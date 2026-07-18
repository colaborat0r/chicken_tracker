// lib/core/database/app_database.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'dart:async';

part 'app_database.g.dart';

// ====================== TABLES ======================

// 1. Individual Birds (new powerful feature)
class Birds extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get breed => text().withDefault(const Constant('Unknown'))();
  TextColumn get eggColor => text().nullable()(); // Brown, Colored, White
  DateTimeColumn get hatchDate => dateTime()();
  TextColumn get status => text().withDefault(const Constant('laying'))(); // laying, growing, sold, deceased
  TextColumn get notes => text().nullable()();
  TextColumn get photoPath => text().nullable()(); // Path to stored photo file
}

// 2. Daily Log (core of the original spreadsheet)
class DailyLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get layingHens => integer().withDefault(const Constant(0))();
  IntColumn get eggsBrown => integer().withDefault(const Constant(0))();
  IntColumn get eggsColored => integer().withDefault(const Constant(0))();
  IntColumn get eggsWhite => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// 3. Sales
class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()(); // 'eggs' or 'chickens'
  RealColumn get quantity => real()(); // dozens for eggs, or based on unit
  TextColumn get unit => text().withDefault(const Constant('dozens'))(); // dozens, crates, units
  RealColumn get amount => real()();
  TextColumn get customerName => text().nullable()();
  BoolColumn get isPaid => boolean().withDefault(const Constant(true))();
}

// 4. Expenses
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get category => text()(); // feed, bedding, general, medicine, other
  RealColumn get amount => real()();
  TextColumn get description => text().nullable()();
  RealColumn get pounds => real().nullable()(); // only for feed
}

// 5. Flock Purchases
class FlockPurchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()(); // live_chicks, hatching_eggs
  IntColumn get quantity => integer()();
  RealColumn get cost => real()();
  TextColumn get supplier => text().nullable()();
  IntColumn get hatchedCount => integer().nullable()();
}

// 6. Flock Losses
class FlockLosses extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()(); // human_consumption, natural_causes, predator
  IntColumn get quantity => integer()();
  TextColumn get predatorSubtype => text().nullable()(); // raccoon, skunk, etc.
}

// 7. App Settings
class Settings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  TextColumn get weightUnit => text().withDefault(const Constant('lbs'))();
  BoolColumn get darkMode => boolean().withDefault(const Constant(true))();
}

// 8. Reminders
class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // feeding, cleaning, health_check
  TextColumn get title => text()();
  IntColumn get frequencyDays => integer().withDefault(const Constant(1))();
  DateTimeColumn get nextDueDate => dateTime()();
  DateTimeColumn get lastCompletedDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get notifyOnAndroid =>
      boolean().withDefault(const Constant(false))();
}

// 9. Saved Guides
class SavedGuides extends Table {
  TextColumn get guideId => text()();
  DateTimeColumn get savedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {guideId};
}

// 10. Read Guides
class ReadGuides extends Table {
  TextColumn get guideId => text()();
  IntColumn get progressPercent => integer().withDefault(const Constant(0))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastReadAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {guideId};
}

// 11. Care Logs (flock care journal notes)
class CareLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get title => text().withDefault(const Constant('Care Note'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// 12. Care Log Photos
class CareLogPhotos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careLogId =>
      integer().references(CareLogs, #id, onDelete: KeyAction.cascade)();
  TextColumn get filePath => text()();
  TextColumn get galleryUri => text().nullable()();
  TextColumn get caption => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// ====================== NEW CRM / ORDERS TABLES ======================

// 13. Customers (simple CRM)
class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastOrderDate => dateTime().nullable()();
  RealColumn get totalSpent => real().withDefault(const Constant(0.0))();
  RealColumn get unpaidBalance => real().withDefault(const Constant(0.0))();
}

// 14. Orders (header – supports multi-line items + delivery date)
class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId =>
      integer().nullable().references(Customers, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get orderDate => dateTime()();
  DateTimeColumn get deliveryDate => dateTime().nullable()();
  TextColumn get status =>
      text().withDefault(const Constant('confirmed'))(); // draft, confirmed, paid, delivered, cancelled
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
  BoolColumn get isDelivered => boolean().withDefault(const Constant(false))();
  TextColumn get invoiceNumber => text().nullable()();
  TextColumn get notes => text().nullable()();
  RealColumn get subtotal => real().withDefault(const Constant(0.0))();
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

// 15. Order line items (multi-line support)
class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId =>
      integer().references(Orders, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => text()(); // eggs, chickens, other
  TextColumn get description => text()();
  RealColumn get quantity => real()();
  TextColumn get unit => text()(); // dozens, crates, individual, birds, units
  RealColumn get unitPrice => real()();
  RealColumn get lineTotal => real()();
  TextColumn get notes => text().nullable()();
}

@DriftDatabase(
  tables: [
    Birds,
    DailyLogs,
    Sales,
    Expenses,
    FlockPurchases,
    FlockLosses,
    Settings,
    Reminders,
    SavedGuides,
    ReadGuides,
    CareLogs,
    CareLogPhotos,
    Customers,
    Orders,
    OrderItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(reminders);
      }
      if (from >= 2 && from < 3) {
        await m.addColumn(reminders, reminders.notifyOnAndroid);
      }
      if (from < 4) {
        await m.createTable(savedGuides);
        await m.createTable(readGuides);
      }
      if (from < 5) {
        await m.createTable(careLogs);
        await m.createTable(careLogPhotos);
      }
      if (from < 6) {
        // Upgrade Sales table: quantity from Int to Real, add unit
        // ignore: experimental_member_use
        await m.alterTable(TableMigration(sales, columnTransformer: {
          sales.quantity: sales.quantity.cast<double>(),
        }, newColumns: [sales.unit]));
      }
      if (from < 7) {
        await m.addColumn(sales, sales.isPaid);
      }
      if (from < 8) {
        await m.createTable(customers);
        await m.createTable(orders);
        await m.createTable(orderItems);
      }
      if (from < 9) {
        await m.addColumn(orders, orders.isPaid);
        await m.addColumn(orders, orders.isDelivered);
      }
      if (from < 10) {
        await m.addColumn(customers, customers.unpaidBalance);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'chicken_tracker');
  }

  // ====================== BIRDS DAO ======================
  Future<int> addBird(BirdsCompanion bird) => into(birds).insert(bird);
  
  Future<List<Bird>> getAllBirds() => select(birds).get();
  
  Future<Bird?> getBirdById(int id) => 
    (select(birds)..where((b) => b.id.equals(id))).getSingleOrNull();
  
  Future<void> updateBird(Bird bird) => update(birds).replace(bird);
  
  Future<void> deleteBird(int id) => 
    (delete(birds)..where((b) => b.id.equals(id))).go();

  // ====================== DAILY LOGS DAO ======================
  Future<int> addDailyLog(DailyLogsCompanion log) => into(dailyLogs).insert(log);
  
  Future<List<DailyLog>> getAllDailyLogs() => 
    (select(dailyLogs)..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
      .get();
  
  Future<DailyLog?> getDailyLogByDate(DateTime date) async {
    final logs = await getAllDailyLogs();
    for (var log in logs) {
      if (log.date.year == date.year && 
          log.date.month == date.month && 
          log.date.day == date.day) {
        return log;
      }
    }
    return null;
  }
  
  Future<void> updateDailyLog(DailyLog log) => update(dailyLogs).replace(log);

  // ====================== SALES DAO ======================
  Future<int> addSale(SalesCompanion sale) => into(sales).insert(sale);
  
  Future<List<Sale>> getAllSales() => 
    (select(sales)..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
      .get();

  Future<void> updateSale(Sale sale) => update(sales).replace(sale);

  Future<void> deleteSale(int id) =>
      (delete(sales)..where((s) => s.id.equals(id))).go();

  // ====================== EXPENSES DAO ======================
  Future<int> addExpense(ExpensesCompanion expense) => into(expenses).insert(expense);
  
  Future<List<Expense>> getAllExpenses() => 
    (select(expenses)..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
      .get();

  Future<void> updateExpense(Expense expense) => update(expenses).replace(expense);

  Future<void> deleteExpense(int id) =>
      (delete(expenses)..where((e) => e.id.equals(id))).go();

  // ====================== FLOCK PURCHASES DAO ======================
  Future<void> updateFlockPurchase(FlockPurchase purchase) =>
      update(flockPurchases).replace(purchase);

  Future<void> deleteFlockPurchase(int id) =>
      (delete(flockPurchases)..where((p) => p.id.equals(id))).go();

  // ====================== FLOCK LOSSES DAO ======================
  Future<void> updateFlockLoss(FlockLossesData loss) =>
      update(flockLosses).replace(loss);

  Future<void> deleteFlockLoss(int id) =>
      (delete(flockLosses)..where((l) => l.id.equals(id))).go();

  // ====================== DAILY LOGS DAO ======================
  Future<void> deleteDailyLog(int id) =>
      (delete(dailyLogs)..where((l) => l.id.equals(id))).go();

  // ====================== REMINDERS DAO ======================
  Stream<List<Reminder>> watchAllReminders() =>
      (select(reminders)
            ..orderBy([(r) => OrderingTerm(expression: r.nextDueDate)]))
          .watch();

  Future<List<Reminder>> getAllRemindersSnapshot() =>
      (select(reminders)
            ..orderBy([(r) => OrderingTerm(expression: r.nextDueDate)]))
          .get();

  Future<int> addReminder(RemindersCompanion reminder) =>
      into(reminders).insert(reminder);

  Future<void> markReminderDone(int id, DateTime nextDueDate) =>
      (update(reminders)..where((r) => r.id.equals(id))).write(
        RemindersCompanion(
          lastCompletedDate: Value(DateTime.now()),
          nextDueDate: Value(nextDueDate),
        ),
      );

  Future<void> updateReminderDetails(
    int id, {
    required String type,
    required String title,
    required int frequencyDays,
    required DateTime nextDueDate,
    String? notes,
    required bool isActive,
    required bool notifyOnAndroid,
  }) =>
      (update(reminders)..where((r) => r.id.equals(id))).write(
        RemindersCompanion(
          type: Value(type),
          title: Value(title),
          frequencyDays: Value(frequencyDays),
          nextDueDate: Value(nextDueDate),
          notes: Value(notes),
          isActive: Value(isActive),
          notifyOnAndroid: Value(notifyOnAndroid),
        ),
      );

  Future<void> deleteReminder(int id) =>
      (delete(reminders)..where((r) => r.id.equals(id))).go();

  // ====================== GUIDES DAO ======================
  Stream<List<SavedGuide>> watchSavedGuides() => select(savedGuides).watch();

  Stream<List<ReadGuide>> watchReadGuides() => select(readGuides).watch();

  Future<void> saveGuide(String guideId) =>
      into(savedGuides).insertOnConflictUpdate(
        SavedGuidesCompanion(
          guideId: Value(guideId),
          savedAt: Value(DateTime.now()),
        ),
      );

  Future<void> unsaveGuide(String guideId) =>
      (delete(savedGuides)..where((g) => g.guideId.equals(guideId))).go();

  Future<bool> isGuideSaved(String guideId) async {
    final row = await (select(savedGuides)
          ..where((g) => g.guideId.equals(guideId)))
        .getSingleOrNull();
    return row != null;
  }

   Future<void> upsertReadGuide(
     String guideId, {
     required int progressPercent,
     required bool completed,
   }) =>
       into(readGuides).insertOnConflictUpdate(
         ReadGuidesCompanion(
           guideId: Value(guideId),
           progressPercent: Value(progressPercent),
           completed: Value(completed),
           lastReadAt: Value(DateTime.now()),
         ),
       );

   // ====================== SETTINGS DAO ======================
   Future<Setting?> getSettings() async {
     final result = await (select(settings)..where((s) => s.id.equals(1))).getSingleOrNull();
     return result;
   }

   Future<void> updateThemeMode(bool darkMode) async {
     await (update(settings)..where((s) => s.id.equals(1))).write(
       SettingsCompanion(darkMode: Value(darkMode)),
     );
   }

   Future<void> initializeSettings() async {
     final existing = await getSettings();
     if (existing == null) {
       await into(settings).insert(SettingsCompanion.insert(
         currency: const Value('USD'),
         weightUnit: const Value('lbs'),
         darkMode: const Value(true),
       ));
     }
   }

  // ====================== CARE LOGS DAO ======================
  Stream<List<CareLog>> watchAllCareLogs() =>
      (select(careLogs)
            ..orderBy([
              (l) => OrderingTerm(expression: l.date, mode: OrderingMode.desc),
              (l) => OrderingTerm(expression: l.createdAt, mode: OrderingMode.desc),
            ]))
          .watch();

  Future<CareLog?> getCareLogById(int id) =>
      (select(careLogs)..where((l) => l.id.equals(id))).getSingleOrNull();

  Future<int> addCareLog(CareLogsCompanion log) => into(careLogs).insert(log);

  Future<void> updateCareLog(CareLog log) => update(careLogs).replace(log);

  Future<void> deleteCareLog(int id) =>
      (delete(careLogs)..where((l) => l.id.equals(id))).go();

  Future<List<CareLogPhoto>> getPhotosForCareLog(int careLogId) =>
      (select(careLogPhotos)
            ..where((p) => p.careLogId.equals(careLogId))
            ..orderBy([(p) => OrderingTerm(expression: p.createdAt)]))
          .get();

  Future<List<CareLogPhoto>> getAllCareLogPhotos() =>
      (select(careLogPhotos)
            ..orderBy([
              (p) => OrderingTerm(expression: p.createdAt, mode: OrderingMode.desc),
            ]))
          .get();

  Future<int> addCareLogPhoto(CareLogPhotosCompanion photo) =>
      into(careLogPhotos).insert(photo);

  Future<void> deleteCareLogPhoto(int id) =>
      (delete(careLogPhotos)..where((p) => p.id.equals(id))).go();

  Future<void> updateCareLogPhoto(CareLogPhoto photo) =>
      update(careLogPhotos).replace(photo);

  Future<CareLogPhoto?> getCareLogPhotoById(int id) =>
      (select(careLogPhotos)..where((p) => p.id.equals(id))).getSingleOrNull();

  // ====================== CRM / ORDERS DAO ======================
  Future<List<Customer>> getAllCustomers() =>
      (select(customers)..orderBy([(c) => OrderingTerm(expression: c.name)]))
          .get();

  Future<Customer?> getCustomerById(int id) =>
      (select(customers)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<int> addCustomer(CustomersCompanion customer) =>
      into(customers).insert(customer);

  Future<void> updateCustomer(Customer customer) =>
      update(customers).replace(customer);

  Future<void> deleteCustomer(int id) =>
      (delete(customers)..where((c) => c.id.equals(id))).go();

  Future<List<Order>> getAllOrders() =>
      (select(orders)..orderBy([(o) => OrderingTerm(expression: o.orderDate, mode: OrderingMode.desc)]))
          .get();

  Future<Order?> getOrderById(int id) =>
      (select(orders)..where((o) => o.id.equals(id))).getSingleOrNull();

  Future<List<OrderItem>> getOrderItems(int orderId) =>
      (select(orderItems)..where((i) => i.orderId.equals(orderId))).get();

  Future<List<Order>> getOrdersForCustomer(int customerId) =>
      (select(orders)
            ..where((o) => o.customerId.equals(customerId))
            ..orderBy([(o) => OrderingTerm(expression: o.orderDate, mode: OrderingMode.desc)]))
          .get();
}
