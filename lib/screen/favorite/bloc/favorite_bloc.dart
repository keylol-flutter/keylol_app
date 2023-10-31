import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';

part 'favorite_event.dart';

part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final Keylol _client;

  FavoriteBloc(this._client) : super(FavoriteInitial()) {
    on<FavoriteRefreshed>(_onFavoriteRefreshed);
    on<FavoriteFetched>(_onFavoriteFetched);
    on<FavoriteDeleted>(_onFavoriteDeleted);
  }

  Future<void> _onFavoriteRefreshed(
    FavoriteRefreshed event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      final myFavThreadResp = await _client.myFavThread(1);
      final myFavThread = myFavThreadResp.variables;
      final favThreads = myFavThread.list;

      emit(state.copy(
        status: FavoriteStatus.success,
        page: 1,
        favThreads: favThreads,
        hasReachMax: favThreads.length >= myFavThread.count,
      ));
    } catch (e) {
      emit(state.copy(status: FavoriteStatus.failure));
    }
  }

  Future<void> _onFavoriteFetched(
    FavoriteFetched event,
    Emitter<FavoriteState> emit,
  ) async {
    final page = state.page + 1;

    try {
      final myFavThreadResp = await _client.myFavThread(1);
      final myFavThread = myFavThreadResp.variables;
      var favThreads = myFavThread.list;

      favThreads = state.favThreads..addAll(favThreads);

      emit(state.copy(
        status: FavoriteStatus.success,
        page: page,
        favThreads: favThreads,
        hasReachMax: favThreads.length >= myFavThread.count,
      ));
    } catch (e) {
      emit(state.copy(status: FavoriteStatus.failure));
    }
  }

  Future<void> _onFavoriteDeleted(
    FavoriteDeleted event,
    Emitter<FavoriteState> emitter,
  ) async {}
}
