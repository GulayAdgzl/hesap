import '../../../../module/report_summary/entities/report_filter.dart';
import '../../../../module/report_summary/entities/report_summary.dart';
import '../repositories/reports_repository.dart';

class GetReportSummary {
  final ReportsRepository _repository;

  const GetReportSummary(this._repository);

  Future<ReportSummary> call(ReportFilter filter) =>
      _repository.getSummary(filter);
}
