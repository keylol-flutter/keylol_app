part of 'history_bloc.dart';

sealed class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class HistoryRefreshed extends HistoryEvent {}

class HistoryFetched extends HistoryEvent {}
