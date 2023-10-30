part of 'history_bloc.dart';

enum HistoryStatus { initial, success, failure }

class HistoryState extends Equatable {
  final HistoryStatus status;

  final int page;
  final Map<String, List<Thread>> threads;
  final bool hasReachMax;

  const HistoryState(this.status, this.page, this.threads, this.hasReachMax);

  HistoryState copyWith({
    HistoryStatus? status,
    int? page,
    Map<String, List<Thread>>? threads,
    bool? hasReachMax,
  }) {
    return HistoryState(
      status ?? this.status,
      page ?? this.page,
      threads ?? this.threads,
      hasReachMax ?? this.hasReachMax,
    );
  }

  @override
  List<Object> get props => [status, page, threads];
}

final class HistoryInitial extends HistoryState {
  HistoryInitial() : super(HistoryStatus.initial, 1, {}, true);
}
