import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../models/chicken_model.dart';

/// Provider for the AppDatabase instance (singleton)
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// Provider for all chickens as a stream
final allChickensProvider = StreamProvider<List<ChickenModel>>((ref) async* {
  final db = ref.watch(databaseProvider);
  
  // Watch for changes and emit updated list
  yield* db.select(db.birds).watch().map((birds) {
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
  });
});

/// Provider for count of active chickens
final activeChickensCountProvider = 
    FutureProvider<int>((ref) async {
  final db = ref.watch(databaseProvider);
  final birds = await db.getAllBirds();
  return birds.where((b) => b.status != 'sold' && b.status != 'deceased').length;
});

/// Provider for daily production logs as a stream
final allDailyLogsProvider = StreamProvider<List<DailyProductionModel>>((ref) async* {
  final db = ref.watch(databaseProvider);
  
  yield* db.select(db.dailyLogs).watch().map((logs) {
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
  });
});

/// Provider for today's daily log
final todayProductionProvider = 
    FutureProvider<DailyProductionModel?>((ref) async {
  final db = ref.watch(databaseProvider);
  final today = DateTime.now();
  final log = await db.getDailyLogByDate(today);
  
  if (log == null) return null;
  
  return DailyProductionModel(
    date: log.date,
    layingHens: log.layingHens,
    eggsBrown: log.eggsBrown,
    eggsColored: log.eggsColored,
    eggsWhite: log.eggsWhite,
    notes: log.notes,
  );
});

/// Provider for today's total egg count
final todayEggCountProvider = FutureProvider<int>((ref) async {
  final production = await ref.watch(todayProductionProvider.future);
  return production?.totalEggs ?? 0;
});

/// Provider for total eggs this week (last 7 days including today)
final weeklyEggTotalProvider = 
    FutureProvider<int>((ref) async {
  final logs = await ref.watch(allDailyLogsProvider.future);
  final today = DateTime.now();
  final sevenDaysAgo = today.subtract(const Duration(days: 6)); // Include today and 6 previous days
  
  int total = 0;
  for (var log in logs) {
    // Compare dates by year, month, day to ignore time components
    final logDate = DateTime(log.date.year, log.date.month, log.date.day);
    final todayDate = DateTime(today.year, today.month, today.day);
    final sevenDaysAgoDate = DateTime(sevenDaysAgo.year, sevenDaysAgo.month, sevenDaysAgo.day);
    
    if (logDate.isAtSameMomentAs(todayDate) || 
        (logDate.isAfter(sevenDaysAgoDate) && logDate.isBefore(todayDate))) {
      total += log.totalEggs;
    }
  }
  return total;
});

/// Provider for sales data
final allSalesProvider = StreamProvider<List<SaleModel>>((ref) async* {
  final db = ref.watch(databaseProvider);
  
  yield* db.select(db.sales).watch().map((sales) {
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
  });
});

/// Provider for expenses data
final allExpensesProvider = StreamProvider<List<ExpenseModel>>((ref) async* {
  final db = ref.watch(databaseProvider);
  
  yield* db.select(db.expenses).watch().map((expenses) {
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
  });
});

/// Family provider for getting a specific chicken by ID
final chickenByIdProvider = 
    FutureProvider.family<ChickenModel?, int>((ref, id) async {
  final db = ref.watch(databaseProvider);
  final bird = await db.getBirdById(id);
  
  if (bird == null) return null;
  
  return ChickenModel(
    id: bird.id,
    breed: bird.breed,
    eggColor: bird.eggColor,
    hatchDate: bird.hatchDate,
    status: bird.status,
    notes: bird.notes,
  );
});
