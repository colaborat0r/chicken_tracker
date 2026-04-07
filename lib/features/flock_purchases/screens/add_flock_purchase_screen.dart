import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/services/form_memory_service.dart';
import '../../../core/widgets/app_ui_components.dart';

class AddFlockPurchaseScreen extends ConsumerStatefulWidget {
  const AddFlockPurchaseScreen({super.key});

  @override
  ConsumerState<AddFlockPurchaseScreen> createState() =>
      _AddFlockPurchaseScreenState();
}

class _AddFlockPurchaseScreenState
    extends ConsumerState<AddFlockPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityController;
  late TextEditingController _costController;
  late TextEditingController _supplierController;
  late TextEditingController _hatchedCountController;
  late TextEditingController _breedController;
  late TextEditingController _notesController;

  String _selectedType = 'live_chicks';
  String _selectedStatus = 'growing';
  DateTime _selectedDate = DateTime.now();
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
    _quantityController = TextEditingController();
    _costController = TextEditingController();
    _supplierController = TextEditingController(
      text: FormMemoryService.lastPurchaseSupplier,
    );
    _hatchedCountController = TextEditingController();
    _breedController = TextEditingController();
    _notesController = TextEditingController();
    _selectedType = FormMemoryService.lastPurchaseType;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _costController.dispose();
    _supplierController.dispose();
    _hatchedCountController.dispose();
    _breedController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectPurchaseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
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
    final hatchedCount = _selectedType == 'hatching_eggs' &&
            _hatchedCountController.text.trim().isNotEmpty
        ? int.parse(_hatchedCountController.text.trim())
        : null;

    if (hatchedCount != null && hatchedCount > quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hatched count cannot exceed quantity.')),
      );
      return;
    }

    if (_selectedType == 'live_chicks' &&
        _breedController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Breed is required for live chick purchases.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      FormMemoryService.lastPurchaseType = _selectedType;
      FormMemoryService.lastPurchaseSupplier = _supplierController.text.trim();

      final repo = ref.read(chickenRepositoryProvider);
      await repo.recordFlockPurchase(
        date: _selectedDate,
        type: _selectedType,
        quantity: quantity,
        cost: double.parse(_costController.text.trim()),
        supplier: _supplierController.text.trim(),
        hatchedCount: hatchedCount,
        breed: _selectedType == 'live_chicks' ? _breedController.text : null,
        status: _selectedType == 'live_chicks' ? _selectedStatus : null,
        hatchDate: _selectedType == 'live_chicks' ? _selectedHatchDate : null,
        notes: _selectedType == 'live_chicks' ? _notesController.text : null,
      );

      if (!mounted) return;
      final addedBirds = _selectedType == 'live_chicks' ? quantity : 0;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            addedBirds > 0
                ? 'Purchase saved and $addedBirds chickens added to flock.'
                : 'Flock purchase recorded successfully!',
          ),
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error recording purchase: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Flock Purchase'),
      ),
      body: AppFormShell(
        title: 'Record A Flock Purchase',
        subtitle: 'Track acquisitions, supplier, and hatch performance',
        icon: Icons.shopping_bag,
        gradient: const [Color(0xFF0D6E77), Color(0xFF09545B)],
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppFormSection(
                title: 'Basic Info',
                subtitle: 'Purchase details',
                child: Column(
                  children: [
                    InkWell(
                      onTap: _selectPurchaseDate,
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
                                'Purchase Date: ${_formatDate(_selectedDate)}'),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Purchase Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'live_chicks',
                          child: Text('Live Chicks'),
                        ),
                        DropdownMenuItem(
                          value: 'hatching_eggs',
                          child: Text('Hatching Eggs'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedType = value ?? 'live_chicks');
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
                    if (_selectedType == 'live_chicks') ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _breedController,
                        decoration: const InputDecoration(
                          labelText: 'Breed *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (_selectedType != 'live_chicks') return null;
                          if ((value ?? '').trim().isEmpty) {
                            return 'Breed is required for live chicks';
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
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Notes (optional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
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
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
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
                      controller: _costController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Total Cost',
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
                    if (_selectedType == 'hatching_eggs') ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _hatchedCountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Hatched Count (optional)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) return null;
                          final parsed = int.tryParse(value!.trim());
                          if (parsed == null || parsed < 0) {
                            return 'Enter a valid non-negative number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppSubmitButton(
                isLoading: _isLoading,
                onPressed: _submit,
                label: 'Save Purchase',
                loadingLabel: 'Saving...',
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
