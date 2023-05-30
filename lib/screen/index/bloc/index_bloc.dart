import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol.dart';
import 'package:keylol_api/models/index.dart';

part 'index_event.dart';

part 'index_state.dart';

class IndexBloc extends Bloc<IndexEvent, IndexState> {
  final Keylol _client;

  IndexBloc(this._client) : super(const IndexInitial()) {
    on<IndexFetched>(_onIndexFetched);
    on<IndexPageChanged>(_onIndexPageChanged);
  }

  Future<void> _onIndexFetched(
    IndexFetched event,
    Emitter<IndexState> emit,
  ) async {
    try {
      final index = await _client.index();
      emit(state.copyWith(status: IndexStatus.success, index: index));
    } catch (exception) {
      emit(state.copyWith(status: IndexStatus.failure));
    }
  }

  Future<void> _onIndexPageChanged(
    IndexPageChanged event,
    Emitter<IndexState> emit,
  ) async {
    emit(state.copyWith(pageIndex: event.pageIndex));
  }
}
