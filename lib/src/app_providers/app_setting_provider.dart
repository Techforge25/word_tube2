import 'package:flutter/material.dart';
import 'package:word_toob/src/common/app_constants/app_keys.dart';

enum Status { initial, error, loading, loaded }

class AppSettingsProvider extends ChangeNotifier {
  ThemeMode _activeTheme = ThemeMode.light;

  ///theme
  ThemeMode get activeTheme {
    String theme = "light";
    switch (theme) {
      case AppKeys.dark:
        _activeTheme = ThemeMode.dark;
        break;
      case AppKeys.light:
        _activeTheme = ThemeMode.light;
        break;
      default:
        _activeTheme = ThemeMode.light;
        break;
    }
    return _activeTheme;
  }
}
