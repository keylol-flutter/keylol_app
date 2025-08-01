import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:keylol_flutter/repository/authentication_repository.dart';
import 'package:keylol_flutter/screen/index/bloc/index_bloc.dart';
import 'package:keylol_flutter/screen/index/widgets/carousel.dart';
import 'package:keylol_flutter/screen/index/widgets/index_search_button.dart';
import 'package:keylol_flutter/utils/ui_utils.dart';
import 'package:keylol_flutter/widgets/avatar.dart';
import 'package:keylol_flutter/widgets/thread_item.dart';
import 'package:keylol_flutter/l10n/app_localizations.dart';
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
        final uid = _getUid(state);

        return BlocConsumer<IndexBloc, IndexState>(
          listener: (context, state) {
            if (state.status == IndexStatus.failure) {
              showFloatingSnackBar(
                context,
                AppLocalizations.of(context)!.networkError,
              );
            }
          },
          builder: (context, state) {
            final index = state.index;
            return RefreshIndicator(
              edgeOffset: kToolbarHeight + MediaQuery.of(context).padding.top,
              notificationPredicate: (notification) {
                return notification.depth == 2;
              },
              onRefresh: () async {
                context.read<IndexBloc>().add(IndexFetched());
              },
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    _buildAppbar(context, uid),
                    SliverToBoxAdapter(child: _buildCarousel(context, index)),
                    SliverToBoxAdapter(child: _buildTab(context, index)),
                  ];
                },
                body: _buildPageView(context, index),
              ),
            );
          },
        );
      },
    );
  }

  String _getUid(AuthenticationState state) {
    if (state.status == AuthenticationStatus.unauthenticated) {
      return '';
    } else {
      return state.profile.memberUid;
    }
  }

  Widget _buildAppbar(BuildContext context, String uid) {
    return SliverAppBar(
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
    );
  }

  /// 轮播图
  Widget _buildCarousel(BuildContext context, Index? index) {
    final threads = index == null
        ? List.generate(
            1,
            (index) => Thread.fromJson({
              'subject': 'Subject' * 4,
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
                'subject': 'Subject' * 4,
                'author': 'Author',
                'authorid': '0',
                'dateline': '1970-01-01',
              }),
            ),
            '最新回复': List.generate(
              10,
              (index) => Thread.fromJson({
                'subject': 'Subject' * 4,
                'author': 'Author',
                'authorid': '0',
                'dateline': '1970-01-01',
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
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
