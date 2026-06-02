import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/errror/failure.dart';
import 'package:hesap/feature/stock/domain/entities/daily_stock_entry.dart';
import 'package:hesap/feature/stock/domain/repositories/daily_entry_repository.dart';
import 'package:hesap/feature/stock/domain/usecases/save_daily_entries_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_daily_entries_usecase_test.mocks.dart';

@GenerateMocks([DailyEntryRepository])
void main() {
  late SaveDailyEntriesUseCase useCase;
  late MockDailyEntryRepository mockRepository;

  setUp(() {
    mockRepository = MockDailyEntryRepository();
    useCase = SaveDailyEntriesUseCase(mockRepository);
  });

  final tEntries = [
    DailyStockEntry(
      id: 'entry-1',
      productId: 'product-1',
      productName: 'Un',
      productUnit: 'kg',
      previousQuantity: 360,
      currentQuantity: 180,
      unitPrice: 18.0,
      date: DateTime(2025, 1, 1),
    ),
    DailyStockEntry(
      id: 'entry-2',
      productId: 'product-2',
      productName: 'Şeker',
      productUnit: 'kg',
      previousQuantity: 100,
      currentQuantity: 60,
      unitPrice: 22.0,
      date: DateTime(2025, 1, 1),
    ),
  ];

  group('SaveDailyEntriesUseCase', () {
    test('repository başarılı dönünce Right(unit) gelmeli', () async {
      when(mockRepository.saveDailyEntries(tEntries))
          .thenAnswer((_) async => const Right(unit));

      final result = await useCase(tEntries);

      expect(result, const Right(unit));
      verify(mockRepository.saveDailyEntries(tEntries));
      verifyNoMoreInteractions(mockRepository);
    });

    test('repository hata dönünce Left(Failure) gelmeli', () async {
      final tFailure = CacheFailure('Kayıt hatası');
      when(mockRepository.saveDailyEntries(tEntries))
          .thenAnswer((_) async => Left(tFailure));

      final result = await useCase(tEntries);

      expect(result, Left(tFailure));
      verify(mockRepository.saveDailyEntries(tEntries));
      verifyNoMoreInteractions(mockRepository);
    });

    test('boş liste ile çağrılınca repository yine de çağrılmalı', () async {
      when(mockRepository.saveDailyEntries([]))
          .thenAnswer((_) async => const Right(unit));

      final result = await useCase([]);

      expect(result, const Right(unit));
      verify(mockRepository.saveDailyEntries([]));
    });
  });
}
