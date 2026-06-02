import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/feature/stock/domain/entities/daily_stock_entry.dart';

void main() {
  group('DailyStockEntryX', () {
    late DailyStockEntry entry;

    setUp(() {
      entry = DailyStockEntry(
        id: 'test-id',
        productId: 'product-1',
        productName: 'Un',
        productUnit: 'kg',
        previousQuantity: 360,
        currentQuantity: 180,
        unitPrice: 18.0,
        date: DateTime(2025, 1, 1),
      );
    });

    group('consumed', () {
      test('tüketim doğru hesaplanmalı', () {
        expect(entry.consumed, 180); // 360 - 180
      });

      test('tüketim sıfır olabilmeli', () {
        final noConsumption = entry.copyWith(currentQuantity: 360);
        expect(noConsumption.consumed, 0);
      });

      test('stok artışında tüketim negatif olabilmeli', () {
        final increased = entry.copyWith(currentQuantity: 400);
        expect(increased.consumed, -40); // 360 - 400
      });
    });

    group('totalCost', () {
      test('toplam maliyet doğru hesaplanmalı', () {
        // consumed: 180, unitPrice: 18.0 → 180 * 18 = 3240
        expect(entry.totalCost, 3240.0);
      });

      test('tüketim sıfırsa maliyet sıfır olmalı', () {
        final noConsumption = entry.copyWith(currentQuantity: 360);
        expect(noConsumption.totalCost, 0.0);
      });

      test('negatif tüketimde maliyet negatif olmalı', () {
        final increased = entry.copyWith(currentQuantity: 400);
        expect(increased.totalCost, -720.0); // -40 * 18
      });

      test('ondalıklı birim fiyatla doğru hesaplanmalı', () {
        final decimalPrice = entry.copyWith(unitPrice: 18.5);
        expect(decimalPrice.totalCost, 3330.0); // 180 * 18.5
      });
    });

    group('hasNegativeStock', () {
      test('negatif stokta true dönmeli', () {
        final negative = entry.copyWith(currentQuantity: -10);
        expect(negative.hasNegativeStock, true);
      });

      test('sıfır stokta false dönmeli', () {
        final zero = entry.copyWith(currentQuantity: 0);
        expect(zero.hasNegativeStock, false);
      });

      test('pozitif stokta false dönmeli', () {
        expect(entry.hasNegativeStock, false);
      });
    });
  });
}
