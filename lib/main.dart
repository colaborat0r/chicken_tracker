import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'core/theme/app_theme.dart';
import 'config/router.dart';
import 'core/models/reminder_model.dart';
import 'core/providers/database_providers.dart';
import 'core/providers/notification_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Android Alarm Manager for background tasks
  await AndroidAlarmManager.initialize();

  runApp(const ProviderScope(child: ChickenTrackerApp()));
}


class ChickenTrackerApp extends ConsumerStatefulWidget {
  const ChickenTrackerApp({super.key});

  @override
  ConsumerState<ChickenTrackerApp> createState() => _ChickenTrackerAppState();
}

class _ChickenTrackerAppState extends ConsumerState<ChickenTrackerApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(reminderNotificationServiceProvider).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<ReminderModel>>>(allRemindersProvider, (_, next) {
      next.whenData((reminders) {
        ref.read(reminderNotificationServiceProvider).resyncActiveReminders(
              reminders,
            );
      });
    });

    return MaterialApp.router(
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();

        return SafeArea(
          top: false,
          left: false,
          right: false,
          minimum: const EdgeInsets.only(bottom: 16),
          child: child,
        );
      },
      title: 'Chicken & Egg Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // default = dark for farm use
      routerConfig: goRouter,
    );
  }
}