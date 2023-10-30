import 'package:flutter/material.dart';
import 'package:keylol_api/models/thread.dart';
import 'package:keylol_flutter/widgets/avatar.dart';

typedef ThreadWrapperBuilder = Widget Function(Widget child);

class ThreadItem extends StatelessWidget {
  final Thread thread;
  final ThreadWrapperBuilder? wrapperBuilder;

  const ThreadItem({Key? key, required this.thread, this.wrapperBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = ListTile(
      leading: thread.authorId.isEmpty
          ? null
          : Avatar(
              key: Key('Avatar ${thread.authorId}'),
              uid: thread.authorId,
              username: thread.author,
              width: 40.0,
              height: 40.0,
            ),
      title: Text(
        thread.subject,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Row(
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
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          '/thread',
          arguments: {'tid': thread.tid},
        );
      },
    );
    return Container(
      child: wrapperBuilder == null ? content : wrapperBuilder!.call(content),
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
