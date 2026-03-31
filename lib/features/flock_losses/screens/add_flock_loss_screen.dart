import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/app_database.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/services/form_memory_service.dart';
import '../../../core/widgets/app_ui_components.dart';

class AddFlockLossScreen extends ConsumerStatefulWidget {
  const AddFlockLossScreen({super.key});

  @override
  ConsumerState<AddFlockLossScreen> createState() => _AddFlockLossScreenState();
}

class _AddFlockLossScreenState extends ConsumerState<AddFlockLossScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityController;
  late TextEditingController _predatorController;

  String _selectedType = 'natural_causes';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _predatorController = TextEditingController(
      text: FormMemoryService.lastPredatorSubtype,
    );
    _selectedType = FormMemoryService.lastLossType;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _predatorController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      FormMemoryService.lastLossType = _selectedType;
      FormMemoryService.lastPredatorSubtype = _predatorController.text.trim();

      final db = ref.read(databaseProvider);
      await db.into(db.flockLosses).insert(
            FlockLossesCompanion(
              date: Value(DateTime.now()),
              type: Value(_selectedType),
              quantity: Value(int.parse(_quantityController.text.trim())),
              predatorSubtype: Value(
                _selectedType == 'predator' &&
                        _predatorController.text.trim().isNotEmpty
                    ? _predatorController.text.trim()
                    : null,
              ),
            ),
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Flock loss recorded successfully!')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error recording loss: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Flock Loss'),
      ),
      body: AppFormShell(
        title: 'Record A Flock Loss',
        subtitle: 'Capture quantity and cause for better flock analysis',
        icon: Icons.warning_amber,
        gradient: const [Color(0xFFC62828), Color(0xFF8E1B1B)],
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
                        labelText: 'Loss Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'natural_causes',
                          child: Text('Natural Causes'),
                        ),
                        DropdownMenuItem(
                          value: 'predator',
                          child: Text('Predator Attack'),
                        ),
                        DropdownMenuItem(
                          value: 'human_consumption',
                          child: Text('Human Consumption'),
                        ),
                        DropdownMenuItem(
                          value: 'sold',
                          child: Text('Sold'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(
                            () => _selectedType = value ?? 'natural_causes');
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
                            label: const Text('Natural'),
                            onPressed: () {
                              setState(() => _selectedType = 'natural_causes');
                            },
                          ),
                          ActionChip(
                            label: const Text('Predator'),
                            onPressed: () {
                              setState(() => _selectedType = 'predator');
                            },
                          ),
                          ActionChip(
                            label: const Text('Sold'),
                            onPressed: () {
                              setState(() => _selectedType = 'sold');
                            },
                          ),
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
                label: 'Save Loss',
                loadingLabel: 'Saving...',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
