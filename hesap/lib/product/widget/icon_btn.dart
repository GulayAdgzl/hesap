import 'package:flutter/material.dart';
import 'package:hesap/core/theme/theme.dart';

class IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const IconBtn({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.xxl + AppSizes.xs,
        height: AppSizes.xxl + AppSizes.xs,
        decoration: BoxDecoration(
          color: context.appTheme.cardBackground,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: context.colors.primary.withOpacity(0.08),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: AppSizes.iconMd - 2,
          color: context.colors.onSurface,
        ),
      ),
    );
  }
}
