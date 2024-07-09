import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/repository/history_repository.dart';
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
          final thread = state.thread;
          if (message.contains('电脑版') && thread != null) {
            Navigator.of(context).pushReplacementNamed(
              '/thread',
              arguments: {
                'tid': thread.tid,
                'thread': thread,
                'desktop': true,
              },
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
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
        context.read<HistoryRepository>().insertHistory(thread);

        if (state.pid != null) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            _scrollTo(context, state.pid!);
          });
        }

        final firstPost = state.firstPost;
        final posts = state.posts;
        final comments = state.comments;
        final poll = state.poll;
        final appBar = ThreadAppBar(
          tid: thread.tid,
          title: thread.subject,
          favored: state.favored ?? false,
          textStyle: Theme.of(context).textTheme.titleLarge!,
          width: MediaQuery.of(context).size.width,
          topPadding: MediaQuery.of(context).padding.top,
        );
        return Scaffold(
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  ReplyRoute(context.read<ThreadBloc>(), state.thread, null),
                );
              }),
          body: RefreshIndicator(
            edgeOffset: appBar.maxExtent,
            onRefresh: () async {
              context.read<ThreadBloc>().add(const ThreadRefreshed());
            },
            child: CustomScrollView(
              controller: _controller,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: appBar,
                ),
                if (firstPost != null)
                  SliverToBoxAdapter(
                    child: PostItem(
                      thread: thread,
                      post: firstPost,
                      comments: comments[firstPost.pid] ?? [],
                      poll: poll,
                      showFloor: false,
                    ),
                  ),
                if (firstPost != null)
                  SliverToBoxAdapter(
                    child: Divider(
                      color: Theme.of(context).dividerColor.withOpacity(0.2),
                    ),
                  ),
                if (posts.isNotEmpty)
                  SliverList.separated(
                    itemCount: posts.length + 1,
                    itemBuilder: (context, index) {
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
                          comments: comments[post.pid] ?? [],
                          scrollTo: (pid) => _scrollTo(context, pid),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      if (index == posts.length) {
                        return Container();
                      }
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 48 + 16, right: 16),
                        child: Divider(
                          height: 0,
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.2),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _scrollTo(BuildContext context, String pid) {
    final state = context.read<ThreadBloc>().state;
    final posts = state.posts;
    int index = 0;
    for (final post in posts) {
      if (post.pid == pid) {
        break;
      }
      index++;
    }

    _controller.scrollToIndex(index);
  }
}
