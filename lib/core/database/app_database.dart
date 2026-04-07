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
  IntColumn get quantity => integer()(); // dozens for eggs
  RealColumn get amount => real()();
  TextColumn get customerName => text().nullable()();
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

@DriftDatabase(tables: [Birds, DailyLogs, Sales, Expenses, FlockPurchases, FlockLosses, Settings, Reminders])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(reminders);
      }
      if (from >= 2 && from < 3) {
        await m.addColumn(reminders, reminders.notifyOnAndroid);
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

  // ====================== EXPENSES DAO ======================
  Future<int> addExpense(ExpensesCompanion expense) => into(expenses).insert(expense);
  
  Future<List<Expense>> getAllExpenses() => 
    (select(expenses)..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
      .get();

  // ====================== REMINDERS DAO ======================
  Stream<List<Reminder>> watchAllReminders() =>
      (select(reminders)
            ..orderBy([(r) => OrderingTerm(expression: r.nextDueDate)]))
          .watch();

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
}