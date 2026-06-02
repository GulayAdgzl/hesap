import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/feature/sub_feature/product/data/datasources/product_local_datasource.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';
import 'package:hesap/product/model/product_model.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<ProductModel> {}

class FakeProductModel extends Fake implements ProductModel {}

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

ProductModel fakeModel({String id = 'test-id', String name = 'Test Ürün'}) =>
    ProductModel(
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
  late MockBox mockBox;
  late ProductLocalDatasourceImpl datasource;

  setUpAll(() {
    registerFallbackValue(FakeProductModel());
  });

  setUp(() {
    mockBox = MockBox();
    datasource = ProductLocalDatasourceImpl(mockBox);
  });

  group('addProduct', () {
    test('box.put doğru id ile çağrılır', () async {
      when(() => mockBox.put('abc', any<ProductModel>()))
          .thenAnswer((_) async {});

      await datasource.addProduct(fakeProduct(id: 'abc'));

      verify(() => mockBox.put('abc', any<ProductModel>())).called(1);
    });

    test('box.put bir kez çağrılır', () async {
      when(() => mockBox.put(any(), any<ProductModel>()))
          .thenAnswer((_) async {});

      await datasource.addProduct(fakeProduct());

      verify(() => mockBox.put(any(), any<ProductModel>())).called(1);
    });
  });

  group('getAllProducts', () {
    test('box.values → Product listesine dönüştürülür', () async {
      when(() => mockBox.values).thenReturn([
        fakeModel(id: '1', name: 'Un'),
        fakeModel(id: '2', name: 'Şeker'),
      ]);

      final result = await datasource.getAllProducts();

      expect(result.length, 2);
      expect(result[0].name, 'Un');
      expect(result[1].name, 'Şeker');
    });

    test('box boşsa boş liste döner', () async {
      when(() => mockBox.values).thenReturn([]);

      final result = await datasource.getAllProducts();

      expect(result, isEmpty);
    });

    test('model doğru entity\'e dönüşür', () async {
      when(() => mockBox.values).thenReturn([
        fakeModel(id: 'x', name: 'Tuz'),
      ]);

      final result = await datasource.getAllProducts();

      expect(result.first.id, 'x');
      expect(result.first.name, 'Tuz');
      expect(result.first, isA<Product>());
    });
  });

  group('updateProduct', () {
    test('box.put doğru id ile çağrılır', () async {
      when(() => mockBox.put('guncelle', any<ProductModel>()))
          .thenAnswer((_) async {});

      await datasource.updateProduct(fakeProduct(id: 'guncelle'));

      verify(() => mockBox.put('guncelle', any<ProductModel>())).called(1);
    });

    test('box.put bir kez çağrılır', () async {
      when(() => mockBox.put(any(), any<ProductModel>()))
          .thenAnswer((_) async {});

      await datasource.updateProduct(fakeProduct());

      verify(() => mockBox.put(any(), any<ProductModel>())).called(1);
    });
  });

  group('deleteProduct', () {
    test('box.delete doğru id ile çağrılır', () async {
      when(() => mockBox.delete('sil-beni')).thenAnswer((_) async {});

      await datasource.deleteProduct('sil-beni');

      verify(() => mockBox.delete('sil-beni')).called(1);
    });

    test('box.delete bir kez çağrılır', () async {
      when(() => mockBox.delete('test-id')).thenAnswer((_) async {});

      await datasource.deleteProduct('test-id');

      verify(() => mockBox.delete('test-id')).called(1);
    });
  });
}
