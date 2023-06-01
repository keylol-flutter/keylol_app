import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final Widget? barLeading;
  final List<Widget>? barTrailing;

  const Search({super.key, this.barLeading, this.barTrailing});

  @override
  State<StatefulWidget> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _dio = Dio();

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      barLeading: widget.barLeading,
      barTrailing: widget.barTrailing,
      suggestionsBuilder: (context, controller) {
        // TODO
        return List<Widget>.generate(
          5,
          (int index) {
            return ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Initial list item $index'),
            );
          },
        );
      },
      isFullScreen: true,
    );
  }
}
