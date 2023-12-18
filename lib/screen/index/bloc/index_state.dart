part of 'index_bloc.dart';

enum IndexStatus { initial, success, failure }

class IndexState extends Equatable {
  final IndexStatus status;
  final Index? index;

  const IndexState(this.status, this.index);

  IndexState copyWith({
    IndexStatus? status,
    Index? index,
  }) {
    return IndexState(
      status ?? this.status,
      index ?? this.index,
    );
  }

  @override
  List<Object?> get props => [status, index];
}

class IndexInitial extends IndexState {
  const IndexInitial() : super(IndexStatus.initial, null);
}
