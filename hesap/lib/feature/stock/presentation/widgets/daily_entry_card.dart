import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';
import 'package:hesap/feature/stock/domain/entities/daily_stock_entry.dart';
import 'package:hesap/feature/stock/presentation/widgets/daily_entry_consumption_row.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';

/// Ürün adına göre emoji + zemin rengi eşleşmesi.
/// Not: Home feature'ındaki ProductStockTile._visualFor ile aynı mantık —
/// ileride tekrarı önlemek için ortak bir core/widgets katmanına taşınabilir.
final class _ProductVisual {
  const _ProductVisual(this.emoji, this.bgColorBuilder);

  final String emoji;
  final Color Function(BuildContext context) bgColorBuilder;
}

_ProductVisual _visualFor(String name) {
  final n = name.toLowerCase();
  if (n.contains('un')) {
    return _ProductVisual('🌾', (c) => c.appTheme.brandSecondary);
  }
  if (n.contains('tereyağ')) {
    return _ProductVisual('🧈', (c) => c.appTheme.warningContainer);
  }
  if (n.contains('şeker')) {
    return _ProductVisual('🍬', (c) => c.appTheme.dangerContainer);
  }
  if (n.contains('süt')) {
    return _ProductVisual('🥛', (c) => c.appTheme.successContainer);
  }
  return _ProductVisual('📦', (c) => c.appTheme.brandSecondary);
}

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
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.base),
      decoration: BoxDecoration(
        color: context.appTheme.cardBackground,
        borderRadius: AppRadius.baseBorderRadius,
        border: isCritical
            ? Border.all(
                color: context.appTheme.danger.withOpacity(0.35),
                width: 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isCritical
                ? context.appTheme.danger.withOpacity(0.08)
                : context.colors.primary.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(product: product, isCritical: isCritical),
          const SizedBox(height: AppSizes.md + 2),
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
    final visual = _visualFor(product.name);
    // Kritik durumda kutunun zemini her zaman dangerContainer'a döner;
    // normalde ürüne özel renk kullanılır.
    final boxBg = isCritical
        ? context.appTheme.dangerContainer
        : visual.bgColorBuilder(context);

    return Row(
      children: [
        Container(
          width: AppSizes.xxxl,
          height: AppSizes.xxxl,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: boxBg,
            borderRadius: AppRadius.smBorderRadius,
          ),
          child: Text(visual.emoji, style: const TextStyle(fontSize: 18)),
        ),
        const SizedBox(width: AppSizes.sm + 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name, style: context.textTheme.labelLarge),
            Text(
              product.unit,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.appTheme.muted,
              ),
            ),
          ],
        ),
        // Not: Kritik rozeti burada değil — "DÜN KALAN" değerinin yanında
        // satır içi uyarı ikonu olarak gösteriliyor (bkz. _QuantityRow).
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
    final danger = context.appTheme.danger;
    final inputBorderColor = isCritical ? danger : context.appTheme.divider;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.yesterdayLabel,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.appTheme.muted,
                ),
              ),
              const SizedBox(height: AppSizes.xs + 1),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$previousQty ${product.unit}',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: isCritical ? danger : null,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (isCritical) ...[
                    const SizedBox(width: AppSizes.xs),
                    Icon(
                      Icons.warning_amber_rounded,
                      size: AppSizes.iconSm - 2,
                      color: danger,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.todayLabel,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.appTheme.muted,
                ),
              ),
              const SizedBox(height: AppSizes.xs + 1),
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                onChanged: onChanged,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.sm + 2,
                  ),
                  hintText: '0',
                  hintStyle: TextStyle(color: context.appTheme.inputHint),
                  filled: true,
                  fillColor: context.appTheme.inputFill,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.smBorderRadius,
                    borderSide: BorderSide(
                      color: inputBorderColor,
                      width: isCritical ? 1.5 : 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.smBorderRadius,
                    borderSide: BorderSide(
                      color: inputBorderColor,
                      width: isCritical ? 1.5 : 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.smBorderRadius,
                    borderSide: BorderSide(
                      color: isCritical ? danger : context.colors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
