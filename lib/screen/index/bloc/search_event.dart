part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchHistoriesFetched extends SearchEvent {}

class SearchHistoriesCleaned extends SearchEvent {}

class SearchResultsFetched extends SearchEvent {
  final String text;

  const SearchResultsFetched(this.text);

  @override
  List<Object?> get props => [text];
}
