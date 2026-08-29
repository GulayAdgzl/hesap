import 'package:hesap/feature/reports/domain/usecases/get_report_summary.dart';
import 'package:hesap/feature/reports/domain/usecases/get_top_consumed.dart';
import 'package:hesap/module/report_summary/entities/report_filter.dart';
import 'package:hesap/module/report_summary/entities/report_summary.dart';
import 'package:hesap/module/report_summary/entities/top_consumed_item.dart';

/// ViewModel'in beklediği sonuç modeli.
final class ReportSummaryResult {
  const ReportSummaryResult({
    required this.summary,
    required this.topConsumed,
  });

  final ReportSummary summary;
  final List<TopConsumedItem> topConsumed;
}

/// ViewModel'in bağımlı olduğu arayüz.
abstract interface class GetReportSummaryUseCase {
  Future<ReportSummaryResult> call(ReportFilter filter);
}

/// Mevcut [GetReportSummary] + [GetTopConsumed] use case'lerini
/// tek çağrıda birleştiren implementasyon.
final class GetReportSummaryUseCaseImpl implements GetReportSummaryUseCase {
  const GetReportSummaryUseCaseImpl(
    Object object, {
    required GetReportSummary getReportSummary,
    required GetTopConsumed getTopConsumed,
  })  : _getReportSummary = getReportSummary,
        _getTopConsumed = getTopConsumed;

  final GetReportSummary _getReportSummary;
  final GetTopConsumed _getTopConsumed;

  @override
  Future<ReportSummaryResult> call(ReportFilter filter) async {
    final results = await Future.wait([
      _getReportSummary(filter),
      _getTopConsumed(filter),
    ]);

    return ReportSummaryResult(
      summary: results[0] as ReportSummary,
      topConsumed: results[1] as List<TopConsumedItem>,
    );
  }
}
