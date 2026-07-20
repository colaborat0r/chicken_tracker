import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/repositories/order_repository.dart';
import '../../../core/widgets/app_ui_components.dart';
import '../../../config/router.dart';
import '../../../core/models/customer_model.dart';
import '../../../core/models/order_model.dart';

class CreateOrderScreen extends ConsumerStatefulWidget {
  final int? orderId;

  const CreateOrderScreen({super.key, this.orderId});

  @override
  ConsumerState<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends ConsumerState<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _orderDate = DateTime.now();
  DateTime? _deliveryDate;
  int? _selectedCustomerId;
  final List<OrderItemInput> _items = [];
  final _notesController = TextEditingController();
  String _status = 'confirmed';
  bool _isLoading = false;
  
  // For Editing
  OrderWithDetails? _editingOrder;

  @override
  void initState() {
    super.initState();
    if (widget.orderId != null) {
      _loadOrder();
    }
  }

  Future<void> _loadOrder() async {
    setState(() => _isLoading = true);
    final order = await ref.read(orderRepositoryProvider).getOrderById(widget.orderId!);
    if (order != null && mounted) {
      setState(() {
        _editingOrder = order;
        _orderDate = order.order.orderDate;
        _deliveryDate = order.order.deliveryDate;
        _selectedCustomerId = order.order.customerId;
        _notesController.text = order.order.notes ?? '';
        _status = order.order.status;
        _items.addAll(order.items.map((i) => OrderItemInput(
          type: i.type,
          description: i.description,
          quantity: i.quantity,
          unit: i.unit,
          unitPrice: i.unitPrice,
          notes: i.notes,
        )));
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _total => _items.fold(0.0, (sum, i) => sum + i.lineTotal);

  Future<void> _save() async {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add at least one item to the order.')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_editingOrder != null) {
        await ref.read(orderRepositoryProvider).updateOrder(
              orderId: _editingOrder!.order.id,
              customerId: _selectedCustomerId,
              orderDate: _orderDate,
              deliveryDate: _deliveryDate,
              status: _status,
              notes: _notesController.text,
              items: _items,
            );
      } else {
        await ref.read(orderRepositoryProvider).createOrder(
          customerId: _selectedCustomerId,
          orderDate: _orderDate,
          deliveryDate: _deliveryDate,
          status: _status,
          notes: _notesController.text,
          items: _items,
        );
      }

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving order: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(allCustomersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_editingOrder != null ? 'Edit Order' : 'New Order'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMetaSection(context, customersAsync),
              const SizedBox(height: 24),
              _buildStatusSection(context),
              const SizedBox(height: 24),
              _buildItemsSection(context),
              const SizedBox(height: 24),
              const AppSectionHeader(title: 'Overall Notes', subtitle: 'Appear at the bottom of the invoice'),
              const SizedBox(height: 10),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'e.g. Leave at side door, etc.'),
              ),
              const SizedBox(height: 32),
              AppSubmitButton(
                isLoading: _isLoading,
                onPressed: _save,
                label: _editingOrder != null ? 'Update Order' : 'Complete Order',
                loadingLabel: 'Processing...',
                icon: Icons.check_circle,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(
          title: 'Order Status',
          subtitle: 'Mark as draft to work on it later',
        ),
        const SizedBox(height: 10),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(
              value: 'draft',
              label: Text('Draft'),
              icon: Icon(Icons.edit_note),
            ),
            ButtonSegment(
              value: 'confirmed',
              label: Text('Confirmed'),
              icon: Icon(Icons.check_circle_outline),
            ),
          ],
          selected: {_status},
          onSelectionChanged: (selection) {
            setState(() => _status = selection.first);
          },
        ),
      ],
    );
  }

  Widget _buildMetaSection(BuildContext context, AsyncValue<List<CustomerModel>> customersAsync) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _DatePicker(
                    label: 'Order Date',
                    date: _orderDate,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _orderDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setState(() => _orderDate = picked);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DatePicker(
                    label: 'Delivery Date (Optional)',
                    date: _deliveryDate,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _deliveryDate ?? DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setState(() => _deliveryDate = picked);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            customersAsync.when(
              data: (customers) => _CustomerPicker(
                selectedId: _selectedCustomerId,
                customers: customers,
                onChanged: (id) => setState(() => _selectedCustomerId = id),
                onAddNew: () => context.push(Routes.addCustomer),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error loading customers: $e'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppSectionHeader(title: 'Order Items', subtitle: 'Add multiple products to this invoice'),
            Text(
              '\$${_total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_items.isEmpty)
          _buildNoItemsPlaceHolder()
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(item.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${item.quantity} ${item.unit} @ \$${item.unitPrice.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('\$${item.lineTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900)),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () => setState(() => _items.removeAt(index)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showAddItemSheet(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Product or Service'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoItemsPlaceHolder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2), style: BorderStyle.solid),
      ),
      child: const Column(
        children: [
          Icon(Icons.shopping_basket_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text('No items added yet', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showAddItemSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddItemBottomSheet(
        onAdd: (item) {
          setState(() => _items.add(item));
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _DatePicker extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DatePicker({required this.label, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(date != null ? DateFormat('MMM d, yyyy').format(date!) : 'Select Date'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomerPicker extends StatelessWidget {
  final int? selectedId;
  final List<CustomerModel> customers;
  final ValueChanged<int?> onChanged;
  final VoidCallback onAddNew;

  const _CustomerPicker({required this.selectedId, required this.customers, required this.onChanged, required this.onAddNew});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('CUSTOMER', style: Theme.of(context).textTheme.labelSmall),
            TextButton.icon(
              onPressed: onAddNew,
              icon: const Icon(Icons.person_add, size: 14),
              label: const Text('New Customer', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
            ),
          ],
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<int>(
          initialValue: selectedId,
          isExpanded: true,
          decoration: const InputDecoration(
            hintText: 'Select a customer (or leave for walk-in)',
            prefixIcon: Icon(Icons.person_outline),
            border: OutlineInputBorder(),
            isDense: true,
          ),
          items: [
            const DropdownMenuItem<int>(value: null, child: Text('Walk-in / Cash Customer')),
            ...customers.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _AddItemBottomSheet extends StatefulWidget {
  final Function(OrderItemInput) onAdd;

  const _AddItemBottomSheet({required this.onAdd});

  @override
  State<_AddItemBottomSheet> createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends State<_AddItemBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'eggs';
  final _descriptionController = TextEditingController(text: 'Farm Fresh Eggs');
  final _quantityController = TextEditingController(text: '1');
  String _unit = 'dozens';
  final _priceController = TextEditingController(text: '5.00');
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Add Line Item', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Type', isDense: true),
              items: const [
                DropdownMenuItem(value: 'eggs', child: Text('Eggs')),
                DropdownMenuItem(value: 'chickens', child: Text('Chickens')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _type = val;
                    if (val == 'eggs') {
                      _descriptionController.text = 'Farm Fresh Eggs';
                      _unit = 'dozens';
                    } else if (val == 'chickens') {
                      _descriptionController.text = 'Live Chicken';
                      _unit = 'birds';
                      _priceController.text = '15.00';
                    }
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description*', isDense: true),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity', isDense: true),
                    keyboardType: TextInputType.number,
                    validator: (v) => double.tryParse(v ?? '') == null ? 'Invalid' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _unit,
                    decoration: const InputDecoration(labelText: 'Unit', isDense: true),
                    items: const [
                      DropdownMenuItem(value: 'dozens', child: Text('Dozens')),
                      DropdownMenuItem(value: 'crates', child: Text('Crates')),
                      DropdownMenuItem(value: 'individual', child: Text('Individual')),
                      DropdownMenuItem(value: 'birds', child: Text('Birds')),
                      DropdownMenuItem(value: 'units', child: Text('Units')),
                    ],
                    onChanged: (v) => setState(() => _unit = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Unit Price (\$)', isDense: true, prefixText: '\$'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => double.tryParse(v ?? '') == null ? 'Invalid' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onAdd(OrderItemInput(
                      type: _type,
                      description: _descriptionController.text,
                      quantity: double.parse(_quantityController.text),
                      unit: _unit,
                      unitPrice: double.parse(_priceController.text),
                      notes: _notesController.text,
                    ));
                  }
                },
                child: const Text('Add to Order'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
