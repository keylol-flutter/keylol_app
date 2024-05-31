import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:keylol_flutter/bloc/settings/settings_cubit.dart';
import 'package:keylol_flutter/config/logger_manager.dart';
import 'package:keylol_flutter/repository/authentication_repository.dart';
import 'package:keylol_flutter/repository/favorite_repository.dart';
import 'package:keylol_flutter/repository/history_repository.dart';
import 'package:keylol_flutter/repository/settings_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class BlocManager {
  final Map<String, Object> _repositories;

  BlocManager._(this._repositories);

  static BlocManager? _instance;

  static Future<BlocManager> getInstance() async {
    if (_instance != null) {
      return _instance!;
    }

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
    );

    final settingsRepository = await SettingsRepository.getInstance();
    final authenticationRepository = AuthenticationRepository.getInstance();
    final historyRepository = await HistoryRepository.getInstance();

    final keylol = await Keylol.create();
    keylol.addInterceptor(DioCacheInterceptor(
      options: CacheOptions(
        store: MemCacheStore(),
        keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      ),
    ));
    keylol.addInterceptor(AuthenticationInterceptor(authenticationRepository));
    keylol.addInterceptor(TalkerDioLogger(talker: talker));

    final favoriteRepository = await FavoriteRepository.getInstance(keylol);

    Bloc.observer = TalkerBlocObserver(talker: talker);

    _instance = BlocManager._({
      'keylol': keylol,
      'settings': settingsRepository,
      'authentication': authenticationRepository,
      'history': historyRepository,
      'favorite': favoriteRepository,
    });
    return _instance!;
  }

  Widget appWrap(Widget app) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _repositories['keylol'] as Keylol),
        RepositoryProvider.value(
            value: _repositories['settings'] as SettingsRepository),
        RepositoryProvider.value(
            value: _repositories['authentication'] as AuthenticationRepository),
        RepositoryProvider.value(
            value: _repositories['history'] as HistoryRepository),
        RepositoryProvider.value(
            value: _repositories['favorite'] as FavoriteRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              _repositories['keylol'] as Keylol,
              _repositories['authentication'] as AuthenticationRepository,
            )..add(AuthenticationStatusFetched()),
          ),
          BlocProvider(
              create: (context) => SettingsCubit(
                  _repositories['settings'] as SettingsRepository)),
        ],
        child: app,
      ),
    );
  }
}
