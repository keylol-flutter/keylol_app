part of 'search_bloc.dart';

enum SearchStatus { initial, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<String> histories;
  final List<Map<String, dynamic>> results;

  const SearchState(this.status, this.histories, this.results);

  SearchState copyWith({
    SearchStatus? status,
    List<String>? histories,
    List<Map<String, dynamic>>? results,
  }) {
    return SearchState(
      status ?? this.status,
      histories ?? this.histories,
      results ?? this.results,
    );
  }

  @override
  List<Object?> get props => [histories, results];
}

class SearchInitial extends SearchState {
  const SearchInitial() : super(SearchStatus.initial, const [], const []);
}
