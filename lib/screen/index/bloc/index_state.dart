part of 'index_bloc.dart';

enum IndexStatus { initial, success, failure }

class IndexState extends Equatable {
  final IndexStatus status;
  final Index? index;
  final int pageIndex;

  const IndexState(this.status, this.index, this.pageIndex);

  IndexState copyWith({
    IndexStatus? status,
    Index? index,
    int? pageIndex,
  }) {
    return IndexState(
      status ?? this.status,
      index ?? this.index,
      pageIndex ?? this.pageIndex,
    );
  }

  @override
  List<Object?> get props => [status, index];
}

class IndexInitial extends IndexState {
  const IndexInitial() : super(IndexStatus.initial, null, 0);
}
