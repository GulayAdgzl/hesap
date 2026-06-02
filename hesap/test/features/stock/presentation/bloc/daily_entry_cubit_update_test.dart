import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/feature/stock/domain/usecases/get_last_entry_usecase.dart';
import 'package:hesap/feature/stock/domain/usecases/save_daily_entries_usecase.dart';
import 'package:hesap/feature/stock/presentation/bloc/daily_entry_cubit.dart';
import 'package:hesap/feature/stock/presentation/bloc/daily_entry_state.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';
import 'package:hesap/feature/sub_feature/product/usecases/get_all_products_usecase.dart';
import 'package:mockito/annotations.dart';

import '../../../product/presentation/bloc/product_cubit_test.dart';
import 'daily_entry_cubit_update_test.mocks.dart'
    hide MockGetAllProductsUseCase;

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

  group('updateQuantity', () {
    blocTest<DailyEntryCubit, DailyEntryState>(
      'değer güncellenince currentQuantities map değişmeli',
      build: () => cubit,
      seed: () => DailyEntryLoaded(
        products: tProducts,
        currentQuantities: {'p1': null, 'p2': null},
        lastEntries: {'p1': null, 'p2': null},
      ),
      act: (c) => c.updateQuantity('p1', 42),
      expect: () => [
        isA<DailyEntryLoaded>().having(
          (s) => s.currentQuantities['p1'],
          'p1 quantity 42 olmalı',
          42,
        ),
      ],
    );

    blocTest<DailyEntryCubit, DailyEntryState>(
      'güncelleme diğer ürünlerin değerini bozmamalı',
      build: () => cubit,
      seed: () => DailyEntryLoaded(
        products: tProducts,
        currentQuantities: {'p1': null, 'p2': 77},
        lastEntries: {'p1': null, 'p2': null},
      ),
      act: (c) => c.updateQuantity('p1', 42),
      expect: () => [
        isA<DailyEntryLoaded>().having(
          (s) => s.currentQuantities['p2'],
          'p2 quantity değişmemeli',
          77,
        ),
      ],
    );

    blocTest<DailyEntryCubit, DailyEntryState>(
      'state DailyEntryLoaded değilken hiçbir şey emit etmemeli',
      build: () => cubit,
      seed: () => DailyEntryInitial(),
      act: (c) => c.updateQuantity('p1', 42),
      expect: () => [],
    );
  });
}
