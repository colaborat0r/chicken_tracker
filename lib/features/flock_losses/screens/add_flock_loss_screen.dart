import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/app_database.dart';
import '../../../core/providers/database_providers.dart';

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
    _predatorController = TextEditingController();
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
      final db = ref.read(databaseProvider);
      await db.into(db.flockLosses).insert(
            FlockLossesCompanion(
              date: Value(DateTime.now()),
              type: Value(_selectedType),
              quantity: Value(int.parse(_quantityController.text.trim())),
              predatorSubtype: Value(
                _selectedType == 'predator' && _predatorController.text.trim().isNotEmpty
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  setState(() => _selectedType = value ?? 'natural_causes');
                },
              ),
              const SizedBox(height: 16),
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
                    return 'Enter a quantity greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_selectedType == 'predator') ...[
                TextFormField(
                  controller: _predatorController,
                  decoration: const InputDecoration(
                    labelText: 'Predator Type (optional)',
                    hintText: 'e.g., raccoon, hawk, fox',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isLoading ? 'Saving...' : 'Save Loss'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
