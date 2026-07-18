import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/widgets/app_ui_components.dart';
import '../../../core/models/customer_model.dart';

class AddCustomerScreen extends ConsumerStatefulWidget {
  final int? customerId;

  const AddCustomerScreen({super.key, this.customerId});

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  
  bool _isLoading = false;
  CustomerModel? _existingCustomer;

  @override
  void initState() {
    super.initState();
    if (widget.customerId != null) {
      _loadCustomer();
    }
  }

  Future<void> _loadCustomer() async {
    setState(() => _isLoading = true);
    final customer = await ref.read(customerRepositoryProvider).getCustomerById(widget.customerId!);
    if (customer != null && mounted) {
      setState(() {
        _existingCustomer = customer;
        _nameController.text = customer.name;
        _phoneController.text = customer.phone ?? '';
        _emailController.text = customer.email ?? '';
        _addressController.text = customer.address ?? '';
        _notesController.text = customer.notes ?? '';
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      if (_existingCustomer != null) {
        await ref.read(customerRepositoryProvider).updateCustomer(
          _existingCustomer!.copyWith(
            name: _nameController.text,
            phone: _phoneController.text,
            email: _emailController.text,
            address: _addressController.text,
            notes: _notesController.text,
          ),
        );
      } else {
        await ref.read(customerRepositoryProvider).addCustomer(
          name: _nameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          address: _addressController.text,
          notes: _notesController.text,
        );
      }
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving customer: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_existingCustomer != null ? 'Edit Customer' : 'Add Customer'),
      ),
      body: AppFormShell(
        title: _existingCustomer != null ? 'Update Contact' : 'New Customer',
        subtitle: 'Manage customer details for professional invoices.',
        icon: Icons.person_add,
        gradient: const [Color(0xFF1565C0), Color(0xFF0D47A1)],
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name*',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Mailing Address',
                  prefixIcon: Icon(Icons.location_on),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Internal Notes',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              AppSubmitButton(
                isLoading: _isLoading,
                onPressed: _save,
                label: _existingCustomer != null ? 'Update Customer' : 'Save Customer',
                loadingLabel: 'Saving...',
                icon: Icons.save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
