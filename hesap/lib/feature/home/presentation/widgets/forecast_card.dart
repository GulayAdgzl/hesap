import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';

import '../../domain/entities/production_forecast.dart';

class ForecastCard extends StatelessWidget {
  final List<ProductionForecast> forecasts;

  const ForecastCard({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg - 2),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: AppRadius.lgBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.homeProductionForecast,
                style: context.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm + 2, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: AppRadius.fullBorderRadius,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome_rounded,
                        size: AppSizes.iconXs, color: Colors.white),
                    SizedBox(width: 4),
                    Text('AI',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          for (int i = 0; i < forecasts.length; i++) ...[
            _ForecastRow(forecast: forecasts[i]),
            if (i != forecasts.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.sm + 2),
                child:
                    Divider(height: 1, color: Colors.white.withOpacity(0.12)),
              ),
          ],
        ],
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  final ProductionForecast forecast;

  const _ForecastRow({required this.forecast});

  @override
  Widget build(BuildContext context) {
    final trendLabel = switch (forecast.trend) {
      ForecastTrend.increasing => AppStrings.homeTrendIncreasing,
      ForecastTrend.decreasing => AppStrings.homeTrendDecreasing,
      ForecastTrend.stable => AppStrings.homeTrendStable,
    };
    final trendColor = switch (forecast.trend) {
      ForecastTrend.increasing => context.appTheme.success,
      ForecastTrend.decreasing => context.appTheme.danger,
      ForecastTrend.stable => Colors.white70,
    };

    return Row(
      children: [
        Container(
          width: AppSizes.avatarSm + 2,
          height: AppSizes.avatarSm + 2,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: AppRadius.mdBorderRadius,
          ),
          child: const Icon(Icons.grain_rounded,
              size: AppSizes.iconSm, color: Colors.white70),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                forecast.productName,
                style: context.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(trendLabel,
                  style: context.textTheme.labelSmall
                      ?.copyWith(color: trendColor)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              forecast.forecastAmount.toStringAsFixed(0),
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: forecast.isDecreasing
                    ? context.appTheme.danger
                    : Colors.white,
              ),
            ),
            Text(
              '${forecast.unit} ${AppStrings.homeTargetSuffix}',
              style:
                  context.textTheme.labelSmall?.copyWith(color: Colors.white54),
            ),
          ],
        ),
      ],
    );
  }
}
