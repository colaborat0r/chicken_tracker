// lib/core/repositories/order_repository.dart
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/customer_model.dart';
import '../models/order_model.dart';
import 'customer_repository.dart';

class OrderRepository {
  final AppDatabase database;
  final CustomerRepository customerRepository;

  OrderRepository(this.database, this.customerRepository);

  /// Create a full order with multiple line items in one transaction.
  Future<int> createOrder({
    int? customerId,
    required DateTime orderDate,
    DateTime? deliveryDate,
    String status = 'confirmed',
    String? notes,
    required List<OrderItemInput> items,
  }) async {
    if (items.isEmpty) {
      throw ArgumentError('An order must have at least one line item.');
    }

    return database.transaction(() async {
      final subtotal = items.fold(0.0, (sum, i) => sum + i.lineTotal);
      final now = DateTime.now();

      // Generate a simple invoice number
      final year = orderDate.year;
      final count = await (database.select(database.orders)
            ..where((o) => o.orderDate.year.equals(year)))
          .get()
          .then((list) => list.length + 1);
      final invoiceNumber = 'INV-$year-${count.toString().padLeft(4, '0')}';

      final orderId = await database.into(database.orders).insert(
            OrdersCompanion(
              customerId: Value(customerId),
              orderDate: Value(orderDate),
              deliveryDate: Value(deliveryDate),
              status: Value(status),
              invoiceNumber: Value(invoiceNumber),
              notes: Value(_nullIfEmpty(notes)),
              subtotal: Value(subtotal),
              totalAmount: Value(subtotal),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      for (final item in items) {
        await database.into(database.orderItems).insert(
              OrderItemsCompanion(
                orderId: Value(orderId),
                type: Value(item.type),
                description: Value(item.description),
                quantity: Value(item.quantity),
                unit: Value(item.unit),
                unitPrice: Value(item.unitPrice),
                lineTotal: Value(item.lineTotal),
                notes: Value(_nullIfEmpty(item.notes)),
              ),
            );
      }

      // Update customer totals if linked and status indicates money received
      if (customerId != null &&
          (status == 'paid' || status == 'delivered')) {
        await customerRepository.recordOrderForCustomer(
          customerId: customerId,
          orderDate: orderDate,
          amount: subtotal,
        );
      }

      return orderId;
    });
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    final order = await getOrderById(orderId);
    if (order == null) return;

    await (database.update(database.orders)
          ..where((o) => o.id.equals(orderId)))
        .write(OrdersCompanion(
      status: Value(newStatus),
      updatedAt: Value(DateTime.now()),
    ));

    // If moving to paid/delivered and has a customer, update totals
    if (order.order.customerId != null &&
        (newStatus == 'paid' || newStatus == 'delivered') &&
        !(order.order.status == 'paid' || order.order.status == 'delivered')) {
      await customerRepository.recordOrderForCustomer(
        customerId: order.order.customerId!,
        orderDate: order.order.orderDate,
        amount: order.order.totalAmount,
      );
    }
  }

  Future<void> deleteOrder(int orderId) async {
    // OrderItems cascade automatically thanks to onDelete: KeyAction.cascade
    await (database.delete(database.orders)
          ..where((o) => o.id.equals(orderId)))
        .go();
  }

  Future<OrderWithDetails?> getOrderById(int id) async {
    final orderRow = await (database.select(database.orders)
          ..where((o) => o.id.equals(id)))
        .getSingleOrNull();
    if (orderRow == null) return null;

    final itemRows = await (database.select(database.orderItems)
          ..where((i) => i.orderId.equals(id)))
        .get();

    CustomerModel? customer;
    if (orderRow.customerId != null) {
      customer = await customerRepository.getCustomerById(orderRow.customerId!);
    }

    return OrderWithDetails(
      order: _mapOrder(orderRow),
      items: itemRows.map(_mapItem).toList(),
      customer: customer,
    );
  }

  Future<List<OrderWithDetails>> getAllOrders() async {
    final orderRows = await (database.select(database.orders)
          ..orderBy([
            (o) => OrderingTerm(expression: o.orderDate, mode: OrderingMode.desc)
          ]))
        .get();

    final result = <OrderWithDetails>[];
    for (final row in orderRows) {
      final details = await getOrderById(row.id);
      if (details != null) result.add(details);
    }
    return result;
  }

  Stream<List<OrderWithDetails>> watchAllOrders() {
    // Simple approach: re-fetch on any change to orders or items
    return database.select(database.orders).watch().asyncMap((_) async {
      return getAllOrders();
    });
  }

  Future<List<OrderWithDetails>> getOrdersForCustomer(int customerId) async {
    final all = await getAllOrders();
    return all.where((o) => o.order.customerId == customerId).toList();
  }

  OrderModel _mapOrder(Order row) => OrderModel(
        id: row.id,
        customerId: row.customerId,
        orderDate: row.orderDate,
        deliveryDate: row.deliveryDate,
        status: row.status,
        invoiceNumber: row.invoiceNumber,
        notes: row.notes,
        subtotal: row.subtotal,
        totalAmount: row.totalAmount,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );

  OrderItemModel _mapItem(OrderItem row) => OrderItemModel(
        id: row.id,
        orderId: row.orderId,
        type: row.type,
        description: row.description,
        quantity: row.quantity,
        unit: row.unit,
        unitPrice: row.unitPrice,
        lineTotal: row.lineTotal,
        notes: row.notes,
      );

  String? _nullIfEmpty(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}

/// Lightweight input class used when creating an order
class OrderItemInput {
  final String type;
  final String description;
  final double quantity;
  final String unit;
  final double unitPrice;
  final String? notes;

  OrderItemInput({
    required this.type,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    this.notes,
  });

  double get lineTotal => quantity * unitPrice;
}
