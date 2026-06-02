class AppSettings {
  final double criticalStockThreshold;
  final int forecastPeriod;
  final bool criticalStockNotification;
  final bool dailySummary;
  final bool productionForecast;
  final bool darkMode;
  final String language;

  const AppSettings({
    required this.criticalStockThreshold,
    required this.forecastPeriod,
    required this.criticalStockNotification,
    required this.dailySummary,
    required this.productionForecast,
    required this.darkMode,
    required this.language,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.criticalStockThreshold == criticalStockThreshold &&
        other.forecastPeriod == forecastPeriod &&
        other.criticalStockNotification == criticalStockNotification &&
        other.dailySummary == dailySummary &&
        other.productionForecast == productionForecast &&
        other.darkMode == darkMode &&
        other.language == language;
  }

  @override
  int get hashCode => Object.hash(
        criticalStockThreshold,
        forecastPeriod,
        criticalStockNotification,
        dailySummary,
        productionForecast,
        darkMode,
        language,
      );

  @override
  String toString() => 'AppSettings('
      'criticalStockThreshold: $criticalStockThreshold, '
      'forecastPeriod: $forecastPeriod, '
      'criticalStockNotification: $criticalStockNotification, '
      'dailySummary: $dailySummary, '
      'productionForecast: $productionForecast, '
      'darkMode: $darkMode, '
      'language: $language)';
}
