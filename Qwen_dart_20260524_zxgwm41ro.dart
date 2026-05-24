import 'package:drift/drift.dart';

class Bills extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get billNumber => text().withLength(min: 1, max: 50)();
  TextColumn get customerName => text().withLength(min: 1, max: 200)();
  TextColumn get customerMobile => text().nullable()();
  TextColumn get customerAddress => text().nullable()();
  RealColumn get subtotal => real()();
  RealColumn get gstAmount => real().withDefault(const Constant(0.0))();
  RealColumn get discount => real().withDefault(const Constant(0.0))();
  RealColumn get total => real()();
  TextColumn get paymentMode => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get status => text().withDefault(const Constant('completed'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class BillItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get billId => integer().references(Bills, #id)();
  IntColumn get itemId => integer()();
  TextColumn get itemName => text()();
  RealColumn get quantity => real()();
  RealColumn get rate => real()();
  RealColumn get gstPercent => real()();
  RealColumn get amount => real()();
}