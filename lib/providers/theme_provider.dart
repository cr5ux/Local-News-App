import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  static const String _darkModeKey = 'isDarkMode';

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    // Load theme preference immediately
    SharedPreferences.getInstance().then((prefs) {
      _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
      notifyListeners();
    });
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, _isDarkMode);
    notifyListeners();
  }
}
