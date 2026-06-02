import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_decorations.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/constants/app_text_styles.dart';

class DailyEntryConsumptionRow extends StatelessWidget {
  final TextEditingController controller;
  final int previousQty;
  final String unit;
  final double price;

  const DailyEntryConsumptionRow({
    super.key,
    required this.controller,
    required this.previousQty,
    required this.unit,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final val = int.tryParse(controller.text);
    if (val == null) return const SizedBox();

    final diff = previousQty - val;
    final isConsumed = diff >= 0;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isConsumed
            ? AppDecorations.consumptionRowConsumed
            : AppDecorations.consumptionRowAdded,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isConsumed ? AppStrings.consumptionLabel : AppStrings.addedLabel,
              style: AppTextStyles.consumptionLabel.copyWith(
                color: isConsumed ? AppColors.danger : AppColors.success,
              ),
            ),
            Text(
              '${isConsumed ? "-" : "+"}${diff.abs()} $unit  ·  ₺${(diff.abs() * price).toStringAsFixed(2)}',
              style: AppTextStyles.consumptionValue.copyWith(
                color: isConsumed ? AppColors.danger : AppColors.success,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
