// test/features/stock/data/repositories/daily_entry_repository_impl_test.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/errror/failure.dart';
import 'package:hesap/feature/stock/data/datasources/daily_entry_datasource.dart';
import 'package:hesap/feature/stock/data/repositories/daily_entry_repository_impl.dart';
import 'package:hesap/feature/stock/domain/entities/daily_stock_entry.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'daily_entry_repository_impl_test.mocks.dart';

@GenerateMocks([DailyEntryLocalDatasource])
void main() {
  late DailyEntryRepositoryImpl repository;
  late MockDailyEntryLocalDatasource mockDatasource;

  final tEntries = [
    DailyStockEntry(
      id: 'e1',
      productId: 'p1',
      productName: 'Un',
      productUnit: 'kg',
      previousQuantity: 360,
      currentQuantity: 300,
      unitPrice: 18.0,
      date: DateTime(2025, 1, 1),
    ),
  ];

  setUp(() {
    mockDatasource = MockDailyEntryLocalDatasource();
    repository = DailyEntryRepositoryImpl(mockDatasource);
  });

  group('DailyEntryRepositoryImpl', () {
    group('saveDailyEntries', () {
      test('datasource\'u doğru parametrelerle çağırmalı', () async {
        // Arrange
        when(mockDatasource.saveDailyEntries(tEntries))
            .thenAnswer((_) async {});

        // Act
        await repository.saveDailyEntries(tEntries);

        // Assert
        verify(mockDatasource.saveDailyEntries(tEntries)).called(1);
      });

      test('başarılıysa Right(unit) dönmeli', () async {
        // Arrange
        when(mockDatasource.saveDailyEntries(tEntries))
            .thenAnswer((_) async {});

        // Act
        final result = await repository.saveDailyEntries(tEntries);

        // Assert
        expect(result, const Right(unit));
      });

      test('exception fırlatılınca Left(CacheFailure) dönmeli', () async {
        // Arrange
        when(mockDatasource.saveDailyEntries(any))
            .thenThrow(Exception('DB hatası'));

        // Act
        final result = await repository.saveDailyEntries(tEntries);

        // Assert
        expect(result, isA<Left>());
        result.fold(
          (failure) {
            expect(failure, isA<CacheFailure>());
            expect(failure.message, contains('DB hatası'));
          },
          (_) => fail('Left bekleniyor'),
        );
      });
    });
  });
}
