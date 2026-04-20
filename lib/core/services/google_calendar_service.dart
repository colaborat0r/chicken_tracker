import 'package:url_launcher/url_launcher.dart';

import '../models/reminder_model.dart';

/// Opens Google Calendar's event-creation page pre-filled with the reminder
/// details. No API key or OAuth is needed — it uses the standard web URL that
/// Google Calendar (and the Calendar app on Android) understands.
class GoogleCalendarService {
  /// Attempts to open Google Calendar for [reminder].
  /// Returns true if the URL was launched successfully.
  static Future<bool> addToGoogleCalendar(ReminderModel reminder) async {
    final uri = _buildCalendarUri(reminder);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    // Fallback: open in browser
    return launchUrl(uri, mode: LaunchMode.platformDefault);
  }

  static Uri _buildCalendarUri(ReminderModel reminder) {
    // Format: YYYYMMDDTHHmmSS (local, no Z suffix so Calendar uses device TZ)
    // All-day format: YYYYMMDD (no time component)
    final start = _formatAllDay(reminder.nextDueDate);
    // Google Calendar end date for all-day events is exclusive, so add 1 day
    final end = _formatAllDay(reminder.nextDueDate.add(const Duration(days: 1)));

    final recurrence = _rrule(reminder.frequencyDays);
    final details = _buildDetails(reminder);

    // Google Calendar event creation URL
    // https://calendar.google.com/calendar/render?action=TEMPLATE&...
    final params = <String, String>{
      'action': 'TEMPLATE',
      'text': reminder.title,
      'dates': '$start/$end',
      'details': details,
    };
    if (recurrence != null) {
      params['recur'] = recurrence;
    }

    return Uri.https('calendar.google.com', '/calendar/render', params);
  }

  static String _formatAllDay(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}'
        '${date.month.toString().padLeft(2, '0')}'
        '${date.day.toString().padLeft(2, '0')}';
  }

  /// Maps frequencyDays to an RFC 5545 RRULE string.
  static String? _rrule(int frequencyDays) {
    switch (frequencyDays) {
      case 1:
        return 'RRULE:FREQ=DAILY';
      case 7:
        return 'RRULE:FREQ=WEEKLY';
      case 14:
        return 'RRULE:FREQ=WEEKLY;INTERVAL=2';
      case 30:
        return 'RRULE:FREQ=MONTHLY';
      default:
        // Custom interval in days
        return 'RRULE:FREQ=DAILY;INTERVAL=$frequencyDays';
    }
  }

  static String _buildDetails(ReminderModel reminder) {
    final buffer = StringBuffer('Chicken Tracker reminder');
    if (reminder.notes != null && reminder.notes!.isNotEmpty) {
      buffer.write('\n\n${reminder.notes}');
    }
    return buffer.toString();
  }
}



