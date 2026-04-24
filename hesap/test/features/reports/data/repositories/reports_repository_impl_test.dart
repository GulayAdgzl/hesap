import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hesap/features/reports/data/datasources/reports_local_datasource.dart';
import 'package:hesap/features/reports/data/repositories/reports_repository_impl.dart';
import 'package:hesap/features/reports/domain/entities/report_filter.dart';
import 'package:hesap/features/reports/domain/entities/report_summary.dart';
import 'package:hesap/features/stock/domain/entities/daily_stock_entry.dart';

// ---------------------------------------------------------------------------
// Mock
// ---------------------------------------------------------------------------

class MockReportsLocalDatasource extends Mock
    implements ReportsLocalDatasource {}

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

DailyStockEntry _entry({
  String id = 'e1',
  String productId = 'p1',
  String productName = 'Un',
  String productUnit = 'kg',
  int previousQuantity = 50,
  int currentQuantity = 30,
  double unitPrice = 5.0,
  DateTime? date,
}) =>
    DailyStockEntry(
      id: id,
      productId: productId,
      productName: productName,
      productUnit: productUnit,
      previousQuantity: previousQuantity,
      currentQuantity: currentQuantity,
      unitPrice: unitPrice,
      date: date ?? DateTime(2024, 3, 15),
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockReportsLocalDatasource datasource;
  late ReportsRepositoryImpl repository;

  setUp(() {
    datasource = MockReportsLocalDatasource();
    repository = ReportsRepositoryImpl(datasource);

    // Önceki dönem için varsayılan boş dönüş
    when(() => datasource.getEntriesBetween(any(), any()))
        .thenAnswer((_) async => []);
  });

  // ── getSummary ────────────────────────────────────────────────────────────

  group('getSummary', () {
    test('kayıt yoksa ReportSummary.empty döndürmeli', () async {
      when(() => datasource.getEntriesBetween(any(), any()))
          .thenAnswer((_) async => []);

      final filter = const ReportFilter(period: ReportPeriod.thisWeek);
      final result = await repository.getSummary(filter);

      expect(result.totalConsumption, 0);
      expect(result.totalCost, 0);
      expect(result.consumptionChangePercent, isNull);
    });

    test('toplam tüketimi doğru hesaplamalı', () async {
      // consumed = previousQuantity - currentQuantity
      // e1: 50-30=20, e2: 40-10=30 → toplam=50
      final entries = [
        _entry(id: 'e1', previousQuantity: 50, currentQuantity: 30),
        _entry(id: 'e2', previousQuantity: 40, currentQuantity: 10),
      ];

      when(() => datasource.getEntriesBetween(any(), any()))
          .thenAnswer((_) async => entries);

      final result = await repository.getSummary(
        const ReportFilter(period: ReportPeriod.thisWeek),
      );

      expect(result.totalConsumption, 50);
    });

    test('toplam maliyeti doğru hesaplamalı', () async {
      // e1: consumed=20, price=5 → 100
      // e2: consumed=30, price=3 → 90 → toplam=190
      final entries = [
        _entry(
            id: 'e1',
            previousQuantity: 50,
            currentQuantity: 30,
            unitPrice: 5.0),
        _entry(
            id: 'e2',
            previousQuantity: 40,
            currentQuantity: 10,
            unitPrice: 3.0),
      ];

      when(() => datasource.getEntriesBetween(any(), any()))
          .thenAnswer((_) async => entries);

      final result = await repository.getSummary(
        const ReportFilter(period: ReportPeriod.thisWeek),
      );

      expect(result.totalCost, closeTo(190.0, 0.01));
    });

    test('günlük ortalama maliyeti doğru hesaplamalı', () async {
      // 2 farklı gün, toplam maliyet 200 → ortalama 100
      final entries = [
        _entry(
            id: 'e1',
            previousQuantity: 50,
            currentQuantity: 30,
            unitPrice: 5.0,
            date: DateTime(2024, 3, 15)), // 20*5=100
        _entry(
            id: 'e2',
            previousQuantity: 40,
            currentQuantity: 20,
            unitPrice: 5.0,
            date: DateTime(2024, 3, 16)), // 20*5=100
      ];

      when(() => datasource.getEntriesBetween(any(), any()))
          .thenAnswer((_) async => entries);

      final result = await repository.getSummary(
        const ReportFilter(period: ReportPeriod.thisWeek),
      );

      expect(result.dailyAverageCost, closeTo(100.0, 0.01));
    });

    test('günlük maliyet serisi doğru oluşturulmalı', () async {
      final entries = [
        _entry(
            id: 'e1',
            previousQuantity: 50,
            currentQuantity: 30,
            unitPrice: 5.0,
            date: DateTime(2024, 3, 15)), // 100
        _entry(
            id: 'e2',
            previousQuantity: 30,
            currentQuantity: 10,
            unitPrice: 5.0,
            date: DateTime(2024, 3, 15)), // 100 → aynı gün 200
        _entry(
            id: 'e3',
            previousQuantity: 40,
            currentQuantity: 20,
            unitPrice: 4.0,
            date: DateTime(2024, 3, 16)), // 80
      ];

      when(() => datasource.getEntriesBetween(any(), any()))
          .thenAnswer((_) async => entries);

      final result = await repository.getSummary(
        const ReportFilter(period: ReportPeriod.thisWeek),
      );

      expect(
          result.dailyCostSeries[DateTime(2024, 3, 15)], closeTo(200.0, 0.01));
      expect(
          result.dailyCostSeries[DateTime(2024, 3, 16)], closeTo(80.0, 0.01));
    });

    test('önceki dönem verisi varsa changePercent hesaplanmalı', () async {
      final currentEntries = [
        _entry(
            id: 'e1', previousQuantity: 60, currentQuantity: 30), // consumed=30
      ];
      final prevEntries = [
        _entry(
            id: 'e2', previousQuantity: 50, currentQuantity: 30), // consumed=20
      ];

      var callCount = 0;
      when(() => datasource.getEntriesBetween(any(), any()))
          .thenAnswer((_) async {
        callCount++;
        return callCount == 1 ? currentEntries : prevEntries;
      });

      final result = await repository.getSummary(
        const ReportFilter(period: ReportPeriod.thisWeek),
      );

      // (30-20)/20 * 100 = +50%
      expect(result.consumptionChangePercent, closeTo(50.0, 0.01));
    });

    test('önceki dönem verisi yoksa changePercent null olmalı', () async {
      final currentEntries = [
        _entry(id: 'e1', previousQuantity: 50, currentQuantity: 30),
      ];

      var callCount = 0;
      when(() => datasource.getEntriesBetween(any(), any()))
          .thenAnswer((_) async {
        callCount++;
        return callCount == 1 ? currentEntries : [];
      });

      final result = await repository.getSummary(
        const ReportFilter(period: ReportPeriod.thisWeek),
      );

      expect(result.consumptionChangePercent, isNull);
    });

    test('negatif tüketim (stok artışı) hesaba katılmamalı', () async {
      final entries = [
        _entry(
            id: 'e1',
            previousQuantity: 30,
            currentQuantity: 50), // consumed=-20
      ];

      when(() => datasource.getEntriesBetween(any(), any()))
          .thenAnswer((_) async => entries);

      final result = await repository.getSummary(
        const ReportFilter(period: ReportPeriod.thisWeek),
      );

      expect(result.totalConsumption, 0); // clamp(0,...)
      expect(result.totalCost, 0);
    });
  });

  // ── getTopConsumed ────────────────────────────────────────────────────────

  group('getTopConsumed', () {
    test('kayıt yoksa boş liste döndürmeli', () async {
      when(() => datasource.getEntriesBetween(any(), any()))
          .thenAnswer((_) async => []);

      final result = await repository.getTopConsumed(
        const ReportFilter(period: ReportPeriod.thisWeek),
      );

      expect(result, isEmpty);
    });

    test('tüketime göre azalan sıralanmalı', () async {
      final entries = [
        _entry(
            id: 'e1',
            productId: 'p1',
            productName: 'Un',
            previousQuantity: 30,
            currentQuantity: 10), // consumed=20
        _entry(
            id: 'e2',
            productId: 'p2',
            productName: 'Tereyagi',
            previousQuantity: 60,
            currentQuantity: 10), // consumed=50
        _entry(
            id: 'e3',
            productId: 'p3',
            productName: 'Seker',
            previousQuantity: 40,
            currentQuantity: 30), // consumed=10
      ];

      when(() => datasource.getEntriesBetween(any(), any()))
          .thenAnswer((_) async => entries);

      final result = await repository.getTopConsumed(
        const ReportFilter(period: ReportPeriod.thisWeek),
      );

      expect(result[0].productName, 'Tereyagi'); // 50
      expect(result[1].productName, 'Un'); // 20
      expect(result[2].productName, 'Seker'); // 10
    });

    test('aynı ürünün birden fazla kaydı toplanmalı', () async {
      final entries = [
        _entry(
            id: 'e1',
            productId: 'p1',
            productName: 'Un',
            previousQuantity: 50,
            currentQuantity: 30), // consumed=20
        _entry(
            id: 'e2',
            productId: 'p1',
            productName: 'Un',
            previousQuantity: 40,
            currentQuantity: 20), // consumed=20 → toplam 40
      ];

      when(() => datasource.getEntriesBetween(any(), any()))
          .thenAnswer((_) async => entries);

      final result = await repository.getTopConsumed(
        const ReportFilter(period: ReportPeriod.thisWeek),
      );

      expect(result.length, 1);
      expect(result.first.totalConsumed, 40);
    });

    test('toplam maliyeti doğru hesaplamalı', () async {
      final entries = [
        _entry(
            id: 'e1',
            productId: 'p1',
            previousQuantity: 50,
            currentQuantity: 30,
            unitPrice: 5.0), // 100
        _entry(
            id: 'e2',
            productId: 'p1',
            previousQuantity: 40,
            currentQuantity: 20,
            unitPrice: 5.0), // 100
      ];

      when(() => datasource.getEntriesBetween(any(), any()))
          .thenAnswer((_) async => entries);

      final result = await repository.getTopConsumed(
        const ReportFilter(period: ReportPeriod.thisWeek),
      );

      expect(result.first.totalCost, closeTo(200.0, 0.01));
    });

    test('negatif tüketim olan kayıtlar göz ardı edilmeli', () async {
      final entries = [
        _entry(
            id: 'e1',
            productId: 'p1',
            previousQuantity: 20,
            currentQuantity: 50), // consumed=-30
      ];

      when(() => datasource.getEntriesBetween(any(), any()))
          .thenAnswer((_) async => entries);

      final result = await repository.getTopConsumed(
        const ReportFilter(period: ReportPeriod.thisWeek),
      );

      expect(result, isEmpty);
    });
  });
}
