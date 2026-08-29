import 'package:flutter/material.dart';
import 'package:hesap/core/theme/theme.dart';
import 'package:hesap/feature/reports/presentation/view_model/reports_ui_state.dart';
import 'package:hesap/feature/reports/presentation/widgets/reports_csv_export_button.dart';
import 'package:hesap/feature/reports/presentation/widgets/reports_summary_grid.dart';
import 'package:hesap/feature/reports/presentation/widgets/reports_top_consumed_list.dart';
import 'package:hesap/feature/reports/presentation/widgets/reports_trend_chart.dart';

final class ReportsContent extends StatelessWidget {
  const ReportsContent({super.key, required this.state});

  final ReportsUiState state;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.lg,
        AppSizes.sm,
        AppSizes.lg,
        AppSizes.xl,
      ),
      children: [
        ReportsSummaryGrid(summary: state.summary!),
        const SizedBox(height: AppSizes.md),
        ReportsTrendChart(series: state.summary!.dailyCostSeries),
        const SizedBox(height: AppSizes.md),
        ReportsTopConsumedList(items: state.topConsumed),
        const SizedBox(height: AppSizes.md),
        ReportsCsvExportButton(
          isExporting: state.isExporting,
          onExport: () {},
        ),
      ],
    );
  }
}
