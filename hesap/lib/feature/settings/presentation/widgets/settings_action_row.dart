import 'package:flutter/material.dart';

import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_text_styles.dart';

class SettingsActionRow extends StatelessWidget {
  final IconData icon;
  final BoxDecoration iconBoxDecoration;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final String? value;
  final VoidCallback onTap;

  const SettingsActionRow({
    super.key,
    required this.icon,
    required this.iconBoxDecoration,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 36,
              height: 36,
              decoration: iconBoxDecoration,
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.settingsRowTitle),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: AppTextStyles.settingsRowSubtitle),
                  ],
                ],
              ),
            ),
            // Value + chevron
            if (value != null) ...[
              Text(value!, style: AppTextStyles.settingsRowValue),
              const SizedBox(width: 4),
            ],
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.settingsChevron,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
