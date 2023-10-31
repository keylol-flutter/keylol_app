import 'package:flutter/material.dart';
import 'package:keylol_api/keylol_api.dart';

class FavoriteThreadItem extends StatelessWidget {
  final FavThread favThread;

  const FavoriteThreadItem({super.key, required this.favThread});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(favThread.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(favThread.description),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(favThread.author),
              Text(_formatDateline(favThread.dateline)),
            ],
          )
        ],
      ),
      onTap: () {
        Navigator.of(context).pushNamed(
          '/thread',
          arguments: {'tid': favThread.id},
        );
      },
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
