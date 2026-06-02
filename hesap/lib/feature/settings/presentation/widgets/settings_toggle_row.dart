import 'package:flutter/material.dart';

import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_text_styles.dart';

class SettingsToggleRow extends StatelessWidget {
  final IconData icon;
  final BoxDecoration iconBoxDecoration;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleRow({
    super.key,
    required this.icon,
    required this.iconBoxDecoration,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          // Toggle
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.settingsToggleActive,
            activeTrackColor: AppColors.primaryLight,
            inactiveThumbColor: AppColors.muted,
            inactiveTrackColor: AppColors.inputFill,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }
}
