import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../config/router.dart';
import '../../../core/models/care_log_model.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/widgets/app_ui_components.dart';

class CareLogsScreen extends ConsumerStatefulWidget {
  const CareLogsScreen({super.key});

  @override
  ConsumerState<CareLogsScreen> createState() => _CareLogsScreenState();
}

class _CareLogsScreenState extends ConsumerState<CareLogsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteLog(CareLogModel log) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete care note?'),
        content: Text(
          'Delete "${log.title}" from ${DateFormat.yMMMd().format(log.date)}? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await ref.read(careLogRepositoryProvider).deleteCareLog(log);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Care note deleted')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(allCareLogsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Logs'),
        actions: [
          IconButton(
            tooltip: 'Photo gallery',
            icon: const Icon(Icons.photo_library_outlined),
            onPressed: () => context.push(Routes.careLogGallery),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.addCareLog),
        icon: const Icon(Icons.note_add_outlined),
        label: const Text('Log Notes'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF1A2E1C), Color(0xFF101810)]
                : const [Color(0xFFE8F5E9), Color(0xFFF9FFF9)],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: logsAsync.when(
                data: (logs) {
                  final query = _searchController.text.trim().toLowerCase();
                  final filtered = logs.where((log) {
                    if (query.isEmpty) return true;
                    return log.title.toLowerCase().contains(query) ||
                        (log.notes ?? '').toLowerCase().contains(query);
                  }).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.notes_outlined,
                              size: 64,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              query.isEmpty
                                  ? 'No care notes yet'
                                  : 'No notes match your search',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap Log Notes to record observations and photos.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      appFabSafeBottomSpacing(context),
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final log = filtered[index];
                      return _CareLogCard(
                        log: log,
                        onTap: () => context.push(
                          Routes.addCareLog,
                          extra: log,
                        ),
                        onDelete: () => _deleteLog(log),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CareLogCard extends StatelessWidget {
  final CareLogModel log;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _CareLogCard({
    required this.log,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final preview = (log.notes ?? '').trim();
    final firstPhoto = log.photos.isNotEmpty ? log.photos.first : null;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (firstPhoto != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(firstPhoto.filePath),
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.note_alt_outlined,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat.yMMMd().format(log.date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    if (preview.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (log.photos.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.photo_outlined, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${log.photos.length} photo${log.photos.length == 1 ? '' : 's'}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
