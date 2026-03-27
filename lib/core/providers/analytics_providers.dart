import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chicken_model.dart';
import 'database_providers.dart';

/// Helper function to get the start of the week (Monday)
DateTime _getWeekStart(DateTime date) {
  final dayOfWeek = date.weekday; // 1 = Monday, 7 = Sunday
  return date.subtract(Duration(days: dayOfWeek - 1));
}

/// Helper function to get the last day of a month
int _getLastDayOfMonth(int year, int month) {
  if (month == DateTime.february) {
    return (year % 4 == 0) ? 29 : 28;
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
  
  for (int i = 11; i >= 0; i--) {
    var monthDate = now;
    monthDate = DateTime(monthDate.year, monthDate.month - i, 1);
    final summary = await ref.watch(monthlyProductionProvider(monthDate).future);
    months.add(summary);
  }
  
  return months;
});

/// Provider for production stats summary
final productionStatsSummaryProvider = FutureProvider<({
  int totalEggsAllTime,
  double averageEggsPerDay,
  double averageEggsPerHen,
  int daysTracked,
})>((ref) async {
  final logs = await ref.watch(allDailyLogsProvider.future);
  
  if (logs.isEmpty) {
    return (
      totalEggsAllTime: 0,
      averageEggsPerDay: 0.0,
      averageEggsPerHen: 0.0,
      daysTracked: 0,
    );
  }

  int totalEggs = 0;
  double totalHenDays = 0;

  for (var log in logs) {
    totalEggs += log.totalEggs;
    totalHenDays += log.layingHens;
  }

  return (
    totalEggsAllTime: totalEggs,
    averageEggsPerDay: logs.isEmpty ? 0.0 : totalEggs / logs.length,
    averageEggsPerHen: totalHenDays == 0 ? 0.0 : totalEggs / totalHenDays,
    daysTracked: logs.length,
  );
});
