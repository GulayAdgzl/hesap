import '../../core/constants/app_string.dart';
import '../../feature/settings/domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required super.criticalStockThreshold,
    required super.forecastPeriod,
    required super.criticalStockNotification,
    required super.dailySummary,
    required super.productionForecast,
    required super.darkMode,
    required super.language,
  });

  factory AppSettingsModel.fromMap(Map<String, dynamic> map) {
    return AppSettingsModel(
      criticalStockThreshold:
          (map[AppStrings.keyCriticalStockThreshold] as num?)?.toDouble() ??
              AppStrings.defaultCriticalStockThreshold,
      forecastPeriod: (map[AppStrings.keyForecastPeriod] as num?)?.toInt() ??
          AppStrings.defaultForecastPeriod,
      criticalStockNotification:
          map[AppStrings.keyCriticalStockNotification] as bool? ??
              AppStrings.defaultCriticalStockNotification,
      dailySummary: map[AppStrings.keyDailySummary] as bool? ??
          AppStrings.defaultDailySummary,
      productionForecast: map[AppStrings.keyProductionForecast] as bool? ??
          AppStrings.defaultProductionForecast,
      darkMode:
          map[AppStrings.keyDarkMode] as bool? ?? AppStrings.defaultDarkMode,
      language:
          map[AppStrings.keyLanguage] as String? ?? AppStrings.defaultLanguage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppStrings.keyCriticalStockThreshold: criticalStockThreshold,
      AppStrings.keyForecastPeriod: forecastPeriod,
      AppStrings.keyCriticalStockNotification: criticalStockNotification,
      AppStrings.keyDailySummary: dailySummary,
      AppStrings.keyProductionForecast: productionForecast,
      AppStrings.keyDarkMode: darkMode,
      AppStrings.keyLanguage: language,
    };
  }

  factory AppSettingsModel.defaults() {
    return AppSettingsModel(
      criticalStockThreshold: AppStrings.defaultCriticalStockThreshold,
      forecastPeriod: AppStrings.defaultForecastPeriod,
      criticalStockNotification: AppStrings.defaultCriticalStockNotification,
      dailySummary: AppStrings.defaultDailySummary,
      productionForecast: AppStrings.defaultProductionForecast,
      darkMode: AppStrings.defaultDarkMode,
      language: AppStrings.defaultLanguage,
    );
  }

  AppSettingsModel copyWith({
    double? criticalStockThreshold,
    int? forecastPeriod,
    bool? criticalStockNotification,
    bool? dailySummary,
    bool? productionForecast,
    bool? darkMode,
    String? language,
  }) {
    return AppSettingsModel(
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

  AppSettingsModel fromEntity(AppSettings entity) {
    return AppSettingsModel(
      criticalStockThreshold: entity.criticalStockThreshold,
      forecastPeriod: entity.forecastPeriod,
      criticalStockNotification: entity.criticalStockNotification,
      dailySummary: entity.dailySummary,
      productionForecast: entity.productionForecast,
      darkMode: entity.darkMode,
      language: entity.language,
    );
  }
}
