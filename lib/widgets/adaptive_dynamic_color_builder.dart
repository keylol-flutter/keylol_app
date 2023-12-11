import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

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

        return builder(lightColorScheme, darkColorScheme);
      },
    );
  }
}
