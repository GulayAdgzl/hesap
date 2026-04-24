import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/errror/failure.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:hesap/features/product/domain/entities/product.dart';
import 'package:hesap/features/product/domain/usecases/get_all_products_usecase.dart';
import 'package:hesap/features/stock/domain/usecases/get_last_entry_usecase.dart';
import 'package:hesap/features/stock/domain/usecases/save_daily_entries_usecase.dart';
import 'package:hesap/features/stock/presentation/bloc/daily_entry_cubit.dart';
import 'package:hesap/features/stock/presentation/bloc/daily_entry_state.dart';

import 'daily_entry_cubit_load_test.mocks.dart';
import 'daily_entry_cubit_load_test.mocks.dart' hide MockGetAllProductsUseCase;

@GenerateMocks([
  GetAllProductsUseCase,
  SaveDailyEntriesUseCase,
  GetLastEntryForProductUseCase,
])
void main() {
  late DailyEntryCubit cubit;
  late MockGetAllProductsUseCase mockGetAllProducts;
  late MockSaveDailyEntriesUseCase mockSaveEntries;
  late MockGetLastEntryForProductUseCase mockGetLastEntry;

  setUp(() {
    mockGetAllProducts = MockGetAllProductsUseCase();
    mockSaveEntries = MockSaveDailyEntriesUseCase();
    mockGetLastEntry = MockGetLastEntryForProductUseCase();

    cubit = DailyEntryCubit(
      getAllProductsUseCase: mockGetAllProducts,
      saveDailyEntriesUseCase: mockSaveEntries,
      getLastEntryForProductUseCase: mockGetLastEntry,
    );
  });

  tearDown(() => cubit.close());

  final tProducts = [
    Product(
      id: 'p1',
      name: 'Un',
      price: 18.0,
      quantity: 360,
      description: '',
      imageUrl: '',
      categoryId: '',
      createdAt: DateTime(2025, 1, 1),
      unit: 'kg',
      maxStock: 500,
    ),
    Product(
      id: 'p2',
      name: 'Şeker',
      price: 22.0,
      quantity: 100,
      description: '',
      imageUrl: '',
      categoryId: '',
      createdAt: DateTime(2025, 1, 1),
      unit: 'kg',
      maxStock: 200,
    ),
  ];

  group('loadProducts', () {
    blocTest<DailyEntryCubit, DailyEntryState>(
      'başlangıçta Loading sonra Loaded emit etmeli',
      build: () {
        when(mockGetAllProducts()).thenAnswer((_) async => Right(tProducts));
        when(mockGetLastEntry(any)).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (c) => c.loadProducts(),
      expect: () => [
        isA<DailyEntryLoading>(),
        isA<DailyEntryLoaded>(),
      ],
    );

    blocTest<DailyEntryCubit, DailyEntryState>(
      'Loaded state ürünleri içermeli',
      build: () {
        when(mockGetAllProducts()).thenAnswer((_) async => Right(tProducts));
        when(mockGetLastEntry(any)).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (c) => c.loadProducts(),
      expect: () => [
        isA<DailyEntryLoading>(),
        isA<DailyEntryLoaded>().having(
          (s) => s.products,
          'products',
          tProducts,
        ),
      ],
    );

    blocTest<DailyEntryCubit, DailyEntryState>(
      'Loaded state currentQuantities başlangıçta null olmalı',
      build: () {
        when(mockGetAllProducts()).thenAnswer((_) async => Right(tProducts));
        when(mockGetLastEntry(any)).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (c) => c.loadProducts(),
      expect: () => [
        isA<DailyEntryLoading>(),
        isA<DailyEntryLoaded>().having(
          (s) => s.currentQuantities.values.every((v) => v == null),
          'tüm quantities null',
          true,
        ),
      ],
    );

    blocTest<DailyEntryCubit, DailyEntryState>(
      'ürün yoksa Loaded products listesi boş gelmeli',
      build: () {
        when(mockGetAllProducts()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (c) => c.loadProducts(),
      expect: () => [
        isA<DailyEntryLoading>(),
        isA<DailyEntryLoaded>().having(
          (s) => s.products,
          'products boş',
          isEmpty,
        ),
      ],
    );

    blocTest<DailyEntryCubit, DailyEntryState>(
      'usecase hata dönünce Error emit etmeli',
      build: () {
        when(mockGetAllProducts())
            .thenAnswer((_) async => Left(CacheFailure('Hata')));
        return cubit;
      },
      act: (c) => c.loadProducts(),
      expect: () => [
        isA<DailyEntryLoading>(),
        isA<DailyEntryError>().having(
          (s) => s.message,
          'message',
          'Hata',
        ),
      ],
    );
  });
}
