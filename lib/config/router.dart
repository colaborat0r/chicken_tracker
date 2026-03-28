import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chicken_tracker/features/home/screens/home_screen.dart';
import 'package:chicken_tracker/features/chickens/screens/add_chicken_screen.dart';
import 'package:chicken_tracker/features/chickens/screens/chicken_list_screen.dart';
import 'package:chicken_tracker/features/chickens/screens/chicken_detail_screen.dart';
import 'package:chicken_tracker/features/production/screens/log_production_screen.dart';
import 'package:chicken_tracker/features/production/screens/production_history_screen.dart';
import 'package:chicken_tracker/features/production/screens/analytics_dashboard_screen.dart';
import 'package:chicken_tracker/features/reports/screens/reports_screen.dart';
import 'package:chicken_tracker/features/sales/screens/sales_screen.dart';
import 'package:chicken_tracker/features/expenses/screens/expenses_screen.dart';
import 'package:chicken_tracker/features/flock_purchases/screens/flock_purchases_screen.dart';
import 'package:chicken_tracker/features/flock_losses/screens/flock_losses_screen.dart';
import 'package:chicken_tracker/core/models/chicken_model.dart';

/// Route names for named navigation
class Routes {
  static const String home = '/';
  static const String addChicken = '/add-chicken';
  static const String chickenList = '/chickens';
  static const String chickenDetail = '/chickens/:id';
  static const String logProduction = '/log-production';
  static const String productionHistory = '/production-history';
  static const String analytics = '/analytics';
  static const String reports = '/reports';
  static const String sales = '/sales';
  static const String expenses = '/expenses';
  static const String flockPurchases = '/flock-purchases';
  static const String flockLosses = '/flock-losses';
}

/// GoRouter configuration for the app
final goRouter = GoRouter(
  initialLocation: Routes.home,
  routes: [
    // Home screen
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    
    // Add chicken screen
    GoRoute(
      path: Routes.addChicken,
      builder: (context, state) => const AddChickenScreen(),
    ),
    
    // Chicken list screen
    GoRoute(
      path: Routes.chickenList,
      builder: (context, state) => const ChickenListScreen(),
    ),
    
    // Chicken detail screen - receives chicken object via extras
    GoRoute(
      path: Routes.chickenDetail,
      builder: (context, state) {
        final chicken = state.extra as ChickenModel;
        return ChickenDetailScreen(chicken: chicken);
      },
    ),
    
    // Log production screen
    GoRoute(
      path: Routes.logProduction,
      builder: (context, state) => const LogProductionScreen(),
    ),
    
    // Production history screen
    GoRoute(
      path: Routes.productionHistory,
      builder: (context, state) => const ProductionHistoryScreen(),
    ),
    
    // Analytics dashboard screen
    GoRoute(
      path: Routes.analytics,
      builder: (context, state) => const AnalyticsDashboardScreen(),
    ),
    
    // Reports screen
    GoRoute(
      path: Routes.reports,
      builder: (context, state) => const ReportsScreen(),
    ),

    // Sales screen
    GoRoute(
      path: Routes.sales,
      builder: (context, state) => const SalesScreen(),
    ),

    // Expenses screen
    GoRoute(
      path: Routes.expenses,
      builder: (context, state) => const ExpensesScreen(),
    ),

    // Flock purchases screen
    GoRoute(
      path: Routes.flockPurchases,
      builder: (context, state) => const FlockPurchasesScreen(),
    ),

    // Flock losses screen
    GoRoute(
      path: Routes.flockLosses,
      builder: (context, state) => const FlockLossesScreen(),
    ),
  ],
  
  // Global error handler
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(
      title: const Text('Error'),
    ),
    body: Center(
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
            'Page not found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Path: ${state.uri}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.go(Routes.home),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);
