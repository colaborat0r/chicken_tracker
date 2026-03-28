import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/database_providers.dart';
import '../../../config/router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🐔 Chicken Tracker',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.agriculture, size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    '🐔 Chicken Tracker',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
              child: Text('Flock', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
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
              child: Text('Production', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline, color: Colors.green),
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
              leading: const Icon(Icons.bar_chart_outlined, color: Colors.purple),
              title: const Text('Analytics'),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.analytics);
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('Finance', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
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
              leading: const Icon(Icons.account_balance_wallet, color: Colors.deepOrange),
              title: const Text('Expenses'),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.expenses);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.file_download_outlined, color: Colors.cyan),
              title: const Text('Reports & Exports'),
              onTap: () {
                Navigator.pop(context);
                context.push(Routes.reports);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Chicken Tracker',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Track your flock\'s health and egg production with ease.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Quick Stats Section
              Text(
                'Quick Stats',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _StatCardAsync(
                    label: 'Total Chickens',
                    icon: Icons.pets,
                    color: Colors.orange,
                    provider: activeChickensCountProvider,
                  ),
                  _StatCardAsync(
                    label: 'Eggs Today',
                    icon: Icons.egg,
                    color: Colors.amber,
                    provider: todayEggCountProvider,
                  ),
                  _StatCardAsync(
                    label: 'This Week',
                    icon: Icons.calendar_month,
                    color: Colors.blue,
                    provider: weeklyEggTotalProvider,
                  ),
                  const _StatCard(
                    label: 'Health Alerts',
                    value: '0',
                    icon: Icons.warning_amber,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions Section
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  _ActionButton(
                    label: 'Log Egg Production',
                    icon: Icons.add_circle_outline,
                    onPressed: () {
                      context.push(Routes.logProduction);
                    },
                  ),
                  const SizedBox(height: 8),
                  _ActionButton(
                    label: 'View Flock',
                    icon: Icons.pets,
                    onPressed: () {
                      context.push(Routes.chickenList);
                    },
                  ),
                  const SizedBox(height: 8),
                  _ActionButton(
                    label: 'Production History',
                    icon: Icons.history,
                    onPressed: () {
                      context.push(Routes.productionHistory);
                    },
                  ),
                  const SizedBox(height: 8),
                  _ActionButton(
                    label: 'Analytics',
                    icon: Icons.bar_chart_outlined,
                    onPressed: () {
                      context.push(Routes.analytics);
                    },
                  ),
                  const SizedBox(height: 8),
                  _ActionButton(
                    label: 'Reports & Exports',
                    icon: Icons.file_download_outlined,
                    onPressed: () {
                      context.push(Routes.reports);
                    },
                  ),
                  const SizedBox(height: 8),
                  _ActionButton(
                    label: 'Sales',
                    icon: Icons.receipt_long,
                    onPressed: () {
                      context.push(Routes.sales);
                    },
                  ),
                  const SizedBox(height: 8),
                  _ActionButton(
                    label: 'Expenses',
                    icon: Icons.account_balance_wallet,
                    onPressed: () {
                      context.push(Routes.expenses);
                    },
                  ),
                  const SizedBox(height: 8),
                  _ActionButton(
                    label: 'Flock Purchases',
                    icon: Icons.shopping_bag,
                    onPressed: () {
                      context.push(Routes.flockPurchases);
                    },
                  ),
                  const SizedBox(height: 8),
                  _ActionButton(
                    label: 'Flock Losses',
                    icon: Icons.warning_amber,
                    onPressed: () {
                      context.push(Routes.flockLosses);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Activity Section
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
                        color: isDark ? Colors.grey[900] : Colors.grey[100],
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
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start tracking by adding chickens or logging production',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  // Show last 5 logs
                  final recentLogs = logs.take(5).toList();
                  return Column(
                    children: recentLogs.map((log) {
                      final date = log.date;
                      final formattedDate = '${date.month}/${date.day}/${date.year}';
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            Icons.egg,
                            color: Colors.amber[600],
                          ),
                          title: Text(
                            '${log.totalEggs} eggs logged',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            '$formattedDate • ${log.layingHens} hens active',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          trailing: Text(
                            '${log.eggsPerHen.toStringAsFixed(2)}/hen',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.blue,
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(Routes.addChicken);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Chicken'),
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
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
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
        ),
      ),
    );
  }
}

class _StatCardAsync extends ConsumerWidget {
  final String label;
  final IconData icon;
  final Color color;
  final ProviderListenable<dynamic> provider;

  const _StatCardAsync({
    required this.label,
    required this.icon,
    required this.color,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Builder(
          builder: (context) {
            final asyncValue = ref.watch(provider);
            if (asyncValue.isLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 32),
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
                  Icon(icon, color: Colors.grey, size: 32),
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
                  Icon(icon, color: color, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    value.toString(),
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

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
