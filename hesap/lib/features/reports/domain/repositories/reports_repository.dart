import '../entities/report_filter.dart';
import '../entities/report_summary.dart';
import '../entities/top_consumed_item.dart';

abstract class ReportsRepository {
  /// Filtreye göre özet rapor döndürür.
  Future<ReportSummary> getSummary(ReportFilter filter);

  /// Filtreye göre en çok tüketilen ürünleri sıralı döndürür.
  Future<List<TopConsumedItem>> getTopConsumed(ReportFilter filter);
}
