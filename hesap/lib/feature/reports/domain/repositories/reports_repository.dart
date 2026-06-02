import '../../../../module/report_summary/entities/report_filter.dart';
import '../../../../module/report_summary/entities/report_summary.dart';
import '../../../../module/report_summary/entities/top_consumed_item.dart';

abstract class ReportsRepository {
  /// Filtreye göre özet rapor döndürür.
  Future<ReportSummary> getSummary(ReportFilter filter);

  /// Filtreye göre en çok tüketilen ürünleri sıralı döndürür.
  Future<List<TopConsumedItem>> getTopConsumed(ReportFilter filter);
}
