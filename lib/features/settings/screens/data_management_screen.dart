import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../../../core/providers/database_providers.dart';
import '../../../core/services/backup_service.dart';

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

  Future<void> _restoreFromBackup() async {
    if (_backups.isEmpty) {
      _showMessage('No local backup found to restore.', isError: true);
      return;
    }

    final confirmed = await _confirmAction(
      title: 'Restore from backup?',
      message:
          'This will replace your current app data with the selected backup.',
      confirmText: 'Restore',
      destructive: true,
    );
    if (confirmed != true) return;

    final selected = await _pickBackupFile();
    if (selected == null) return;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore'),
      ),
      body: AbsorbPointer(
        absorbing: _isWorking,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
                        'Replace current data using one of your local backups.'),
                    onTap: _restoreFromBackup,
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
