import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_ume/core/plugin_manager.dart';
import 'package:flutter_ume/core/ui/root_widget.dart';
import 'package:flutter_ume_kit_console/console/console_panel.dart';
import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart';
import 'package:flutter_ume_kit_ui/components/widget_detail_inspector/widget_detail_inspector.dart';
import 'package:flutter_ume_kit_ui/components/widget_info_inspector/widget_info_inspector.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/bloc/bloc/authentication_bloc.dart';
import 'package:keylol_flutter/config/firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:keylol_flutter/config/router.dart';
import 'package:keylol_flutter/repository/authentication_repository.dart';
import 'package:keylol_flutter/repository/config_repository.dart';
import 'package:keylol_flutter/repository/favorite_repository.dart';
import 'package:keylol_flutter/repository/history_repository.dart';
import 'package:keylol_flutter/widgets/adaptive_dynamic_color_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final prefs = await SharedPreferences.getInstance();
  final keylol = await Keylol.create();
  final authenticationRepository = AuthenticationRepository();
  final authenticationInterceptor =
      AuthenticationInterceptor(authenticationRepository);
  keylol.addInterceptor(authenticationInterceptor);
  final historyRepository = HistoryRepository();
  await historyRepository.initial();
  final favoriteRepository = FavoriteRepository(prefs, keylol);
  await favoriteRepository.initial();

  PluginManager.instance
    ..register(const WidgetInfoInspector())
    ..register(const WidgetDetailInspector())
    ..register(Console())
    ..register(DioInspector(dio: keylol.dio()));

  FlutterNativeSplash.remove();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => ConfigRepository(prefs)),
        RepositoryProvider.value(value: keylol),
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: historyRepository),
        RepositoryProvider.value(value: favoriteRepository),
        BlocProvider(
          create: (context) {
            return AuthenticationBloc(
              keylol,
              authenticationRepository,
            )..add(AuthenticationStatusFetched());
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return UMEWidget(
          enable: true,
          child: AdaptiveDynamicColorBuilder(
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
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routes: routes,
              );
            },
          ),
        );
      },
    );
  }
}
