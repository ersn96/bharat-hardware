import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/item_model.dart';
import '../models/bill_model.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Items, Bills, BillItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'bharat_hardware.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
  
  @override
  int get schemaVersion => 1;
  
  Future<List<Item>> getAllItems() => select(items).get();
  Future<List<Item>> getLowStockItems() => (select(items)..where((t) => t.stock.isSmallerOrEqualValue(t.lowStockThreshold))).get();
  Future<int> insertItem(ItemsCompanion item) => into(items).insert(item);
  Future<bool> updateItem(int id, ItemsCompanion item) => (update(items)..where((t) => t.id.equals(id))).write(item);
  
  Future<List<Bill>> getAllBills() => select(bills).orderBy([(t) => OrderingTerm.desc(t.date)]).get();
  Future<List<Bill>> getTodayBills() {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));
    return (select(bills)..where((t) => t.date.isBetweenValues(start, end))).get();
  }
  
  Future<int> insertBill(BillsCompanion bill, List<BillItemsCompanion> items) {
    return transaction(() async {
      final billId = await into(bills).insert(bill);
      for (final i in items) await into(billItems).insert(i.copyWith(billId: Value(billId)));
      return billId;
    });
  }
  
  Future<Map<String, dynamic>> getTodayStats() async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));
    final bills = await (select(bills)..where((t) => t.date.isBetweenValues(start, end))).get();
    final allItems = await select(items).get();
    
    double sale = bills.fold(0.0, (sum, b) => sum + b.total);
    double stockVal = allItems.fold(0.0, (sum, i) => sum + (i.purchasePrice * i.stock));
    
    return {'todaySale': sale, 'stockValue': stockVal, 'billsCount': bills.length, 'totalItems': allItems.length};
  }
}