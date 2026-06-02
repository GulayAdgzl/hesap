import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_text_styles.dart';
import 'package:hesap/module/report_summary/entities/top_consumed_item.dart';

class ReportsTopConsumedList extends StatelessWidget {
  final List<TopConsumedItem> items;

  const ReportsTopConsumedList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
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
              const Text('En Çok Tüketilen', style: AppTextStyles.sectionTitle),
              Text('Bu hafta', style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child:
                    Text('Veri yok', style: TextStyle(color: AppColors.muted)),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              // Rank badge
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _rankColor(rank).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _rankColor(rank),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Ürün ikonu
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.inventory_2_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              // Ad ve miktar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productName, style: AppTextStyles.productName),
                    const SizedBox(height: 2),
                    Text(
                      '${item.totalConsumed} ${item.productUnit}',
                      style: AppTextStyles.productMeta,
                    ),
                  ],
                ),
              ),
              // Maliyet
              Text(
                '₺${_formatCost(item.totalCost)}',
                style: AppTextStyles.quantityLarge.copyWith(fontSize: 15),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.inputBorder,
          ),
      ],
    );
  }

  Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFF5A623); // altın
      case 2:
        return const Color(0xFF9090A8); // gümüş
      case 3:
        return const Color(0xFFCD7F32); // bronz
      default:
        return AppColors.muted;
    }
  }

  String _formatCost(double cost) {
    if (cost >= 1000) return '${(cost / 1000).toStringAsFixed(1)}K';
    return cost.toStringAsFixed(0);
  }
}
