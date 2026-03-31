import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../config/router.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/widgets/app_ui_components.dart';

class FlockPurchasesScreen extends ConsumerStatefulWidget {
  const FlockPurchasesScreen({super.key});

  @override
  ConsumerState<FlockPurchasesScreen> createState() =>
      _FlockPurchasesScreenState();
}

class _FlockPurchasesScreenState extends ConsumerState<FlockPurchasesScreen> {
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
    final purchasesAsync = ref.watch(allFlockPurchasesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flock Purchases'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF132020), Color(0xFF0F1515)]
                : const [Color(0xFFECFAF8), Color(0xFFFBFFFE)],
          ),
        ),
        child: purchasesAsync.when(
          data: (purchases) {
            final now = DateTime.now();
            final query = _searchController.text.trim().toLowerCase();
            final filteredPurchases = purchases.where((purchase) {
              final purchaseDate = DateTime(
                  purchase.date.year, purchase.date.month, purchase.date.day);
              final todayDate = DateTime(now.year, now.month, now.day);

              bool inRange;
              if (_selectedRangeDays == -1) {
                inRange = true;
              } else if (_selectedRangeDays == 0) {
                inRange = purchaseDate.isAtSameMomentAs(todayDate);
              } else if (_selectedRangeDays == -2 &&
                  _customStartDate != null &&
                  _customEndDate != null) {
                final start = DateTime(_customStartDate!.year,
                    _customStartDate!.month, _customStartDate!.day);
                final end = DateTime(_customEndDate!.year,
                    _customEndDate!.month, _customEndDate!.day);
                inRange = (purchaseDate.isAtSameMomentAs(start) ||
                        purchaseDate.isAfter(start)) &&
                    (purchaseDate.isAtSameMomentAs(end) ||
                        purchaseDate.isBefore(end));
              } else {
                inRange = purchase.date.isAfter(
                  now.subtract(Duration(days: _selectedRangeDays)),
                );
              }

              if (!inRange) {
                return false;
              }

              if (query.isEmpty) {
                return true;
              }

              final supplier = (purchase.supplier ?? '').toLowerCase();
              return purchase.type.toLowerCase().contains(query) ||
                  supplier.contains(query) ||
                  purchase.quantity.toString().contains(query) ||
                  purchase.cost.toStringAsFixed(2).contains(query);
            }).toList();

            if (filteredPurchases.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No purchases yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap Add Purchase to record new flock stock.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            final totalCost = filteredPurchases.fold<double>(
                0, (sum, item) => sum + item.cost);
            final totalUnits = filteredPurchases.fold<int>(
                0, (sum, item) => sum + item.quantity);

            // Group purchases by type
            final typeTotals = <String, Map<String, dynamic>>{};
            final typePurchases = <String, List<dynamic>>{};

            for (final purchase in filteredPurchases) {
              typeTotals.putIfAbsent(
                  purchase.type,
                  () => {
                        'totalCost': 0.0,
                        'totalQuantity': 0,
                        'count': 0,
                      });

              typeTotals[purchase.type]!['totalCost'] += purchase.cost;
              typeTotals[purchase.type]!['totalQuantity'] += purchase.quantity;
              typeTotals[purchase.type]!['count'] += 1;

              typePurchases.putIfAbsent(purchase.type, () => []).add(purchase);
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _TopBanner(
                  totalCost: totalCost,
                  totalUnits: totalUnits,
                ),
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
                  title: 'Purchase Mix',
                  subtitle: 'Totals by acquisition type',
                ),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: typeTotals.entries.map((entry) {
                    final type = entry.key;
                    final data = entry.value;
                    final totalCost = data['totalCost'] as double;
                    final totalQuantity = data['totalQuantity'] as int;
                    final count = data['count'] as int;

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
                              '\$${totalCost.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                            ),
                            Text(
                              '$totalQuantity total',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '$count purchases',
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
                  title: 'Purchase History',
                  subtitle: 'Most recent records first',
                ),
                const SizedBox(height: 12),
                ...filteredPurchases.map((purchase) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          _getPurchaseIcon(purchase.type),
                          color: _getPurchaseColor(purchase.type),
                        ),
                        title: Text(
                          '${purchase.quantity} ${_formatTypeName(purchase.type)}',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('MMM d, yyyy').format(purchase.date),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (purchase.supplier != null) ...[
                              Text(
                                'Supplier: ${purchase.supplier}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                            Text(
                              '\$${(purchase.cost / purchase.quantity).toStringAsFixed(2)} each',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.green,
                                  ),
                            ),
                            if (purchase.hatchedCount != null &&
                                purchase.type == 'hatching_eggs') ...[
                              Text(
                                'Hatched: ${purchase.hatchedCount} (${((purchase.hatchedCount! / purchase.quantity) * 100).toStringAsFixed(1)}%)',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.blue,
                                    ),
                              ),
                            ],
                          ],
                        ),
                        trailing: Text(
                          '\$${purchase.cost.toStringAsFixed(2)}\n${_purchaseStatusText(purchase)}',
                          textAlign: TextAlign.right,
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0D6E77),
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
                  'Error loading purchases: $error',
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
          context.push(Routes.addFlockPurchase);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Purchase'),
      ),
    );
  }

  String _formatTypeName(String type) {
    switch (type) {
      case 'live_chicks':
        return 'Live Chicks';
      case 'hatching_eggs':
        return 'Hatching Eggs';
      default:
        return type;
    }
  }

  IconData _getPurchaseIcon(String type) {
    switch (type) {
      case 'live_chicks':
        return Icons.pets;
      case 'hatching_eggs':
        return Icons.egg;
      default:
        return Icons.shopping_cart;
    }
  }

  Color _getPurchaseColor(String type) {
    switch (type) {
      case 'live_chicks':
        return Colors.orange;
      case 'hatching_eggs':
        return Colors.amber;
      default:
        return Colors.blue;
    }
  }

  String _purchaseStatusText(dynamic purchase) {
    if (purchase.type == 'hatching_eggs' && purchase.hatchedCount != null) {
      final hatchRate = (purchase.hatchedCount! / purchase.quantity) * 100;
      return hatchRate < 70 ? 'Low Hatch' : 'Good Hatch';
    }
    return 'Received';
  }
}

class _TopBanner extends StatelessWidget {
  final double totalCost;
  final int totalUnits;

  const _TopBanner({required this.totalCost, required this.totalUnits});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D6E77), Color(0xFF09545B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Acquisition Overview',
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            '\$${totalCost.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '$totalUnits total units purchased',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
