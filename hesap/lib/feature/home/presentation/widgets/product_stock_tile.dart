import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';

import '../../domain/entities/product_stock.dart';

class _ProductVisual {
  final String emoji;
  const _ProductVisual(this.emoji);
}

_ProductVisual _visualFor(String name) {
  final n = name.toLowerCase();
  if (n.contains('un')) return const _ProductVisual('🌾');
  if (n.contains('tereyağ')) return const _ProductVisual('🧈');
  if (n.contains('şeker')) return const _ProductVisual('🍬');
  return const _ProductVisual('📦');
}

class ProductStockTile extends StatelessWidget {
  final ProductStock product;

  const ProductStockTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final visual = _visualFor(product.productName);
    final isCritical = product.consumedToday > 0 &&
        product.remainingAmount <= product.consumedToday * 1.5;
    final danger = context.appTheme.danger;
    final muted = context.appTheme.muted;
    final textPrimary = context.colors.onSurface;

    return Container(
      padding: const EdgeInsets.all(AppSizes.sm + 2),
      decoration: BoxDecoration(
        color: context.appTheme.cardBackground,
        borderRadius: AppRadius.lgBorderRadius,
        boxShadow: [
          BoxShadow(
              color: muted.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.avatarMd,
            height: AppSizes.avatarMd,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.appTheme.brandSecondary,
              borderRadius: AppRadius.mdBorderRadius,
            ),
            child: Text(visual.emoji, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      product.productName,
                      style: context.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    if (isCritical) ...[
                      const SizedBox(width: 6),
                      Icon(Icons.warning_amber_rounded,
                          size: AppSizes.iconXs + 1, color: danger),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  product.remainingFormatted,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isCritical ? danger : muted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '-${product.consumedToday.toStringAsFixed(0)}',
                style: context.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: danger,
                ),
              ),
              Text(
                '${product.unit} ${AppStrings.homeToday}',
                style: context.textTheme.labelSmall?.copyWith(color: danger),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
