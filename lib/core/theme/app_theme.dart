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
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 1,
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF8B4513),
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
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 1,
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFFC4A747), // Golden brown
        foregroundColor: Colors.black,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }
}
