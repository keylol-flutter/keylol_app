import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/screen/space/bloc/space_bloc.dart';
import 'package:keylol_flutter/screen/space/widgets/label.dart';
import 'package:keylol_flutter/widgets/avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';

class SpaceView extends StatefulWidget {
  const SpaceView({super.key});

  @override
  State<StatefulWidget> createState() => _SpaceState();
}

class _SpaceState extends State<SpaceView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpaceBloc, SpaceState>(
      listener: (context, state) {
        if (state.status == SpaceStatus.failure) {
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
        final profile = state.profile;
        if (profile == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final space = profile.space;
        return Scaffold(
          appBar: AppBar(),
          body: ListView(
            padding: const EdgeInsets.only(left: 16, right: 16),
            physics: const ClampingScrollPhysics(),
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Avatar(
                  uid: space.uid,
                  username: space.username,
                  width: 56,
                  height: 56,
                ),
                title: Text(space.username),
                subtitle: Text('ID: ${space.uid}'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Label(
                      label: AppLocalizations.of(context)!.spacePageFriends,
                      value: '${space.friends}',
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/space/friends',
                        arguments: {
                          'uid': space.uid,
                        },
                      );
                    },
                  ),
                  const VerticalDivider(),
                  InkWell(
                    child: Label(
                      label: AppLocalizations.of(context)!.spacePageThreads,
                      value: '${space.threads}',
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/space/threads',
                        arguments: {
                          'uid': space.uid,
                        },
                      );
                    },
                  ),
                  const VerticalDivider(),
                  InkWell(
                    child: Label(
                      label: AppLocalizations.of(context)!.spacePagePosts,
                      value: '${space.posts}',
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/space/posts',
                        arguments: {
                          'uid': space.uid,
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (space.signHtml.isNotEmpty)
                Text(AppLocalizations.of(context)!.spacePageSign),
              if (space.signHtml.isNotEmpty) const SizedBox(height: 8),
              if (space.signHtml.isNotEmpty)
                Html(
                  data: space.signHtml,
                  style: {
                    'body': Style(
                      margin: Margins.all(0),
                      padding: HtmlPaddings.all(0),
                    )
                  },
                ),
              if (space.signHtml.isNotEmpty) const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton(
                  showSelectedIcon: false,
                  selected: {_currentIndex},
                  onSelectionChanged: (set) {
                    setState(() {
                      _currentIndex = set.first;
                    });
                  },
                  segments: [
                    ButtonSegment(
                      value: 0,
                      label: Text(
                        AppLocalizations.of(context)!.spacePageMedals,
                      ),
                    ),
                    ButtonSegment(
                      value: 1,
                      label: Text(
                        AppLocalizations.of(context)!.spacePageActivity,
                      ),
                    ),
                    ButtonSegment(
                      value: 2,
                      label: Text(
                        AppLocalizations.of(context)!.spacePageStatistics,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildData(space),
            ],
          ),
        );
      },
    );
  }

  Widget _buildData(Space space) {
    switch (_currentIndex) {
      case 0:
        return _buildMedals(space);
      case 1:
        return _buildActivity(space);
      case 2:
        return _buildStatistics(space);
    }
    return Container();
  }

  // 勋章
  Widget _buildMedals(Space space) {
    final medals = space.medals;

    if (medals.isEmpty) {
      return Container();
    }

    return Column(
      children: medals.map(
        (medal) {
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
      ).toList(),
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
