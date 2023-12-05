part of 'space_threads_bloc.dart';

sealed class SpaceThreadsEvent extends Equatable {
  const SpaceThreadsEvent();

  @override
  List<Object> get props => [];
}

class SpaceThreadsRefreshed extends SpaceThreadsEvent {}

class SpaceThreadsFetched extends SpaceThreadsEvent {}
