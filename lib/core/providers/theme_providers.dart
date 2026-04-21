import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import 'database_providers.dart';

/// Provider for current theme mode
/// Reads from database settings and provides ThemeMode
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final db = ref.watch(databaseProvider);
  return ThemeModeNotifier(db);
});

/// Notifier to manage theme mode changes
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final AppDatabase db;

  ThemeModeNotifier(this.db) : super(ThemeMode.dark) {
    _initThemeMode();
  }

  /// Initialize theme mode from database
  Future<void> _initThemeMode() async {
    try {
      final setting = await db.getSettings();
      if (setting != null) {
        state = setting.darkMode ? ThemeMode.dark : ThemeMode.light;
      }
    } catch (e) {
      // Default to dark mode on error
      state = ThemeMode.dark;
    }
  }

  /// Toggle between dark and light mode
  Future<void> toggleThemeMode() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = newMode;

    try {
      await db.updateThemeMode(newMode == ThemeMode.dark);
    } catch (e) {
      // Revert on error
      state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    }
  }

  /// Set theme mode explicitly
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;

    try {
      await db.updateThemeMode(mode == ThemeMode.dark);
    } catch (e) {
      // Revert on error
      state = mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    }
  }
}

