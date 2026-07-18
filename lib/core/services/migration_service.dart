import '../database/app_database.dart';
import '../repositories/order_repository.dart';
import '../repositories/customer_repository.dart';

class MigrationService {
  final AppDatabase database;
  final OrderRepository orderRepository;
  final CustomerRepository customerRepository;

  MigrationService({
    required this.database,
    required this.orderRepository,
    required this.customerRepository,
  });

  /// Migrates legacy Sales records to the new multi-line Orders structure.
  Future<int> migrateSalesToOrders() async {
    final sales = await database.getAllSales();
    if (sales.isEmpty) return 0;

    int migratedCount = 0;

    await database.transaction(() async {
      for (final sale in sales) {
        int? customerId;

        // Try to find or create customer
        if (sale.customerName != null && sale.customerName!.trim().isNotEmpty) {
          final customers = await customerRepository.getAllCustomers();
          final existing = customers.where(
            (c) => c.name.toLowerCase() == sale.customerName!.trim().toLowerCase()
          ).toList();

          if (existing.isNotEmpty) {
            customerId = existing.first.id;
          } else {
            customerId = await customerRepository.addCustomer(
              name: sale.customerName!.trim(),
              notes: 'Migrated from legacy sales',
            );
          }
        }

        // Create the order
        await orderRepository.createOrder(
          customerId: customerId,
          orderDate: sale.date,
          status: 'confirmed',
          isPaid: sale.isPaid,
          isDelivered: sale.isPaid, // Assume if it was a simple sale, it was delivered if paid
          notes: 'Migrated from legacy sale #${sale.id}',
          items: [
            OrderItemInput(
              type: sale.type,
              description: _getSaleDescription(sale),
              quantity: sale.quantity,
              unit: sale.unit,
              unitPrice: sale.quantity == 0 ? 0 : sale.amount / sale.quantity,
            ),
          ],
        );

        // Delete the legacy sale record
        await database.deleteSale(sale.id);
        migratedCount++;
      }
    });

    return migratedCount;
  }

  String _getSaleDescription(Sale sale) {
    if (sale.type == 'eggs') {
      return 'Eggs (${sale.unit})';
    } else if (sale.type == 'chickens') {
      return 'Chickens';
    }
    return 'Legacy Sale';
  }
}
