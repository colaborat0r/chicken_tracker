import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../config/router.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/widgets/app_ui_components.dart';

class FlockLossesScreen extends ConsumerStatefulWidget {
  const FlockLossesScreen({super.key});

  @override
  ConsumerState<FlockLossesScreen> createState() => _FlockLossesScreenState();
}

class _FlockLossesScreenState extends ConsumerState<FlockLossesScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedRangeDays = -1;
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  Future<void> _selectCustomRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: _customStartDate ?? now.subtract(const Duration(days: 30)),
        end: _customEndDate ?? now,
      ),
    );

    if (picked != null) {
      setState(() {
        _customStartDate = picked.start;
        _customEndDate = picked.end;
        _selectedRangeDays = -2;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lossesAsync = ref.watch(allFlockLossesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flock Losses'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF251617), Color(0xFF160F10)]
                : const [Color(0xFFFFEEEE), Color(0xFFFFFBFB)],
          ),
        ),
        child: lossesAsync.when(
          data: (losses) {
            final now = DateTime.now();
            final query = _searchController.text.trim().toLowerCase();
            final filteredLosses = losses.where((loss) {
              final lossDate =
                  DateTime(loss.date.year, loss.date.month, loss.date.day);
              final todayDate = DateTime(now.year, now.month, now.day);

              bool inRange;
              if (_selectedRangeDays == -1) {
                inRange = true;
              } else if (_selectedRangeDays == 0) {
                inRange = lossDate.isAtSameMomentAs(todayDate);
              } else if (_selectedRangeDays == -2 &&
                  _customStartDate != null &&
                  _customEndDate != null) {
                final start = DateTime(_customStartDate!.year,
                    _customStartDate!.month, _customStartDate!.day);
                final end = DateTime(_customEndDate!.year,
                    _customEndDate!.month, _customEndDate!.day);
                inRange = (lossDate.isAtSameMomentAs(start) ||
                        lossDate.isAfter(start)) &&
                    (lossDate.isAtSameMomentAs(end) || lossDate.isBefore(end));
              } else {
                inRange = loss.date.isAfter(
                  now.subtract(Duration(days: _selectedRangeDays)),
                );
              }

              if (!inRange) {
                return false;
              }

              if (query.isEmpty) {
                return true;
              }

              final predatorSubtype =
                  (loss.predatorSubtype ?? '').toLowerCase();
              return loss.type.toLowerCase().contains(query) ||
                  predatorSubtype.contains(query) ||
                  loss.quantity.toString().contains(query);
            }).toList();

            if (filteredLosses.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No losses yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap Record Loss to track flock changes.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Group losses by type
            final typeTotals = <String, int>{};
            final typeLosses = <String, List<dynamic>>{};

            for (final loss in filteredLosses) {
              typeTotals[loss.type] =
                  (typeTotals[loss.type] ?? 0) + loss.quantity;
              typeLosses.putIfAbsent(loss.type, () => []).add(loss);
            }

            final totalLosses =
                filteredLosses.fold<int>(0, (sum, loss) => sum + loss.quantity);

            return ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                appFabSafeBottomSpacing(context),
              ),
              children: [
                _LossBanner(
                    totalLosses: totalLosses,
                    incidentCount: filteredLosses.length),
                const SizedBox(height: 16),
                AppSearchAndRangeBar(
                  searchController: _searchController,
                  onSearchChanged: (_) => setState(() {}),
                  selectedRangeDays: _selectedRangeDays,
                  onRangeChanged: (days) {
                    setState(() => _selectedRangeDays = days);
                  },
                  onCustomRangePressed: _selectCustomRange,
                  customRangeLabel: _customStartDate != null &&
                          _customEndDate != null
                      ? '${DateFormat('M/d').format(_customStartDate!)}-${DateFormat('M/d').format(_customEndDate!)}'
                      : 'Custom',
                ),
                const SizedBox(height: 16),
                const AppSectionHeader(
                  title: 'Loss Types',
                  subtitle: 'Incidents grouped by reason',
                ),
                const SizedBox(height: 10),

                // Summary cards by type
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: typeTotals.entries.map((entry) {
                    final type = entry.key;
                    final total = entry.value;
                    final count = typeLosses[type]!.length;

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formatTypeName(type).toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$total',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                            ),
                            Text(
                              '$count incident${count != 1 ? 's' : ''}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                const AppSectionHeader(
                  title: 'Loss History',
                  subtitle: 'Detailed event log',
                ),
                const SizedBox(height: 12),

                ...filteredLosses.map((loss) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          _getLossIcon(loss.type),
                          color: _getLossColor(loss.type),
                        ),
                        title: Text(
                          '${loss.quantity} chicken${loss.quantity != 1 ? 's' : ''} lost',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_formatTypeName(loss.type)} - ${DateFormat('MMM d, yyyy').format(loss.date)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (loss.predatorSubtype != null &&
                                loss.type == 'predator') ...[
                              Text(
                                'Predator: ${loss.predatorSubtype}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.orange,
                                    ),
                              ),
                            ],
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _getLossColor(loss.type).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            loss.type.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: _getLossColor(loss.type),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    )),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                AppSkeletonCard(),
                SizedBox(height: 10),
                AppSkeletonCard(),
              ],
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading losses: $error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(Routes.addFlockLoss);
        },
        icon: const Icon(Icons.warning),
        label: const Text('Record Loss'),
      ),
    );
  }

  String _formatTypeName(String type) {
    switch (type) {
      case 'human_consumption':
        return 'Human Consumption';
      case 'illness':
        return 'Illness';
      case 'natural_causes':
        return 'Natural Causes';
      case 'other':
        return 'Other';
      case 'predator':
        return 'Predator Attack';
      case 'sold':
        return 'Sold';
      default:
        return type;
    }
  }

  IconData _getLossIcon(String type) {
    switch (type) {
      case 'human_consumption':
        return Icons.restaurant;
      case 'illness':
        return Icons.medical_services;
      case 'natural_causes':
        return Icons.heart_broken;
      case 'other':
        return Icons.category;
      case 'predator':
        return Icons.pets;
      case 'sold':
        return Icons.attach_money;
      default:
        return Icons.warning;
    }
  }

  Color _getLossColor(String type) {
    switch (type) {
      case 'human_consumption':
        return Colors.blue;
      case 'illness':
        return Colors.purple;
      case 'natural_causes':
        return Colors.grey;
      case 'other':
        return Colors.brown;
      case 'predator':
        return Colors.red;
      case 'sold':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }
}

class _LossBanner extends StatelessWidget {
  final int totalLosses;
  final int incidentCount;

  const _LossBanner({required this.totalLosses, required this.incidentCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFC62828), Color(0xFF8E1B1B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Flock Impact',
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            '$totalLosses total losses',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '$incidentCount incident${incidentCount == 1 ? '' : 's'} recorded',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
