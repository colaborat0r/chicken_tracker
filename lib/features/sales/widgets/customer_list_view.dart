import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/database_providers.dart';
import '../../../config/router.dart';

class CustomerListView extends ConsumerStatefulWidget {
  const CustomerListView({super.key});

  @override
  ConsumerState<CustomerListView> createState() => _CustomerListViewState();
}

class _CustomerListViewState extends ConsumerState<CustomerListView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(allCustomersProvider);

    return customersAsync.when(
      data: (customers) {
        final query = _searchController.text.toLowerCase();
        final filtered = customers.where((c) {
          return c.name.toLowerCase().contains(query) ||
              (c.phone?.contains(query) ?? false) ||
              (c.email?.toLowerCase().contains(query) ?? false);
        }).toList();

        if (filtered.isEmpty) {
          return _buildEmptyState(query.isNotEmpty);
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search customers...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final customer = filtered[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      onTap: () => context.push(
                        Routes.customerDetail.replaceFirst(':id', customer.id.toString()),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(customer.name[0].toUpperCase()),
                      ),
                      title: Text(
                        customer.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        customer.contactLine.isNotEmpty
                            ? customer.contactLine
                            : 'No contact info',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${customer.unpaidBalance.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: customer.unpaidBalance > 0 
                                  ? Colors.orange[800] 
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            'UNPAID',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: customer.unpaidBalance > 0 
                                  ? Colors.orange[800] 
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading customers: $e')),
    );
  }

  Widget _buildEmptyState(bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.people_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'No customers match your search' : 'No customers found',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          if (!isSearching) ...[
            const SizedBox(height: 8),
            const Text(
              'Add your first customer to get started.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.push(Routes.addCustomer),
              icon: const Icon(Icons.person_add),
              label: const Text('Add Customer'),
            ),
          ],
        ],
      ),
    );
  }
}
