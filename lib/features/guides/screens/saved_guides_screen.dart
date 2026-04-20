import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/repository_providers.dart';
import '../providers/guides_providers.dart';

class SavedGuidesScreen extends ConsumerWidget {
  const SavedGuidesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedAsync = ref.watch(savedGuidesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Guides')),
      body: savedAsync.when(
        data: (guides) {
          if (guides.isEmpty) {
            return const Center(
              child: Text('No saved guides yet. Save one from the guide detail page.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: guides.length,
            itemBuilder: (context, index) {
              final guide = guides[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  onTap: () => context.push('/guides/${Uri.encodeComponent(guide.id)}'),
                  leading: const Icon(Icons.bookmark),
                  title: Text(
                    guide.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text('${guide.category} • ${guide.readMinutes} min'),
                  trailing: IconButton(
                    icon: const Icon(Icons.bookmark_remove),
                    tooltip: 'Remove from saved',
                    onPressed: () {
                      ref
                          .read(guidesRepositoryProvider)
                          .setBookmarked(guide.id, false);
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load saved guides: $e')),
      ),
    );
  }
}
