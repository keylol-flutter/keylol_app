import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/bloc/bloc/authentication_bloc.dart';
import 'package:keylol_flutter/repository/authentication_repository.dart';
import 'package:keylol_flutter/screen/index/bloc/index_bloc.dart';
import 'package:keylol_flutter/screen/index/widgets/carousel.dart';
import 'package:keylol_flutter/screen/index/widgets/index_search_button.dart';
import 'package:keylol_flutter/widgets/avatar.dart';
import 'package:keylol_flutter/widgets/thread_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class IndexView extends StatefulWidget {
  const IndexView({super.key});

  @override
  State<StatefulWidget> createState() => _IndexViewState();
}

class _IndexViewState extends State<IndexView> {
  var _index = 0;
  final _controller = PageController();
  final _searchController = SearchController();

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        context.read<IndexBloc>().add(IndexFetched());
      },
      builder: (context, state) {
        late String uid;
        if (state.status == AuthenticationStatus.unauthenticated) {
          uid = '';
        } else {
          uid = state.profile.memberUid;
        }
        return BlocConsumer<IndexBloc, IndexState>(
          listener: (context, state) {
            if (state.status == IndexStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.networkError),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            final index = state.index;
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    title: Text(AppLocalizations.of(context)!.indexPageTitle),
                    actions: [
                      const IndexSearchButton(),
                      Avatar(
                        uid: uid,
                        padding: const EdgeInsets.all(9),
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  ),
                ];
              },
              body: RefreshIndicator(
                onRefresh: () async {
                  context.read<IndexBloc>().add(IndexFetched());
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(child: _buildCarousel(context, index)),
                    SliverToBoxAdapter(child: _buildTab(context, index)),
                    SliverToBoxAdapter(child: _buildPageView(context, index)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 轮播图
  Widget _buildCarousel(BuildContext context, Index? index) {
    final threads = index == null
        ? List.generate(
            1,
            (index) => Thread.fromJson({
              'subject': 'Subject',
              'cover': '',
            }),
          )
        : index.slideViewThreads;
    return Skeletonizer(
      enabled: index == null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
        child: Carousel(
          threads: threads,
        ),
      ),
    );
  }

  void _animateTo(int index) {
    setState(() {
      _index = index;
      _controller.animateToPage(
        _index,
        duration: const Duration(microseconds: 500),
        curve: Curves.linear,
      );
    });
  }

  Widget _buildTabItem(int index, String text) {
    return InkWell(
      onTap: () {
        _animateTo(index);
      },
      child: Text(
        text,
        style: _index == index
            ? Theme.of(context).textTheme.headlineSmall
            : Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }

  Widget _buildTab(BuildContext context, Index? index) {
    final threadMap = index == null
        ? {
            '最新主题': [],
            '最新回复': [],
          }
        : index.tabThreadMap;
    final hasLogin = threadMap.containsKey('最新回复');

    final newThreadsTab = _buildTabItem(0, '最新主题');
    final newRepliesTab = _buildTabItem(1, '最新回复');
    return Skeletonizer(
      enabled: index == null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            newThreadsTab,
            const SizedBox(width: 8.0),
            if (hasLogin) newRepliesTab,
          ],
        ),
      ),
    );
  }

  Widget _buildPageView(BuildContext context, Index? index) {
    final threadMap = index == null
        ? {
            '最新主题': List.generate(
              10,
              (index) => Thread.fromJson({
                'subject': 'Subject',
                'author': 'Author',
                'authorId': '',
                'dateline': DateTime.now().millisecondsSinceEpoch / 1000,
              }),
            ),
            '最新回复': List.generate(
              10,
              (index) => Thread.fromJson({
                'subject': 'Subject',
                'author': 'Author',
                'authorId': '',
                'dateline': DateTime.now().millisecondsSinceEpoch / 1000,
              }),
            ),
          }
        : index.tabThreadMap;
    final newThreads = threadMap['最新主题'];
    final newReplies = threadMap['最新回复'];

    return Skeletonizer(
      enabled: index == null,
      child: PageView.builder(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _index = index;
          });
        },
        itemCount: newReplies == null ? 1 : 2,
        itemBuilder: (context, index) {
          final threads = index == 0 ? newThreads : newReplies;
          return ListView.separated(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: threads!.length,
            itemBuilder: (context, index) {
              return ThreadItem(thread: threads[index]);
            },
            separatorBuilder: (context, index) {
              if (index == threads.length - 1) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.only(left: 16.0 + 56, right: 16.0),
                child: Divider(
                  height: 0,
                  color: Theme.of(context).dividerColor.withOpacity(0.2),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
