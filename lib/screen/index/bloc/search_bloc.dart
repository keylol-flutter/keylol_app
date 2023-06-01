import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:keylol_flutter/repository/search_history_repository.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final _dio = Dio();
  final SearchHistoryRepository _repository;

  SearchBloc(this._repository) : super(const SearchInitial()) {
    on<SearchHistoriesFetched>(_onSearchHistoriesFetched);
    on<SearchHistoriesCleaned>(_onSearchHistoriesCleaned);
    on<SearchResultsFetched>(_onSearchResultsFetched);
  }

  Future<void> _onSearchHistoriesFetched(
    SearchHistoriesFetched event,
    Emitter<SearchState> emit,
  ) async {}

  Future<void> _onSearchHistoriesCleaned(
    SearchHistoriesCleaned event,
    Emitter<SearchState> emit,
  ) async {}

  Future<void> _onSearchResultsFetched(
    SearchResultsFetched event,
    Emitter<SearchState> emit,
  ) async {
    final text = event.text;
  }
}
