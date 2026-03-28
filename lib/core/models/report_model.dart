// Report models for exporting production data

import 'package:intl/intl.dart';

/// Enum for different report types
enum ReportType {
  daily('Daily Production Report'),
  weekly('Weekly Production Report'),
  monthly('Monthly Production Report'),
  quarterly('Quarterly Production Report'),
  annual('Annual Production Report');

  final String displayName;
  const ReportType(this.displayName);
}

/// Enum for export formats
enum ExportFormat {
  pdf('PDF'),
  csv('CSV');

  final String displayName;
  const ExportFormat(this.displayName);
}

/// A single report line item
class ReportLineItem {
  final DateTime date;
  final int totalEggs;
  final int brownEggs;
  final int coloredEggs;
  final int whiteEggs;
  final int layingHens;
  final double eggsPerHen;
  final double productionPercentage;
  final String? notes;

  ReportLineItem({
    required this.date,
    required this.totalEggs,
    required this.brownEggs,
    required this.coloredEggs,
    required this.whiteEggs,
    required this.layingHens,
    required this.eggsPerHen,
    required this.productionPercentage,
    this.notes,
  });

  /// Format date as string
  String get formattedDate => DateFormat('MMM d, yyyy').format(date);
  
  /// Format date with day of week
  String get formattedDateWithDay => DateFormat('EEE, MMM d, yyyy').format(date);
}

/// Production report with summary and line items
class ProductionReport {
  final ReportType reportType;
  final DateTime startDate;
  final DateTime endDate;
  final List<ReportLineItem> lineItems;
  final String title;

  ProductionReport({
    required this.reportType,
    required this.startDate,
    required this.endDate,
    required this.lineItems,
    required this.title,
  });

  /// Generate report summary statistics
  ReportSummary get summary => ReportSummary(
    reportType: reportType,
    startDate: startDate,
    endDate: endDate,
    totalEggs: lineItems.fold<int>(0, (sum, item) => sum + item.totalEggs),
    totalBrownEggs: lineItems.fold<int>(0, (sum, item) => sum + item.brownEggs),
    totalColoredEggs: lineItems.fold<int>(0, (sum, item) => sum + item.coloredEggs),
    totalWhiteEggs: lineItems.fold<int>(0, (sum, item) => sum + item.whiteEggs),
    averageEggsPerDay: lineItems.isEmpty 
      ? 0 
      : lineItems.fold<int>(0, (sum, item) => sum + item.totalEggs) / lineItems.length,
    averageEggsPerHen: lineItems.isEmpty
      ? 0
      : lineItems.fold<double>(0, (sum, item) => sum + item.eggsPerHen) / lineItems.length,
    averageProductionPercentage: lineItems.isEmpty
      ? 0
      : lineItems.fold<double>(0, (sum, item) => sum + item.productionPercentage) / lineItems.length,
    daysWithData: lineItems.length,
    peakEggsDay: lineItems.isEmpty 
      ? null 
      : lineItems.reduce((a, b) => a.totalEggs > b.totalEggs ? a : b),
    lowestEggsDay: lineItems.isEmpty
      ? null
      : lineItems.reduce((a, b) => a.totalEggs < b.totalEggs ? a : b),
  );

  /// Get date range display string
  String get dateRangeDisplay {
    final formatter = DateFormat('MMM d, yyyy');
    if (startDate.year == endDate.year && 
        startDate.month == endDate.month && 
        startDate.day == endDate.day) {
      return formatter.format(startDate);
    }
    return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
  }
}

/// Summary statistics for a report
class ReportSummary {
  final ReportType reportType;
  final DateTime startDate;
  final DateTime endDate;
  final int totalEggs;
  final int totalBrownEggs;
  final int totalColoredEggs;
  final int totalWhiteEggs;
  final double averageEggsPerDay;
  final double averageEggsPerHen;
  final double averageProductionPercentage;
  final int daysWithData;
  final ReportLineItem? peakEggsDay;
  final ReportLineItem? lowestEggsDay;

  ReportSummary({
    required this.reportType,
    required this.startDate,
    required this.endDate,
    required this.totalEggs,
    required this.totalBrownEggs,
    required this.totalColoredEggs,
    required this.totalWhiteEggs,
    required this.averageEggsPerDay,
    required this.averageEggsPerHen,
    required this.averageProductionPercentage,
    required this.daysWithData,
    this.peakEggsDay,
    this.lowestEggsDay,
  });

  /// Get brown eggs percentage
  double get brownPercentage => totalEggs == 0 ? 0 : (totalBrownEggs / totalEggs) * 100;

  /// Get colored eggs percentage
  double get coloredPercentage => totalEggs == 0 ? 0 : (totalColoredEggs / totalEggs) * 100;

  /// Get white eggs percentage
  double get whitePercentage => totalEggs == 0 ? 0 : (totalWhiteEggs / totalEggs) * 100;

  /// Format title for display
  String get title => reportType.displayName;
}

/// Monthly breakdown item for reports
class MonthlyBreakdown {
  final int month;
  final int year;
  final int totalEggs;
  final int daysWithData;
  final double averageEggsPerDay;

  MonthlyBreakdown({
    required this.month,
    required this.year,
    required this.totalEggs,
    required this.daysWithData,
    required this.averageEggsPerDay,
  });

  String get monthName {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String get displayText => '$monthName $year';
}

/// Sales report line item
class SalesReportLineItem {
  final DateTime date;
  final String type;
  final int quantity;
  final double amount;
  final double unitPrice;
  final String? customerName;

  SalesReportLineItem({
    required this.date,
    required this.type,
    required this.quantity,
    required this.amount,
    required this.unitPrice,
    this.customerName,
  });

  String get formattedDate => DateFormat('MMM d, yyyy').format(date);
}

/// Sales report
class SalesReport {
  final DateTime startDate;
  final DateTime endDate;
  final List<SalesReportLineItem> lineItems;
  final String title;
  final double totalRevenue;
  final int totalEggsSold;
  final int totalChickensSold;

  SalesReport({
    required this.startDate,
    required this.endDate,
    required this.lineItems,
    required this.title,
    required this.totalRevenue,
    required this.totalEggsSold,
    required this.totalChickensSold,
  });

  String get dateRangeDisplay {
    final formatter = DateFormat('MMM d, yyyy');
    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day) {
      return formatter.format(startDate);
    }
    return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
  }
}

/// Expenses report line item
class ExpensesReportLineItem {
  final DateTime date;
  final String category;
  final double amount;
  final String? description;
  final double? pounds;
  final double? costPerPound;

  ExpensesReportLineItem({
    required this.date,
    required this.category,
    required this.amount,
    this.description,
    this.pounds,
    this.costPerPound,
  });

  String get formattedDate => DateFormat('MMM d, yyyy').format(date);
}

/// Expenses report
class ExpensesReport {
  final DateTime startDate;
  final DateTime endDate;
  final List<ExpensesReportLineItem> lineItems;
  final String title;
  final double totalExpenses;
  final Map<String, double> categoryBreakdown;

  ExpensesReport({
    required this.startDate,
    required this.endDate,
    required this.lineItems,
    required this.title,
    required this.totalExpenses,
    required this.categoryBreakdown,
  });

  String get dateRangeDisplay {
    final formatter = DateFormat('MMM d, yyyy');
    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day) {
      return formatter.format(startDate);
    }
    return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
  }
}

/// Flock purchases report line item
class FlockPurchasesReportLineItem {
  final DateTime date;
  final String type;
  final int quantity;
  final double cost;
  final double costPerUnit;
  final String? supplier;
  final int? hatchedCount;
  final double? hatchRate;

  FlockPurchasesReportLineItem({
    required this.date,
    required this.type,
    required this.quantity,
    required this.cost,
    required this.costPerUnit,
    this.supplier,
    this.hatchedCount,
    this.hatchRate,
  });

  String get formattedDate => DateFormat('MMM d, yyyy').format(date);
}

/// Flock purchases report
class FlockPurchasesReport {
  final DateTime startDate;
  final DateTime endDate;
  final List<FlockPurchasesReportLineItem> lineItems;
  final String title;
  final double totalCost;
  final int totalChicksPurchased;
  final int totalEggsPurchased;

  FlockPurchasesReport({
    required this.startDate,
    required this.endDate,
    required this.lineItems,
    required this.title,
    required this.totalCost,
    required this.totalChicksPurchased,
    required this.totalEggsPurchased,
  });

  String get dateRangeDisplay {
    final formatter = DateFormat('MMM d, yyyy');
    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day) {
      return formatter.format(startDate);
    }
    return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
  }
}

/// Flock losses report line item
class FlockLossesReportLineItem {
  final DateTime date;
  final String type;
  final int quantity;
  final String? predatorSubtype;

  FlockLossesReportLineItem({
    required this.date,
    required this.type,
    required this.quantity,
    this.predatorSubtype,
  });

  String get formattedDate => DateFormat('MMM d, yyyy').format(date);
}

/// Flock losses report
class FlockLossesReport {
  final DateTime startDate;
  final DateTime endDate;
  final List<FlockLossesReportLineItem> lineItems;
  final String title;
  final int totalLosses;
  final Map<String, int> lossesByType;

  FlockLossesReport({
    required this.startDate,
    required this.endDate,
    required this.lineItems,
    required this.title,
    required this.totalLosses,
    required this.lossesByType,
  });

  String get dateRangeDisplay {
    final formatter = DateFormat('MMM d, yyyy');
    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day) {
      return formatter.format(startDate);
    }
    return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
  }
}
