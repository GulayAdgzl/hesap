import '../entities/report_filter.dart';
import '../entities/report_summary.dart';
import '../repositories/reports_repository.dart';

class GetReportSummary {
  final ReportsRepository _repository;

  const GetReportSummary(this._repository);

  Future<ReportSummary> call(ReportFilter filter) =>
      _repository.getSummary(filter);
}
