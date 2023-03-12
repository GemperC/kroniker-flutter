import 'package:flutter/material.dart';
import 'package:kroniker_flutter/config/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  static const String _themeKey = 'theme';

  ThemeData _currentTheme = appThemeData;
  ThemeData get currentTheme => _currentTheme;

  ThemeModel() {
    loadTheme();
  }

  Future<void> toggleTheme() async {
    _currentTheme =
        _currentTheme == appThemeData ? darkAppThemeData : appThemeData;
    print('New theme: $_currentTheme');
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _themeKey, _currentTheme == appThemeData ? 'light' : 'dark');
    print('Theme saved: ${_currentTheme == appThemeData ? 'light' : 'dark'}');
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String themeName = prefs.getString(_themeKey) ?? 'light';
    _currentTheme = themeName == 'light' ? appThemeData : darkAppThemeData;
    notifyListeners();
  }
}
