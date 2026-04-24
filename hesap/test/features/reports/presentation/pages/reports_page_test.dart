import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/features/reports/domain/entities/report_filter.dart';
import 'package:hesap/features/reports/domain/entities/report_summary.dart';
import 'package:hesap/features/reports/domain/entities/top_consumed_item.dart';
import 'package:hesap/features/reports/presentation/bloc/reports_cubit.dart';
import 'package:hesap/features/reports/presentation/bloc/reports_state.dart';
import 'package:hesap/features/reports/presentation/pages/reports_page.dart';
import 'package:hesap/features/reports/presentation/widgets/reports_filter_bar.dart';
import 'package:hesap/features/reports/presentation/widgets/reports_summary_grid.dart';
import 'package:hesap/features/reports/presentation/widgets/reports_trend_chart.dart';
import 'package:hesap/features/reports/presentation/widgets/reports_top_consumed_list.dart';
import 'package:hesap/features/reports/presentation/widgets/reports_csv_export_button.dart';

// ---------------------------------------------------------------------------
// Mock
// ---------------------------------------------------------------------------

class MockReportsCubit extends MockCubit<ReportsState>
    implements ReportsCubit {}

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

final _filter = const ReportFilter();

final _summary = ReportSummary(
  totalConsumption: 3847,
  totalCost: 128400,
  consumptionChangePercent: 18.0,
  dailyAverageCost: 4060,
  dailyCostSeries: {
    DateTime(2024, 1, 1): 1200,
    DateTime(2024, 1, 2): 1800,
    DateTime(2024, 1, 3): 900,
  },
);

final _topConsumed = [
  const TopConsumedItem(
    productId: 'p1',
    productName: 'Un',
    productUnit: 'kg',
    totalConsumed: 540,
    totalCost: 68000,
  ),
  const TopConsumedItem(
    productId: 'p2',
    productName: 'Tereyagi',
    productUnit: 'kg',
    totalConsumed: 110,
    totalCost: 73000,
  ),
];

ReportsLoaded _loaded({
  ReportFilter? filter,
  ReportSummary? summary,
  List<TopConsumedItem>? topConsumed,
}) =>
    ReportsLoaded(
      filter: filter ?? _filter,
      summary: summary ?? _summary,
      topConsumed: topConsumed ?? _topConsumed,
      entries: [],
    );

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

Widget _page(MockReportsCubit cubit) => BlocProvider<ReportsCubit>(
      create: (_) => cubit,
      child: const MaterialApp(home: ReportsPage()),
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // ── FIX 1: ReportFilter için fallback kaydı ─────────────────────────────
  setUpAll(() {
    registerFallbackValue(const ReportFilter());
  });

  late MockReportsCubit cubit;

  setUp(() {
    cubit = MockReportsCubit();
    when(() => cubit.load()).thenAnswer((_) async {});
    when(() => cubit.exportCsv()).thenAnswer((_) async {});
  });

  // ── 1. load() çağrısı ────────────────────────────────────────────────────

  testWidgets('Sayfa acilinca load() cagriliyor mu?', (tester) async {
    when(() => cubit.state).thenReturn(ReportsLoading());

    await tester.pumpWidget(_page(cubit));
    await tester.pump();

    verify(() => cubit.load()).called(1);
  });

  // ── 2. Loading spinner ───────────────────────────────────────────────────

  testWidgets('Loading statinde spinner gorunuyor mu?', (tester) async {
    when(() => cubit.state).thenReturn(ReportsLoading());

    await tester.pumpWidget(_page(cubit));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  // ── 3. Filtre bar ────────────────────────────────────────────────────────

  testWidgets('Filtre bar render ediliyor mu?', (tester) async {
    when(() => cubit.state).thenReturn(_loaded());

    await tester.pumpWidget(_page(cubit));
    await tester.pump();

    expect(find.byType(ReportsFilterBar), findsOneWidget);
    expect(find.text('Bu Hafta'), findsOneWidget);
    expect(find.text('Bu Ay'), findsOneWidget);
    expect(find.text('Ozel'), findsOneWidget);
  });

  // ── 4. Filtre değişince changeFilter() ───────────────────────────────────
  // FIX 1: registerFallbackValue ile düzeltildi

  testWidgets('Filtre degisince changeFilter() cagriliyor mu?', (tester) async {
    when(() => cubit.state).thenReturn(_loaded());
    when(() => cubit.changeFilter(any())).thenAnswer((_) async {});

    await tester.pumpWidget(_page(cubit));
    await tester.pump();

    await tester.tap(find.text('Bu Ay'));
    await tester.pump();

    verify(() => cubit.changeFilter(any())).called(1);
  });

  // ── 5. Özet grid ─────────────────────────────────────────────────────────

  testWidgets('Loaded statinde ozet grid 4 kart gosteriyor mu?',
      (tester) async {
    when(() => cubit.state).thenReturn(_loaded());

    await tester.pumpWidget(_page(cubit));
    await tester.pump();

    expect(find.byType(ReportsSummaryGrid), findsOneWidget);
    expect(find.text('Toplam Tüketim'), findsOneWidget);
    expect(find.text('Toplam Maliyet'), findsOneWidget);
    expect(find.text('Geçen haftaya göre'), findsOneWidget);
    expect(find.text('Günlük ortalama'), findsOneWidget);
  });

  // ── 6. Trend chart ───────────────────────────────────────────────────────
  // FIX 2: ListView içinde scroll ile bul

  testWidgets('Trend chart render ediliyor mu?', (tester) async {
    when(() => cubit.state).thenReturn(_loaded());

    await tester.pumpWidget(_page(cubit));
    await tester.pump();

    await tester.scrollUntilVisible(
      find.byType(ReportsTrendChart),
      200,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.byType(ReportsTrendChart), findsOneWidget);
    expect(find.text('Günlük Maliyet Trendi'), findsOneWidget);
  });

  // ── 7. Top consumed list ─────────────────────────────────────────────────
  // FIX 2: scroll ile bul

  testWidgets('Top consumed list urun adlarini gosteriyor mu?', (tester) async {
    when(() => cubit.state).thenReturn(_loaded());

    await tester.pumpWidget(_page(cubit));
    await tester.pump();

    await tester.scrollUntilVisible(
      find.byType(ReportsTopConsumedList),
      200,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.byType(ReportsTopConsumedList), findsOneWidget);
    expect(find.text('Un'), findsOneWidget);
    expect(find.text('Tereyagi'), findsOneWidget);
  });

  // ── 8. CSV export butonu görünüyor mu? ───────────────────────────────────
  // FIX 2: scroll ile bul

  testWidgets('CSV export butonu gorunuyor mu?', (tester) async {
    when(() => cubit.state).thenReturn(_loaded());

    await tester.pumpWidget(_page(cubit));
    await tester.pump();

    await tester.scrollUntilVisible(
      find.byType(ReportsCsvExportButton),
      200,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.byType(ReportsCsvExportButton), findsOneWidget);
    expect(find.text(AppStrings.csvExport), findsOneWidget);
  });

  // ── 9. Export butonu exportCsv() çağırıyor mu? ───────────────────────────
  // FIX 2: scroll ile butona ulaş

  testWidgets('Export butonuna tiklaninca exportCsv() cagriliyor mu?',
      (tester) async {
    when(() => cubit.state).thenReturn(_loaded());

    await tester.pumpWidget(_page(cubit));
    await tester.pump();

    await tester.scrollUntilVisible(
      find.text(AppStrings.csvExport),
      200,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.tap(find.text(AppStrings.csvExport));
    await tester.pump();

    verify(() => cubit.exportCsv()).called(1);
  });

  // ── 10. Export sırasında butonlar disabled ────────────────────────────────
  // FIX 3: header IconButton'ı kontrol et (her zaman görünür, scroll gerekmez)

  testWidgets('Export sirasinda header ikonu disabled oluyor mu?',
      (tester) async {
    when(() => cubit.state).thenReturn(ReportsExporting());

    await tester.pumpWidget(_page(cubit));
    await tester.pump();

    // Header'daki IconButton ReportsExporting'de onPressed=null olmalı
    final iconButton = tester.widget<IconButton>(
      find.byType(IconButton).first,
    );
    expect(iconButton.onPressed, isNull);
  });

  // ── 11. ReportsExportError snackbar ──────────────────────────────────────

  testWidgets('ReportsExportError gelince kirmizi snackbar cikiyor mu?',
      (tester) async {
    const errorMessage = 'CSV olusturulurken hata olustu';

    whenListen(
      cubit,
      Stream.fromIterable([
        _loaded(),
        ReportsExportError(errorMessage),
        _loaded(),
      ]),
      initialState: _loaded(),
    );

    await tester.pumpWidget(_page(cubit));
    await tester.pump();
    await tester.pump();

    expect(find.text(errorMessage), findsOneWidget);

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.backgroundColor, equals(AppColors.danger));
  });

  // ── 12. Hata state'inde hata mesajı ─────────────────────────────────────

  testWidgets('Hata statinde hata mesaji gorunuyor mu?', (tester) async {
    const errorMessage = 'Veriler yuklenemedi';
    when(() => cubit.state).thenReturn(ReportsError(errorMessage));

    await tester.pumpWidget(_page(cubit));
    await tester.pump();

    expect(find.text(errorMessage), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
