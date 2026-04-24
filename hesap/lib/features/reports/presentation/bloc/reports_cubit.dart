import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hesap/features/reports/data/services/csv_export_service.dart';
import 'package:hesap/features/reports/domain/entities/report_filter.dart';
import 'package:hesap/features/reports/domain/usecases/get_report_summary.dart';
import 'package:hesap/features/reports/domain/usecases/get_top_consumed.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final GetReportSummary _getReportSummary;
  final GetTopConsumed _getTopConsumed;
  final CsvExportService _csvExportService;

  ReportsCubit({
    required GetReportSummary getReportSummary,
    required GetTopConsumed getTopConsumed,
    required CsvExportService csvExportService,
  })  : _getReportSummary = getReportSummary,
        _getTopConsumed = getTopConsumed,
        _csvExportService = csvExportService,
        super(ReportsInitial());

  /// İlk yükleme — varsayılan filtre: Bu Hafta
  Future<void> load([ReportFilter filter = const ReportFilter()]) async {
    emit(ReportsLoading());
    await _fetch(filter);
  }

  /// Filtre değiştiğinde çağrılır
  Future<void> changeFilter(ReportFilter filter) async {
    emit(ReportsLoading());
    await _fetch(filter);
  }

  /// Mevcut yüklü veriyi CSV olarak dışa aktarır
  Future<void> exportCsv() async {
    final current = state;
    if (current is! ReportsLoaded) return;

    emit(ReportsExporting());

    try {
      await _csvExportService.exportTopConsumed(
        items: current.topConsumed,
        filter: current.filter,
      );
      emit(current); // export sonrası aynı loaded state'e dön
    } catch (e) {
      emit(ReportsExportError(e.toString()));
      emit(current); // hata gösterildikten sonra önceki state'e dön
    }
  }

  Future<void> _fetch(ReportFilter filter) async {
    try {
      final results = await Future.wait([
        _getReportSummary(filter),
        _getTopConsumed(filter),
      ]);

      emit(ReportsLoaded(
        filter: filter,
        summary: results[0] as dynamic,
        topConsumed: results[1] as dynamic,
        entries: const [], // bunu ekle
      ));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }
}
