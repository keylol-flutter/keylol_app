import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  final SharedPreferences prefs;
  final _controller = StreamController<DateTime>();

  SettingsRepository(this.prefs);

  Stream<DateTime> get version async* {
    yield DateTime.now();
    yield* _controller.stream;
  }

  void dispose() {
    _controller.close();
  }

  bool getEnableDynamicColor() {
    return !(prefs.getBool('theme.enabled') ?? false);
  }

  void setEnableDynamicColor(bool enabled) {
    prefs.setBool('theme.enabled', !enabled);
    _controller.add(DateTime.now());
  }

  int? getThemeColorValue() {
    return prefs.getInt('theme.color');
  }

  void setThemeColor(int value) {
    prefs.setInt('theme.color', value);
    _controller.add(DateTime.now());
  }

  bool getEnableDebug() {
    return prefs.getBool('debug.enabled') ?? false;
  }

  void setEnableDebug(bool enabled) {
    prefs.setBool('debug.enabled', enabled);
    _controller.add(DateTime.now());
  }
}
