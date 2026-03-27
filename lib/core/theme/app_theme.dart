import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8B4513), // Brown for farm/chicken theme
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 1,
        backgroundColor: Color(0xFF8B4513),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF8B4513),
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8B4513), // Brown for farm/chicken theme
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 1,
        backgroundColor: Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFC4A747), // Golden brown
        foregroundColor: Colors.black,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }
}
