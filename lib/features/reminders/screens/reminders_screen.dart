import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../config/router.dart';
import '../../../core/models/reminder_model.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/providers/repository_providers.dart';

// Type metadata helpers
IconData _typeIcon(String type) {
  switch (type) {
    case 'cleaning':
      return Icons.cleaning_services;
    case 'health_check':
      return Icons.health_and_safety;
    case 'feeding':
    default:
      return Icons.grass;
  }
}

Color _typeColor(String type) {
  switch (type) {
    case 'cleaning':
      return const Color(0xFF1565C0);
    case 'health_check':
      return const Color(0xFFE08A24);
    case 'feeding':
    default:
      return const Color(0xFF2E7D32);
  }
}

String _typeLabel(String type) {
  switch (type) {
    case 'cleaning':
      return 'Cleaning';
    case 'health_check':
      return 'Health Check';
    case 'feeding':
    default:
      return 'Feeding';
  }
}

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  /// 0 = All, 1 = Due/Overdue, 2 = Upcoming
  int _filter = 0;

  Future<void> _markDone(ReminderModel reminder) async {
    try {
      await ref.read(reminderRepositoryProvider).markDone(reminder);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${reminder.title}" marked as done!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _deleteReminder(ReminderModel reminder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Reminder'),
        content: Text('Delete "${reminder.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(reminderRepositoryProvider).deleteReminder(reminder.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${reminder.title}" deleted.'),
          behavior: SnackBarBehavior.floating,
        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final remindersAsync = ref.watch(allRemindersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.addReminder),
        icon: const Icon(Icons.alarm_add),
        label: const Text('Add Reminder'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF1A1E1A), Color(0xFF111311)]
                : const [Color(0xFFF1F8F1), Color(0xFFFAFFFa)],
          ),
        ),
        child: Column(
          children: [
            // Filter chips
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _filter == 0,
                    onTap: () => setState(() => _filter = 0),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Due / Overdue',
                    selected: _filter == 1,
                    onTap: () => setState(() => _filter = 1),
                    color: Colors.red[700]!,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Upcoming',
                    selected: _filter == 2,
                    onTap: () => setState(() => _filter = 2),
                    color: const Color(0xFF1565C0),
                  ),
                ],
              ),
            ),
            // List
            Expanded(
              child: remindersAsync.when(
                data: (all) {
                  final reminders = all.where((r) {
                    if (_filter == 1) return r.isActive && r.isDueOrOverdue;
                    if (_filter == 2) return r.isActive && !r.isDueOrOverdue;
                    return true;
                  }).toList();

                  if (reminders.isEmpty) {
                    return _EmptyState(filter: _filter);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = reminders[index];
                      return _ReminderCard(
                        reminder: reminder,
                        isDark: isDark,
                        onMarkDone: () => _markDone(reminder),
                        onEdit: () => context.push(
                          Routes.addReminder,
                          extra: reminder,
                        ),
                        onDelete: () => _deleteReminder(reminder),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text('Error loading reminders: $e'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color = const Color(0xFF2E7D32),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : color.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final ReminderModel reminder;
  final bool isDark;
  final VoidCallback onMarkDone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ReminderCard({
    required this.reminder,
    required this.isDark,
    required this.onMarkDone,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(reminder.type);
    final statusColor = reminder.isOverdue
        ? Colors.red[700]!
        : reminder.isDueToday
            ? Colors.orange[700]!
            : Colors.grey[500]!;
    final statusLabel = reminder.isOverdue
        ? 'Overdue'
        : reminder.isDueToday
            ? 'Due Today'
            : reminder.daysUntilDue == 1
                ? 'Tomorrow'
                : 'In ${reminder.daysUntilDue} days';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Colored left accent bar
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(_typeIcon(reminder.type),
                              color: color, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reminder.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                _typeLabel(reminder.type),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: color),
                              ),
                            ],
                          ),
                        ),
                        // Three-dot menu
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') onEdit();
                            if (value == 'delete') onDelete();
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 18),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline,
                                      size: 18, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.repeat, size: 13, color: Colors.grey[500]),
                        const SizedBox(width: 3),
                        Text(
                          reminder.frequencyLabel,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[500]),
                        ),
                        const Spacer(),
                        Text(
                          DateFormat('MMM d').format(reminder.nextDueDate),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    if (reminder.notes != null &&
                        reminder.notes!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        reminder.notes!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey[500]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (reminder.isActive && reminder.isDueOrOverdue) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.tonal(
                          onPressed: onMarkDone,
                          style: FilledButton.styleFrom(
                            backgroundColor: color.withValues(alpha: 0.14),
                            foregroundColor: color,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle_outline, size: 16),
                              SizedBox(width: 6),
                              Text('Mark Done',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final int filter;

  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    final messages = [
      ('No reminders set up yet.', 'Tap Add Reminder to create one.'),
      ('Nothing due right now!', 'All your tasks are on schedule.'),
      ('No upcoming reminders.', 'All reminders are due today or overdue.'),
    ];
    final (title, sub) = messages[filter.clamp(0, 2)];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            filter == 1 ? Icons.task_alt : Icons.alarm_off_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey[600])),
          const SizedBox(height: 6),
          Text(sub,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[500])),
        ],
      ),
    );
  }
}
