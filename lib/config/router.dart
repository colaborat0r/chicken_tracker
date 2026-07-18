import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chicken_tracker/features/home/screens/home_screen.dart';
import 'package:chicken_tracker/features/home/screens/report_settings_screen.dart';
import 'package:chicken_tracker/features/chickens/screens/add_chicken_screen.dart';
import 'package:chicken_tracker/features/chickens/screens/add_multiple_chickens_screen.dart';
import 'package:chicken_tracker/features/chickens/screens/chicken_list_screen.dart';
import 'package:chicken_tracker/features/chickens/screens/chicken_detail_screen.dart';
import 'package:chicken_tracker/features/production/screens/log_production_screen.dart';
import 'package:chicken_tracker/features/production/screens/production_history_screen.dart';
import 'package:chicken_tracker/features/production/screens/analytics_dashboard_screen.dart';
import 'package:chicken_tracker/features/reports/screens/reports_screen.dart';
import 'package:chicken_tracker/features/sales/screens/add_sale_screen.dart';
import 'package:chicken_tracker/features/expenses/screens/expenses_screen.dart';
import 'package:chicken_tracker/features/expenses/screens/add_expense_screen.dart';
import 'package:chicken_tracker/features/expenses/screens/category_expenses_screen.dart';
import 'package:chicken_tracker/features/flock_purchases/screens/flock_purchases_screen.dart';
import 'package:chicken_tracker/features/flock_purchases/screens/add_flock_purchase_screen.dart';
import 'package:chicken_tracker/features/flock_losses/screens/flock_losses_screen.dart';
import 'package:chicken_tracker/features/flock_losses/screens/add_flock_loss_screen.dart';
import 'package:chicken_tracker/features/settings/screens/data_management_screen.dart';
import 'package:chicken_tracker/features/settings/screens/about_screen.dart';
import 'package:chicken_tracker/features/reminders/screens/reminders_screen.dart';
import 'package:chicken_tracker/features/reminders/screens/add_reminder_screen.dart';
import 'package:chicken_tracker/features/guides/screens/guides_home_screen.dart';
import 'package:chicken_tracker/features/guides/screens/guides_list_screen.dart';
import 'package:chicken_tracker/features/guides/screens/guide_detail_screen.dart';
import 'package:chicken_tracker/features/guides/screens/saved_guides_screen.dart';
import 'package:chicken_tracker/features/care_logs/screens/care_logs_screen.dart';
import 'package:chicken_tracker/features/care_logs/screens/add_care_log_screen.dart';
import 'package:chicken_tracker/features/care_logs/screens/care_log_gallery_screen.dart';
import 'package:chicken_tracker/features/home/screens/main_screen.dart';
import 'package:chicken_tracker/features/sales/screens/sales_crm_hub_screen.dart';
import 'package:chicken_tracker/features/sales/screens/order_detail_screen.dart';
import 'package:chicken_tracker/features/sales/screens/create_order_screen.dart';
import 'package:chicken_tracker/features/sales/screens/add_customer_screen.dart';
import 'package:chicken_tracker/features/sales/screens/customer_detail_screen.dart';
import 'package:chicken_tracker/core/models/chicken_model.dart';
import 'package:chicken_tracker/core/models/reminder_model.dart';
import 'package:chicken_tracker/core/models/care_log_model.dart';

/// Route names for named navigation
class Routes {
  static const String home = '/';
  static const String reportSettings = '/report-settings';
  static const String addChicken = '/add-chicken';
  static const String addMultipleChickens = '/add-multiple-chickens';
  static const String chickenList = '/chickens';
  static const String chickenDetail = '/chickens/:id';
  static const String logProduction = '/log-production';
  static const String productionHistory = '/production-history';
  static const String analytics = '/analytics';
  static const String reports = '/reports';
  static const String addSale = '/add-sale';
  static const String expenses = '/expenses';
  static const String addExpense = '/add-expense';
  static const String categoryExpenses = '/expenses/category/:category';
  static const String flockPurchases = '/flock-purchases';
  static const String addFlockPurchase = '/add-flock-purchase';
  static const String flockLosses = '/flock-losses';
  static const String addFlockLoss = '/add-flock-loss';
  static const String dataManagement = '/data-management';
  static const String about = '/about';
  static const String reminders = '/reminders';
  static const String addReminder = '/add-reminder';
  static const String guidesHome = '/guides-home';
  static const String guides = '/guides';
  static const String guideDetail = '/guides/:id';
  static const String savedGuides = '/saved-guides';
  static const String careLogs = '/care-logs';
  static const String addCareLog = '/add-care-log';
  static const String careLogGallery = '/care-log-gallery';

  // CRM & Orders
  static const String crmHub = '/crm';
  static const String orderDetail = '/orders/:id';
  static const String createOrder = '/create-order';
  static const String addCustomer = '/add-customer';
  static const String customerDetail = '/customers/:id';
}

/// GoRouter configuration for the app
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _productionNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'production');
final _flockNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'flock');
final _crmNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'crm');
final _expensesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'expenses');

final goRouter = GoRouter(
  initialLocation: Routes.home,
  navigatorKey: _rootNavigatorKey,
  routes: [
    // StatefulShellRoute for Bottom Navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        // Home Branch
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: Routes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Production Branch
        StatefulShellBranch(
          navigatorKey: _productionNavigatorKey,
          routes: [
            GoRoute(
              path: Routes.productionHistory,
              builder: (context, state) => const ProductionHistoryScreen(),
            ),
          ],
        ),
        // Flock Branch
        StatefulShellBranch(
          navigatorKey: _flockNavigatorKey,
          routes: [
            GoRoute(
              path: Routes.chickenList,
              builder: (context, state) => const ChickenListScreen(),
            ),
          ],
        ),
        // CRM Branch
        StatefulShellBranch(
          navigatorKey: _crmNavigatorKey,
          routes: [
            GoRoute(
              path: Routes.crmHub,
              builder: (context, state) => const SalesCrmHubScreen(),
            ),
          ],
        ),
        // Expenses Branch
        StatefulShellBranch(
          navigatorKey: _expensesNavigatorKey,
          routes: [
            GoRoute(
              path: Routes.expenses,
              builder: (context, state) => const ExpensesScreen(),
            ),
          ],
        ),
      ],
    ),

    // Other screens that should be on top of the bottom navigation
    // Report settings screen
    GoRoute(
      path: Routes.reportSettings,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ReportSettingsScreen(),
    ),

    // Add chicken screen
    GoRoute(
      path: Routes.addChicken,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AddChickenScreen(),
    ),

    // Add multiple chickens screen
    GoRoute(
      path: Routes.addMultipleChickens,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AddMultipleChickensScreen(),
    ),

    // Chicken detail screen - receives chicken object via extras
    GoRoute(
      path: Routes.chickenDetail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! ChickenModel) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => context.go(Routes.home),
          );
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return ChickenDetailScreen(chicken: extra);
      },
    ),

    // Log production screen
    GoRoute(
      path: Routes.logProduction,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra;
        return LogProductionScreen(
          logToEdit: extra is DailyProductionModel ? extra : null,
        );
      },
    ),

    // Analytics dashboard screen
    GoRoute(
      path: Routes.analytics,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AnalyticsDashboardScreen(),
    ),

    // Reports screen
    GoRoute(
      path: Routes.reports,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ReportsScreen(),
    ),

    // Add sale screen
    GoRoute(
      path: Routes.addSale,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra;
        return AddSaleScreen(saleToEdit: extra is SaleModel ? extra : null);
      },
    ),

    // Add expense screen
    GoRoute(
      path: Routes.addExpense,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra;
        return AddExpenseScreen(expenseToEdit: extra is ExpenseModel ? extra : null);
      },
    ),

    // Category expenses screen
    GoRoute(
      path: Routes.categoryExpenses,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final category = state.pathParameters['category'] ?? '';
        return CategoryExpensesScreen(category: category);
      },
    ),

    // Flock purchases screen
    GoRoute(
      path: Routes.flockPurchases,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FlockPurchasesScreen(),
    ),

    // Add flock purchase screen
    GoRoute(
      path: Routes.addFlockPurchase,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra;
        return AddFlockPurchaseScreen(
          purchaseToEdit: extra is FlockPurchaseModel ? extra : null,
        );
      },
    ),

    // Flock losses screen
    GoRoute(
      path: Routes.flockLosses,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FlockLossesScreen(),
    ),

    // Add flock loss screen
    GoRoute(
      path: Routes.addFlockLoss,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra;
        return AddFlockLossScreen(
          lossToEdit: extra is FlockLossModel ? extra : null,
        );
      },
    ),

    // Data management screen
    GoRoute(
      path: Routes.dataManagement,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DataManagementScreen(),
    ),

    // About screen
    GoRoute(
      path: Routes.about,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AboutScreen(),
    ),

    // Reminders screen
    GoRoute(
      path: Routes.reminders,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RemindersScreen(),
    ),

    // Add / edit reminder screen
    GoRoute(
      path: Routes.addReminder,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra;
        return AddReminderScreen(
          reminderToEdit: extra is ReminderModel ? extra : null,
        );
      },
    ),

    // Guides home screen
    GoRoute(
      path: Routes.guidesHome,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const GuidesHomeScreen(),
    ),

    // Guides library screen
    GoRoute(
      path: Routes.guides,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final category = state.uri.queryParameters['category'];
        return GuidesListScreen(initialCategory: category);
      },
    ),

    // Guide detail screen (deep link ready)
    GoRoute(
      path: Routes.guideDetail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return GuideDetailScreen(guideId: id);
      },
    ),

    // Saved guides screen
    GoRoute(
      path: Routes.savedGuides,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SavedGuidesScreen(),
    ),

    // Care logs screen
    GoRoute(
      path: Routes.careLogs,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CareLogsScreen(),
    ),

    // Add / edit care log screen
    GoRoute(
      path: Routes.addCareLog,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra;
        return AddCareLogScreen(
          logToEdit: extra is CareLogModel ? extra : null,
        );
      },
    ),

    // Care log photo gallery
    GoRoute(
      path: Routes.careLogGallery,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CareLogGalleryScreen(),
    ),

    // CRM / Order details (pushed on top of stack)
    GoRoute(
      path: Routes.orderDetail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return OrderDetailScreen(orderId: id);
      },
    ),
    GoRoute(
      path: Routes.createOrder,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final orderId = state.extra as int?;
        return CreateOrderScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: Routes.addCustomer,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final customerId = state.extra as int?;
        return AddCustomerScreen(customerId: customerId);
      },
    ),
    GoRoute(
      path: Routes.customerDetail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return CustomerDetailScreen(customerId: id);
      },
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
