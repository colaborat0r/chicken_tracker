import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/providers/database_providers.dart';

class LogProductionScreen extends ConsumerStatefulWidget {
  const LogProductionScreen({super.key});

  @override
  ConsumerState<LogProductionScreen> createState() => _LogProductionScreenState();
}

class _LogProductionScreenState extends ConsumerState<LogProductionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _layingHensController;
  late TextEditingController _brownController;
  late TextEditingController _coloredController;
  late TextEditingController _whiteController;
  late TextEditingController _notesController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _layingHensController = TextEditingController();
    _brownController = TextEditingController(text: '0');
    _coloredController = TextEditingController(text: '0');
    _whiteController = TextEditingController(text: '0');
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _layingHensController.dispose();
    _brownController.dispose();
    _coloredController.dispose();
    _whiteController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int get _totalEggs {
    final brown = int.tryParse(_brownController.text) ?? 0;
    final colored = int.tryParse(_coloredController.text) ?? 0;
    final white = int.tryParse(_whiteController.text) ?? 0;
    return brown + colored + white;
  }

  double get _eggsPerHen {
    final hens = int.tryParse(_layingHensController.text) ?? 0;
    if (hens == 0) return 0;
    return _totalEggs / hens;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(productionRepositoryProvider);
      await repo.logDailyProduction(
        layingHens: int.parse(_layingHensController.text),
        eggsBrown: int.parse(_brownController.text),
        eggsColored: int.parse(_coloredController.text),
        eggsWhite: int.parse(_whiteController.text),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('📊 Production logged successfully!')),
      );
      
      // Invalidate the providers to refresh dashboard
      unawaited(ref.refresh(todayProductionProvider.future));
      unawaited(ref.refresh(allDailyLogsProvider.future));
      unawaited(ref.refresh(weeklyEggTotalProvider.future));
      
      // Delay to show the snackbar before popping
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging production: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Egg Production'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Laying Hens field
                TextFormField(
                  controller: _layingHensController,
                  decoration: InputDecoration(
                    label: const Text('Laying Hens *'),
                    hintText: 'Number of hens laying eggs today',
                    prefixIcon: const Icon(Icons.pets),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of laying hens';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Eggs by color section
                Text(
                  'Eggs Collected',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Brown eggs
                TextFormField(
                  controller: _brownController,
                  decoration: InputDecoration(
                    label: const Text('Brown Eggs'),
                    prefixIcon: const Icon(Icons.egg, color: Colors.brown),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Colored eggs
                TextFormField(
                  controller: _coloredController,
                  decoration: InputDecoration(
                    label: const Text('Colored Eggs'),
                    prefixIcon: const Icon(Icons.egg, color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // White eggs
                TextFormField(
                  controller: _whiteController,
                  decoration: InputDecoration(
                    label: const Text('White Eggs'),
                    prefixIcon: const Icon(Icons.egg, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Stats card
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Total Eggs',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$_totalEggs',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Eggs/Hen',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _eggsPerHen.toStringAsFixed(2),
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _eggsPerHen >= 0.8 ? Colors.green : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Production %',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(_eggsPerHen * 100).toStringAsFixed(0)}%',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _eggsPerHen >= 0.8 ? Colors.green : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Notes field
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    label: const Text('Notes'),
                    hintText: 'Any notes about today\'s production',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _submitForm,
                    icon: _isLoading ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ) : const Icon(Icons.check),
                    label: Text(_isLoading ? 'Logging...' : 'Log Production'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
