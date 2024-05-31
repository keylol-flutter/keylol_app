import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/config/logger_manager.dart';

part 'space_friends_event.dart';
part 'space_friends_state.dart';

class SpaceFriendsBloc extends Bloc<SpaceFriendsEvent, SpaceFriendsState> {
  final Keylol _client;
  final String uid;

  SpaceFriendsBloc(this._client, this.uid) : super(SpaceFriendsInitial()) {
    on<SpaceFriendsRefreshed>(_onSpaceFriendsRefreshed);
    on<SpaceFriendsFetched>(_onSpaceFriendsFetched);
  }

  Future<void> _onSpaceFriendsRefreshed(
    SpaceFriendsRefreshed event,
    Emitter<SpaceFriendsState> emit,
  ) async {
    try {
      int page = 1;
      final friendsResp = await _client.spaceFriend(uid, page);
      final message = friendsResp.message;
      if (message != null) {
        emit(state.copyWith(
          status: SpaceFriendsStatus.failure,
          message: message.messageStr,
        ));
      }

      final friends = friendsResp.variables.list;
      final count = friendsResp.variables.count;

      emit(state.copyWith(
        status: SpaceFriendsStatus.success,
        page: page,
        friends: friends,
        hasReachMax: friends.isEmpty || friends.length == count,
      ));
    } catch (e, stack) {
      talker.error('获取用户好友列表失败', e, stack);
      emit(state.copyWith(
        status: SpaceFriendsStatus.failure,
      ));
    }
  }

  Future<void> _onSpaceFriendsFetched(
    SpaceFriendsFetched event,
    Emitter<SpaceFriendsState> emit,
  ) async {
    try {
      final page = state.page + 1;
      final friendsResp = await _client.spaceFriend(uid, page);
      final message = friendsResp.message;
      if (message != null) {
        emit(state.copyWith(
          status: SpaceFriendsStatus.failure,
          message: message.messageStr,
        ));
      }

      final tempFriends = friendsResp.variables.list;
      final count = friendsResp.variables.count;

      final friends = state.friends..addAll(tempFriends);

      emit(state.copyWith(
        status: SpaceFriendsStatus.success,
        page: page,
        friends: friends,
        hasReachMax: tempFriends.isEmpty || friends.length == count,
      ));
    } catch (e, stack) {
      talker.error('获取用户好友列表失败', e, stack);
      emit(state.copyWith(
        status: SpaceFriendsStatus.failure,
      ));
    }
  }
}
