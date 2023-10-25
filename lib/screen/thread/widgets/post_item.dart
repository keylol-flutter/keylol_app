import 'package:discuz_widgets/discuz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/screen/thread/bloc/thread_bloc.dart';
import 'package:keylol_flutter/screen/thread/widgets/poll.dart';
import 'package:keylol_flutter/widgets/avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostItem extends StatelessWidget {
  final Post post;
  final SpecialPoll? poll;

  final bool showFloor;
  final double elevation;

  const PostItem({
    super.key,
    required this.post,
    this.poll,
    this.showFloor = true,
    this.elevation = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        elevation: elevation,
        child: Column(
          children: [
            ListTile(
              leading: Avatar(
                uid: post.authorId,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(post.author),
                  if (showFloor)
                    Text(
                      '${post.position}${AppLocalizations.of(context)!.threadPageFloor}',
                    ),
                ],
              ),
              subtitle: Text(post.dateline),
            ),
            Discuz(data: post.message, isPost: showFloor),
            if (poll != null)
              Poll(
                tid: post.tid,
                poll: poll!,
                callback: (context) {
                  context.read<ThreadBloc>().add(const ThreadRefreshed());
                },
              )
          ],
        ),
      ),
    );
  }
}
