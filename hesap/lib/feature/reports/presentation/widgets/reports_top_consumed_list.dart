import 'package:flutter/material.dart';
import 'package:hesap/core/theme/theme.dart';
import 'package:hesap/module/report_summary/entities/top_consumed_item.dart';

class ReportsTopConsumedList extends StatelessWidget {
  final List<TopConsumedItem> items;

  const ReportsTopConsumedList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.base),
      decoration: BoxDecoration(
        color: context.appTheme.cardBackground,
        borderRadius: AppRadius.lgBorderRadius,
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'En Çok Tüketilen',
                style: context.textTheme.titleSmall,
              ),
              Text(
                'Bu hafta',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.appTheme.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          if (items.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.base),
                child: Text(
                  'Veri yok',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.appTheme.muted,
                  ),
                ),
              ),
            )
          else
            ...items.take(5).toList().asMap().entries.map(
                  (e) => _TopConsumedRow(
                    rank: e.key + 1,
                    item: e.value,
                    isLast: e.key == (items.length > 5 ? 4 : items.length - 1),
                  ),
                ),
        ],
      ),
    );
  }
}

class _TopConsumedRow extends StatelessWidget {
  final int rank;
  final TopConsumedItem item;
  final bool isLast;

  const _TopConsumedRow({
    required this.rank,
    required this.item,
    required this.isLast,
  });

  // Sabit podyum renkleri — tema ile değişmez, tasarım kararı
  static const Color _gold = Color(0xFFF5A623);
  static const Color _silver = Color(0xFF9090A8);
  static const Color _bronze = Color(0xFFCD7F32);

  @override
  Widget build(BuildContext context) {
    final rankColor = switch (rank) {
      1 => _gold,
      2 => _silver,
      3 => _bronze,
      _ => context.appTheme.muted,
    };

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.sm + 2),
          child: Row(
            children: [
              // Rank badge
              Container(
                width: AppSizes.xxl - 4,
                height: AppSizes.xxl - 4,
                decoration: BoxDecoration(
                  color: rankColor.withOpacity(0.12),
                  borderRadius: AppRadius.smBorderRadius,
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: context.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: rankColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              // Ürün ikonu
              Container(
                width: AppSizes.xxl + 4,
                height: AppSizes.xxl + 4,
                decoration: BoxDecoration(
                  color: context.appTheme.brandSecondary,
                  borderRadius: AppRadius.smBorderRadius,
                ),
                child: Icon(
                  Icons.inventory_2_rounded,
                  size: AppSizes.iconSm,
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(width: AppSizes.sm + 2),
              // Ad ve miktar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: context.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.totalConsumed} ${item.productUnit}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.appTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              // Maliyet
              Text(
                '₺${_formatCost(item.totalCost)}',
                style: context.textTheme.titleSmall?.copyWith(fontSize: 15),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            color: context.appTheme.divider,
          ),
      ],
    );
  }

  String _formatCost(double cost) {
    if (cost >= 1000) return '${(cost / 1000).toStringAsFixed(1)}K';
    return cost.toStringAsFixed(0);
  }
}
