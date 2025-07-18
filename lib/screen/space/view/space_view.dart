import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/screen/space/bloc/space_bloc.dart';
import 'package:keylol_flutter/screen/space/widgets/label.dart';
import 'package:keylol_flutter/utils/ui_utils.dart';
import 'package:keylol_flutter/widgets/avatar.dart';
import 'package:keylol_flutter/l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';

class SpaceView extends StatefulWidget {
  const SpaceView({super.key});

  @override
  State<StatefulWidget> createState() => _SpaceState();
}

class _SpaceState extends State<SpaceView> with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpaceBloc, SpaceState>(
      listener: (context, state) {
        if (state.status == SpaceStatus.failure) {
          final message =
              state.message ?? AppLocalizations.of(context)!.networkError;
          showFloatingSnackBar(context, message);
        }
      },
      builder: (context, state) {
        final profile = state.profile;
        if (profile == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final space = profile.space;
        return Scaffold(
          body: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              const SliverAppBar(
                pinned: true,
              ),
              SliverToBoxAdapter(
                child: _buildUserInfo(space),
              ),
              SliverToBoxAdapter(
                child: _buildSign(space),
              ),
              SliverToBoxAdapter(
                child: _buildDataTab(),
              ),
              SliverFillRemaining(
                child: _buildDataView(space),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserInfo(Space space) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          leading: Avatar(
            uid: space.uid,
            username: space.username,
            width: 56,
            height: 56,
          ),
          title: Text(space.username),
          subtitle: Text('ID: ${space.uid}'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Label(
                label: AppLocalizations.of(context)!.spacePageFriends,
                value: '${space.friends}',
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/space/friends',
                    arguments: {
                      'uid': space.uid,
                    },
                  );
                },
              ),
            ),
            const VerticalDivider(thickness: 4, color: Colors.black),
            Expanded(
              child: Label(
                label: AppLocalizations.of(context)!.spacePageThreads,
                value: '${space.threads}',
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/space/threads',
                    arguments: {
                      'uid': space.uid,
                    },
                  );
                },
              ),
            ),
            const VerticalDivider(thickness: 4, color: Colors.black),
            Expanded(
              child: Label(
                label: AppLocalizations.of(context)!.spacePagePosts,
                value: '${space.posts}',
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/space/posts',
                    arguments: {
                      'uid': space.uid,
                    },
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSign(Space space) {
    if (space.signHtml.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.spacePageSign),
            const SizedBox(height: 8),
            Html(
              shrinkWrap: true,
              data: space.signHtml,
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  TabBar _buildDataTab() {
    return TabBar(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      controller: _controller,
      tabs: [
        Tab(text: AppLocalizations.of(context)!.spacePageMedals),
        Tab(text: AppLocalizations.of(context)!.spacePageActivity),
        Tab(text: AppLocalizations.of(context)!.spacePageStatistics),
      ],
    );
  }

  Widget _buildDataView(Space space) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TabBarView(
        controller: _controller,
        children: [
          _buildMedals(space),
          _buildActivity(space),
          _buildStatistics(space),
        ],
      ),
    );
  }

  // 勋章
  Widget _buildMedals(Space space) {
    final medals = space.medals;
    return ListView.separated(
      padding: const EdgeInsets.all(0),
      itemCount: medals.length,
      itemBuilder: (context, index) {
        final medal = medals[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(medal.name),
            Text(medal.description),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  height: 30.0,
                  imageUrl:
                      'https://keylol.com/static/image/common/${medal.image}',
                ),
              ],
            ),
          ],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }

  // 活跃概况
  Widget _buildActivity(Space space) {
    return Column(
      children: [
        if (space.group != null)
          Row(
            children: [
              Text(AppLocalizations.of(context)!.spacePageActivityGroup),
              if (space.group!.groupTitle.isNotEmpty)
                const SizedBox(width: 8.0),
              if (space.group!.groupTitle.isNotEmpty)
                Expanded(
                  child: Html(
                    data: space.group!.groupTitle,
                  ),
                ),
              if (space.group!.icon.isNotEmpty) const SizedBox(width: 8.0),
              if (space.group!.icon.isNotEmpty)
                Expanded(
                  child: Html(
                    data: space.group!.icon,
                  ),
                ),
            ],
          ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text(AppLocalizations.of(context)!.spacePageActivityOnlineTime),
            const SizedBox(width: 8.0),
            Text(
              '${space.olTime}${AppLocalizations.of(context)!.spacePageActivityOnlineTimeUnit}',
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text(AppLocalizations.of(context)!.spacePageActivityRegDate),
            const SizedBox(width: 8.0),
            Text(space.regDate),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text(AppLocalizations.of(context)!.spacePageActivityLastVisit),
            const SizedBox(width: 8.0),
            Text(space.lastVisit),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text(AppLocalizations.of(context)!.spacePageActivityLastActivity),
            const SizedBox(width: 8.0),
            Text(space.lastActivity),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text(AppLocalizations.of(context)!.spacePageActivityLastPost),
            const SizedBox(width: 8.0),
            Text(space.lastPost),
          ],
        ),
      ],
    );
  }

  // 统计信息
  Widget _buildStatistics(Space space) {
    return Column(
      children: [
        Row(
          children: [
            Text(AppLocalizations.of(context)!.spacePageStatisticsAttachSize),
            const SizedBox(width: 8.0),
            Text(space.attachSize.trim())
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text(AppLocalizations.of(context)!.spacePageStatisticsCredits),
            const SizedBox(width: 8.0),
            Text('${space.credits}'),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text(AppLocalizations.of(context)!.spacePageStatisticsCredits1),
            const SizedBox(width: 8.0),
            Text(
              '${space.extCredits1}${AppLocalizations.of(context)!.spacePageStatisticsCredits1Unit}',
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text(AppLocalizations.of(context)!.spacePageStatisticsCredits3),
            const SizedBox(width: 8.0),
            Text(
              '${space.extCredits3}${AppLocalizations.of(context)!.spacePageStatisticsCredits3Unit}',
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text(AppLocalizations.of(context)!.spacePageStatisticsCredits4),
            const SizedBox(width: 8.0),
            Text(
              '${space.extCredits4}${AppLocalizations.of(context)!.spacePageStatisticsCredits4Unit}',
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text(AppLocalizations.of(context)!.spacePageStatisticsCredits6),
            const SizedBox(width: 8.0),
            Text('${space.extCredits6}'),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text(AppLocalizations.of(context)!.spacePageStatisticsCredits8),
            const SizedBox(width: 8.0),
            Text('${space.extCredits8}'),
          ],
        ),
      ],
    );
  }
}
