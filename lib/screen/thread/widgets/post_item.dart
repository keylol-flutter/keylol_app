import 'package:discuz_widgets/discuz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/screen/thread/bloc/thread_bloc.dart';
import 'package:keylol_flutter/screen/thread/widgets/poll.dart';
import 'package:keylol_flutter/screen/thread/widgets/reply_modal.dart';
import 'package:keylol_flutter/widgets/avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostItem extends StatelessWidget {
  final Thread thread;
  final Post post;
  final SpecialPoll? poll;

  final bool showFloor;
  final double elevation;

  const PostItem({
    super.key,
    required this.thread,
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
        elevation: 0,
        child: Column(
          children: [
            ListTile(
              leading: Avatar(
                uid: post.authorId,
                username: post.author,
                width: showFloor ? 32 : 40,
                height: showFloor ? 32 : 40,
              ),
              title: Text(post.author),
              subtitle: Text(
                  '${post.dateline} • ${post.position}${AppLocalizations.of(context)!.threadPageFloor}'),
            ),
            Padding(
              padding: showFloor
                  ? const EdgeInsets.only(left: 48 + 16, right: 16)
                  : EdgeInsets.zero,
              child: Discuz(
                data: post.message,
                isPost: showFloor,
                nested: showFloor,
              ),
            ),
            if (poll != null)
              Poll(
                tid: post.tid,
                poll: poll!,
                callback: (context) {
                  context.read<ThreadBloc>().add(const ThreadRefreshed());
                },
              ),
            if (showFloor)
              Row(
                children: [
                  const SizedBox(width: 48 + 6),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        ReplyRoute(context.read<ThreadBloc>(), thread, post),
                      );
                    },
                    icon: const Icon(Icons.reply),
                  ),
                ],
              ),
            Padding(
              padding: showFloor
                  ? const EdgeInsets.only(left: 48 + 16, right: 16)
                  : EdgeInsets.zero,
              child: Divider(
                height: 0,
                color: Theme.of(context).dividerColor.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
