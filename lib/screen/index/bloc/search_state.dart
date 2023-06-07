part of 'search_bloc.dart';

enum SearchStatus { initial, searching, success, failure, done }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<Map<String, dynamic>> results;

  const SearchState(this.status, this.results);

  SearchState copyWith({
    SearchStatus? status,
    List<Map<String, dynamic>>? results,
  }) {
    return SearchState(
      status ?? this.status,
      results ?? this.results,
    );
  }

  @override
  List<Object?> get props => [status, results];
}

class SearchInitial extends SearchState {
  const SearchInitial() : super(SearchStatus.initial, const []);
}
