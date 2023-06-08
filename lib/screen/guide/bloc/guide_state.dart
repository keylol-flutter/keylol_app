part of 'guide_bloc.dart';

enum GuideStatus { initial, success, failure }

class GuideState extends Equatable {
  final GuideStatus status;
  final List<Thread> threads;
  final int page;
  final bool hasReachMax;

  const GuideState(this.status, this.threads, this.page, this.hasReachMax);

  GuideState copyWith({
    GuideStatus? status,
    List<Thread>? threads,
    int? page,
    bool? hasReachMax,
  }) {
    return GuideState(
      status ?? this.status,
      threads ?? this.threads,
      page ?? this.page,
      hasReachMax ?? this.hasReachMax,
    );
  }

  @override
  List<Object?> get props => [status, threads, page, hasReachMax];
}

class GuideInitial extends GuideState {
  const GuideInitial() : super(GuideStatus.initial, const [], 0, false);
}
