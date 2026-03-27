import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/providers/analytics_providers.dart';

class AnalyticsDashboardScreen extends ConsumerWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trendData = ref.watch(productionTrendProvider(30)); // Last 30 days
    final monthlyData = ref.watch(last12MonthsProvider);
    final summaryData = ref.watch(productionStatsSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Analytics Dashboard'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Stats
              Text(
                'Overall Statistics',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              summaryData.when(
                data: (stats) => GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _StatCard(
                      label: 'Total Eggs',
                      value: stats.totalEggsAllTime.toString(),
                      icon: Icons.egg,
                      color: Colors.amber,
                    ),
                    _StatCard(
                      label: 'Days Tracked',
                      value: stats.daysTracked.toString(),
                      icon: Icons.calendar_month,
                      color: Colors.blue,
                    ),
                    _StatCard(
                      label: 'Avg/Day',
                      value: stats.averageEggsPerDay.toStringAsFixed(1),
                      icon: Icons.trending_up,
                      color: Colors.orange,
                    ),
                    _StatCard(
                      label: 'Avg/Hen',
                      value: stats.averageEggsPerHen.toStringAsFixed(2),
                      icon: Icons.pets,
                      color: Colors.green,
                    ),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, st) => Text('Error: $err'),
              ),
              const SizedBox(height: 28),

              // 30-Day Trend Chart
              Text(
                '30-Day Production Trend',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: trendData.when(
                    data: (points) {
                      if (points.isEmpty) {
                        return Center(
                          child: Text(
                            'No data available',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      }

                      // Find max value for Y axis
                      final maxEggs = points.fold<int>(
                          0, (max, point) => point.eggs > max ? point.eggs : max);
                      final yMax = (maxEggs / 10).ceil() * 10; // Round up to nearest 10

                      // Create line chart spots
                      final spots = points.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value.eggs.toDouble(),
                        );
                      }).toList();

                      return SizedBox(
                        height: 250,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: yMax > 0 ? (yMax / 5) : 10,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                                  strokeWidth: 0.8,
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() % 5 == 0 &&
                                        value.toInt() < points.length) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 32,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                color: Colors.amber[600],
                                barWidth: 3,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, barData, index) {
                                    return FlDotCirclePainter(
                                      radius: 4,
                                      color: Colors.amber[600]!,
                                      strokeWidth: 0,
                                    );
                                  },
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.amber[300]?.withOpacity(0.2),
                                ),
                              ),
                            ],
                            minX: 0,
                            maxX: (points.length - 1).toDouble(),
                            minY: 0,
                            maxY: yMax.toDouble(),
                          ),
                        ),
                      );
                    },
                    loading: () => const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, st) => SizedBox(
                      height: 250,
                      child: Center(
                        child: Text('Error: $err'),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Monthly Summary
              Text(
                'Last 12 Months',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              monthlyData.when(
                data: (months) {
                  if (months.isEmpty) {
                    return Center(
                      child: Text(
                        'No monthly data',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: months.map((month) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    month.displayText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${month.totalEggs} eggs',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: Colors.amber[800],
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _MiniStat(
                                      label: 'Avg/Day',
                                      value: month.averageEggsPerDay
                                          .toStringAsFixed(1),
                                    ),
                                  ),
                                  Expanded(
                                    child: _MiniStat(
                                      label: 'Avg/Hen',
                                      value: month.averageEggsPerHen
                                          .toStringAsFixed(2),
                                    ),
                                  ),
                                  Expanded(
                                    child: _MiniStat(
                                      label: 'Days',
                                      value: month.totalDays.toString(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Egg breakdown bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Row(
                                  children: [
                                    if (month.totalBrownEggs > 0)
                                      Expanded(
                                        flex: month.totalBrownEggs,
                                        child: Container(
                                          height: 8,
                                          color: Colors.brown[600],
                                        ),
                                      ),
                                    if (month.totalColoredEggs > 0)
                                      Expanded(
                                        flex: month.totalColoredEggs,
                                        child: Container(
                                          height: 8,
                                          color: Colors.orange[600],
                                        ),
                                      ),
                                    if (month.totalWhiteEggs > 0)
                                      Expanded(
                                        flex: month.totalWhiteEggs,
                                        child: Container(
                                          height: 8,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, st) => Text('Error: $err'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.blue[600],
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
