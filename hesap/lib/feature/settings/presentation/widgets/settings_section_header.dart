import 'package:flutter/material.dart';
import 'package:hesap/core/theme/theme.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSizes.xs, bottom: 2),
      child: Text(
        title,
        style: context.textTheme.labelSmall?.copyWith(
          color: context.appTheme.muted,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
