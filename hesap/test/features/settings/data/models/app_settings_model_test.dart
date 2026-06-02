import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/feature/settings/domain/entities/app_settings.dart';
import 'package:hesap/product/model/app_settings_model.dart';

void main() {
  // ── Test fixtures ──────────────────────────────────────────────────────────

  const tSettings = AppSettings(
    criticalStockThreshold: 20.0,
    forecastPeriod: 14,
    criticalStockNotification: true,
    dailySummary: false,
    productionForecast: true,
    darkMode: false,
    language: 'Türkçe',
  );

  const tModel = AppSettingsModel(
    criticalStockThreshold: 20.0,
    forecastPeriod: 14,
    criticalStockNotification: true,
    dailySummary: false,
    productionForecast: true,
    darkMode: false,
    language: 'Türkçe',
  );

  final tMap = {
    AppStrings.keyCriticalStockThreshold: 20.0,
    AppStrings.keyForecastPeriod: 14,
    AppStrings.keyCriticalStockNotification: true,
    AppStrings.keyDailySummary: false,
    AppStrings.keyProductionForecast: true,
    AppStrings.keyDarkMode: false,
    AppStrings.keyLanguage: 'Türkçe',
  };

  // ── AppSettings == operatörü ───────────────────────────────────────────────

  group('AppSettings equality', () {
    test('aynı değerler → true', () {
      const a = AppSettings(
        criticalStockThreshold: 20.0,
        forecastPeriod: 14,
        criticalStockNotification: true,
        dailySummary: false,
        productionForecast: true,
        darkMode: false,
        language: 'Türkçe',
      );
      const b = AppSettings(
        criticalStockThreshold: 20.0,
        forecastPeriod: 14,
        criticalStockNotification: true,
        dailySummary: false,
        productionForecast: true,
        darkMode: false,
        language: 'Türkçe',
      );
      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('farklı criticalStockThreshold → false', () {
      const other = AppSettings(
        criticalStockThreshold: 30.0,
        forecastPeriod: 14,
        criticalStockNotification: true,
        dailySummary: false,
        productionForecast: true,
        darkMode: false,
        language: 'Türkçe',
      );
      expect(tSettings == other, isFalse);
    });

    test('farklı forecastPeriod → false', () {
      const other = AppSettings(
        criticalStockThreshold: 20.0,
        forecastPeriod: 7,
        criticalStockNotification: true,
        dailySummary: false,
        productionForecast: true,
        darkMode: false,
        language: 'Türkçe',
      );
      expect(tSettings == other, isFalse);
    });

    test('farklı darkMode → false', () {
      const other = AppSettings(
        criticalStockThreshold: 20.0,
        forecastPeriod: 14,
        criticalStockNotification: true,
        dailySummary: false,
        productionForecast: true,
        darkMode: true,
        language: 'Türkçe',
      );
      expect(tSettings == other, isFalse);
    });

    test('farklı language → false', () {
      const other = AppSettings(
        criticalStockThreshold: 20.0,
        forecastPeriod: 14,
        criticalStockNotification: true,
        dailySummary: false,
        productionForecast: true,
        darkMode: false,
        language: 'English',
      );
      expect(tSettings == other, isFalse);
    });

    test('identical → true', () {
      expect(tSettings == tSettings, isTrue);
    });
  });

  // ── AppSettingsModel.fromMap() ─────────────────────────────────────────────

  group('AppSettingsModel.fromMap()', () {
    test('dolu map → doğru değerler', () {
      final result = AppSettingsModel.fromMap(tMap);
      expect(result.criticalStockThreshold, 20.0);
      expect(result.forecastPeriod, 14);
      expect(result.criticalStockNotification, true);
      expect(result.dailySummary, false);
      expect(result.productionForecast, true);
      expect(result.darkMode, false);
      expect(result.language, 'Türkçe');
    });

    test('boş map → tüm alanlar default değer döner', () {
      final result = AppSettingsModel.fromMap({});
      expect(result.criticalStockThreshold,
          AppStrings.defaultCriticalStockThreshold);
      expect(result.forecastPeriod, AppStrings.defaultForecastPeriod);
      expect(result.criticalStockNotification,
          AppStrings.defaultCriticalStockNotification);
      expect(result.dailySummary, AppStrings.defaultDailySummary);
      expect(result.productionForecast, AppStrings.defaultProductionForecast);
      expect(result.darkMode, AppStrings.defaultDarkMode);
      expect(result.language, AppStrings.defaultLanguage);
    });

    test('eksik criticalStockThreshold → default döner', () {
      final map = Map<String, dynamic>.from(tMap)
        ..remove(AppStrings.keyCriticalStockThreshold);
      final result = AppSettingsModel.fromMap(map);
      expect(result.criticalStockThreshold,
          AppStrings.defaultCriticalStockThreshold);
    });

    test('eksik forecastPeriod → default döner', () {
      final map = Map<String, dynamic>.from(tMap)
        ..remove(AppStrings.keyForecastPeriod);
      final result = AppSettingsModel.fromMap(map);
      expect(result.forecastPeriod, AppStrings.defaultForecastPeriod);
    });

    test('eksik darkMode → default döner', () {
      final map = Map<String, dynamic>.from(tMap)
        ..remove(AppStrings.keyDarkMode);
      final result = AppSettingsModel.fromMap(map);
      expect(result.darkMode, AppStrings.defaultDarkMode);
    });

    test('eksik language → default döner', () {
      final map = Map<String, dynamic>.from(tMap)
        ..remove(AppStrings.keyLanguage);
      final result = AppSettingsModel.fromMap(map);
      expect(result.language, AppStrings.defaultLanguage);
    });

    test('int değer double field → toDouble() çalışır', () {
      final map = Map<String, dynamic>.from(tMap)
        ..[AppStrings.keyCriticalStockThreshold] = 25;
      final result = AppSettingsModel.fromMap(map);
      expect(result.criticalStockThreshold, 25.0);
      expect(result.criticalStockThreshold, isA<double>());
    });
  });

  // ── AppSettingsModel.toMap() ───────────────────────────────────────────────

  group('AppSettingsModel.toMap()', () {
    test('doğru key-value çiftleri döner', () {
      final result = tModel.toMap();
      expect(result[AppStrings.keyCriticalStockThreshold], 20.0);
      expect(result[AppStrings.keyForecastPeriod], 14);
      expect(result[AppStrings.keyCriticalStockNotification], true);
      expect(result[AppStrings.keyDailySummary], false);
      expect(result[AppStrings.keyProductionForecast], true);
      expect(result[AppStrings.keyDarkMode], false);
      expect(result[AppStrings.keyLanguage], 'Türkçe');
    });

    test('tüm AppStrings keyleri map içinde mevcut', () {
      final result = tModel.toMap();
      expect(result.containsKey(AppStrings.keyCriticalStockThreshold), isTrue);
      expect(result.containsKey(AppStrings.keyForecastPeriod), isTrue);
      expect(
          result.containsKey(AppStrings.keyCriticalStockNotification), isTrue);
      expect(result.containsKey(AppStrings.keyDailySummary), isTrue);
      expect(result.containsKey(AppStrings.keyProductionForecast), isTrue);
      expect(result.containsKey(AppStrings.keyDarkMode), isTrue);
      expect(result.containsKey(AppStrings.keyLanguage), isTrue);
    });

    test('fromMap → toMap → fromMap round-trip eşit', () {
      final firstPass = AppSettingsModel.fromMap(tMap);
      final backToMap = firstPass.toMap();
      final secondPass = AppSettingsModel.fromMap(backToMap);
      expect(firstPass, equals(secondPass));
    });
  });

  // ── AppSettingsModel.defaults() ───────────────────────────────────────────

  group('AppSettingsModel.defaults()', () {
    test('AppStrings default sabitleriyle tam eşleşme', () {
      final result = AppSettingsModel.defaults();
      expect(result.criticalStockThreshold,
          AppStrings.defaultCriticalStockThreshold);
      expect(result.forecastPeriod, AppStrings.defaultForecastPeriod);
      expect(result.criticalStockNotification,
          AppStrings.defaultCriticalStockNotification);
      expect(result.dailySummary, AppStrings.defaultDailySummary);
      expect(result.productionForecast, AppStrings.defaultProductionForecast);
      expect(result.darkMode, AppStrings.defaultDarkMode);
      expect(result.language, AppStrings.defaultLanguage);
    });

    test('iki kez çağrılınca eşit nesneler döner', () {
      expect(AppSettingsModel.defaults(), equals(AppSettingsModel.defaults()));
    });
  });

  // ── AppSettingsModel.copyWith() ───────────────────────────────────────────

  group('AppSettingsModel.copyWith()', () {
    test('darkMode değişince diğer alanlar korunur', () {
      final result = tModel.copyWith(darkMode: true);
      expect(result.darkMode, true);
      expect(result.criticalStockThreshold, tModel.criticalStockThreshold);
      expect(result.forecastPeriod, tModel.forecastPeriod);
      expect(
          result.criticalStockNotification, tModel.criticalStockNotification);
      expect(result.dailySummary, tModel.dailySummary);
      expect(result.productionForecast, tModel.productionForecast);
      expect(result.language, tModel.language);
    });

    test('criticalStockThreshold değişince diğer alanlar korunur', () {
      final result = tModel.copyWith(criticalStockThreshold: 35.0);
      expect(result.criticalStockThreshold, 35.0);
      expect(result.forecastPeriod, tModel.forecastPeriod);
      expect(result.darkMode, tModel.darkMode);
      expect(result.language, tModel.language);
    });

    test('language değişince diğer alanlar korunur', () {
      final result = tModel.copyWith(language: 'English');
      expect(result.language, 'English');
      expect(result.darkMode, tModel.darkMode);
      expect(result.criticalStockThreshold, tModel.criticalStockThreshold);
    });

    test('hiçbir parametre verilmeyince orijinale eşit döner', () {
      final result = tModel.copyWith();
      expect(result, equals(tModel));
    });

    test('birden fazla alan aynı anda değişebilir', () {
      final result = tModel.copyWith(
        darkMode: true,
        forecastPeriod: 30,
        language: 'Deutsch',
      );
      expect(result.darkMode, true);
      expect(result.forecastPeriod, 30);
      expect(result.language, 'Deutsch');
      expect(result.criticalStockThreshold, tModel.criticalStockThreshold);
    });
  });
}
