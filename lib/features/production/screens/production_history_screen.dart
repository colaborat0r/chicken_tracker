import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/database_providers.dart';
import '../../../config/router.dart';

class ProductionHistoryScreen extends ConsumerStatefulWidget {
  const ProductionHistoryScreen({super.key});

  @override
  ConsumerState<ProductionHistoryScreen> createState() =>
      _ProductionHistoryScreenState();
}

class _ProductionHistoryScreenState
    extends ConsumerState<ProductionHistoryScreen> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedEndDate = DateTime.now();
    _selectedStartDate = _selectedEndDate!.subtract(const Duration(days: 90));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _selectedStartDate ??
            DateTime.now().subtract(const Duration(days: 90)),
        end: _selectedEndDate ?? DateTime.now(),
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedStartDate = picked.start;
        _selectedEndDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logsAsyncValue = ref.watch(allDailyLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Production History'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF1A1922), Color(0xFF111015)]
                : const [Color(0xFFF3F1FF), Color(0xFFFFFEFF)],
          ),
        ),
        child: logsAsyncValue.when(
          data: (allLogs) {
            final query = _searchController.text.trim().toLowerCase();
            // Filter logs by date range
            final filteredLogs = allLogs.where((log) {
              if (_selectedStartDate == null || _selectedEndDate == null)
                return true;
              final inRange = log.date.isAfter(
                      _selectedStartDate!.subtract(const Duration(days: 1))) &&
                  log.date
                      .isBefore(_selectedEndDate!.add(const Duration(days: 1)));

              if (!inRange) {
                return false;
              }

              if (query.isEmpty) {
                return true;
              }

              final dateText =
                  '${log.date.year}-${log.date.month}-${log.date.day}';
              final notes = (log.notes ?? '').toLowerCase();
              return dateText.contains(query) ||
                  notes.contains(query) ||
                  log.totalEggs.toString().contains(query) ||
                  log.layingHens.toString().contains(query);
            }).toList()
              ..sort((a, b) => b.date.compareTo(a.date)); // Most recent first

            if (filteredLogs.isEmpty) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        onPressed: _selectDateRange,
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Select Date Range'),
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No production logs',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start logging production to see history',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[500],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            // Calculate summary stats
            int totalEggs = 0;
            double totalHenDays = 0;
            for (var log in filteredLogs) {
              totalEggs += log.totalEggs;
              totalHenDays += log.layingHens;
            }
            final avgEggsPerDay =
                filteredLogs.isEmpty ? 0.0 : totalEggs / filteredLogs.length;
            final avgEggsPerHen =
                totalHenDays == 0 ? 0.0 : totalEggs / totalHenDays;

            return CustomScrollView(
              slivers: [
                // Filter header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _selectDateRange,
                                icon: const Icon(Icons.calendar_today),
                                label: const Text('Filter'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (_selectedStartDate != null &&
                                _selectedEndDate != null)
                              Expanded(
                                child: Text(
                                  '${_selectedStartDate!.month}/${_selectedStartDate!.day} - ${_selectedEndDate!.month}/${_selectedEndDate!.day}',
                                  style: Theme.of(context).textTheme.labelSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: 'Search by date, eggs, hens, or notes',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Summary stats
                        _HistoryHero(
                          totalEggs: totalEggs,
                          days: filteredLogs.length,
                          avgEggsPerDay: avgEggsPerDay,
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          children: [
                            _StatTile(
                              label: 'Total Eggs',
                              value: totalEggs.toString(),
                              color: Colors.amber,
                              icon: Icons.egg,
                            ),
                            _StatTile(
                              label: 'Avg/Day',
                              value: avgEggsPerDay.toStringAsFixed(1),
                              color: Colors.orange,
                              icon: Icons.trending_up,
                            ),
                            _StatTile(
                              label: 'Avg/Hen',
                              value: avgEggsPerHen.toStringAsFixed(2),
                              color: Colors.lightBlue,
                              icon: Icons.pets,
                            ),
                            _StatTile(
                              label: 'Days',
                              value: filteredLogs.length.toString(),
                              color: Colors.green,
                              icon: Icons.calendar_month,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Production list
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Text(
                      'Daily Logs (${filteredLogs.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final log = filteredLogs[index];
                      final dateStr =
                          '${log.date.month}/${log.date.day}/${log.date.year}';
                      final dayOfWeek = [
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat',
                        'Sun'
                      ][log.date.weekday - 1];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  isDark ? Colors.grey[800] : Colors.grey[100],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${log.totalEggs}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber[600],
                                      ),
                                ),
                                Text(
                                  'eggs',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        fontSize: 9,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            dateStr,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                          subtitle: Text(
                            '$dayOfWeek • ${log.layingHens} hens • ${log.eggsPerHen.toStringAsFixed(2)}/hen',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (log.eggsBrown > 0)
                                Text(
                                  '🟤 ${log.eggsBrown}',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              if (log.eggsColored > 0)
                                Text(
                                  '🟤🟠 ${log.eggsColored}',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              if (log.eggsWhite > 0)
                                Text(
                                  '⚪ ${log.eggsWhite}',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: filteredLogs.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading history',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.red[400],
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.logProduction),
        icon: const Icon(Icons.add),
        label: const Text('Log Production'),
      ),
    );
  }
}

class _HistoryHero extends StatelessWidget {
  final int totalEggs;
  final int days;
  final double avgEggsPerDay;

  const _HistoryHero({
    required this.totalEggs,
    required this.days,
    required this.avgEggsPerDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF5B45B0), Color(0xFF45338E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'History Snapshot',
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            '$totalEggs eggs across $days days',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 3),
          Text(
            '${avgEggsPerDay.toStringAsFixed(1)} eggs/day average',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
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
