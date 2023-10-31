part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FavoriteRefreshed extends FavoriteEvent {}

class FavoriteFetched extends FavoriteEvent {}

class FavoriteDeleted extends FavoriteEvent {
  final String favId;

  FavoriteDeleted(this.favId);
}
