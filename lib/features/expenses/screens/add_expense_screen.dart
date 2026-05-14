import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/chicken_model.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/services/form_memory_service.dart';
import '../../../core/widgets/app_ui_components.dart';

const _builtInCategories = ['feed', 'bedding', 'medicine', 'general', 'other'];
const _customCategoriesKey = 'expense_custom_categories';

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
  List<String> _customCategories = [];

  bool get _isEdit => widget.expenseToEdit != null;

  List<String> get _allCategories => [
        ..._builtInCategories,
        ..._customCategories.where((c) => !_builtInCategories.contains(c)),
      ];

  @override
  void initState() {
    super.initState();
    final e = widget.expenseToEdit;
    if (e != null) {
      _amountController =
          TextEditingController(text: e.amount.toStringAsFixed(2));
      _descriptionController =
          TextEditingController(text: e.description ?? '');
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
    _loadCustomCategories();
  }

  Future<void> _loadCustomCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_customCategoriesKey) ?? [];
    if (mounted) {
      setState(() {
        _customCategories = saved;
        // If editing and category isn't in built-ins, ensure it's in custom list
        if (_isEdit &&
            !_builtInCategories.contains(_selectedCategory) &&
            !_customCategories.contains(_selectedCategory)) {
          _customCategories = [..._customCategories, _selectedCategory];
        }
      });
    }
  }

  Future<void> _saveCustomCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_customCategoriesKey, _customCategories);
  }

  Future<void> _addCustomCategory() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Category'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Category name',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (v) {
            if (v.trim().isNotEmpty) Navigator.pop(ctx, v.trim().toLowerCase());
          },
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final v = controller.text.trim().toLowerCase();
              if (v.isNotEmpty) Navigator.pop(ctx, v);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      final normalized = result.toLowerCase();
      if (!_allCategories.contains(normalized)) {
        setState(() {
          _customCategories = [..._customCategories, normalized];
          _selectedCategory = normalized;
        });
        await _saveCustomCategories();
      } else {
        setState(() => _selectedCategory = normalized);
      }
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
      final description = _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim();
      final pounds = _selectedCategory == 'feed' &&
              _poundsController.text.trim().isNotEmpty
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
        FormMemoryService.lastExpenseDescription =
            _descriptionController.text.trim();
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
        SnackBar(
            content: Text(_isEdit
                ? 'Expense updated!'
                : 'Expense recorded successfully!')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
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
                            Text(
                                'Date: ${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}'),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      key: ValueKey(_selectedCategory),
                      initialValue: _allCategories.contains(_selectedCategory)
                          ? _selectedCategory
                          : _allCategories.first,
                      decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder()),
                      items: [
                        ..._allCategories.map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat[0].toUpperCase() +
                                  cat.substring(1).toLowerCase()),
                            )),
                        const DropdownMenuItem(
                          value: '__add_custom__',
                          child: Row(
                            children: [
                              Icon(Icons.add, size: 18),
                              SizedBox(width: 6),
                              Text('Add custom…',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (value) async {
                        if (value == '__add_custom__') {
                          await _addCustomCategory();
                        } else if (value != null) {
                          setState(() => _selectedCategory = value);
                        }
                      },
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
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                          labelText: 'Amount',
                          prefixText: '\$',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        final parsed = double.tryParse(value?.trim() ?? '');
                        if (parsed == null || parsed <= 0) {
                          return 'Amount must be greater than 0';
                        }
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
                            ActionChip(
                                label: const Text('Layer Crumble'),
                                onPressed: () {
                                  _descriptionController.text =
                                      'Layer Crumble';
                                }),
                            ActionChip(
                                label: const Text('Starter Feed'),
                                onPressed: () {
                                  _descriptionController.text =
                                      'Starter Feed';
                                }),
                            ActionChip(
                                label: const Text('Scratch Grain'),
                                onPressed: () {
                                  _descriptionController.text =
                                      'Scratch Grain';
                                }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _poundsController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'Weight (lbs, optional)',
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) return null;
                          final parsed = double.tryParse(value!.trim());
                          if (parsed == null || parsed <= 0) {
                            return 'Weight must be greater than 0';
                          }
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
                  decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                      border: OutlineInputBorder()),
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
