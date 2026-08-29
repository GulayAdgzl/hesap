import 'package:flutter/foundation.dart';
import 'package:hesap/feature/reports/domain/usecases/export_csv_use_case.dart';
import 'package:hesap/feature/reports/domain/usecases/get_report_summary_use_case.dart';
import 'package:hesap/module/csv_export/csv_export_service.dart';
import 'package:hesap/module/report_summary/entities/report_filter.dart';

import 'reports_ui_state.dart';

final class ReportsViewModel {
  ReportsViewModel({
    required GetReportSummaryUseCase getReportSummary,
    required CsvExportService csvExportService,
  }) : _getReportSummary = getReportSummary {
    // Closure, her çağrıda güncel topConsumed listesini verir.
    _exportCsv = ExportCsvUseCaseImpl(
      csvExportService: csvExportService,
      getTopConsumed: () => state.value.topConsumed,
    );
  }

  final GetReportSummaryUseCase _getReportSummary;
  late final ExportCsvUseCase _exportCsv;

  final ValueNotifier<ReportsUiState> state =
      ValueNotifier(const ReportsUiState());

  // ── Public API ─────────────────────────────────────────────────────────────

  Future<void> load() async {
    _emit(state.value.copyWith(isLoading: true, clearError: true));
    try {
      final result = await _getReportSummary(state.value.filter);
      _emit(state.value.copyWith(
        isLoading: false,
        summary: result.summary,
        topConsumed: result.topConsumed,
      ));
    } catch (e) {
      _emit(state.value.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> changeFilter(ReportFilter filter) async {
    _emit(state.value.copyWith(filter: filter, clearError: true));
    await load();
  }

  Future<void> exportCsv() async {
    if (state.value.isExporting) return;
    _emit(state.value.copyWith(isExporting: true, clearError: true));
    try {
      await _exportCsv(state.value.filter);
      _emit(state.value.copyWith(isExporting: false));
    } catch (e) {
      _emit(state.value.copyWith(isExporting: false, error: e.toString()));
    }
  }

  void dispose() => state.dispose();

  void _emit(ReportsUiState next) => state.value = next;
}
