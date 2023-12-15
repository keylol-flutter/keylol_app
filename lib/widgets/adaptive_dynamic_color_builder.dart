import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keylol_flutter/repository/settings_repository.dart';

typedef DynamicColorChildBuilder = Widget Function(
  ColorScheme lightColorScheme,
  ColorScheme darkColorScheme,
);

class AdaptiveDynamicColorBuilder extends StatelessWidget {
  final DynamicColorChildBuilder builder;

  const AdaptiveDynamicColorBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        final dynamicColorEnabled =
            context.read<SettingsRepository>().getEnableDynamicColor();
        if (dynamicColorEnabled &&
            (lightDynamic != null && darkDynamic != null)) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          final colorValue =
              context.read<SettingsRepository>().getThemeColorValue();
          // Otherwise, use fallback schemes.
          lightColorScheme = ColorScheme.fromSeed(
            seedColor:
                colorValue == null ? Colors.deepPurple : Color(colorValue),
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor:
                colorValue == null ? Colors.deepPurple : Color(colorValue),
            brightness: Brightness.dark,
          );
        }

        return builder(lightColorScheme, darkColorScheme);
      },
    );
  }
}
