import 'package:hive_ce/hive.dart';
import 'package:hesap/core/models/daily_stock_entry_model.dart';
import 'package:hesap/features/stock/domain/entities/daily_stock_entry.dart';

abstract class DailyEntryLocalDatasource {
  Future<void> saveDailyEntries(List<DailyStockEntry> entries);
  Future<List<DailyStockEntry>> getEntriesByDate(DateTime date);
  Future<DailyStockEntry?> getLastEntryForProduct(String productId);
}

class DailyEntryLocalDatasourceImpl implements DailyEntryLocalDatasource {
  final Box<DailyStockEntryModel> box;

  DailyEntryLocalDatasourceImpl(this.box);

  @override
  Future<void> saveDailyEntries(List<DailyStockEntry> entries) async {
    for (final entry in entries) {
      await box.put(entry.id, DailyStockEntryModel.fromEntity(entry));
    }
  }

  @override
  Future<List<DailyStockEntry>> getEntriesByDate(DateTime date) async {
    return box.values
        .where((m) =>
            m.date.year == date.year &&
            m.date.month == date.month &&
            m.date.day == date.day)
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<DailyStockEntry?> getLastEntryForProduct(String productId) async {
    final entries = box.values.where((m) => m.productId == productId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return entries.isEmpty ? null : entries.first.toEntity();
  }
}
