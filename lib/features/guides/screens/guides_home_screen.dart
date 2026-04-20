import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/router.dart';
import '../providers/guides_providers.dart';

class GuidesHomeScreen extends ConsumerWidget {
  const GuidesHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final guidesAsync = ref.watch(allGuidesProvider);
    final categoriesAsync = ref.watch(guideCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tips & Guides'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            tooltip: 'Saved guides',
            onPressed: () => context.push(Routes.savedGuides),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF1A1A20), Color(0xFF111115)]
                : const [Color(0xFFF9F6EF), Color(0xFFFFFCF5)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _HeroCard(
              onBrowse: () => context.push(Routes.guides),
              onSaved: () => context.push(Routes.savedGuides),
            ),
            const SizedBox(height: 20),
            const Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            categoriesAsync.when(
              data: (categories) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final category in categories.where((c) => c != 'All'))
                    ActionChip(
                      label: Text(category),
                      avatar: const Icon(Icons.category, size: 18),
                      onPressed: () {
                        final encoded = Uri.encodeComponent(category);
                        context.push('${Routes.guides}?category=$encoded');
                      },
                    ),
                ],
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Failed loading categories: $e'),
            ),
            const SizedBox(height: 22),
            const Text(
              'Featured Reads',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            guidesAsync.when(
              data: (guides) {
                if (guides.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No guides available yet.'),
                    ),
                  );
                }

                return Column(
                  children: [
                    for (final guide in guides.take(3))
                      Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const Icon(Icons.menu_book),
                          title: Text(
                            guide.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${guide.category} • ${guide.readMinutes} min',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () =>
                              context.push('/guides/${Uri.encodeComponent(guide.id)}'),
                        ),
                      ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Failed loading guides: $e'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final VoidCallback onBrowse;
  final VoidCallback onSaved;

  const _HeroCard({required this.onBrowse, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF0E2141), Color(0xFF2E7D32)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Farm Wisdom, Always Offline',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Search practical guides for brooding, feeding, biosecurity, and seasonal care.',
            style: TextStyle(color: Colors.white, height: 1.35),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: onBrowse,
                icon: const Icon(Icons.travel_explore),
                label: const Text('Browse Guides'),
              ),
              OutlinedButton.icon(
                onPressed: onSaved,
                icon: const Icon(Icons.bookmark),
                label: const Text('Saved'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
