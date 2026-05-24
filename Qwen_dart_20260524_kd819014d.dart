import 'package:flutter/material.dart';
import 'new_sale_screen.dart';

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Billing')), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.receipt_long, size: 64, color: Colors.grey), const SizedBox(height: 16), const Text('Billing History & Reports', style: TextStyle(fontSize: 18)), const SizedBox(height: 16), ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewSaleScreen())), child: const Text('Create New Sale'))])));
}