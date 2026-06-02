import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';
import 'package:hesap/feature/sub_feature/product/pages/product_filter.dart';

Product fakeProduct({
  String id = 'test-id',
  String name = 'Test Ürün',
  int quantity = 100,
  int maxStock = 500,
  double criticalThreshold = 15.0,
}) =>
    Product(
      id: id,
      name: name,
      unit: 'kg',
      price: 10.0,
      quantity: quantity,
      description: '',
      imageUrl: '',
      categoryId: '',
      createdAt: DateTime(2024),
      criticalThreshold: criticalThreshold,
      maxStock: maxStock,
    );

void main() {
  final products = [
    fakeProduct(id: '1', name: 'Un', quantity: 5, maxStock: 500), // kritik
    fakeProduct(id: '2', name: 'Şeker', quantity: 450, maxStock: 500), // normal
    fakeProduct(id: '3', name: 'Tuz', quantity: 200, maxStock: 500), // normal
  ];

  group('arama filtresi', () {
    test('eşleşen ürünü döner', () {
      final result = ProductFilter.apply(
        products: products,
        filter: AppStrings.filterAll,
        search: 'un',
      );
      expect(result.length, 1);
      expect(result.first.name, 'Un');
    });

    test('büyük/küçük harf duyarsız çalışır', () {
      final result = ProductFilter.apply(
        products: products,
        filter: AppStrings.filterAll,
        search: 'UN',
      );
      expect(result.length, 1);
      expect(result.first.name, 'Un');
    });

    test('eşleşme yoksa boş liste döner', () {
      final result = ProductFilter.apply(
        products: products,
        filter: AppStrings.filterAll,
        search: 'xyz',
      );
      expect(result, isEmpty);
    });

    test('arama boşsa tüm ürünler döner', () {
      final result = ProductFilter.apply(
        products: products,
        filter: AppStrings.filterAll,
        search: '',
      );
      expect(result.length, 3);
    });
  });

  group('Tümü filtresi', () {
    test('tüm ürünleri döner', () {
      final result = ProductFilter.apply(
        products: products,
        filter: AppStrings.filterAll,
        search: '',
      );
      expect(result.length, 3);
    });
  });

  group('Kritik filtresi', () {
    test('sadece kritik ürünleri döner', () {
      final result = ProductFilter.apply(
        products: products,
        filter: AppStrings.filterCritical,
        search: '',
      );
      expect(result.length, 1);
      expect(result.first.name, 'Un');
    });

    test('kritik ürün yoksa boş liste döner', () {
      final normalProducts = [
        fakeProduct(id: '1', quantity: 450, maxStock: 500),
      ];
      final result = ProductFilter.apply(
        products: normalProducts,
        filter: AppStrings.filterCritical,
        search: '',
      );
      expect(result, isEmpty);
    });
  });

  group('Normal filtresi', () {
    test('sadece normal ürünleri döner', () {
      final result = ProductFilter.apply(
        products: products,
        filter: AppStrings.filterNormal,
        search: '',
      );
      expect(result.length, 2);
      expect(result.any((p) => p is Product && p.name == 'Un'), false);
    });
  });

  group('En Çok Tüketilen filtresi', () {
    test('quantity\'ye göre azalan sıralar', () {
      final result = ProductFilter.apply(
        products: products,
        filter: AppStrings.filterMostConsumed,
        search: '',
      );
      expect(result.first.name, 'Şeker'); // 450
      expect(result.last.name, 'Un'); // 5
    });
  });

  group('arama + filtre birlikte', () {
    test('arama ve filtre birlikte çalışır', () {
      final result = ProductFilter.apply(
        products: products,
        filter: AppStrings.filterNormal,
        search: 'şeker',
      );
      expect(result.length, 1);
      expect(result.first.name, 'Şeker');
    });
  });
}
