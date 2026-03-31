import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/services/form_memory_service.dart';
import '../../../core/widgets/app_ui_components.dart';

class AddSaleScreen extends ConsumerStatefulWidget {
  const AddSaleScreen({super.key});

  @override
  ConsumerState<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends ConsumerState<AddSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityController;
  late TextEditingController _amountController;
  late TextEditingController _customerController;
  String _selectedType = 'eggs';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _amountController = TextEditingController();
    _customerController = TextEditingController(
      text: FormMemoryService.lastSaleCustomer,
    );
    _selectedType = FormMemoryService.lastSaleType;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _amountController.dispose();
    _customerController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      FormMemoryService.lastSaleType = _selectedType;
      FormMemoryService.lastSaleCustomer = _customerController.text.trim();

      await ref.read(salesRepositoryProvider).recordSale(
            type: _selectedType,
            quantity: int.parse(_quantityController.text.trim()),
            amount: double.parse(_amountController.text.trim()),
            customerName: _customerController.text.trim().isEmpty
                ? null
                : _customerController.text.trim(),
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sale recorded successfully!')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error recording sale: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sale'),
      ),
      body: AppFormShell(
        title: 'Record A Sale',
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
                subtitle: 'Date: Today',
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Sale Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'eggs', child: Text('Eggs')),
                        DropdownMenuItem(
                            value: 'chickens', child: Text('Chickens')),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedType = value ?? 'eggs');
                      },
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ActionChip(
                            label: const Text('Farm Stand'),
                            onPressed: () {
                              _customerController.text = 'Farm Stand';
                            },
                          ),
                          ActionChip(
                            label: const Text('Local Market'),
                            onPressed: () {
                              _customerController.text = 'Local Market';
                            },
                          ),
                          ActionChip(
                            label: const Text('Neighbor'),
                            onPressed: () {
                              _customerController.text = 'Neighbor';
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _customerController,
                      decoration: const InputDecoration(
                        labelText: 'Customer (optional)',
                        border: OutlineInputBorder(),
                      ),
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
                        labelText: _selectedType == 'eggs'
                            ? 'Quantity (dozens)'
                            : 'Quantity',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final parsed = int.tryParse(value?.trim() ?? '');
                        if (parsed == null || parsed <= 0) {
                          return 'Quantity must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        prefixText: '\$',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final parsed = double.tryParse(value?.trim() ?? '');
                        if (parsed == null || parsed <= 0) {
                          return 'Amount must be greater than 0';
                        }
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
                label: 'Save Sale',
                loadingLabel: 'Saving...',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
