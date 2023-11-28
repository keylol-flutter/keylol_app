import 'package:discuz_widgets/discuz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/config/router.dart';
import 'package:keylol_flutter/screen/thread/bloc/thread_bloc.dart';
import 'package:keylol_flutter/screen/thread/widgets/poll.dart';
import 'package:keylol_flutter/screen/thread/widgets/reply_modal.dart';
import 'package:keylol_flutter/widgets/avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:html/dom.dart' as html;

typedef ScrollToFunction = void Function(String pid);

class PostItem extends StatelessWidget {
  final Thread thread;
  final Post post;
  final List<Comment> comments;
  final SpecialPoll? poll;

  final bool showFloor;
  final ScrollToFunction? scrollTo;
  final double elevation;

  const PostItem({
    super.key,
    required this.thread,
    required this.post,
    this.comments = const [],
    this.poll,
    this.showFloor = true,
    this.scrollTo,
    this.elevation = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  : const EdgeInsets.only(left: 16, right: 16),
              child: Discuz(
                data: post.message,
                isPost: showFloor,
                nested: true,
                onLinkTap: (url, attributes, element) async {
                  await _onLinkTap(context, url, attributes, element);
                },
              ),
            ),
            if (post.attachments != null && post.attachments!.isNotEmpty)
              for (final attachment in post.attachments!.values)
                Padding(
                  padding: showFloor
                      ? const EdgeInsets.only(left: 48 + 16, right: 16)
                      : const EdgeInsets.only(left: 16, right: 16),
                  child: Image.network(
                      '${attachment.url}${attachment.attachment}'),
                ),
            if (poll != null)
              Poll(
                tid: post.tid,
                poll: poll!,
                callback: (context) {
                  context.read<ThreadBloc>().add(const ThreadRefreshed());
                },
              ),
            if (comments.isNotEmpty)
              Padding(
                padding: showFloor
                    ? const EdgeInsets.only(
                        left: 48 + 16,
                        right: 16,
                        top: 8,
                        bottom: 8,
                      )
                    : const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 8,
                        bottom: 8,
                      ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent.withOpacity(0.1),
                    border: Border.all(
                        color: Colors.deepOrangeAccent.withOpacity(0.1)),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle_outlined,
                        size: 12,
                        color: Colors.deepOrangeAccent.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.threadPageComment,
                        style: TextStyle(
                          color: Colors.deepOrangeAccent.withOpacity(0.6),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            for (final comment in comments)
              Padding(
                padding: showFloor
                    ? const EdgeInsets.only(left: 48 + 16, right: 16)
                    : const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Avatar(
                        uid: comment.authorId,
                        username: comment.author,
                        width: showFloor ? 32 : 40,
                        height: showFloor ? 32 : 40,
                      ),
                      title: Text(comment.author),
                      subtitle: Text(comment.dateline),
                    ),
                    Discuz(data: comment.comment, nested: true),
                  ],
                ),
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
            if (!showFloor) const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _onLinkTap(
    BuildContext context,
    String? url,
    Map<String, String> attributes,
    html.Element? element,
  ) async {
    if (url == null) {
      return;
    }
    final subUrl = url.replaceFirst('https://keylol.com/', '');
    if (subUrl.contains('findpost')) {
      // 帖子内楼层跳转
      final params = url.split('?')[1].split('&');
      late String pid;
      for (var param in params) {
        if (param.startsWith('pid=')) {
          pid = param.replaceAll('pid=', '');
          break;
        }
      }
      if (scrollTo != null) {
        scrollTo!.call(pid);
        return;
      }
    }

    await urlRoute(context, url);
  }
}
