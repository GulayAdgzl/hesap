import 'stock_alert.dart';
import 'weekly_consumption.dart';
import 'production_forecast.dart';

class HomeSummary {
  final double totalStockValue;
  final double dailyCost;
  final int criticalProductCount;
  final String? topConsumedProductName;
  final double? topConsumedAmount;
  final String? topConsumedUnit;
  final List<StockAlert> alerts;
  final List<WeeklyConsumption> weeklyConsumption;
  final List<ProductionForecast> productionForecasts;

  const HomeSummary({
    required this.totalStockValue,
    required this.dailyCost,
    required this.criticalProductCount,
    this.topConsumedProductName,
    this.topConsumedAmount,
    this.topConsumedUnit,
    required this.alerts,
    required this.weeklyConsumption,
    required this.productionForecasts,
  });

  bool get hasCritical => criticalProductCount > 0;
  bool get hasAlerts => alerts.isNotEmpty;
  bool get hasForecasts => productionForecasts.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeSummary &&
        other.totalStockValue == totalStockValue &&
        other.dailyCost == dailyCost &&
        other.criticalProductCount == criticalProductCount &&
        other.topConsumedProductName == topConsumedProductName &&
        other.topConsumedAmount == topConsumedAmount &&
        other.topConsumedUnit == topConsumedUnit;
  }

  @override
  int get hashCode => Object.hash(
        totalStockValue,
        dailyCost,
        criticalProductCount,
        topConsumedProductName,
        topConsumedAmount,
        topConsumedUnit,
      );

  @override
  String toString() => 'HomeSummary('
      'totalStockValue: $totalStockValue, '
      'dailyCost: $dailyCost, '
      'criticalProductCount: $criticalProductCount, '
      'topConsumedProductName: $topConsumedProductName)';
}
