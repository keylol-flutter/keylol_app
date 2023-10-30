import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/repository/history_repository.dart';
import 'package:collection/collection.dart';

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
      final threadDatas = await _repository.histories(page: 1, limit: 100);

      final dateThreadMap = groupBy(threadDatas, (obj) {
        final dateTime = DateTime.parse(obj['date']);
        return '${dateTime.month}-${dateTime.day}';
      }).map(
        (key, value) => MapEntry(
          key,
          value
              .map(
                (threadData) => Thread.fromJson(
                  {
                    'tid': threadData['tid'],
                    'fid': threadData['fid'],
                    'authorid': threadData['author_id'],
                    'author': threadData['author'],
                    'subject': threadData['subject'],
                    'dateline': threadData['dateline'],
                  },
                ),
              )
              .toList(),
        ),
      );

      emit(state.copyWith(
        status: HistoryStatus.success,
        page: 1,
        threads: dateThreadMap,
        hasReachMax: threadDatas.isEmpty,
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
      final threadDatas = await _repository.histories(page: page, limit: 100);

      final tempDateThreadMap = groupBy(threadDatas, (obj) {
        final dateTime = DateTime.parse(obj['date']);
        return '${dateTime.month}-${dateTime.day}';
      }).map(
        (key, value) => MapEntry(
          key,
          value
              .map(
                (threadData) => Thread.fromJson(
                  {
                    'tid': threadData['tid'],
                    'fid': threadData['fid'],
                    'authorid': threadData['author_id'],
                    'author': threadData['author'],
                    'subject': threadData['subject'],
                    'dateline': threadData['dateline'],
                  },
                ),
              )
              .toList(),
        ),
      );

      final dateThreadMap = state.threads;
      for (final date in tempDateThreadMap.keys) {
        if (dateThreadMap[date] == null) {
          dateThreadMap[date] = tempDateThreadMap[date]!;
        } else {
          dateThreadMap[date]!.addAll(tempDateThreadMap[date]!);
        }
      }

      emit(state.copyWith(
        status: HistoryStatus.success,
        page: page,
        threads: dateThreadMap,
        hasReachMax: threadDatas.isEmpty,
      ));
    } catch (e) {
      emit(state.copyWith(status: HistoryStatus.failure));
    }
  }
}
