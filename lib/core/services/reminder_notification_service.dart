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
    if (!Platform.isAndroid) return;

    if (!reminder.notifyOnAndroid || !reminder.isActive) {
      await cancelReminder(reminder.id);
      return;
    }

    await initialize();

    final granted = await _ensurePermissionGranted();
    if (!granted) return;

    final now = DateTime.now();
    var fireAt = DateTime(
      reminder.nextDueDate.year,
      reminder.nextDueDate.month,
      reminder.nextDueDate.day,
      8,
    );

    if (fireAt.isBefore(now)) {
      fireAt = now.add(const Duration(minutes: 1));
    }

    final zonedFireAt = tz.TZDateTime.from(fireAt, tz.local);

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.zonedSchedule(
      reminder.id,
      reminder.title,
      'Due today',
      zonedFireAt,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'reminder:${reminder.id}',
    );
  }

  Future<void> cancelReminder(int reminderId) async {
    if (!Platform.isAndroid) return;
    await initialize();
    await _plugin.cancel(reminderId);
  }

  Future<bool> _ensurePermissionGranted() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return true;

    final updated = await Permission.notification.request();
    return updated.isGranted;
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
}
