import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chicken_tracker/core/providers/database_instance_provider.dart';
import 'package:chicken_tracker/core/providers/notification_providers.dart';
import 'package:chicken_tracker/core/repositories/chicken_repository.dart';
import 'package:chicken_tracker/core/repositories/reminder_repository.dart';
import 'package:chicken_tracker/core/repositories/care_log_repository.dart';
import 'package:chicken_tracker/core/repositories/customer_repository.dart';
import 'package:chicken_tracker/core/repositories/order_repository.dart';
import 'package:chicken_tracker/core/services/image_storage_service.dart';
import 'package:chicken_tracker/core/services/migration_service.dart';
import 'package:chicken_tracker/core/models/care_log_model.dart';
import 'package:chicken_tracker/features/guides/repositories/guides_repository.dart';

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

/// Repository provider for flock purchases
final flockPurchaseRepositoryProvider = Provider<FlockPurchaseRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return FlockPurchaseRepository(db);
});

/// Repository provider for flock losses
final flockLossRepositoryProvider = Provider<FlockLossRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return FlockLossRepository(db);
});

/// Service provider for image storage
final imageStorageServiceProvider = Provider<ImageStorageService>((ref) {
  return ImageStorageService();
});

/// Repository provider for care logs
final careLogRepositoryProvider = Provider<CareLogRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final imageStorage = ref.watch(imageStorageServiceProvider);
  return CareLogRepository(db, imageStorage);
});

/// Provider for all care logs as a stream
final allCareLogsProvider = StreamProvider<List<CareLogModel>>((ref) {
  return ref.watch(careLogRepositoryProvider).watchAllCareLogs();
});

List<CareLogGalleryItem> _galleryItemsFromLogs(List<CareLogModel> logs) {
  final items = <CareLogGalleryItem>[];
  for (final log in logs) {
    for (final photo in log.photos) {
      items.add(CareLogGalleryItem(photo: photo, log: log));
    }
  }
  items.sort((a, b) => b.photo.createdAt.compareTo(a.photo.createdAt));
  return items;
}

/// Provider for all care log photos across every note
final careLogGalleryProvider =
    StreamProvider<List<CareLogGalleryItem>>((ref) async* {
  await for (final logs
      in ref.watch(careLogRepositoryProvider).watchAllCareLogs()) {
    yield _galleryItemsFromLogs(logs);
  }
});

/// Repository provider for guides and bookmarks
final guidesRepositoryProvider = Provider<GuidesRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return GuidesRepository(db);
});

// ====================== NEW CRM / ORDERS PROVIDERS ======================

/// Repository provider for customers (simple CRM)
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return CustomerRepository(db);
});

/// Repository provider for multi-line orders
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final customerRepo = ref.watch(customerRepositoryProvider);
  return OrderRepository(db, customerRepo);
});

/// Service provider for database migrations
final migrationServiceProvider = Provider<MigrationService>((ref) {
  final db = ref.watch(databaseProvider);
  final orderRepo = ref.watch(orderRepositoryProvider);
  final customerRepo = ref.watch(customerRepositoryProvider);
  return MigrationService(
    database: db,
    orderRepository: orderRepo,
    customerRepository: customerRepo,
  );
});
