// test/features/product/data/repositories/product_repository_impl_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hesap/core/errror/failure.dart';
import 'package:hesap/features/product/data/datasources/product_local_datasource.dart';
import 'package:hesap/features/product/data/repositories/product_repository_impl.dart';
import 'package:hesap/features/product/domain/entities/product.dart';

class MockProductLocalDatasource extends Mock
    implements ProductLocalDatasource {}

class FakeProduct extends Fake implements Product {}

Product fakeProduct({String id = 'test-id', String name = 'Test Ürün'}) =>
    Product(
      id: id,
      name: name,
      unit: 'kg',
      price: 10.0,
      quantity: 100,
      description: '',
      imageUrl: '',
      categoryId: '',
      createdAt: DateTime(2024),
      criticalThreshold: 15.0,
      maxStock: 500,
    );

void main() {
  late MockProductLocalDatasource mockDatasource;
  late ProductRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeProduct());
  });

  setUp(() {
    mockDatasource = MockProductLocalDatasource();
    repository = ProductRepositoryImpl(mockDatasource);
  });

  // ─────────────────────────────────────────
  // addProduct
  // ─────────────────────────────────────────
  group('addProduct', () {
    test('başarılı → Right(unit) döner', () async {
      when(() => mockDatasource.addProduct(any())).thenAnswer((_) async {});

      final result = await repository.addProduct(fakeProduct());

      expect(result, const Right(unit));
    });

    test('hata → Left(CacheFailure) döner', () async {
      when(() => mockDatasource.addProduct(any()))
          .thenThrow(Exception('hive hatası'));

      final result = await repository.addProduct(fakeProduct());

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Left beklendi'),
      );
    });
  });

  // ─────────────────────────────────────────
  // getAllProducts
  // ─────────────────────────────────────────
  group('getAllProducts', () {
    test('başarılı → Right(products) döner', () async {
      when(() => mockDatasource.getAllProducts()).thenAnswer(
        (_) async => [fakeProduct(id: '1'), fakeProduct(id: '2')],
      );

      final result = await repository.getAllProducts();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Right beklendi'),
        (products) => expect(products.length, 2),
      );
    });

    test('boş liste → Right([]) döner', () async {
      when(() => mockDatasource.getAllProducts()).thenAnswer((_) async => []);

      final result = await repository.getAllProducts();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Right beklendi'),
        (products) => expect(products, isEmpty),
      );
    });

    test('hata → Left(CacheFailure) döner', () async {
      when(() => mockDatasource.getAllProducts())
          .thenThrow(Exception('hive hatası'));

      final result = await repository.getAllProducts();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Left beklendi'),
      );
    });
  });

  // ─────────────────────────────────────────
  // updateProduct
  // ─────────────────────────────────────────
  group('updateProduct', () {
    test('başarılı → Right(unit) döner', () async {
      when(() => mockDatasource.updateProduct(any())).thenAnswer((_) async {});

      final result = await repository.updateProduct(fakeProduct());

      expect(result, const Right(unit));
    });

    test('hata → Left(CacheFailure) döner', () async {
      when(() => mockDatasource.updateProduct(any()))
          .thenThrow(Exception('hive hatası'));

      final result = await repository.updateProduct(fakeProduct());

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Left beklendi'),
      );
    });
  });

  // ─────────────────────────────────────────
  // deleteProduct
  // ─────────────────────────────────────────
  group('deleteProduct', () {
    test('başarılı → Right(unit) döner', () async {
      when(() => mockDatasource.deleteProduct(any())).thenAnswer((_) async {});

      final result = await repository.deleteProduct('test-id');

      expect(result, const Right(unit));
    });

    test('hata → Left(CacheFailure) döner', () async {
      when(() => mockDatasource.deleteProduct(any()))
          .thenThrow(Exception('hive hatası'));

      final result = await repository.deleteProduct('test-id');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Left beklendi'),
      );
    });

    test('doğru id datasource\'a iletilir', () async {
      when(() => mockDatasource.deleteProduct(any())).thenAnswer((_) async {});

      await repository.deleteProduct('sil-beni');

      verify(() => mockDatasource.deleteProduct('sil-beni')).called(1);
    });
  });
}
