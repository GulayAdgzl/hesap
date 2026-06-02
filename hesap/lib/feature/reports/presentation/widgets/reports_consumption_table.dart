import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_text_styles.dart';
import 'package:hesap/feature/stock/domain/entities/daily_stock_entry.dart';

class ReportsConsumptionTable extends StatelessWidget {
  final List<DailyStockEntry> entries;

  const ReportsConsumptionTable({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox();

    // Ürüne göre en son girişi al — aynı üründen birden fazla kayıt olabilir
    final Map<String, DailyStockEntry> latest = {};
    for (final e in entries) {
      final existing = latest[e.productId];
      if (existing == null || e.date.isAfter(existing.date)) {
        latest[e.productId] = e;
      }
    }

    final rows = latest.values.toList()
      ..sort((a, b) => a.productName.compareTo(b.productName));

    return Container(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Günlük Tüketim Tablosu',
              style: AppTextStyles.productName,
            ),
          ),
          const _TableHeader(),
          const Divider(height: 1, color: AppColors.inputBorder),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rows.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: AppColors.inputBorder),
            itemBuilder: (_, i) => _TableRow(entry: rows[i]),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('ÜRÜN', style: AppTextStyles.label),
          ),
          Expanded(
            child: Text('DÜN',
                style: AppTextStyles.label, textAlign: TextAlign.right),
          ),
          Expanded(
            child: Text('BUGÜN',
                style: AppTextStyles.label, textAlign: TextAlign.right),
          ),
          Expanded(
            child: Text('FARK',
                style: AppTextStyles.label, textAlign: TextAlign.right),
          ),
          Expanded(
            child: Text('MALİYET',
                style: AppTextStyles.label, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final DailyStockEntry entry;

  const _TableRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final diff = entry.consumed; // previousQuantity - currentQuantity
    final isConsumed = diff >= 0;
    final diffColor = isConsumed ? AppColors.danger : AppColors.success;
    final diffText =
        '${isConsumed ? "-" : "+"}${diff.abs()} ${entry.productUnit}';
    final costText = '₺${_fmt(entry.totalCost.abs())}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.inventory_2_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.productName,
                    style: AppTextStyles.productName.copyWith(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              '${entry.previousQuantity}',
              style: AppTextStyles.label,
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Text(
              '${entry.currentQuantity}',
              style: AppTextStyles.label,
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Text(
              diffText,
              style: AppTextStyles.label.copyWith(
                color: diffColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Text(
              costText,
              style: AppTextStyles.label.copyWith(
                color: diffColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(2);
  }
}
