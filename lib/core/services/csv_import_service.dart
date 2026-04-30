import 'dart:io';
import 'package:csv/csv.dart';
import 'package:drift/drift.dart' show Value;
import 'package:intl/intl.dart';
import '../database/app_database.dart';

/// Service for importing data from CSV files
class CsvImportService {
  /// Import production data from CSV
  static Future<Map<String, dynamic>> importProductionCsv(
    File file,
    AppDatabase db,
  ) async {
    final content = await file.readAsString();
    final rows = const CsvToListConverter().convert(content);

    int imported = 0;
    int skipped = 0;
    final errors = <String>[];

    // Find the header row (DAILY DETAILS)
    int startIndex = 0;
    for (int i = 0; i < rows.length; i++) {
      if (rows[i].isNotEmpty && rows[i][0].toString().contains('Date')) {
        startIndex = i + 1;
        break;
      }
    }

    // Process data rows
    for (int i = startIndex; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 7 || row[0].toString().isEmpty) continue;

      try {
        final dateStr = row[0].toString();
        final date = _parseDate(dateStr);
        if (date == null) {
          skipped++;
          continue;
        }

        final layingHens = _parseInt(row[6]) ?? 0;
        final brownEggs = _parseInt(row[2]) ?? 0;
        final coloredEggs = _parseInt(row[4]) ?? 0;
        final whiteEggs = _parseInt(row[5]) ?? 0;

        // Check if entry already exists
        final existing = await db.getDailyLogByDate(date);
        if (existing != null) {
          skipped++;
          continue;
        }

        // Insert the daily log
        await db.into(db.dailyLogs).insert(DailyLogsCompanion(
          date: Value(date),
          layingHens: Value(layingHens),
          eggsBrown: Value(brownEggs),
          eggsColored: Value(coloredEggs),
          eggsWhite: Value(whiteEggs),
        ));

        imported++;
      } catch (e) {
        skipped++;
        errors.add('Row ${i + 1}: ${e.toString()}');
      }
    }

    return {
      'imported': imported,
      'skipped': skipped,
      'errors': errors,
    };
  }

  /// Import chicken flock inventory from CSV
  static Future<Map<String, dynamic>> importFlockInventoryCsv(
    File file,
    AppDatabase db,
  ) async {
    final content = await file.readAsString();
    final rows = const CsvToListConverter().convert(content);

    int imported = 0;
    int skipped = 0;
    final errors = <String>[];

    // Find the header row
    int startIndex = 0;
    for (int i = 0; i < rows.length; i++) {
      if (rows[i].isNotEmpty && rows[i][0].toString().contains('Breed')) {
        startIndex = i + 1;
        break;
      }
    }

    // Process data rows
    for (int i = startIndex; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 4 || row[0].toString().isEmpty) continue;

      try {
        final breed = row[0].toString().trim();
        final eggColor = row[1].toString().trim().isEmpty ? null : row[1].toString().trim().toLowerCase();
        final hatchDateStr = row[2].toString().trim();
        final hatchDate = _parseDate(hatchDateStr);

        if (breed.isEmpty || hatchDate == null) {
          skipped++;
          continue;
        }

        final status = row.length > 5 ? row[5].toString().trim().toLowerCase() : 'laying';
        final notes = row.length > 6 ? row[6].toString().trim() : null;

        // Insert the bird
        await db.into(db.birds).insert(BirdsCompanion(
          breed: Value(breed),
          eggColor: Value(eggColor),
          hatchDate: Value(hatchDate),
          status: Value(status),
          notes: Value(notes),
        ));

        imported++;
      } catch (e) {
        skipped++;
        errors.add('Row ${i + 1}: ${e.toString()}');
      }
    }

    return {
      'imported': imported,
      'skipped': skipped,
      'errors': errors,
    };
  }

  /// Parse date from various formats
  static DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) return null;

    // Try ISO 8601 parsing first
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      // Continue to other formats
    }

    // Try various date formats using intl
    final formats = [
      'M/d/yyyy',
      'MM/dd/yyyy',
      'd MMM yyyy',
      'MMM d, yyyy',
      'MMM dd, yyyy',
    ];

    for (final fmt in formats) {
      try {
        return DateFormat(fmt).parseStrict(dateStr);
      } catch (_) {
        // Try next format
      }
    }

    return null;
  }

  /// Parse integer, handling various formats
  static int? _parseInt(dynamic value) {
    if (value == null || value.toString().isEmpty) return null;
    try {
      return int.parse(value.toString().trim());
    } catch (e) {
      return null;
    }
  }
}

