import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';

import '../../domain/entities/weekly_consumption.dart';

const _weekdayLabels = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

class WeeklyChartCard extends StatelessWidget {
  final WeeklyConsumption weekly;

  const WeeklyChartCard({super.key, required this.weekly});

  @override
  Widget build(BuildContext context) {
    final change = weekly.percentChangeFromLastWeek;
    final maxValue = weekly.maxValue == 0 ? 1.0 : weekly.maxValue;
    final primary = context.appTheme.brandPrimary;
    final success = context.appTheme.success;
    final danger = context.appTheme.danger;
    final muted = context.appTheme.muted;
    final textPrimary = context.colors.onSurface;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: context.appTheme.cardBackground,
        borderRadius: AppRadius.lgBorderRadius,
        boxShadow: [
          BoxShadow(
              color: muted.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.homeWeeklyConsumption,
                style: context.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              if (change != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm, vertical: 3),
                  decoration: BoxDecoration(
                    color: change >= 0
                        ? context.appTheme.successContainer
                        : context.appTheme.dangerContainer,
                    borderRadius: AppRadius.fullBorderRadius,
                  ),
                  child: Text(
                    '${change >= 0 ? '↑' : '↓'} %${(change.abs() * 100).toStringAsFixed(0)}',
                    style: context.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: change >= 0 ? success : danger,
                    ),
                  ),
                ),
            ],
          ),
          if (change != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                AppStrings.homeVsLastWeek,
                style: context.textTheme.labelSmall?.copyWith(color: muted),
              ),
            ),
          const SizedBox(height: AppSizes.md),
          SizedBox(
            height: 110,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekly.days.map((d) {
                final actualH = (d.actual / maxValue).clamp(0.0, 1.0) * 90;
                final forecastH = (d.forecast / maxValue).clamp(0.0, 1.0) * 90;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _Bar(height: actualH, color: primary),
                        const SizedBox(width: 3),
                        _Bar(height: forecastH, color: success),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _weekdayLabels[d.date.weekday - 1],
                      style:
                          context.textTheme.labelSmall?.copyWith(color: muted),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              _LegendDot(color: primary, label: AppStrings.homeActualLegend),
              const SizedBox(width: AppSizes.base),
              _LegendDot(color: success, label: AppStrings.homeForecastLegend),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final Color color;

  const _Bar({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: height < 3 ? 3 : height,
      decoration:
          BoxDecoration(color: color, borderRadius: AppRadius.xsBorderRadius),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label,
            style: context.textTheme.labelSmall
                ?.copyWith(color: context.appTheme.muted)),
      ],
    );
  }
}
