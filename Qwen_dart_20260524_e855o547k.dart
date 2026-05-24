import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../data/database/app_database.dart';
import '../../../core/theme/app_theme.dart';
import '../../billing/screens/new_sale_screen.dart';
import '../../items/screens/items_screen.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError('DB must be provided'));

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final db = ref.watch(appDatabaseProvider);
    final isDesktop = ResponsiveWrapper.of(context).isLargerThan(DESKTOP);
    
    return Scaffold(
      appBar: AppBar(title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Bharat Hardware', style: TextStyle(fontSize: 18)), Text('Er. Shaikh Naeem', style: TextStyle(fontSize: 12, color: Colors.white70))]), actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => setState(() {})), IconButton(icon: const Icon(Icons.settings), onPressed: () {})]),
      body: FutureBuilder(future: db.getTodayStats(), builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        final stats = snapshot.data as Map<String, dynamic>? ?? {};
        return RefreshIndicator(onRefresh: () async => setState(() {}), child: ListView(padding: const EdgeInsets.all(16), children: [_buildSummaryCards(stats, isDesktop), const SizedBox(height: 24), _buildQuickActions(isDesktop), const SizedBox(height: 24), _buildLowStockAlert(db)]));
      }),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewSaleScreen())), icon: const Icon(Icons.add_shopping_cart), label: const Text('New Sale')),
      bottomNavigationBar: isDesktop ? null : BottomNavigationBar(currentIndex: _selectedIndex, onTap: (i) { setState(() => _selectedIndex = i); if(i==1) Navigator.push(context, MaterialPageRoute(builder: (_) => const ItemsScreen())); if(i==2) Navigator.push(context, MaterialPageRoute(builder: (_) => const NewSaleScreen())); }, items: const [BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'), BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Items'), BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Billing')]),
    );
  }
  
  Widget _buildSummaryCards(Map<String, dynamic> s, bool isDesktop) => GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: isDesktop ? 4 : 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.5, children: [_card('${s['todaySale']?.toStringAsFixed(0)??'0'}','Today Sale',AppTheme.successColor,Icons.trending_up), _card('₹${s['stockValue']?.toStringAsFixed(0)??'0'}','Stock Value',AppTheme.primaryColor,Icons.inventory_2), _card('${s['billsCount']??0}','Bills Today',AppTheme.warningColor,Icons.receipt_long), if(isDesktop) _card('${s['totalItems']??0}','Total Items',AppTheme.dangerColor,Icons.shopping_basket)]);
  
  Widget _card(String v, String l, Color c, IconData i) => Card(color: c, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i, color: Colors.white, size: 28), const SizedBox(height: 8), Text(v, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)), Text(l, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.9)))])));
  
  Widget _buildQuickActions(bool isDesktop) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 12), GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: isDesktop ? 4 : 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.2, children: [_tile('New Sale', Icons.point_of_sale, AppTheme.successColor, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewSaleScreen()))), _tile('Add Item', Icons.add_box, AppTheme.primaryColor, () => Navigator.pushNamed(context, '/items/add')), _tile('Purchase', Icons.shopping_cart, AppTheme.warningColor, () {}), _tile('View Items', Icons.inventory, AppTheme.dangerColor, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ItemsScreen())))])]);
  
  Widget _tile(String t, IconData i, Color c, VoidCallback o) => Card(child: InkWell(onTap: o, borderRadius: BorderRadius.circular(12), child: Padding(padding: const EdgeInsets.all(16), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i, size: 32, color: c), const SizedBox(height: 8), Text(t, style: const TextStyle(fontWeight: FontWeight.w600))]))));
  
  Widget _buildLowStockAlert(AppDatabase db) => FutureBuilder(future: db.getLowStockItems(), builder: (c, s) { if(!s.hasData || s.data!.isEmpty) return const SizedBox.shrink(); final items = s.data!; return Card(color: AppTheme.warningColor.withOpacity(0.1), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Icon(Icons.warning, color: AppTheme.warningColor), const SizedBox(width: 8), const Text('Low Stock Alert', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]), const SizedBox(height: 12), ...items.take(3).map((i) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Text('• ${i.name} - ${i.stock} left', style: const TextStyle(fontSize: 14)))]))); });
}