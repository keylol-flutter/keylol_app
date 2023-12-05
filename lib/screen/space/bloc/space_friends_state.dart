part of 'space_friends_bloc.dart';

enum SpaceFriendsStatus { initial, success, failure }

class SpaceFriendsState extends Equatable {
  final SpaceFriendsStatus status;

  final int page;
  final List<Friend> friends;
  final bool hasReachMax;

  final String? message;

  const SpaceFriendsState(
    this.status,
    this.page,
    this.friends,
    this.hasReachMax,
    this.message,
  );

  SpaceFriendsState copyWith({
    SpaceFriendsStatus? status,
    int? page,
    List<Friend>? friends,
    bool? hasReachMax,
    String? message,
  }) {
    return SpaceFriendsState(
      status ?? this.status,
      page ?? this.page,
      friends ?? this.friends,
      hasReachMax ?? this.hasReachMax,
      message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        page,
        friends,
        hasReachMax,
        message,
      ];
}

final class SpaceFriendsInitial extends SpaceFriendsState {
  SpaceFriendsInitial() : super(SpaceFriendsStatus.initial, 1, [], true, null);
}
