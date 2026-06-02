import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/feature/settings/domain/entities/app_settings.dart';
import 'package:hesap/feature/settings/presentation/bloc/settings_cubit.dart';
import 'package:hesap/feature/settings/presentation/bloc/settings_state.dart';
import 'package:hesap/feature/settings/presentation/pages/settings_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'settings_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SettingsCubit>()])
void main() {
  late MockSettingsCubit mockCubit;

  const tSettings = AppSettings(
    criticalStockThreshold: 15.0,
    forecastPeriod: 7,
    criticalStockNotification: true,
    dailySummary: true,
    productionForecast: false,
    darkMode: false,
    language: 'Türkçe',
  );

  setUp(() {
    mockCubit = MockSettingsCubit();
    when(mockCubit.state).thenReturn(const SettingsLoaded(settings: tSettings));
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget buildWidget({SettingsState? initialState}) {
    if (initialState != null) {
      when(mockCubit.state).thenReturn(initialState);
    }
    return MaterialApp(
      home: BlocProvider<SettingsCubit>.value(
        value: mockCubit,
        child: const SettingsPage(),
      ),
    );
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(finder, 100);
    await tester.pumpAndSettle();
  }

  // Switch sırası (page'deki görünüm sırasına göre):
  // 0 → Kritik Stok Bildirimi
  // 1 → Günlük Özet
  // 2 → Üretim Tahmini
  // 3 → Koyu Tema
  const int _switchKritikStok = 0;
  const int _switchGunlukOzet = 1;
  const int _switchKoyuTema = 3;

  // ── SettingsLoading ────────────────────────────────────────────────────────

  group('SettingsLoading', () {
    testWidgets('CircularProgressIndicator gösterilir', (tester) async {
      await tester.pumpWidget(
        buildWidget(initialState: const SettingsLoading()),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('section başlıkları görünmez', (tester) async {
      await tester.pumpWidget(
        buildWidget(initialState: const SettingsLoading()),
      );
      expect(find.text(AppStrings.settingsSectionStock), findsNothing);
      expect(find.text(AppStrings.settingsSectionNotifications), findsNothing);
      expect(find.text(AppStrings.settingsSectionApp), findsNothing);
    });
  });

  // ── SettingsLoaded ─────────────────────────────────────────────────────────

  group('SettingsLoaded — section başlıkları', () {
    testWidgets('Ayarlar page title görünür', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.settingsTitle), findsOneWidget);
    });

    testWidgets('STOK AYARLARI başlığı görünür', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.settingsSectionStock), findsOneWidget);
    });

    testWidgets('BİLDİRİMLER başlığı görünür', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      final finder = find.text(AppStrings.settingsSectionNotifications);
      await scrollTo(tester, finder);
      expect(finder, findsOneWidget);
    });

    testWidgets('UYGULAMA başlığı görünür', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      final finder = find.text(AppStrings.settingsSectionApp);
      await scrollTo(tester, finder);
      expect(finder, findsOneWidget);
    });

    testWidgets('Kritik Stok Eşiği satırı görünür', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.settingsKritikStokEsigi), findsOneWidget);
    });

    testWidgets('Tahmin Periyodu satırı görünür', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.settingsTahminPeriyodu), findsOneWidget);
    });

    testWidgets('Koyu Tema satırı görünür', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      final finder = find.text(AppStrings.settingsKoyuTemaLabel);
      await scrollTo(tester, finder);
      expect(finder, findsOneWidget);
    });

    testWidgets('Çıkış Yap butonu görünür', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      final finder = find.text(AppStrings.settingsLogout);
      await scrollTo(tester, finder);
      expect(finder, findsOneWidget);
    });
  });

  // ── Toggle tap ─────────────────────────────────────────────────────────────

  group('Toggle tap → cubit metodları çağrılıyor', () {
    testWidgets('Günlük Özet Switch tap → updateDailySummary(false) çağrılır',
        (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Önce label'ı görünür yap, sonra Switch'i index ile tap et
      await scrollTo(tester, find.text(AppStrings.settingsGunlukOzetLabel));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Switch).at(_switchGunlukOzet));
      await tester.pumpAndSettle();

      verify(mockCubit.updateDailySummary(false)).called(1);
    });

    testWidgets(
        'Kritik Stok Bildirimi Switch tap → updateCriticalStockNotification(false) çağrılır',
        (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      await scrollTo(
          tester, find.text(AppStrings.settingsKritikStokBildirimLabel));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Switch).at(_switchKritikStok));
      await tester.pumpAndSettle();

      verify(mockCubit.updateCriticalStockNotification(false)).called(1);
    });

    testWidgets('Koyu Tema Switch tap → updateDarkMode(true) çağrılır',
        (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Koyu Tema scroll + tüm Switch'leri yükle
      await scrollTo(tester, find.text(AppStrings.settingsKoyuTemaLabel));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Switch).at(_switchKoyuTema));
      await tester.pumpAndSettle();

      verify(mockCubit.updateDarkMode(true)).called(1);
    });
  });

  // ── Çıkış Yap dialog ──────────────────────────────────────────────────────

  group('Çıkış Yap → dialog açılıyor', () {
    Future<void> openLogoutDialog(WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      final logoutFinder = find.text(AppStrings.settingsLogout);
      await scrollTo(tester, logoutFinder);
      await tester.tap(logoutFinder);
      await tester.pumpAndSettle();
    }

    testWidgets('logout butona tap → AlertDialog görünür', (tester) async {
      await openLogoutDialog(tester);
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('dialog içinde confirm butonu görünür', (tester) async {
      await openLogoutDialog(tester);
      expect(find.text(AppStrings.settingsLogoutConfirm), findsOneWidget);
    });

    testWidgets('dialog içinde iptal butonu görünür', (tester) async {
      await openLogoutDialog(tester);
      expect(find.text(AppStrings.cancel), findsOneWidget);
    });

    testWidgets('İptal butonuna tap → dialog kapanır', (tester) async {
      await openLogoutDialog(tester);
      await tester.tap(find.text(AppStrings.cancel));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('Onayla butonuna tap → clearSettings çağrılır', (tester) async {
      await openLogoutDialog(tester);
      await tester.tap(find.text(AppStrings.settingsLogoutConfirm));
      await tester.pumpAndSettle();
      verify(mockCubit.clearSettings()).called(1);
    });
  });

  // ── Dil satırı → language picker ──────────────────────────────────────────

  group('Dil satırı tap → language picker bottom sheet', () {
    Future<void> openLanguagePicker(WidgetTester tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      final dilFinder = find.text(AppStrings.settingsDilLabel);
      await scrollTo(tester, dilFinder);
      await tester.tap(dilFinder);
      await tester.pumpAndSettle();
    }

    testWidgets('Dil satırına tap → bottom sheet açılır', (tester) async {
      await openLanguagePicker(tester);
      expect(find.byType(BottomSheet), findsOneWidget);
    });

    testWidgets('bottom sheet içinde dil seçenekleri görünür', (tester) async {
      await openLanguagePicker(tester);
      // Türkçe page'de value olarak da göründüğünden findsAtLeastNWidgets
      expect(find.text('Türkçe'), findsAtLeastNWidgets(1));
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Deutsch'), findsOneWidget);
      expect(find.text('Français'), findsOneWidget);
      expect(find.text('Español'), findsOneWidget);
    });

    testWidgets('dil seçince updateLanguage çağrılır', (tester) async {
      await openLanguagePicker(tester);
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      verify(mockCubit.updateLanguage('English')).called(1);
    });

    testWidgets('dil seçince bottom sheet kapanır', (tester) async {
      await openLanguagePicker(tester);
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
    });
  });
}
