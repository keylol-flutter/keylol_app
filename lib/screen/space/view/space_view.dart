import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/screen/space/bloc/space_bloc.dart';
import 'package:keylol_flutter/screen/space/widgets/label.dart';
import 'package:keylol_flutter/widgets/avatar.dart';
import 'package:flutter_html/flutter_html.dart';

class SpaceView extends StatefulWidget {
  const SpaceView({super.key});

  @override
  State<StatefulWidget> createState() => _SpaceState();
}

class _SpaceState extends State<SpaceView> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpaceBloc, SpaceState>(
      listener: (context, state) {},
      builder: (context, state) {
        final profile = state.profile;
        if (profile == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const CircularProgressIndicator(),
          );
        }

        final space = profile.space;
        return Scaffold(
          appBar: AppBar(),
          body: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: Avatar(
                  uid: space.uid,
                  username: space.username,
                  width: 56,
                  height: 56,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Label(label: '好友数', value: '${space.friends}'),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('/space/friend', arguments: space.uid);
                    },
                  ),
                  const VerticalDivider(),
                  InkWell(
                    child: Label(label: '主题数', value: '${space.threads}'),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('/space/thread', arguments: space.uid);
                    },
                  ),
                  const VerticalDivider(),
                  InkWell(
                    child: Label(label: '回复数', value: '${space.threads}'),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('/space/reply', arguments: space.uid);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (space.signHtml.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text('个人签名'),
                ),
              if (space.signHtml.isNotEmpty) const SizedBox(height: 8),
              if (space.signHtml.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Html(
                    data: space.signHtml,
                    style: {
                      'body': Style(
                        margin: Margins.all(0),
                        padding: HtmlPaddings.all(0),
                      )
                    },
                  ),
                ),
              if (space.signHtml.isNotEmpty) const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: SegmentedButton(
                  showSelectedIcon: false,
                  selected: {_currentIndex},
                  onSelectionChanged: (set) {
                    setState(() {
                      _currentIndex = set.first;
                    });
                    _controller.animateToPage(
                      _currentIndex,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear,
                    );
                  },
                  segments: const [
                    ButtonSegment(value: 0, label: Text('勋章')),
                    ButtonSegment(value: 1, label: Text('活跃概况')),
                    ButtonSegment(value: 2, label: Text('统计信息')),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                children: [
                  _buildMedals(space),
                  _buildActivity(space),
                  _buildStatistics(space),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // 勋章
  Widget _buildMedals(Space space) {
    final medals = space.medals;

    if (medals.isEmpty) {
      return Container();
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: medals.length - 1,
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
    );
  }

  // 活跃概况
  Widget _buildActivity(Space space) {
    return ListView(
      shrinkWrap: true,
      children: [
        if (space.group != null)
          Row(
            children: [
              const Text('用户组'),
              if (space.group!.groupTitle.isNotEmpty)
                const SizedBox(width: 8.0),
              if (space.group!.groupTitle.isNotEmpty)
                Text(space.group!.groupTitle),
              if (space.group!.icon.isNotEmpty) const SizedBox(width: 8.0),
              if (space.group!.icon.isNotEmpty)
                CachedNetworkImage(imageUrl: space.group!.icon),
            ],
          ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const Text('在线时间'),
            const SizedBox(width: 8.0),
            Text('${space.olTime}小时'),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const Text('注册时间'),
            const SizedBox(width: 8.0),
            Text(space.regDate),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const Text('最后访问'),
            const SizedBox(width: 8.0),
            Text(space.lastVisit),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const Text('上次活动'),
            const SizedBox(width: 8.0),
            Text(space.lastActivity),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const Text('上次发表'),
            const SizedBox(width: 8.0),
            Text(space.lastPost),
          ],
        ),
      ],
    );
  }

  // 统计信息
  Widget _buildStatistics(Space space) {
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          children: [
            const Text('已用空间'),
            const SizedBox(width: 8.0),
            Text(space.attachSize.trim())
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const Text('积分'),
            const SizedBox(width: 8.0),
            Text('${space.credits}'),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const Text('体力'),
            const SizedBox(width: 8.0),
            Text('${space.extCredits1}点'),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const Text('蒸汽'),
            const SizedBox(width: 8.0),
            Text('${space.extCredits3}克'),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const Text('动力'),
            const SizedBox(width: 8.0),
            Text('${space.extCredits4}点'),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const Text('绿意'),
            const SizedBox(width: 8.0),
            Text('${space.extCredits6}'),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const Text('可用改名次数'),
            const SizedBox(width: 8.0),
            Text('${space.extCredits8}'),
          ],
        ),
      ],
    );
  }
}
