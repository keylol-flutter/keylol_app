part of 'thread_bloc.dart';

abstract class ThreadEvent extends Equatable {
  const ThreadEvent();

  @override
  List<Object?> get props => [];
}

class ThreadRefreshed extends ThreadEvent {
  final String? pid;

  const ThreadRefreshed({this.pid});

  @override
  List<Object?> get props => [pid];
}

class ThreadFetched extends ThreadEvent {}
