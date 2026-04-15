import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/reminder_model.dart';

class ReminderNotificationService {
  static const String _channelId = 'reminders_channel';
  static const String _channelName = 'Reminders';
  static const String _channelDescription = 'Chicken care reminders';
  static const int _summaryNotificationBaseId = 900000;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!Platform.isAndroid || _isInitialized) return;

    tz.initializeTimeZones();
    await _setLocalTimezone();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(channel);

    _isInitialized = true;
  }

  Future<void> scheduleReminder(ReminderModel reminder) async {
    // Kept for backward compatibility. New behavior coalesces notifications.
    await resyncActiveReminders([reminder]);
  }

  Future<void> resyncActiveReminders(List<ReminderModel> reminders) async {
    if (!Platform.isAndroid) return;

    await initialize();

    final granted = await _ensurePermissionGranted();
    if (!granted) return;

    final exactAllowed = await _canUseExactAlarms();
    final scheduleMode = exactAllowed
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.cancelAll();

    final grouped = <DateTime, List<ReminderModel>>{};
    for (final reminder in reminders) {
      if (!reminder.notifyOnAndroid || !reminder.isActive) continue;
      final day = DateTime(
        reminder.nextDueDate.year,
        reminder.nextDueDate.month,
        reminder.nextDueDate.day,
      );
      grouped.putIfAbsent(day, () => <ReminderModel>[]).add(reminder);
    }

    final now = DateTime.now();
    for (final entry in grouped.entries) {
      var fireAt = DateTime(
        entry.key.year,
        entry.key.month,
        entry.key.day,
        8,
      );

      if (fireAt.isBefore(now)) {
        fireAt = now.add(const Duration(minutes: 1));
      }

      final remindersForDay = entry.value;
      final title = remindersForDay.length == 1
          ? remindersForDay.first.title
          : '${remindersForDay.length} reminders due';
      final body = remindersForDay.length == 1
          ? 'Due today'
          : 'Open Chicken Tracker to view all due tasks.';
      final payload = remindersForDay.length == 1
          ? 'reminder:${remindersForDay.first.id}'
          : 'reminder-group:${_dateKey(entry.key)}';

      await _plugin.zonedSchedule(
        _summaryNotificationId(entry.key),
        title,
        body,
        tz.TZDateTime.from(fireAt, tz.local),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: scheduleMode,
        payload: payload,
      );
    }
  }

  Future<void> cancelReminder(int reminderId) async {
    if (!Platform.isAndroid) return;
    await initialize();
    // Notification IDs are date-based summaries; perform a full cancel.
    await _plugin.cancelAll();
  }

  Future<bool> sendTestNotification() async {
    if (!Platform.isAndroid) return false;

    await initialize();

    final granted = await _ensurePermissionGranted();
    if (!granted) return false;

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.show(
      999001,
      'Chicken Tracker test',
      'Notifications are working for reminders.',
      notificationDetails,
      payload: 'test-notification',
    );

    return true;
  }

  Future<bool> _ensurePermissionGranted() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return true;

    final updated = await Permission.notification.request();
    return updated.isGranted;
  }

  Future<bool> _canUseExactAlarms() async {
    if (!Platform.isAndroid) return false;

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return false;

    try {
      final canSchedule = await androidPlugin.canScheduleExactNotifications();
      if (canSchedule == true) return true;

      final requested = await androidPlugin.requestExactAlarmsPermission();
      return requested ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _setLocalTimezone() async {
    try {
      final timezone = await FlutterTimezone.getLocalTimezone();
      final timezoneId = _extractTimezoneIdentifier(timezone);
      tz.setLocalLocation(tz.getLocation(timezoneId));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  String _extractTimezoneIdentifier(dynamic timezone) {
    if (timezone is String && timezone.isNotEmpty) {
      return timezone;
    }

    try {
      final identifier = timezone.identifier as String?;
      if (identifier != null && identifier.isNotEmpty) {
        return identifier;
      }
    } catch (_) {
      // Fall through to UTC fallback.
    }

    return 'UTC';
  }

  int _summaryNotificationId(DateTime date) {
    return _summaryNotificationBaseId + _dateKey(date);
  }

  int _dateKey(DateTime date) {
    return (date.year * 10000) + (date.month * 100) + date.day;
  }
}
