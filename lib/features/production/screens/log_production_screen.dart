import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/chicken_model.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/widgets/app_ui_components.dart';

class LogProductionScreen extends ConsumerStatefulWidget {
  final DailyProductionModel? logToEdit;
  const LogProductionScreen({super.key, this.logToEdit});

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
  late DateTime _selectedDate;
  bool _isLoading = false;

  bool get _isEdit => widget.logToEdit != null;

  @override
  void initState() {
    super.initState();
    final l = widget.logToEdit;
    if (l != null) {
      _layingHensController = TextEditingController(text: l.layingHens.toString());
      _brownController = TextEditingController(text: l.eggsBrown.toString());
      _coloredController = TextEditingController(text: l.eggsColored.toString());
      _whiteController = TextEditingController(text: l.eggsWhite.toString());
      _notesController = TextEditingController(text: l.notes ?? '');
    } else {
      _layingHensController = TextEditingController();
      _brownController = TextEditingController(text: '0');
      _coloredController = TextEditingController(text: '0');
      _whiteController = TextEditingController(text: '0');
      _notesController = TextEditingController();
      _selectedDate = DateTime.now();
    }

    if (_isEdit) {
      _selectedDate = widget.logToEdit!.date;
    }
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
       if (_isEdit) {
         await repo.updateLog(DailyProductionModel(
           id: widget.logToEdit!.id,
           date: _selectedDate,
           layingHens: int.parse(_layingHensController.text),
           eggsBrown: int.parse(_brownController.text),
           eggsColored: int.parse(_coloredController.text),
           eggsWhite: int.parse(_whiteController.text),
           notes: _notesController.text.isEmpty ? null : _notesController.text,
         ));
       } else {
         await repo.logDailyProduction(
           date: _selectedDate,
           layingHens: int.parse(_layingHensController.text),
           eggsBrown: int.parse(_brownController.text),
           eggsColored: int.parse(_coloredController.text),
           eggsWhite: int.parse(_whiteController.text),
           notes: _notesController.text.isEmpty ? null : _notesController.text,
         );
       }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEdit ? '📊 Production updated!' : '📊 Production logged successfully!')),
      );

      unawaited(ref.refresh(todayProductionProvider.future));
      unawaited(ref.refresh(allDailyLogsProvider.future));
      unawaited(ref.refresh(weeklyEggTotalProvider.future));

      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) context.pop();
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
        title: Text(_isEdit ? 'Edit Production Log' : 'Log Egg Production'),
      ),
      body: AppFormShell(
        title: 'Log Daily Production',
        subtitle: 'Capture eggs by color and monitor per-hen output',
        icon: Icons.egg,
        gradient: const [Color(0xFF2E7D32), Color(0xFF1E5C24)],
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppFormSection(
                title: 'Basic Info',
                subtitle: 'Date: ${_selectedDate.toString().split(' ')[0]}',
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Log Date'),
                      subtitle: Text(_selectedDate.toString().split(' ')[0]),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => _selectedDate = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
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
                  ],
                ),
              ),
              const SizedBox(height: 18),
              AppFormSection(
                title: 'Quantity & Amount',
                subtitle: 'Egg counts by shell color',
                child: Column(
                  children: [
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
                  ],
                ),
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
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
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
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _eggsPerHen >= 0.8
                                      ? Colors.green
                                      : Colors.orange,
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
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _eggsPerHen >= 0.8
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              AppFormSection(
                title: 'Notes',
                child: TextFormField(
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
              ),
              const SizedBox(height: 24),

              // Submit button
              AppSubmitButton(
                isLoading: _isLoading,
                onPressed: _submitForm,
                label: 'Log Production',
                loadingLabel: 'Logging...',
                icon: Icons.check,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
