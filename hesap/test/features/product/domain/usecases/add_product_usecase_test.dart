// test/features/product/domain/usecases/add_product_usecase_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hesap/core/errror/failure.dart';
import 'package:hesap/features/product/domain/entities/product.dart';
import 'package:hesap/features/product/domain/repositories/product_repository.dart';
import 'package:hesap/features/product/domain/usecases/add_product_usecase.dart';

class MockProductRepository extends Mock implements ProductRepository {}

class FakeProduct extends Fake implements Product {}

Product fakeProduct({String id = 'test-id'}) => Product(
      id: id,
      name: 'Test Ürün',
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
  late AddProductUseCase usecase;

  setUpAll(() {
    registerFallbackValue(FakeProduct());
  });

  setUp(() {
    mockRepo = MockProductRepository();
    usecase = AddProductUseCase(mockRepo);
  });

  test('başarılı → Right(unit) döner', () async {
    when(() => mockRepo.addProduct(any())).thenAnswer((_) async => Right(unit));

    final result = await usecase(fakeProduct());

    expect(result, Right(unit));
    verify(() => mockRepo.addProduct(any())).called(1);
  });

  test('hata → Left(CacheFailure) döner', () async {
    when(() => mockRepo.addProduct(any()))
        .thenAnswer((_) async => Left(CacheFailure('Ekleme hatası')));

    final result = await usecase(fakeProduct());

    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, 'Ekleme hatası');
      },
      (_) => fail('Left beklendi'),
    );
  });

  test('repository.addProduct tam olarak bir kez çağrılır', () async {
    when(() => mockRepo.addProduct(any())).thenAnswer((_) async => Right(unit));

    await usecase(fakeProduct());

    verify(() => mockRepo.addProduct(any())).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
