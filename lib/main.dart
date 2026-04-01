import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'config/router.dart';

void main() {
  runApp(const ProviderScope(child: ChickenTrackerApp()));
}

class ChickenTrackerApp extends StatelessWidget {
  const ChickenTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();

        return SafeArea(
          top: false,
          left: false,
          right: false,
          minimum: const EdgeInsets.only(bottom: 16),
          child: child,
        );
      },
      title: 'Chicken & Egg Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // default = dark for farm use
      routerConfig: goRouter,
    );
  }
}