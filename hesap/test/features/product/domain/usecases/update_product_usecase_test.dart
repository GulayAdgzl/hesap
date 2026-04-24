// test/features/product/domain/usecases/update_product_usecase_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hesap/core/errror/failure.dart';
import 'package:hesap/features/product/domain/entities/product.dart';
import 'package:hesap/features/product/domain/repositories/product_repository.dart';
import 'package:hesap/features/product/domain/usecases/update_product_usecase.dart';

class MockProductRepository extends Mock implements ProductRepository {}

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
  late MockProductRepository mockRepo;
  late UpdateProductUseCase usecase;

  setUpAll(() {
    registerFallbackValue(FakeProduct());
  });

  setUp(() {
    mockRepo = MockProductRepository();
    usecase = UpdateProductUseCase(mockRepo);
  });

  test('başarılı → Right(unit) döner', () async {
    when(() => mockRepo.updateProduct(any()))
        .thenAnswer((_) async => Right(unit));

    final result = await usecase(fakeProduct());

    expect(result, Right(unit));
  });

  test('hata → Left(CacheFailure) döner', () async {
    when(() => mockRepo.updateProduct(any()))
        .thenAnswer((_) async => Left(CacheFailure('Güncelleme hatası')));

    final result = await usecase(fakeProduct());

    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, 'Güncelleme hatası');
      },
      (_) => fail('Left beklendi'),
    );
  });

  test('repository.updateProduct tam olarak bir kez çağrılır', () async {
    when(() => mockRepo.updateProduct(any()))
        .thenAnswer((_) async => Right(unit));

    await usecase(fakeProduct());

    verify(() => mockRepo.updateProduct(any())).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('güncellenmiş ürün repository\'e iletilir', () async {
    Product? capturedProduct;
    when(() => mockRepo.updateProduct(any())).thenAnswer((invocation) async {
      capturedProduct = invocation.positionalArguments[0] as Product;
      return Right(unit);
    });

    await usecase(fakeProduct(name: 'Güncellendi'));

    expect(capturedProduct?.name, 'Güncellendi');
  });
}
