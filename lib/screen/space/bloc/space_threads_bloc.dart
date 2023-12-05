import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/config/logger.dart';

part 'space_threads_event.dart';
part 'space_threads_state.dart';

class SpaceThreadsBloc extends Bloc<SpaceThreadsEvent, SpaceThreadsState> {
  final Keylol _client;
  final String uid;

  SpaceThreadsBloc(this._client, this.uid) : super(SpaceThreadsInitial()) {
    on<SpaceThreadsRefreshed>(_onSpaceThreadsRefreshed);
    on<SpaceThreadsFetched>(_onSpaceThreadsFetched);
  }

  Future<void> _onSpaceThreadsRefreshed(
    SpaceThreadsRefreshed event,
    Emitter<SpaceThreadsState> emit,
  ) async {
    try {
      int page = 1;
      final threadsResp = await _client.spaceThread(uid, page);

      final threads = threadsResp.list;

      emit(state.copyWith(
        status: SpaceThreadsStatus.success,
        page: page,
        threads: threads,
        hasReachMax: threads.isEmpty,
      ));
    } catch (e, stack) {
      logger.e('获取用户帖子列表失败', e, stack);
      emit(state.copyWith(
        status: SpaceThreadsStatus.failure,
      ));
    }
  }

  Future<void> _onSpaceThreadsFetched(
    SpaceThreadsFetched event,
    Emitter<SpaceThreadsState> emit,
  ) async {
    try {
      final page = state.page + 1;
      final threadsResp = await _client.spaceThread(uid, page);

      final threads = threadsResp.list;

      emit(state.copyWith(
        status: SpaceThreadsStatus.success,
        page: page,
        threads: state.threads..addAll(threads),
        hasReachMax: threads.isEmpty,
      ));
    } catch (e, stack) {
      logger.e('获取用户帖子列表失败', e, stack);
      emit(state.copyWith(
        status: SpaceThreadsStatus.failure,
      ));
    }
  }
}
