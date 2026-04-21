import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/models/reminder_model.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/services/google_calendar_service.dart';

class AddReminderScreen extends ConsumerStatefulWidget {
  /// If non-null the screen operates in edit mode
  final ReminderModel? reminderToEdit;

  const AddReminderScreen({super.key, this.reminderToEdit});

  @override
  ConsumerState<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends ConsumerState<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _customDaysController;
  late TextEditingController _notesController;

  String _selectedType = 'feeding';
  // frequency: 1=daily, 7=weekly, 14=bi-weekly, 30=monthly, -1=custom
  int _frequencyPreset = 1;
  int _customDays = 3;
  DateTime _nextDueDate = DateTime.now();
  bool _isLoading = false;
  bool _isAddingToCalendar = false;

  bool get _isEdit => widget.reminderToEdit != null;

  @override
  void initState() {
    super.initState();
    final r = widget.reminderToEdit;
    _selectedType = r?.type ?? 'feeding';
    _nextDueDate = r?.nextDueDate ?? DateTime.now();

    final knownPresets = [1, 7, 14, 30];
    _frequencyPreset = (r != null && !knownPresets.contains(r.frequencyDays))
        ? -1
        : (r?.frequencyDays ?? 1);
    _customDays = (r != null && !knownPresets.contains(r.frequencyDays))
        ? r.frequencyDays
        : 3;

    _titleController =
        TextEditingController(text: r?.title ?? _defaultTitle('feeding'));
    _customDaysController = TextEditingController(text: _customDays.toString());
    _notesController = TextEditingController(text: r?.notes ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _customDaysController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _defaultTitle(String type) {
    switch (type) {
      case 'cleaning':
        return 'Clean coop';
      case 'health_check':
        return 'Health check';
      case 'todo':
        return 'New to-do';
      default:
        return 'Feed chickens';
    }
  }

  int get _effectiveFrequencyDays =>
      _frequencyPreset == -1 ? _customDays : _frequencyPreset;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextDueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _nextDueDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    ReminderModel? savedReminder;

    try {
      final repo = ref.read(reminderRepositoryProvider);
      if (_isEdit) {
        final updated = widget.reminderToEdit!.copyWith(
          type: _selectedType,
          title: _titleController.text.trim(),
          frequencyDays: _effectiveFrequencyDays,
          nextDueDate: _nextDueDate,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );
        await repo.updateReminder(updated);
        savedReminder = updated;
      } else {
        await repo.addReminder(
          type: _selectedType,
          title: _titleController.text.trim(),
          frequencyDays: _effectiveFrequencyDays,
          nextDueDate: _nextDueDate,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          notifyOnAndroid: true,
        );
        // Fetch the just-created reminder for calendar use
        final all = await ref.read(allRemindersProvider.future);
        savedReminder = all
            .where((r) => r.title == _titleController.text.trim())
            .lastOrNull;
      }


      if (!mounted) return;

      // Offer to add to Google Calendar
      if (savedReminder != null) {
        await _showCalendarDialog(savedReminder);
      }

      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Shows a dialog offering to open Google Calendar with the reminder details.
  Future<void> _showCalendarDialog(ReminderModel reminder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.calendar_month, size: 32),
        title: const Text('Add to Google Calendar?'),
        content: Text(
          'Open Google Calendar to create a recurring all-day event for '
          '"${reminder.title}" starting ${DateFormat('MMM d, y').format(reminder.nextDueDate)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Skip'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('Open Calendar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _addToGoogleCalendar(reminder);
    }
  }

  Future<void> _addToGoogleCalendar(ReminderModel reminder) async {
    setState(() => _isAddingToCalendar = true);
    try {
      final opened = await GoogleCalendarService.addToGoogleCalendar(reminder);
      if (!mounted) return;
      if (!opened) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open Google Calendar. Is it installed?'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening Google Calendar: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isAddingToCalendar = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const headerGradient = [Color(0xFF2E7D32), Color(0xFF1B5E20)];

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Reminder' : 'Add Reminder'),
        elevation: 0,
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: headerGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.alarm_add,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEdit ? 'Edit Reminder' : 'New Reminder',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              'Keep your flock care on schedule',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Type selector ────────────────────────────────────────
                const _SectionLabel(label: 'Reminder Type'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final type in [
                      'feeding',
                      'cleaning',
                      'health_check',
                      'todo'
                    ])
                      SizedBox(
                        width: (MediaQuery.sizeOf(context).width - 32 - 24) / 4,
                        child: _TypeChip(
                          type: type,
                          selected: _selectedType == type,
                          onTap: () => setState(() {
                            // Update title placeholder if user hasn't typed
                            final defaultOld = _defaultTitle(_selectedType);
                            if (_titleController.text == defaultOld ||
                                _titleController.text.isEmpty) {
                              _titleController.text = _defaultTitle(type);
                            }
                            _selectedType = type;
                          }),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Title ────────────────────────────────────────────────
                const _SectionLabel(label: 'Title'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Feed morning grain',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Title is required'
                      : null,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 20),

                // ── Frequency ────────────────────────────────────────────
                const _SectionLabel(label: 'Frequency'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final entry in const [
                      (1, 'Daily'),
                      (7, 'Weekly'),
                      (14, 'Every 2 wks'),
                      (30, 'Monthly'),
                      (-1, 'Custom'),
                    ])
                      _FrequencyChip(
                        label: entry.$2,
                        selected: _frequencyPreset == entry.$1,
                        onTap: () => setState(() {
                          _frequencyPreset = entry.$1;
                        }),
                      ),
                  ],
                ),
                if (_frequencyPreset == -1) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _customDaysController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Repeat every N days',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.repeat),
                      suffixText: 'days',
                    ),
                    onChanged: (v) {
                      final n = int.tryParse(v);
                      if (n != null && n > 0) setState(() => _customDays = n);
                    },
                    validator: (v) {
                      if (_frequencyPreset != -1) return null;
                      final n = int.tryParse(v ?? '');
                      if (n == null || n < 1) {
                        return 'Enter a number ≥ 1';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 20),

                // ── First due date ───────────────────────────────────────
                _SectionLabel(
                    label: _isEdit ? 'Next Due Date' : 'First Due Date'),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(8),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      DateFormat('EEEE, MMM d, y').format(_nextDueDate),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Notes ────────────────────────────────────────────────
                const _SectionLabel(label: 'Notes (optional)'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    hintText: 'Any extra details...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.notes),
                  ),
                  minLines: 2,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 32),

                // ── Save button ──────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _isLoading ? null : _submit,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.check),
                    label: Text(
                      _isEdit ? 'Update Reminder' : 'Create Reminder',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ── Google Calendar button ───────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: (_isAddingToCalendar || _isLoading)
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;
                            // Build a temporary model from current form state
                            final tempReminder = ReminderModel(
                              id: widget.reminderToEdit?.id ?? 0,
                              type: _selectedType,
                              title: _titleController.text.trim(),
                              frequencyDays: _effectiveFrequencyDays,
                              nextDueDate: _nextDueDate,
                              notes: _notesController.text.trim().isEmpty
                                  ? null
                                  : _notesController.text.trim(),
                              isActive: true,
                              notifyOnAndroid: true,
                            );
                            await _addToGoogleCalendar(tempReminder);
                          },
                    icon: _isAddingToCalendar
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.calendar_month_outlined),
                    label: const Text(
                      'Add to Google Calendar',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String type;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  IconData get _icon {
    switch (type) {
      case 'cleaning':
        return Icons.cleaning_services;
      case 'health_check':
        return Icons.health_and_safety;
      case 'todo':
        return Icons.task_alt;
      default:
        return Icons.grass;
    }
  }

  String get _label {
    switch (type) {
      case 'cleaning':
        return 'Cleaning';
      case 'health_check':
        return 'Health';
      case 'todo':
        return 'To-Do';
      default:
        return 'Feeding';
    }
  }

  Color get _color {
    switch (type) {
      case 'cleaning':
        return const Color(0xFF1565C0);
      case 'health_check':
        return const Color(0xFFE08A24);
      case 'todo':
        return const Color(0xFFB84DFF);
      default:
        return const Color(0xFF2E7D32);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _color : _color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? _color : _color.withValues(alpha: 0.25),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(_icon, color: selected ? Colors.white : _color, size: 22),
            const SizedBox(height: 4),
            Text(
              _label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : _color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FrequencyChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FrequencyChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF2E7D32);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : color.withValues(alpha: 0.25),
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
