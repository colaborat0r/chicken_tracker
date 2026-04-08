import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/router.dart';
import '../../../core/providers/repository_providers.dart';
import '../models/guide_models.dart';
import '../providers/guides_providers.dart';

class GuidesListScreen extends ConsumerStatefulWidget {
  final String? initialCategory;

  const GuidesListScreen({super.key, this.initialCategory});

  @override
  ConsumerState<GuidesListScreen> createState() => _GuidesListScreenState();
}

class _GuidesListScreenState extends ConsumerState<GuidesListScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(guideSearchQueryProvider.notifier).state = '';
      final category = widget.initialCategory;
      if (category != null && category.isNotEmpty) {
        ref.read(selectedGuideCategoryProvider.notifier).state = category;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredAsync = ref.watch(filteredGuidesProvider);
    final categoriesAsync = ref.watch(guideCategoriesProvider);
    final selectedCategory = ref.watch(selectedGuideCategoryProvider);
    final bookmarksAsync = ref.watch(bookmarkedGuideIdsProvider);
    final progressAsync = ref.watch(readProgressMapProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guides Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            tooltip: 'Saved guides',
            onPressed: () => context.push(Routes.savedGuides),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search title, tags, or guide content',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(guideSearchQueryProvider.notifier).state = '';
                          setState(() {});
                        },
                      ),
              ),
              onChanged: (value) {
                ref.read(guideSearchQueryProvider.notifier).state = value;
                setState(() {});
              },
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: categoriesAsync.when(
                data: (categories) {
                  return DropdownButton<String>(
                    value: categories.contains(selectedCategory)
                        ? selectedCategory
                        : 'All',
                    items: [
                      for (final category in categories)
                        DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      ref.read(selectedGuideCategoryProvider.notifier).state = value;
                    },
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filteredAsync.when(
                data: (guides) {
                  if (guides.isEmpty) {
                    return const Center(
                      child: Text('No guides match your search/filter.'),
                    );
                  }

                  return bookmarksAsync.when(
                    data: (bookmarks) => progressAsync.when(
                      data: (progressMap) => ListView.builder(
                        itemCount: guides.length,
                        itemBuilder: (context, index) {
                          final guide = guides[index];
                          final progress = progressMap[guide.id];

                          return _GuideListTile(
                            guide: guide,
                            isBookmarked: bookmarks.contains(guide.id),
                            progressPercent: progress?.progressPercent ?? 0,
                            onOpen: () => context.push(
                              '/guides/${Uri.encodeComponent(guide.id)}',
                            ),
                            onToggleBookmark: () async {
                              await ref
                                  .read(guidesRepositoryProvider)
                                  .toggleBookmark(guide.id);
                            },
                          );
                        },
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (e, _) => Center(child: Text('Error: $e')),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (e, _) => Center(child: Text('Error: $e')),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Failed to load guides: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideListTile extends StatelessWidget {
  final GuideArticle guide;
  final bool isBookmarked;
  final int progressPercent;
  final VoidCallback onOpen;
  final VoidCallback onToggleBookmark;

  const _GuideListTile({
    required this.guide,
    required this.isBookmarked,
    required this.progressPercent,
    required this.onOpen,
    required this.onToggleBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onOpen,
        title: Text(
          guide.title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${guide.category} • ${guide.readMinutes} min • ${guide.season}'),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: progressPercent / 100,
                minHeight: 4,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 2),
              Text('Read progress: $progressPercent%'),
            ],
          ),
        ),
        trailing: IconButton(
          icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
          onPressed: onToggleBookmark,
        ),
      ),
    );
  }
}
