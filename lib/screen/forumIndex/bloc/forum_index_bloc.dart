import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/config/logger.dart';

part 'forum_index_event.dart';

part 'forum_index_state.dart';

class ForumIndexBloc extends HydratedBloc<ForumIndexEvent, ForumIndexState> {
  final Keylol _client;

  ForumIndexBloc(this._client) : super(const ForumIndexInitial()) {
    on<ForumIndexFetched>(_onForumIndexFetched);
  }

  Future<void> _onForumIndexFetched(
    ForumIndexFetched event,
    Emitter<ForumIndexState> emit,
  ) async {
    try {
      final forumIndexResp = await _client.forumIndex();
      final message = forumIndexResp.message;
      if (message != null) {
        emit(state.copyWith(
          status: ForumIndexStatus.failure,
          message: message.messageStr,
        ));
      }

      final forumIndex = forumIndexResp.variables;
      emit(state.copyWith(
        status: ForumIndexStatus.success,
        forumIndex: forumIndex,
        message: null,
      ));
    } catch (e, stack) {
      talker.error("加载版块索引失败", e, stack);
      emit(state.copyWith(status: ForumIndexStatus.failure));
    }
  }

  @override
  ForumIndexState? fromJson(Map<String, dynamic> json) {
    return json.isEmpty
        ? const ForumIndexInitial()
        : ForumIndexState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ForumIndexState state) {
    return state.toJson();
  }
}
