import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_providers.dart';
import 'notification_providers.dart';
import '../repositories/chicken_repository.dart';
import '../repositories/reminder_repository.dart';

/// Repository provider for chickens
final chickenRepositoryProvider = Provider<ChickenRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ChickenRepository(db);
});

/// Repository provider for production logging
final productionRepositoryProvider = Provider<ProductionRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ProductionRepository(db);
});

/// Repository provider for sales
final salesRepositoryProvider = Provider<SalesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SalesRepository(db);
});

/// Repository provider for expenses
final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ExpenseRepository(db);
});

/// Repository provider for reminders
final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final notificationService = ref.watch(reminderNotificationServiceProvider);
  return ReminderRepository(db, notificationService);
});
