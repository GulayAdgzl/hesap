import 'package:hesap/feature/stock/domain/entities/daily_stock_entry.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';

abstract class DailyEntryState {}

class DailyEntryInitial extends DailyEntryState {}

class DailyEntryLoading extends DailyEntryState {}

class DailyEntryLoaded extends DailyEntryState {
  final List<Product> products;
  final Map<String, int?> currentQuantities;
  final Map<String, DailyStockEntry?> lastEntries;

  DailyEntryLoaded({
    required this.products,
    required this.currentQuantities,
    required this.lastEntries,
  });
}

class DailyEntrySaved extends DailyEntryState {}

class DailyEntryError extends DailyEntryState {
  final String message;
  DailyEntryError(this.message);
}
