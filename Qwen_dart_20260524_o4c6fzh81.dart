import 'package:flutter/material.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/billing/screens/billing_screen.dart';
import '../../features/billing/screens/new_sale_screen.dart';
import '../../features/items/screens/items_screen.dart';
import '../../features/items/screens/add_item_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String billing = '/billing';
  static const String newSale = '/billing/new';
  static const String items = '/items';
  static const String addItem = '/items/add';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home: return MaterialPageRoute(builder: (_) => const HomeScreen());
      case billing: return MaterialPageRoute(builder: (_) => const BillingScreen());
      case newSale: return MaterialPageRoute(builder: (_) => const NewSaleScreen());
      case items: return MaterialPageRoute(builder: (_) => const ItemsScreen());
      case addItem: return MaterialPageRoute(builder: (_) => const AddItemScreen());
      default: return MaterialPageRoute(builder: (_) => Scaffold(appBar: AppBar(title: const Text('Not Found')), body: const Center(child: Text('Page not found'))));
    }
  }
}