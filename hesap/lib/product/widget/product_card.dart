import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/constants/app_text_styles.dart';
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
    final status = _stockStatus(ratio);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: status.bgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text('📦', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: AppTextStyles.productName),
                    const SizedBox(height: 2),
                    Text(
                      'Birim: ${product.unit} · ₺${product.price}/${product.unit}',
                      style: AppTextStyles.productMeta,
                    ),
                  ],
                ),
              ),
              _ActionButton(
                icon: '✏️',
                color: AppColors.primaryLight,
                onTap: onEdit,
              ),
              const SizedBox(width: 6),
              _ActionButton(
                icon: '🗑️',
                color: AppColors.dangerLight,
                onTap: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: ratio.clamp(0.0, 1.0),
                  minHeight: 5,
                  backgroundColor: AppColors.primaryLight,
                  valueColor: AlwaysStoppedAnimation(status.barColor),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppStrings.remaining}: ${product.quantity} ${product.unit}',
                    style: AppTextStyles.caption.copyWith(
                      color: status.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${AppStrings.max} ${product.maxStock} ${product.unit}',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: status.bgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status.label,
                          style: AppTextStyles.caption.copyWith(
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

  _StockStatus _stockStatus(double ratio) {
    if (ratio <= 0.1) {
      return _StockStatus(
        label: AppStrings.statusCritical,
        barColor: AppColors.danger,
        bgColor: AppColors.dangerLight,
        textColor: AppColors.danger,
      );
    } else if (ratio <= 0.4) {
      return _StockStatus(
        label: AppStrings.statusWarning,
        barColor: AppColors.warning,
        bgColor: AppColors.warningLight,
        textColor: AppColors.warning,
      );
    } else {
      return _StockStatus(
        label: AppStrings.statusNormal,
        barColor: AppColors.success,
        bgColor: AppColors.successLight,
        textColor: AppColors.success,
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
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(icon, style: const TextStyle(fontSize: 13)),
        ),
      ),
    );
  }
}
