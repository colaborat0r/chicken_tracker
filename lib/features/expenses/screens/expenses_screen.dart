import 'dart:math';
import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/router.dart';
import '../../../core/models/chicken_model.dart';
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
  String? _selectedCategoryFilter; // null = all
  double _monthlyBudget = 0.0;

  static const _budgetKey = 'expenses_monthly_budget';

  @override
  void initState() {
    super.initState();
    _loadBudget();
  }

  Future<void> _loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() => _monthlyBudget = prefs.getDouble(_budgetKey) ?? 0.0);
    }
  }

  Future<void> _saveBudget(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_budgetKey, value);
    if (mounted) setState(() => _monthlyBudget = value);
  }

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

  Future<void> _showBudgetDialog() async {
    final controller = TextEditingController(
      text: _monthlyBudget > 0 ? _monthlyBudget.toStringAsFixed(2) : '',
    );
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Monthly Budget'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Set a monthly spending limit. Leave blank to disable.'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Budget Amount',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          if (_monthlyBudget > 0)
            TextButton(
              onPressed: () async {
                await _saveBudget(0.0);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child:
                  const Text('Clear', style: TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final v = double.tryParse(controller.text.trim());
              if (v != null && v > 0) await _saveBudget(v);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportCsv(List<ExpenseModel> expenses) async {
    final rows = <List<dynamic>>[
      ['Date', 'Category', 'Description', 'Amount', 'Pounds'],
      ...expenses.map((e) => [
            DateFormat('yyyy-MM-dd').format(e.date),
            e.category,
            e.description ?? '',
            e.amount.toStringAsFixed(2),
            e.pounds?.toString() ?? '',
          ]),
    ];
    final csv = const ListToCsvConverter().convert(rows);
    await Share.share(csv, subject: 'Expenses Export');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(allExpensesProvider);
    final costPerEggAsync = ref.watch(thisMonthFeedCostPerEggProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Set monthly budget',
            icon: const Icon(Icons.savings),
            onPressed: _showBudgetDialog,
          ),
          expensesAsync.when(
            data: (expenses) => IconButton(
              tooltip: 'Export as CSV',
              icon: const Icon(Icons.download),
              onPressed: () => _exportCsv(expenses),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          IconButton(
            tooltip: _sortNewestFirst
                ? 'Showing newest first'
                : 'Showing oldest first',
            icon: Icon(
                _sortNewestFirst ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: () =>
                setState(() => _sortNewestFirst = !_sortNewestFirst),
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

            // All unique categories across all (unfiltered) expenses
            final allCategories =
                expenses.map((e) => e.category).toSet().toList()..sort();

            final filteredExpenses = expenses.where((expense) {
              // Category filter
              if (_selectedCategoryFilter != null &&
                  expense.category != _selectedCategoryFilter) {
                return false;
              }

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
                    now.subtract(Duration(days: _selectedRangeDays)));
              }

              if (!inRange) return false;

              if (query.isEmpty) return true;

              final description = (expense.description ?? '').toLowerCase();
              return expense.category.toLowerCase().contains(query) ||
                  description.contains(query) ||
                  expense.amount.toStringAsFixed(2).contains(query);
            }).toList()
              ..sort((a, b) => _sortNewestFirst
                  ? b.date.compareTo(a.date)
                  : a.date.compareTo(b.date));

            // This-month total for budget progress (always uses unfiltered data)
            final thisMonthTotal = expenses
                .where((e) =>
                    e.date.year == now.year && e.date.month == now.month)
                .fold<double>(0, (s, e) => s + e.amount);

            if (filteredExpenses.isEmpty) {
              return Column(
                children: [
                  if (allCategories.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: _CategoryFilterRow(
                        categories: allCategories,
                        selected: _selectedCategoryFilter,
                        onSelected: (cat) =>
                            setState(() => _selectedCategoryFilter = cat),
                      ),
                    ),
                  const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance_wallet,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No expenses yet',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey)),
                          SizedBox(height: 8),
                          Text('Tap Add Expense to start tracking costs.',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
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

            final costPerEgg = costPerEggAsync.value ?? 0.0;

            return ListView(
              padding: EdgeInsets.fromLTRB(
                  16, 16, 16, appFabSafeBottomSpacing(context)),
              children: [
                _SummaryBanner(
                  totalSpent: totalSpent,
                  expenseCount: filteredExpenses.length,
                  costPerEgg: costPerEgg,
                  monthlyBudget: _monthlyBudget,
                  thisMonthTotal: thisMonthTotal,
                ),
                const SizedBox(height: 16),
                AppSearchAndRangeBar(
                  searchController: _searchController,
                  onSearchChanged: (_) => setState(() {}),
                  selectedRangeDays: _selectedRangeDays,
                  onRangeChanged: (days) =>
                      setState(() => _selectedRangeDays = days),
                  onCustomRangePressed: _selectCustomRange,
                  customRangeLabel: _customStartDate != null &&
                          _customEndDate != null
                      ? '${DateFormat('M/d').format(_customStartDate!)}-${DateFormat('M/d').format(_customEndDate!)}'
                      : 'Custom',
                ),
                const SizedBox(height: 8),
                _CategoryFilterRow(
                  categories: allCategories,
                  selected: _selectedCategoryFilter,
                  onSelected: (cat) =>
                      setState(() => _selectedCategoryFilter = cat),
                ),
                const SizedBox(height: 16),
                const AppSectionHeader(
                  title: 'Monthly Trend',
                  subtitle: 'Last 6 months of spending',
                ),
                const SizedBox(height: 10),
                _MonthlySpendChart(expenses: expenses),
                const SizedBox(height: 24),
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

                    return InkWell(
                      onTap: () =>
                          context.push('/expenses/category/$category'),
                      child: Card(
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
                                    ?.copyWith(fontWeight: FontWeight.bold),
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
                                style:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
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
                            if (expense.description != null)
                              Text(expense.description!,
                                  style:
                                      Theme.of(context).textTheme.bodySmall),
                            if (expense.pounds != null)
                              Text(
                                '${expense.pounds} lbs @ \$${(expense.amount / expense.pounds!).toStringAsFixed(2)}/lb',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.blue),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\$${expense.amount.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFC5392A),
                                  ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  context.push(Routes.addExpense,
                                      extra: expense);
                                } else if (value == 'delete') {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title:
                                          const Text('Delete Expense'),
                                      content: const Text(
                                          'Delete this expense record?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx, false),
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx, true),
                                            child: const Text('Delete',
                                                style: TextStyle(
                                                    color: Colors.red))),
                                      ],
                                    ),
                                  );
                                  if (confirmed == true && mounted) {
                                    await ref
                                        .read(expenseRepositoryProvider)
                                        .deleteExpense(expense.id);
                                  }
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                    value: 'edit',
                                    child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('Edit'))),
                                const PopupMenuItem(
                                    value: 'delete',
                                    child: ListTile(
                                        leading: Icon(Icons.delete,
                                            color: Colors.red),
                                        title: Text('Delete',
                                            style: TextStyle(
                                                color: Colors.red)))),
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
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
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
        onPressed: () => context.push(Routes.addExpense),
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

// ─── Category Filter Chips ────────────────────────────────────────────────────

class _CategoryFilterRow extends StatelessWidget {
  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelected;

  const _CategoryFilterRow({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('All'),
              selected: selected == null,
              onSelected: (_) => onSelected(null),
            ),
          ),
          ...categories.map((cat) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(
                      cat[0].toUpperCase() + cat.substring(1).toLowerCase()),
                  selected: selected == cat,
                  onSelected: (_) =>
                      onSelected(selected == cat ? null : cat),
                ),
              )),
        ],
      ),
    );
  }
}

// ─── Monthly Spend Bar Chart ──────────────────────────────────────────────────

class _MonthlySpendChart extends StatelessWidget {
  final List<ExpenseModel> expenses;

  const _MonthlySpendChart({required this.expenses});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Last 6 months including current
    final months = List.generate(6, (i) {
      final d = DateTime(now.year, now.month - (5 - i));
      return DateTime(d.year, d.month);
    });

    final totals = months.map((m) {
      return expenses
          .where((e) => e.date.year == m.year && e.date.month == m.month)
          .fold<double>(0, (s, e) => s + e.amount);
    }).toList();

    final maxY = totals.isEmpty
        ? 10.0
        : (totals.reduce(max) * 1.25).clamp(10.0, double.infinity);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
        child: SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                      BarTooltipItem(
                    '\$${rod.toY.toStringAsFixed(0)}',
                    TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= months.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          DateFormat('MMM').format(months[idx]),
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: maxY / 4,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: isDark ? Colors.white10 : Colors.black12,
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(months.length, (i) {
                final isCurrent = months[i].year == now.year &&
                    months[i].month == now.month;
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: totals[i],
                      color: isCurrent
                          ? const Color(0xFFC5392A)
                          : const Color(0xFFC5392A).withValues(alpha: 0.45),
                      width: 22,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Summary Banner ───────────────────────────────────────────────────────────

class _SummaryBanner extends StatelessWidget {
  final double totalSpent;
  final int expenseCount;
  final double costPerEgg;
  final double monthlyBudget;
  final double thisMonthTotal;

  const _SummaryBanner({
    required this.totalSpent,
    required this.expenseCount,
    required this.costPerEgg,
    required this.monthlyBudget,
    required this.thisMonthTotal,
  });

  @override
  Widget build(BuildContext context) {
    final budgetEnabled = monthlyBudget > 0;
    final budgetProgress = budgetEnabled
        ? (thisMonthTotal / monthlyBudget).clamp(0.0, 1.0)
        : 0.0;
    final budgetOver = budgetEnabled && thisMonthTotal > monthlyBudget;

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
          Row(
            children: [
              Text(
                '$expenseCount record${expenseCount == 1 ? '' : 's'}',
                style: const TextStyle(color: Colors.white70),
              ),
              if (costPerEgg > 0) ...[
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '🥚 \$${costPerEgg.toStringAsFixed(3)}/egg',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (budgetEnabled) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  budgetOver
                      ? '⚠️ Over budget!'
                      : 'Budget: \$${thisMonthTotal.toStringAsFixed(0)} / \$${monthlyBudget.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: budgetOver ? Colors.yellow : Colors.white70,
                    fontSize: 12,
                    fontWeight:
                        budgetOver ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  '${(budgetProgress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                      color: budgetOver ? Colors.yellow : Colors.white70,
                      fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: budgetProgress,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(
                    budgetOver ? Colors.yellow : Colors.white),
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
