import 'package:hesap/features/reports/domain/entities/report_filter.dart';
import 'package:hesap/features/reports/domain/entities/report_summary.dart';
import 'package:hesap/features/reports/domain/entities/top_consumed_item.dart';
import 'package:hesap/features/stock/domain/entities/daily_stock_entry.dart';

abstract class ReportsState {}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final ReportFilter filter;
  final ReportSummary summary;
  final List<TopConsumedItem> topConsumed;
  final List<DailyStockEntry> entries;

  ReportsLoaded({
    required this.filter,
    required this.summary,
    required this.topConsumed,
    required this.entries,
  });
}

class ReportsError extends ReportsState {
  final String message;
  ReportsError(this.message);
}

class ReportsExporting extends ReportsState {}

class ReportsExportError extends ReportsState {
  final String message;
  ReportsExportError(this.message);
}