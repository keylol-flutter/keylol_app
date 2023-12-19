import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/widgets/avatar.dart';

class NoticeItem extends StatefulWidget {
  final Note notice;

  const NoticeItem({super.key, required this.notice});

  @override
  State<StatefulWidget> createState() => _NoticeItemState();
}

class _NoticeItemState extends State<NoticeItem> {
  late String dateStr;
  late String note;
  late String pushName;
  late Map<String, dynamic> routeParams;

  @override
  void initState() {
    final date =
        DateTime.fromMillisecondsSinceEpoch(widget.notice.dateline * 1000);
    dateStr = formatDate(date, [yyyy, '-', mm, '-', dd]);

    if (widget.notice.noteVar != null) {
      final noticeVar = widget.notice.noteVar!;
      pushName = '/thread';
      routeParams = {
        'tid': noticeVar.tid,
        'pid': noticeVar.pid,
      };
    }

    /// 评分
    if (widget.notice.fromIdType == 'rate') {
      final regExp = RegExp(r'pid=(\d+)&ptid=(\d+)');
      final match = regExp.firstMatch(widget.notice.note);
      final pid = match?[1];
      final tid = match?[2];
      pushName = '/thread';
      routeParams = {
        'tid': tid,
        'pid': pid,
      };
    }

    if (widget.notice.fromIdType.startsWith('moderate') ||
        widget.notice.type == 'reward') {
      final regExp = RegExp(r'tid=(\d+)');
      final match = regExp.firstMatch(widget.notice.note);
      final tid = match?[1];
      pushName = '/thread';
      routeParams = {
        'tid': tid,
      };
    }

    note = widget.notice.note
        .replaceAllMapped(
            RegExp(r'<a(?:[^>]*)>([^<]*)</a>'), (match) => match[1] ?? '')
        .replaceAll('<div class=\\"quote\\"><blockquote>', '\n')
        .replaceAll('</blockquote></div>', '')
        .replaceAll('&nsbp;', '')
        .replaceFirstMapped(RegExp(r'查看$'), (match) => '');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          pushName,
          arguments: routeParams,
        );
      },
      leading: Avatar(
        key: Key('Avatar${widget.notice.authorId}'),
        uid: widget.notice.authorId,
        username: widget.notice.author,
        width: 40,
        height: 40,
      ),
      title: Text(note),
      subtitle: Text(dateStr),
    );
  }
}
