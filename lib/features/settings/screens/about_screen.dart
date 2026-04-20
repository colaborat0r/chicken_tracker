import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/reminder_model.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/providers/notification_providers.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/services/reminder_notification_service.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  bool _isRefreshingDiagnostics = false;
  ReminderNotificationDiagnostics? _diagnostics;
  String? _lastRepositoryResyncError;

  static final Uri _feedbackEmailUri = Uri(
    scheme: 'mailto',
    path: 'thehost22000@yahoo.com',
    queryParameters: {
      'subject': 'Chicken Tracker Feedback',
    },
  );

  Future<void> _sendFeedback(BuildContext context) async {
    if (!await launchUrl(_feedbackEmailUri)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open email app.'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_refreshDiagnostics);
  }

  Future<void> _refreshDiagnostics() async {
    if (_isRefreshingDiagnostics) return;
    setState(() => _isRefreshingDiagnostics = true);

    try {
      final diagnostics = await ref
          .read(reminderNotificationServiceProvider)
          .getDiagnostics();
      final repositoryError =
          ref.read(reminderRepositoryProvider).lastResyncError;
      if (!mounted) return;
      setState(() {
        _diagnostics = diagnostics;
        _lastRepositoryResyncError = repositoryError;
      });
    } finally {
      if (mounted) {
        setState(() => _isRefreshingDiagnostics = false);
      }
    }
  }

  Future<void> _resyncReminderNotifications(List<ReminderModel> reminders) async {
    await ref
        .read(reminderNotificationServiceProvider)
        .resyncActiveReminders(reminders);
    await _refreshDiagnostics();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reminder notifications re-synced.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final remindersAsync = ref.watch(allRemindersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/icons/app_icon.png',
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About Chicken & Egg Production Tracker',
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Version 1.1.0',
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Built for homesteaders, backyard farmers, and small flock owners who want to track their egg production the easy way.',
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _AboutSection(
                    title: 'What This App Does',
                    child: Text(
                      'It helps you log daily egg collection, manage your flock, track feed and costs, and see clear charts of your hens’ productivity, all offline, right on your phone.\n\nJust open the app, tap, and keep your homestead running smoothly.',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _AboutSection(
                    title: 'Key Features',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FeatureBullet('Quick daily egg logging (by total or per hen)'),
                        _FeatureBullet('Complete flock management (breeds, ages, notes, and status)'),
                        _FeatureBullet('Feed, expense, and cost tracking'),
                        _FeatureBullet('Beautiful production charts and yearly trends'),
                        _FeatureBullet('Reminders for feeding, cleaning, and health checks'),
                        _FeatureBullet('Full export to CSV or PDF for your records'),
                        _FeatureBullet('Works completely offline - perfect for the barn or field'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _AboutSection(
                    title: 'Reminder Diagnostics',
                    child: remindersAsync.when(
                      data: (reminders) => _ReminderDiagnosticsCard(
                        diagnostics: _diagnostics,
                        remindersCount: reminders.length,
                        lastRepositoryResyncError: _lastRepositoryResyncError,
                        isRefreshing: _isRefreshingDiagnostics,
                        onRefresh: _refreshDiagnostics,
                        onResync: () => _resyncReminderNotifications(reminders),
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Text(
                        'Unable to load reminder diagnostics: $error',
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _AboutSection(
                    title: 'Feedback & Support',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'We’re constantly improving the app based on feedback from real chicken keepers like you. Have ideas, found a bug, or want a new feature?',
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () => _sendFeedback(context),
                          icon: const Icon(Icons.mail_outline),
                          label: const Text('Send Feedback'),
                        ),
                        const SizedBox(height: 12),
                        SelectableText(
                          'Email: thehost22000@yahoo.com',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _AboutSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _FeatureBullet extends StatelessWidget {
  final String text;

  const _FeatureBullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Text('• '),
          ),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}

class _ReminderDiagnosticsCard extends StatelessWidget {
  const _ReminderDiagnosticsCard({
    required this.diagnostics,
    required this.remindersCount,
    required this.lastRepositoryResyncError,
    required this.isRefreshing,
    required this.onRefresh,
    required this.onResync,
  });

  final ReminderNotificationDiagnostics? diagnostics;
  final int remindersCount;
  final String? lastRepositoryResyncError;
  final bool isRefreshing;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onResync;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;
    final scheduledTasks = diagnostics?.scheduledTasks ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Use this section to confirm whether reminder alarms are actually scheduled on this device.',
          style: bodyStyle,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            OutlinedButton.icon(
              onPressed: isRefreshing ? null : onRefresh,
              icon: isRefreshing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
            FilledButton.icon(
              onPressed: isRefreshing ? null : onResync,
              icon: const Icon(Icons.alarm),
              label: const Text('Re-sync reminders'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _DiagnosticRow(
          label: 'Saved reminders',
          value: '$remindersCount',
        ),
        _DiagnosticRow(
          label: 'Notifications permission',
          value: _boolLabel(diagnostics?.notificationsGranted),
        ),
        _DiagnosticRow(
          label: 'AlarmManager initialized',
          value: _boolLabel(diagnostics?.alarmManagerInitialized),
        ),
        _DiagnosticRow(
          label: 'Service instance id',
          value: '${diagnostics?.serviceInstanceId ?? 0}',
        ),
        _DiagnosticRow(
          label: 'Sync run count',
          value: '${diagnostics?.syncRunCount ?? 0}',
        ),
        _DiagnosticRow(
          label: 'Last sync attempt',
          value: diagnostics?.lastSyncAttemptAtIso ?? '(none)',
        ),
        _DiagnosticRow(
          label: 'Reminders seen in last sync',
          value: '${diagnostics?.totalRemindersSeen ?? 0}',
        ),
        _DiagnosticRow(
          label: 'Eligible reminders in last sync',
          value: '${diagnostics?.eligibleRemindersSeen ?? 0}',
        ),
        _DiagnosticRow(
          label: 'Grouped schedules prepared',
          value: '${diagnostics?.groupedNotificationsPrepared ?? 0}',
        ),
        _DiagnosticRow(
          label: 'Scheduled AlarmManager alarms',
          value: '${scheduledTasks.length}',
        ),
        if (diagnostics?.lastScheduleError != null) ...[
          const SizedBox(height: 8),
          Text(
            'Scheduler error: ${diagnostics!.lastScheduleError}',
            style: bodyStyle,
          ),
        ],
        if (lastRepositoryResyncError != null) ...[
          const SizedBox(height: 8),
          Text(
            'Repository resync error: $lastRepositoryResyncError',
            style: bodyStyle,
          ),
        ],
        if (scheduledTasks.isNotEmpty) ...[
          const SizedBox(height: 12),
          for (final task in scheduledTasks)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: Text(
                  task,
                  style: bodyStyle,
                ),
              ),
            ),
        ],
        if (scheduledTasks.isEmpty && diagnostics != null) ...[
          const SizedBox(height: 8),
          Text(
            'No scheduled AlarmManager alarms are currently registered. That means Android has nothing queued to fire.',
            style: bodyStyle,
          ),
        ],
        const SizedBox(height: 8),
        Text(
          'Expected reminder fire time is 8:00 AM local time on each reminder due date.',
          style: bodyStyle,
        ),
      ],
    );
  }

  String _boolLabel(bool? value) {
    if (value == null) return 'Unknown';
    return value ? 'Yes' : 'No';
  }
}

class _DiagnosticRow extends StatelessWidget {
  const _DiagnosticRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
