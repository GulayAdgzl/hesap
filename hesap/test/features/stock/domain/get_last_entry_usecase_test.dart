import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/errror/failure.dart';
import 'package:hesap/feature/stock/domain/entities/daily_stock_entry.dart';
import 'package:hesap/feature/stock/domain/repositories/daily_entry_repository.dart';
import 'package:hesap/feature/stock/domain/usecases/get_last_entry_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_last_entry_usecase_test.mocks.dart';

@GenerateMocks([DailyEntryRepository])
void main() {
  late GetLastEntryForProductUseCase useCase;
  late MockDailyEntryRepository mockRepository;

  setUp(() {
    mockRepository = MockDailyEntryRepository();
    useCase = GetLastEntryForProductUseCase(mockRepository);
  });

  const tProductId = 'product-1';

  final tEntry = DailyStockEntry(
    id: 'entry-1',
    productId: tProductId,
    productName: 'Un',
    productUnit: 'kg',
    previousQuantity: 360,
    currentQuantity: 180,
    unitPrice: 18.0,
    date: DateTime(2025, 1, 1),
  );

  group('GetLastEntryForProductUseCase', () {
    test('kayıt varsa doğru entry dönmeli', () async {
      when(mockRepository.getLastEntryForProduct(tProductId))
          .thenAnswer((_) async => Right(tEntry));

      final result = await useCase(tProductId);

      expect(result, Right(tEntry));
      verify(mockRepository.getLastEntryForProduct(tProductId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('kayıt yoksa Right(null) dönmeli', () async {
      when(mockRepository.getLastEntryForProduct(tProductId))
          .thenAnswer((_) async => const Right(null));

      final result = await useCase(tProductId);

      expect(result, const Right(null));
      verify(mockRepository.getLastEntryForProduct(tProductId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('repository hata dönünce Left(Failure) gelmeli', () async {
      final tFailure = CacheFailure('Okuma hatası');
      when(mockRepository.getLastEntryForProduct(tProductId))
          .thenAnswer((_) async => Left(tFailure));

      final result = await useCase(tProductId);

      expect(result, Left(tFailure));
      verify(mockRepository.getLastEntryForProduct(tProductId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
