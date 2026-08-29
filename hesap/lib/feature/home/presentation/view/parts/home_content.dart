part of '../home_page.dart';

final class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.state,
    required this.onRefresh,
    required this.onSeeAllProductsTap,
  });

  final HomeViewState state;
  final Future<void> Function() onRefresh;
  final VoidCallback onSeeAllProductsTap;

  @override
  Widget build(BuildContext context) {
    final summary = state.summary!;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSizes.lg,
          AppSizes.sm,
          AppSizes.lg,
          AppSizes.xl,
        ),
        children: [
          if (state.isRefreshing) const _HomeRefreshingBadge(),
          _HomeSummaryGrid(summary: summary),
          AppGap.xl,
          _HomeSectionTitle(
            title: AppStrings.homeConsumptionFlow,
            trailing: AppStrings.homeLast7Days,
          ),
          AppGap.md,
          WeeklyChartCard(weekly: summary.weeklyConsumption),
          if (summary.hasAlerts) ...[
            AppGap.xl,
            const _HomeSectionTitle(title: AppStrings.homeAlerts),
            AppGap.md,
            ...summary.alerts.take(3).map(
                  (alert) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.sm),
                    child: AlertCard(alert: alert),
                  ),
                ),
          ],
          AppGap.xl,
          _HomeSectionTitle(
            title: AppStrings.homeProductStocks,
            trailing: AppStrings.homeSeeAll,
            onTrailingTap: onSeeAllProductsTap,
          ),
          AppGap.md,
          // productStocks tüketime göre azalan sıralı geliyor (HomeRepositoryImpl)
          ...summary.productStocks.take(3).map(
                (product) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.sm),
                  child: ProductStockTile(product: product),
                ),
              ),
          if (summary.hasForecasts) ...[
            AppGap.xl,
            const _HomeSectionTitle(
              title: AppStrings.homeTomorrowForecast,
              trailing: AppStrings.homeAiForecast,
            ),
            AppGap.md,
            ForecastCard(
              forecasts: summary.productionForecasts.take(3).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

final class _HomeRefreshingBadge extends StatelessWidget {
  const _HomeRefreshingBadge();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: AppSizes.iconSm,
          height: AppSizes.iconSm,
          child: CircularProgressIndicator(
            strokeWidth: AppSizes.borderWidthThick,
          ),
        ),
      ),
    );
  }
}
