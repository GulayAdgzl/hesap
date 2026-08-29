import 'package:hesap/feature/reports/domain/repositories/reports_repository.dart';
import 'package:hesap/module/report_summary/entities/report_filter.dart';
import 'package:hesap/module/report_summary/entities/report_summary.dart';

final class GetReportSummary {
  const GetReportSummary(this._repository);

  final ReportsRepository _repository;

  Future<ReportSummary> call(ReportFilter filter) =>
      _repository.getSummary(filter);
}
