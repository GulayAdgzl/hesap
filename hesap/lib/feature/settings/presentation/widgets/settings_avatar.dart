import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';

class SettingsAvatar extends StatelessWidget {
  const SettingsAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(AppStrings.appName);

    return Center(
      child: Container(
        width: AppSizes.huge + AppSizes.xxxl, // 48 + 40 = 88
        height: AppSizes.huge + AppSizes.xxxl,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.colors.primary,
              context.colors.primary.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppRadius.xlBorderRadius,
          boxShadow: [
            BoxShadow(
              color: context.colors.primary.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            initials,
            style: context.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }
}
