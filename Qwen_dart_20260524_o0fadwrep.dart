import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';
import 'data/database/app_database.dart';
import 'features/home/screens/home_screen.dart';
import 'features/billing/screens/billing_screen.dart';
import 'features/items/screens/items_screen.dart';

class BharatHardwareApp extends ConsumerWidget {
  final AppDatabase db;
  const BharatHardwareApp({super.key, required this.db});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Bharat Hardware',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generateRoute,
      home: const HomeScreen(),
    );
  }
}