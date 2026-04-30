import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/report_settings_provider.dart';
import '../../../core/services/pdf_export_service.dart';

/// A pre-generation dialog that lets the user:
///  - Read what the Farm Report is
///  - Toggle which metrics to include
///  - Attach up to 4 photos with captions
class FarmReportDialog extends ConsumerStatefulWidget {
  const FarmReportDialog({super.key});

  @override
  ConsumerState<FarmReportDialog> createState() => _FarmReportDialogState();
}

class _FarmReportDialogState extends ConsumerState<FarmReportDialog> {
  // Local copies of metric toggles — initialised from provider in initState
  late bool _totalEggs;
  late bool _totalSales;
  late bool _totalExpenses;
  late bool _profitLoss;
  late bool _flockCount;
  late bool _layingCount;
  late bool _feedPerEgg;
  late bool _layingPercentage;

  final List<_PhotoEntry> _photos = [];

  @override
  void initState() {
    super.initState();
    final s = ref.read(reportSettingsProvider);
    _totalEggs = s.totalEggs;
    _totalSales = s.totalSales;
    _totalExpenses = s.totalExpenses;
    _profitLoss = s.profitLoss;
    _flockCount = s.flockCount;
    _layingCount = s.layingCount;
    _feedPerEgg = s.feedPerEgg;
    _layingPercentage = s.layingPercentage;
  }

  Future<void> _pickPhoto() async {
    if (_photos.length >= 4) return;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;
    final path = result.files.first.path;
    if (path == null) return;
    setState(() {
      _photos.add(_PhotoEntry(filePath: path, captionController: TextEditingController()));
    });
  }

  void _removePhoto(int index) {
    setState(() {
      _photos[index].captionController.dispose();
      _photos.removeAt(index);
    });
  }

  ReportSettings _buildSettings() => ReportSettings(
        totalEggs: _totalEggs,
        totalSales: _totalSales,
        totalExpenses: _totalExpenses,
        profitLoss: _profitLoss,
        flockCount: _flockCount,
        layingCount: _layingCount,
        feedPerEgg: _feedPerEgg,
        layingPercentage: _layingPercentage,
      );

  List<FarmReportPhoto> _buildPhotos() => _photos
      .map((p) => FarmReportPhoto(
            filePath: p.filePath,
            caption: p.captionController.text.trim(),
          ))
      .toList();

  @override
  void dispose() {
    for (final p in _photos) {
      p.captionController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const brown = Color(0xFF8A5A2B);

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header banner ─────────────────────────────────────────────
              Container(
                width: double.infinity,
                color: const Color(0xFF6D451E),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Farm Report Card',
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(
                            'A shareable one-page PDF snapshot of your flock '
                            'and egg production.',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Metrics section ──────────────────────────────────
                    Text('Choose which stats appear on the report.',
                        style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold, color: brown)),
                    const SizedBox(height: 8),
                    _metricTile('🥚 Total Eggs', _totalEggs,
                        (v) => setState(() => _totalEggs = v!)),
                    _metricTile('💰 Total Sales', _totalSales,
                        (v) => setState(() => _totalSales = v!)),
                    _metricTile('💸 Total Expenses', _totalExpenses,
                        (v) => setState(() => _totalExpenses = v!)),
                    _metricTile('📊 Profit / Loss', _profitLoss,
                        (v) => setState(() => _profitLoss = v!)),
                    _metricTile('🐔 Flock Count', _flockCount,
                        (v) => setState(() => _flockCount = v!)),
                    _metricTile('🥚 Laying Hens', _layingCount,
                        (v) => setState(() => _layingCount = v!)),
                    _metricTile('🌾 Feed per Egg', _feedPerEgg,
                        (v) => setState(() => _feedPerEgg = v!)),
                    _metricTile('📈 Laying %', _layingPercentage,
                        (v) => setState(() => _layingPercentage = v!)),

                    const Divider(height: 28),

                    // ── Photos section ───────────────────────────────────
                    Text('Farm Photos  (optional)',
                        style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold, color: brown)),
                    const SizedBox(height: 4),
                    Text(
                      'Add up to 4 photos. They appear on a second page of the report with your caption.',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 12),
                    if (_photos.isEmpty)
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: _pickPhoto,
                          icon: const Icon(Icons.add_photo_alternate_outlined),
                          label: const Text('Add Photo'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: brown,
                            side: const BorderSide(color: brown),
                          ),
                        ),
                      )
                    else ...[
                      ..._photos.asMap().entries.map((e) {
                        final i = e.key;
                        final p = e.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Thumbnail
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(
                                  File(p.filePath),
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Container(
                                        width: 64,
                                        height: 64,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image),
                                      ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Caption
                              Expanded(
                                child: TextField(
                                  controller: p.captionController,
                                  decoration: InputDecoration(
                                    hintText: 'Caption (optional)',
                                    isDense: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                  ),
                                  maxLength: 80,
                                  maxLines: 2,
                                  buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
                                      null,
                                ),
                              ),
                              // Remove button
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                tooltip: 'Remove',
                                onPressed: () => _removePhoto(i),
                              ),
                            ],
                          ),
                        );
                      }),
                      if (_photos.length < 4)
                        TextButton.icon(
                          onPressed: _pickPhoto,
                          icon: const Icon(Icons.add_photo_alternate_outlined),
                          label: const Text('Add Another Photo'),
                          style: TextButton.styleFrom(foregroundColor: brown),
                        ),
                    ],
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () {
            // Save metric preferences back to provider
            final notifier = ref.read(reportSettingsProvider.notifier);
            final s = _buildSettings();
            for (final metric in ReportMetric.values) {
              notifier.setMetricEnabled(metric, s.isEnabled(metric));
            }
            Navigator.of(context).pop(
              FarmReportDialogResult(
                settings: s,
                photos: _buildPhotos(),
              ),
            );
          },
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Generate Report'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF6D451E),
          ),
        ),
      ],
    );
  }

  Widget _metricTile(String label, bool value, ValueChanged<bool?> onChanged) {
    return SizedBox(
      height: 36,
      child: CheckboxListTile(
        dense: true,
        title: Text(label, style: const TextStyle(fontSize: 13)),
        value: value,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _PhotoEntry {
  final String filePath;
  final TextEditingController captionController;
  _PhotoEntry({required this.filePath, required this.captionController});
}

class FarmReportDialogResult {
  final ReportSettings settings;
  final List<FarmReportPhoto> photos;
  FarmReportDialogResult({required this.settings, required this.photos});
}

/// Show the dialog and return the result (null = cancelled).
Future<FarmReportDialogResult?> showFarmReportDialog(BuildContext context) {
  return showDialog<FarmReportDialogResult>(
    context: context,
    builder: (_) => const FarmReportDialog(),
  );
}

