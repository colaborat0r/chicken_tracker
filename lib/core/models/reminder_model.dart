// Model for the Reminders feature

class ReminderModel {
  final int id;
  final String type; // feeding, cleaning, health_check
  final String title;
  final int frequencyDays;
  final DateTime nextDueDate;
  final DateTime? lastCompletedDate;
  final String? notes;
  final bool isActive;

  const ReminderModel({
    required this.id,
    required this.type,
    required this.title,
    required this.frequencyDays,
    required this.nextDueDate,
    this.lastCompletedDate,
    this.notes,
    required this.isActive,
  });

  bool get isOverdue {
    final today = _today();
    final due = DateTime(nextDueDate.year, nextDueDate.month, nextDueDate.day);
    return due.isBefore(today);
  }

  bool get isDueToday {
    final today = _today();
    final due = DateTime(nextDueDate.year, nextDueDate.month, nextDueDate.day);
    return due.isAtSameMomentAs(today);
  }

  bool get isDueOrOverdue => isOverdue || isDueToday;

  int get daysUntilDue {
    final today = _today();
    final due = DateTime(nextDueDate.year, nextDueDate.month, nextDueDate.day);
    return due.difference(today).inDays;
  }

  String get frequencyLabel {
    switch (frequencyDays) {
      case 1:
        return 'Daily';
      case 7:
        return 'Weekly';
      case 14:
        return 'Every 2 weeks';
      case 30:
        return 'Monthly';
      default:
        return 'Every $frequencyDays days';
    }
  }

  ReminderModel copyWith({
    int? id,
    String? type,
    String? title,
    int? frequencyDays,
    DateTime? nextDueDate,
    DateTime? lastCompletedDate,
    String? notes,
    bool? isActive,
  }) {
    return ReminderModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      frequencyDays: frequencyDays ?? this.frequencyDays,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
    );
  }

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
