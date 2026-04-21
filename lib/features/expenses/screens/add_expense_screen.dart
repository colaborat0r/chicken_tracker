import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/chicken_model.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/services/form_memory_service.dart';
import '../../../core/widgets/app_ui_components.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final ExpenseModel? expenseToEdit;
  const AddExpenseScreen({super.key, this.expenseToEdit});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _poundsController;
  String _selectedCategory = 'feed';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  bool get _isEdit => widget.expenseToEdit != null;

  @override
  void initState() {
    super.initState();
    final e = widget.expenseToEdit;
    if (e != null) {
      _amountController = TextEditingController(
          text: e.amount.toStringAsFixed(2));
      _descriptionController = TextEditingController(
          text: e.description ?? '');
      _poundsController = TextEditingController(
          text: e.pounds != null ? e.pounds.toString() : '');
      _selectedCategory = e.category;
      _selectedDate = e.date;
    } else {
      _amountController = TextEditingController();
      _descriptionController = TextEditingController(
          text: FormMemoryService.lastExpenseDescription);
      _poundsController = TextEditingController();
      _selectedCategory = FormMemoryService.lastExpenseCategory;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _poundsController.dispose();
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
      final repo = ref.read(expenseRepositoryProvider);
      final description = _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim();
      final pounds = _selectedCategory == 'feed' && _poundsController.text.trim().isNotEmpty
          ? double.parse(_poundsController.text.trim())
          : null;
      if (_isEdit) {
        await repo.updateExpense(ExpenseModel(
          id: widget.expenseToEdit!.id,
          date: _selectedDate,
          category: _selectedCategory,
          amount: double.parse(_amountController.text.trim()),
          description: description,
          pounds: pounds,
        ));
      } else {
        FormMemoryService.lastExpenseCategory = _selectedCategory;
        FormMemoryService.lastExpenseDescription = _descriptionController.text.trim();
        await repo.recordExpense(
          category: _selectedCategory,
          amount: double.parse(_amountController.text.trim()),
          description: description,
          pounds: pounds,
          date: _selectedDate,
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEdit ? 'Expense updated!' : 'Expense recorded successfully!')),
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
      appBar: AppBar(title: Text(_isEdit ? 'Edit Expense' : 'Add Expense')),
      body: AppFormShell(
        title: _isEdit ? 'Edit Expense' : 'Record An Expense',
        subtitle: 'Track costs by category and optional notes',
        icon: Icons.account_balance_wallet,
        gradient: const [Color(0xFFC5392A), Color(0xFF992C22)],
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      initialValue: _selectedCategory,
                      decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'feed', child: Text('Feed')),
                        DropdownMenuItem(value: 'bedding', child: Text('Bedding')),
                        DropdownMenuItem(value: 'medicine', child: Text('Medicine')),
                        DropdownMenuItem(value: 'general', child: Text('General')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (value) => setState(() => _selectedCategory = value ?? 'feed'),
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
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$', border: OutlineInputBorder()),
                      validator: (value) {
                        final parsed = double.tryParse(value?.trim() ?? '');
                        if (parsed == null || parsed <= 0) return 'Amount must be greater than 0';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    if (_selectedCategory == 'feed') ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ActionChip(label: const Text('Layer Crumble'), onPressed: () { _descriptionController.text = 'Layer Crumble'; }),
                            ActionChip(label: const Text('Starter Feed'), onPressed: () { _descriptionController.text = 'Starter Feed'; }),
                            ActionChip(label: const Text('Scratch Grain'), onPressed: () { _descriptionController.text = 'Scratch Grain'; }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _poundsController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Weight (lbs, optional)', border: OutlineInputBorder()),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) return null;
                          final parsed = double.tryParse(value!.trim());
                          if (parsed == null || parsed <= 0) return 'Weight must be greater than 0';
                          return null;
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
              AppFormSection(
                title: 'Notes',
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Description (optional)', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(height: 24),
              AppSubmitButton(
                isLoading: _isLoading,
                onPressed: _submit,
                label: _isEdit ? 'Update Expense' : 'Save Expense',
                loadingLabel: 'Saving...',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
