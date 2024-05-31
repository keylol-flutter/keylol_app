import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/config/logger_manager.dart';

part 'index_event.dart';

part 'index_state.dart';

class IndexBloc extends HydratedBloc<IndexEvent, IndexState> {
  final Keylol _client;

  IndexBloc(this._client) : super(const IndexInitial()) {
    on<IndexFetched>(_onIndexFetched);
  }

  Future<void> _onIndexFetched(
    IndexFetched event,
    Emitter<IndexState> emit,
  ) async {
    try {
      final index = await _client.index();
      emit(state.copyWith(status: IndexStatus.success, index: index));
    } catch (e, stack) {
      talker.error('加载聚焦失败', e, stack);
      emit(state.copyWith(status: IndexStatus.failure));
    }
  }

  @override
  IndexState? fromJson(Map<String, dynamic> json) {
    return json.isEmpty ? const IndexInitial() : IndexState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(IndexState state) {
    return state.toJson();
  }
}
