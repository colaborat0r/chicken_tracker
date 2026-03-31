import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/database_providers.dart';

class FlockPurchasesScreen extends ConsumerWidget {
  const FlockPurchasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasesAsync = ref.watch(allFlockPurchasesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Flock Purchases'),
        elevation: 0,
      ),
      body: purchasesAsync.when(
        data: (purchases) {
          if (purchases.isEmpty) {
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
                    'No purchases recorded yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Track your flock acquisitions here',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          // Group purchases by type
          final typeTotals = <String, Map<String, dynamic>>{};
          final typePurchases = <String, List<dynamic>>{};

          for (final purchase in purchases) {
            typeTotals.putIfAbsent(purchase.type, () => {
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
              // Summary cards
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
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${totalCost.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            '$totalQuantity total',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '\$count purchases',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Detailed purchases list
              Text(
                'Purchase History',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              ...purchases.map((purchase) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    _getPurchaseIcon(purchase.type),
                    color: _getPurchaseColor(purchase.type),
                  ),
                  title: Text(
                    '${purchase.quantity} ${_formatTypeName(purchase.type)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                        ),
                      ),
                      if (purchase.hatchedCount != null && purchase.type == 'hatching_eggs') ...[
                        Text(
                          'Hatched: ${purchase.hatchedCount} (${((purchase.hatchedCount! / purchase.quantity) * 100).toStringAsFixed(1)}%)',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ],
                  ),
                  trailing: Text(
                    '\$${purchase.cost.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              )),
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
}