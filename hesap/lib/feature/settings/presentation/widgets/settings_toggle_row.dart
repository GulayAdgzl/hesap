import 'package:flutter/material.dart';
import 'package:hesap/core/theme/theme.dart';

class SettingsToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.base,
        vertical: AppSizes.md,
      ),
      child: Row(
        children: [
          // İkon kutusu
          Container(
            width: AppSizes.xxl + AppSizes.xs,
            height: AppSizes.xxl + AppSizes.xs,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: AppRadius.smBorderRadius,
            ),
            child: Icon(icon, color: iconColor, size: AppSizes.iconMd - 2),
          ),
          const SizedBox(width: AppSizes.md),
          // Başlık + alt başlık
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textTheme.labelLarge),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.appTheme.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Switch — renkleri ThemeData.switchTheme'den otomatik geliyor
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
