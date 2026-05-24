import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/database/app_database.dart';
import '../../../core/theme/app_theme.dart';
import 'add_item_screen.dart';

final itemsListProvider = FutureProvider((ref) => ref.watch(appDatabaseProvider).getAllItems());

class ItemsScreen extends ConsumerWidget {
  const ItemsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(itemsListProvider);
    return Scaffold(appBar: AppBar(title: const Text('Items'), actions: [IconButton(icon: const Icon(Icons.search), onPressed: () => showSearch(context: context, delegate: _ItemSearch(ref)))]), body: asyncItems.when(data: (items) => ListView.builder(padding: const EdgeInsets.all(16), itemCount: items.length, itemBuilder: (c, i) { final it = items[i]; final low = it.stock <= it.lowStockThreshold; return Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(leading: CircleAvatar(backgroundColor: low ? AppTheme.dangerColor : AppTheme.successColor, child: Text('${it.stock}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))), title: Text(it.name, style: const TextStyle(fontWeight: FontWeight.w600)), subtitle: Text('${it.category ?? 'General'} • SKU: ${it.sku ?? 'N/A'}'), trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [Text('₹${it.salePrice}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)), if(low) const Text('Low Stock', style: TextStyle(color: AppTheme.dangerColor, fontSize: 12))]), onTap: () => _showDetails(context, it))); }), loading: () => const Center(child: CircularProgressIndicator()), error: (e, _) => Center(child: Text('Error: $e'))), floatingActionButton: FloatingActionButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddItemScreen())), child: const Icon(Icons.add)));
  }
  void _showDetails(BuildContext c, dynamic i) => showModalBottomSheet(context: c, builder: (c) => Container(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(i.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 16), _row('Purchase Price', '₹${i.purchasePrice}'), _row('Sale Price', '₹${i.salePrice}'), _row('GST', '${i.gstPercent}%'), _row('Stock', '${i.stock} ${i.unit}'), _row('Supplier', i.supplier ?? 'N/A'), const SizedBox(height: 24), SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.edit), label: const Text('Edit Item')))])));
  Widget _row(String l, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l, style: const TextStyle(color: Colors.grey)), Text(v, style: const TextStyle(fontWeight: FontWeight.w600))]));
}

class _ItemSearch extends SearchDelegate {
  final WidgetRef ref;
  _ItemSearch(this.ref);
  @override List<Widget> buildActions(BuildContext c) => [IconButton(icon: const Icon(Icons.clear), onPressed: () => query='')];
  @override Widget buildLeading(BuildContext c) => IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(c, null));
  @override Widget buildResults(BuildContext c) => buildSuggestions(c);
  @override Widget buildSuggestions(BuildContext c) => FutureBuilder(future: ref.read(appDatabaseProvider).getAllItems(), builder: (c, s) { if(!s.hasData) return const Center(child: CircularProgressIndicator()); final res = s.data!.where((i) => i.name.toLowerCase().contains(query.toLowerCase())).toList(); return ListView.builder(itemCount: res.length, itemBuilder: (c, i) => ListTile(title: Text(res[i].name), subtitle: Text('₹${res[i].salePrice}'), onTap: () => close(c, res[i]))); });
}