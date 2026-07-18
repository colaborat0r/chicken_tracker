import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'config/router.dart';
import 'core/models/reminder_model.dart';
import 'core/providers/database_providers.dart';
import 'core/providers/database_instance_provider.dart';
import 'core/providers/repository_providers.dart';
import 'core/providers/notification_providers.dart';
import 'core/providers/theme_providers.dart';
import 'core/services/backup_scheduler_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Catch Flutter framework errors (widget build / layout errors).
  // In release mode, log silently rather than showing the red error screen.
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      FlutterError.presentError(details);
    } else {
      debugPrint('[FlutterError] ${details.exceptionAsString()}');
      debugPrintStack(stackTrace: details.stack);
    }
  };

  // Catch all other asynchronous Dart errors that escape to the platform layer.
  // Returning true tells Flutter we handled it, preventing a hard crash dialog.
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('[PlatformError] $error');
    debugPrintStack(stackTrace: stack);
    return true;
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

        // Auto-update growing birds to laying status
        final updatedCount = await ref.read(chickenRepositoryProvider).autoUpdateGrowingBirds();
        if (updatedCount > 0) {
          debugPrint('[Flock] Auto-updated $updatedCount growing birds to laying status.');
        }

        // Sync all customer totals to fix any inconsistent balances
        await ref.read(customerRepositoryProvider).syncAllCustomers();
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
        try {
          ref.read(reminderNotificationServiceProvider).resyncActiveReminders(
                reminders,
              );
        } catch (e) {
          debugPrint('[Reminders] resync error: $e');
        }
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