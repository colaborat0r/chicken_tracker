// lib/config/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/screens/home_screen.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    // Add more routes here as we build new screens
  ],
);
