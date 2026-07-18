import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/providers/farm_name_provider.dart';
import '../../../core/widgets/app_ui_components.dart';
import '../../../core/services/pdf_export_service.dart';
import '../../../config/router.dart';
import '../../../core/models/order_model.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  bool _isGeneratingPdf = false;

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(allOrdersProvider).whenData(
      (list) => list.where((o) => o.order.id == widget.orderId).firstOrNull,
    );

    return orderAsync.when(
      data: (orderDetails) {
        if (orderDetails == null) {
          return const Scaffold(body: Center(child: Text('Order not found')));
        }

        final order = orderDetails.order;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          appBar: AppBar(
            title: Text(order.invoiceNumber ?? 'Order #${order.id}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.push(Routes.createOrder, extra: order.id),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDelete(context, order.id),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, order, orderDetails.customerDisplayName, isDark),
                const SizedBox(height: 12),
                _buildStatusFlags(context, order),
                const SizedBox(height: 24),
                _buildCustomerSection(context, orderDetails),
                const SizedBox(height: 24),
                _buildItemsTable(context, orderDetails.items),
                const SizedBox(height: 20),
                _buildTotalsSection(context, order),
                if (order.notes != null && order.notes!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const AppSectionHeader(title: 'Notes', subtitle: ''),
                  const SizedBox(height: 8),
                  Text(order.notes!, style: const TextStyle(fontStyle: FontStyle.italic)),
                ],
                const SizedBox(height: 32),
                _buildQuickActions(context, order),
                const SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _isGeneratingPdf ? null : () => _generateAndSharePdf(orderDetails),
            icon: _isGeneratingPdf 
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.picture_as_pdf),
            label: Text(_isGeneratingPdf ? 'Generating...' : 'Share Invoice PDF'),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }

  Widget _buildHeader(BuildContext context, OrderModel order, String customerName, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('STATUS', style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 4),
                  _buildStatusBadge(order.status),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('DATE', style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, yyyy').format(order.orderDate),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (order.deliveryDate != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DELIVERY DATE', style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM d, yyyy').format(order.deliveryDate!),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('TOTAL', style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 4),
                  Text(
                    '\$${order.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection(BuildContext context, OrderWithDetails orderDetails) {
    final customer = orderDetails.customer;
    return InkWell(
      onTap: customer != null 
        ? () => context.push(Routes.customerDetail.replaceFirst(':id', customer.id.toString()))
        : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: Icon(Icons.person, color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bill To', style: Theme.of(context).textTheme.labelSmall),
                  Text(
                    orderDetails.customerDisplayName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  if (customer?.phone != null) Text(customer!.phone!, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            if (customer != null) const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsTable(BuildContext context, List<OrderItemModel> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(title: 'Items', subtitle: ''),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(11), topRight: Radius.circular(11)),
                ),
                child: const Row(
                  children: [
                    Expanded(flex: 3, child: Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    Expanded(child: Text('Qty', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    Expanded(flex: 2, child: Text('Price', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    Expanded(flex: 2, child: Text('Total', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  ],
                ),
              ),
              ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.description, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          if (item.notes != null) Text(item.notes!, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Expanded(child: Text(item.quantity.toStringAsFixed(0), textAlign: TextAlign.center, style: const TextStyle(fontSize: 13))),
                    Expanded(flex: 2, child: Text('\$${item.unitPrice.toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 13))),
                    Expanded(flex: 2, child: Text('\$${item.lineTotal.toStringAsFixed(2)}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalsSection(BuildContext context, OrderModel order) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 200,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal', style: TextStyle(color: Colors.grey)),
                Text('\$${order.subtotal.toStringAsFixed(2)}'),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Divider()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('GRAND TOTAL', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(title: 'Update Order', subtitle: 'Manage status and payment'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _ActionBtn(
              label: order.isPaid ? 'Mark Unpaid' : 'Mark Paid',
              color: order.isPaid ? Colors.amber : Colors.green,
              icon: Icons.payments,
              onTap: () => _togglePaid(order.id),
            ),
            _ActionBtn(
              label: order.isDelivered ? 'Pending Delivery' : 'Mark Delivered',
              color: order.isDelivered ? Colors.orange : Colors.blue,
              icon: Icons.local_shipping,
              onTap: () => _toggleDelivered(order.id),
            ),
            if (order.status != 'confirmed')
              _ActionBtn(
                label: 'Confirm Order',
                color: Colors.deepPurple,
                icon: Icons.check,
                onTap: () => _updateStatus(order.id, 'confirmed'),
              ),
            if (order.status != 'cancelled')
              _ActionBtn(
                label: 'Cancel Order',
                color: Colors.red,
                icon: Icons.cancel,
                onTap: () => _updateStatus(order.id, 'cancelled'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusFlags(BuildContext context, OrderModel order) {
    return Row(
      children: [
        Expanded(
          child: _StatusFlagCard(
            label: 'Payment',
            status: order.isPaid ? 'PAID' : 'UNPAID',
            icon: Icons.payments,
            color: order.isPaid ? Colors.green : Colors.amber,
            onTap: () => _togglePaid(order.id),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatusFlagCard(
            label: 'Delivery',
            status: order.isDelivered ? 'DELIVERED' : 'PENDING',
            icon: Icons.local_shipping,
            color: order.isDelivered ? Colors.blue : Colors.orange,
            onTap: () => _toggleDelivered(order.id),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    if (status == 'paid' || status == 'delivered') {
      return const SizedBox.shrink();
    }

    Color color;
    switch (status) {
      case 'confirmed': color = Colors.orange; break;
      case 'cancelled': color = Colors.red; break;
      case 'draft': color = Colors.blueGrey; break;
      default: color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _updateStatus(int orderId, String status) async {
    await ref.read(orderRepositoryProvider).updateOrderStatus(orderId, status);
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order status updated to $status')),
      );
    }
  }

  Future<void> _togglePaid(int orderId) async {
    await ref.read(orderRepositoryProvider).togglePaidStatus(orderId);
  }

  Future<void> _toggleDelivered(int orderId) async {
    await ref.read(orderRepositoryProvider).toggleDeliveredStatus(orderId);
  }

  Future<void> _confirmDelete(BuildContext context, int orderId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Order'),
        content: const Text('Are you sure you want to delete this order? This will also delete all line items. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(orderRepositoryProvider).deleteOrder(orderId);
      if (context.mounted) context.pop();
    }
  }

  Future<void> _generateAndSharePdf(OrderWithDetails orderDetails) async {
    setState(() => _isGeneratingPdf = true);
    try {
      final farmName = ref.read(farmNameProvider);
      final file = await PdfExportService.generateInvoicePdf(
        orderDetails: orderDetails,
        farmName: farmName,
      );

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Invoice for ${orderDetails.customerDisplayName} - ${orderDetails.order.invoiceNumber ?? orderDetails.order.id}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating PDF: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionBtn({required this.label, required this.color, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _StatusFlagCard extends StatelessWidget {
  final String label;
  final String status;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StatusFlagCard({
    required this.label,
    required this.status,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(label.toUpperCase(), style: TextStyle(fontSize: 10, color: isDark ? Colors.grey[400] : Colors.grey[700], fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 6),
                Text(status, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
