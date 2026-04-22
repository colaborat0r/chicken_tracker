import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for report display settings
/// Allows users to customize which metrics appear on the Farm Report Card
final reportSettingsProvider =
    StateNotifierProvider<ReportSettingsNotifier, ReportSettings>((ref) {
  return ReportSettingsNotifier();
});

/// Manages which report metrics are enabled/disabled
class ReportSettingsNotifier extends StateNotifier<ReportSettings> {
  static const _enabledMetricsKey = 'report_enabled_metrics';

  ReportSettingsNotifier() : super(ReportSettings.defaults()) {
    _load();
  }

  /// Load settings from SharedPreferences
  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getStringList(_enabledMetricsKey);
      if (stored != null) {
        state = ReportSettings.fromStoredList(stored);
      }
    } catch (_) {
      // Ignore errors, use defaults
    }
  }

  /// Update which metrics are enabled
  Future<void> setMetricEnabled(ReportMetric metric, bool enabled) async {
    final updated = state.copyWith(metric: metric, enabled: enabled);
    state = updated;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _enabledMetricsKey,
        updated.toStoredList(),
      );
    } catch (_) {
      // Ignore errors
    }
  }

  /// Reset to defaults
  Future<void> resetToDefaults() async {
    state = ReportSettings.defaults();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _enabledMetricsKey,
        state.toStoredList(),
      );
    } catch (_) {
      // Ignore errors
    }
  }
}

/// Represents which metrics are enabled in the report
class ReportSettings {
  final bool totalEggs;
  final bool totalSales;
  final bool totalExpenses;
  final bool profitLoss;
  final bool flockCount;
  final bool layingCount;
  final bool feedPerEgg;
  final bool layingPercentage;

  ReportSettings({
    required this.totalEggs,
    required this.totalSales,
    required this.totalExpenses,
    required this.profitLoss,
    required this.flockCount,
    required this.layingCount,
    required this.feedPerEgg,
    required this.layingPercentage,
  });

  /// Default settings: Sales, Expenses, Profit/Loss, and Feed/Egg disabled
  factory ReportSettings.defaults() {
    return ReportSettings(
      totalEggs: true,
      totalSales: false, // Disabled by default
      totalExpenses: false, // Disabled by default
      profitLoss: false, // Disabled by default
      flockCount: true,
      layingCount: true,
      feedPerEgg: false, // Disabled by default
      layingPercentage: true,
    );
  }

  /// Convert from stored string list
  factory ReportSettings.fromStoredList(List<String> stored) {
    final map = <String, bool>{};
    for (var item in stored) {
      final parts = item.split(':');
      if (parts.length == 2) {
        map[parts[0]] = parts[1] == 'true';
      }
    }
    return ReportSettings(
      totalEggs: map['totalEggs'] ?? true,
      totalSales: map['totalSales'] ?? false,
      totalExpenses: map['totalExpenses'] ?? false,
      profitLoss: map['profitLoss'] ?? false,
      flockCount: map['flockCount'] ?? true,
      layingCount: map['layingCount'] ?? true,
      feedPerEgg: map['feedPerEgg'] ?? false,
      layingPercentage: map['layingPercentage'] ?? true,
    );
  }

  /// Convert to storable string list format
  List<String> toStoredList() {
    return [
      'totalEggs:$totalEggs',
      'totalSales:$totalSales',
      'totalExpenses:$totalExpenses',
      'profitLoss:$profitLoss',
      'flockCount:$flockCount',
      'layingCount:$layingCount',
      'feedPerEgg:$feedPerEgg',
      'layingPercentage:$layingPercentage',
    ];
  }

  /// Create a copy with one metric updated
  ReportSettings copyWith({
    required ReportMetric metric,
    required bool enabled,
  }) {
    switch (metric) {
      case ReportMetric.totalEggs:
        return ReportSettings(
          totalEggs: enabled,
          totalSales: totalSales,
          totalExpenses: totalExpenses,
          profitLoss: profitLoss,
          flockCount: flockCount,
          layingCount: layingCount,
          feedPerEgg: feedPerEgg,
          layingPercentage: layingPercentage,
        );
      case ReportMetric.totalSales:
        return ReportSettings(
          totalEggs: totalEggs,
          totalSales: enabled,
          totalExpenses: totalExpenses,
          profitLoss: profitLoss,
          flockCount: flockCount,
          layingCount: layingCount,
          feedPerEgg: feedPerEgg,
          layingPercentage: layingPercentage,
        );
      case ReportMetric.totalExpenses:
        return ReportSettings(
          totalEggs: totalEggs,
          totalSales: totalSales,
          totalExpenses: enabled,
          profitLoss: profitLoss,
          flockCount: flockCount,
          layingCount: layingCount,
          feedPerEgg: feedPerEgg,
          layingPercentage: layingPercentage,
        );
      case ReportMetric.profitLoss:
        return ReportSettings(
          totalEggs: totalEggs,
          totalSales: totalSales,
          totalExpenses: totalExpenses,
          profitLoss: enabled,
          flockCount: flockCount,
          layingCount: layingCount,
          feedPerEgg: feedPerEgg,
          layingPercentage: layingPercentage,
        );
      case ReportMetric.flockCount:
        return ReportSettings(
          totalEggs: totalEggs,
          totalSales: totalSales,
          totalExpenses: totalExpenses,
          profitLoss: profitLoss,
          flockCount: enabled,
          layingCount: layingCount,
          feedPerEgg: feedPerEgg,
          layingPercentage: layingPercentage,
        );
      case ReportMetric.layingCount:
        return ReportSettings(
          totalEggs: totalEggs,
          totalSales: totalSales,
          totalExpenses: totalExpenses,
          profitLoss: profitLoss,
          flockCount: flockCount,
          layingCount: enabled,
          feedPerEgg: feedPerEgg,
          layingPercentage: layingPercentage,
        );
      case ReportMetric.feedPerEgg:
        return ReportSettings(
          totalEggs: totalEggs,
          totalSales: totalSales,
          totalExpenses: totalExpenses,
          profitLoss: profitLoss,
          flockCount: flockCount,
          layingCount: layingCount,
          feedPerEgg: enabled,
          layingPercentage: layingPercentage,
        );
      case ReportMetric.layingPercentage:
        return ReportSettings(
          totalEggs: totalEggs,
          totalSales: totalSales,
          totalExpenses: totalExpenses,
          profitLoss: profitLoss,
          flockCount: flockCount,
          layingCount: layingCount,
          feedPerEgg: feedPerEgg,
          layingPercentage: enabled,
        );
    }
  }

  /// Get the enabled status of a metric
  bool isEnabled(ReportMetric metric) {
    switch (metric) {
      case ReportMetric.totalEggs:
        return totalEggs;
      case ReportMetric.totalSales:
        return totalSales;
      case ReportMetric.totalExpenses:
        return totalExpenses;
      case ReportMetric.profitLoss:
        return profitLoss;
      case ReportMetric.flockCount:
        return flockCount;
      case ReportMetric.layingCount:
        return layingCount;
      case ReportMetric.feedPerEgg:
        return feedPerEgg;
      case ReportMetric.layingPercentage:
        return layingPercentage;
    }
  }
}

/// Enum for each report metric
enum ReportMetric {
  totalEggs,
  totalSales,
  totalExpenses,
  profitLoss,
  flockCount,
  layingCount,
  feedPerEgg,
  layingPercentage,
}

/// Extension for metric display info
extension ReportMetricDisplay on ReportMetric {
  String get label {
    switch (this) {
      case ReportMetric.totalEggs:
        return '🥚 Total Eggs';
      case ReportMetric.totalSales:
        return '💰 Total Sales';
      case ReportMetric.totalExpenses:
        return '💸 Total Expenses';
      case ReportMetric.profitLoss:
        return '📊 Profit/Loss';
      case ReportMetric.flockCount:
        return '🐔 Flock Count';
      case ReportMetric.layingCount:
        return '🥚 Laying Hens';
      case ReportMetric.feedPerEgg:
        return '🌾 Feed per Egg';
      case ReportMetric.layingPercentage:
        return '📈 Laying %';
    }
  }

  String get description {
    switch (this) {
      case ReportMetric.totalEggs:
        return 'Total eggs collected this month';
      case ReportMetric.totalSales:
        return 'Total sales revenue this month';
      case ReportMetric.totalExpenses:
        return 'Total expenses this month';
      case ReportMetric.profitLoss:
        return 'Net profit or loss for the month';
      case ReportMetric.flockCount:
        return 'Current number of chickens';
      case ReportMetric.layingCount:
        return 'Number of hens currently laying';
      case ReportMetric.feedPerEgg:
        return 'Average feed cost per egg';
      case ReportMetric.layingPercentage:
        return 'Percentage of flock that is laying';
    }
  }
}

