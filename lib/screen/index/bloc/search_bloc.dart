import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart';
import 'package:keylol_flutter/config/logger.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final _dio = Dio(BaseOptions(baseUrl: 'https://duckduckgo.com'));

  SearchBloc() : super(const SearchInitial()) {
    on<SearchResultsFetched>(_onSearchResultsFetched);
    on<SearchResultsFetching>(_onSearchResultsFetching);
  }

  Future<void> _onSearchResultsFetched(
      SearchResultsFetched event,
      Emitter<SearchState> emit,
      ) async {
    final text = event.text;
    if (text.isEmpty) {
      return;
    }

    try {
      final resp = await _dio.get('/html', queryParameters: {'q': text});
      final document = parse(resp.data);

      final resultElements = document.getElementsByClassName('result');
      final results = resultElements.map((r) {
        final title = r.getElementsByClassName('result__a')[0].text;
        final subTitle = r.getElementsByClassName('result__snippet')[0].text;
        final url = r.getElementsByClassName('result__url')[0].text.trim();
        return {
          'title': title,
          'subTitle': subTitle,
          'url': url,
        };
      }).toList();

      emit(state.copyWith(
        status: SearchStatus.success,
        results: results,
      ));
    } catch (e, stack) {
      logger.e('DuckDuckGo搜索错误', e, stack);
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }

  Future<void> _onSearchResultsFetching(
      SearchResultsFetching event,
      Emitter<SearchState> emit,
      ) async {
    emit(state.copyWith(status: SearchStatus.searching));
  }
}
