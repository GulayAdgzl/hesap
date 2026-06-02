import 'package:hesap/feature/reports/data/datasources/reports_local_datasource.dart';
import 'package:hesap/feature/reports/domain/repositories/reports_repository.dart';
import 'package:hesap/feature/stock/domain/entities/daily_stock_entry.dart';
import 'package:hesap/module/report_summary/entities/report_filter.dart';
import 'package:hesap/module/report_summary/entities/report_summary.dart';
import 'package:hesap/module/report_summary/entities/top_consumed_item.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsLocalDatasource _datasource;

  ReportsRepositoryImpl(this._datasource);

  @override
  Future<ReportSummary> getSummary(ReportFilter filter) async {
    final entries =
        await _datasource.getEntriesBetween(filter.startDate, filter.endDate);

    if (entries.isEmpty) return ReportSummary.empty;

    // Toplam tüketim ve maliyet
    final totalConsumption =
        entries.fold<int>(0, (sum, e) => sum + e.consumed.clamp(0, 9999999));
    final totalCost = entries.fold<double>(
        0, (sum, e) => sum + e.totalCost.clamp(0, 9999999));

    // Günlük maliyet serisi
    final Map<DateTime, double> dailySeries = {};
    for (final entry in entries) {
      final day = DateTime(entry.date.year, entry.date.month, entry.date.day);
      dailySeries[day] =
          (dailySeries[day] ?? 0) + entry.totalCost.clamp(0, 9999999);
    }

    // Günlük ortalama
    final dayCount = dailySeries.keys.length;
    final dailyAvg = dayCount > 0 ? totalCost / dayCount : 0.0;

    // Bir önceki dönem karşılaştırması
    final periodDays = filter.endDate.difference(filter.startDate).inDays + 1;
    final prevStart = filter.startDate.subtract(Duration(days: periodDays));
    final prevEnd = filter.startDate.subtract(const Duration(days: 1));

    final prevEntries = await _datasource.getEntriesBetween(prevStart, prevEnd);
    final prevConsumption = prevEntries.fold<int>(
        0, (sum, e) => sum + e.consumed.clamp(0, 9999999));

    double? changePercent;
    if (prevConsumption > 0) {
      changePercent =
          ((totalConsumption - prevConsumption) / prevConsumption) * 100;
    }

    return ReportSummary(
      totalConsumption: totalConsumption,
      totalCost: totalCost,
      consumptionChangePercent: changePercent,
      dailyAverageCost: dailyAvg,
      dailyCostSeries: dailySeries,
    );
  }

  @override
  Future<List<TopConsumedItem>> getTopConsumed(ReportFilter filter) async {
    final entries =
        await _datasource.getEntriesBetween(filter.startDate, filter.endDate);

    // Ürüne göre grupla
    final Map<String, _ProductAcc> acc = {};
    for (final entry in entries) {
      final consumed = entry.consumed.clamp(0, 9999999);
      if (consumed <= 0) continue;

      acc.putIfAbsent(
        entry.productId,
        () => _ProductAcc(
          productId: entry.productId,
          productName: entry.productName,
          productUnit: entry.productUnit,
        ),
      )
        ..totalConsumed += consumed
        ..totalCost += entry.totalCost.clamp(0, double.maxFinite);
    }

    // Tüketime göre azalan sırala
    final sorted = acc.values.toList()
      ..sort((a, b) => b.totalConsumed.compareTo(a.totalConsumed));

    return sorted
        .map((a) => TopConsumedItem(
              productId: a.productId,
              productName: a.productName,
              productUnit: a.productUnit,
              totalConsumed: a.totalConsumed,
              totalCost: a.totalCost,
            ))
        .toList();
  }
}

/// Gruplama için yardımcı iç sınıf
class _ProductAcc {
  final String productId;
  final String productName;
  final String productUnit;
  int totalConsumed = 0;
  double totalCost = 0;

  _ProductAcc({
    required this.productId,
    required this.productName,
    required this.productUnit,
  });
}
