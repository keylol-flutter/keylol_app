import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/screen/thread/bloc/thread_bloc.dart';
import 'package:keylol_flutter/screen/thread/widgets/post_item.dart';
import 'package:keylol_flutter/screen/thread/widgets/reply_modal.dart';
import 'package:keylol_flutter/screen/thread/widgets/thread_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ThreadView extends StatefulWidget {
  const ThreadView({super.key});

  @override
  State<StatefulWidget> createState() => _ThreadViewState();
}

class _ThreadViewState extends State<ThreadView> {
  final _controller = AutoScrollController();

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

        if (state.pid != null) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            _scrollTo(state.pid!);
          });
        }

        final firstPost = state.firstPost;
        final posts = state.posts;
        final poll = state.poll;
        return Scaffold(
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  ReplyRoute(context.read<ThreadBloc>(), state.thread, null),
                );
              }),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<ThreadBloc>().add(const ThreadRefreshed());
            },
            child: CustomScrollView(
              controller: _controller,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: ThreadAppBar(
                    tid: thread.tid,
                    title: thread.subject,
                    textStyle: Theme.of(context).textTheme.titleLarge!,
                    width: MediaQuery.of(context).size.width,
                    topPadding: MediaQuery.of(context).padding.top,
                  ),
                ),
                if (firstPost != null)
                  SliverToBoxAdapter(
                    child: PostItem(
                      thread: thread,
                      post: firstPost,
                      poll: poll,
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
                        return AutoScrollTag(
                          key: Key(post.pid),
                          controller: _controller,
                          index: index,
                          child: PostItem(
                            thread: thread,
                            post: post,
                            scrollTo: _scrollTo,
                          ),
                        );
                      },
                      childCount: posts.length + 1,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _scrollTo(String pid) {
    final state = context.read<ThreadBloc>().state;
    final posts = state.posts;
    int index = 0;
    for (final post in posts) {
      if (post.pid == pid) {
        break;
      }
      index++;
    }

    _controller.scrollToIndex(index - 1);
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
