import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/errror/failure.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hesap/core/constants/app_string.dart';

import 'package:hesap/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:hesap/features/settings/data/models/app_settings_model.dart';
import 'package:hesap/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:hesap/features/settings/domain/entities/app_settings.dart';

import 'settings_repository_impl_test.mocks.dart';

@GenerateMocks([SettingsLocalDataSource])
void main() {
  late MockSettingsLocalDataSource mockDatasource;
  late SettingsRepositoryImpl repository;

  final tMap = {
    AppStrings.keyCriticalStockThreshold: 20.0,
    AppStrings.keyForecastPeriod: 14,
    AppStrings.keyCriticalStockNotification: true,
    AppStrings.keyDailySummary: false,
    AppStrings.keyProductionForecast: true,
    AppStrings.keyDarkMode: false,
    AppStrings.keyLanguage: 'Türkçe',
  };

  final tModel = AppSettingsModel.fromMap(tMap);

  setUp(() {
    mockDatasource = MockSettingsLocalDataSource();
    repository = SettingsRepositoryImpl(localDataSource: mockDatasource);
  });

  // ── getSettings() ──────────────────────────────────────────────────────────

  group('getSettings()', () {
    test('başarılı senaryo → Right(AppSettings) döner', () async {
      when(mockDatasource.getSettings()).thenAnswer((_) async => tMap);

      final result = await repository.getSettings();

      expect(result, isA<Right<Failure, AppSettings>>());
      result.fold(
        (l) => fail('Left dönmemeli'),
        (r) {
          expect(r.criticalStockThreshold, tModel.criticalStockThreshold);
          expect(r.forecastPeriod, tModel.forecastPeriod);
          expect(r.criticalStockNotification, tModel.criticalStockNotification);
          expect(r.dailySummary, tModel.dailySummary);
          expect(r.productionForecast, tModel.productionForecast);
          expect(r.darkMode, tModel.darkMode);
          expect(r.language, tModel.language);
        },
      );
      verify(mockDatasource.getSettings()).called(1);
    });

    test('exception fırlatınca → Left(CacheFailure) döner', () async {
      when(mockDatasource.getSettings())
          .thenThrow(Exception('SharedPreferences hatası'));

      final result = await repository.getSettings();

      expect(result, isA<Left<Failure, AppSettings>>());
      result.fold(
        (l) => expect(l, isA<CacheFailure>()),
        (r) => fail('Right dönmemeli'),
      );
      verify(mockDatasource.getSettings()).called(1);
    });

    test('exception mesajı CacheFailure.message içinde', () async {
      when(mockDatasource.getSettings())
          .thenThrow(Exception('test error message'));

      final result = await repository.getSettings();

      result.fold(
        (l) => expect(l.message, contains('test error message')),
        (r) => fail('Right dönmemeli'),
      );
    });

    test('datasource yalnızca bir kez çağrılır', () async {
      when(mockDatasource.getSettings()).thenAnswer((_) async => tMap);

      await repository.getSettings();

      verify(mockDatasource.getSettings()).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });
  });

  // ── saveSetting() ──────────────────────────────────────────────────────────

  group('saveSetting()', () {
    test('bool değer → Right(null) döner', () async {
      when(mockDatasource.saveSetting(AppStrings.keyDarkMode, true))
          .thenAnswer((_) async {});

      final result = await repository.saveSetting(AppStrings.keyDarkMode, true);

      expect(result, equals(const Right<Failure, void>(null)));
      verify(mockDatasource.saveSetting(AppStrings.keyDarkMode, true))
          .called(1);
    });

    test('int değer → Right(null) döner', () async {
      when(mockDatasource.saveSetting(AppStrings.keyForecastPeriod, 30))
          .thenAnswer((_) async {});

      final result =
          await repository.saveSetting(AppStrings.keyForecastPeriod, 30);

      expect(result, equals(const Right<Failure, void>(null)));
      verify(mockDatasource.saveSetting(AppStrings.keyForecastPeriod, 30))
          .called(1);
    });

    test('double değer → Right(null) döner', () async {
      when(mockDatasource.saveSetting(
              AppStrings.keyCriticalStockThreshold, 25.0))
          .thenAnswer((_) async {});

      final result = await repository.saveSetting(
          AppStrings.keyCriticalStockThreshold, 25.0);

      expect(result, equals(const Right<Failure, void>(null)));
      verify(mockDatasource.saveSetting(
              AppStrings.keyCriticalStockThreshold, 25.0))
          .called(1);
    });

    test('String değer → Right(null) döner', () async {
      when(mockDatasource.saveSetting(AppStrings.keyLanguage, 'English'))
          .thenAnswer((_) async {});

      final result =
          await repository.saveSetting(AppStrings.keyLanguage, 'English');

      expect(result, equals(const Right<Failure, void>(null)));
      verify(mockDatasource.saveSetting(AppStrings.keyLanguage, 'English'))
          .called(1);
    });

    test('exception fırlatınca → Left(CacheFailure) döner', () async {
      when(mockDatasource.saveSetting(any, any))
          .thenThrow(ArgumentError('Desteklenmeyen tip'));

      final result =
          await repository.saveSetting(AppStrings.keyLanguage, ['unsupported']);

      expect(result, isA<Left<Failure, void>>());
      result.fold(
        (l) => expect(l, isA<CacheFailure>()),
        (r) => fail('Right dönmemeli'),
      );
    });
  });

  // ── clearSettings() ────────────────────────────────────────────────────────

  group('clearSettings()', () {
    test('başarılı senaryo → Right(null) döner', () async {
      when(mockDatasource.clearSettings()).thenAnswer((_) async {});

      final result = await repository.clearSettings();

      expect(result, equals(const Right<Failure, void>(null)));
    });

    test('clearSettings datasource üzerinde çağrıldı mı verify', () async {
      when(mockDatasource.clearSettings()).thenAnswer((_) async {});

      await repository.clearSettings();

      verify(mockDatasource.clearSettings()).called(1);
    });

    test('clearSettings sırasında getSettings çağrılmaz', () async {
      when(mockDatasource.clearSettings()).thenAnswer((_) async {});

      await repository.clearSettings();

      verifyNever(mockDatasource.getSettings());
    });

    test('exception fırlatınca → Left(CacheFailure) döner', () async {
      when(mockDatasource.clearSettings()).thenThrow(Exception('clear hatası'));

      final result = await repository.clearSettings();

      expect(result, isA<Left<Failure, void>>());
      result.fold(
        (l) => expect(l, isA<CacheFailure>()),
        (r) => fail('Right dönmemeli'),
      );
    });

    test('datasource yalnızca bir kez çağrılır', () async {
      when(mockDatasource.clearSettings()).thenAnswer((_) async {});

      await repository.clearSettings();

      verify(mockDatasource.clearSettings()).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });
  });
}
