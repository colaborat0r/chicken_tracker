import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../config/router.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/widgets/app_ui_components.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
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
    final expensesAsync = ref.watch(allExpensesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
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
                ? const [Color(0xFF241617), Color(0xFF161112)]
                : const [Color(0xFFFFF2EC), Color(0xFFFFFCFA)],
          ),
        ),
        child: expensesAsync.when(
          data: (expenses) {
            final now = DateTime.now();
            final query = _searchController.text.trim().toLowerCase();
            final filteredExpenses = expenses.where((expense) {
              final expenseDate = DateTime(
                  expense.date.year, expense.date.month, expense.date.day);
              final todayDate = DateTime(now.year, now.month, now.day);

              bool inRange;
              if (_selectedRangeDays == -1) {
                inRange = true;
              } else if (_selectedRangeDays == 0) {
                inRange = expenseDate.isAtSameMomentAs(todayDate);
              } else if (_selectedRangeDays == -2 &&
                  _customStartDate != null &&
                  _customEndDate != null) {
                final start = DateTime(_customStartDate!.year,
                    _customStartDate!.month, _customStartDate!.day);
                final end = DateTime(_customEndDate!.year,
                    _customEndDate!.month, _customEndDate!.day);
                inRange = (expenseDate.isAtSameMomentAs(start) ||
                        expenseDate.isAfter(start)) &&
                    (expenseDate.isAtSameMomentAs(end) ||
                        expenseDate.isBefore(end));
              } else {
                inRange = expense.date.isAfter(
                  now.subtract(Duration(days: _selectedRangeDays)),
                );
              }

              if (!inRange) {
                return false;
              }

              if (query.isEmpty) {
                return true;
              }

              final description = (expense.description ?? '').toLowerCase();
              return expense.category.toLowerCase().contains(query) ||
                  description.contains(query) ||
                  expense.amount.toStringAsFixed(2).contains(query);
            }).toList()
              ..sort((a, b) => _sortNewestFirst
                  ? b.date.compareTo(a.date)
                  : a.date.compareTo(b.date));

            if (filteredExpenses.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No expenses yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap Add Expense to start tracking costs.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            final totalSpent = filteredExpenses.fold<double>(
                0, (sum, item) => sum + item.amount);

            // Group expenses by category
            final categoryTotals = <String, double>{};
            final categoryExpenses = <String, List<dynamic>>{};

            for (final expense in filteredExpenses) {
              categoryTotals[expense.category] =
                  (categoryTotals[expense.category] ?? 0) + expense.amount;
              categoryExpenses
                  .putIfAbsent(expense.category, () => [])
                  .add(expense);
            }

            return ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                appFabSafeBottomSpacing(context),
              ),
              children: [
                _SummaryBanner(
                  totalSpent: totalSpent,
                  expenseCount: filteredExpenses.length,
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
                  title: 'Category Snapshot',
                  subtitle: 'Where your money goes',
                ),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: categoryTotals.entries.map((entry) {
                    final category = entry.key;
                    final total = entry.value;
                    final count = categoryExpenses[category]!.length;

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              category.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${total.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFC5392A),
                                  ),
                            ),
                            Text(
                              '$count expense${count != 1 ? 's' : ''}',
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
                  title: 'Recent Expenses',
                  subtitle: 'Latest cost records',
                ),
                const SizedBox(height: 12),
                ...filteredExpenses.map((expense) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          _getCategoryIcon(expense.category),
                          color: _getCategoryColor(expense.category),
                        ),
                        title: Text(
                          expense.category.toUpperCase(),
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('MMM d, yyyy').format(expense.date),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (expense.description != null) ...[
                              Text(
                                expense.description!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                            if (expense.pounds != null) ...[
                              Text(
                                '${expense.pounds} lbs @ \$${(expense.amount / expense.pounds!).toStringAsFixed(2)}/lb',
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\$${expense.amount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFC5392A),
                                  ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  context.push(Routes.addExpense, extra: expense);
                                } else if (value == 'delete') {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete Expense'),
                                      content: const Text('Delete this expense record?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                                      ],
                                    ),
                                  );
                                  if (confirmed == true && mounted) {
                                    await ref.read(expenseRepositoryProvider).deleteExpense(expense.id);
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
                  'Error loading expenses: $error',
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
          context.push(Routes.addExpense);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'feed':
        return Icons.grass;
      case 'bedding':
        return Icons.king_bed;
      case 'medicine':
        return Icons.medical_services;
      case 'general':
        return Icons.shopping_cart;
      default:
        return Icons.attach_money;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'feed':
        return Colors.green;
      case 'bedding':
        return Colors.brown;
      case 'medicine':
        return Colors.blue;
      case 'general':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class _SummaryBanner extends StatelessWidget {
  final double totalSpent;
  final int expenseCount;

  const _SummaryBanner({
    required this.totalSpent,
    required this.expenseCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFC5392A), Color(0xFF92291E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Expense Overview',
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            '\$${totalSpent.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '$expenseCount record${expenseCount == 1 ? '' : 's'}',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
