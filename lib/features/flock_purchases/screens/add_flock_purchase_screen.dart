import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/app_database.dart';
import '../../../core/providers/database_providers.dart';

class AddFlockPurchaseScreen extends ConsumerStatefulWidget {
  const AddFlockPurchaseScreen({super.key});

  @override
  ConsumerState<AddFlockPurchaseScreen> createState() =>
      _AddFlockPurchaseScreenState();
}

class _AddFlockPurchaseScreenState extends ConsumerState<AddFlockPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityController;
  late TextEditingController _costController;
  late TextEditingController _supplierController;
  late TextEditingController _hatchedCountController;

  String _selectedType = 'live_chicks';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _costController = TextEditingController();
    _supplierController = TextEditingController();
    _hatchedCountController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _costController.dispose();
    _supplierController.dispose();
    _hatchedCountController.dispose();
    super.dispose();
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

    setState(() => _isLoading = true);

    try {
      final db = ref.read(databaseProvider);
      await db.into(db.flockPurchases).insert(
            FlockPurchasesCompanion(
              date: Value(DateTime.now()),
              type: Value(_selectedType),
              quantity: Value(quantity),
              cost: Value(double.parse(_costController.text.trim())),
              supplier: Value(
                _supplierController.text.trim().isEmpty
                    ? null
                    : _supplierController.text.trim(),
              ),
              hatchedCount: Value(hatchedCount),
            ),
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Flock purchase recorded successfully!')),
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
              TextFormField(
                controller: _costController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Total Cost',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final parsed = double.tryParse(value?.trim() ?? '');
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a cost greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _supplierController,
                decoration: const InputDecoration(
                  labelText: 'Supplier (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedType == 'hatching_eggs') ...[
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
                  label: Text(_isLoading ? 'Saving...' : 'Save Purchase'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
