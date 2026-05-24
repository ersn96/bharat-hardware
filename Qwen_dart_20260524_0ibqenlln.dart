import 'package:drift/drift.dart';

class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get sku => text().withLength(min: 1, max: 50).nullable()();
  TextColumn get category => text().withLength(min: 1, max: 100).nullable()();
  RealColumn get purchasePrice => real()();
  RealColumn get salePrice => real()();
  RealColumn get gstPercent => real().withDefault(const Constant(18.0))();
  IntColumn get stock => integer().withDefault(const Constant(0))();
  IntColumn get lowStockThreshold => integer().withDefault(const Constant(10))();
  TextColumn get supplier => text().nullable()();
  TextColumn get unit => text().withDefault(const Constant('pcs'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}