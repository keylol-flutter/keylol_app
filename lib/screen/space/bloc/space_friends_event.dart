part of 'space_friends_bloc.dart';

sealed class SpaceFriendsEvent extends Equatable {
  const SpaceFriendsEvent();

  @override
  List<Object> get props => [];
}

class SpaceFriendsRefreshed extends SpaceFriendsEvent {}

class SpaceFriendsFetched extends SpaceFriendsEvent {}
