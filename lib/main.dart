import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'config/router.dart';
import 'core/models/reminder_model.dart';
import 'core/providers/database_providers.dart';
import 'core/providers/notification_providers.dart';
import 'core/providers/theme_providers.dart';
import 'core/services/backup_scheduler_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Catch Flutter framework errors (widget build / layout errors)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  // Catch all other asynchronous Dart errors that escape to the platform layer
  PlatformDispatcher.instance.onError = (error, stack) {
    // Log to console in debug; in release this silently prevents the crash dialog
    debugPrint('Unhandled error: $error\n$stack');
    return true; // returning true tells Flutter we handled it
  };

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
      try {
        // Initialize reminders
        await ref.read(reminderNotificationServiceProvider).initialize();

        // Initialize daily backup scheduler
        final db = ref.read(databaseProvider);
        await BackupSchedulerService.initialize(db);
      } catch (e, stackTrace) {
        // Log initialization errors without crashing the app
        debugPrint('Initialization error: $e\n$stackTrace');
      }
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

    final themeMode = ref.watch(themeModeProvider);

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
      themeMode: themeMode,
      routerConfig: goRouter,
    );
  }
}