// lib/core/repositories/customer_repository.dart
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/customer_model.dart';

class CustomerRepository {
  final AppDatabase database;

  CustomerRepository(this.database);

  Future<int> addCustomer({
    required String name,
    String? phone,
    String? email,
    String? address,
    String? notes,
  }) {
    return database.into(database.customers).insert(CustomersCompanion(
          name: Value(name.trim()),
          phone: Value(_nullIfEmpty(phone)),
          email: Value(_nullIfEmpty(email)),
          address: Value(_nullIfEmpty(address)),
          notes: Value(_nullIfEmpty(notes)),
          createdAt: Value(DateTime.now()),
          totalSpent: const Value(0.0),
          unpaidBalance: const Value(0.0),
        ));
  }

  Future<void> updateCustomer(CustomerModel customer) {
    return database.update(database.customers).replace(Customer(
          id: customer.id,
          name: customer.name,
          phone: customer.phone,
          email: customer.email,
          address: customer.address,
          notes: customer.notes,
          createdAt: customer.createdAt,
          lastOrderDate: customer.lastOrderDate,
          totalSpent: customer.totalSpent,
          unpaidBalance: customer.unpaidBalance,
        ));
  }

  Future<void> deleteCustomer(int id) {
    return (database.delete(database.customers)
          ..where((c) => c.id.equals(id)))
        .go();
  }

  Future<List<CustomerModel>> getAllCustomers() async {
    final rows = await (database.select(database.customers)
          ..orderBy([(c) => OrderingTerm(expression: c.name)]))
        .get();
    return rows.map(mapCustomer).toList();
  }

  Future<CustomerModel?> getCustomerById(int id) async {
    final row = await (database.select(database.customers)
          ..where((c) => c.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : mapCustomer(row);
  }

  Stream<List<CustomerModel>> watchAllCustomers() {
    return (database.select(database.customers)
          ..orderBy([(c) => OrderingTerm(expression: c.name)]))
        .watch()
        .map((rows) => rows.map(mapCustomer).toList());
  }

  /// Recalculates totalSpent, unpaidBalance and lastOrderDate by scanning all orders
  Future<void> syncCustomerTotals(int customerId) async {
    final orders = await database.getOrdersForCustomer(customerId);
    
    // Include all orders that are NOT cancelled
    final validOrders = orders.where((o) => o.status != 'cancelled').toList();
    
    double totalSpent = 0.0;
    double unpaidBalance = 0.0;
    DateTime? lastOrderDate;

    for (final order in validOrders) {
      totalSpent += order.totalAmount;
      if (!order.isPaid) {
        unpaidBalance += order.totalAmount;
      }
      
      if (lastOrderDate == null || order.orderDate.isAfter(lastOrderDate)) {
        lastOrderDate = order.orderDate;
      }
    }

    final customer = await getCustomerById(customerId);
    if (customer == null) return;

    await updateCustomer(customer.copyWith(
      totalSpent: totalSpent,
      unpaidBalance: unpaidBalance,
      lastOrderDate: lastOrderDate,
    ));
  }

  /// One-time sync for all customers (useful for migrations or fixing data)
  Future<int> syncAllCustomers() async {
    final all = await getAllCustomers();
    for (final customer in all) {
      await syncCustomerTotals(customer.id);
    }
    return all.length;
  }

  CustomerModel mapCustomer(Customer row) => CustomerModel(
        id: row.id,
        name: row.name,
        phone: row.phone,
        email: row.email,
        address: row.address,
        notes: row.notes,
        createdAt: row.createdAt,
        lastOrderDate: row.lastOrderDate,
        totalSpent: row.totalSpent,
        unpaidBalance: row.unpaidBalance,
      );

  String? _nullIfEmpty(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
