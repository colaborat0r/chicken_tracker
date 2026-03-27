import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../models/report_model.dart';

/// Service for exporting reports to CSV format
class CsvExportService {
  /// Generate a CSV report and return the file
  static Future<File> generateCsv(ProductionReport report) async {
    final summary = report.summary;
    
    // Build CSV data as List<List<dynamic>>
    final List<List<dynamic>> csvData = [];

    // Header information
    csvData.add(['Chicken Tracker Production Report']);
    csvData.add(['Generated', DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())]);
    csvData.add(['Report Type', summary.title]);
    csvData.add(['Period', report.dateRangeDisplay]);
    csvData.add([]); // Empty row for spacing

    // Summary section
    csvData.add(['SUMMARY STATISTICS']);
    csvData.add(['Metric', 'Value']);
    csvData.add(['Total Eggs', summary.totalEggs]);
    csvData.add(['Brown Eggs', '${summary.totalBrownEggs} (${summary.brownPercentage.toStringAsFixed(1)}%)']);
    csvData.add(['Colored Eggs', '${summary.totalColoredEggs} (${summary.coloredPercentage.toStringAsFixed(1)}%)']);
    csvData.add(['White Eggs', '${summary.totalWhiteEggs} (${summary.whitePercentage.toStringAsFixed(1)}%)']);
    csvData.add(['Average Eggs/Day', summary.averageEggsPerDay.toStringAsFixed(2)]);
    csvData.add(['Average Eggs/Hen', summary.averageEggsPerHen.toStringAsFixed(2)]);
    csvData.add(['Average Production %', '${summary.averageProductionPercentage.toStringAsFixed(1)}%']);
    csvData.add(['Days with Data', summary.daysWithData]);
    
    if (summary.peakEggsDay != null) {
      csvData.add(['Peak Day', '${summary.peakEggsDay!.formattedDate} (${summary.peakEggsDay!.totalEggs} eggs)']);
    }
    
    if (summary.lowestEggsDay != null) {
      csvData.add(['Lowest Day', '${summary.lowestEggsDay!.formattedDate} (${summary.lowestEggsDay!.totalEggs} eggs)']);
    }
    
    csvData.add([]); // Empty row for spacing

    // Daily details section
    if (report.lineItems.isNotEmpty) {
      csvData.add(['DAILY DETAILS']);
      csvData.add([
        'Date',
        'Day',
        'Total Eggs',
        'Brown',
        'Colored',
        'White',
        'Laying Hens',
        'Eggs/Hen',
        'Production %',
        'Notes',
      ]);

      for (var item in report.lineItems) {
        final dayOfWeek = DateFormat('EEEE').format(item.date);
        csvData.add([
          item.formattedDate,
          dayOfWeek,
          item.totalEggs,
          item.brownEggs,
          item.coloredEggs,
          item.whiteEggs,
          item.layingHens,
          item.eggsPerHen.toStringAsFixed(2),
          '${item.productionPercentage.toStringAsFixed(1)}%',
          item.notes ?? '',
        ]);
      }
    }

    // Convert to CSV string
    final csvContent = const ListToCsvConverter().convert(csvData);

    // Save to file
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'Production_Report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(csvContent);
    return file;
  }

  /// Generate a simplified CSV for flock inventory
  static Future<File> generateFlockInventoryCsv(
    List<FlockInventoryItem> flockData,
  ) async {
    final List<List<dynamic>> csvData = [];

    // Header
    csvData.add(['Chicken Tracker - Flock Inventory']);
    csvData.add(['Generated', DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())]);
    csvData.add([]); // Empty row

    // Flock data header
    csvData.add([
      'Breed',
      'Egg Color',
      'Hatch Date',
      'Age (Days)',
      'Age (Months)',
      'Status',
      'Notes',
    ]);

    // Flock data rows
    for (var item in flockData) {
      csvData.add([
        item.breed,
        item.eggColor,
        item.formattedHatchDate,
        item.ageInDays,
        item.ageInMonths,
        item.status,
        item.notes ?? '',
      ]);
    }

    final csvContent = const ListToCsvConverter().convert(csvData);
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'Flock_Inventory_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(csvContent);
    return file;
  }
}

/// Simple model for flock inventory export
class FlockInventoryItem {
  final String breed;
  final String? eggColor;
  final DateTime hatchDate;
  final String status;
  final String? notes;

  FlockInventoryItem({
    required this.breed,
    this.eggColor,
    required this.hatchDate,
    required this.status,
    this.notes,
  });

  int get ageInDays => DateTime.now().difference(hatchDate).inDays;
  int get ageInMonths => ageInDays ~/ 30;
  String get formattedHatchDate => DateFormat('MMM d, yyyy').format(hatchDate);
}
