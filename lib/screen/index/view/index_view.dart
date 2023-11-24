import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/bloc/bloc/authentication_bloc.dart';
import 'package:keylol_flutter/repository/authentication_repository.dart';
import 'package:keylol_flutter/screen/index/bloc/index_bloc.dart';
import 'package:keylol_flutter/screen/index/bloc/search_bloc.dart';
import 'package:keylol_flutter/screen/index/widgets/carousel.dart';
import 'package:keylol_flutter/screen/index/widgets/index_search_bar.dart';
import 'package:keylol_flutter/widgets/avatar.dart';
import 'package:keylol_flutter/widgets/thread_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IndexView extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const IndexView({super.key, required this.scaffoldKey});

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
            return RefreshIndicator(
              notificationPredicate: (notification) {
                return notification.depth == 2;
              },
              onRefresh: () async {
                context.read<IndexBloc>().add(IndexFetched());
              },
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      title: IndexSearchBar(
                        leading: IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            widget.scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                        trailing: [
                          Avatar(
                            uid: uid,
                            padding: const EdgeInsets.all(9),
                          ),
                          const SizedBox(width: 8.0),
                        ],
                      ),
                    ),
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

  Widget _buildSearchBar(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state.status == SearchStatus.done) {
          if (!_searchController.isOpen) {
            _searchController.openView();
          }
        } else if (state.status == SearchStatus.success) {
          context.read<SearchBloc>().add(SearchResultsDone());
        }
      },
      builder: (context, state) {
        return SearchAnchor(
          searchController: _searchController,
          builder: (context, controller) {
            final focusNode = FocusNode(
              onKeyEvent: (node, event) {
                if (event.logicalKey == LogicalKeyboardKey.enter) {
                  final text = controller.text;
                  if (text.isEmpty) {
                    return KeyEventResult.ignored;
                  }
                  context.read<SearchBloc>()
                    ..add(SearchResultsFetching())
                    ..add(SearchResultsFetched(text));
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
            );
            return SearchBar(
              focusNode: focusNode,
              controller: _searchController,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () async {
                  Scaffold.of(context).openDrawer();
                },
              ),
              trailing: [
                if (state.status == SearchStatus.searching)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  ),
                const Avatar(
                  uid: '',
                  padding: EdgeInsets.all(9),
                ),
              ],
            );
          },
          suggestionsBuilder: (_, controller) {
            final results = context.read<SearchBloc>().state.results;
            return List.generate(
              results.length,
              (index) {
                final result = results[index];
                return ListTile(
                  title: Text(result['title']),
                  onTap: () async {
                    // TODO
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  /// 轮播图
  Widget _buildCarousel(BuildContext context, Index? index) {
    if (index == null) {
      return Container();
    }

    final threads = index.slideViewThreads;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Carousel(
        threads: threads,
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
    if (index == null) {
      return Container();
    }

    final threadMap = index.tabThreadMap;
    final hasLogin = threadMap.containsKey('最新回复');

    final newThreadsTab = _buildTabItem(0, '最新主题');
    final newRepliesTab = _buildTabItem(1, '最新回复');
    return Padding(
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
    );
  }

  Widget _buildPageView(BuildContext context, Index? index) {
    if (index == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final threadMap = index.tabThreadMap;
    final newThreads = threadMap['最新主题'];
    final newReplies = threadMap['最新回复'];

    return PageView.builder(
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
    );
  }
}
