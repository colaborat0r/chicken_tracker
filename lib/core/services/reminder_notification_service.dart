import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/reminder_model.dart';

class ReminderNotificationDiagnostics {
  const ReminderNotificationDiagnostics({
    required this.serviceInstanceId,
    required this.syncRunCount,
    required this.lastSyncAttemptAtIso,
    required this.notificationsGranted,
    required this.alarmManagerInitialized,
    required this.scheduledTasks,
    required this.totalRemindersSeen,
    required this.eligibleRemindersSeen,
    required this.groupedNotificationsPrepared,
    required this.lastScheduleError,
  });

  final int serviceInstanceId;
  final int syncRunCount;
  final String? lastSyncAttemptAtIso;
  final bool notificationsGranted;
  final bool alarmManagerInitialized;
  final List<String> scheduledTasks;
  final int totalRemindersSeen;
  final int eligibleRemindersSeen;
  final int groupedNotificationsPrepared;
  final String? lastScheduleError;
}

class ReminderNotificationService {
  static const String _channelId = 'reminders_channel';
  static const String _channelName = 'Reminders';
  static const String _channelDescription = 'Chicken care reminders';
  static const int _summaryNotificationBaseId = 900000;
  static const int _testNotificationId = 1001;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  final int _serviceInstanceId = DateTime.now().microsecondsSinceEpoch;
  bool _isInitialized = false;
  int _syncRunCount = 0;
  DateTime? _lastSyncAttemptAt;
  int _lastTotalRemindersSeen = 0;
  int _lastEligibleRemindersSeen = 0;
  int _lastGroupedNotificationsPrepared = 0;
  String? _lastScheduleError;

  Future<void> initialize() async {
    if (!Platform.isAndroid || _isInitialized) return;

    // Initialize timezone data
    tz.initializeTimeZones();
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // Request exact alarm permission on Android 12+
    await androidPlugin?.requestExactAlarmsPermission();

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );
    await androidPlugin?.createNotificationChannel(channel);

    _isInitialized = true;
  }

  Future<void> scheduleReminder(ReminderModel reminder) async {
    await resyncActiveReminders([reminder]);
  }

  Future<void> resyncActiveReminders(List<ReminderModel> reminders) async {
    if (!Platform.isAndroid) return;

    await initialize();

    _syncRunCount++;
    _lastSyncAttemptAt = DateTime.now();
    _lastTotalRemindersSeen = reminders.length;
    _lastEligibleRemindersSeen = 0;
    _lastGroupedNotificationsPrepared = 0;
    _lastScheduleError = null;

    final granted = await _ensurePermissionGranted();
    if (!granted) {
      _lastScheduleError = 'Notification permission is not granted.';
      return;
    }

    // Cancel all previously scheduled reminder notifications
    await _cancelAllScheduledReminders();

    // Group active reminders by due date
    final grouped = <DateTime, List<ReminderModel>>{};
    for (final reminder in reminders) {
      if (!reminder.notifyOnAndroid || !reminder.isActive) continue;
      _lastEligibleRemindersSeen++;
      final day = DateTime(
        reminder.nextDueDate.year,
        reminder.nextDueDate.month,
        reminder.nextDueDate.day,
      );
      grouped.putIfAbsent(day, () => <ReminderModel>[]).add(reminder);
    }
    _lastGroupedNotificationsPrepared = grouped.length;

    final now = DateTime.now();
    try {
      for (final entry in grouped.entries) {
        // Target 8 AM on the due date
        var fireAt = DateTime(
          entry.key.year,
          entry.key.month,
          entry.key.day,
          8,
        );

        // If 8 AM has already passed, fire in 1 minute
        if (fireAt.isBefore(now)) {
          fireAt = now.add(const Duration(minutes: 1));
        }

        final tzFireAt = tz.TZDateTime.from(fireAt, tz.local);

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
        final notificationId = _summaryNotificationId(entry.key);

        const details = NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
        );

        // Try exact alarm first; fall back to inexact if permission is denied.
        try {
          await _plugin.zonedSchedule(
            notificationId,
            title,
            body,
            tzFireAt,
            details,
            payload: payload,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
        } catch (_) {
          // Exact alarms require explicit user permission on Android 12+.
          // Fall back to inexact scheduling, which works without that permission.
          await _plugin.zonedSchedule(
            notificationId,
            title,
            body,
            tzFireAt,
            details,
            payload: payload,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
        }
      }
    } catch (e) {
      _lastScheduleError = e.toString();
      // Do not rethrow — callers (main.dart listener, UI) should not crash.
    }
  }

  Future<void> cancelReminder(int reminderId) async {
    if (!Platform.isAndroid) return;
    await initialize();
    await _cancelAllScheduledReminders();
  }

  Future<bool> sendTestNotification() async {
    if (!Platform.isAndroid) return false;

    await initialize();

    final granted = await _ensurePermissionGranted();
    if (!granted) return false;

    await _plugin.show(
      _testNotificationId,
      'Chicken Tracker test',
      'Notifications are working for reminders.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: 'test-notification',
    );

    return true;
  }

  Future<ReminderNotificationDiagnostics> getDiagnostics() async {
    await initialize();

    final notificationStatus = await Permission.notification.status;

    // Query the actual pending (scheduled) notifications from the OS
    final pending = await _plugin.pendingNotificationRequests();
    final scheduledTasks = pending
        .where((n) => n.id >= _summaryNotificationBaseId)
        .map((n) => 'id=${n.id} title=${n.title ?? ""}')
        .toList();

    return ReminderNotificationDiagnostics(
      serviceInstanceId: _serviceInstanceId,
      syncRunCount: _syncRunCount,
      lastSyncAttemptAtIso: _lastSyncAttemptAt?.toIso8601String(),
      notificationsGranted: notificationStatus.isGranted,
      alarmManagerInitialized: _isInitialized,
      scheduledTasks: scheduledTasks,
      totalRemindersSeen: _lastTotalRemindersSeen,
      eligibleRemindersSeen: _lastEligibleRemindersSeen,
      groupedNotificationsPrepared: _lastGroupedNotificationsPrepared,
      lastScheduleError: _lastScheduleError,
    );
  }

  Future<bool> _ensurePermissionGranted() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return true;
    final updated = await Permission.notification.request();
    return updated.isGranted;
  }

  /// Cancels all scheduled reminder notifications (IDs in the summary range).
  Future<void> _cancelAllScheduledReminders() async {
    try {
      final pending = await _plugin.pendingNotificationRequests();
      for (final n in pending) {
        if (n.id >= _summaryNotificationBaseId) {
          await _plugin.cancel(n.id);
        }
      }
    } catch (_) {}
  }

  int _summaryNotificationId(DateTime date) {
    return _summaryNotificationBaseId + _dateKey(date);
  }

  int _dateKey(DateTime date) {
    return (date.year * 10000) + (date.month * 100) + date.day;
  }
}
