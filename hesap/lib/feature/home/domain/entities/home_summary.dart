import 'package:hesap/feature/home/domain/entities/product_stock.dart';

import 'production_forecast.dart';
import 'stock_alert.dart';
import 'weekly_consumption.dart';

class HomeSummary {
  final double totalConsumption; // "Toplam Tüketim" kartı — kg/gün
  final double dailyCost;
  final int criticalProductCount;
  final String? topConsumedProductName;
  final double? topConsumedAmount;
  final String? topConsumedUnit;
  final List<StockAlert> alerts;
  final WeeklyConsumption weeklyConsumption;
  final List<ProductionForecast> productionForecasts;
  final List<ProductStock> productStocks;

  const HomeSummary({
    required this.totalConsumption,
    required this.dailyCost,
    required this.criticalProductCount,
    this.topConsumedProductName,
    this.topConsumedAmount,
    this.topConsumedUnit,
    required this.alerts,
    required this.weeklyConsumption,
    required this.productionForecasts,
    required this.productStocks,
  });

  bool get hasCritical => criticalProductCount > 0;
  bool get hasAlerts => alerts.isNotEmpty;
  bool get hasForecasts => productionForecasts.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeSummary &&
        other.totalConsumption == totalConsumption &&
        other.dailyCost == dailyCost &&
        other.criticalProductCount == criticalProductCount &&
        other.topConsumedProductName == topConsumedProductName &&
        other.topConsumedAmount == topConsumedAmount &&
        other.topConsumedUnit == topConsumedUnit;
  }

  @override
  int get hashCode => Object.hash(
        totalConsumption,
        dailyCost,
        criticalProductCount,
        topConsumedProductName,
        topConsumedAmount,
        topConsumedUnit,
      );

  @override
  String toString() => 'HomeSummary('
      'totalConsumption: $totalConsumption, '
      'dailyCost: $dailyCost, '
      'criticalProductCount: $criticalProductCount, '
      'topConsumedProductName: $topConsumedProductName)';
}
