import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/widgets/app_ui_components.dart';
import '../../../config/router.dart';
import '../../../core/models/customer_model.dart';

class CustomerDetailScreen extends ConsumerWidget {
  final int customerId;

  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerAsync = ref.watch(allCustomersProvider).whenData(
      (list) => list.where((c) => c.id == customerId).firstOrNull,
    );

    return customerAsync.when(
      data: (customer) {
        if (customer == null) {
          return const Scaffold(body: Center(child: Text('Customer not found')));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(customer.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.push(Routes.addCustomer, extra: customer.id),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(context, customer),
                const SizedBox(height: 24),
                const AppSectionHeader(
                  title: 'Order History',
                  subtitle: 'Recent transactions for this customer',
                ),
                const SizedBox(height: 12),
                _CustomerOrdersList(customerId: customerId),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.push(Routes.createOrder, extra: customer.id),
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('New Order'),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }

  Widget _buildSummaryCard(BuildContext context, CustomerModel customer) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF2C3E50), Color(0xFF000000)]
              : const [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  customer.name[0].toUpperCase(),
                  style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                    ),
                    if (customer.phone != null)
                      Text(customer.phone!, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                    if (customer.email != null)
                      Text(customer.email!, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
          if (customer.address != null) ...[
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text(customer.address!, style: const TextStyle(fontSize: 13))),
              ],
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Consumer(
                builder: (context, ref, _) {
                  final ordersAsync = ref.watch(customerOrdersProvider(customer.id));
                  return ordersAsync.maybeWhen(
                    data: (orders) {
                      final lifetime = orders
                          .where((o) => o.order.status != 'cancelled')
                          .fold<double>(0, (sum, o) => sum + o.order.totalAmount);
                      final unpaid = orders
                          .where((o) => o.order.status != 'cancelled' && !o.order.isPaid)
                          .fold<double>(0, (sum, o) => sum + o.order.totalAmount);
                      
                      return Expanded(
                        child: Row(
                          children: [
                            _buildStatItem('Lifetime Total', '\$${lifetime.toStringAsFixed(2)}', isDark),
                            _buildStatItem('Unpaid Balance', '\$${unpaid.toStringAsFixed(2)}', isDark),
                          ],
                        ),
                      );
                    },
                    orElse: () => Expanded(
                      child: Row(
                        children: [
                          _buildStatItem('Lifetime Total', '\$${customer.totalSpent.toStringAsFixed(2)}', isDark),
                          _buildStatItem('Unpaid Balance', '\$${customer.unpaidBalance.toStringAsFixed(2)}', isDark),
                        ],
                      ),
                    ),
                  );
                },
              ),
              _buildStatItem(
                'Last Order',
                customer.lastOrderDate != null
                    ? DateFormat('MMM d, yyyy').format(customer.lastOrderDate!)
                    : 'None',
                isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, bool isDark) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.black54)),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _CustomerOrdersList extends ConsumerWidget {
  final int customerId;

  const _CustomerOrdersList({required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(customerOrdersProvider(customerId));

    return ordersAsync.when(
      data: (orders) {
        if (orders.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text('No orders yet for this customer.', style: TextStyle(color: Colors.grey)),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final orderDetails = orders[index];
            final order = orderDetails.order;
            
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                onTap: () => context.push(
                  Routes.orderDetail.replaceFirst(':id', order.id.toString()),
                ),
                title: Text(
                  'Order ${order.invoiceNumber ?? "#${order.id}"}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(DateFormat('MMM d, yyyy').format(order.orderDate)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${order.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    _buildStatusBadge(order.status),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 8),
              Text('Error loading history: $e', style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'paid':
        color = Colors.green;
        break;
      case 'delivered':
        color = Colors.blue;
        break;
      case 'confirmed':
        color = Colors.orange;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }
}
