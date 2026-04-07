import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/chicken_model.dart';

/// Repository for managing chicken/bird data
class ChickenRepository {
  final AppDatabase database;

  ChickenRepository(this.database);

  /// Add a new chicken to the flock
  Future<int> addChicken({
    required String breed,
    String? eggColor,
    required DateTime hatchDate,
    String status = 'laying',
    String? notes,
  }) {
    return database.addBird(BirdsCompanion(
      breed: Value(breed),
      eggColor: Value(eggColor),
      hatchDate: Value(hatchDate),
      status: Value(status),
      notes: Value(notes),
    ));
  }

  /// Record a flock purchase and optionally create one bird record per unit.
  ///
  /// For `hatching_eggs`, keep current behavior and do not create birds.
  Future<void> recordFlockPurchase({
    required DateTime date,
    required String type,
    required int quantity,
    required double cost,
    String? supplier,
    int? hatchedCount,
    String? breed,
    String? status,
    DateTime? hatchDate,
    String? notes,
  }) async {
    final normalizedSupplier = _nullIfEmpty(supplier);

    await database.transaction(() async {
      await database.into(database.flockPurchases).insert(
            FlockPurchasesCompanion(
              date: Value(date),
              type: Value(type),
              quantity: Value(quantity),
              cost: Value(cost),
              supplier: Value(normalizedSupplier),
              hatchedCount: Value(hatchedCount),
            ),
          );

      if (type != 'live_chicks') {
        return;
      }

      final normalizedBreed = (breed ?? '').trim();
      if (normalizedBreed.isEmpty) {
        throw ArgumentError('Breed is required for live chick purchases.');
      }

      final birdStatus = (status ?? 'growing').trim();
      final birdHatchDate = hatchDate ?? date;
      final birdNotes = _nullIfEmpty(notes);

      for (var i = 0; i < quantity; i++) {
        await database.addBird(BirdsCompanion(
          breed: Value(normalizedBreed),
          eggColor: const Value(null),
          hatchDate: Value(birdHatchDate),
          status: Value(birdStatus),
          notes: Value(birdNotes),
        ));
      }
    });
  }

  /// Add multiple chickens in one flow, and optionally create a matching
  /// purchase record when `costPerBird` is provided.
  Future<void> addMultipleChickens({
    required int quantity,
    required String breed,
    required String status,
    required DateTime hatchDate,
    String? notes,
    double? costPerBird,
    String? supplier,
  }) async {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be greater than 0.');
    }

    final normalizedBreed = breed.trim();
    if (normalizedBreed.isEmpty) {
      throw ArgumentError('Breed is required.');
    }

    final normalizedNotes = _nullIfEmpty(notes);
    final normalizedSupplier = _nullIfEmpty(supplier);

    await database.transaction(() async {
      for (var i = 0; i < quantity; i++) {
        await database.addBird(BirdsCompanion(
          breed: Value(normalizedBreed),
          eggColor: const Value(null),
          hatchDate: Value(hatchDate),
          status: Value(status),
          notes: Value(normalizedNotes),
        ));
      }

      if (costPerBird != null) {
        await database.into(database.flockPurchases).insert(
              FlockPurchasesCompanion(
                date: Value(DateTime.now()),
                type: const Value('live_chicks'),
                quantity: Value(quantity),
                cost: Value(costPerBird * quantity),
                supplier: Value(normalizedSupplier),
                hatchedCount: const Value(null),
              ),
            );
      }
    });
  }

  String? _nullIfEmpty(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  /// Get all chickens in the flock
  Future<List<ChickenModel>> getAllChickens() async {
    final birds = await database.getAllBirds();
    return birds
        .map((bird) => ChickenModel(
              id: bird.id,
              breed: bird.breed,
              eggColor: bird.eggColor,
              hatchDate: bird.hatchDate,
              status: bird.status,
              notes: bird.notes,
            ))
        .toList();
  }

  /// Get all active chickens (laying, growing)
  Future<List<ChickenModel>> getActiveChickens() async {
    final all = await getAllChickens();
    return all.where((c) => c.isActive).toList();
  }

  /// Get all chickens currently laying
  Future<List<ChickenModel>> getLayingChickens() async {
    final all = await getAllChickens();
    return all.where((c) => c.isLaying).toList();
  }

  /// Get a specific chicken by ID
  Future<ChickenModel?> getChickenById(int id) async {
    final bird = await database.getBirdById(id);
    if (bird == null) return null;

    return ChickenModel(
      id: bird.id,
      breed: bird.breed,
      eggColor: bird.eggColor,
      hatchDate: bird.hatchDate,
      status: bird.status,
      notes: bird.notes,
    );
  }

  /// Update a chicken's information
  Future<void> updateChicken(ChickenModel chicken) {
    return database.updateBird(Bird(
      id: chicken.id,
      breed: chicken.breed,
      eggColor: chicken.eggColor,
      hatchDate: chicken.hatchDate,
      status: chicken.status,
      notes: chicken.notes,
    ));
  }

  /// Mark a chicken as sold
  Future<void> markAsSold(int id) async {
    final chicken = await getChickenById(id);
    if (chicken != null) {
      await updateChicken(chicken.copyWith(status: 'sold'));
    }
  }

  /// Mark a chicken as deceased
  Future<void> markAsDeceased(int id) async {
    final chicken = await getChickenById(id);
    if (chicken != null) {
      await updateChicken(chicken.copyWith(status: 'deceased'));
    }
  }

  /// Delete a chicken record
  Future<void> deleteChicken(int id) {
    return database.deleteBird(id);
  }

  /// Get total count of active chickens
  Future<int> getActiveChickenCount() async {
    final active = await getActiveChickens();
    return active.length;
  }

  /// Get total count of laying chickens
  Future<int> getLayingChickenCount() async {
    final laying = await getLayingChickens();
    return laying.length;
  }
}

/// Repository for managing daily production logs
class ProductionRepository {
  final AppDatabase database;

  ProductionRepository(this.database);

  /// Log daily egg production
  Future<void> logDailyProduction({
    required int layingHens,
    required int eggsBrown,
    required int eggsColored,
    required int eggsWhite,
    String? notes,
  }) async {
    final today = DateTime.now();
    // Check if log exists for today
    final existing = await database.getDailyLogByDate(today);

    if (existing != null) {
      final log = DailyLog(
        id: existing.id,
        date: today,
        layingHens: layingHens,
        eggsBrown: eggsBrown,
        eggsColored: eggsColored,
        eggsWhite: eggsWhite,
        notes: notes ?? existing.notes,
      );
      await database.updateDailyLog(log);
    } else {
      await database.addDailyLog(DailyLogsCompanion(
        date: Value(today),
        layingHens: Value(layingHens),
        eggsBrown: Value(eggsBrown),
        eggsColored: Value(eggsColored),
        eggsWhite: Value(eggsWhite),
        notes: Value(notes),
      ));
    }
  }

  /// Get all daily production logs
  Future<List<DailyProductionModel>> getAllLogs() async {
    final logs = await database.getAllDailyLogs();
    return logs
        .map((log) => DailyProductionModel(
              date: log.date,
              layingHens: log.layingHens,
              eggsBrown: log.eggsBrown,
              eggsColored: log.eggsColored,
              eggsWhite: log.eggsWhite,
              notes: log.notes,
            ))
        .toList();
  }

  /// Get today's production log
  Future<DailyProductionModel?> getTodayProduction() async {
    final today = DateTime.now();
    final log = await database.getDailyLogByDate(today);

    if (log == null) return null;

    return DailyProductionModel(
      date: log.date,
      layingHens: log.layingHens,
      eggsBrown: log.eggsBrown,
      eggsColored: log.eggsColored,
      eggsWhite: log.eggsWhite,
      notes: log.notes,
    );
  }

  /// Get production logs for a date range
  Future<List<DailyProductionModel>> getProductionRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final allLogs = await getAllLogs();
    return allLogs
        .where(
            (log) => log.date.isAfter(startDate) && log.date.isBefore(endDate))
        .toList();
  }

  /// Get total eggs for a date range
  Future<int> getTotalEggsInRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final allLogs = await getAllLogs();
    int total = 0;
    for (var log in allLogs) {
      if (log.date.isAfter(startDate) && log.date.isBefore(endDate)) {
        total += log.totalEggs;
      }
    }
    return total;
  }

  /// Get average daily production for a range
  Future<double> getAverageDailyProduction(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final logs = await getProductionRange(startDate, endDate);
    if (logs.isEmpty) return 0;

    final total = logs.fold<int>(
      0,
      (sum, log) => sum + log.totalEggs,
    );
    return total / logs.length;
  }

  /// Get best production day in a range
  Future<DailyProductionModel?> getBestProductionDay(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final logs = await getProductionRange(startDate, endDate);
    if (logs.isEmpty) return null;

    logs.sort((a, b) => b.totalEggs.compareTo(a.totalEggs));
    return logs.first;
  }
}

/// Repository for managing sales
class SalesRepository {
  final AppDatabase database;

  SalesRepository(this.database);

  /// Record a sale
  Future<int> recordSale({
    required String type, // 'eggs' or 'chickens'
    required int quantity,
    required double amount,
    String? customerName,
  }) {
    return database.addSale(SalesCompanion(
      date: Value(DateTime.now()),
      type: Value(type),
      quantity: Value(quantity),
      amount: Value(amount),
      customerName: Value(customerName),
    ));
  }

  /// Get all sales records
  Future<List<SaleModel>> getAllSales() async {
    final sales = await database.getAllSales();
    return sales
        .map((sale) => SaleModel(
              id: sale.id,
              date: sale.date,
              type: sale.type,
              quantity: sale.quantity,
              amount: sale.amount,
              customerName: sale.customerName,
            ))
        .toList();
  }

  /// Get total revenue for a date range
  Future<double> getTotalRevenue(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final allSales = await getAllSales();
    double total = 0;
    for (var sale in allSales) {
      if (sale.date.isAfter(startDate) && sale.date.isBefore(endDate)) {
        total += sale.amount;
      }
    }
    return total;
  }

  /// Get revenue from eggs only
  Future<double> getEggRevenue(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final sales = await getAllSales();
    final eggSales = sales
        .where((s) =>
            s.type == 'eggs' &&
            s.date.isAfter(startDate) &&
            s.date.isBefore(endDate))
        .toList();

    double total = 0.0;
    for (var sale in eggSales) {
      total += sale.amount;
    }
    return total;
  }

  /// Get revenue from chickens only
  Future<double> getChickenRevenue(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final sales = await getAllSales();
    final chickenSales = sales
        .where((s) =>
            s.type == 'chickens' &&
            s.date.isAfter(startDate) &&
            s.date.isBefore(endDate))
        .toList();

    double total = 0.0;
    for (var sale in chickenSales) {
      total += sale.amount;
    }
    return total;
  }
}

/// Repository for managing expenses
class ExpenseRepository {
  final AppDatabase database;

  ExpenseRepository(this.database);

  /// Record an expense
  Future<int> recordExpense({
    required String category, // feed, bedding, general, medicine, other
    required double amount,
    String? description,
    double? pounds, // only for feed
  }) {
    return database.addExpense(ExpensesCompanion(
      date: Value(DateTime.now()),
      category: Value(category),
      amount: Value(amount),
      description: Value(description),
      pounds: Value(pounds),
    ));
  }

  /// Get all expenses
  Future<List<ExpenseModel>> getAllExpenses() async {
    final expenses = await database.getAllExpenses();
    return expenses
        .map((expense) => ExpenseModel(
              id: expense.id,
              date: expense.date,
              category: expense.category,
              amount: expense.amount,
              description: expense.description,
              pounds: expense.pounds,
            ))
        .toList();
  }

  /// Get total expenses for a date range
  Future<double> getTotalExpenses(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final allExpenses = await getAllExpenses();
    double total = 0;
    for (var expense in allExpenses) {
      if (expense.date.isAfter(startDate) && expense.date.isBefore(endDate)) {
        total += expense.amount;
      }
    }
    return total;
  }

  /// Get expenses by category
  Future<Map<String, double>> getExpensesByCategory(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final expenses = await getAllExpenses();
    final filtered = expenses
        .where((e) => e.date.isAfter(startDate) && e.date.isBefore(endDate))
        .toList();

    final categories = <String, double>{};
    for (var expense in filtered) {
      categories[expense.category] =
          (categories[expense.category] ?? 0) + expense.amount;
    }
    return categories;
  }

  /// Get feed cost per pound
  Future<double> getAverageFeedCostPerPound(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final expenses = await getAllExpenses();
    final feedExpenses = expenses
        .where((e) =>
            e.category == 'feed' &&
            e.pounds != null &&
            e.pounds! > 0 &&
            e.date.isAfter(startDate) &&
            e.date.isBefore(endDate))
        .toList();

    if (feedExpenses.isEmpty) return 0;

    final totalCost = feedExpenses.fold(0.0, (sum, e) => sum + e.amount);
    final totalPounds =
        feedExpenses.fold(0.0, (sum, e) => sum + (e.pounds ?? 0));

    if (totalPounds == 0) return 0;
    return totalCost / totalPounds;
  }
}

/// Model class for easy use
class SaleModel {
  final int id;
  final DateTime date;
  final String type;
  final int quantity;
  final double amount;
  final String? customerName;

  SaleModel({
    required this.id,
    required this.date,
    required this.type,
    required this.quantity,
    required this.amount,
    this.customerName,
  });

  double get unitPrice => amount / quantity;
}

/// Model class for easy use
class ExpenseModel {
  final int id;
  final DateTime date;
  final String category;
  final double amount;
  final String? description;
  final double? pounds;

  ExpenseModel({
    required this.id,
    required this.date,
    required this.category,
    required this.amount,
    this.description,
    this.pounds,
  });

  double? get costPerPound {
    if (category == 'feed' && pounds != null && pounds! > 0) {
      return amount / pounds!;
    }
    return null;
  }
}

/// Model class for easy use
class DailyProductionModel {
  final DateTime date;
  final int layingHens;
  final int eggsBrown;
  final int eggsColored;
  final int eggsWhite;
  final String? notes;

  DailyProductionModel({
    required this.date,
    required this.layingHens,
    required this.eggsBrown,
    required this.eggsColored,
    required this.eggsWhite,
    this.notes,
  });

  int get totalEggs => eggsBrown + eggsColored + eggsWhite;

  double get eggsPerHen {
    if (layingHens == 0) return 0;
    return totalEggs / layingHens;
  }

  double get productionPercentage {
    if (layingHens == 0) return 0;
    return (eggsPerHen / 1.0) * 100;
  }
}
