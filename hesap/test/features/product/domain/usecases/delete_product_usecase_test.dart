// test/features/product/domain/usecases/delete_product_usecase_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hesap/core/errror/failure.dart';
import 'package:hesap/features/product/domain/repositories/product_repository.dart';
import 'package:hesap/features/product/domain/usecases/delete_product_usecase.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository mockRepo;
  late DeleteProductUseCase usecase;

  setUp(() {
    mockRepo = MockProductRepository();
    usecase = DeleteProductUseCase(mockRepo);
  });

  test('başarılı → Right(unit) döner', () async {
    when(() => mockRepo.deleteProduct(any()))
        .thenAnswer((_) async => Right(unit));

    final result = await usecase('test-id');

    expect(result, Right(unit));
  });

  test('hata → Left(CacheFailure) döner', () async {
    when(() => mockRepo.deleteProduct(any()))
        .thenAnswer((_) async => Left(CacheFailure('Silme hatası')));

    final result = await usecase('test-id');

    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, 'Silme hatası');
      },
      (_) => fail('Left beklendi'),
    );
  });

  test('repository.deleteProduct doğru id ile çağrılır', () async {
    when(() => mockRepo.deleteProduct(any()))
        .thenAnswer((_) async => Right(unit));

    await usecase('sil-beni');

    verify(() => mockRepo.deleteProduct('sil-beni')).called(1);
  });

  test('repository.deleteProduct tam olarak bir kez çağrılır', () async {
    when(() => mockRepo.deleteProduct(any()))
        .thenAnswer((_) async => Right(unit));

    await usecase('test-id');

    verify(() => mockRepo.deleteProduct(any())).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
