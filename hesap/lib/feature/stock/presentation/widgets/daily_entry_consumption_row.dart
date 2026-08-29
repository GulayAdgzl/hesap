import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';

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
    final statusColor =
        isConsumed ? context.appTheme.danger : context.appTheme.success;
    final containerColor = isConsumed
        ? context.appTheme.dangerContainer
        : context.appTheme.successContainer;

    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.sm + 2),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: AppRadius.smBorderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isConsumed ? AppStrings.consumptionLabel : AppStrings.addedLabel,
              style: context.textTheme.labelSmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${isConsumed ? "-" : "+"}${diff.abs()} $unit  ·  ₺${(diff.abs() * price).toStringAsFixed(2)}',
              style: context.textTheme.labelSmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
