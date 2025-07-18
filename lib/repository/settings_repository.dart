import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  final SharedPreferences _prefs;
  final _controller = StreamController<DateTime>();

  SettingsRepository(this._prefs);

  Stream<DateTime> get version async* {
    yield DateTime.now();
    yield* _controller.stream;
  }

  void dispose() {
    _controller.close();
  }

  bool getEnableDynamicColor() {
    return !(_prefs.getBool('theme.enabled') ?? false);
  }

  void setEnableDynamicColor(bool enabled) {
    _prefs.setBool('theme.enabled', !enabled);
    _controller.add(DateTime.now());
  }

  int? getThemeColorValue() {
    return _prefs.getInt('theme.color');
  }

  void setThemeColor(int value) {
    _prefs.setInt('theme.color', value);
    _controller.add(DateTime.now());
  }

  bool getEnableDebug() {
    return _prefs.getBool('debug.enabled') ?? false;
  }

  void setEnableDebug(bool enabled) {
    _prefs.setBool('debug.enabled', enabled);
    _controller.add(DateTime.now());
  }
}
