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
    return rows.map(_map).toList();
  }

  Future<CustomerModel?> getCustomerById(int id) async {
    final row = await (database.select(database.customers)
          ..where((c) => c.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  Stream<List<CustomerModel>> watchAllCustomers() {
    return (database.select(database.customers)
          ..orderBy([(c) => OrderingTerm(expression: c.name)]))
        .watch()
        .map((rows) => rows.map(_map).toList());
  }

  /// Update lastOrderDate + totalSpent after an order is paid/delivered
  Future<void> recordOrderForCustomer({
    required int customerId,
    required DateTime orderDate,
    required double amount,
  }) async {
    final existing = await getCustomerById(customerId);
    if (existing == null) return;

    await updateCustomer(existing.copyWith(
      lastOrderDate: orderDate,
      totalSpent: existing.totalSpent + amount,
    ));
  }

  CustomerModel _map(Customer row) => CustomerModel(
        id: row.id,
        name: row.name,
        phone: row.phone,
        email: row.email,
        address: row.address,
        notes: row.notes,
        createdAt: row.createdAt,
        lastOrderDate: row.lastOrderDate,
        totalSpent: row.totalSpent,
      );

  String? _nullIfEmpty(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
