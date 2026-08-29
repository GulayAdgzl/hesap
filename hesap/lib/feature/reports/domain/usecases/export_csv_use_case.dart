import 'package:hesap/module/csv_export/csv_export_service.dart';
import 'package:hesap/module/report_summary/entities/report_filter.dart';
import 'package:hesap/module/report_summary/entities/top_consumed_item.dart';

/// ViewModel'in bağımlı olduğu arayüz.
abstract interface class ExportCsvUseCase {
  Future<void> call(ReportFilter filter);
}

/// Mevcut [CsvExportService]'i ViewModel arayüzüne adapte eder.
/// topConsumed listesi dışarıdan enjekte edilir.
final class ExportCsvUseCaseImpl implements ExportCsvUseCase {
  const ExportCsvUseCaseImpl({
    required CsvExportService csvExportService,
    required List<TopConsumedItem> Function() getTopConsumed,
  })  : _csvExportService = csvExportService,
        _getTopConsumed = getTopConsumed;

  final CsvExportService _csvExportService;
  final List<TopConsumedItem> Function() _getTopConsumed;

  @override
  Future<void> call(ReportFilter filter) => _csvExportService.exportTopConsumed(
        items: _getTopConsumed(),
        filter: filter,
      );
}
