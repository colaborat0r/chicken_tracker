import 'package:chicken_tracker/core/models/chicken_model.dart';
import 'package:chicken_tracker/core/models/order_model.dart';

enum ActivityType { production, sale, expense, order }

class RecentActivityItem {
  final DateTime date;
  final ActivityType type;
  final dynamic data;

  RecentActivityItem({
    required this.date,
    required this.type,
    required this.data,
  });

  DailyProductionModel? get production =>
      type == ActivityType.production ? data as DailyProductionModel : null;
  SaleModel? get sale => type == ActivityType.sale ? data as SaleModel : null;
  ExpenseModel? get expense =>
      type == ActivityType.expense ? data as ExpenseModel : null;
  OrderWithDetails? get order =>
      type == ActivityType.order ? data as OrderWithDetails : null;
}
