import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/reminder_model.dart';

/// Repository for managing reminders
class ReminderRepository {
  final AppDatabase database;

  ReminderRepository(this.database);

  /// Add a new reminder
  Future<int> addReminder({
    required String type,
    required String title,
    required int frequencyDays,
    required DateTime nextDueDate,
    String? notes,
  }) {
    return database.addReminder(RemindersCompanion(
      type: Value(type),
      title: Value(title),
      frequencyDays: Value(frequencyDays),
      nextDueDate: Value(nextDueDate),
      notes: Value(notes),
      isActive: const Value(true),
    ));
  }

  /// Mark a reminder as done and advance to the next due date
  Future<void> markDone(ReminderModel reminder) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(
        reminder.nextDueDate.year,
        reminder.nextDueDate.month,
        reminder.nextDueDate.day);

    // If overdue, advance from today; otherwise advance from the scheduled date
    final nextDueDate = due.isBefore(today)
        ? today.add(Duration(days: reminder.frequencyDays))
        : due.add(Duration(days: reminder.frequencyDays));

    return database.markReminderDone(reminder.id, nextDueDate);
  }

  /// Update an existing reminder's details
  Future<void> updateReminder(ReminderModel model) {
    return database.updateReminderDetails(
      model.id,
      type: model.type,
      title: model.title,
      frequencyDays: model.frequencyDays,
      nextDueDate: model.nextDueDate,
      notes: model.notes,
      isActive: model.isActive,
    );
  }

  /// Delete a reminder permanently
  Future<void> deleteReminder(int id) => database.deleteReminder(id);
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
    );
