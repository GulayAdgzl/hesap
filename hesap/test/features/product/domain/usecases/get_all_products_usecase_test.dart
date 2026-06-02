// test/features/product/domain/usecases/get_all_products_usecase_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/errror/failure.dart';
import 'package:hesap/feature/sub_feature/product/data/repositories/product_repository.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';
import 'package:hesap/feature/sub_feature/product/usecases/get_all_products_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

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
  late GetAllProductsUseCase usecase;

  setUp(() {
    mockRepo = MockProductRepository();
    usecase = GetAllProductsUseCase(mockRepo);
  });

  test('başarılı → Right(products) döner', () async {
    when(() => mockRepo.getAllProducts()).thenAnswer(
      (_) async => Right([fakeProduct(id: '1'), fakeProduct(id: '2')]),
    );

    final result = await usecase();

    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Right beklendi'),
      (products) => expect(products.length, 2),
    );
  });

  test('boş liste → Right([]) döner', () async {
    when(() => mockRepo.getAllProducts())
        .thenAnswer((_) async => const Right([]));

    final result = await usecase();

    expect(result.isRight(), true);
    result.fold(
      (_) => fail('Right beklendi'),
      (products) => expect(products, isEmpty),
    );
  });

  test('hata → Left(CacheFailure) döner', () async {
    when(() => mockRepo.getAllProducts()).thenAnswer(
      (_) async => Left(CacheFailure('Yükleme hatası')),
    );

    final result = await usecase();

    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, 'Yükleme hatası');
      },
      (_) => fail('Left beklendi'),
    );
  });

  test('repository.getAllProducts tam olarak bir kez çağrılır', () async {
    when(() => mockRepo.getAllProducts())
        .thenAnswer((_) async => const Right([]));

    await usecase();

    verify(() => mockRepo.getAllProducts()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
