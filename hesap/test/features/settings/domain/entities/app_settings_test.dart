import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/feature/settings/domain/entities/app_settings.dart';

void main() {
  const tSettings = AppSettings(
    criticalStockThreshold: 15.0,
    forecastPeriod: 7,
    criticalStockNotification: true,
    dailySummary: true,
    productionForecast: false,
    darkMode: false,
    language: 'Türkçe',
  );

  // ── == operatörü ───────────────────────────────────────────────────────────

  group('== operatörü', () {
    test('identical → true', () {
      expect(tSettings == tSettings, isTrue);
    });

    test('aynı değerler → true', () {
      const other = AppSettings(
        criticalStockThreshold: 15.0,
        forecastPeriod: 7,
        criticalStockNotification: true,
        dailySummary: true,
        productionForecast: false,
        darkMode: false,
        language: 'Türkçe',
      );
      expect(tSettings == other, isTrue);
    });

    test('farklı criticalStockThreshold → false', () {
      const other = AppSettings(
        criticalStockThreshold: 20.0,
        forecastPeriod: 7,
        criticalStockNotification: true,
        dailySummary: true,
        productionForecast: false,
        darkMode: false,
        language: 'Türkçe',
      );
      expect(tSettings == other, isFalse);
    });

    test('farklı forecastPeriod → false', () {
      const other = AppSettings(
        criticalStockThreshold: 15.0,
        forecastPeriod: 14,
        criticalStockNotification: true,
        dailySummary: true,
        productionForecast: false,
        darkMode: false,
        language: 'Türkçe',
      );
      expect(tSettings == other, isFalse);
    });

    test('farklı criticalStockNotification → false', () {
      const other = AppSettings(
        criticalStockThreshold: 15.0,
        forecastPeriod: 7,
        criticalStockNotification: false,
        dailySummary: true,
        productionForecast: false,
        darkMode: false,
        language: 'Türkçe',
      );
      expect(tSettings == other, isFalse);
    });

    test('farklı dailySummary → false', () {
      const other = AppSettings(
        criticalStockThreshold: 15.0,
        forecastPeriod: 7,
        criticalStockNotification: true,
        dailySummary: false,
        productionForecast: false,
        darkMode: false,
        language: 'Türkçe',
      );
      expect(tSettings == other, isFalse);
    });

    test('farklı productionForecast → false', () {
      const other = AppSettings(
        criticalStockThreshold: 15.0,
        forecastPeriod: 7,
        criticalStockNotification: true,
        dailySummary: true,
        productionForecast: true,
        darkMode: false,
        language: 'Türkçe',
      );
      expect(tSettings == other, isFalse);
    });

    test('farklı darkMode → false', () {
      const other = AppSettings(
        criticalStockThreshold: 15.0,
        forecastPeriod: 7,
        criticalStockNotification: true,
        dailySummary: true,
        productionForecast: false,
        darkMode: true,
        language: 'Türkçe',
      );
      expect(tSettings == other, isFalse);
    });

    test('farklı language → false', () {
      const other = AppSettings(
        criticalStockThreshold: 15.0,
        forecastPeriod: 7,
        criticalStockNotification: true,
        dailySummary: true,
        productionForecast: false,
        darkMode: false,
        language: 'English',
      );
      expect(tSettings == other, isFalse);
    });
  });

  // ── hashCode ───────────────────────────────────────────────────────────────

  group('hashCode', () {
    test('aynı değerler → aynı hashCode', () {
      const other = AppSettings(
        criticalStockThreshold: 15.0,
        forecastPeriod: 7,
        criticalStockNotification: true,
        dailySummary: true,
        productionForecast: false,
        darkMode: false,
        language: 'Türkçe',
      );
      expect(tSettings.hashCode, equals(other.hashCode));
    });

    test('farklı değerler → farklı hashCode', () {
      const other = AppSettings(
        criticalStockThreshold: 99.0,
        forecastPeriod: 30,
        criticalStockNotification: false,
        dailySummary: false,
        productionForecast: true,
        darkMode: true,
        language: 'English',
      );
      expect(tSettings.hashCode, isNot(equals(other.hashCode)));
    });

    test('== true ise hashCode da eşit', () {
      const other = AppSettings(
        criticalStockThreshold: 15.0,
        forecastPeriod: 7,
        criticalStockNotification: true,
        dailySummary: true,
        productionForecast: false,
        darkMode: false,
        language: 'Türkçe',
      );
      if (tSettings == other) {
        expect(tSettings.hashCode, equals(other.hashCode));
      }
    });
  });

  // ── toString() ─────────────────────────────────────────────────────────────

  group('toString()', () {
    test('AppSettings prefix içeriyor', () {
      expect(tSettings.toString(), contains('AppSettings('));
    });

    test('tüm field değerlerini içeriyor', () {
      final str = tSettings.toString();
      expect(str, contains('15.0'));
      expect(str, contains('7'));
      expect(str, contains('true'));
      expect(str, contains('false'));
      expect(str, contains('Türkçe'));
    });

    test('field isimlerini içeriyor', () {
      final str = tSettings.toString();
      expect(str, contains('criticalStockThreshold'));
      expect(str, contains('forecastPeriod'));
      expect(str, contains('darkMode'));
      expect(str, contains('language'));
    });
  });

  // ── immutability ───────────────────────────────────────────────────────────

  group('immutability', () {
    test('const constructor ile oluşturulabiliyor', () {
      const settings = AppSettings(
        criticalStockThreshold: 10.0,
        forecastPeriod: 7,
        criticalStockNotification: true,
        dailySummary: true,
        productionForecast: false,
        darkMode: false,
        language: 'Türkçe',
      );
      expect(settings, isNotNull);
    });

    test('field değerleri doğru atanıyor', () {
      expect(tSettings.criticalStockThreshold, 15.0);
      expect(tSettings.forecastPeriod, 7);
      expect(tSettings.criticalStockNotification, true);
      expect(tSettings.dailySummary, true);
      expect(tSettings.productionForecast, false);
      expect(tSettings.darkMode, false);
      expect(tSettings.language, 'Türkçe');
    });
  });
}
