import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';

import '../../domain/entities/stock_alert.dart';

class AlertCard extends StatelessWidget {
  final StockAlert alert;

  const AlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final danger = context.appTheme.danger;
    final dangerContainer = context.appTheme.dangerContainer;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: dangerContainer,
        borderRadius: AppRadius.lgBorderRadius,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: danger.withOpacity(0.15),
              borderRadius: AppRadius.mdBorderRadius,
            ),
            child: Icon(Icons.notifications_active_rounded,
                color: danger, size: AppSizes.iconSm + 2),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppStrings.homeAlertCriticalPrefix}${alert.productName}',
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: danger,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${AppStrings.homeAlertRemainingPrefix} ${alert.remainingFormatted} · '
                  '${AppStrings.homeAlertEstimatedEnd}: ${alert.estimatedDaysLeftFormatted}',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: danger.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: danger.withOpacity(0.75)),
        ],
      ),
    );
  }
}
