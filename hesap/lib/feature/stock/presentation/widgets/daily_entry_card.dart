import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_decorations.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/constants/app_text_styles.dart';
import 'package:hesap/feature/stock/domain/entities/daily_stock_entry.dart';
import 'package:hesap/feature/stock/presentation/widgets/daily_entry_consumption_row.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';

class DailyEntryCard extends StatelessWidget {
  final Product product;
  final DailyStockEntry? lastEntry;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const DailyEntryCard({
    super.key,
    required this.product,
    required this.lastEntry,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final previousQty = lastEntry?.currentQuantity ?? product.quantity;
    final isCritical = product.maxStock > 0 &&
        (previousQty / product.maxStock) <= (product.criticalThreshold / 100);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: isCritical
          ? AppDecorations.entryCardCritical
          : AppDecorations.entryCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(product: product, isCritical: isCritical),
          const SizedBox(height: 14),
          _QuantityRow(
            product: product,
            previousQty: previousQty,
            isCritical: isCritical,
            controller: controller,
            onChanged: onChanged,
          ),
          DailyEntryConsumptionRow(
            controller: controller,
            previousQty: previousQty,
            unit: product.unit,
            price: product.price,
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final Product product;
  final bool isCritical;

  const _CardHeader({required this.product, required this.isCritical});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: isCritical
              ? AppDecorations.cardIconCritical
              : AppDecorations.cardIconNormal,
          child: Icon(
            Icons.inventory_2_rounded,
            size: 18,
            color: isCritical ? AppColors.danger : AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: AppTextStyles.productName),
            Text(product.unit, style: AppTextStyles.productMeta),
          ],
        ),
        if (isCritical) ...[
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: AppDecorations.criticalBadge,
            child: const Text(
              AppStrings.criticalLabel,
              style: AppTextStyles.criticalBadge,
            ),
          ),
        ],
      ],
    );
  }
}

class _QuantityRow extends StatelessWidget {
  final Product product;
  final int previousQty;
  final bool isCritical;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _QuantityRow({
    required this.product,
    required this.previousQty,
    required this.isCritical,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(AppStrings.yesterdayLabel, style: AppTextStyles.label),
              const SizedBox(height: 5),
              Text(
                '$previousQty ${product.unit}',
                style: isCritical
                    ? AppTextStyles.quantityLargeDanger
                    : AppTextStyles.quantityLarge,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(AppStrings.todayLabel, style: AppTextStyles.label),
              const SizedBox(height: 5),
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                onChanged: onChanged,
                decoration: AppDecorations.entryInputDecoration(),
                style: AppTextStyles.inputValue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
