import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/repository/search_history_repository.dart';
import 'package:keylol_flutter/screen/index/bloc/search_bloc.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<StatefulWidget> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _controller = SearchController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(context.read<SearchHistoryRepository>()),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return SearchAnchor(
            searchController: _controller,
            isFullScreen: true,
            builder: (BuildContext context, SearchController controller) {
              return IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  controller.openView();
                },
              );
            },
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
          );
        },
      ),
    );
  }
}
