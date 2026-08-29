import 'package:flutter/material.dart';
import 'package:hesap/core/theme/theme.dart';

final class ReportsHeader extends StatelessWidget {
  const ReportsHeader({
    super.key,
    required this.isExporting,
    required this.onExport,
  });

  final bool isExporting;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.lg,
        AppSizes.base,
        AppSizes.lg,
        AppSizes.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Raporlar', style: context.textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(
                'Tüketim ve maliyet analizi',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.appTheme.muted,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: isExporting ? null : onExport,
            icon: isExporting
                ? SizedBox(
                    width: AppSizes.iconMd,
                    height: AppSizes.iconMd,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.colors.primary,
                    ),
                  )
                : Icon(
                    Icons.ios_share_rounded,
                    color: context.appTheme.muted,
                    size: AppSizes.iconBase - 2,
                  ),
          ),
        ],
      ),
    );
  }
}
