import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/errror/failure.dart';
import 'package:hesap/feature/settings/domain/entities/app_settings.dart';
import 'package:hesap/feature/settings/domain/repositories/settings_repository.dart';
import 'package:hesap/feature/settings/domain/usecases/get_settings.dart';
import 'package:hesap/feature/settings/domain/usecases/save_settings.dart';
import 'package:hesap/feature/settings/presentation/bloc/settings_cubit.dart';
import 'package:hesap/feature/settings/presentation/bloc/settings_state.dart';
import 'package:hesap/module/notification/notification_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'settings_cubit_test.mocks.dart';

@GenerateMocks([
  GetSettings,
  SaveSetting,
  SettingsRepository,
  NotificationService,
])
void main() {
  late MockGetSettings mockGetSettings;
  late MockSaveSetting mockSaveSetting;
  late MockSettingsRepository mockRepository;
  late MockNotificationService mockNotificationService;
  late SettingsCubit cubit;

  const tSettings = AppSettings(
    criticalStockThreshold: 15.0,
    forecastPeriod: 7,
    criticalStockNotification: true,
    dailySummary: true,
    productionForecast: false,
    darkMode: false,
    language: 'Türkçe',
  );

  const tSettingsDarkMode = AppSettings(
    criticalStockThreshold: 15.0,
    forecastPeriod: 7,
    criticalStockNotification: true,
    dailySummary: true,
    productionForecast: false,
    darkMode: true,
    language: 'Türkçe',
  );

  setUp(() {
    mockGetSettings = MockGetSettings();
    mockSaveSetting = MockSaveSetting();
    mockRepository = MockSettingsRepository();
    mockNotificationService = MockNotificationService();

    cubit = SettingsCubit(
      getSettings: mockGetSettings,
      saveSetting: mockSaveSetting,
      repository: mockRepository,
      notificationService: mockNotificationService,
    );
  });

  tearDown(() => cubit.close());

  // ── loadSettings() ─────────────────────────────────────────────────────────

  group('loadSettings()', () {
    blocTest<SettingsCubit, SettingsState>(
      'başarılı → [Loading, Loaded] sırasıyla emit',
      build: () {
        when(mockGetSettings()).thenAnswer((_) async => Right(tSettings));
        return cubit;
      },
      act: (c) => c.loadSettings(),
      expect: () => [
        const SettingsLoading(),
        const SettingsLoaded(settings: tSettings),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'hata → [Loading, Error] sırasıyla emit',
      build: () {
        when(mockGetSettings())
            .thenAnswer((_) async => Left(CacheFailure('yükleme hatası')));
        return cubit;
      },
      act: (c) => c.loadSettings(),
      expect: () => [
        const SettingsLoading(),
        const SettingsError(message: 'yükleme hatası'),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'failure message Error state.message ile eşleşir',
      build: () {
        when(mockGetSettings())
            .thenAnswer((_) async => Left(CacheFailure('özel hata mesajı')));
        return cubit;
      },
      act: (c) => c.loadSettings(),
      expect: () => [
        const SettingsLoading(),
        const SettingsError(message: 'özel hata mesajı'),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'getSettings yalnızca bir kez çağrılır',
      build: () {
        when(mockGetSettings()).thenAnswer((_) async => Right(tSettings));
        return cubit;
      },
      act: (c) => c.loadSettings(),
      verify: (_) => verify(mockGetSettings()).called(1),
    );
  });

  // ── updateDarkMode() ───────────────────────────────────────────────────────

  group('updateDarkMode()', () {
    blocTest<SettingsCubit, SettingsState>(
      'save → reload → Loaded(darkMode: true) sırası',
      build: () {
        when(mockSaveSetting(key: AppStrings.keyDarkMode, value: true))
            .thenAnswer((_) async => const Right(null));
        when(mockGetSettings())
            .thenAnswer((_) async => Right(tSettingsDarkMode));
        return cubit;
      },
      seed: () => const SettingsLoaded(settings: tSettings),
      act: (c) => c.updateDarkMode(true),
      expect: () => [
        const SettingsLoading(),
        const SettingsLoaded(settings: tSettingsDarkMode),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'saveSetting doğru key/value ile çağrılır',
      build: () {
        when(mockSaveSetting(key: AppStrings.keyDarkMode, value: true))
            .thenAnswer((_) async => const Right(null));
        when(mockGetSettings())
            .thenAnswer((_) async => Right(tSettingsDarkMode));
        return cubit;
      },
      seed: () => const SettingsLoaded(settings: tSettings),
      act: (c) => c.updateDarkMode(true),
      verify: (_) =>
          verify(mockSaveSetting(key: AppStrings.keyDarkMode, value: true))
              .called(1),
    );

    blocTest<SettingsCubit, SettingsState>(
      'save sonrası loadSettings tetiklenir',
      build: () {
        when(mockSaveSetting(key: AppStrings.keyDarkMode, value: true))
            .thenAnswer((_) async => const Right(null));
        when(mockGetSettings())
            .thenAnswer((_) async => Right(tSettingsDarkMode));
        return cubit;
      },
      seed: () => const SettingsLoaded(settings: tSettings),
      act: (c) => c.updateDarkMode(true),
      verify: (_) => verify(mockGetSettings()).called(1),
    );
  });

  // ── updateDailySummary() ───────────────────────────────────────────────────

  group('updateDailySummary()', () {
    blocTest<SettingsCubit, SettingsState>(
      'NotificationService.scheduleDailySummary(enabled: false) çağrılır',
      build: () {
        when(mockSaveSetting(key: AppStrings.keyDailySummary, value: false))
            .thenAnswer((_) async => const Right(null));
        when(mockGetSettings()).thenAnswer((_) async => Right(tSettings));
        when(mockNotificationService.scheduleDailySummary(enabled: false))
            .thenAnswer((_) async {});
        return cubit;
      },
      seed: () => const SettingsLoaded(settings: tSettings),
      act: (c) => c.updateDailySummary(false),
      verify: (_) =>
          verify(mockNotificationService.scheduleDailySummary(enabled: false))
              .called(1),
    );

    blocTest<SettingsCubit, SettingsState>(
      'NotificationService.scheduleDailySummary(enabled: true) çağrılır',
      build: () {
        when(mockSaveSetting(key: AppStrings.keyDailySummary, value: true))
            .thenAnswer((_) async => const Right(null));
        when(mockGetSettings()).thenAnswer((_) async => Right(tSettings));
        when(mockNotificationService.scheduleDailySummary(enabled: true))
            .thenAnswer((_) async {});
        return cubit;
      },
      seed: () => const SettingsLoaded(settings: tSettings),
      act: (c) => c.updateDailySummary(true),
      verify: (_) =>
          verify(mockNotificationService.scheduleDailySummary(enabled: true))
              .called(1),
    );
  });

  // ── _save() state guard ────────────────────────────────────────────────────

  group('_save() — state SettingsLoaded değilse hiçbir şey yapmaz', () {
    blocTest<SettingsCubit, SettingsState>(
      'SettingsInitial state → updateDarkMode görmezden gelir',
      build: () => cubit,
      seed: () => const SettingsInitial(),
      act: (c) => c.updateDarkMode(true),
      expect: () => [],
      verify: (_) {
        verifyNever(
            mockSaveSetting(key: anyNamed('key'), value: anyNamed('value')));
        verifyNever(mockGetSettings());
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'SettingsLoading state → updateDarkMode görmezden gelir',
      build: () => cubit,
      seed: () => const SettingsLoading(),
      act: (c) => c.updateDarkMode(true),
      expect: () => [],
      verify: (_) => verifyNever(
          mockSaveSetting(key: anyNamed('key'), value: anyNamed('value'))),
    );

    blocTest<SettingsCubit, SettingsState>(
      'SettingsError state → updateDarkMode görmezden gelir',
      build: () => cubit,
      seed: () => const SettingsError(message: 'hata'),
      act: (c) => c.updateDarkMode(true),
      expect: () => [],
      verify: (_) => verifyNever(
          mockSaveSetting(key: anyNamed('key'), value: anyNamed('value'))),
    );
  });

  // ── clearSettings() ────────────────────────────────────────────────────────

  group('clearSettings()', () {
    blocTest<SettingsCubit, SettingsState>(
      'cancelAll → Initial state emit edilir',
      build: () {
        when(mockNotificationService.cancelAll()).thenAnswer((_) async {});
        when(mockRepository.clearSettings())
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (c) => c.clearSettings(),
      expect: () => [const SettingsInitial()],
    );

    blocTest<SettingsCubit, SettingsState>(
      'NotificationService.cancelAll() çağrıldı mı verify',
      build: () {
        when(mockNotificationService.cancelAll()).thenAnswer((_) async {});
        when(mockRepository.clearSettings())
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (c) => c.clearSettings(),
      verify: (_) => verify(mockNotificationService.cancelAll()).called(1),
    );

    blocTest<SettingsCubit, SettingsState>(
      'repository.clearSettings() çağrıldı mı verify',
      build: () {
        when(mockNotificationService.cancelAll()).thenAnswer((_) async {});
        when(mockRepository.clearSettings())
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (c) => c.clearSettings(),
      verify: (_) => verify(mockRepository.clearSettings()).called(1),
    );

    blocTest<SettingsCubit, SettingsState>(
      'repository hata → Error state emit edilir',
      build: () {
        when(mockNotificationService.cancelAll()).thenAnswer((_) async {});
        when(mockRepository.clearSettings())
            .thenAnswer((_) async => Left(CacheFailure('clear hatası')));
        return cubit;
      },
      act: (c) => c.clearSettings(),
      expect: () => [const SettingsError(message: 'clear hatası')],
    );
  });
}
