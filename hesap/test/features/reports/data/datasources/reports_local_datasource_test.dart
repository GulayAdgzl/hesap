import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive_ce/hive.dart';
import 'package:hesap/core/models/daily_stock_entry_model.dart';
import 'package:hesap/features/reports/data/datasources/reports_local_datasource.dart';

// ---------------------------------------------------------------------------
// Mock
// ---------------------------------------------------------------------------

class MockBox extends Mock implements Box<DailyStockEntryModel> {}

// ---------------------------------------------------------------------------
// Fixture
// ---------------------------------------------------------------------------

DailyStockEntryModel _model({
  required String id,
  required DateTime date,
  int previousQuantity = 50,
  int currentQuantity = 40,
}) =>
    DailyStockEntryModel(
      id: id,
      productId: 'p1',
      productName: 'Un',
      productUnit: 'kg',
      previousQuantity: previousQuantity,
      currentQuantity: currentQuantity,
      unitPrice: 5.0,
      date: date,
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockBox box;
  late ReportsLocalDatasourceImpl datasource;

  setUp(() {
    box = MockBox();
    datasource = ReportsLocalDatasourceImpl(box);
  });

  group('ReportsLocalDatasource.getEntriesBetween', () {
    test('aralık içindeki kayıtları döndürmeli', () async {
      final inRange = _model(id: '1', date: DateTime(2024, 3, 15));
      final models = [inRange];
      when(() => box.values).thenReturn(models);

      final result = await datasource.getEntriesBetween(
        DateTime(2024, 3, 10),
        DateTime(2024, 3, 20),
      );

      expect(result.length, 1);
      expect(result.first.id, '1');
    });

    test('aralık dışındaki kayıtları döndürmemeli', () async {
      final outOfRange = _model(id: '2', date: DateTime(2024, 3, 5));
      when(() => box.values).thenReturn([outOfRange]);

      final result = await datasource.getEntriesBetween(
        DateTime(2024, 3, 10),
        DateTime(2024, 3, 20),
      );

      expect(result, isEmpty);
    });

    test('başlangıç tarihi dahil olmalı', () async {
      final onStart = _model(id: '3', date: DateTime(2024, 3, 10, 0, 0, 0));
      when(() => box.values).thenReturn([onStart]);

      final result = await datasource.getEntriesBetween(
        DateTime(2024, 3, 10),
        DateTime(2024, 3, 20),
      );

      expect(result.length, 1);
    });

    test('bitiş tarihi dahil olmalı (23:59:59)', () async {
      final onEnd = _model(id: '4', date: DateTime(2024, 3, 20, 23, 59, 58));
      when(() => box.values).thenReturn([onEnd]);

      final result = await datasource.getEntriesBetween(
        DateTime(2024, 3, 10),
        DateTime(2024, 3, 20),
      );

      expect(result.length, 1);
    });

    test('box boşsa boş liste döndürmeli', () async {
      when(() => box.values).thenReturn([]);

      final result = await datasource.getEntriesBetween(
        DateTime(2024, 3, 10),
        DateTime(2024, 3, 20),
      );

      expect(result, isEmpty);
    });

    test('birden fazla kayıt varsa hepsini döndürmeli', () async {
      final models = [
        _model(id: '1', date: DateTime(2024, 3, 11)),
        _model(id: '2', date: DateTime(2024, 3, 13)),
        _model(id: '3', date: DateTime(2024, 3, 15)),
        _model(id: '4', date: DateTime(2024, 3, 25)), // dışarıda
      ];
      when(() => box.values).thenReturn(models);

      final result = await datasource.getEntriesBetween(
        DateTime(2024, 3, 10),
        DateTime(2024, 3, 20),
      );

      expect(result.length, 3);
      expect(result.map((e) => e.id), containsAll(['1', '2', '3']));
    });

    test('döndürülen entity alanları model ile eşleşmeli', () async {
      final model = _model(
        id: 'e1',
        date: DateTime(2024, 3, 15),
        previousQuantity: 100,
        currentQuantity: 80,
      );
      when(() => box.values).thenReturn([model]);

      final result = await datasource.getEntriesBetween(
        DateTime(2024, 3, 10),
        DateTime(2024, 3, 20),
      );

      expect(result.first.id, 'e1');
      expect(result.first.previousQuantity, 100);
      expect(result.first.currentQuantity, 80);
      expect(result.first.productName, 'Un');
    });
  });
}
