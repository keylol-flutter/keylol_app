import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/screen/thread/bloc/thread_bloc.dart';
import 'package:keylol_flutter/screen/thread/widgets/post_item.dart';
import 'package:keylol_flutter/screen/thread/widgets/thread_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThreadView extends StatefulWidget {
  const ThreadView({super.key});

  @override
  State<StatefulWidget> createState() => _ThreadViewState();
}

class _ThreadViewState extends State<ThreadView> {
  final _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(() {
      final maxScroll = _controller.position.maxScrollExtent;
      final pixels = _controller.position.pixels;

      if (maxScroll == pixels) {
        context.read<ThreadBloc>().add(ThreadFetched());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThreadBloc, ThreadState>(
      listener: (context, state) {
        if (state.status == ThreadStatus.failure) {
          final message =
              state.message ?? AppLocalizations.of(context)!.networkError;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final thread = state.thread;
        if (thread == null) {
          return Scaffold(
            appBar: AppBar(),
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<ThreadBloc>().add(const ThreadRefreshed());
              },
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final firstPost = state.firstPost;
        final posts = state.posts;
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<ThreadBloc>().add(const ThreadRefreshed());
            },
            child: NestedScrollView(
              controller: _controller,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: ThreadAppBar(
                      title: thread.subject,
                      textStyle: Theme.of(context).textTheme.titleLarge!,
                      width: MediaQuery.of(context).size.width,
                      topPadding: MediaQuery.of(context).padding.top,
                    ),
                  ),
                ];
              },
              body: CustomScrollView(
                slivers: [
                  if (firstPost != null)
                    SliverToBoxAdapter(
                      child: PostItem(
                        post: firstPost,
                        showFloor: false,
                      ),
                    ),
                  if (posts.isNotEmpty)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == posts.length) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Opacity(
                                opacity: state.hasReachMax ? 0.0 : 1.0,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                          }

                          final post = posts[index];
                          return PostItem(post: post);
                        },
                        childCount: posts.length + 1,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Size boundingTextSize(String text, TextStyle style,
    {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
  final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: text, style: style),
      maxLines: maxLines)
    ..layout(maxWidth: maxWidth);
  return textPainter.size;
}
