import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/widgets/app_ui_components.dart';

class AddMultipleChickensScreen extends ConsumerStatefulWidget {
  const AddMultipleChickensScreen({super.key});

  @override
  ConsumerState<AddMultipleChickensScreen> createState() =>
      _AddMultipleChickensScreenState();
}

class _AddMultipleChickensScreenState
    extends ConsumerState<AddMultipleChickensScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _quantityController;
  late TextEditingController _breedController;
  late TextEditingController _costPerBirdController;
  late TextEditingController _supplierController;
  late TextEditingController _notesController;

  String _selectedStatus = 'growing';
  DateTime _selectedHatchDate = DateTime.now();
  bool _isLoading = false;

  final List<String> _statuses = [
    'laying',
    'growing',
    'broody',
    'brooding',
    'retired',
  ];

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '1');
    _breedController = TextEditingController();
    _costPerBirdController = TextEditingController();
    _supplierController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _breedController.dispose();
    _costPerBirdController.dispose();
    _supplierController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectHatchDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedHatchDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedHatchDate = picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final quantity = int.parse(_quantityController.text.trim());
    final costPerBirdText = _costPerBirdController.text.trim();
    final costPerBird =
        costPerBirdText.isEmpty ? null : double.parse(costPerBirdText);

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(chickenRepositoryProvider);
      await repo.addMultipleChickens(
        quantity: quantity,
        breed: _breedController.text,
        status: _selectedStatus,
        hatchDate: _selectedHatchDate,
        notes: _notesController.text,
        costPerBird: costPerBird,
        supplier: _supplierController.text,
      );

      if (!mounted) return;
      final createdPurchase = costPerBird != null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            createdPurchase
                ? 'Added $quantity chickens and recorded a flock purchase.'
                : 'Added $quantity chickens to your flock.',
          ),
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding chickens: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Multiple Chickens'),
      ),
      body: AppFormShell(
        title: 'Batch Add Chickens',
        subtitle: 'Add a group of similar birds in one step',
        icon: Icons.groups,
        gradient: const [Color(0xFF8A5A2B), Color(0xFF6D451E)],
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppFormSection(
                title: 'Flock Details',
                child: Column(
                  children: [
                    TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantity *',
                        border: OutlineInputBorder(),
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
                      controller: _breedController,
                      decoration: const InputDecoration(
                        labelText: 'Breed *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'Breed is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Status / Age Group',
                        border: OutlineInputBorder(),
                      ),
                      items: _statuses
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(_statusLabel(status)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => _selectedStatus = value ?? 'growing');
                      },
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: _selectHatchDate,
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
                            Text(
                              'Acquisition / Hatch Date: ${_formatDate(_selectedHatchDate)}',
                            ),
                            const Icon(Icons.edit_calendar),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppFormSection(
                title: 'Purchase (Optional)',
                subtitle: 'If provided, creates a flock purchase automatically',
                child: Column(
                  children: [
                    TextFormField(
                      controller: _costPerBirdController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Cost Per Bird (optional)',
                        prefixText: '\$',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final raw = (value ?? '').trim();
                        if (raw.isEmpty) return null;
                        final parsed = double.tryParse(raw);
                        if (parsed == null || parsed <= 0) {
                          return 'Enter a valid amount greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _supplierController,
                      decoration: const InputDecoration(
                        labelText: 'Supplier (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              AppSubmitButton(
                isLoading: _isLoading,
                onPressed: _submit,
                label: 'Add Multiple Chickens',
                loadingLabel: 'Saving...',
                icon: Icons.groups,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'laying':
        return 'Laying';
      case 'growing':
        return 'Growing';
      case 'broody':
        return 'Broody';
      case 'brooding':
        return 'Brooding';
      case 'retired':
        return 'Retired';
      default:
        return status;
    }
  }
}
