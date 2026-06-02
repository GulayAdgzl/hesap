import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/core/theme/app_theme.dart';
import 'package:hesap/feature/settings/data/datasources/settings_local_datasource.dart';
import 'package:hesap/feature/settings/data/repositories/settings_repository_impl.dart';
import 'package:hesap/feature/settings/domain/usecases/get_settings.dart';
import 'package:hesap/feature/settings/domain/usecases/save_settings.dart';
import 'package:hesap/feature/settings/presentation/bloc/settings_cubit.dart';
import 'package:hesap/feature/settings/presentation/bloc/settings_state.dart';
import 'package:hesap/feature/settings/presentation/pages/settings_page.dart';
import 'package:hesap/module/notification/notification_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_integration_test.mocks.dart';

@GenerateMocks([NotificationService])
void main() {
  late MockNotificationService mockNotificationService;

  setUp(() {
    SharedPreferences.resetStatic();
    mockNotificationService = MockNotificationService();
    when(mockNotificationService.cancelAll()).thenAnswer((_) async {});
    when(mockNotificationService.scheduleDailySummary(
            enabled: anyNamed('enabled')))
        .thenAnswer((_) async {});
    when(mockNotificationService.scheduleProductionForecast(
            enabled: anyNamed('enabled')))
        .thenAnswer((_) async {});
    when(mockNotificationService.applySettings(
            criticalStockNotification: anyNamed('criticalStockNotification'),
            dailySummary: anyNamed('dailySummary'),
            productionForecast: anyNamed('productionForecast')))
        .thenAnswer((_) async {});
  });

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Future<SettingsCubit> buildCubit({
    Map<String, Object> initialValues = const {},
  }) async {
    SharedPreferences.resetStatic();
    SharedPreferences.setMockInitialValues(initialValues);
    final prefs = await SharedPreferences.getInstance();
    final datasource = SettingsLocalDataSourceImpl(sharedPreferences: prefs);
    final repository = SettingsRepositoryImpl(localDataSource: datasource);
    return SettingsCubit(
      getSettings: GetSettings(repository: repository),
      saveSetting: SaveSetting(repository: repository),
      repository: repository,
      notificationService: mockNotificationService,
    );
  }

  Widget buildApp(SettingsCubit cubit) {
    return BlocProvider<SettingsCubit>.value(
      value: cubit,
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (prev, curr) {
          if (prev is SettingsLoaded && curr is SettingsLoaded) {
            return prev.settings.darkMode != curr.settings.darkMode;
          }
          return curr is SettingsLoaded;
        },
        builder: (context, state) {
          final isDark =
              state is SettingsLoaded ? state.settings.darkMode : false;
          return MaterialApp(
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: BlocProvider<SettingsCubit>.value(
              value: cubit,
              child: const SettingsPage(),
            ),
          );
        },
      ),
    );
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(finder, 100);
    await tester.pumpAndSettle();
  }

  // ── Uçtan uca ───────────────────────────────────────────────────────────────

  group('SharedPreferences → DataSource → Repository → Cubit → UI', () {
    testWidgets('boş prefs → default değerler UI\'da görünür', (tester) async {
      final cubit = await buildCubit();
      await tester.pumpWidget(buildApp(cubit));
      cubit.loadSettings();
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.settingsTitle), findsOneWidget);
      expect(find.text(AppStrings.settingsSectionStock), findsOneWidget);
      expect(
        find.text(
            '%${AppStrings.defaultCriticalStockThreshold.toStringAsFixed(0)}'),
        findsOneWidget,
      );
      expect(
        find.text(
            '${AppStrings.defaultForecastPeriod}${AppStrings.settingsTahminPeriyoduSuffix}'),
        findsOneWidget,
      );
      final langFinder = find.text(AppStrings.defaultLanguage);
      await scrollTo(tester, langFinder);
      expect(langFinder, findsAtLeastNWidgets(1));
    });

    testWidgets('kayıtlı prefs → doğru değerler UI\'da görünür',
        (tester) async {
      final cubit = await buildCubit(initialValues: {
        AppStrings.keyCriticalStockThreshold: 30.0,
        AppStrings.keyForecastPeriod: 14,
        AppStrings.keyLanguage: 'English',
      });
      await tester.pumpWidget(buildApp(cubit));
      cubit.loadSettings();
      await tester.pumpAndSettle();

      expect(find.text('%30'), findsOneWidget);
      expect(
        find.text('14${AppStrings.settingsTahminPeriyoduSuffix}'),
        findsOneWidget,
      );
      final langFinder = find.text('English');
      await scrollTo(tester, langFinder);
      expect(langFinder, findsAtLeastNWidgets(1));
    });

    testWidgets('loadSettings sonrası SettingsLoaded state emit edilir',
        (tester) async {
      final cubit = await buildCubit();
      await tester.pumpWidget(buildApp(cubit));
      cubit.loadSettings();
      await tester.pumpAndSettle();
      expect(cubit.state, isA<SettingsLoaded>());
    });

    testWidgets('saveSetting → getSettings → güncel değer state\'de döner',
        (tester) async {
      final cubit = await buildCubit();
      await tester.pumpWidget(buildApp(cubit));
      cubit.loadSettings();
      await tester.pumpAndSettle();

      await cubit.updateCriticalStockThreshold(35.0);
      await tester.pumpAndSettle();

      final state = cubit.state as SettingsLoaded;
      expect(state.settings.criticalStockThreshold, 35.0);
    });

    testWidgets('clearSettings → state Initial\'a döner', (tester) async {
      final cubit =
          await buildCubit(initialValues: {AppStrings.keyDarkMode: true});
      await tester.pumpWidget(buildApp(cubit));
      cubit.loadSettings();
      await tester.pumpAndSettle();

      expect(cubit.state, isA<SettingsLoaded>());
      await cubit.clearSettings();
      await tester.pump(); // ← pumpAndSettle yerine pump
      expect(cubit.state, isA<SettingsInitial>());
    });

    testWidgets('clearSettings sonrası loadSettings → default değerler döner',
        (tester) async {
      final cubit = await buildCubit(initialValues: {
        AppStrings.keyCriticalStockThreshold: 40.0,
        AppStrings.keyForecastPeriod: 30,
        AppStrings.keyDarkMode: true,
      });
      await tester.pumpWidget(buildApp(cubit));
      cubit.loadSettings();
      await tester.pumpAndSettle();

      await cubit.clearSettings();
      await tester.pump();

      cubit.loadSettings();
      await tester.pump(); // ← loadSettings başlatır
      await tester.pump(); // ← async tamamlanır, Loaded gelir

      final state = cubit.state as SettingsLoaded;
      expect(state.settings.criticalStockThreshold,
          AppStrings.defaultCriticalStockThreshold);
      expect(state.settings.forecastPeriod, AppStrings.defaultForecastPeriod);
      expect(state.settings.darkMode, AppStrings.defaultDarkMode);
    });
  });

  // ── darkMode → themeMode ───────────────────────────────────────────────────

  group('darkMode toggle → MaterialApp themeMode değişiyor', () {
    testWidgets('darkMode false → ThemeMode.light', (tester) async {
      final cubit =
          await buildCubit(initialValues: {AppStrings.keyDarkMode: false});
      await tester.pumpWidget(buildApp(cubit));
      cubit.loadSettings();
      await tester.pumpAndSettle();

      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        ThemeMode.light,
      );
    });

    testWidgets('darkMode true → ThemeMode.dark', (tester) async {
      final cubit =
          await buildCubit(initialValues: {AppStrings.keyDarkMode: true});
      await tester.pumpWidget(buildApp(cubit));
      cubit.loadSettings();
      await tester.pumpAndSettle();

      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        ThemeMode.dark,
      );
    });

    testWidgets('darkMode false → true → ThemeMode.dark\'a geçer',
        (tester) async {
      final cubit = await buildCubit();
      await tester.pumpWidget(buildApp(cubit));
      cubit.loadSettings();
      await tester.pumpAndSettle();

      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        ThemeMode.light,
      );

      await cubit.updateDarkMode(true);
      await tester.pumpAndSettle();

      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        ThemeMode.dark,
      );
    });

    testWidgets('darkMode true → false → ThemeMode.light\'a döner',
        (tester) async {
      final cubit =
          await buildCubit(initialValues: {AppStrings.keyDarkMode: true});
      await tester.pumpWidget(buildApp(cubit));
      cubit.loadSettings();
      await tester.pumpAndSettle();

      await cubit.updateDarkMode(false);
      await tester.pumpAndSettle();

      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        ThemeMode.light,
      );
    });
  });
}
