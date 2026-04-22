import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../../../core/providers/database_providers.dart';
import '../../../core/providers/theme_providers.dart';
import '../../../core/services/backup_service.dart';
import '../../../core/services/backup_scheduler_service.dart';
import '../../../core/services/csv_import_service.dart';

enum _BackupSourceAction { saved, browse }

class DataManagementScreen extends ConsumerStatefulWidget {
  const DataManagementScreen({super.key});

  @override
  ConsumerState<DataManagementScreen> createState() =>
      _DataManagementScreenState();
}

class _DataManagementScreenState extends ConsumerState<DataManagementScreen> {
  bool _isWorking = false;
  DateTime? _lastBackupTime;
  List<File> _backups = const [];

  @override
  void initState() {
    super.initState();
    _loadBackups();
  }

  Future<void> _loadBackups() async {
    final entities = await BackupService.listBackups();
    final backups = entities.whereType<File>().toList();

    DateTime? newest;
    if (backups.isNotEmpty) {
      final first = backups.first;
      newest = await first.lastModified();
    }

    if (!mounted) return;
    setState(() {
      _backups = backups;
      _lastBackupTime = newest;
    });
  }

  Future<void> _importCsv() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;

      final file = File(result.files.first.path!);
      final fileName = p.basename(file.path);

      // Show import type selection
      if (!mounted) return;
      final importType = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Import Type'),
          content: const Text('What would you like to import?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'production'),
              child: const Text('Production Data'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'flock'),
              child: const Text('Flock Inventory'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );

      if (importType == null) return;

      setState(() => _isWorking = true);

      final db = ref.read(databaseProvider);
      final results = importType == 'production'
          ? await CsvImportService.importProductionCsv(file, db)
          : await CsvImportService.importFlockInventoryCsv(file, db);

      if (!mounted) return;
      final imported = results['imported'] as int;
      final skipped = results['skipped'] as int;
      final errors = results['errors'] as List<String>;

      String message = 'Imported $imported records from $fileName';
      if (skipped > 0) message += ' (skipped $skipped)';
      if (errors.isNotEmpty) {
        message += '\n\nWarnings:\n${errors.take(3).join('\n')}';
        if (errors.length > 3) message += '\n...and ${errors.length - 3} more';
      }

      _showMessage(message, isError: errors.isNotEmpty);
    } catch (e) {
      _showMessage('Import failed: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }
  Future<void> _createBackup() async {
    final db = ref.read(databaseProvider);
    setState(() => _isWorking = true);
    try {
      final file = await BackupService.createBackup(db);
      await _loadBackups();
      final timestamp = DateFormat('d MMM yyyy, HH:mm').format(DateTime.now());
      _showMessage('Backup created: $timestamp (${p.basename(file.path)})');
    } catch (e) {
      _showMessage('Backup failed: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _exportLatestBackup() async {
    if (_backups.isEmpty) {
      _showMessage('No backup found to export.', isError: true);
      return;
    }

    setState(() => _isWorking = true);
    try {
      await BackupService.exportBackup(_backups.first);
      _showMessage('Backup exported successfully.');
    } catch (e) {
      _showMessage('Export failed: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _manageStoredBackups() async {
    if (_backups.isEmpty) {
      _showMessage('No saved backups to manage.', isError: true);
      return;
    }

    final selected = await showModalBottomSheet<List<File>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        final selectedPaths = <String>{};

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manage Stored Backups',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Select one or more backup files to delete.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _backups.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final file = _backups[index];
                          final fileName = p.basename(file.path);
                          final metadata =
                              BackupSchedulerService.parseBackupFilename(file);
                          final isSelected = selectedPaths.contains(file.path);

                          return CheckboxListTile(
                            value: isSelected,
                            contentPadding: EdgeInsets.zero,
                            secondary: const Icon(Icons.folder_copy_outlined),
                            title: Text(fileName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: metadata.isAutomatic
                                            ? Colors.blue.withValues(alpha: 0.2)
                                            : Colors.green
                                                .withValues(alpha: 0.2),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        metadata.type,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: metadata.isAutomatic
                                              ? Colors.blue[700]
                                              : Colors.green[700],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        metadata.displayLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  file.path,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: Colors.grey,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            isThreeLine: true,
                            onChanged: (value) {
                              setSheetState(() {
                                if (value == true) {
                                  selectedPaths.add(file.path);
                                } else {
                                  selectedPaths.remove(file.path);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        const Spacer(),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            foregroundColor:
                                Theme.of(context).colorScheme.onError,
                          ),
                          onPressed: selectedPaths.isEmpty
                              ? null
                              : () {
                                  final selectedFiles = _backups
                                      .where(
                                        (file) =>
                                            selectedPaths.contains(file.path),
                                      )
                                      .toList();
                                  Navigator.of(context).pop(selectedFiles);
                                },
                          child: Text(
                            selectedPaths.length <= 1
                                ? 'Delete Selected'
                                : 'Delete ${selectedPaths.length} Selected',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (selected == null || selected.isEmpty) return;

    final confirmed = await _confirmDeleteBackups(selected);
    if (confirmed != true) return;

    setState(() => _isWorking = true);
    try {
      final deletedCount = await BackupService.deleteBackups(selected);
      await _loadBackups();
      _showMessage(
        deletedCount == 1
            ? 'Deleted 1 backup file.'
            : 'Deleted $deletedCount backup files.',
      );
    } catch (e) {
      _showMessage('Delete failed: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _restoreFromBackup() async {
    final selected = await _pickBackupFile();
    if (selected == null) return;

    final confirmed = await _confirmRestoreSelection(selected);
    if (confirmed != true) return;

    final db = ref.read(databaseProvider);
    setState(() => _isWorking = true);
    try {
      await BackupService.restoreFromBackup(db, selected);
      await _loadBackups();
      _showMessage('Restore complete from ${p.basename(selected.path)}');
    } catch (e) {
      _showMessage('Restore failed: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _resetData() async {
    final firstConfirm = await _confirmAction(
      title: 'Reset all data?',
      message: 'This permanently deletes all records in the app.',
      confirmText: 'Continue',
      destructive: true,
    );
    if (firstConfirm != true) return;

    final typedConfirm = await _confirmWithText();
    if (typedConfirm != true) return;

    final db = ref.read(databaseProvider);
    setState(() => _isWorking = true);
    try {
      await BackupService.resetAllData(db);
      _showMessage('All data has been reset.');
    } catch (e) {
      _showMessage('Reset failed: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<File?> _pickBackupFile() async {
    final action = await showModalBottomSheet<_BackupSourceAction>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text('Select backup source'),
                subtitle:
                    Text('Use a saved app backup or browse local storage.'),
              ),
              if (_backups.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.folder_copy_outlined),
                  title: const Text('Choose from saved backups'),
                  subtitle: Text('${_backups.length} file(s) available'),
                  onTap: () => Navigator.of(context).pop(_BackupSourceAction.saved),
                ),
              ListTile(
                leading: const Icon(Icons.folder_open),
                title: const Text('Browse local storage'),
                subtitle: const Text('Pick a .json backup file from device'),
                onTap: () => Navigator.of(context).pop(_BackupSourceAction.browse),
              ),
            ],
          ),
        );
      },
    );

    if (action == _BackupSourceAction.saved) {
      return _pickSavedBackupFile();
    }
    if (action == _BackupSourceAction.browse) {
      return _pickBackupFromStorage();
    }

    return null;
  }

  Future<File?> _pickSavedBackupFile() async {
    if (_backups.isEmpty) {
      _showMessage('No saved backups found. Browse local storage instead.',
          isError: true);
      return null;
    }

    if (_backups.length == 1) return _backups.first;

    return showModalBottomSheet<File>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _backups.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final file = _backups[index];
              return ListTile(
                leading: const Icon(Icons.folder_copy_outlined),
                title: Text(p.basename(file.path)),
                subtitle: Text(file.path),
                onTap: () => Navigator.of(context).pop(file),
              );
            },
          ),
        );
      },
    );
  }

  Future<File?> _pickBackupFromStorage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      allowMultiple: false,
      withData: false,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final selectedPath = result.files.single.path;
    if (selectedPath == null || selectedPath.isEmpty) {
      _showMessage('Could not access selected file path.', isError: true);
      return null;
    }

    final file = File(selectedPath);
    if (!await file.exists()) {
      _showMessage('Selected file no longer exists.', isError: true);
      return null;
    }

    return file;
  }

  Future<bool?> _confirmRestoreSelection(File file) {
    final fileName = p.basename(file.path);

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore from backup?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This will replace your current app data with the selected backup file.',
            ),
            const SizedBox(height: 12),
            Text(
              'Selected file:',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 4),
            Text(
              fileName,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmDeleteBackups(List<File> files) {
    final fileCount = files.length;
    final previewNames = files.take(3).map((file) => p.basename(file.path));
    final previewText = previewNames.join('\n');
    final hasMore = fileCount > 3;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(fileCount == 1
            ? 'Delete selected backup?'
            : 'Delete selected backups?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fileCount == 1
                  ? 'This will permanently delete the selected backup file.'
                  : 'This will permanently delete the selected backup files.',
            ),
            const SizedBox(height: 12),
            Text(
              previewText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            if (hasMore) ...[
              const SizedBox(height: 8),
              Text('And ${fileCount - 3} more...'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmAction({
    required String title,
    required String message,
    required String confirmText,
    bool destructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: destructive
                ? FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  )
                : null,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmWithText() {
    final controller = TextEditingController();

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Final confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Type RESET to confirm data reset.'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'RESET',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () {
              final isValid = controller.text.trim().toUpperCase() == 'RESET';
              Navigator.of(context).pop(isValid);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }

  String _formatDate(DateTime? value) {
    if (value == null) return 'No backups yet';
    return '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')} '
        '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
      ),
      body: AbsorbPointer(
        absorbing: _isWorking,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Theme Toggle Card
            Card(
              child: ListTile(
                leading: Icon(
                  themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                  color: themeMode == ThemeMode.dark ? Colors.amber : Colors.orange,
                ),
                title: const Text('Appearance'),
                subtitle: Text(
                  themeMode == ThemeMode.dark ? 'Dark Mode' : 'Light Mode',
                ),
                trailing: Switch(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    ref.read(themeModeProvider.notifier).setThemeMode(
                      value ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Data Import',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.upload_file, color: Colors.purple),
                title: const Text('Import from CSV'),
                subtitle: const Text(
                    'Restore production logs or flock data from exported files.'),
                onTap: _importCsv,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Backup & Restore',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Last backup'),
                subtitle: Text(_formatDate(_lastBackupTime)),
                trailing: Text('${_backups.length} file(s)'),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading:
                        const Icon(Icons.backup_outlined, color: Colors.green),
                    title: const Text('Create Backup'),
                    subtitle: const Text(
                        'Save a local backup of your farm records now.'),
                    onTap: _createBackup,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.restore, color: Colors.blue),
                    title: const Text('Restore from Backup'),
                    subtitle: const Text(
                        'Restore from saved backups or browse local storage.'),
                    onTap: _restoreFromBackup,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.delete_sweep_outlined,
                        color: Colors.redAccent),
                    title: const Text('Manage Stored Backups'),
                    subtitle: const Text(
                        'Select saved backup files and delete the ones you no longer need.'),
                    onTap: _manageStoredBackups,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading:
                        const Icon(Icons.share_outlined, color: Colors.orange),
                    title: const Text('Export Backup'),
                    subtitle: const Text(
                        'Share the latest backup file to storage or other apps.'),
                    onTap: _exportLatestBackup,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Advanced',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.delete_forever,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Reset App Data',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                subtitle: const Text(
                    'Permanently delete all app data and start fresh.'),
                onTap: _resetData,
              ),
            ),
            if (_isWorking) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }
}
