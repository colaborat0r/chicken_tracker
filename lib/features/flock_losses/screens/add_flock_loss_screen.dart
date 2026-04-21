import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/chicken_model.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/services/form_memory_service.dart';
import '../../../core/widgets/app_ui_components.dart';

class AddFlockLossScreen extends ConsumerStatefulWidget {
  final FlockLossModel? lossToEdit;
  const AddFlockLossScreen({super.key, this.lossToEdit});

  @override
  ConsumerState<AddFlockLossScreen> createState() => _AddFlockLossScreenState();
}

class _AddFlockLossScreenState extends ConsumerState<AddFlockLossScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityController;
  late TextEditingController _predatorController;
  String _selectedType = 'natural_causes';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  bool get _isEdit => widget.lossToEdit != null;

  @override
  void initState() {
    super.initState();
    final l = widget.lossToEdit;
    if (l != null) {
      _quantityController = TextEditingController(text: l.quantity.toString());
      _predatorController = TextEditingController(text: l.predatorSubtype ?? '');
      _selectedType = l.type;
      _selectedDate = l.date;
    } else {
      _quantityController = TextEditingController();
      _predatorController = TextEditingController(text: FormMemoryService.lastPredatorSubtype);
      _selectedType = FormMemoryService.lastLossType;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _predatorController.dispose();
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
      final predatorSubtype = _selectedType == 'predator' && _predatorController.text.trim().isNotEmpty
          ? _predatorController.text.trim()
          : null;
      final quantity = int.parse(_quantityController.text.trim());

      if (_isEdit) {
        await ref.read(flockLossRepositoryProvider).updateLoss(FlockLossModel(
          id: widget.lossToEdit!.id,
          date: _selectedDate,
          type: _selectedType,
          quantity: quantity,
          predatorSubtype: predatorSubtype,
        ));
      } else {
        FormMemoryService.lastLossType = _selectedType;
        FormMemoryService.lastPredatorSubtype = _predatorController.text.trim();
        await ref.read(flockLossRepositoryProvider).recordLoss(
          date: _selectedDate,
          type: _selectedType,
          quantity: quantity,
          predatorSubtype: predatorSubtype,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEdit ? 'Loss updated!' : 'Flock loss recorded successfully!')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Flock Loss' : 'Record Flock Loss')),
      body: AppFormShell(
        title: _isEdit ? 'Edit Flock Loss' : 'Record A Flock Loss',
        subtitle: 'Capture quantity and cause for better flock analysis',
        icon: Icons.warning_amber,
        gradient: const [Color(0xFFC62828), Color(0xFF8E1B1B)],
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isEdit) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.15),
                    border: Border.all(color: Colors.blue.shade700),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade800, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedType == 'sold'
                              ? 'The specified quantity of birds will be marked as sold.'
                              : 'The specified quantity of active birds will automatically be marked as deceased.',
                          style: TextStyle(color: Colors.blue.shade900, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              AppFormSection(
                title: 'Basic Info',
                child: Column(
                  children: [
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
                      decoration: const InputDecoration(labelText: 'Loss Type', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'natural_causes', child: Text('Natural Causes')),
                        DropdownMenuItem(value: 'illness', child: Text('Illness')),
                        DropdownMenuItem(value: 'predator', child: Text('Predator Attack')),
                        DropdownMenuItem(value: 'human_consumption', child: Text('Human Consumption')),
                        DropdownMenuItem(value: 'sold', child: Text('Sold')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (value) => setState(() => _selectedType = value ?? 'natural_causes'),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ActionChip(label: const Text('Natural'), onPressed: () => setState(() => _selectedType = 'natural_causes')),
                          ActionChip(label: const Text('Predator'), onPressed: () => setState(() => _selectedType = 'predator')),
                          ActionChip(label: const Text('Illness'), onPressed: () => setState(() => _selectedType = 'illness')),
                          ActionChip(label: const Text('Sold'), onPressed: () => setState(() => _selectedType = 'sold')),
                          ActionChip(label: const Text('Other'), onPressed: () => setState(() => _selectedType = 'other')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              AppFormSection(
                title: 'Quantity',
                child: TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
                  validator: (value) {
                    final parsed = int.tryParse(value?.trim() ?? '');
                    if (parsed == null || parsed <= 0) return 'Quantity must be greater than 0';
                    return null;
                  },
                ),
              ),
              if (_selectedType == 'predator') ...[
                const SizedBox(height: 18),
                AppFormSection(
                  title: 'Notes',
                  subtitle: 'Predator details help trend analysis',
                  child: TextFormField(
                    controller: _predatorController,
                    decoration: const InputDecoration(
                      labelText: 'Predator Type (optional)',
                      hintText: 'e.g., raccoon, hawk, fox',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              AppSubmitButton(
                isLoading: _isLoading,
                onPressed: _submit,
                label: _isEdit ? 'Update Loss' : 'Save Loss',
                loadingLabel: 'Saving...',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
