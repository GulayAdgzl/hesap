final class AppSettings {
  const AppSettings({
    required this.criticalStockThreshold,
    required this.forecastPeriod,
    required this.criticalStockNotification,
    required this.dailySummary,
    required this.productionForecast,
    required this.darkMode,
    required this.language,
  });

  final double criticalStockThreshold;
  final int forecastPeriod;
  final bool criticalStockNotification;
  final bool dailySummary;
  final bool productionForecast;
  final bool darkMode;

  /// Locale kodu (örn. 'tr', 'en'). Display label için
  /// `AppLanguage.fromCode(language).label` kullanılmalı.
  final String language;

  AppSettings copyWith({
    double? criticalStockThreshold,
    int? forecastPeriod,
    bool? criticalStockNotification,
    bool? dailySummary,
    bool? productionForecast,
    bool? darkMode,
    String? language,
  }) {
    return AppSettings(
      criticalStockThreshold:
          criticalStockThreshold ?? this.criticalStockThreshold,
      forecastPeriod: forecastPeriod ?? this.forecastPeriod,
      criticalStockNotification:
          criticalStockNotification ?? this.criticalStockNotification,
      dailySummary: dailySummary ?? this.dailySummary,
      productionForecast: productionForecast ?? this.productionForecast,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
    );
  }

  static const AppSettings defaults = AppSettings(
    criticalStockThreshold: 15.0,
    forecastPeriod: 7,
    criticalStockNotification: true,
    dailySummary: true,
    productionForecast: false,
    darkMode: false,
    language: 'tr',
  );

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
