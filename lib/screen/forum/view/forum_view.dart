import 'package:discuz_widgets/discuz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:keylol_flutter/config/router.dart';
import 'package:keylol_flutter/screen/forum/bloc/forum_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:keylol_flutter/widgets/load_more_list_view.dart';
import 'package:keylol_flutter/widgets/thread_item.dart';

class ForumView extends StatefulWidget {
  const ForumView({super.key});

  @override
  State<StatefulWidget> createState() => _ForumState();
}

class _ForumState extends State<ForumView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {},
      builder: (context, state) {
        return BlocConsumer<ForumBloc, ForumState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.forum == null) {
              return Scaffold(
                appBar: AppBar(),
                body: RefreshIndicator(
                  onRefresh: () async {
                    context.read<ForumBloc>().add(const ForumRefreshed());
                  },
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            final forum = state.forum!;
            final threadTypes = state.threadTypes;
            return DefaultTabController(
              length: threadTypes.length + 1,
              child: Scaffold(
                appBar: AppBar(
                  title: Hero(
                    tag: forum.fid,
                    child: Text(forum.name),
                  ),
                  bottom: _buildTabBar(threadTypes),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () async {
                        _showDetailDialog(context, state);
                      },
                    ),
                  ],
                ),
                body: TabBarView(
                  children: [
                    _buildTabView(forum.fid, null),
                    for (final threadType in threadTypes)
                      _buildTabView(forum.fid, threadType.type),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  PreferredSizeWidget? _buildTabBar(List<ThreadType> threadTypes) {
    if (threadTypes.isEmpty) {
      return null;
    }

    return TabBar(
      isScrollable: true,
      tabs: [
        Tab(text: AppLocalizations.of(context)!.forumPageTabAll),
        for (final threadType in threadTypes) Tab(text: threadType.name),
      ],
    );
  }

  void _showDetailDialog(BuildContext context, ForumState state) {
    final forum = state.forum!;
    final subForums = state.subForums;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: Hero(
                tag: forum.fid,
                child: Text(forum.name),
              ),
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.only(left: 16, right: 16),
              children: [
                Discuz(
                  data: forum.rules,
                  onLinkTap: (url, attributes, element) {
                    if (url != null) {
                      urlRoute(context, url);
                    }
                  },
                ),
                if (subForums.isNotEmpty) const Divider(),
                Wrap(spacing: 8.0, children: [
                  ...subForums.map((subForum) {
                    return ElevatedButton(
                      child: Text(subForum.name),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/forum',
                          arguments: {'fid': subForum.fid},
                        );
                      },
                    );
                  }).toList(),
                ])
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilter(BuildContext context, ForumState state) {
    final controller = MenuController();
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ChoiceChip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    showCheckmark: false,
                    label: Text(
                        AppLocalizations.of(context)!.forumPageFilterHeats),
                    selected: state.filter == 'heats',
                    onSelected: (selected) {
                      context.read<TypeForumBloc>().add(ForumRefreshed(
                            type: state.type,
                            filter: selected ? 'heats' : null,
                            orderBy: selected ? 'heats' : null,
                          ));
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    showCheckmark: false,
                    label:
                        Text(AppLocalizations.of(context)!.forumPageFilterHot),
                    selected: state.filter == 'hot',
                    onSelected: (selected) {
                      context.read<TypeForumBloc>().add(ForumRefreshed(
                            type: state.type,
                            filter: selected ? 'hot' : null,
                          ));
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    showCheckmark: false,
                    label: Text(
                        AppLocalizations.of(context)!.forumPageFilterDigest),
                    selected: state.filter == 'digest',
                    onSelected: (selected) {
                      context.read<TypeForumBloc>().add(ForumRefreshed(
                            type: state.type,
                            filter: selected ? 'digest' : null,
                            params: selected ? {'digest': '1'} : null,
                          ));
                    },
                  ),
                ],
              ),
            ),
          ),
          MenuAnchor(
            controller: controller,
            menuChildren: [
              MenuItemButton(
                child: Text(AppLocalizations.of(context)!.forumPageOrderByNull),
                onPressed: () {
                  context.read<TypeForumBloc>().add(ForumRefreshed(
                        type: state.type,
                        filter: state.filter,
                        params: state.params,
                      ));
                },
              ),
              MenuItemButton(
                child: Text(
                    AppLocalizations.of(context)!.forumPageOrderByDateline),
                onPressed: () {
                  context.read<TypeForumBloc>().add(ForumRefreshed(
                        type: state.type,
                        filter: state.filter,
                        params: state.params,
                        orderBy: 'dateline',
                      ));
                },
              ),
              MenuItemButton(
                child:
                    Text(AppLocalizations.of(context)!.forumPageOrderByReplies),
                onPressed: () {
                  context.read<TypeForumBloc>().add(ForumRefreshed(
                        type: state.type,
                        filter: state.filter,
                        params: state.params,
                        orderBy: 'replies',
                      ));
                },
              ),
              MenuItemButton(
                child:
                    Text(AppLocalizations.of(context)!.forumPageOrderByViews),
                onPressed: () {
                  context.read<TypeForumBloc>().add(ForumRefreshed(
                        type: state.type,
                        filter: state.filter,
                        params: state.params,
                        orderBy: 'views',
                      ));
                },
              ),
            ],
            child: TextButton.icon(
              onPressed: () {
                controller.open();
              },
              icon: const Icon(Icons.sort),
              label: Text(_orderByText(state.orderBy)),
            ),
          ),
        ],
      ),
    );
  }

  String _orderByText(String? orderBy) {
    switch (orderBy) {
      case 'dateline':
        return AppLocalizations.of(context)!.forumPageOrderByDateline;
      case 'replies':
        return AppLocalizations.of(context)!.forumPageOrderByReplies;
      case 'views':
        return AppLocalizations.of(context)!.forumPageOrderByViews;
    }
    return AppLocalizations.of(context)!.forumPageOrderByNull;
  }

  Widget _buildTabView(String fid, String? type) {
    return BlocProvider(
      create: (_) => TypeForumBloc(context.read<Keylol>(), fid)
        ..add(ForumRefreshed(type: type)),
      child: BlocConsumer<TypeForumBloc, ForumState>(
        listener: (context, state) {
          if (state.status == ForumStatus.failure) {
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
          final threads = state.threads;
          return RefreshIndicator(
            onRefresh: () async {
              context.read<TypeForumBloc>().add(ForumRefreshed(
                    type: type,
                    filter: state.filter,
                    params: state.params,
                    orderBy: state.orderBy,
                  ));
            },
            child: LoadMoreListView(
              callback: () {
                context.read<TypeForumBloc>().add(ForumFetched());
              },
              itemCount: threads.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildFilter(context, state);
                }
                index = index - 1;
                if (index == threads.length) {
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

                final thread = threads[index];
                ThreadWrapperBuilder? builder;
                if (thread.displayOrder == 1) {
                  builder = (child) {
                    return ClipRect(
                        child: Banner(
                            location: BannerLocation.topStart,
                            message: AppLocalizations.of(context)!
                                .forumPageThreadWrapper3,
                            color: const Color(0xFF81C784),
                            child: child));
                  };
                } else if (thread.displayOrder == 3) {
                  builder = (child) {
                    return ClipRect(
                        child: Banner(
                            location: BannerLocation.topStart,
                            message: AppLocalizations.of(context)!
                                .forumPageThreadWrapper3,
                            color: const Color(0xFFFFD54F),
                            child: child));
                  };
                }

                return ThreadItem(thread: thread, wrapperBuilder: builder);
              },
              separatorBuilder: (context, index) {
                if (index == 0) {
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
            ),
          );
        },
      ),
    );
  }
}
