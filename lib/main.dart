import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:keylol_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:keylol_flutter/bloc/settings/settings_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:keylol_flutter/config/bloc_manager.dart';
import 'package:keylol_flutter/config/router.dart';
import 'package:keylol_flutter/widgets/adaptive_dynamic_color_builder.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final blocManager = await BlocManager.getInstance();

  FlutterNativeSplash.remove();
  runApp(blocManager.appWrap(const MyApp()));
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
                );
              },
            );
          },
        );
      },
    );
  }
}
