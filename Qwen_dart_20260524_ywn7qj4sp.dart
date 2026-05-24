import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/database/app_database.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  const AddItemScreen({super.key});
  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController(); final _sku = TextEditingController(); final _cat = TextEditingController();
  final _pur = TextEditingController(); final _sale = TextEditingController(); final _gst = TextEditingController(text: '18');
  final _stock = TextEditingController(text: '0'); final _thresh = TextEditingController(text: '10'); final _sup = TextEditingController(); final _unit = TextEditingController(text: 'pcs');
  
  @override void dispose() { [_name,_sku,_cat,_pur,_sale,_gst,_stock,_thresh,_sup,_unit].forEach((c) => c.dispose()); super.dispose(); }

  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Add New Item')), body: Form(key: _form, child: ListView(padding: const EdgeInsets.all(16), children: [
    TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Item Name *', prefixIcon: Icon(Icons.label)), validator: (v) => v!.isEmpty ? 'Required' : null),
    TextFormField(controller: _sku, decoration: const InputDecoration(labelText: 'SKU/Code', prefixIcon: Icon(Icons.qr_code))),
    TextFormField(controller: _cat, decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category))),
    const SizedBox(height: 16), const Text('Pricing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 8),
    TextFormField(controller: _pur, decoration: const InputDecoration(labelText: 'Purchase Price (₹)', prefixIcon: Icon(Icons.shopping_cart)), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),
    TextFormField(controller: _sale, decoration: const InputDecoration(labelText: 'Sale Price (₹)', prefixIcon: Icon(Icons.sell)), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null),
    TextFormField(controller: _gst, decoration: const InputDecoration(labelText: 'GST %', prefixIcon: Icon(Icons.percent)), keyboardType: TextInputType.number),
    const SizedBox(height: 16), const Text('Inventory', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 8),
    TextFormField(controller: _stock, decoration: const InputDecoration(labelText: 'Opening Stock', prefixIcon: Icon(Icons.inventory)), keyboardType: TextInputType.number),
    TextFormField(controller: _thresh, decoration: const InputDecoration(labelText: 'Low Stock Alert At', prefixIcon: Icon(Icons.warning)), keyboardType: TextInputType.number),
    TextFormField(controller: _unit, decoration: const InputDecoration(labelText: 'Unit (pcs/kg/mtr)', prefixIcon: Icon(Icons.straighten))),
    const SizedBox(height: 16), TextFormField(controller: _sup, decoration: const InputDecoration(labelText: 'Supplier', prefixIcon: Icon(Icons.store))),
    const SizedBox(height: 32), ElevatedButton(onPressed: _save, style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)), child: const Text('SAVE ITEM', style: TextStyle(fontSize: 16))),
  ])));

  Future<void> _save() async {
    if(!_form.currentState!.validate()) return;
    final db = ref.read(appDatabaseProvider);
    try {
      await db.insertItem(ItemsCompanion(name: Value(_name.text), sku: Value(_sku.text.isEmpty?null:_sku.text), category: Value(_cat.text.isEmpty?null:_cat.text), purchasePrice: Value(double.parse(_pur.text)), salePrice: Value(double.parse(_sale.text)), gstPercent: Value(double.tryParse(_gst.text)??18), stock: Value(int.tryParse(_stock.text)??0), lowStockThreshold: Value(int.tryParse(_thresh.text)??10), supplier: Value(_sup.text.isEmpty?null:_sup.text), unit: Value(_unit.text)));
      if(mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item saved!'), backgroundColor: Colors.green)); Navigator.pop(context); }
    } catch(e) { if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red)); }
  }
}