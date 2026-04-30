import 'dart:io';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/app_database.dart';
import 'backup_service.dart';

class BackupSchedulerService {
  BackupSchedulerService._();

  static const String _lastBackupDateKey = 'last_automatic_backup_date';
  static const String _firstLaunchKey = 'chicken_tracker_first_launch';

  /// Initialize and trigger daily automatic backup if needed
  static Future<void> initialize(AppDatabase db) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirstLaunch = !prefs.containsKey(_firstLaunchKey);

      print('[BackupScheduler] isFirstLaunch = $isFirstLaunch');

      // Skip backup creation on first launch to avoid restoring old data
      if (isFirstLaunch) {
        print('[BackupScheduler] Skipping automatic backup on first launch');
        return;
      }

      await _performDailyBackupIfNeeded(db);
    } catch (e) {
      // Silently handle backup initialization errors
      // to prevent app startup failures
    }
  }

  /// Check if backup is needed today and perform it
  static Future<void> _performDailyBackupIfNeeded(AppDatabase db) async {
    final prefs = await SharedPreferences.getInstance();
    final lastBackupDateStr = prefs.getString(_lastBackupDateKey);
    final today = _dateKey(DateTime.now());

    // Skip if backup already created today
    if (lastBackupDateStr == today) {
      return;
    }

    // Create automatic backup
    await _createAutomaticBackup(db, prefs, today);
  }

  /// Create automatic backup and enforce retention policy
  static Future<void> _createAutomaticBackup(
    AppDatabase db,
    SharedPreferences prefs,
    String today,
  ) async {
    try {
      // Create the backup with 'automatic' type
      await BackupService.createBackup(
        db,
        backupType: 'automatic',
      );

      // Update last backup date
      await prefs.setString(_lastBackupDateKey, today);

      // Enforce retention policy (keep only 2 automatic backups)
      await _enforceRetentionPolicy();
    } catch (e) {
      // Silently handle backup creation errors — do not rethrow so startup is unaffected
    }
  }

  /// Keep only the 2 most recent automatic backups, delete older ones
  static Future<void> _enforceRetentionPolicy() async {
    try {
      final allBackups = await BackupService.listBackups();
      final automaticBackups = allBackups
          .whereType<File>()
          .where((f) => f.path.contains('_auto_'))
          .toList();

      if (automaticBackups.length <= 2) {
        return; // Nothing to delete
      }

      // Sort by modification time (newest first)
      automaticBackups.sort((a, b) {
        final aTime = a.lastModifiedSync().millisecondsSinceEpoch;
        final bTime = b.lastModifiedSync().millisecondsSinceEpoch;
        return bTime.compareTo(aTime); // Descending (newest first)
      });

      // Delete backups beyond the 2 most recent
      final toDelete = automaticBackups.sublist(2);
      await BackupService.deleteBackups(toDelete.cast<File>());
    } catch (e) {
      // Silently handle retention policy errors
    }
  }

  /// Extract date key from filename for comparison (YYYY-MM-DD format)
  static String _dateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Get display-friendly text for backup file
  static BackupMetadata parseBackupFilename(File file) {
    final filename = file.path.split('/').last;

    // Pattern: chicken_tracker_{auto|manual}_YYYY-MM-DD_HHmmss.json
    final isAutomatic = filename.contains('_auto_');
    final type = isAutomatic ? 'Automatic' : 'Manual';

    // Extract date and time from filename
    final parts = filename.replaceAll('.json', '').split('_');
    String dateStr = 'Unknown';
    String timeStr = '';

    if (parts.length >= 5) {
      dateStr = parts[parts.length - 2]; // YYYY-MM-DD
      timeStr = parts[parts.length - 1]; // HHmmss
      if (timeStr.length == 6) {
        timeStr =
            '${timeStr.substring(0, 2)}:${timeStr.substring(2, 4)}:${timeStr.substring(4)}';
      }
    }

    return BackupMetadata(
      filename: filename,
      type: type,
      isAutomatic: isAutomatic,
      dateStr: dateStr,
      timeStr: timeStr,
    );
  }
}

class BackupMetadata {
  final String filename;
  final String type;
  final bool isAutomatic;
  final String dateStr;
  final String timeStr;

  BackupMetadata({
    required this.filename,
    required this.type,
    required this.isAutomatic,
    required this.dateStr,
    required this.timeStr,
  });

  String get displayLabel =>
      '$type - $dateStr${timeStr.isNotEmpty ? ' at $timeStr' : ''}';
}






