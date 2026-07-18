import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/order_list_view.dart';
import '../widgets/customer_list_view.dart';
import '../../../config/router.dart';

class SalesCrmHubScreen extends ConsumerStatefulWidget {
  const SalesCrmHubScreen({super.key});

  @override
  ConsumerState<SalesCrmHubScreen> createState() => _SalesCrmHubScreenState();
}

class _SalesCrmHubScreenState extends ConsumerState<SalesCrmHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to update FAB
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales & CRM'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Orders', icon: Icon(Icons.receipt_long)),
            Tab(text: 'Customers', icon: Icon(Icons.people)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OrderListView(),
          CustomerListView(),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildFab() {
    final isOrdersTab = _tabController.index == 0;
    
    return FloatingActionButton.extended(
      onPressed: () {
        if (isOrdersTab) {
          context.push(Routes.createOrder);
        } else {
          context.push(Routes.addCustomer);
        }
      },
      icon: Icon(isOrdersTab ? Icons.add_shopping_cart : Icons.person_add),
      label: Text(isOrdersTab ? 'New Order' : 'New Customer'),
    );
  }
}
