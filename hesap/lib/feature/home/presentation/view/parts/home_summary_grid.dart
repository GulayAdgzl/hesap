part of '../home_page.dart';

final class _HomeSummaryGrid extends StatelessWidget {
  const _HomeSummaryGrid({required this.summary});

  final HomeSummary summary;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: AppSizes.sm,
      crossAxisSpacing: AppSizes.sm,
      childAspectRatio: 1.55,
      children: [
        SummaryCard.gradient(
          icon: Icons.inventory_2_rounded,
          title: AppStrings.homeTotalConsumption,
          value: summary.totalConsumption.toStringAsFixed(0),
          subtitle: AppStrings.homeTodayUnit,
        ),
        SummaryCard(
          icon: Icons.account_balance_wallet_rounded,
          iconColor: context.appTheme.warning,
          iconBg: context.appTheme.warningContainer,
          title: AppStrings.homeDailyCost,
          value: '₺${summary.dailyCost.toStringAsFixed(0)}',
          subtitle: AppStrings.homeVsYesterday,
        ),
        SummaryCard(
          icon: Icons.warning_amber_rounded,
          iconColor: context.appTheme.danger,
          iconBg: context.appTheme.dangerContainer,
          title: AppStrings.homeCriticalStock,
          value: summary.criticalProductCount.toString().padLeft(2, '0'),
          valueColor: context.appTheme.danger,
          subtitle: AppStrings.homeCriticalStockSubtitle,
        ),
        SummaryCard(
          icon: Icons.emoji_events_rounded,
          iconColor: context.appTheme.warning,
          iconBg: context.appTheme.warningContainer,
          cardBg: context.appTheme.warningContainer.withOpacity(0.5),
          title: AppStrings.homeTopConsumed,
          value: summary.topConsumedProductName ?? '—',
          subtitle: summary.topConsumedAmount != null
              ? '${summary.topConsumedAmount!.toStringAsFixed(0)} '
                  '${summary.topConsumedUnit ?? ''} ${AppStrings.homeToday}'
              : AppStrings.homeNoDataToday,
        ),
      ],
    );
  }
}
