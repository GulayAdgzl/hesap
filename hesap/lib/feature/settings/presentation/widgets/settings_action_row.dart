import 'package:flutter/material.dart';
import 'package:hesap/core/theme/theme.dart';

class SettingsActionRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String? subtitle;
  final String? value;
  final VoidCallback onTap;

  const SettingsActionRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
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
            // Değer + chevron
            if (value != null) ...[
              Text(
                value!,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.appTheme.muted,
                ),
              ),
              const SizedBox(width: AppSizes.xs),
            ],
            Icon(
              Icons.chevron_right_rounded,
              color: context.appTheme.inputHint,
              size: AppSizes.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}
