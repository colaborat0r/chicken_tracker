import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/backup_service.dart';
import 'database_providers.dart';

/// Provider to track and manage first app launch
final firstLaunchProvider = StateNotifierProvider<FirstLaunchNotifier, bool>((ref) {
  return FirstLaunchNotifier(ref);
});

class FirstLaunchNotifier extends StateNotifier<bool> {
  final Ref _ref;
  
  FirstLaunchNotifier(this._ref) : super(false) {
    _initialize();
  }

  static const String _key = 'chicken_tracker_first_launch';

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = !prefs.containsKey(_key);
    
    print('[FirstLaunch] isFirstLaunch = $isFirstLaunch');
    
    state = isFirstLaunch;
    if (isFirstLaunch) {
      print('[FirstLaunch] Running first launch database reset...');
      try {
        // Use the existing database instance from the provider
        final db = _ref.read(databaseProvider);
        print('[FirstLaunch] Resetting database...');
        await BackupService.resetAllData(db);
        print('[FirstLaunch] ✓ Database reset complete');
      } catch (e, stackTrace) {
        print('[FirstLaunch] ERROR resetting database: $e');
        print('[FirstLaunch] StackTrace: $stackTrace');
      }
      
      await prefs.setBool(_key, false);
      print('[FirstLaunch] ✓ First launch complete');
    }
  }

  Future<void> markLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, false);
    state = false;
  }
}
