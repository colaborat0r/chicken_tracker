// lib/core/database/app_database.dart
import 'package:drift/drift.dart';
import 'dart:async';

part 'app_database.g.dart';

/// MVP Database stub - currently returns empty results
/// TODO: Implement proper SQLite persistence using drift_flutter
class _StubExecutor implements QueryExecutor {
  @override
  SqlDialect get dialect => SqlDialect.sqlite;

  @override
  Future<void> close() async {}

  @override
  Future<T> doWhenOpened<T>(FutureOr<T> Function(QueryExecutor p1) fn) async =>
      await fn(this);

  @override
  TransactionExecutor beginTransaction() =>
      throw UnimplementedError('MVP version does not support transactions');

  @override
  TransactionExecutor beginExclusive() =>
      throw UnimplementedError('MVP version does not support transactions');

  @override
  Future<bool> ensureOpen(QueryExecutorUser user) async => true;

  @override
  Future<void> runBatched(BatchedStatements statements) async {}

  @override
  Future<List<Map<String, dynamic>>> runSelect(String statement,
      List<dynamic> args) async {
    return [];
  }

  @override
  Future<int> runUpdate(String statement, List<dynamic> args) async => 0;

  @override
  Future<int> runDelete(String statement, List<dynamic> args) async => 0;

  @override
  Future<int> runInsert(String statement, List<dynamic> args) async => 0;

  @override
  Future<void> runCustom(String statement, [List<Object?>? args]) async {}
}

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
  DateTimeColumn get date => dateTime()();
  IntColumn get layingHens => integer().withDefault(const Constant(0))();
  IntColumn get eggsBrown => integer().withDefault(const Constant(0))();
  IntColumn get eggsColored => integer().withDefault(const Constant(0))();
  IntColumn get eggsWhite => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  
  @override
  List<Set<Column>> get uniqueKeys => [
    {date},
  ];
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

@DriftDatabase(tables: [Birds, DailyLogs, Sales, Expenses, FlockPurchases, FlockLosses, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    // MVP implementation - uses stub executor
    // TODO: Replace with actual implementation using drift_flutter
    return _StubExecutor();
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
}