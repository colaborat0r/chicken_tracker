import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../config/router.dart';
import '../../../core/providers/database_providers.dart';

class FlockLossesScreen extends ConsumerWidget {
  const FlockLossesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lossesAsync = ref.watch(allFlockLossesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('⚠️ Flock Losses'),
        elevation: 0,
      ),
      body: lossesAsync.when(
        data: (losses) {
          if (losses.isEmpty) {
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
                    'No losses recorded yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Track flock reductions here',
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

          for (final loss in losses) {
            typeTotals[loss.type] = (typeTotals[loss.type] ?? 0) + loss.quantity;
            typeLosses.putIfAbsent(loss.type, () => []).add(loss);
          }

          final totalLosses = losses.fold<int>(0, (sum, loss) => sum + loss.quantity);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Total losses summary
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Total Flock Losses',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$totalLosses chickens',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

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
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$total',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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

              // Detailed losses list
              Text(
                'Loss History',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              ...losses.map((loss) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    _getLossIcon(loss.type),
                    color: _getLossColor(loss.type),
                  ),
                  title: Text(
                    '${loss.quantity} chicken${loss.quantity != 1 ? 's' : ''} lost',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                      if (loss.predatorSubtype != null && loss.type == 'predator') ...[
                        Text(
                          'Predator: ${loss.predatorSubtype}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                      color: _getLossColor(loss.type).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      loss.type.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                'Error loading losses: $error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
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
      case 'natural_causes':
        return 'Natural Causes';
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
      case 'natural_causes':
        return Icons.heart_broken;
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
      case 'natural_causes':
        return Colors.grey;
      case 'predator':
        return Colors.red;
      case 'sold':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }
}