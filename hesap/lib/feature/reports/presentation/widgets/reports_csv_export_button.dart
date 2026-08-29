import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';

/// CSV dışa aktarma butonu.
///
/// Bloc bağımlılığı kaldırıldı — durum ve aksiyon dışarıdan enjekte edilir.
final class ReportsCsvExportButton extends StatelessWidget {
  const ReportsCsvExportButton({
    super.key,
    required this.isExporting,
    required this.onExport,
  });

  final bool isExporting;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isExporting ? null : onExport,
        icon: isExporting
            ? SizedBox(
                width: AppSizes.iconSm,
                height: AppSizes.iconSm,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.colors.onPrimary,
                ),
              )
            : Icon(
                Icons.download_rounded,
                color: context.colors.onPrimary,
                size: AppSizes.iconMd - 2,
              ),
        label: Text(
          isExporting ? AppStrings.exporting : AppStrings.csvExport,
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colors.onPrimary,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.primary,
          disabledBackgroundColor: context.colors.primary.withOpacity(0.6),
          padding: const EdgeInsets.symmetric(vertical: AppSizes.md + 2),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.baseBorderRadius,
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
