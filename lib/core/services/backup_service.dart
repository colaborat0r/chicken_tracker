import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
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

  static Future<File> createBackup(AppDatabase db) async {
    final backupDir = await _backupDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final backupPath = p.join(
      backupDir.path,
      'chicken_tracker_backup_$timestamp.json',
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

  static Future<void> exportBackup(File file) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Chicken Tracker backup',
      subject: 'Chicken Tracker backup file',
    );
  }

  static Future<void> restoreFromBackup(AppDatabase db, File file) async {
    if (!await file.exists()) {
      throw Exception('Backup file not found.');
    }

    final content = await file.readAsString();
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

    await db.transaction(() async {
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
  }

  static Future<void> resetAllData(AppDatabase db) async {
    await db.transaction(() async {
      await db.delete(db.dailyLogs).go();
      await db.delete(db.sales).go();
      await db.delete(db.expenses).go();
      await db.delete(db.flockPurchases).go();
      await db.delete(db.flockLosses).go();
      await db.delete(db.settings).go();
      await db.delete(db.birds).go();

      await db.into(db.settings).insert(
        SettingsCompanion.insert(
              id: Value(1),
              currency: Value('USD'),
              weightUnit: Value('lbs'),
              darkMode: Value(true),
            ),
          );
    });
  }
}
