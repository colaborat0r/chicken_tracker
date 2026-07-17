// lib/core/models/customer_model.dart
// Simple CRM customer model for Chicken Tracker

class CustomerModel {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime? lastOrderDate;
  final double totalSpent;

  CustomerModel({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.notes,
    required this.createdAt,
    this.lastOrderDate,
    this.totalSpent = 0.0,
  });

  CustomerModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? notes,
    DateTime? createdAt,
    DateTime? lastOrderDate,
    double? totalSpent,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      lastOrderDate: lastOrderDate ?? this.lastOrderDate,
      totalSpent: totalSpent ?? this.totalSpent,
    );
  }

  /// Display name with phone if available
  String get displayName {
    if (phone != null && phone!.isNotEmpty) {
      return '$name ($phone)';
    }
    return name;
  }

  /// Short contact line for lists
  String get contactLine {
    final parts = <String>[];
    if (phone != null && phone!.isNotEmpty) parts.add(phone!);
    if (email != null && email!.isNotEmpty) parts.add(email!);
    return parts.join(' • ');
  }
}
