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
          (lightColorScheme, darkColorScheme) =
              _generateDynamicColourSchemes(lightDynamic, darkDynamic);
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

  (ColorScheme light, ColorScheme dark) _generateDynamicColourSchemes(
      ColorScheme lightDynamic, ColorScheme darkDynamic) {
    var lightBase = ColorScheme.fromSeed(seedColor: lightDynamic.primary);
    var darkBase = ColorScheme.fromSeed(
        seedColor: darkDynamic.primary, brightness: Brightness.dark);

    var lightAdditionalColours = _extractAdditionalColours(lightBase);
    var darkAdditionalColours = _extractAdditionalColours(darkBase);

    var lightScheme =
        _insertAdditionalColours(lightBase, lightAdditionalColours);
    var darkScheme = _insertAdditionalColours(darkBase, darkAdditionalColours);

    return (lightScheme.harmonized(), darkScheme.harmonized());
  }

  List<Color> _extractAdditionalColours(ColorScheme scheme) => [
        scheme.surface,
        scheme.surfaceDim,
        scheme.surfaceBright,
        scheme.surfaceContainerLowest,
        scheme.surfaceContainerLow,
        scheme.surfaceContainer,
        scheme.surfaceContainerHigh,
        scheme.surfaceContainerHighest,
      ];

  ColorScheme _insertAdditionalColours(
          ColorScheme scheme, List<Color> additionalColours) =>
      scheme.copyWith(
        surface: additionalColours[0],
        surfaceDim: additionalColours[1],
        surfaceBright: additionalColours[2],
        surfaceContainerLowest: additionalColours[3],
        surfaceContainerLow: additionalColours[4],
        surfaceContainer: additionalColours[5],
        surfaceContainerHigh: additionalColours[6],
        surfaceContainerHighest: additionalColours[7],
      );
}
