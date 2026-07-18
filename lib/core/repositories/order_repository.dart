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
    bool isPaid = false,
    bool isDelivered = false,
    String? notes,
    required List<OrderItemInput> items,
  }) async {
    if (items.isEmpty) {
      throw ArgumentError('An order must have at least one line item.');
    }

    final orderId = await database.transaction(() async {
      final subtotal = items.fold(0.0, (sum, i) => sum + i.lineTotal);
      final now = DateTime.now();

      // Generate a simple invoice number
      final year = orderDate.year;
      final count = await (database.select(database.orders)
            ..where((o) => o.orderDate.year.equals(year)))
          .get()
          .then((list) => list.length + 1);
      final invoiceNumber = 'INV-$year-${count.toString().padLeft(4, '0')}';

      final newOrderId = await database.into(database.orders).insert(
            OrdersCompanion(
              customerId: Value(customerId),
              orderDate: Value(orderDate),
              deliveryDate: Value(deliveryDate),
              status: Value(status),
              isPaid: Value(isPaid),
              isDelivered: Value(isDelivered),
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
                orderId: Value(newOrderId),
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

      return newOrderId;
    });

    // Update customer totals after transaction completes to ensure data visibility
    if (customerId != null) {
      await customerRepository.syncCustomerTotals(customerId);
    }

    return orderId;
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    final order = await getOrderById(orderId);
    final customerId = order?.order.customerId;

    await (database.update(database.orders)
          ..where((o) => o.id.equals(orderId)))
        .write(OrdersCompanion(
      status: Value(newStatus),
      updatedAt: Value(DateTime.now()),
    ));

    if (customerId != null) {
      await customerRepository.syncCustomerTotals(customerId);
    }
  }

  Future<void> togglePaidStatus(int orderId) async {
    final orderDetails = await getOrderById(orderId);
    if (orderDetails == null) return;

    final newPaid = !orderDetails.order.isPaid;

    await (database.update(database.orders)
          ..where((o) => o.id.equals(orderId)))
        .write(OrdersCompanion(
      isPaid: Value(newPaid),
      updatedAt: Value(DateTime.now()),
    ));

    // If moving to paid and has a customer, update totals
    if (orderDetails.order.customerId != null) {
      await customerRepository.syncCustomerTotals(orderDetails.order.customerId!);
    }
  }

  Future<void> toggleDeliveredStatus(int orderId) async {
    final orderDetails = await getOrderById(orderId);
    if (orderDetails == null) return;

    final customerId = orderDetails.order.customerId;

    await (database.update(database.orders)
          ..where((o) => o.id.equals(orderId)))
        .write(OrdersCompanion(
      isDelivered: Value(!orderDetails.order.isDelivered),
      updatedAt: Value(DateTime.now()),
    ));

    if (customerId != null) {
      await customerRepository.syncCustomerTotals(customerId);
    }
  }

  Future<void> deleteOrder(int orderId) async {
    final order = await getOrderById(orderId);
    final customerId = order?.order.customerId;

    // OrderItems cascade automatically thanks to onDelete: KeyAction.cascade
    await (database.delete(database.orders)
          ..where((o) => o.id.equals(orderId)))
        .go();

    if (customerId != null) {
      await customerRepository.syncCustomerTotals(customerId);
    }
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

    if (orderRows.isEmpty) return [];

    // Optimization: Fetch all items for these orders in one query
    final orderIds = orderRows.map((o) => o.id).toList();
    final allItems = await (database.select(database.orderItems)
          ..where((i) => i.orderId.isIn(orderIds)))
        .get();

    // Group items by orderId
    final itemMap = <int, List<OrderItem>>{};
    for (final item in allItems) {
      itemMap.putIfAbsent(item.orderId, () => []).add(item);
    }

    // Optimization: Fetch all unique customers in one query
    final customerIds = orderRows.where((o) => o.customerId != null).map((o) => o.customerId!).toSet().toList();
    final customerMap = <int, CustomerModel>{};
    if (customerIds.isNotEmpty) {
      final customers = await (database.select(database.customers)
            ..where((c) => c.id.isIn(customerIds)))
          .get();
      for (final c in customers) {
        customerMap[c.id] = customerRepository.mapCustomer(c); // Use public repo mapping
      }
    }

    return orderRows.map((row) {
      return OrderWithDetails(
        order: _mapOrder(row),
        items: (itemMap[row.id] ?? []).map(_mapItem).toList(),
        customer: row.customerId != null ? customerMap[row.customerId] : null,
      );
    }).toList();
  }

  Stream<List<OrderWithDetails>> watchAllOrders() {
    // Watch orders table for changes
    return database.select(database.orders).watch().asyncMap((_) async {
      return getAllOrders();
    });
  }

  Future<List<OrderWithDetails>> getOrdersForCustomer(int customerId) async {
    final orderRows = await (database.select(database.orders)
          ..where((o) => o.customerId.equals(customerId))
          ..orderBy([
            (o) => OrderingTerm(expression: o.orderDate, mode: OrderingMode.desc)
          ]))
        .get();

    if (orderRows.isEmpty) return [];

    // Optimization: Fetch all items for these orders in one query
    final orderIds = orderRows.map((o) => o.id).toList();
    final allItems = await (database.select(database.orderItems)
          ..where((i) => i.orderId.isIn(orderIds)))
        .get();

    final itemMap = <int, List<OrderItem>>{};
    for (final item in allItems) {
      itemMap.putIfAbsent(item.orderId, () => []).add(item);
    }

    CustomerModel? customer = await customerRepository.getCustomerById(customerId);

    return orderRows.map((row) {
      return OrderWithDetails(
        order: _mapOrder(row),
        items: (itemMap[row.id] ?? []).map(_mapItem).toList(),
        customer: customer,
      );
    }).toList();
  }

  Stream<List<OrderWithDetails>> watchOrdersForCustomer(int customerId) {
    return database.select(database.orders).watch().asyncMap((_) async {
      return getOrdersForCustomer(customerId);
    });
  }

  OrderModel _mapOrder(Order row) => OrderModel(
        id: row.id,
        customerId: row.customerId,
        orderDate: row.orderDate,
        deliveryDate: row.deliveryDate,
        status: row.status,
        isPaid: row.isPaid,
        isDelivered: row.isDelivered,
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
