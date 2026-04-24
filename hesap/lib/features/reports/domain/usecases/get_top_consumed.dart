import '../entities/report_filter.dart';
import '../entities/top_consumed_item.dart';
import '../repositories/reports_repository.dart';

class GetTopConsumed {
  final ReportsRepository _repository;

  const GetTopConsumed(this._repository);

  Future<List<TopConsumedItem>> call(ReportFilter filter) =>
      _repository.getTopConsumed(filter);
}
