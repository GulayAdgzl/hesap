import 'package:flutter/material.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_text_styles.dart';
import 'package:hesap/features/reports/domain/entities/report_summary.dart';

class ReportsSummaryGrid extends StatelessWidget {
  final ReportSummary summary;

  const ReportsSummaryGrid({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final change = summary.consumptionChangePercent;
    final changeText = change == null
        ? null
        : '${change >= 0 ? "+" : ""}${change.toStringAsFixed(1)}%';
    final changePositive = change != null && change >= 0;

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.55,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _SummaryCard(
          icon: Icons.scale_rounded,
          iconColor: AppColors.primary,
          iconBg: AppColors.primaryLight,
          label: 'Toplam Tüketim',
          value: summary.totalConsumption.toString(),
        ),
        _SummaryCard(
          icon: Icons.account_balance_wallet_rounded,
          iconColor: AppColors.success,
          iconBg: AppColors.successLight,
          label: 'Toplam Maliyet',
          value: '₺${summary.totalCost.toStringAsFixed(1)}K'
              .replaceAll(RegExp(r'(\d+\.\d+)K'), _formatK(summary.totalCost)),
        ),
        _SummaryCard(
          icon: Icons.trending_up_rounded,
          iconColor: changePositive ? AppColors.danger : AppColors.success,
          iconBg:
              changePositive ? AppColors.dangerLight : AppColors.successLight,
          label: 'Geçen haftaya göre',
          value: changeText ?? '—',
          valueColor:
              change == null ? AppColors.muted : (changePositive ? AppColors.danger : AppColors.success),
        ),
        _SummaryCard(
          icon: Icons.bolt_rounded,
          iconColor: AppColors.warning,
          iconBg: AppColors.warningLight,
          label: 'Günlük ortalama',
          value: '₺${_formatK(summary.dailyAverageCost)}',
        ),
      ],
    );
  }

  String _formatK(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.quantityLarge.copyWith(
                  fontSize: 20,
                  color: valueColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(label, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}