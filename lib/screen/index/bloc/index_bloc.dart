import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/config/logger.dart';

part 'index_event.dart';

part 'index_state.dart';

class IndexBloc extends Bloc<IndexEvent, IndexState> {
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
      logger.e('加载聚焦失败', e, stack);
      emit(state.copyWith(status: IndexStatus.failure));
    }
  }
}
