// Models for chicken tracking domain

class ChickenModel {
  final int id;
  final String breed;
  final String? eggColor; // Brown, Colored, White, null
  final DateTime hatchDate;
  final String status; // laying, growing, sold, deceased
  final String? notes;

  ChickenModel({
    required this.id,
    required this.breed,
    this.eggColor,
    required this.hatchDate,
    required this.status,
    this.notes,
  });

  /// Get age in days
  int get ageInDays {
    return DateTime.now().difference(hatchDate).inDays;
  }

  /// Get approximate age in months
  int get ageInMonths {
    return ageInDays ~/ 30;
  }

  /// Check if chicken is currently laying (status and age)
  bool get isLaying {
    return status == 'laying' && ageInDays >= 140; // ~5 months
  }

  /// Check if chicken is healthy (not sold/deceased)
  bool get isActive {
    return status != 'sold' && status != 'deceased';
  }

  ChickenModel copyWith({
    int? id,
    String? breed,
    String? eggColor,
    DateTime? hatchDate,
    String? status,
    String? notes,
  }) {
    return ChickenModel(
      id: id ?? this.id,
      breed: breed ?? this.breed,
      eggColor: eggColor ?? this.eggColor,
      hatchDate: hatchDate ?? this.hatchDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}

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

  /// Get total eggs for the day
  int get totalEggs => eggsBrown + eggsColored + eggsWhite;

  /// Get average eggs per hen
  double get eggsPerHen {
    if (layingHens == 0) return 0;
    return totalEggs / layingHens;
  }

  /// Get production percentage (eggs per hen as %)
  double get productionPercentage {
    if (layingHens == 0) return 0;
    return (eggsPerHen / 1.0) * 100; // 1 egg per hen = 100%
  }

  DailyProductionModel copyWith({
    DateTime? date,
    int? layingHens,
    int? eggsBrown,
    int? eggsColored,
    int? eggsWhite,
    String? notes,
  }) {
    return DailyProductionModel(
      date: date ?? this.date,
      layingHens: layingHens ?? this.layingHens,
      eggsBrown: eggsBrown ?? this.eggsBrown,
      eggsColored: eggsColored ?? this.eggsColored,
      eggsWhite: eggsWhite ?? this.eggsWhite,
      notes: notes ?? this.notes,
    );
  }
}

class SaleModel {
  final int id;
  final DateTime date;
  final String type; // 'eggs' or 'chickens'
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

  /// Get unit price (per egg or per chicken)
  double get unitPrice => amount / quantity;

  SaleModel copyWith({
    int? id,
    DateTime? date,
    String? type,
    int? quantity,
    double? amount,
    String? customerName,
  }) {
    return SaleModel(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      amount: amount ?? this.amount,
      customerName: customerName ?? this.customerName,
    );
  }
}

class ExpenseModel {
  final int id;
  final DateTime date;
  final String category; // feed, bedding, general, medicine, other
  final double amount;
  final String? description;
  final double? pounds; // only for feed

  ExpenseModel({
    required this.id,
    required this.date,
    required this.category,
    required this.amount,
    this.description,
    this.pounds,
  });

  /// Get cost per pound for feed expenses
  double? get costPerPound {
    if (category == 'feed' && pounds != null && pounds! > 0) {
      return amount / pounds!;
    }
    return null;
  }

  ExpenseModel copyWith({
    int? id,
    DateTime? date,
    String? category,
    double? amount,
    String? description,
    double? pounds,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      date: date ?? this.date,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      pounds: pounds ?? this.pounds,
    );
  }
}

/// Weekly production summary for analytics
class WeeklyProductionSummary {
  final DateTime weekStart; // Monday of the week
  final int totalEggs;
  final int totalDays; // Days with data
  final double averageEggsPerDay;
  final double averageEggsPerHen;
  final int maxEggsInDay;
  final int minEggsInDay;
  final int totalBrownEggs;
  final int totalColoredEggs;
  final int totalWhiteEggs;

  WeeklyProductionSummary({
    required this.weekStart,
    required this.totalEggs,
    required this.totalDays,
    required this.averageEggsPerDay,
    required this.averageEggsPerHen,
    required this.maxEggsInDay,
    required this.minEggsInDay,
    required this.totalBrownEggs,
    required this.totalColoredEggs,
    required this.totalWhiteEggs,
  });
}

/// Monthly production summary for analytics
class MonthlyProductionSummary {
  final int year;
  final int month;
  final int totalEggs;
  final int totalDays; // Days with data
  final double averageEggsPerDay;
  final double averageEggsPerHen;
  final int maxEggsInDay;
  final int minEggsInDay;
  final int totalBrownEggs;
  final int totalColoredEggs;
  final int totalWhiteEggs;

  MonthlyProductionSummary({
    required this.year,
    required this.month,
    required this.totalEggs,
    required this.totalDays,
    required this.averageEggsPerDay,
    required this.averageEggsPerHen,
    required this.maxEggsInDay,
    required this.minEggsInDay,
    required this.totalBrownEggs,
    required this.totalColoredEggs,
    required this.totalWhiteEggs,
  });

  String get monthName {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String get displayText => '$monthName $year';
}

/// Production trend data point for charts
class ProductionTrendPoint {
  final DateTime date;
  final int eggs;
  final double eggsPerHen;
  final int layingHens;

  ProductionTrendPoint({
    required this.date,
    required this.eggs,
    required this.eggsPerHen,
    required this.layingHens,
  });
}
