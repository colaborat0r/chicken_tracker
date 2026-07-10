import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/models/care_log_model.dart';
import '../../../core/providers/repository_providers.dart';

class CareLogGalleryScreen extends ConsumerWidget {
  const CareLogGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final galleryAsync = ref.watch(careLogGalleryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Log Photos'),
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
        child: galleryAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 64,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No care log photos yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add photos when you log care notes.',
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

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _GalleryTile(
                  item: item,
                  onTap: () => _openPhotoViewer(context, items, index),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  void _openPhotoViewer(
    BuildContext context,
    List<CareLogGalleryItem> items,
    int initialIndex,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _CareLogPhotoViewer(
          items: items,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  final CareLogGalleryItem item;
  final VoidCallback onTap;

  const _GalleryTile({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(item.photo.filePath),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image_outlined),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                color: Colors.black54,
                child: Text(
                  DateFormat.MMMd().format(item.log.date),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CareLogPhotoViewer extends StatefulWidget {
  final List<CareLogGalleryItem> items;
  final int initialIndex;

  const _CareLogPhotoViewer({
    required this.items,
    required this.initialIndex,
  });

  @override
  State<_CareLogPhotoViewer> createState() => _CareLogPhotoViewerState();
}

class _CareLogPhotoViewerState extends State<_CareLogPhotoViewer> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.items[_index];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_index + 1} of ${widget.items.length}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.items.length,
              onPageChanged: (value) => setState(() => _index = value),
              itemBuilder: (context, index) {
                final photo = widget.items[index].photo;
                return InteractiveViewer(
                  child: Center(
                    child: Image.file(
                      File(photo.filePath),
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.black87,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.log.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat.yMMMd().format(item.log.date),
                  style: const TextStyle(color: Colors.white70),
                ),
                if ((item.photo.caption ?? '').isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    item.photo.caption!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
                if ((item.log.notes ?? '').isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    item.log.notes!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white60),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
