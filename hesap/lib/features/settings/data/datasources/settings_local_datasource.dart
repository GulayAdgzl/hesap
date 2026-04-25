import 'package:hesap/core/constants/app_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<Map<String, dynamic>> getSettings();
  Future<void> saveSetting(String key, dynamic value);
  Future<void> clearSettings();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<Map<String, dynamic>> getSettings() async {
    return {
      AppStrings.keyCriticalStockThreshold:
          sharedPreferences.getDouble(AppStrings.keyCriticalStockThreshold) ??
              AppStrings.defaultCriticalStockThreshold,
      AppStrings.keyForecastPeriod:
          sharedPreferences.getInt(AppStrings.keyForecastPeriod) ??
              AppStrings.defaultForecastPeriod,
      AppStrings.keyCriticalStockNotification:
          sharedPreferences.getBool(AppStrings.keyCriticalStockNotification) ??
              AppStrings.defaultCriticalStockNotification,
      AppStrings.keyDailySummary:
          sharedPreferences.getBool(AppStrings.keyDailySummary) ??
              AppStrings.defaultDailySummary,
      AppStrings.keyProductionForecast:
          sharedPreferences.getBool(AppStrings.keyProductionForecast) ??
              AppStrings.defaultProductionForecast,
      AppStrings.keyDarkMode:
          sharedPreferences.getBool(AppStrings.keyDarkMode) ??
              AppStrings.defaultDarkMode,
      AppStrings.keyLanguage:
          sharedPreferences.getString(AppStrings.keyLanguage) ??
              AppStrings.defaultLanguage,
    };
  }

  @override
  Future<void> saveSetting(String key, dynamic value) async {
    if (value is bool) {
      await sharedPreferences.setBool(key, value);
    } else if (value is int) {
      await sharedPreferences.setInt(key, value);
    } else if (value is double) {
      await sharedPreferences.setDouble(key, value);
    } else if (value is String) {
      await sharedPreferences.setString(key, value);
    } else {
      throw ArgumentError('Unsupported type: ${value.runtimeType}');
    }
  }

  @override
  Future<void> clearSettings() async {
    await sharedPreferences.remove(AppStrings.keyCriticalStockThreshold);
    await sharedPreferences.remove(AppStrings.keyForecastPeriod);
    await sharedPreferences.remove(AppStrings.keyCriticalStockNotification);
    await sharedPreferences.remove(AppStrings.keyDailySummary);
    await sharedPreferences.remove(AppStrings.keyProductionForecast);
    await sharedPreferences.remove(AppStrings.keyDarkMode);
    await sharedPreferences.remove(AppStrings.keyLanguage);
  }
}
