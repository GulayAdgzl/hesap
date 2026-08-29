import 'package:flutter/material.dart';
import 'package:hesap/core/theme/theme.dart';
import 'package:hesap/module/report_summary/entities/report_summary.dart';

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
      crossAxisSpacing: AppSizes.md,
      mainAxisSpacing: AppSizes.md,
      childAspectRatio: 1.55,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _SummaryCard(
          icon: Icons.scale_rounded,
          iconColor: context.colors.primary,
          iconBg: context.appTheme.brandSecondary,
          label: 'Toplam Tüketim',
          value: summary.totalConsumption.toString(),
        ),
        _SummaryCard(
          icon: Icons.account_balance_wallet_rounded,
          iconColor: context.appTheme.success,
          iconBg: context.appTheme.successContainer,
          label: 'Toplam Maliyet',
          value: '₺${_formatK(summary.totalCost)}',
        ),
        _SummaryCard(
          icon: Icons.trending_up_rounded,
          iconColor: changePositive
              ? context.appTheme.danger
              : context.appTheme.success,
          iconBg: changePositive
              ? context.appTheme.dangerContainer
              : context.appTheme.successContainer,
          label: 'Geçen haftaya göre',
          value: changeText ?? '—',
          valueColor: change == null
              ? context.appTheme.muted
              : (changePositive
                  ? context.appTheme.danger
                  : context.appTheme.success),
        ),
        _SummaryCard(
          icon: Icons.bolt_rounded,
          iconColor: context.appTheme.warning,
          iconBg: context.appTheme.warningContainer,
          label: 'Günlük ortalama',
          value: '₺${_formatK(summary.dailyAverageCost)}',
        ),
      ],
    );
  }

  String _formatK(double value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
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
      padding: const EdgeInsets.all(AppSizes.md + 2),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: AppSizes.xxxl - 6,
            height: AppSizes.xxxl - 6,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: AppRadius.smBorderRadius,
            ),
            child: Icon(icon, size: AppSizes.iconSm + 4, color: iconColor),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: context.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  color: valueColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.appTheme.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
