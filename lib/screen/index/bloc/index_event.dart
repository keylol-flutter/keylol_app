part of 'index_bloc.dart';

abstract class IndexEvent extends Equatable {
  const IndexEvent();

  @override
  List<Object> get props => [];
}

final class IndexFetched extends IndexEvent {}

final class IndexPageChanged extends IndexEvent {
  final int pageIndex;

  const IndexPageChanged(this.pageIndex);

  @override
  List<Object> get props => [pageIndex];
}
