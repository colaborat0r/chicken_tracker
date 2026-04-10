import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../config/router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _quickAddOpen = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final statsCrossAxisCount = width > 900 ? 4 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chicken Tracker',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
        ),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 88,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              decoration: const BoxDecoration(
                color: Color(0xFF0E2141),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.pop(context);
                          context.push(Routes.about);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/icons/app_icon.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Chicken Tracker',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('Flock',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ),
            ListTile(
              leading: const Icon(Icons.pets, color: Colors.orange),
              title: const Text('View Flock'),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.chickenList);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag, color: Colors.teal),
              title: const Text('Flock Purchases'),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.flockPurchases);
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning_amber, color: Colors.red),
              title: const Text('Flock Losses'),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.flockLosses);
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('Production',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ),
            ListTile(
              leading:
                  const Icon(Icons.add_circle_outline, color: Colors.green),
              title: const Text('Log Egg Production'),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.logProduction);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.blue),
              title: const Text('Production History'),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.productionHistory);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.bar_chart_outlined, color: Colors.purple),
              title: const Text('Analytics'),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.analytics);
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('Finance',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.indigo),
              title: const Text('Sales'),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.sales);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet,
                  color: Colors.deepOrange),
              title: const Text('Expenses'),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.expenses);
              },
            ),
            const Divider(),
            ListTile(
              leading:
                  const Icon(Icons.file_download_outlined, color: Colors.cyan),
              title: const Text('Reports & Exports'),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.reports);
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('Care',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ),
            ListTile(
              leading: const Icon(Icons.alarm, color: Color(0xFF2E7D32)),
              title: const Text('Reminders'),
              subtitle: const Text('Feeding, cleaning, health checks'),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.reminders);
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('Settings',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
            ),
            ListTile(
              leading:
                  const Icon(Icons.storage_outlined, color: Colors.blueGrey),
              title: const Text('Data Management'),
              subtitle: const Text('Backup, restore, export, reset'),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.dataManagement);
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF1B1A17), Color(0xFF111111)]
                : const [Color(0xFFF8F2E8), Color(0xFFFFFDF8)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionReveal(
                  child: _HeroHeader(
                    onPrimaryAction: () => context.push(Routes.logProduction),
                    onSecondaryAction: () => context.push(Routes.sales),
                    onTertiaryAction: () => context.push(Routes.expenses),
                  ),
                ),
                const SizedBox(height: 20),
                const _SectionTitle(
                  title: 'Farm Snapshot',
                  subtitle: 'Live totals from your current data',
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: statsCrossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.15,
                  children: [
                    _StatCardAsync(
                      label: 'Flock Count',
                      icon: Icons.pets,
                      color: const Color(0xFFE08A24),
                      provider: flockCountProvider,
                    ),
                    _StatCardAsync(
                      label: 'Eggs Today',
                      icon: Icons.egg,
                      color: const Color(0xFFDAA520),
                      provider: todayEggCountProvider,
                    ),
                    _StatCardAsync(
                      label: 'This Month Expenses',
                      icon: Icons.account_balance_wallet,
                      color: const Color(0xFFC5392A),
                      provider: thisMonthExpensesTotalProvider,
                      formatter: (value) => NumberFormat.currency(symbol: '\$')
                          .format((value as num?) ?? 0),
                    ),
                    _StatCardAsync(
                      label: 'This Month Sales',
                      icon: Icons.receipt_long,
                      color: const Color(0xFF0E7A4F),
                      provider: thisMonthSalesTotalProvider,
                      formatter: (value) => NumberFormat.currency(symbol: '\$')
                          .format((value as num?) ?? 0),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const _SectionTitle(
                  title: 'Quick Actions',
                  subtitle: 'Tap a task to jump directly into your workflow',
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _ActionChip(
                      label: 'Log Production',
                      icon: Icons.add_circle_outline,
                      color: const Color(0xFF2E7D32),
                      onPressed: () => context.push(Routes.logProduction),
                    ),
                    _ActionChip(
                      label: 'View Flock',
                      icon: Icons.pets,
                      color: const Color(0xFFE08A24),
                      onPressed: () => context.push(Routes.chickenList),
                    ),
                    _ActionChip(
                      label: 'Sales',
                      icon: Icons.receipt_long,
                      color: const Color(0xFF1565C0),
                      onPressed: () => context.push(Routes.sales),
                    ),
                    _ActionChip(
                      label: 'Expenses',
                      icon: Icons.account_balance_wallet,
                      color: const Color(0xFFD35400),
                      onPressed: () => context.push(Routes.expenses),
                    ),
                    _ActionChip(
                      label: 'History',
                      icon: Icons.history,
                      color: const Color(0xFF6A1B9A),
                      onPressed: () => context.push(Routes.productionHistory),
                    ),
                    _ActionChip(
                      label: 'Analytics',
                      icon: Icons.bar_chart_outlined,
                      color: const Color(0xFF0D8F8A),
                      onPressed: () => context.push(Routes.analytics),
                    ),
                    _ActionChip(
                      label: 'Reports',
                      icon: Icons.file_download_outlined,
                      color: const Color(0xFF455A64),
                      onPressed: () => context.push(Routes.reports),
                    ),
                    _ActionChip(
                      label: 'Data Management',
                      icon: Icons.storage_outlined,
                      color: const Color(0xFF5D4037),
                      onPressed: () => context.push(Routes.dataManagement),
                    ),
                    _ActionChip(
                      label: 'Flock Purchases',
                      icon: Icons.shopping_bag,
                      color: const Color(0xFF00695C),
                      onPressed: () => context.push(Routes.flockPurchases),
                    ),
                    _ActionChip(
                      label: 'Flock Losses',
                      icon: Icons.warning_amber,
                      color: const Color(0xFFB71C1C),
                      onPressed: () => context.push(Routes.flockLosses),
                    ),
                    _ActionChip(
                      label: 'Reminders',
                      icon: Icons.alarm,
                      color: const Color(0xFF2E7D32),
                      onPressed: () => context.push(Routes.reminders),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const _SectionTitle(
                  title: "Today's Reminders",
                  subtitle: 'Tasks due or overdue',
                ),
                const SizedBox(height: 12),
                const _DueRemindersCard(),
                const SizedBox(height: 24),
                const _SectionTitle(
                  title: 'Recent Activity',
                  subtitle: 'Last five production logs',
                ),
                const SizedBox(height: 12),
                ref.watch(allDailyLogsProvider).when(
                      data: (logs) {
                        if (logs.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  isDark ? Colors.grey[900] : Colors.grey[100],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 48,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No activity yet',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Start tracking by adding chickens or logging production',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.grey[500],
                                      ),
                                ),
                              ],
                            ),
                          );
                        }

                        final recentLogs = logs.take(5).toList();
                        return Column(
                          children: recentLogs.map((log) {
                            final date = log.date;
                            final formattedDate =
                                '${date.month}/${date.day}/${date.year}';
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Icon(
                                  Icons.egg,
                                  color: Colors.amber[600],
                                ),
                                title: Text(
                                  '${log.totalEggs} eggs logged',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                subtitle: Text(
                                  '$formattedDate • ${log.layingHens} hens active',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                trailing: Text(
                                  '${log.eggsPerHen.toStringAsFixed(2)}/hen',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: const Color(0xFF2A78B9),
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: isDark ? Colors.grey[900] : Colors.grey[100],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Loading activity...',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                      error: (err, st) => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: isDark ? Colors.grey[900] : Colors.grey[100],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red[400],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Error loading activity',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.red[400],
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_quickAddOpen) ...[
            _QuickAddButton(
              label: 'Add Sale',
              icon: Icons.receipt_long,
              color: const Color(0xFF0E7A4F),
              onTap: () {
                setState(() => _quickAddOpen = false);
                context.push(Routes.addSale);
              },
            ),
            const SizedBox(height: 8),
            _QuickAddButton(
              label: 'Add Expense',
              icon: Icons.account_balance_wallet,
              color: const Color(0xFFC5392A),
              onTap: () {
                setState(() => _quickAddOpen = false);
                context.push(Routes.addExpense);
              },
            ),
            const SizedBox(height: 8),
            _QuickAddButton(
              label: 'Add Purchase',
              icon: Icons.shopping_bag,
              color: const Color(0xFF0D6E77),
              onTap: () {
                setState(() => _quickAddOpen = false);
                context.push(Routes.addFlockPurchase);
              },
            ),
            const SizedBox(height: 10),
          ],
          FloatingActionButton.extended(
            onPressed: () {
              setState(() => _quickAddOpen = !_quickAddOpen);
            },
            icon: Icon(_quickAddOpen ? Icons.close : Icons.add),
            label: const Text('Quick Add'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Due Reminders Card shown on the home screen
// ---------------------------------------------------------------------------
class _DueRemindersCard extends ConsumerWidget {
  const _DueRemindersCard();

  Color _typeColor(String type) {
    switch (type) {
      case 'cleaning':
        return const Color(0xFF1565C0);
      case 'health_check':
        return const Color(0xFFE08A24);
      default:
        return const Color(0xFF2E7D32);
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'cleaning':
        return Icons.cleaning_services;
      case 'health_check':
        return Icons.health_and_safety;
      default:
        return Icons.grass;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final remindersAsync = ref.watch(allRemindersProvider);

    return remindersAsync.when(
      data: (all) {
        final due = all
            .where((r) => r.isActive && r.isDueOrOverdue)
            .toList();

        if (due.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDark
                  ? const Color(0xFF1A2A1A)
                  : const Color(0xFFE8F5E9),
            ),
            child: Row(
              children: [
                const Icon(Icons.task_alt,
                    color: Color(0xFF2E7D32), size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All caught up!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2E7D32),
                            ),
                      ),
                      Text(
                        'No reminders due today.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(Routes.reminders),
                  child: const Text('View All'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            for (final reminder in due.take(3))
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _typeColor(reminder.type)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(_typeIcon(reminder.type),
                        color: _typeColor(reminder.type), size: 20),
                  ),
                  title: Text(
                    reminder.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    reminder.isOverdue ? 'Overdue' : 'Due Today',
                    style: TextStyle(
                      color: reminder.isOverdue
                          ? Colors.red[700]
                          : Colors.orange[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () async {
                      await ref
                          .read(reminderRepositoryProvider)
                          .markDone(reminder);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('"${reminder.title}" marked done!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: const Text('Done'),
                  ),
                ),
              ),
            if (due.length > 3)
              TextButton(
                onPressed: () => context.push(Routes.reminders),
                child: Text(
                    '+ ${due.length - 3} more due — View all reminders'),
              ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _StatCardAsync extends ConsumerWidget {
  final String label;
  final IconData icon;
  final Color color;
  final ProviderListenable<dynamic> provider;
  final String Function(dynamic value)? formatter;

  const _StatCardAsync({
    required this.label,
    required this.icon,
    required this.color,
    required this.provider,
    this.formatter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 1,
      color: isDark ? const Color(0xFF222222) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Builder(
          builder: (context) {
            final asyncValue = ref.watch(provider);
            if (asyncValue.isLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              );
            } else if (asyncValue is AsyncError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.error_outline,
                        color: Colors.grey, size: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              );
            } else {
              final value = asyncValue.value;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatter != null ? formatter!(value) : value.toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final VoidCallback onPrimaryAction;
  final VoidCallback onSecondaryAction;
  final VoidCallback onTertiaryAction;

  const _HeroHeader({
    required this.onPrimaryAction,
    required this.onSecondaryAction,
    required this.onTertiaryAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF5C3B21), Color(0xFF8C6239)]
              : const [Color(0xFF8B5E3C), Color(0xFFB07A4E)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.agriculture, color: Colors.white, size: 28),
              SizedBox(width: 10),
              Text(
                'Farm Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Track flock health, eggs, sales, and expenses from one place.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: onPrimaryAction,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Log Eggs'),
              ),
              OutlinedButton.icon(
                onPressed: onSecondaryAction,
                icon: const Icon(Icons.receipt_long, color: Colors.white),
                label: const Text('Add Sale',
                    style: TextStyle(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.7)),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onTertiaryAction,
                icon: const Icon(Icons.account_balance_wallet,
                    color: Colors.white),
                label: const Text(
                  'Add Expense',
                  style: TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.7)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _SectionReveal extends StatelessWidget {
  final Widget child;

  const _SectionReveal({required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 450),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
