import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/services/form_memory_service.dart';
import '../../../core/widgets/app_ui_components.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _poundsController;
  String _selectedCategory = 'feed';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _descriptionController = TextEditingController(
      text: FormMemoryService.lastExpenseDescription,
    );
    _poundsController = TextEditingController();
    _selectedCategory = FormMemoryService.lastExpenseCategory;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _poundsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      FormMemoryService.lastExpenseCategory = _selectedCategory;
      FormMemoryService.lastExpenseDescription =
          _descriptionController.text.trim();

      await ref.read(expenseRepositoryProvider).recordExpense(
            category: _selectedCategory,
            amount: double.parse(_amountController.text.trim()),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            pounds: _selectedCategory == 'feed' &&
                    _poundsController.text.trim().isNotEmpty
                ? double.parse(_poundsController.text.trim())
                : null,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense recorded successfully!')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error recording expense: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: AppFormShell(
        title: 'Record An Expense',
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
                subtitle: 'Date: Today',
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'feed', child: Text('Feed')),
                    DropdownMenuItem(value: 'bedding', child: Text('Bedding')),
                    DropdownMenuItem(
                        value: 'medicine', child: Text('Medicine')),
                    DropdownMenuItem(value: 'general', child: Text('General')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedCategory = value ?? 'feed');
                  },
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
                                _descriptionController.text = 'Layer Crumble';
                              },
                            ),
                            ActionChip(
                              label: const Text('Starter Feed'),
                              onPressed: () {
                                _descriptionController.text = 'Starter Feed';
                              },
                            ),
                            ActionChip(
                              label: const Text('Scratch Grain'),
                              onPressed: () {
                                _descriptionController.text = 'Scratch Grain';
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _poundsController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Weight (lbs, optional)',
                          border: OutlineInputBorder(),
                        ),
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
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AppSubmitButton(
                isLoading: _isLoading,
                onPressed: _submit,
                label: 'Save Expense',
                loadingLabel: 'Saving...',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
