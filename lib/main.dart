import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ume/core/plugin_manager.dart';
import 'package:flutter_ume/core/ui/root_widget.dart';
import 'package:flutter_ume_kit_console/console/console_panel.dart';
import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/bloc/bloc/authentication_bloc.dart';
import 'package:keylol_flutter/config/firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:keylol_flutter/config/router.dart';
import 'package:keylol_flutter/repository/authentication_repository.dart';
import 'package:keylol_flutter/repository/config_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kDebugMode) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  final prefs = await SharedPreferences.getInstance();
  final keylol = await Keylol.create();
  final authenticationRepository = AuthenticationRepository();
  final authenticationInterceptor =
      AuthenticationInterceptor(authenticationRepository);
  keylol.addInterceptor(authenticationInterceptor);

  PluginManager.instance
      ..register(Console())
      ..register(DioInspector(dio: keylol.dio()));
  runApp(
    UMEWidget(
      enable: true,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => ConfigRepository(prefs)),
          RepositoryProvider.value(value: keylol),
          RepositoryProvider.value(value: authenticationRepository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) {
                return AuthenticationBloc(
                  context.read<Keylol>(),
                  context.read<AuthenticationRepository>(),
                )..add(AuthenticationStatusFetched());
              },
            ),
          ],
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return DynamicColorBuilder(
          builder: (lightDynamic, darkDynamic) {
            ColorScheme lightColorScheme;
            ColorScheme darkColorScheme;

            if (lightDynamic != null && darkDynamic != null) {
              lightColorScheme = lightDynamic.harmonized();
              darkColorScheme = darkDynamic.harmonized();
            } else {
              // Otherwise, use fallback schemes.
              lightColorScheme = ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
              );
              darkColorScheme = ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              );
            }

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
        );
      },
    );
  }
}
