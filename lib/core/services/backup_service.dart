import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../database/app_database.dart';

class BackupService {
  BackupService._();

  static const String _backupFolderName = 'backups';

  static Future<Directory> _backupDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(docsDir.path, _backupFolderName));
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir;
  }

  static Future<File> createBackup(
    AppDatabase db, {
    String backupType = 'manual',
  }) async {
    final backupDir = await _backupDirectory();

    // Format: chicken_tracker_{auto|manual}_YYYY-MM-DD_HHmmss.json
    final typePrefix = backupType == 'automatic' ? 'auto' : 'manual';
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';

    final backupPath = p.join(
      backupDir.path,
      'chicken_tracker_${typePrefix}_${dateStr}_$timeStr.json',
    );

    final birdsData = await db.select(db.birds).get();
    final dailyLogsData = await db.select(db.dailyLogs).get();
    final salesData = await db.select(db.sales).get();
    final expensesData = await db.select(db.expenses).get();
    final flockPurchasesData = await db.select(db.flockPurchases).get();
    final flockLossesData = await db.select(db.flockLosses).get();
    final settingsData = await db.select(db.settings).get();

    final payload = <String, dynamic>{
      'metadata': {
        'app': 'chicken_tracker',
        'version': 1,
        'createdAt': DateTime.now().toIso8601String(),
        'backupType': backupType,
      },
      'birds': birdsData.map((row) => row.toJson()).toList(),
      'dailyLogs': dailyLogsData.map((row) => row.toJson()).toList(),
      'sales': salesData.map((row) => row.toJson()).toList(),
      'expenses': expensesData.map((row) => row.toJson()).toList(),
      'flockPurchases': flockPurchasesData.map((row) => row.toJson()).toList(),
      'flockLosses': flockLossesData.map((row) => row.toJson()).toList(),
      'settings': settingsData.map((row) => row.toJson()).toList(),
    };

    final file = File(backupPath);
    await file.writeAsString(jsonEncode(payload));
    return file;
  }

  static Future<List<FileSystemEntity>> listBackups() async {
    final backupDir = await _backupDirectory();
    final files = backupDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.toLowerCase().endsWith('.json'))
        .toList()
      ..sort((a, b) => b.path.compareTo(a.path));
    return files;
  }

  static Future<int> deleteBackups(List<File> files) async {
    var deletedCount = 0;

    for (final file in files) {
      if (await file.exists()) {
        await file.delete();
        deletedCount++;
      }
    }

    return deletedCount;
  }

  static Future<void> exportBackup(File file) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Chicken Tracker backup',
      subject: 'Chicken Tracker backup file',
    );
  }

  static Future<void> restoreFromBackup(AppDatabase db, File file) async {
    print('[restoreFromBackup] Starting restore from ${file.path}');
    if (!await file.exists()) {
      throw Exception('Backup file not found.');
    }

    final content = await file.readAsString();
    print('[restoreFromBackup] File content length: ${content.length}');
    final parsed = jsonDecode(content);
    if (parsed is! Map<String, dynamic>) {
      throw Exception('Invalid backup format.');
    }

    final birdsData = (parsed['birds'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final dailyLogsData = (parsed['dailyLogs'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final salesData = (parsed['sales'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final expensesData = (parsed['expenses'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final flockPurchasesData =
        (parsed['flockPurchases'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .toList();
    final flockLossesData = (parsed['flockLosses'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final settingsData = (parsed['settings'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();

    print('[restoreFromBackup] Data counts: birds=${birdsData.length}, logs=${dailyLogsData.length}, sales=${salesData.length}, expenses=${expensesData.length}');

    await db.transaction(() async {
      print('[restoreFromBackup] Starting transaction');
      await db.delete(db.dailyLogs).go();
      await db.delete(db.sales).go();
      await db.delete(db.expenses).go();
      await db.delete(db.flockPurchases).go();
      await db.delete(db.flockLosses).go();
      await db.delete(db.settings).go();
      await db.delete(db.birds).go();

      for (final json in birdsData) {
        final row = Bird.fromJson(json);
        await db.into(db.birds).insert(
              BirdsCompanion.insert(
                id: Value(row.id),
                breed: Value(row.breed),
                eggColor: Value(row.eggColor),
                hatchDate: row.hatchDate,
                status: Value(row.status),
                notes: Value(row.notes),
                photoPath: Value(row.photoPath),
              ),
            );
      }

      for (final json in dailyLogsData) {
        final row = DailyLog.fromJson(json);
        await db.into(db.dailyLogs).insert(
              DailyLogsCompanion.insert(
                id: Value(row.id),
                date: row.date,
                layingHens: Value(row.layingHens),
                eggsBrown: Value(row.eggsBrown),
                eggsColored: Value(row.eggsColored),
                eggsWhite: Value(row.eggsWhite),
                notes: Value(row.notes),
              ),
            );
      }

      for (final json in salesData) {
        final row = Sale.fromJson(json);
        await db.into(db.sales).insert(
              SalesCompanion.insert(
                id: Value(row.id),
                date: row.date,
                type: row.type,
                quantity: row.quantity,
                amount: row.amount,
                customerName: Value(row.customerName),
              ),
            );
      }

      for (final json in expensesData) {
        final row = Expense.fromJson(json);
        await db.into(db.expenses).insert(
              ExpensesCompanion.insert(
                id: Value(row.id),
                date: row.date,
                category: row.category,
                amount: row.amount,
                description: Value(row.description),
                pounds: Value(row.pounds),
              ),
            );
      }

      for (final json in flockPurchasesData) {
        final row = FlockPurchase.fromJson(json);
        await db.into(db.flockPurchases).insert(
              FlockPurchasesCompanion.insert(
                id: Value(row.id),
                date: row.date,
                type: row.type,
                quantity: row.quantity,
                cost: row.cost,
                supplier: Value(row.supplier),
                hatchedCount: Value(row.hatchedCount),
              ),
            );
      }

      for (final json in flockLossesData) {
        final row = FlockLossesData.fromJson(json);
        await db.into(db.flockLosses).insert(
              FlockLossesCompanion.insert(
                id: Value(row.id),
                date: row.date,
                type: row.type,
                quantity: row.quantity,
                predatorSubtype: Value(row.predatorSubtype),
              ),
            );
      }

      if (settingsData.isNotEmpty) {
        for (final json in settingsData) {
          final row = Setting.fromJson(json);
          await db.into(db.settings).insert(
                SettingsCompanion.insert(
                  id: Value(row.id),
                  currency: Value(row.currency),
                  weightUnit: Value(row.weightUnit),
                  darkMode: Value(row.darkMode),
                ),
              );
        }
      }
    });
    print('[restoreFromBackup] Transaction completed successfully');
  }

  static Future<void> resetAllData(AppDatabase db) async {
    print('[resetAllData] Starting database reset...');
    try {
      await db.transaction(() async {
        print('[resetAllData] Deleting dailyLogs...');
        await db.delete(db.dailyLogs).go();
        print('[resetAllData] ✓ dailyLogs deleted');
        
        print('[resetAllData] Deleting sales...');
        await db.delete(db.sales).go();
        print('[resetAllData] ✓ sales deleted');
        
        print('[resetAllData] Deleting expenses...');
        await db.delete(db.expenses).go();
        print('[resetAllData] ✓ expenses deleted');
        
        print('[resetAllData] Deleting flockPurchases...');
        await db.delete(db.flockPurchases).go();
        print('[resetAllData] ✓ flockPurchases deleted');
        
        print('[resetAllData] Deleting flockLosses...');
        await db.delete(db.flockLosses).go();
        print('[resetAllData] ✓ flockLosses deleted');
        
        print('[resetAllData] Deleting settings...');
        await db.delete(db.settings).go();
        print('[resetAllData] ✓ settings deleted');
        
        print('[resetAllData] Deleting birds...');
        await db.delete(db.birds).go();
        print('[resetAllData] ✓ birds deleted');

        print('[resetAllData] Inserting default settings...');
        await db.into(db.settings).insert(
          SettingsCompanion.insert(
            id: const Value(1),
            currency: const Value('USD'),
            weightUnit: const Value('lbs'),
            darkMode: const Value(true),
          ),
        );
        print('[resetAllData] ✓ Default settings inserted');
      });
      print('[resetAllData] Transaction completed successfully!');
    } catch (e, stackTrace) {
      print('[resetAllData] ERROR during reset: $e');
      print('[resetAllData] StackTrace: $stackTrace');
      rethrow;
    }
  }

  /// Load sample data from assets for demo purposes
  static Future<void> loadSampleData(AppDatabase db) async {
    print('[BackupService] Starting loadSampleData()');
    try {
      const assetPath = 'assets/Sample Data.json';
      print('[BackupService] Loading asset: $assetPath');
      
      late String jsonString;
      try {
        jsonString = await rootBundle.loadString(assetPath);
        print('[BackupService] Asset loaded successfully, length: ${jsonString.length}');
      } catch (e) {
        print('[BackupService] FAILED to load asset: $e');
        throw Exception(
          'Failed to load $assetPath: $e\n'
          'Make sure the asset is registered in pubspec.yaml under the "assets" section.'
        );
      }
      
      if (jsonString.isEmpty) {
        print('[BackupService] ERROR: Asset is empty');
        throw Exception('Asset $assetPath exists but is empty');
      }
      
      print('[BackupService] Creating temporary file');
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(p.join(tempDir.path, 'sample_data_temp.json'));
      print('[BackupService] Writing JSON to temp file: ${tempFile.path}');
      
      try {
        await tempFile.writeAsString(jsonString);
        print('[BackupService] Temp file written successfully');
      } catch (e) {
        print('[BackupService] FAILED to write temp file: $e');
        throw Exception('Failed to write temp file: $e');
      }
      
      try {
        print('[BackupService] Calling restoreFromBackup()');
        await restoreFromBackup(db, tempFile);
        print('[BackupService] restoreFromBackup() completed successfully');
      } catch (e) {
        print('[BackupService] ERROR in restoreFromBackup(): $e');
        throw Exception('restoreFromBackup failed: $e');
      } finally {
        print('[BackupService] Cleaning up temp file');
        if (await tempFile.exists()) {
          try {
            await tempFile.delete();
            print('[BackupService] Temp file deleted successfully');
          } catch (e) {
            print('[BackupService] Failed to delete temp file: $e');
          }
        } else {
          print('[BackupService] Temp file does not exist (already deleted?)');
        }
      }
      
      print('[BackupService] loadSampleData() completed successfully');
    } catch (e) {
      print('[BackupService] ERROR in loadSampleData(): $e');
      rethrow;
    }
  }
}
