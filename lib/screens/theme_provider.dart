import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themedata => _themeData;

  static ThemeData get lightMode => ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          background: Colors.white,
          primary: const Color.fromARGB(255, 13, 197, 214),
        ),
      );

  static ThemeData get darkMode => ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          background: Color.fromRGBO(0, 0, 0, 1),
          primary: Color.fromARGB(255, 28, 150, 146),
        ),
      );

  bool get isDarkModeEnabled =>
      _themeData == darkMode; // Check if current theme is dark mode

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _saveThemePreference(themeData); // Save the theme preference
    notifyListeners();
  }

  Future<void> _saveThemePreference(ThemeData themeData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('theme', themeData == lightMode ? 'light' : 'dark');
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }

  Future<void> loadSavedTheme() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String savedTheme = prefs.getString('theme') ?? 'light';
      themeData = savedTheme == 'light' ? lightMode : darkMode;
    } catch (e) {
      print('Error loading saved theme: $e');
    }
  }

  void toggleTheme() {
    themeData = _themeData == darkMode ? lightMode : darkMode;
  }
}
