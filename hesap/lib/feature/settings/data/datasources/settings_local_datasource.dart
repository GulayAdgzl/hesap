import 'package:hesap/core/constants/settings_keys.dart';
import 'package:hesap/feature/settings/domain/entities/app_settings.dart';
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
      SettingsKeys.criticalStockThreshold:
          sharedPreferences.getDouble(SettingsKeys.criticalStockThreshold) ??
              AppSettings.defaults.criticalStockThreshold,
      SettingsKeys.forecastPeriod:
          sharedPreferences.getInt(SettingsKeys.forecastPeriod) ??
              AppSettings.defaults.forecastPeriod,
      SettingsKeys.criticalStockNotification:
          sharedPreferences.getBool(SettingsKeys.criticalStockNotification) ??
              AppSettings.defaults.criticalStockNotification,
      SettingsKeys.dailySummary:
          sharedPreferences.getBool(SettingsKeys.dailySummary) ??
              AppSettings.defaults.dailySummary,
      SettingsKeys.productionForecast:
          sharedPreferences.getBool(SettingsKeys.productionForecast) ??
              AppSettings.defaults.productionForecast,
      SettingsKeys.darkMode: sharedPreferences.getBool(SettingsKeys.darkMode) ??
          AppSettings.defaults.darkMode,
      SettingsKeys.language:
          sharedPreferences.getString(SettingsKeys.language) ??
              AppSettings.defaults.language,
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
    await sharedPreferences.remove(SettingsKeys.criticalStockThreshold);
    await sharedPreferences.remove(SettingsKeys.forecastPeriod);
    await sharedPreferences.remove(SettingsKeys.criticalStockNotification);
    await sharedPreferences.remove(SettingsKeys.dailySummary);
    await sharedPreferences.remove(SettingsKeys.productionForecast);
    await sharedPreferences.remove(SettingsKeys.darkMode);
    await sharedPreferences.remove(SettingsKeys.language);
  }
}
