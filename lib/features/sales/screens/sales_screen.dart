import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../config/router.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/widgets/app_ui_components.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedRangeDays = -1;
  DateTime? _customStartDate;
  DateTime? _customEndDate;
  bool _sortNewestFirst = true;

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
    final salesAsync = ref.watch(allSalesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: _sortNewestFirst ? 'Showing newest first' : 'Showing oldest first',
            icon: Icon(_sortNewestFirst ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: () => setState(() => _sortNewestFirst = !_sortNewestFirst),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF161D1E), Color(0xFF101414)]
                : const [Color(0xFFF0FAF6), Color(0xFFFCFFFD)],
          ),
        ),
        child: salesAsync.when(
          data: (sales) {
            final now = DateTime.now();
            final query = _searchController.text.trim().toLowerCase();
            final filteredSales = sales.where((sale) {
              final saleDate =
                  DateTime(sale.date.year, sale.date.month, sale.date.day);
              final todayDate = DateTime(now.year, now.month, now.day);

              bool inRange;
              if (_selectedRangeDays == -1) {
                inRange = true;
              } else if (_selectedRangeDays == 0) {
                inRange = saleDate.isAtSameMomentAs(todayDate);
              } else if (_selectedRangeDays == -2 &&
                  _customStartDate != null &&
                  _customEndDate != null) {
                final start = DateTime(_customStartDate!.year,
                    _customStartDate!.month, _customStartDate!.day);
                final end = DateTime(_customEndDate!.year,
                    _customEndDate!.month, _customEndDate!.day);
                inRange = (saleDate.isAtSameMomentAs(start) ||
                        saleDate.isAfter(start)) &&
                    (saleDate.isAtSameMomentAs(end) || saleDate.isBefore(end));
              } else {
                inRange = sale.date.isAfter(
                  now.subtract(Duration(days: _selectedRangeDays)),
                );
              }

              if (!inRange) {
                return false;
              }

              if (query.isEmpty) {
                return true;
              }

              final customer = (sale.customerName ?? '').toLowerCase();
              return sale.type.toLowerCase().contains(query) ||
                  customer.contains(query) ||
                  sale.quantity.toString().contains(query) ||
                  sale.amount.toStringAsFixed(2).contains(query);
            }).toList()
              ..sort((a, b) => _sortNewestFirst
                  ? b.date.compareTo(a.date)
                  : a.date.compareTo(b.date));

            if (filteredSales.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No sales yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap Add Sale to record your first transaction.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            final totalRevenue =
                filteredSales.fold<double>(0, (sum, sale) => sum + sale.amount);
            final eggsSold = filteredSales
                .where((sale) => sale.type == 'eggs')
                .fold<int>(0, (sum, sale) => sum + sale.quantity);
            final chickensSold = filteredSales
                .where((sale) => sale.type == 'chickens')
                .fold<int>(0, (sum, sale) => sum + sale.quantity);

            // Group sales by month
            final groupedSales = <String, List<dynamic>>{};
            for (final sale in filteredSales) {
              final monthKey = DateFormat('MMMM yyyy').format(sale.date);
              groupedSales.putIfAbsent(monthKey, () => []).add(sale);
            }

            return ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                appFabSafeBottomSpacing(context),
              ),
              children: [
                _HeroSummary(
                  totalRevenue: totalRevenue,
                  saleCount: filteredSales.length,
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
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _MiniStatCard(
                        label: 'Eggs Sold',
                        value: '$eggsSold',
                        icon: Icons.egg,
                        color: const Color(0xFFB88700),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MiniStatCard(
                        label: 'Chickens Sold',
                        value: '$chickensSold',
                        icon: Icons.pets,
                        color: const Color(0xFF5D4037),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const AppSectionHeader(
                  title: 'Sales Timeline',
                  subtitle: 'Grouped by month',
                ),
                const SizedBox(height: 10),
                ...(groupedSales.entries.toList()
                  ..sort((a, b) {
                    final aDate = DateFormat('MMMM yyyy').parse(a.key);
                    final bDate = DateFormat('MMMM yyyy').parse(b.key);
                    return _sortNewestFirst ? bDate.compareTo(aDate) : aDate.compareTo(bDate);
                  }))
                  .map((entry) {
                  final month = entry.key;
                  final monthSales = entry.value;
                  final totalAmount = monthSales.fold<double>(
                    0,
                    (sum, sale) => sum + sale.amount,
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF253238)
                              : const Color(0xFFDFF3EA),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              month,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            Text(
                              '\$${totalAmount.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF0E7A4F),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...monthSales.map((sale) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Icon(
                                sale.type == 'eggs' ? Icons.egg : Icons.pets,
                                color: sale.type == 'eggs'
                                    ? const Color(0xFFB88700)
                                    : const Color(0xFF6D4C41),
                              ),
                              title: Text(
                                '${sale.quantity} ${sale.type}${sale.quantity != 1 ? 's' : ''} sold',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(DateFormat('MMM d, yyyy')
                                      .format(sale.date)),
                                  if (sale.customerName != null)
                                    Text('Customer: ${sale.customerName}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Builder(builder: (context) {
                                    final isPending = (sale.customerName ?? '')
                                        .toLowerCase()
                                        .contains('pending');
                                    final statusColor =
                                        isPending ? Colors.amber : Colors.green;

                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '\$${sale.amount.toStringAsFixed(2)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                color: const Color(0xFF0E7A4F),
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusColor.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            isPending ? 'Pending' : 'Paid',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  color: statusColor,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                  PopupMenuButton<String>(
                                    onSelected: (value) async {
                                      if (value == 'edit') {
                                        context.push(Routes.addSale, extra: sale);
                                      } else if (value == 'delete') {
                                        final confirmed = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Delete Sale'),
                                            content: const Text('Delete this sale record?'),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                                            ],
                                          ),
                                        );
                                        if (confirmed == true && mounted) {
                                          await ref.read(salesRepositoryProvider).deleteSale(sale.id);
                                        }
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'))),
                                      const PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Delete', style: TextStyle(color: Colors.red)))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                      const SizedBox(height: 14),
                    ],
                  );
                }),
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
                  'Error loading sales: $error',
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
          context.push(Routes.addSale);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Sale'),
      ),
    );
  }
}

class _HeroSummary extends StatelessWidget {
  final double totalRevenue;
  final int saleCount;

  const _HeroSummary({
    required this.totalRevenue,
    required this.saleCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF0E7A4F), Color(0xFF0A5F3E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue Overview',
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            '\$${totalRevenue.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '$saleCount transaction${saleCount == 1 ? '' : 's'}',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
