import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/constants/app_text_styles.dart';

class DailyEntryHeader extends StatelessWidget {
  const DailyEntryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = [
      'Pazar',
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi'
    ];
    final months = [
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
      'Aralık'
    ];
    final dateStr =
        '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]} ${now.year}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dateStr, style: AppTextStyles.dateCaption),
          const SizedBox(height: 4),
          const Text(AppStrings.dailyEntryTitle,
              style: AppTextStyles.pageTitle),
          const SizedBox(height: 4),
          const Text(AppStrings.dailyEntrySubtitle,
              style: AppTextStyles.pageSubtitle),
        ],
      ),
    );
  }
}
