enum ForecastTrend { increasing, stable, decreasing }

class ProductionForecast {
  final String productId;
  final String productName;
  final String unit;
  final double forecastAmount;
  final double previousAmount;
  final ForecastTrend trend;

  const ProductionForecast({
    required this.productId,
    required this.productName,
    required this.unit,
    required this.forecastAmount,
    required this.previousAmount,
    required this.trend,
  });

  double get delta => forecastAmount - previousAmount;

  bool get isIncreasing => trend == ForecastTrend.increasing;
  bool get isDecreasing => trend == ForecastTrend.decreasing;

  String get forecastFormatted => '${forecastAmount.toStringAsFixed(0)} $unit';

  String get deltaFormatted {
    final sign = delta >= 0 ? '+' : '';
    return '$sign${delta.toStringAsFixed(0)} $unit';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductionForecast &&
        other.productId == productId &&
        other.forecastAmount == forecastAmount &&
        other.trend == trend;
  }

  @override
  int get hashCode => Object.hash(productId, forecastAmount, trend);

  @override
  String toString() => 'ProductionForecast('
      'productName: $productName, '
      'forecastAmount: $forecastAmount $unit, '
      'trend: $trend)';
}
