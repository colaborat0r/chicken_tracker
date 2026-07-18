// lib/core/models/order_model.dart
// Multi-line order models for Chicken Tracker CRM

import 'customer_model.dart';

/// Single line item on an order
class OrderItemModel {
  final int id;
  final int orderId;
  final String type; // eggs, chickens, other
  final String description;
  final double quantity;
  final String unit; // dozens, crates, individual, birds, units
  final double unitPrice;
  final double lineTotal;
  final String? notes;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.type,
    required this.description,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.lineTotal,
    this.notes,
  });

  OrderItemModel copyWith({
    int? id,
    int? orderId,
    String? type,
    String? description,
    double? quantity,
    String? unit,
    double? unitPrice,
    double? lineTotal,
    String? notes,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      type: type ?? this.type,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      unitPrice: unitPrice ?? this.unitPrice,
      lineTotal: lineTotal ?? this.lineTotal,
      notes: notes ?? this.notes,
    );
  }

  /// Human readable quantity, e.g. "3 dozens (36 eggs)"
  String get quantityDescription {
    if (type == 'eggs' && unit != 'individual') {
      final eggs = unit == 'dozens'
          ? quantity * 12
          : unit == 'crates'
              ? quantity * 30
              : quantity;
      return '$quantity $unit (${eggs.toInt()} eggs)';
    }
    return '$quantity $unit';
  }
}

/// Order header
class OrderModel {
  final int id;
  final int? customerId;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String status; // draft, confirmed, paid, delivered, cancelled
  final bool isPaid;
  final bool isDelivered;
  final String? invoiceNumber;
  final String? notes;
  final double subtotal;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    this.customerId,
    required this.orderDate,
    this.deliveryDate,
    required this.status,
    required this.isPaid,
    required this.isDelivered,
    this.invoiceNumber,
    this.notes,
    required this.subtotal,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  OrderModel copyWith({
    int? id,
    int? customerId,
    DateTime? orderDate,
    DateTime? deliveryDate,
    String? status,
    bool? isPaid,
    bool? isDelivered,
    String? invoiceNumber,
    String? notes,
    double? subtotal,
    double? totalAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      status: status ?? this.status,
      isPaid: isPaid ?? this.isPaid,
      isDelivered: isDelivered ?? this.isDelivered,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      notes: notes ?? this.notes,
      subtotal: subtotal ?? this.subtotal,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isCancelled => status == 'cancelled';

  String get statusLabel {
    switch (status) {
      case 'draft':
        return 'Draft';
      case 'confirmed':
        return 'Confirmed';
      case 'paid':
        return 'Paid';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}

/// Convenience class used by UI and PDF generation
class OrderWithDetails {
  final OrderModel order;
  final List<OrderItemModel> items;
  final CustomerModel? customer;

  OrderWithDetails({
    required this.order,
    required this.items,
    this.customer,
  });

  double get calculatedTotal =>
      items.fold(0.0, (sum, item) => sum + item.lineTotal);

  String get customerDisplayName =>
      customer?.name ?? 'Walk-in / Cash Customer';
}
