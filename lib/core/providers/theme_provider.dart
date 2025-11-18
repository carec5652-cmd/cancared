import 'package:flutter/material.dart';

/// ThemeProvider manages the app's theme mode (Light/Dark)
class ThemeProvider extends ChangeNotifier {
  // Default theme is light mode
  ThemeMode _themeMode = ThemeMode.light;

  /// Getter for current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Getter to check if dark mode is enabled
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Toggle between light and dark theme
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Notify all listeners that theme changed
  }

  /// Set theme to light mode
  void setLightTheme() {
    if (_themeMode == ThemeMode.light) return;
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  /// Set theme to dark mode
  void setDarkTheme() {
    if (_themeMode == ThemeMode.dark) return;
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  /// Light theme configuration
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    primarySwatch: Colors.blue,
    primaryColor: const Color(0xFF1976D2), // Healthcare blue
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1976D2),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1976D2),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

  /// Dark theme configuration
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    primarySwatch: Colors.blue,
    primaryColor: const Color(0xFF1976D2),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1976D2),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}

