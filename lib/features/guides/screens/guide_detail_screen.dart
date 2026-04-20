import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/repository_providers.dart';
import '../models/guide_models.dart';
import '../providers/guides_providers.dart';

class GuideDetailScreen extends ConsumerStatefulWidget {
  final String guideId;

  const GuideDetailScreen({super.key, required this.guideId});

  @override
  ConsumerState<GuideDetailScreen> createState() => _GuideDetailScreenState();
}

class _GuideDetailScreenState extends ConsumerState<GuideDetailScreen> {
  bool _markedRead = false;

  @override
  Widget build(BuildContext context) {
    final guideAsync = ref.watch(guideByIdProvider(widget.guideId));
    final bookmarksAsync = ref.watch(bookmarkedGuideIdsProvider);
    final progressAsync = ref.watch(readProgressMapProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Guide Detail')),
      body: guideAsync.when(
        data: (guide) {
          if (guide == null) {
            return const Center(child: Text('Guide not found.'));
          }

          if (!_markedRead) {
            _markedRead = true;
            Future.microtask(() {
              ref.read(guidesRepositoryProvider).markGuideRead(guide.id);
            });
          }

          return bookmarksAsync.when(
            data: (bookmarks) => progressAsync.when(
              data: (progressMap) {
                final progress = progressMap[guide.id]?.progressPercent ?? 0;
                final isBookmarked = bookmarks.contains(guide.id);

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      guide.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _MetaChip(label: guide.category, icon: Icons.category),
                        _MetaChip(
                          label: '${guide.readMinutes} min read',
                          icon: Icons.schedule,
                        ),
                        _MetaChip(
                          label: guide.difficulty,
                          icon: Icons.school,
                        ),
                        _MetaChip(label: guide.season, icon: Icons.wb_sunny),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress / 100,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(height: 6),
                    Text('Read progress: $progress%'),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () async {
                        await ref
                            .read(guidesRepositoryProvider)
                            .toggleBookmark(guide.id);
                      },
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      ),
                      label: Text(
                        isBookmarked ? 'Remove Bookmark' : 'Save Guide',
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final block in guide.blocks) _BlockRenderer(block: block),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed loading guide: $e')),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _MetaChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
    );
  }
}

class _BlockRenderer extends StatelessWidget {
  final GuideBlock block;

  const _BlockRenderer({required this.block});

  @override
  Widget build(BuildContext context) {
    switch (block.type) {
      case 'paragraph':
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text(
            block.text ?? '',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
          ),
        );
      case 'checklist':
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((block.title ?? '').isNotEmpty)
                  Text(
                    block.title!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                if ((block.title ?? '').isNotEmpty) const SizedBox(height: 8),
                for (final item in block.items ?? const <String>[])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.check_circle, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      case 'warning':
        return _CalloutCard(
          color: const Color(0xFFC5392A),
          icon: Icons.warning_amber,
          title: block.title ?? 'Warning',
          text: block.text ?? '',
        );
      case 'tip':
        return _CalloutCard(
          color: const Color(0xFF2E7D32),
          icon: Icons.tips_and_updates,
          title: block.title ?? 'Pro Tip',
          text: block.text ?? '',
        );
      case 'link':
        final label = block.label ?? block.url ?? 'Open link';
        final url = block.url;
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          child: ListTile(
            leading: const Icon(Icons.link),
            title: Text(label),
            subtitle: url == null ? null : Text(url),
            onTap: url == null
                ? null
                : () async {
                    final uri = Uri.parse(url);
                    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not open link.')),
                      );
                    }
                  },
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _CalloutCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String text;

  const _CalloutCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
