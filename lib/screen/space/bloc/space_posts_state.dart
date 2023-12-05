part of 'space_posts_bloc.dart';

enum SpacePostsStatus { initial, success, failure }

class SpacePostsState extends Equatable {
  final SpacePostsStatus status;

  final int page;
  final List<Reply> posts;
  final bool hasReachMax;

  final String? message;

  const SpacePostsState(
    this.status,
    this.page,
    this.posts,
    this.hasReachMax,
    this.message,
  );

  SpacePostsState copyWith({
    SpacePostsStatus? status,
    int? page,
    List<Reply>? posts,
    bool? hasReachMax,
    String? message,
  }) {
    return SpacePostsState(
      status ?? this.status,
      page ?? this.page,
      posts ?? this.posts,
      hasReachMax ?? this.hasReachMax,
      message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        status,
        page,
        posts,
        hasReachMax,
        message,
      ];
}

final class SpacePostsInitial extends SpacePostsState {
  SpacePostsInitial() : super(SpacePostsStatus.initial, 1, [], true, null);
}
