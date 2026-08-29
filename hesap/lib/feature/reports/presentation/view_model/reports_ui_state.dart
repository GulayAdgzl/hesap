import 'package:hesap/module/report_summary/entities/report_filter.dart';
import 'package:hesap/module/report_summary/entities/report_summary.dart';
import 'package:hesap/module/report_summary/entities/top_consumed_item.dart';

final class ReportsUiState {
  const ReportsUiState({
    this.isLoading = false,
    this.isExporting = false,
    this.error,
    this.summary,
    this.topConsumed = const [],
    this.filter = const ReportFilter(),
  });

  final bool isLoading;
  final bool isExporting;
  final String? error;
  final ReportSummary? summary;
  final List<TopConsumedItem> topConsumed;
  final ReportFilter filter;

  bool get hasData => summary != null;
  bool get hasError => error != null;

  ReportsUiState copyWith({
    bool? isLoading,
    bool? isExporting,
    String? error,
    ReportSummary? summary,
    List<TopConsumedItem>? topConsumed,
    ReportFilter? filter,
    bool clearError = false,
  }) {
    return ReportsUiState(
      isLoading: isLoading ?? this.isLoading,
      isExporting: isExporting ?? this.isExporting,
      error: clearError ? null : (error ?? this.error),
      summary: summary ?? this.summary,
      topConsumed: topConsumed ?? this.topConsumed,
      filter: filter ?? this.filter,
    );
  }
}
