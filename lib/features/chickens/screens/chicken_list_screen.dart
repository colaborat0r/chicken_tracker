import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/database_providers.dart';
import '../../../config/router.dart';
import '../../../core/widgets/app_ui_components.dart';

class ChickenListScreen extends ConsumerStatefulWidget {
  const ChickenListScreen({super.key});

  @override
  ConsumerState<ChickenListScreen> createState() => _ChickenListScreenState();
}

class _ChickenListScreenState extends ConsumerState<ChickenListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _statusFilter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chickenAsyncValue = ref.watch(allChickensProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Flock'),
        elevation: 0,
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
        child: chickenAsyncValue.when(
          data: (chickens) {
            final query = _searchController.text.trim().toLowerCase();
            final filteredChickens = chickens.where((chicken) {
              final matchesStatus = switch (_statusFilter) {
                'active' => chicken.isActive,
                'inactive' => !chicken.isActive,
                _ => true,
              };
              if (!matchesStatus) {
                return false;
              }

              if (query.isEmpty) {
                return true;
              }

              final eggColor = (chicken.eggColor ?? '').toLowerCase();
              return chicken.breed.toLowerCase().contains(query) ||
                  chicken.status.toLowerCase().contains(query) ||
                  eggColor.contains(query);
            }).toList();

            if (filteredChickens.isEmpty) {
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => context.push(Routes.addChicken),
                          icon: const Icon(Icons.add),
                          label: const Text('Add One Chicken'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () =>
                              context.push(Routes.addMultipleChickens),
                          icon: const Icon(Icons.groups),
                          label: const Text('Add Multiple Chickens'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            // Organize chickens by status
            final activeChickens =
                filteredChickens.where((c) => c.isActive).toList();
            final inactiveChickens =
                filteredChickens.where((c) => !c.isActive).toList();
            final layingCount =
                activeChickens.where((c) => c.status == 'laying').length;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: _FlockHero(
                      total: filteredChickens.length,
                      active: activeChickens.length,
                      laying: layingCount,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _searchController,
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration(
                                hintText: 'Search breed, status, or egg color',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              children: [
                                ChoiceChip(
                                  label: const Text('All'),
                                  selected: _statusFilter == 'all',
                                  onSelected: (_) {
                                    setState(() => _statusFilter = 'all');
                                  },
                                ),
                                ChoiceChip(
                                  label: const Text('Active'),
                                  selected: _statusFilter == 'active',
                                  onSelected: (_) {
                                    setState(() => _statusFilter = 'active');
                                  },
                                ),
                                ChoiceChip(
                                  label: const Text('Inactive'),
                                  selected: _statusFilter == 'inactive',
                                  onSelected: (_) {
                                    setState(() => _statusFilter = 'inactive');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Age & Status Summary
                  if (activeChickens.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                      child: _AgeStatusSummary(
                        chickens: activeChickens,
                      ),
                    ),
                  if (activeChickens.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: AppSectionHeader(
                        title: 'Active Flock (${activeChickens.length})',
                        subtitle: 'Productive birds currently in rotation',
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
                      child: AppSectionHeader(
                        title: 'Inactive (${inactiveChickens.length})',
                        subtitle: 'Retired, sold, or archived birds',
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
                  SizedBox(height: appFabSafeBottomSpacing(context)),
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
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'add-one-chicken',
            onPressed: () => context.push(Routes.addChicken),
            icon: const Icon(Icons.add),
            label: const Text('Add One Chicken'),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'add-multiple-chickens',
            onPressed: () => context.push(Routes.addMultipleChickens),
            icon: const Icon(Icons.groups),
            label: const Text('Add Multiple Chickens'),
          ),
        ],
      ),
    );
  }
}

class _FlockHero extends StatelessWidget {
  final int total;
  final int active;
  final int laying;

  const _FlockHero({
    required this.total,
    required this.active,
    required this.laying,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF8A5A2B), Color(0xFF6D451E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Flock Overview',
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _HeroMetric(label: 'Total', value: '$total'),
              const SizedBox(width: 18),
              _HeroMetric(label: 'Active', value: '$active'),
              const SizedBox(width: 18),
              _HeroMetric(label: 'Laying', value: '$laying'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  final String label;
  final String value;

  const _HeroMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
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

class _AgeStatusSummary extends StatelessWidget {
  final List<dynamic> chickens;

  const _AgeStatusSummary({required this.chickens});

  @override
  Widget build(BuildContext context) {
    final totalChickens = chickens.length;
    
    // Age-based categories
    final layingCount = chickens
        .where((c) => c.status == 'laying' && c.ageInDays >= 140)
        .length;
    final growingCount =
        chickens.where((c) => c.status == 'growing').length;
    final approachingLayingCount = chickens
        .where((c) =>
            c.ageInDays >= 130 &&
            c.ageInDays < 140 &&
            c.status == 'growing')
        .length;
    final retiredCount =
        chickens.where((c) => c.status == 'retired').length;

    // Calculate percentages
    final layingPct = totalChickens > 0
        ? ((layingCount / totalChickens) * 100).toStringAsFixed(0)
        : '0';
    final growingPct = totalChickens > 0
        ? ((growingCount / totalChickens) * 100).toStringAsFixed(0)
        : '0';
    final approachingPct = totalChickens > 0
        ? ((approachingLayingCount / totalChickens) * 100).toStringAsFixed(0)
        : '0';
    final retiredPct = totalChickens > 0
        ? ((retiredCount / totalChickens) * 100).toStringAsFixed(0)
        : '0';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Age & Status Breakdown',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.0,
              children: [
                _StatusCard(
                  emoji: '🥚',
                  label: 'Laying',
                  count: layingCount,
                  percentage: '$layingPct%',
                  color: Colors.green,
                ),
                _StatusCard(
                  emoji: '👶',
                  label: 'Growing',
                  count: growingCount,
                  percentage: '$growingPct%',
                  color: Colors.blue,
                ),
                _StatusCard(
                  emoji: '⏰',
                  label: 'Ready Soon',
                  count: approachingLayingCount,
                  percentage: '$approachingPct%',
                  color: Colors.amber,
                  subtitle:
                      '${130}-140 days',
                ),
                _StatusCard(
                  emoji: '😴',
                  label: 'Retired',
                  count: retiredCount,
                  percentage: '$retiredPct%',
                  color: Colors.grey,
                ),
              ],
            ),
            if (approachingLayingCount > 0) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$approachingLayingCount bird${approachingLayingCount == 1 ? '' : 's'} approaching laying age (130-140 days)',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.amber[700],
                                  fontSize: 11,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String emoji;
  final String label;
  final int count;
  final String percentage;
  final Color color;
  final String? subtitle;

  const _StatusCard({
    required this.emoji,
    required this.label,
    required this.count,
    required this.percentage,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(10),
        color: color.withValues(alpha: 0.08),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            '$count',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          else
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                  ),
              textAlign: TextAlign.center,
            ),
          Text(
            percentage,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}
