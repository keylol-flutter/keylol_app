import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/repository/history_repository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository _repository;

  HistoryBloc(this._repository) : super(HistoryInitial()) {
    on<HistoryRefreshed>(_onHistoryRefreshed);
    on<HistoryFetched>(_onHistoryFetched);
  }

  Future<void> _onHistoryRefreshed(
    HistoryRefreshed event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      final threads = await _repository.histories(page: 1, limit: 100);

      emit(state.copyWith(
        status: HistoryStatus.success,
        page: 1,
        threads: threads,
      ));
    } catch (e) {
      emit(state.copyWith(status: HistoryStatus.failure));
    }
  }

  Future<void> _onHistoryFetched(
    HistoryFetched event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      final page = state.page + 1;
      final threads = await _repository.histories(page: page, limit: 100);

      emit(state.copyWith(
        status: HistoryStatus.success,
        page: page,
        threads: state.threads..addAll(threads),
      ));
    } catch (e) {
      emit(state.copyWith(status: HistoryStatus.failure));
    }
  }
}
