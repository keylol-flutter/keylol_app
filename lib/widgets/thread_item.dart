import 'package:flutter/material.dart';
import 'package:keylol_api/models/thread.dart';
import 'package:keylol_flutter/widgets/avatar.dart';

typedef ThreadWrapperBuilder = Widget Function(Widget child);

class ThreadItem extends StatelessWidget {
  final Thread thread;
  final ThreadWrapperBuilder? wrapperBuilder;

  const ThreadItem({
    super.key,
    required this.thread,
    this.wrapperBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final content = ListTile(
      leading: _buildLeading(context),
      title: _buildTitle(context),
      subtitle: _buildSubTitle(context),
      onTap: () {
        Navigator.of(context).pushNamed(
          '/thread',
          arguments: {
            'tid': thread.tid,
            'thread': thread,
          },
        );
      },
    );
    return Container(
      child: wrapperBuilder == null ? content : wrapperBuilder!.call(content),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    return thread.authorId.isEmpty
        ? null
        : Avatar(
            key: Key('Avatar ${thread.authorId}'),
            uid: thread.authorId,
            username: thread.author,
            width: 40.0,
            height: 40.0,
          );
  }

  Widget? _buildTitle(BuildContext context) {
    return Text(
      thread.subject,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget? _buildSubTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          thread.author,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          _formatDateline(thread.dateline),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  String _formatDateline(String dateline) {
    if (double.tryParse(dateline) == null) {
      return dateline;
    }

    final date =
        DateTime.fromMillisecondsSinceEpoch(int.parse(dateline) * 1000);
    return "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
