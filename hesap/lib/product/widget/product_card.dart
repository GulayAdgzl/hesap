import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/theme.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ratio =
        product.maxStock > 0 ? product.quantity / product.maxStock : 0.0;
    final status = _stockStatus(context, ratio);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.xs + 1,
      ),
      padding: const EdgeInsets.all(AppSizes.base),
      decoration: BoxDecoration(
        color: context.appTheme.cardBackground,
        borderRadius: AppRadius.lgBorderRadius,
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Ürün ikonu
              Container(
                width: AppSizes.huge - AppSizes.xs,
                height: AppSizes.huge - AppSizes.xs,
                decoration: BoxDecoration(
                  color: status.bgColor,
                  borderRadius: AppRadius.smBorderRadius,
                ),
                child: const Center(
                  child: Text('📦', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: context.textTheme.labelLarge),
                    const SizedBox(height: 2),
                    Text(
                      'Birim: ${product.unit} · ₺${product.price}/${product.unit}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.appTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              _ActionButton(
                icon: '✏️',
                color: context.appTheme.brandSecondary,
                onTap: onEdit,
              ),
              const SizedBox(width: AppSizes.xs + 2),
              _ActionButton(
                icon: '🗑️',
                color: context.appTheme.dangerContainer,
                onTap: onDelete,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Column(
            children: [
              ClipRRect(
                borderRadius: AppRadius.xsBorderRadius,
                child: LinearProgressIndicator(
                  value: ratio.clamp(0.0, 1.0),
                  minHeight: 5,
                  backgroundColor: context.appTheme.brandSecondary,
                  valueColor: AlwaysStoppedAnimation(status.barColor),
                ),
              ),
              const SizedBox(height: AppSizes.xs + 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppStrings.remaining}: ${product.quantity} ${product.unit}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: status.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${AppStrings.max} ${product.maxStock} ${product.unit}',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.appTheme.muted,
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm + 2,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: status.bgColor,
                          borderRadius: AppRadius.fullBorderRadius,
                        ),
                        child: Text(
                          status.label,
                          style: context.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: status.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _StockStatus _stockStatus(BuildContext context, double ratio) {
    if (ratio <= 0.1) {
      return _StockStatus(
        label: AppStrings.statusCritical,
        barColor: context.appTheme.danger,
        bgColor: context.appTheme.dangerContainer,
        textColor: context.appTheme.danger,
      );
    } else if (ratio <= 0.4) {
      return _StockStatus(
        label: AppStrings.statusWarning,
        barColor: context.appTheme.warning,
        bgColor: context.appTheme.warningContainer,
        textColor: context.appTheme.warning,
      );
    } else {
      return _StockStatus(
        label: AppStrings.statusNormal,
        barColor: context.appTheme.success,
        bgColor: context.appTheme.successContainer,
        textColor: context.appTheme.success,
      );
    }
  }
}

class _StockStatus {
  final String label;
  final Color barColor;
  final Color bgColor;
  final Color textColor;

  const _StockStatus({
    required this.label,
    required this.barColor,
    required this.bgColor,
    required this.textColor,
  });
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.xxl - 2,
        height: AppSizes.xxl - 2,
        decoration: BoxDecoration(
          color: color,
          borderRadius: AppRadius.smBorderRadius,
        ),
        child: Center(
          child: Text(icon, style: const TextStyle(fontSize: 13)),
        ),
      ),
    );
  }
}
