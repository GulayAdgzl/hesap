import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_text_styles.dart';
import 'package:hesap/feature/reports/presentation/bloc/reports_cubit.dart';
import 'package:hesap/feature/reports/presentation/bloc/reports_state.dart';
import 'package:hesap/feature/reports/presentation/widgets/reports_csv_export_button.dart';
import 'package:hesap/feature/reports/presentation/widgets/reports_filter_bar.dart';
import 'package:hesap/feature/reports/presentation/widgets/reports_summary_grid.dart';
import 'package:hesap/feature/reports/presentation/widgets/reports_top_consumed_list.dart';
import 'package:hesap/feature/reports/presentation/widgets/reports_trend_chart.dart';
import 'package:hesap/module/report_summary/entities/report_filter.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReportsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<ReportsCubit, ReportsState>(
        listener: (context, state) {
          if (state is ReportsExportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.danger,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ReportsHeader(),
              BlocBuilder<ReportsCubit, ReportsState>(
                builder: (context, state) {
                  final filter = state is ReportsLoaded
                      ? state.filter
                      : const ReportFilter();
                  return ReportsFilterBar(
                    filter: filter,
                    onChanged: (f) =>
                        context.read<ReportsCubit>().changeFilter(f),
                  );
                },
              ),
              Expanded(
                child: BlocBuilder<ReportsCubit, ReportsState>(
                  builder: (context, state) {
                    if (state is ReportsLoading) {
                      return const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.primary),
                      );
                    }

                    if (state is ReportsError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: AppColors.danger),
                        ),
                      );
                    }

                    if (state is ReportsLoaded) {
                      return ListView(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                        children: [
                          ReportsSummaryGrid(summary: state.summary),
                          const SizedBox(height: 12),
                          ReportsTrendChart(
                              series: state.summary.dailyCostSeries),
                          const SizedBox(height: 12),
                          ReportsTopConsumedList(items: state.topConsumed),
                          const SizedBox(height: 12),
                          const ReportsCsvExportButton(),
                        ],
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportsHeader extends StatelessWidget {
  const _ReportsHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Raporlar', style: AppTextStyles.pageTitle),
              const SizedBox(height: 2),
              Text(
                'Tüketim ve maliyet analizi',
                style: AppTextStyles.pageSubtitle,
              ),
            ],
          ),
          BlocBuilder<ReportsCubit, ReportsState>(
            builder: (context, state) {
              final isExporting = state is ReportsExporting;
              return IconButton(
                onPressed: isExporting
                    ? null
                    : () => context.read<ReportsCubit>().exportCsv(),
                icon: isExporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.primary),
                      )
                    : const Icon(Icons.ios_share_rounded,
                        color: AppColors.muted, size: 22),
              );
            },
          ),
        ],
      ),
    );
  }
}
