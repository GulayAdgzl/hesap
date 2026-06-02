import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/feature/reports/domain/usecases/get_report_summary.dart';
import 'package:hesap/feature/reports/domain/usecases/get_top_consumed.dart';
import 'package:hesap/feature/reports/presentation/bloc/reports_cubit.dart';
import 'package:hesap/feature/reports/presentation/bloc/reports_state.dart';
import 'package:hesap/module/csv_export/csv_export_service.dart';
import 'package:hesap/module/report_summary/entities/report_filter.dart';
import 'package:hesap/module/report_summary/entities/report_summary.dart';
import 'package:hesap/module/report_summary/entities/top_consumed_item.dart';
import 'package:mocktail/mocktail.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockGetReportSummary extends Mock implements GetReportSummary {}

class MockGetTopConsumed extends Mock implements GetTopConsumed {}

class MockCsvExportService extends Mock implements CsvExportService {}

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

final _filter = const ReportFilter();

final _summary = ReportSummary(
  totalConsumption: 100,
  totalCost: 500,
  consumptionChangePercent: 10.0,
  dailyAverageCost: 71.4,
  dailyCostSeries: {},
);

const _topConsumed = <TopConsumedItem>[
  TopConsumedItem(
    productId: 'p1',
    productName: 'Un',
    productUnit: 'kg',
    totalConsumed: 100,
    totalCost: 500,
  ),
];

ReportsLoaded _loaded([ReportFilter? filter]) => ReportsLoaded(
      filter: filter ?? _filter,
      summary: _summary,
      topConsumed: _topConsumed,
      entries: const [],
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockGetReportSummary getReportSummary;
  late MockGetTopConsumed getTopConsumed;
  late MockCsvExportService csvExportService;

  setUpAll(() {
    registerFallbackValue(const ReportFilter());
  });

  setUp(() {
    getReportSummary = MockGetReportSummary();
    getTopConsumed = MockGetTopConsumed();
    csvExportService = MockCsvExportService();

    when(() => getReportSummary(any())).thenAnswer((_) async => _summary);
    when(() => getTopConsumed(any())).thenAnswer((_) async => _topConsumed);
    when(() => csvExportService.exportTopConsumed(
          items: any(named: 'items'),
          filter: any(named: 'filter'),
        )).thenAnswer((_) async {});
  });

  ReportsCubit _cubit() => ReportsCubit(
        getReportSummary: getReportSummary,
        getTopConsumed: getTopConsumed,
        csvExportService: csvExportService,
      );

  // ── load() ────────────────────────────────────────────────────────────────

  group('load()', () {
    blocTest<ReportsCubit, ReportsState>(
      'Loading → Loaded emit etmeli',
      build: _cubit,
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<ReportsLoading>(),
        isA<ReportsLoaded>(),
      ],
    );

    blocTest<ReportsCubit, ReportsState>(
      'Loaded state filter varsayılan olmalı',
      build: _cubit,
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<ReportsLoading>(),
        isA<ReportsLoaded>().having(
          (s) => s.filter.period,
          'period',
          ReportPeriod.thisWeek,
        ),
      ],
    );

    blocTest<ReportsCubit, ReportsState>(
      'Loaded state summary ve topConsumed dolu olmalı',
      build: _cubit,
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<ReportsLoading>(),
        isA<ReportsLoaded>()
            .having((s) => s.summary, 'summary', _summary)
            .having((s) => s.topConsumed, 'topConsumed', _topConsumed),
      ],
    );

    blocTest<ReportsCubit, ReportsState>(
      'hata olursa Loading → ReportsError emit etmeli',
      build: () {
        when(() => getReportSummary(any()))
            .thenThrow(Exception('Veri alinamadi'));
        return _cubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<ReportsLoading>(),
        isA<ReportsError>(),
      ],
    );

    blocTest<ReportsCubit, ReportsState>(
      'hata mesajı ReportsError içinde olmalı',
      build: () {
        when(() => getReportSummary(any()))
            .thenThrow(Exception('Veri alinamadi'));
        return _cubit();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<ReportsLoading>(),
        isA<ReportsError>().having(
          (s) => s.message,
          'message',
          contains('Veri alinamadi'),
        ),
      ],
    );
  });

  // ── changeFilter() ────────────────────────────────────────────────────────

  group('changeFilter()', () {
    blocTest<ReportsCubit, ReportsState>(
      'Loading → Loaded emit etmeli',
      build: _cubit,
      act: (cubit) => cubit.changeFilter(
        const ReportFilter(period: ReportPeriod.thisMonth),
      ),
      expect: () => [
        isA<ReportsLoading>(),
        isA<ReportsLoaded>(),
      ],
    );

    blocTest<ReportsCubit, ReportsState>(
      'Loaded state yeni filtreyi içermeli',
      build: _cubit,
      act: (cubit) => cubit.changeFilter(
        const ReportFilter(period: ReportPeriod.thisMonth),
      ),
      expect: () => [
        isA<ReportsLoading>(),
        isA<ReportsLoaded>().having(
          (s) => s.filter.period,
          'period',
          ReportPeriod.thisMonth,
        ),
      ],
    );

    blocTest<ReportsCubit, ReportsState>(
      'hata olursa ReportsError emit etmeli',
      build: () {
        when(() => getReportSummary(any()))
            .thenThrow(Exception('Filtre hatasi'));
        return _cubit();
      },
      act: (cubit) => cubit.changeFilter(
        const ReportFilter(period: ReportPeriod.thisMonth),
      ),
      expect: () => [
        isA<ReportsLoading>(),
        isA<ReportsError>(),
      ],
    );
  });

  // ── exportCsv() ───────────────────────────────────────────────────────────

  group('exportCsv()', () {
    blocTest<ReportsCubit, ReportsState>(
      'state ReportsLoaded değilse hiçbir şey emit etmemeli',
      build: _cubit,
      seed: () => ReportsLoading(),
      act: (cubit) => cubit.exportCsv(),
      expect: () => [],
    );

    blocTest<ReportsCubit, ReportsState>(
      'başarılı export: ReportsExporting → ReportsLoaded emit etmeli',
      build: _cubit,
      seed: () => _loaded(),
      act: (cubit) => cubit.exportCsv(),
      expect: () => [
        isA<ReportsExporting>(),
        isA<ReportsLoaded>(),
      ],
    );

    blocTest<ReportsCubit, ReportsState>(
      'export sonrası dönen Loaded state öncekiyle aynı olmalı',
      build: _cubit,
      seed: () => _loaded(),
      act: (cubit) => cubit.exportCsv(),
      expect: () => [
        isA<ReportsExporting>(),
        isA<ReportsLoaded>()
            .having((s) => s.summary, 'summary', _summary)
            .having((s) => s.topConsumed, 'topConsumed', _topConsumed),
      ],
    );

    blocTest<ReportsCubit, ReportsState>(
      'export hatası: ReportsExporting → ReportsExportError → ReportsLoaded',
      build: () {
        when(() => csvExportService.exportTopConsumed(
              items: any(named: 'items'),
              filter: any(named: 'filter'),
            )).thenThrow(Exception('Export hatasi'));
        return _cubit();
      },
      seed: () => _loaded(),
      act: (cubit) => cubit.exportCsv(),
      expect: () => [
        isA<ReportsExporting>(),
        isA<ReportsExportError>(),
        isA<ReportsLoaded>(),
      ],
    );

    blocTest<ReportsCubit, ReportsState>(
      'export hata mesajı ReportsExportError içinde olmalı',
      build: () {
        when(() => csvExportService.exportTopConsumed(
              items: any(named: 'items'),
              filter: any(named: 'filter'),
            )).thenThrow(Exception('Export hatasi'));
        return _cubit();
      },
      seed: () => _loaded(),
      act: (cubit) => cubit.exportCsv(),
      expect: () => [
        isA<ReportsExporting>(),
        isA<ReportsExportError>().having(
          (s) => s.message,
          'message',
          contains('Export hatasi'),
        ),
        isA<ReportsLoaded>(),
      ],
    );

    blocTest<ReportsCubit, ReportsState>(
      'exportTopConsumed doğru parametrelerle çağrılmalı',
      build: _cubit,
      seed: () => _loaded(),
      act: (cubit) => cubit.exportCsv(),
      verify: (_) {
        verify(() => csvExportService.exportTopConsumed(
              items: _topConsumed,
              filter: _filter,
            )).called(1);
      },
    );
  });
}
