import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/constants/app_text_styles.dart';
import 'package:hesap/feature/reports/presentation/bloc/reports_cubit.dart';
import 'package:hesap/feature/reports/presentation/bloc/reports_state.dart';

class ReportsCsvExportButton extends StatelessWidget {
  const ReportsCsvExportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        final isExporting = state is ReportsExporting;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isExporting
                ? null
                : () => context.read<ReportsCubit>().exportCsv(),
            icon: isExporting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.download_rounded,
                    color: Colors.white, size: 18),
            label: Text(
              isExporting ? AppStrings.exporting : AppStrings.csvExport,
              style: AppTextStyles.buttonText,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
          ),
        );
      },
    );
  }
}
