import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/feature/stock/data/datasources/daily_entry_datasource.dart';
import 'package:hesap/product/model/daily_stock_entry_model.dart';
import 'package:hive_ce/hive.dart';

void main() {
  late Box<DailyStockEntryModel> box;
  late DailyEntryLocalDatasourceImpl datasource;
  late Directory tempDir;
  setUp(() async {
    // Adapter zaten kayıtlıysa tekrar kaydetme
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(DailyStockEntryModelAdapter());
    }

    tempDir = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tempDir.path);

    box = await Hive.openBox<DailyStockEntryModel>('test_box');
    datasource = DailyEntryLocalDatasourceImpl(box);
  });

  tearDown(() async {
    await box.clear(); // içeriği temizle
    await Hive.close(); // önce kapat
    await tempDir.delete(recursive: true); // sonra sil
  });

  // ── Yardımcı fonksiyonlar ─────────────────────────────────────────────
  Future<void> putModel(DailyStockEntryModel model) => box.put(model.id, model);

  DailyStockEntryModel makeModel({
    required String id,
    required String productId,
    required DateTime date,
    int previousQuantity = 100,
    int currentQuantity = 80,
  }) =>
      DailyStockEntryModel(
        id: id,
        productId: productId,
        productName: 'Test',
        productUnit: 'kg',
        previousQuantity: previousQuantity,
        currentQuantity: currentQuantity,
        unitPrice: 10.0,
        date: date,
      );

  // ─────────────────────────────────────────────
  group('getEntriesByDate', () {
    test('sadece aynı günün kayıtlarını getirmeli', () async {
      final hedef = DateTime(2025, 6, 15, 10, 0);
      final farkliGun = DateTime(2025, 6, 16, 10, 0);

      await putModel(makeModel(id: 'e1', productId: 'p1', date: hedef));
      await putModel(makeModel(id: 'e2', productId: 'p2', date: hedef));
      await putModel(makeModel(id: 'e3', productId: 'p3', date: farkliGun));

      final result = await datasource.getEntriesByDate(hedef);

      expect(result.length, 2);
      expect(result.map((e) => e.id), containsAll(['e1', 'e2']));
      expect(result.map((e) => e.id), isNot(contains('e3')));
    });

    test('aynı günün farklı saatleri de dahil edilmeli', () async {
      await putModel(makeModel(
          id: 'sabah', productId: 'p1', date: DateTime(2025, 6, 15, 8, 0)));
      await putModel(makeModel(
          id: 'aksam', productId: 'p1', date: DateTime(2025, 6, 15, 22, 30)));

      final result = await datasource.getEntriesByDate(DateTime(2025, 6, 15));

      expect(result.length, 2);
    });

    test('o güne ait kayıt yoksa boş liste dönmeli', () async {
      await putModel(
          makeModel(id: 'e1', productId: 'p1', date: DateTime(2025, 6, 14)));

      final result = await datasource.getEntriesByDate(DateTime(2025, 6, 15));

      expect(result, isEmpty);
    });
  });

  // ─────────────────────────────────────────────
  group('getLastEntryForProduct', () {
    test('en son tarihe göre sıralayıp ilk kaydı dönmeli', () async {
      await putModel(makeModel(
        id: 'eski',
        productId: 'p1',
        date: DateTime(2025, 1, 1),
        currentQuantity: 111,
      ));
      await putModel(makeModel(
        id: 'yeni',
        productId: 'p1',
        date: DateTime(2025, 6, 1),
        currentQuantity: 999,
      ));

      final result = await datasource.getLastEntryForProduct('p1');

      expect(result, isNotNull);
      expect(result!.id, 'yeni');
      expect(result.currentQuantity, 999);
    });

    test('başka ürünün kayıtları sonucu etkilememeli', () async {
      await putModel(makeModel(
        id: 'p1-kayit',
        productId: 'p1',
        date: DateTime(2025, 6, 1),
        currentQuantity: 50,
      ));
      await putModel(makeModel(
        id: 'p2-kayit',
        productId: 'p2',
        date: DateTime(2025, 12, 31),
        currentQuantity: 999,
      ));

      final result = await datasource.getLastEntryForProduct('p1');

      expect(result!.id, 'p1-kayit');
      expect(result.currentQuantity, 50);
    });

    test('ürüne ait kayıt yoksa null dönmeli', () async {
      final result = await datasource.getLastEntryForProduct('olmayan-id');

      expect(result, isNull);
    });
  });
}
