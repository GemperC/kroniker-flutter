import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel extends ChangeNotifier {
  static const String _themeKey = 'theme';

  ThemeData _currentTheme = ThemeData.light();
  ThemeData get currentTheme => _currentTheme;

  Future<void> toggleTheme() async {
    _currentTheme = _currentTheme == ThemeData.light()
        ? ThemeData.dark()
        : ThemeData.light();
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _themeKey, _currentTheme == ThemeData.light() ? 'light' : 'dark');
  }

  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String themeName = prefs.getString(_themeKey) ?? 'light';
    _currentTheme = themeName == 'light' ? ThemeData.light() : ThemeData.dark();
    notifyListeners();
  }
}
