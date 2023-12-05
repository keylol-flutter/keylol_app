part of 'space_posts_bloc.dart';

sealed class SpacePostsEvent extends Equatable {
  const SpacePostsEvent();

  @override
  List<Object> get props => [];
}

class SpacePostsRefreshed extends SpacePostsEvent {}

class SpacePostsFetched extends SpacePostsEvent {}
