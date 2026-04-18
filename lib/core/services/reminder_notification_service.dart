import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import '../models/reminder_model.dart';

/// Callback function for alarm manager - runs in main isolate
@pragma('vm:entry-point')
void alarmCallback(int id, Map<String, dynamic> params) async {
  try {
    final title = params['title'] as String? ?? 'Reminder';
    final body = params['body'] as String? ?? 'You have a reminder';
    final payload = params['payload' ] as String?;
    final notificationId = params['notificationId'] as int? ?? 0;

    final plugin = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await plugin.initialize(settings);

    const channel = AndroidNotificationChannel(
      'reminders_channel',
      'Reminders',
      description: 'Chicken care reminders',
      importance: Importance.high,
    );

    final androidPlugin = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(channel);

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'reminders_channel',
        'Reminders',
        channelDescription: 'Chicken care reminders',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await plugin.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  } catch (e) {
    // Silently fail
  }
}

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

    // AlarmManager is already initialized in main.dart
    // Only initialize local notifications plugin here
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

    await _clearScheduledReminderTasks();

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
        var fireAt = DateTime(
          entry.key.year,
          entry.key.month,
          entry.key.day,
          8, // 8 AM
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
        final notificationId = _summaryNotificationId(entry.key);

        final inputData = <String, dynamic>{
          'title': title,
          'body': body,
          'payload': payload,
          'notificationId': notificationId,
        };

        final delay = fireAt.difference(now);

        await AndroidAlarmManager.oneShot(
          delay,
          notificationId,
          alarmCallback,
          params: inputData,
          exact: true,
          wakeup: true,
        );
      }
    } catch (e) {
      _lastScheduleError = e.toString();
      rethrow;
    }
  }

  Future<void> cancelReminder(int reminderId) async {
    if (!Platform.isAndroid) return;
    await initialize();
    await _clearScheduledReminderTasks();
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
      _testNotificationId,
      'Chicken Tracker test',
      'Notifications are working for reminders.',
      notificationDetails,
      payload: 'test-notification',
    );

    return true;
  }

  Future<ReminderNotificationDiagnostics> getDiagnostics() async {
    await initialize();

    final notificationStatus = await Permission.notification.status;
    final scheduledTasks = await _getScheduledTasks();

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

  Future<void> _clearScheduledReminderTasks() async {
    try {
      // Android Alarm Manager doesn't have a cancelAll method
      // Tasks are cancelled individually or on app restart
      // For now, just return - this is a limitation
    } catch (_) {
      // Silently fail
    }
  }

  Future<List<String>> _getScheduledTasks() async {
    // AlarmManager doesn't provide a direct way to list scheduled alarms
    // This is a limitation, but we can return an empty list for now
    return [];
  }

  int _summaryNotificationId(DateTime date) {
    return _summaryNotificationBaseId + _dateKey(date);
  }

  int _dateKey(DateTime date) {
    return (date.year * 10000) + (date.month * 100) + date.day;
  }
}
