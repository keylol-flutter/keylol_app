import 'dart:async';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:keylol_flutter/bloc/settings/settings_cubit.dart';
import 'package:keylol_flutter/l10n/app_localizations.dart';
import 'package:keylol_flutter/config/router.dart';
import 'package:keylol_flutter/repository/authentication_repository.dart';
import 'package:keylol_flutter/repository/database_service.dart';
import 'package:keylol_flutter/repository/favorite_repository.dart';
import 'package:keylol_flutter/repository/history_repository.dart';
import 'package:keylol_flutter/repository/settings_repository.dart';
import 'package:keylol_flutter/widgets/adaptive_dynamic_color_builder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_flutter/talker_flutter.dart';

final talker = TalkerFlutter.init();

void main() async {
  runZonedGuarded(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      final sharedPreferences = await SharedPreferences.getInstance();

      final databaseService = DatabaseService();
      await databaseService.init();

      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: await getApplicationDocumentsDirectory(),
      );

      Bloc.observer = TalkerBlocObserver(talker: talker);

      final client = await Keylol.create();

      FlutterNativeSplash.remove();
      runApp(MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: sharedPreferences),
          RepositoryProvider.value(value: databaseService),
        ],
        child: RepositoryProvider(
          create: (context) => AuthenticationRepository(),
          child: RepositoryProvider(
            create: (context) {
              client.addInterceptor(DioCacheInterceptor(
                options: CacheOptions(
                  store: MemCacheStore(),
                  keyBuilder: CacheOptions.defaultCacheKeyBuilder,
                ),
              ));
              client.addInterceptor(AuthenticationInterceptor(
                context.read<AuthenticationRepository>(),
              ));
              client.addInterceptor(TalkerDioLogger(
                talker: talker,
              ));
              return client;
            },
            child: MultiRepositoryProvider(
              providers: [
                RepositoryProvider(
                  create: (context) =>
                      SettingsRepository(context.read<SharedPreferences>()),
                ),
                RepositoryProvider(
                  create: (context) => HistoryRepository(
                    context.read<DatabaseService>().instance,
                  ),
                ),
                RepositoryProvider(
                  create: (context) => FavoriteRepository(
                    context.read<SharedPreferences>(),
                    context.read<DatabaseService>().instance,
                    context.read<Keylol>(),
                  ),
                ),
              ],
              child: const MyApp(),
            ),
          ),
        ),
      ));
    },
    (error, stack) {
      talker.error('', error, stack);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, DateTime>(
      builder: (context, _) {
        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return AdaptiveDynamicColorBuilder(
              builder: (lightColorScheme, darkColorScheme) {
                return MaterialApp(
                  theme: ThemeData(
                    useMaterial3: true,
                    colorScheme: lightColorScheme,
                  ),
                  darkTheme: ThemeData(
                    useMaterial3: true,
                    colorScheme: darkColorScheme,
                  ),
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  routes: routes,
                  navigatorObservers: [
                    TalkerRouteObserver(talker),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
