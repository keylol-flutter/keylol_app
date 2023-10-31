part of 'favorite_bloc.dart';

enum FavoriteStatus { initial, success, failure }

class FavoriteState extends Equatable {
  final FavoriteStatus status;

  final int page;
  final List<FavThread> favThreads;
  final bool hasReachMax;

  const FavoriteState(this.status, this.page, this.favThreads, this.hasReachMax);

  FavoriteState copy({
    FavoriteStatus? status,
    int? page,
    List<FavThread>? favThreads,
    bool? hasReachMax,
  }) {
    return FavoriteState(
      status ?? this.status,
      page ?? this.page,
      favThreads ?? this.favThreads,
      hasReachMax ?? this.hasReachMax,
    );
  }

  @override
  List<Object?> get props => [status, favThreads];
}

class FavoriteInitial extends FavoriteState {
  FavoriteInitial() : super(FavoriteStatus.initial, 1, [], true);
}
