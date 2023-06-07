import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_api/keylol_api.dart';
import 'package:keylol_flutter/bloc/theme_color/theme_color_bloc.dart';
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

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => ConfigRepository(prefs)),
        RepositoryProvider.value(value: keylol),
        RepositoryProvider.value(value: authenticationRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  ThemeColorBloc(context.read<ConfigRepository>())),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeColorBloc, ThemeColorState>(
      builder: (context, state) {
        final themeColor = state.color;
        return MaterialApp.router(
          routerConfig: routerConfig,
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
              searchBarTheme: SearchBarThemeData(
                elevation: MaterialStateProperty.all(6.0),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.surface),
                shadowColor: MaterialStateProperty.all(Colors.transparent),
              )),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
