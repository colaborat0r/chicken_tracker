import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chicken_model.dart';
import 'database_providers.dart';

// Chart view mode enum
enum ChartViewMode { line, bar }

/// Statistics range enum for overall stats
enum StatsRange { sevenDays, thirtyDays, ninetyDays, yearToDate, allTime }

/// Provider for tracking which chart view mode is selected (line or bar)
final chartViewModeProvider = StateProvider<ChartViewMode>((ref) => ChartViewMode.bar);

/// Provider for tracking which statistics range is selected
final statsRangeProvider = StateProvider<StatsRange>((ref) => StatsRange.allTime);

/// Helper function to get the start of the week (Monday)
DateTime _getWeekStart(DateTime date) {
  final dayOfWeek = date.weekday; // 1 = Monday, 7 = Sunday
  return date.subtract(Duration(days: dayOfWeek - 1));
}

/// Helper function to get the last day of a month (correct leap year handling)
int _getLastDayOfMonth(int year, int month) {
  if (month == DateTime.february) {
    final isLeap =
        (year % 4 == 0) && (year % 100 != 0 || year % 400 == 0);
    return isLeap ? 29 : 28;
  }
  const daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  return daysInMonth[month - 1];
}

/// Provider for weekly production summary for a specific week
final weeklyProductionProvider =
    FutureProvider.family<WeeklyProductionSummary, DateTime>((ref, date) async {
  final logs = await ref.watch(allDailyLogsProvider.future);
  final weekStart = _getWeekStart(date);
  final weekEnd = weekStart.add(const Duration(days: 7));

  final weeklyLogs = logs
      .where((log) =>
          log.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          log.date.isBefore(weekEnd))
      .toList();

  if (weeklyLogs.isEmpty) {
    return WeeklyProductionSummary(
      weekStart: weekStart,
      totalEggs: 0,
      totalDays: 0,
      averageEggsPerDay: 0,
      averageEggsPerHen: 0,
      maxEggsInDay: 0,
      minEggsInDay: 0,
      totalBrownEggs: 0,
      totalColoredEggs: 0,
      totalWhiteEggs: 0,
    );
  }

  int totalEggs = 0;
  int totalBrownEggs = 0;
  int totalColoredEggs = 0;
  int totalWhiteEggs = 0;
  int maxEggs = 0;
  int minEggs = 999999;
  double totalHenDays = 0;

  for (var log in weeklyLogs) {
    totalEggs += log.totalEggs;
    totalBrownEggs += log.eggsBrown;
    totalColoredEggs += log.eggsColored;
    totalWhiteEggs += log.eggsWhite;
    maxEggs = log.totalEggs > maxEggs ? log.totalEggs : maxEggs;
    minEggs = log.totalEggs < minEggs ? log.totalEggs : minEggs;
    totalHenDays += log.layingHens;
  }

  minEggs = minEggs == 999999 ? 0 : minEggs;

  return WeeklyProductionSummary(
    weekStart: weekStart,
    totalEggs: totalEggs,
    totalDays: weeklyLogs.length,
    averageEggsPerDay: weeklyLogs.isEmpty ? 0 : totalEggs / weeklyLogs.length,
    averageEggsPerHen:
        totalHenDays == 0 ? 0 : totalEggs / totalHenDays,
    maxEggsInDay: maxEggs,
    minEggsInDay: minEggs,
    totalBrownEggs: totalBrownEggs,
    totalColoredEggs: totalColoredEggs,
    totalWhiteEggs: totalWhiteEggs,
  );
});

/// Provider for monthly production summary
final monthlyProductionProvider = FutureProvider.family<MonthlyProductionSummary, DateTime>((ref, date) async {
  final logs = await ref.watch(allDailyLogsProvider.future);
  final year = date.year;
  final month = date.month;
  final lastDay = _getLastDayOfMonth(year, month);
  
  final monthStart = DateTime(year, month, 1);
  final monthEnd = DateTime(year, month, lastDay + 1);

  final monthlyLogs = logs
      .where((log) =>
          log.date.isAfter(monthStart.subtract(const Duration(days: 1))) &&
          log.date.isBefore(monthEnd))
      .toList();

  if (monthlyLogs.isEmpty) {
    return MonthlyProductionSummary(
      year: year,
      month: month,
      totalEggs: 0,
      totalDays: 0,
      averageEggsPerDay: 0,
      averageEggsPerHen: 0,
      maxEggsInDay: 0,
      minEggsInDay: 0,
      totalBrownEggs: 0,
      totalColoredEggs: 0,
      totalWhiteEggs: 0,
    );
  }

  int totalEggs = 0;
  int totalBrownEggs = 0;
  int totalColoredEggs = 0;
  int totalWhiteEggs = 0;
  int maxEggs = 0;
  int minEggs = 999999;
  double totalHenDays = 0;

  for (var log in monthlyLogs) {
    totalEggs += log.totalEggs;
    totalBrownEggs += log.eggsBrown;
    totalColoredEggs += log.eggsColored;
    totalWhiteEggs += log.eggsWhite;
    maxEggs = log.totalEggs > maxEggs ? log.totalEggs : maxEggs;
    minEggs = log.totalEggs < minEggs ? log.totalEggs : minEggs;
    totalHenDays += log.layingHens;
  }

  minEggs = minEggs == 999999 ? 0 : minEggs;

  return MonthlyProductionSummary(
    year: year,
    month: month,
    totalEggs: totalEggs,
    totalDays: monthlyLogs.length,
    averageEggsPerDay: monthlyLogs.isEmpty ? 0 : totalEggs / monthlyLogs.length,
    averageEggsPerHen: totalHenDays == 0 ? 0 : totalEggs / totalHenDays,
    maxEggsInDay: maxEggs,
    minEggsInDay: minEggs,
    totalBrownEggs: totalBrownEggs,
    totalColoredEggs: totalColoredEggs,
    totalWhiteEggs: totalWhiteEggs,
  );
});

/// Provider for production trend data (last N days)
final productionTrendProvider =
    FutureProvider.family<List<ProductionTrendPoint>, int>((ref, days) async {
  final logs = await ref.watch(allDailyLogsProvider.future);
  final now = DateTime.now();
  final startDate = now.subtract(Duration(days: days));

  final trendLogs = logs
      .where((log) => log.date.isAfter(startDate) && log.date.isBefore(now.add(const Duration(days: 1))))
      .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

  return trendLogs
      .map((log) => ProductionTrendPoint(
            date: log.date,
            eggs: log.totalEggs,
            eggsPerHen: log.eggsPerHen,
            layingHens: log.layingHens,
          ))
      .toList();
});

/// Provider for all weeks in the last 12 weeks
final last12WeeksProvider = FutureProvider<List<WeeklyProductionSummary>>((ref) async {
  final List<WeeklyProductionSummary> weeks = [];
  final now = DateTime.now();
  
  for (int i = 11; i >= 0; i--) {
    final weekDate = now.subtract(Duration(days: i * 7));
    final summary = await ref.watch(weeklyProductionProvider(weekDate).future);
    weeks.add(summary);
  }
  
  return weeks;
});

/// Provider for all months in the last 12 months
final last12MonthsProvider = FutureProvider<List<MonthlyProductionSummary>>((ref) async {
  final List<MonthlyProductionSummary> months = [];
  final now = DateTime.now();
  
  for (int i = 0; i < 12; i++) {
    var monthDate = DateTime(now.year, now.month - i, 1);
    final summary = await ref.watch(monthlyProductionProvider(monthDate).future);
    months.add(summary);
  }
  
  return months;
});

/// Provider for production stats summary
final productionStatsSummaryProvider = FutureProvider<({
  int totalEggs,
  double averageEggsPerDay,
  double averageEggsPerHen,
  int daysTracked,
})>((ref) async {
  final logs = await ref.watch(allDailyLogsProvider.future);
  final range = ref.watch(statsRangeProvider);
  
  if (logs.isEmpty) {
    return (
      totalEggs: 0,
      averageEggsPerDay: 0.0,
      averageEggsPerHen: 0.0,
      daysTracked: 0,
    );
  }

  final now = DateTime.now();
  final filteredLogs = logs.where((log) {
    switch (range) {
      case StatsRange.sevenDays:
        return log.date.isAfter(now.subtract(const Duration(days: 7)));
      case StatsRange.thirtyDays:
        return log.date.isAfter(now.subtract(const Duration(days: 30)));
      case StatsRange.ninetyDays:
        return log.date.isAfter(now.subtract(const Duration(days: 90)));
      case StatsRange.yearToDate:
        return log.date.year == now.year;
      case StatsRange.allTime:
        return true;
    }
  }).toList();

  if (filteredLogs.isEmpty) {
    return (
      totalEggs: 0,
      averageEggsPerDay: 0.0,
      averageEggsPerHen: 0.0,
      daysTracked: 0,
    );
  }

  int totalEggs = 0;
  double totalHenDays = 0;

  for (var log in filteredLogs) {
    totalEggs += log.totalEggs;
    totalHenDays += log.layingHens;
  }

  return (
    totalEggs: totalEggs,
    averageEggsPerDay: totalEggs / filteredLogs.length,
    averageEggsPerHen: totalHenDays == 0 ? 0.0 : totalEggs / totalHenDays,
    daysTracked: filteredLogs.length,
  );
});
