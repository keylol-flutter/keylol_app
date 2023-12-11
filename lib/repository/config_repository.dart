import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigRepository {
  final SharedPreferences prefs;

  ConfigRepository(this.prefs);

  int getThemeColorValue() {
    return prefs.getInt('theme.color') ?? Colors.blue.value;
  }

  void setThemeColor(int value) {
    prefs.setInt('theme.color', value);
  }

  bool getEnableDebug() {
    return prefs.getBool('debug.enabled') ?? false;
  }

  void setEnableDebug(bool enabled) {
    prefs.setBool('debug.enabled', enabled);
  }
}
