import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../config/router.dart';
import '../../../core/providers/database_providers.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(allSalesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('💰 Sales'),
        elevation: 0,
      ),
      body: salesAsync.when(
        data: (sales) {
          if (sales.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No sales recorded yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Track your egg and chicken sales here',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          // Group sales by month
          final groupedSales = <String, List<dynamic>>{};
          for (final sale in sales) {
            final monthKey = DateFormat('MMMM yyyy').format(sale.date);
            groupedSales.putIfAbsent(monthKey, () => []).add(sale);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groupedSales.length,
            itemBuilder: (context, index) {
              final month = groupedSales.keys.elementAt(index);
              final monthSales = groupedSales[month]!;

              final totalAmount = monthSales.fold<double>(
                0,
                (sum, sale) => sum + sale.amount,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          month,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${totalAmount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...monthSales.map((sale) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        sale.type == 'eggs' ? Icons.egg : Icons.pets,
                        color: sale.type == 'eggs' ? Colors.amber : Colors.brown,
                      ),
                      title: Text(
                        '${sale.quantity} ${sale.type}${sale.quantity != 1 ? 's' : ''} sold',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('MMM d, yyyy').format(sale.date),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (sale.customerName != null) ...[
                            Text(
                              'Customer: ${sale.customerName}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                      trailing: Text(
                        '\$${sale.amount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(height: 16),
                ],
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading sales: $error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(Routes.addSale);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Sale'),
      ),
    );
  }
}