import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/reminder_notification_service.dart';

final reminderNotificationServiceProvider = Provider<ReminderNotificationService>((ref) {
  return ReminderNotificationService();
});
