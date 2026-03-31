import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/widgets/app_ui_components.dart';

class AddChickenScreen extends ConsumerStatefulWidget {
  const AddChickenScreen({super.key});

  @override
  ConsumerState<AddChickenScreen> createState() => _AddChickenScreenState();
}

class _AddChickenScreenState extends ConsumerState<AddChickenScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _breedController;
  late TextEditingController _notesController;
  String? _selectedEggColor;
  DateTime? _selectedHatchDate;
  String _selectedStatus = 'laying';
  bool _isLoading = false;

  final List<String> _eggColors = ['Brown', 'Colored', 'White', 'Other'];
  final List<String> _statuses = [
    'laying',
    'growing',
    'broody',
    'brooding',
    'retired'
  ];

  @override
  void initState() {
    super.initState();
    _breedController = TextEditingController();
    _notesController = TextEditingController();
    _selectedHatchDate =
        DateTime.now().subtract(const Duration(days: 150)); // ~5 months old
  }

  @override
  void dispose() {
    _breedController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectHatchDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedHatchDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedHatchDate = picked);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedHatchDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a hatch date')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(chickenRepositoryProvider);
      await repo.addChicken(
        breed: _breedController.text,
        eggColor: _selectedEggColor,
        hatchDate: _selectedHatchDate!,
        status: _selectedStatus,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🐔 Chicken added successfully!')),
      );

      // Delay to show the snackbar before popping
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding chicken: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Chicken'),
      ),
      body: AppFormShell(
        title: 'Add A Chicken',
        subtitle: 'Capture breed, age, status, and notes',
        icon: Icons.pets,
        gradient: const [Color(0xFF8A5A2B), Color(0xFF6D451E)],
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breed field
              TextFormField(
                controller: _breedController,
                decoration: InputDecoration(
                  label: const Text('Breed *'),
                  hintText: 'e.g., Rhode Island Red, Leghorn',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a breed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Egg Color dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedEggColor,
                decoration: InputDecoration(
                  label: const Text('Egg Color'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _eggColors.map((color) {
                  return DropdownMenuItem(
                    value: color.toLowerCase() == 'other'
                        ? null
                        : color.toLowerCase(),
                    child: Text(color),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedEggColor = value),
              ),
              const SizedBox(height: 16),

              // Hatch Date picker
              InkWell(
                onTap: _selectedHatchDate == null ? _selectHatchDate : null,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hatch Date *',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedHatchDate != null
                                ? '${_selectedHatchDate!.month}/${_selectedHatchDate!.day}/${_selectedHatchDate!.year}'
                                : 'Select date',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_calendar),
                        onPressed: _selectHatchDate,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (_selectedHatchDate != null)
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    'Age: ${_getAgeString(_selectedHatchDate!)}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.blue,
                        ),
                  ),
                ),
              const SizedBox(height: 16),

              // Status dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: InputDecoration(
                  label: const Text('Status'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _statuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: _getStatusLabel(status),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedStatus = value ?? 'laying'),
              ),
              const SizedBox(height: 16),

              // Notes field
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  label: const Text('Notes'),
                  hintText: 'Any additional notes about this chicken',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Submit button
              AppSubmitButton(
                isLoading: _isLoading,
                onPressed: _submitForm,
                label: 'Add Chicken',
                loadingLabel: 'Adding...',
                icon: Icons.add,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getAgeString(DateTime hatchDate) {
    final now = DateTime.now();
    final age = now.difference(hatchDate).inDays;
    if (age < 30) return '$age days old';
    if (age < 365) return '${(age / 30).toStringAsFixed(1)} months old';
    return '${(age / 365).toStringAsFixed(1)} years old';
  }

  Widget _getStatusLabel(String status) {
    final statusMap = {
      'laying': '🥚 Laying',
      'growing': '👶 Growing',
      'broody': '🥚 Broody',
      'brooding': '🐣 Brooding',
      'retired': '😴 Retired',
    };
    return Text(statusMap[status] ?? status);
  }
}
