import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../database/app_database.dart';
import '../models/reminder_model.dart';
import '../services/reminder_notification_service.dart';

/// Repository for managing reminders
class ReminderRepository {
  final AppDatabase database;
  final ReminderNotificationService notificationService;

  ReminderRepository(this.database, this.notificationService);

  /// Add a new reminder
  Future<int> addReminder({
    required String type,
    required String title,
    required int frequencyDays,
    required DateTime nextDueDate,
    String? notes,
    required bool notifyOnAndroid,
  }) async {
    final id = await database.addReminder(RemindersCompanion(
      type: Value(type),
      title: Value(title),
      frequencyDays: Value(frequencyDays),
      nextDueDate: Value(nextDueDate),
      notes: Value(notes),
      isActive: const Value(true),
      notifyOnAndroid: Value(notifyOnAndroid),
    ));

    await _scheduleReminderSafely(
      ReminderModel(
        id: id,
        type: type,
        title: title,
        frequencyDays: frequencyDays,
        nextDueDate: nextDueDate,
        notes: notes,
        isActive: true,
        notifyOnAndroid: notifyOnAndroid,
      ),
    );

    return id;
  }

  /// Mark a reminder as done and advance to the next due date
  Future<void> markDone(ReminderModel reminder) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(reminder.nextDueDate.year, reminder.nextDueDate.month,
        reminder.nextDueDate.day);

    // If overdue, advance from today; otherwise advance from the scheduled date
    final nextDueDate = due.isBefore(today)
        ? today.add(Duration(days: reminder.frequencyDays))
        : due.add(Duration(days: reminder.frequencyDays));

    await database.markReminderDone(reminder.id, nextDueDate);

    await _scheduleReminderSafely(
      reminder.copyWith(nextDueDate: nextDueDate),
    );
  }

  /// Update an existing reminder's details
  Future<void> updateReminder(ReminderModel model) async {
    await database.updateReminderDetails(
      model.id,
      type: model.type,
      title: model.title,
      frequencyDays: model.frequencyDays,
      nextDueDate: model.nextDueDate,
      notes: model.notes,
      isActive: model.isActive,
      notifyOnAndroid: model.notifyOnAndroid,
    );

    await _scheduleReminderSafely(model);
  }

  /// Delete a reminder permanently
  Future<void> deleteReminder(int id) async {
    await database.deleteReminder(id);
    await _cancelReminderSafely(id);
  }

  Future<void> _scheduleReminderSafely(ReminderModel model) async {
    try {
      await notificationService.scheduleReminder(model);
    } catch (e, st) {
      debugPrint('Failed to schedule reminder notification: $e');
      debugPrint('$st');
    }
  }

  Future<void> _cancelReminderSafely(int id) async {
    try {
      await notificationService.cancelReminder(id);
    } catch (e, st) {
      debugPrint('Failed to cancel reminder notification: $e');
      debugPrint('$st');
    }
  }
}

/// Helper to map a DB Reminder row to a ReminderModel
ReminderModel reminderFromDb(Reminder r) => ReminderModel(
      id: r.id,
      type: r.type,
      title: r.title,
      frequencyDays: r.frequencyDays,
      nextDueDate: r.nextDueDate,
      lastCompletedDate: r.lastCompletedDate,
      notes: r.notes,
      isActive: r.isActive,
      notifyOnAndroid: r.notifyOnAndroid,
    );
