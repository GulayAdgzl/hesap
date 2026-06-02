import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/feature/settings/data/datasources/settings_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SettingsLocalDataSourceImpl datasource;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<SettingsLocalDataSourceImpl> buildDatasource() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsLocalDataSourceImpl(sharedPreferences: prefs);
  }

  // ── getSettings() boş SharedPrefs ─────────────────────────────────────────

  group('getSettings() — boş SharedPrefs → default değerler', () {
    test('criticalStockThreshold default döner', () async {
      datasource = await buildDatasource();
      final result = await datasource.getSettings();
      expect(
        result[AppStrings.keyCriticalStockThreshold],
        AppStrings.defaultCriticalStockThreshold,
      );
    });

    test('forecastPeriod default döner', () async {
      datasource = await buildDatasource();
      final result = await datasource.getSettings();
      expect(
        result[AppStrings.keyForecastPeriod],
        AppStrings.defaultForecastPeriod,
      );
    });

    test('criticalStockNotification default döner', () async {
      datasource = await buildDatasource();
      final result = await datasource.getSettings();
      expect(
        result[AppStrings.keyCriticalStockNotification],
        AppStrings.defaultCriticalStockNotification,
      );
    });

    test('dailySummary default döner', () async {
      datasource = await buildDatasource();
      final result = await datasource.getSettings();
      expect(
        result[AppStrings.keyDailySummary],
        AppStrings.defaultDailySummary,
      );
    });

    test('productionForecast default döner', () async {
      datasource = await buildDatasource();
      final result = await datasource.getSettings();
      expect(
        result[AppStrings.keyProductionForecast],
        AppStrings.defaultProductionForecast,
      );
    });

    test('darkMode default döner', () async {
      datasource = await buildDatasource();
      final result = await datasource.getSettings();
      expect(
        result[AppStrings.keyDarkMode],
        AppStrings.defaultDarkMode,
      );
    });

    test('language default döner', () async {
      datasource = await buildDatasource();
      final result = await datasource.getSettings();
      expect(
        result[AppStrings.keyLanguage],
        AppStrings.defaultLanguage,
      );
    });

    test('map tüm keyleri içeriyor', () async {
      datasource = await buildDatasource();
      final result = await datasource.getSettings();
      expect(result.containsKey(AppStrings.keyCriticalStockThreshold), isTrue);
      expect(result.containsKey(AppStrings.keyForecastPeriod), isTrue);
      expect(
          result.containsKey(AppStrings.keyCriticalStockNotification), isTrue);
      expect(result.containsKey(AppStrings.keyDailySummary), isTrue);
      expect(result.containsKey(AppStrings.keyProductionForecast), isTrue);
      expect(result.containsKey(AppStrings.keyDarkMode), isTrue);
      expect(result.containsKey(AppStrings.keyLanguage), isTrue);
    });
  });

  // ── getSettings() dolu SharedPrefs ────────────────────────────────────────

  group('getSettings() — dolu SharedPrefs → kayıtlı değerler', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({
        AppStrings.keyCriticalStockThreshold: 30.0,
        AppStrings.keyForecastPeriod: 14,
        AppStrings.keyCriticalStockNotification: false,
        AppStrings.keyDailySummary: false,
        AppStrings.keyProductionForecast: true,
        AppStrings.keyDarkMode: true,
        AppStrings.keyLanguage: 'English',
      });
    });

    test('criticalStockThreshold kayıtlı değeri döner', () async {
      datasource = await buildDatasource();
      final result = await datasource.getSettings();
      expect(result[AppStrings.keyCriticalStockThreshold], 30.0);
    });

    test('forecastPeriod kayıtlı değeri döner', () async {
      datasource = await buildDatasource();
      final result = await datasource.getSettings();
      expect(result[AppStrings.keyForecastPeriod], 14);
    });

    test('criticalStockNotification false döner', () async {
      datasource = await buildDatasource();
      final result = await datasource.getSettings();
      expect(result[AppStrings.keyCriticalStockNotification], false);
    });

    test('darkMode true döner', () async {
      datasource = await buildDatasource();
      final result = await datasource.getSettings();
      expect(result[AppStrings.keyDarkMode], true);
    });

    test('language English döner', () async {
      datasource = await buildDatasource();
      final result = await datasource.getSettings();
      expect(result[AppStrings.keyLanguage], 'English');
    });

    test('tüm değerler kayıtlı değerlere eşit', () async {
      datasource = await buildDatasource();
      final result = await datasource.getSettings();
      expect(result[AppStrings.keyCriticalStockThreshold], 30.0);
      expect(result[AppStrings.keyForecastPeriod], 14);
      expect(result[AppStrings.keyCriticalStockNotification], false);
      expect(result[AppStrings.keyDailySummary], false);
      expect(result[AppStrings.keyProductionForecast], true);
      expect(result[AppStrings.keyDarkMode], true);
      expect(result[AppStrings.keyLanguage], 'English');
    });
  });

  // ── saveSetting() ──────────────────────────────────────────────────────────

  group('saveSetting() — tip kontrolü', () {
    test('bool kaydedilir ve geri okunur', () async {
      datasource = await buildDatasource();
      await datasource.saveSetting(AppStrings.keyDarkMode, true);
      final result = await datasource.getSettings();
      expect(result[AppStrings.keyDarkMode], true);
    });

    test('int kaydedilir ve geri okunur', () async {
      datasource = await buildDatasource();
      await datasource.saveSetting(AppStrings.keyForecastPeriod, 30);
      final result = await datasource.getSettings();
      expect(result[AppStrings.keyForecastPeriod], 30);
    });

    test('double kaydedilir ve geri okunur', () async {
      datasource = await buildDatasource();
      await datasource.saveSetting(AppStrings.keyCriticalStockThreshold, 25.0);
      final result = await datasource.getSettings();
      expect(result[AppStrings.keyCriticalStockThreshold], 25.0);
    });

    test('String kaydedilir ve geri okunur', () async {
      datasource = await buildDatasource();
      await datasource.saveSetting(AppStrings.keyLanguage, 'Deutsch');
      final result = await datasource.getSettings();
      expect(result[AppStrings.keyLanguage], 'Deutsch');
    });

    test('List tipi → ArgumentError fırlatır', () async {
      datasource = await buildDatasource();
      expect(
        () => datasource.saveSetting(AppStrings.keyLanguage, ['a', 'b']),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Map tipi → ArgumentError fırlatır', () async {
      datasource = await buildDatasource();
      expect(
        () => datasource.saveSetting(AppStrings.keyLanguage, {'key': 'val'}),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('null tipi → ArgumentError fırlatır', () async {
      datasource = await buildDatasource();
      expect(
        () => datasource.saveSetting(AppStrings.keyLanguage, null),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  // ── clearSettings() ────────────────────────────────────────────────────────

  group('clearSettings() → tüm keyler siliniyor', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({
        AppStrings.keyCriticalStockThreshold: 30.0,
        AppStrings.keyForecastPeriod: 14,
        AppStrings.keyCriticalStockNotification: false,
        AppStrings.keyDailySummary: false,
        AppStrings.keyProductionForecast: true,
        AppStrings.keyDarkMode: true,
        AppStrings.keyLanguage: 'English',
      });
    });

    test('clear sonrası criticalStockThreshold → default', () async {
      datasource = await buildDatasource();
      await datasource.clearSettings();
      final result = await datasource.getSettings();
      expect(
        result[AppStrings.keyCriticalStockThreshold],
        AppStrings.defaultCriticalStockThreshold,
      );
    });

    test('clear sonrası forecastPeriod → default', () async {
      datasource = await buildDatasource();
      await datasource.clearSettings();
      final result = await datasource.getSettings();
      expect(result[AppStrings.keyForecastPeriod],
          AppStrings.defaultForecastPeriod);
    });

    test('clear sonrası darkMode → default', () async {
      datasource = await buildDatasource();
      await datasource.clearSettings();
      final result = await datasource.getSettings();
      expect(result[AppStrings.keyDarkMode], AppStrings.defaultDarkMode);
    });

    test('clear sonrası language → default', () async {
      datasource = await buildDatasource();
      await datasource.clearSettings();
      final result = await datasource.getSettings();
      expect(result[AppStrings.keyLanguage], AppStrings.defaultLanguage);
    });

    test('clear sonrası tüm alanlar default değere döner', () async {
      datasource = await buildDatasource();
      await datasource.clearSettings();
      final result = await datasource.getSettings();
      expect(result[AppStrings.keyCriticalStockThreshold],
          AppStrings.defaultCriticalStockThreshold);
      expect(result[AppStrings.keyForecastPeriod],
          AppStrings.defaultForecastPeriod);
      expect(result[AppStrings.keyCriticalStockNotification],
          AppStrings.defaultCriticalStockNotification);
      expect(
          result[AppStrings.keyDailySummary], AppStrings.defaultDailySummary);
      expect(result[AppStrings.keyProductionForecast],
          AppStrings.defaultProductionForecast);
      expect(result[AppStrings.keyDarkMode], AppStrings.defaultDarkMode);
      expect(result[AppStrings.keyLanguage], AppStrings.defaultLanguage);
    });

    test('clear sonrası save → yeni değer okunur', () async {
      datasource = await buildDatasource();
      await datasource.clearSettings();
      await datasource.saveSetting(AppStrings.keyDarkMode, true);
      final result = await datasource.getSettings();
      expect(result[AppStrings.keyDarkMode], true);
    });
  });
}
