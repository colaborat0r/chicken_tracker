import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/database_providers.dart';
import '../../../config/router.dart';

class OrderListView extends ConsumerStatefulWidget {
  const OrderListView({super.key});

  @override
  ConsumerState<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends ConsumerState<OrderListView> {
  final _searchController = TextEditingController();
  
  // Advanced Filter Sets
  final Set<String> _selectedStatuses = {};
  final Set<bool> _selectedPaymentStates = {};
  final Set<bool> _selectedDeliveryStates = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _hasActiveFilters => 
      _selectedStatuses.isNotEmpty || 
      _selectedPaymentStates.isNotEmpty || 
      _selectedDeliveryStates.isNotEmpty;

  void _clearFilters() {
    setState(() {
      _selectedStatuses.clear();
      _selectedPaymentStates.clear();
      _selectedDeliveryStates.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(allOrdersProvider);

    return ordersAsync.when(
      data: (orders) {
        final query = _searchController.text.toLowerCase();
        
        final filtered = orders.where((o) {
          final matchesQuery = (o.order.invoiceNumber?.toLowerCase().contains(query) ?? false) ||
              (o.customer?.name.toLowerCase().contains(query) ?? false) ||
              o.order.id.toString().contains(query);
          
          final matchesStatus = _selectedStatuses.isEmpty || _selectedStatuses.contains(o.order.status);
          final matchesPayment = _selectedPaymentStates.isEmpty || _selectedPaymentStates.contains(o.order.isPaid);
          final matchesDelivery = _selectedDeliveryStates.isEmpty || _selectedDeliveryStates.contains(o.order.isDelivered);
          
          return matchesQuery && matchesStatus && matchesPayment && matchesDelivery;
        }).toList();

        final filteredTotal = filtered.fold<double>(0, (sum, o) => sum + o.order.totalAmount);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: 'Search orders, invoices...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Stack(
                        children: [
                          IconButton.filledTonal(
                            onPressed: _showFilterSheet,
                            icon: const Icon(Icons.filter_list),
                            tooltip: 'Filter Orders',
                          ),
                          if (_hasActiveFilters)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Text('', style: TextStyle(fontSize: 4)),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (_hasActiveFilters)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: _clearFilters,
                        icon: const Icon(Icons.clear_all, size: 16),
                        label: const Text('Clear Filters', style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                      ),
                    ),
                ],
              ),
            ),
            
            // Summary Bar
            _buildSummaryCard(filtered.length, filteredTotal),

            if (filtered.isEmpty)
              Expanded(child: _buildEmptyState(query.isNotEmpty || _hasActiveFilters))
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final orderWithDetails = filtered[index];
                    final order = orderWithDetails.order;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        onTap: () => context.push(
                          Routes.orderDetail.replaceFirst(':id', order.id.toString()),
                        ),
                        title: Row(
                          children: [
                            Text(
                              order.invoiceNumber ?? 'Order #${order.id}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text(
                              '\$${order.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(orderWithDetails.customerDisplayName),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(DateFormat('MMM d, yyyy').format(order.orderDate)),
                                const Spacer(),
                                _buildStatusBadge(order.status),
                                const SizedBox(width: 4),
                                _buildFlagBadge(order.isPaid ? 'PAID' : 'UNPAID', order.isPaid ? Colors.green : Colors.amber),
                                const SizedBox(width: 4),
                                _buildFlagBadge(order.isDelivered ? 'DELIVERED' : 'PENDING', order.isDelivered ? Colors.blue : Colors.orange),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading orders: $e')),
    );
  }

  Widget _buildSummaryCard(int count, double total) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MATCHING ORDERS', style: Theme.of(context).textTheme.labelSmall),
                Text('$count found', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('TOTAL VALUE', style: Theme.of(context).textTheme.labelSmall),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w900, 
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filter Orders', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  
                  _buildFilterGroup(
                    'Order Status',
                    ['confirmed', 'cancelled', 'draft'],
                    (val) => _selectedStatuses.contains(val),
                    (val) => setState(() {
                      setSheetState(() {
                        if (_selectedStatuses.contains(val)) {
                          _selectedStatuses.remove(val);
                        } else {
                          _selectedStatuses.add(val);
                        }
                      });
                    }),
                  ),
                  const Divider(),
                  _buildFilterGroup<bool>(
                    'Payment Status',
                    [true, false],
                    (val) => _selectedPaymentStates.contains(val),
                    (val) => setState(() {
                      setSheetState(() {
                        if (_selectedPaymentStates.contains(val)) {
                          _selectedPaymentStates.remove(val);
                        } else {
                          _selectedPaymentStates.add(val);
                        }
                      });
                    }),
                    labelMapper: (val) => val ? 'Paid' : 'Unpaid',
                  ),
                  const Divider(),
                  _buildFilterGroup<bool>(
                    'Delivery Status',
                    [true, false],
                    (val) => _selectedDeliveryStates.contains(val),
                    (val) => setState(() {
                      setSheetState(() {
                        if (_selectedDeliveryStates.contains(val)) {
                          _selectedDeliveryStates.remove(val);
                        } else {
                          _selectedDeliveryStates.add(val);
                        }
                      });
                    }),
                    labelMapper: (val) => val ? 'Delivered' : 'Pending',
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Show Results'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterGroup<T>(
    String title,
    List<T> options,
    bool Function(T) isSelected,
    void Function(T) onToggle, {
    String Function(T)? labelMapper,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(title.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        Wrap(
          spacing: 12,
          children: options.map((opt) {
            final label = labelMapper?.call(opt) ?? opt.toString().toUpperCase();
            final active = isSelected(opt);
            return FilterChip(
              label: Text(label, style: TextStyle(fontSize: 12, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
              selected: active,
              onSelected: (_) => onToggle(opt),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    if (status == 'paid' || status == 'delivered') {
      return const SizedBox.shrink();
    }

    Color color;
    switch (status) {
      case 'confirmed':
        color = Colors.orange;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      case 'draft':
        color = Colors.blueGrey;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(right: 4),
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

  Widget _buildFlagBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget _buildEmptyState(bool isFiltered) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFiltered ? Icons.search_off : Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            isFiltered ? 'No orders match your filters' : 'No orders found',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          if (!isFiltered) ...[
            const SizedBox(height: 8),
            const Text(
              'Start selling by creating your first order.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.push(Routes.createOrder),
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('New Order'),
            ),
          ],
        ],
      ),
    );
  }
}
