import 'package:hesap/feature/stock/domain/entities/daily_stock_entry.dart';
import 'package:hesap/product/model/daily_stock_entry_model.dart';
import 'package:hive_ce/hive.dart';

abstract class ReportsLocalDatasource {
  /// [start] ile [end] arasındaki tüm girişleri döndürür (uçlar dahil).
  Future<List<DailyStockEntry>> getEntriesBetween(DateTime start, DateTime end);
}

class ReportsLocalDatasourceImpl implements ReportsLocalDatasource {
  final Box<DailyStockEntryModel> box;

  ReportsLocalDatasourceImpl(this.box);

  @override
  Future<List<DailyStockEntry>> getEntriesBetween(
      DateTime start, DateTime end) async {
    final from = DateTime(start.year, start.month, start.day);
    final to = DateTime(end.year, end.month, end.day, 23, 59, 59);

    return box.values
        .where((m) => !m.date.isBefore(from) && !m.date.isAfter(to))
        .map((m) => m.toEntity())
        .toList();
  }
}
