import 'package:flutter/material.dart';
import 'package:hesap/core/theme/theme.dart';
import 'package:hesap/core/widgets/app_gap.dart';

// summary_card.dart
final class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    this.iconColor,
    this.iconBg,
    this.cardBg,
    this.valueColor,
    this.isGradient = false,
  });

  factory SummaryCard.gradient({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return SummaryCard(
      icon: icon,
      title: title,
      value: value,
      subtitle: subtitle,
      isGradient: true,
      valueColor: Colors.white,
    );
  }

  final IconData icon;
  final Color? iconColor;
  final Color? iconBg;
  final Color? cardBg;
  final String title;
  final String value;
  final Color? valueColor;
  final String subtitle;
  final bool isGradient;

  @override
  Widget build(BuildContext context) {
    const onGradientColor = Colors.white;
    final mutedColor = context.appTheme.muted;
    final surfaceColor = context.appTheme.cardBackground;
    final primary = context.appTheme.brandPrimary;
    final textPrimary = context.colors.onSurface;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: isGradient ? null : (cardBg ?? surfaceColor),
        gradient: isGradient
            ? LinearGradient(
                colors: [primary.withOpacity(0.9), primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: AppRadius.lgBorderRadius,
        boxShadow: [
          BoxShadow(
            color: mutedColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: AppSizes.avatarSm + 2,
            height: AppSizes.avatarSm + 2,
            decoration: BoxDecoration(
              color: isGradient
                  ? Colors.white.withOpacity(0.2)
                  : (iconBg ?? context.appTheme.brandSecondary),
              borderRadius: AppRadius.mdBorderRadius,
            ),
            child: Icon(
              icon,
              size: AppSizes.iconSm + 2,
              color: isGradient ? onGradientColor : (iconColor ?? primary),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.labelSmall?.copyWith(
                  color: isGradient
                      ? onGradientColor.withOpacity(0.85)
                      : mutedColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppGap.xxs,
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: valueColor ?? textPrimary,
                ),
              ),
              AppGap.xxs,
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelSmall?.copyWith(
                  color: isGradient
                      ? onGradientColor.withOpacity(0.75)
                      : mutedColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
