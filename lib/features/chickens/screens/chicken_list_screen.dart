import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/database_providers.dart';
import '../../../config/router.dart';

class ChickenListScreen extends ConsumerWidget {
  const ChickenListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chickenAsyncValue = ref.watch(allChickensProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Flock'),
        elevation: 0,
      ),
      body: chickenAsyncValue.when(
        data: (chickens) {
          if (chickens.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pets,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No chickens yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first chicken to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.push(Routes.addChicken),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Chicken'),
                  ),
                ],
              ),
            );
          }

          // Organize chickens by status
          final activeChickens = chickens
              .where((c) => c.isActive)
              .toList();
          final inactiveChickens = chickens
              .where((c) => !c.isActive)
              .toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (activeChickens.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Active Flock (${activeChickens.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activeChickens.length,
                    itemBuilder: (context, index) {
                      final chicken = activeChickens[index];
                      return _ChickenCard(
                        chicken: chicken,
                        onTap: () {
                          context.push(Routes.chickenDetail, extra: chicken);
                        },
                      );
                    },
                  ),
                ],
                if (inactiveChickens.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Inactive (${inactiveChickens.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: inactiveChickens.length,
                    itemBuilder: (context, index) {
                      final chicken = inactiveChickens[index];
                      return _ChickenCard(
                        chicken: chicken,
                        onTap: () {
                          context.push(Routes.chickenDetail, extra: chicken);
                        },
                        isInactive: true,
                      );
                    },
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
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
                'Error loading chickens',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.red[400],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.addChicken),
        icon: const Icon(Icons.add),
        label: const Text('Add Chicken'),
      ),
    );
  }
}

class _ChickenCard extends StatelessWidget {
  final dynamic chicken;
  final VoidCallback onTap;
  final bool isInactive;

  const _ChickenCard({
    required this.chicken,
    required this.onTap,
    this.isInactive = false,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(chicken.status);
    final statusEmoji = _getStatusEmoji(chicken.status);
    final age = chicken.ageInMonths;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        color: isInactive ? Colors.grey[900] : null,
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundColor: statusColor.withValues(alpha: 0.3),
            child: Text(
              statusEmoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          title: Text(
            chicken.breed,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: isInactive ? Colors.grey[500] : null,
            ),
          ),
          subtitle: Text(
            '$age ${age == 1 ? 'month' : 'months'} old • ${chicken.status} • ${chicken.eggColor ?? 'Unknown color'}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isInactive ? Colors.grey[600] : Colors.grey[500],
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: isInactive ? Colors.grey[600] : null,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'laying':
        return Colors.green;
      case 'growing':
        return Colors.blue;
      case 'broody':
        return Colors.amber;
      case 'brooding':
        return Colors.orange;
      case 'retired':
        return Colors.grey;
      case 'sold':
        return Colors.purple;
      case 'deceased':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusEmoji(String status) {
    switch (status) {
      case 'laying':
        return '🥚';
      case 'growing':
        return '👶';
      case 'broody':
        return '🪺';
      case 'brooding':
        return '🐣';
      case 'retired':
        return '😴';
      case 'sold':
        return '🤝';
      case 'deceased':
        return '🕊️';
      default:
        return '🐔';
    }
  }
}
