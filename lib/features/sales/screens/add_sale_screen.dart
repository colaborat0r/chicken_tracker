import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/chicken_model.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/services/form_memory_service.dart';
import '../../../core/widgets/app_ui_components.dart';

class AddSaleScreen extends ConsumerStatefulWidget {
  final SaleModel? saleToEdit;
  const AddSaleScreen({super.key, this.saleToEdit});

  @override
  ConsumerState<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends ConsumerState<AddSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityController;
  late TextEditingController _amountController;
  late TextEditingController _customerController;
  String _selectedType = 'eggs';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  bool get _isEdit => widget.saleToEdit != null;

  @override
  void initState() {
    super.initState();
    final s = widget.saleToEdit;
    if (s != null) {
      _quantityController = TextEditingController(text: s.quantity.toString());
      _amountController = TextEditingController(text: s.amount.toStringAsFixed(2));
      _customerController = TextEditingController(text: s.customerName ?? '');
      _selectedType = s.type;
      _selectedDate = s.date;
    } else {
      _quantityController = TextEditingController();
      _amountController = TextEditingController();
      _customerController = TextEditingController(text: FormMemoryService.lastSaleCustomer);
      _selectedType = FormMemoryService.lastSaleType;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _amountController.dispose();
    _customerController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(salesRepositoryProvider);
      final customer = _customerController.text.trim().isEmpty ? null : _customerController.text.trim();
      if (_isEdit) {
        await repo.updateSale(SaleModel(
          id: widget.saleToEdit!.id,
          date: _selectedDate,
          type: _selectedType,
          quantity: int.parse(_quantityController.text.trim()),
          amount: double.parse(_amountController.text.trim()),
          customerName: customer,
        ));
      } else {
        FormMemoryService.lastSaleType = _selectedType;
        FormMemoryService.lastSaleCustomer = _customerController.text.trim();
        await repo.recordSale(
          type: _selectedType,
          quantity: int.parse(_quantityController.text.trim()),
          amount: double.parse(_amountController.text.trim()),
          customerName: customer,
          date: _selectedDate,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEdit ? 'Sale updated!' : 'Sale recorded successfully!')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Sale' : 'Add Sale'),
      ),
      body: AppFormShell(
        title: _isEdit ? 'Edit Sale' : 'Record A Sale',
        subtitle: 'Capture quantity, amount, and customer details',
        icon: Icons.receipt_long,
        gradient: const [Color(0xFF0E7A4F), Color(0xFF0A5F3E)],
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppFormSection(
                title: 'Basic Info',
                child: Column(
                  children: [
                    // Date picker
                    InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade500),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Date: ${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}'),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      decoration: const InputDecoration(labelText: 'Sale Type', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'eggs', child: Text('Eggs')),
                        DropdownMenuItem(value: 'chickens', child: Text('Chickens')),
                      ],
                      onChanged: (value) => setState(() => _selectedType = value ?? 'eggs'),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ActionChip(label: const Text('Farm Stand'), onPressed: () { _customerController.text = 'Farm Stand'; }),
                          ActionChip(label: const Text('Local Market'), onPressed: () { _customerController.text = 'Local Market'; }),
                          ActionChip(label: const Text('Neighbor'), onPressed: () { _customerController.text = 'Neighbor'; }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _customerController,
                      decoration: const InputDecoration(labelText: 'Customer (optional)', border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              AppFormSection(
                title: 'Quantity & Amount',
                child: Column(
                  children: [
                    TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: _selectedType == 'eggs' ? 'Quantity (dozens)' : 'Quantity',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final parsed = int.tryParse(value?.trim() ?? '');
                        if (parsed == null || parsed <= 0) return 'Quantity must be greater than 0';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$', border: OutlineInputBorder()),
                      validator: (value) {
                        final parsed = double.tryParse(value?.trim() ?? '');
                        if (parsed == null || parsed <= 0) return 'Amount must be greater than 0';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AppSubmitButton(
                isLoading: _isLoading,
                onPressed: _submit,
                label: _isEdit ? 'Update Sale' : 'Save Sale',
                loadingLabel: 'Saving...',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
