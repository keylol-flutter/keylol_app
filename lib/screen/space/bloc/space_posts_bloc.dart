import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/config/logger_manager.dart';

part 'space_posts_event.dart';
part 'space_posts_state.dart';

class SpacePostsBloc extends Bloc<SpacePostsEvent, SpacePostsState> {
  final Keylol _client;
  final String uid;

  SpacePostsBloc(this._client, this.uid) : super(SpacePostsInitial()) {
    on<SpacePostsRefreshed>(_onSpacePostsRefreshed);
    on<SpacePostsFetched>(_onSpacePostsFetched);
  }

  Future<void> _onSpacePostsRefreshed(
    SpacePostsRefreshed event,
    Emitter<SpacePostsState> emit,
  ) async {
    try {
      int page = 1;
      final repliesResp = await _client.spaceReply(uid, page);

      final posts = repliesResp.list;

      emit(state.copyWith(
        status: SpacePostsStatus.success,
        page: page,
        posts: posts,
        hasReachMax: posts.isEmpty,
      ));
    } catch (e, stack) {
      LoggerManager.e('获取用户回复列表失败', error: e, stackTrace: stack);
      emit(state.copyWith(
        status: SpacePostsStatus.failure,
      ));
    }
  }

  Future<void> _onSpacePostsFetched(
    SpacePostsFetched event,
    Emitter<SpacePostsState> emit,
  ) async {
    try {
      final page = state.page + 1;
      final repliesResp = await _client.spaceReply(uid, page);

      final posts = repliesResp.list;

      emit(state.copyWith(
        status: SpacePostsStatus.success,
        page: page,
        posts: state.posts..addAll(posts),
        hasReachMax: posts.isEmpty,
      ));
    } catch (e, stack) {
      LoggerManager.e('获取用户回复列表失败', error: e, stackTrace: stack);
      emit(state.copyWith(
        status: SpacePostsStatus.failure,
      ));
    }
  }
}
