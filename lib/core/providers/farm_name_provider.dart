import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmNameNotifier extends StateNotifier<String> {
  FarmNameNotifier() : super('Chicken Tracker') {
    _loadName();
  }

  Future<void> _loadName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('farm_name');
      if (name != null && name.isNotEmpty) {
        state = name;
      }
    } catch (e) {
      // Keep default
    }
  }

  Future<void> setName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      state = 'Chicken Tracker';
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('farm_name');
      } catch (e) {
        // Keep state
      }
    } else {
      state = trimmed;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('farm_name', trimmed);
      } catch (e) {
        // Keep state anyway
      }
    }
  }
}

/// Provider for the farm name (persistent with shared preferences)
final farmNameProvider =
    StateNotifierProvider<FarmNameNotifier, String>((ref) {
  return FarmNameNotifier();
});
