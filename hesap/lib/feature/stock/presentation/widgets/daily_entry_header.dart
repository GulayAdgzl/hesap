import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';

class DailyEntryHeader extends StatelessWidget {
  const DailyEntryHeader({super.key});

  static const _days = [
    'Pazar',
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
  ];

  static const _months = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr =
        '${_days[now.weekday % 7]}, ${now.day} ${_months[now.month - 1]} ${now.year}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.lg,
        AppSizes.base,
        AppSizes.lg,
        AppSizes.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateStr,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.appTheme.muted,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(AppStrings.dailyEntryTitle, style: context.textTheme.titleLarge),
          const SizedBox(height: AppSizes.xs),
          Text(
            AppStrings.dailyEntrySubtitle,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.appTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}
