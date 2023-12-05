part of 'space_threads_bloc.dart';

enum SpaceThreadsStatus { initial, success, failure }

class SpaceThreadsState extends Equatable {
  final SpaceThreadsStatus status;

  final int page;
  final List<Thread> threads;
  final bool hasReachMax;

  final String? message;

  const SpaceThreadsState(
    this.status,
    this.page,
    this.threads,
    this.hasReachMax,
    this.message,
  );

  SpaceThreadsState copyWith({
    SpaceThreadsStatus? status,
    int? page,
    List<Thread>? threads,
    bool? hasReachMax,
    String? message,
  }) {
    return SpaceThreadsState(
      status ?? this.status,
      page ?? this.page,
      threads ?? this.threads,
      hasReachMax ?? this.hasReachMax,
      message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        page,
        threads,
        hasReachMax,
        message,
      ];
}

final class SpaceThreadsInitial extends SpaceThreadsState {
  SpaceThreadsInitial() : super(SpaceThreadsStatus.initial, 1, [], true, null);
}
