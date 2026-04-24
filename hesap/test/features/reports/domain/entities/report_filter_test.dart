import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/features/reports/domain/entities/report_filter.dart';
import 'package:hesap/features/reports/domain/entities/report_summary.dart';

void main() {
  group('ReportFilter', () {
    // ── thisWeek ───────────────────────────────────────────────────────────

    test('thisWeek startDate haftanın ilk günü (Pazartesi) olmalı', () {
      final filter = const ReportFilter(period: ReportPeriod.thisWeek);
      final now = DateTime.now();
      final expected = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: now.weekday - 1));

      expect(filter.startDate.year, expected.year);
      expect(filter.startDate.month, expected.month);
      expect(filter.startDate.day, expected.day);
    });

    test('thisWeek endDate bugün olmalı', () {
      final filter = const ReportFilter(period: ReportPeriod.thisWeek);
      final now = DateTime.now();

      expect(filter.endDate.year, now.year);
      expect(filter.endDate.month, now.month);
      expect(filter.endDate.day, now.day);
    });

    // ── thisMonth ──────────────────────────────────────────────────────────

    test('thisMonth startDate ayın ilk günü olmalı', () {
      final filter = const ReportFilter(period: ReportPeriod.thisMonth);
      final now = DateTime.now();

      expect(filter.startDate, DateTime(now.year, now.month, 1));
    });

    test('thisMonth endDate bugün olmalı', () {
      final filter = const ReportFilter(period: ReportPeriod.thisMonth);
      final now = DateTime.now();

      expect(filter.endDate.year, now.year);
      expect(filter.endDate.month, now.month);
      expect(filter.endDate.day, now.day);
    });

    // ── custom ─────────────────────────────────────────────────────────────

    test('custom startDate verilen customStart değerini döndürmeli', () {
      final start = DateTime(2024, 3, 10);
      final end = DateTime(2024, 3, 20);
      final filter = ReportFilter(
        period: ReportPeriod.custom,
        customStart: start,
        customEnd: end,
      );

      expect(filter.startDate, start);
    });

    test('custom endDate verilen customEnd değerini döndürmeli', () {
      final start = DateTime(2024, 3, 10);
      final end = DateTime(2024, 3, 20);
      final filter = ReportFilter(
        period: ReportPeriod.custom,
        customStart: start,
        customEnd: end,
      );

      expect(filter.endDate, end);
    });

    test('custom customStart null ise 7 gün öncesini döndürmeli', () {
      final filter = const ReportFilter(period: ReportPeriod.custom);
      final expected = DateTime.now().subtract(const Duration(days: 7));

      expect(filter.startDate.day, expected.day);
    });

    test('custom customEnd null ise bugünü döndürmeli', () {
      final filter = const ReportFilter(period: ReportPeriod.custom);
      final now = DateTime.now();

      expect(filter.endDate.day, now.day);
    });

    // ── copyWith ───────────────────────────────────────────────────────────

    test('copyWith period değiştirince diğer alanlar korunmalı', () {
      final start = DateTime(2024, 1, 1);
      final end = DateTime(2024, 1, 31);
      final filter = ReportFilter(
        period: ReportPeriod.custom,
        customStart: start,
        customEnd: end,
      );

      final updated = filter.copyWith(period: ReportPeriod.thisMonth);

      expect(updated.period, ReportPeriod.thisMonth);
      expect(updated.customStart, start);
      expect(updated.customEnd, end);
    });

    test('varsayılan period thisWeek olmalı', () {
      const filter = ReportFilter();
      expect(filter.period, ReportPeriod.thisWeek);
    });
  });

  // ── ReportSummary.empty ────────────────────────────────────────────────

  group('ReportSummary.empty', () {
    test('totalConsumption sıfır olmalı', () {
      expect(ReportSummary.empty.totalConsumption, 0);
    });

    test('totalCost sıfır olmalı', () {
      expect(ReportSummary.empty.totalCost, 0);
    });

    test('consumptionChangePercent null olmalı', () {
      expect(ReportSummary.empty.consumptionChangePercent, isNull);
    });

    test('dailyAverageCost sıfır olmalı', () {
      expect(ReportSummary.empty.dailyAverageCost, 0);
    });

    test('dailyCostSeries boş olmalı', () {
      expect(ReportSummary.empty.dailyCostSeries, isEmpty);
    });
  });
}
