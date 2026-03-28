import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../models/report_model.dart';

/// Service for exporting reports to CSV format
class CsvExportService {
  /// Generate a CSV report and return the file
  static Future<File> generateCsv(dynamic report) async {
    if (report is ProductionReport) {
      return _generateProductionCsv(report);
    } else if (report is SalesReport) {
      return _generateSalesCsv(report);
    } else if (report is ExpensesReport) {
      return _generateExpensesCsv(report);
    } else if (report is FlockPurchasesReport) {
      return _generateFlockPurchasesCsv(report);
    } else if (report is FlockLossesReport) {
      return _generateFlockLossesCsv(report);
    } else {
      throw UnsupportedError('Unsupported report type: ${report.runtimeType}');
    }
  }

  /// Generate production CSV
  static Future<File> _generateProductionCsv(ProductionReport report) async {
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

  /// Generate sales CSV
  static Future<File> _generateSalesCsv(SalesReport report) async {
    final List<List<dynamic>> csvData = [];

    // Header information
    csvData.add(['Chicken Tracker Sales Report']);
    csvData.add(['Generated', DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())]);
    csvData.add(['Report Type', report.title]);
    csvData.add(['Period', report.dateRangeDisplay]);
    csvData.add([]); // Empty row for spacing

    // Summary section
    csvData.add(['SUMMARY STATISTICS']);
    csvData.add(['Metric', 'Value']);
    csvData.add(['Total Revenue', '\$${report.totalRevenue.toStringAsFixed(2)}']);
    csvData.add(['Total Eggs Sold', report.totalEggsSold]);
    csvData.add(['Total Chickens Sold', report.totalChickensSold]);
    csvData.add([]); // Empty row for spacing

    // Sales details section
    if (report.lineItems.isNotEmpty) {
      csvData.add(['SALES DETAILS']);
      csvData.add([
        'Date',
        'Type',
        'Quantity',
        'Unit Price',
        'Amount',
        'Customer',
      ]);

      for (var item in report.lineItems) {
        csvData.add([
          item.formattedDate,
          item.type,
          item.quantity,
          '\$${item.unitPrice.toStringAsFixed(2)}',
          '\$${item.amount.toStringAsFixed(2)}',
          item.customerName ?? '',
        ]);
      }
    }

    // Convert to CSV string
    final csvContent = const ListToCsvConverter().convert(csvData);

    // Save to file
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'Sales_Report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(csvContent);
    return file;
  }

  /// Generate expenses CSV
  static Future<File> _generateExpensesCsv(ExpensesReport report) async {
    final List<List<dynamic>> csvData = [];

    // Header information
    csvData.add(['Chicken Tracker Expenses Report']);
    csvData.add(['Generated', DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())]);
    csvData.add(['Report Type', report.title]);
    csvData.add(['Period', report.dateRangeDisplay]);
    csvData.add([]); // Empty row for spacing

    // Summary section
    csvData.add(['SUMMARY STATISTICS']);
    csvData.add(['Metric', 'Value']);
    csvData.add(['Total Expenses', '\$${report.totalExpenses.toStringAsFixed(2)}']);
    csvData.add([]); // Empty row for spacing

    // Category breakdown
    if (report.categoryBreakdown.isNotEmpty) {
      csvData.add(['EXPENSES BY CATEGORY']);
      csvData.add(['Category', 'Amount']);
      for (var entry in report.categoryBreakdown.entries) {
        csvData.add([entry.key, '\$${entry.value.toStringAsFixed(2)}']);
      }
      csvData.add([]); // Empty row for spacing
    }

    // Expense details section
    if (report.lineItems.isNotEmpty) {
      csvData.add(['EXPENSE DETAILS']);
      csvData.add([
        'Date',
        'Category',
        'Amount',
        'Description',
        'Pounds',
        'Cost per Pound',
      ]);

      for (var item in report.lineItems) {
        csvData.add([
          item.formattedDate,
          item.category,
          '\$${item.amount.toStringAsFixed(2)}',
          item.description ?? '',
          item.pounds?.toStringAsFixed(2) ?? '',
          item.costPerPound != null ? '\$${item.costPerPound!.toStringAsFixed(2)}' : '',
        ]);
      }
    }

    // Convert to CSV string
    final csvContent = const ListToCsvConverter().convert(csvData);

    // Save to file
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'Expenses_Report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(csvContent);
    return file;
  }

  /// Generate flock purchases CSV
  static Future<File> _generateFlockPurchasesCsv(FlockPurchasesReport report) async {
    final List<List<dynamic>> csvData = [];

    // Header information
    csvData.add(['Chicken Tracker Flock Purchases Report']);
    csvData.add(['Generated', DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())]);
    csvData.add(['Report Type', report.title]);
    csvData.add(['Period', report.dateRangeDisplay]);
    csvData.add([]); // Empty row for spacing

    // Summary section
    csvData.add(['SUMMARY STATISTICS']);
    csvData.add(['Metric', 'Value']);
    csvData.add(['Total Cost', '\$${report.totalCost.toStringAsFixed(2)}']);
    csvData.add(['Total Chicks Purchased', report.totalChicksPurchased]);
    csvData.add(['Total Eggs Purchased', report.totalEggsPurchased]);
    csvData.add([]); // Empty row for spacing

    // Purchase details section
    if (report.lineItems.isNotEmpty) {
      csvData.add(['PURCHASE DETAILS']);
      csvData.add([
        'Date',
        'Type',
        'Quantity',
        'Cost per Unit',
        'Total Cost',
        'Supplier',
        'Hatched Count',
        'Hatch Rate',
      ]);

      for (var item in report.lineItems) {
        csvData.add([
          item.formattedDate,
          item.type,
          item.quantity,
          '\$${item.costPerUnit.toStringAsFixed(2)}',
          '\$${item.cost.toStringAsFixed(2)}',
          item.supplier ?? '',
          item.hatchedCount ?? '',
          item.hatchRate != null ? '${item.hatchRate!.toStringAsFixed(1)}%' : '',
        ]);
      }
    }

    // Convert to CSV string
    final csvContent = const ListToCsvConverter().convert(csvData);

    // Save to file
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'Flock_Purchases_Report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(csvContent);
    return file;
  }

  /// Generate flock losses CSV
  static Future<File> _generateFlockLossesCsv(FlockLossesReport report) async {
    final List<List<dynamic>> csvData = [];

    // Header information
    csvData.add(['Chicken Tracker Flock Losses Report']);
    csvData.add(['Generated', DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())]);
    csvData.add(['Report Type', report.title]);
    csvData.add(['Period', report.dateRangeDisplay]);
    csvData.add([]); // Empty row for spacing

    // Summary section
    csvData.add(['SUMMARY STATISTICS']);
    csvData.add(['Metric', 'Value']);
    csvData.add(['Total Losses', report.totalLosses]);
    csvData.add([]); // Empty row for spacing

    // Losses by type
    if (report.lossesByType.isNotEmpty) {
      csvData.add(['LOSSES BY TYPE']);
      csvData.add(['Type', 'Count']);
      for (var entry in report.lossesByType.entries) {
        csvData.add([entry.key, entry.value]);
      }
      csvData.add([]); // Empty row for spacing
    }

    // Loss details section
    if (report.lineItems.isNotEmpty) {
      csvData.add(['LOSS DETAILS']);
      csvData.add([
        'Date',
        'Type',
        'Quantity',
        'Predator Subtype',
      ]);

      for (var item in report.lineItems) {
        csvData.add([
          item.formattedDate,
          item.type,
          item.quantity,
          item.predatorSubtype ?? '',
        ]);
      }
    }

    // Convert to CSV string
    final csvContent = const ListToCsvConverter().convert(csvData);

    // Save to file
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'Flock_Losses_Report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
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
