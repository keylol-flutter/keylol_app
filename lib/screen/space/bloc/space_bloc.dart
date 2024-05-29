import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/config/logger_manager.dart';

part 'space_event.dart';

part 'space_state.dart';

class SpaceBloc extends Bloc<SpaceEvent, SpaceState> {
  final Keylol _client;
  final String _uid;

  SpaceBloc(this._client, this._uid) : super(const SpaceInitial()) {
    on<SpaceRefreshed>(_onSpaceRefreshed);
  }

  Future<void> _onSpaceRefreshed(
    SpaceRefreshed event,
    Emitter<SpaceState> emit,
  ) async {
    try {
      final profileResp = await _client.profile(_uid);
      final message = profileResp.message;
      if (message != null) {
        emit(state.copyWith(
          status: SpaceStatus.failure,
          message: message.messageStr,
        ));
        return;
      }

      final profile = profileResp.variables;
      emit(state.copyWith(
        status: SpaceStatus.success,
        profile: profile,
      ));
    } catch (e, stack) {
      LoggerManager.e('获取用户信息失败', error: e, stackTrace: stack);
      emit(state.copyWith(status: SpaceStatus.failure));
    }
  }
}
