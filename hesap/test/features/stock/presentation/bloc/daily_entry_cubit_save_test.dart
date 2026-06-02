import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/errror/failure.dart';
import 'package:hesap/feature/stock/domain/entities/daily_stock_entry.dart';
import 'package:hesap/feature/stock/domain/usecases/get_last_entry_usecase.dart';
import 'package:hesap/feature/stock/domain/usecases/save_daily_entries_usecase.dart';
import 'package:hesap/feature/stock/presentation/bloc/daily_entry_cubit.dart';
import 'package:hesap/feature/stock/presentation/bloc/daily_entry_state.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';
import 'package:hesap/feature/sub_feature/product/usecases/get_all_products_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../product/presentation/bloc/product_cubit_test.dart';
import 'daily_entry_cubit_save_test.mocks.dart' hide MockGetAllProductsUseCase;

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
      quantity: 360, // ← son kayıt yoksa bu kullanılır
      description: '',
      imageUrl: '',
      categoryId: '',
      createdAt: DateTime(2025, 1, 1),
      unit: 'kg',
      maxStock: 500,
    ),
  ];

  // currentQuantity: 999 → product.quantity (360)'dan kasıtlı farklı
  final tLastEntry = DailyStockEntry(
    id: 'entry-1',
    productId: 'p1',
    productName: 'Un',
    productUnit: 'kg',
    previousQuantity: 300,
    currentQuantity: 999,
    unitPrice: 18.0,
    date: DateTime(2025, 6, 1),
  );

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

  group('saveAll', () {
    blocTest<DailyEntryCubit, DailyEntryState>(
      'hiç değer girilmemişse DailyEntryError emit etmeli',
      build: () => cubit,
      seed: () => DailyEntryLoaded(
        products: tProducts,
        currentQuantities: {'p1': null}, // tümü null → entry oluşmaz
        lastEntries: {'p1': null},
      ),
      act: (c) => c.saveAll(),
      expect: () => [
        isA<DailyEntryError>().having(
          (s) => s.message,
          'hata mesajı',
          'Lütfen en az bir ürün için değer girin',
        ),
      ],
    );

    blocTest<DailyEntryCubit, DailyEntryState>(
      'geçerli değer girilince DailyEntrySaved emit etmeli',
      build: () {
        when(mockSaveEntries(any)).thenAnswer((_) async => const Right(unit));
        return cubit;
      },
      seed: () => DailyEntryLoaded(
        products: tProducts,
        currentQuantities: {'p1': 50},
        lastEntries: {'p1': null},
      ),
      act: (c) => c.saveAll(),
      expect: () => [isA<DailyEntrySaved>()],
    );

    blocTest<DailyEntryCubit, DailyEntryState>(
      'usecase hata dönünce DailyEntryError emit etmeli',
      build: () {
        when(mockSaveEntries(any))
            .thenAnswer((_) async => Left(CacheFailure('Kayıt hatası')));
        return cubit;
      },
      seed: () => DailyEntryLoaded(
        products: tProducts,
        currentQuantities: {'p1': 50},
        lastEntries: {'p1': null},
      ),
      act: (c) => c.saveAll(),
      expect: () => [
        isA<DailyEntryError>().having(
          (s) => s.message,
          'message',
          'Kayıt hatası',
        ),
      ],
    );

    test('previousQuantity: son kayıt varsa lastEntry.currentQuantity gelir',
        () async {
      final captured = <DailyStockEntry>[];
      when(mockSaveEntries(any)).thenAnswer((inv) async {
        captured.addAll(inv.positionalArguments[0] as List<DailyStockEntry>);
        return const Right(unit);
      });

      cubit.emit(DailyEntryLoaded(
        products: tProducts,
        currentQuantities: {'p1': 50},
        lastEntries: {'p1': tLastEntry}, // son kayıt VAR
      ));

      await cubit.saveAll();

      expect(
        captured.first.previousQuantity,
        999, // tLastEntry.currentQuantity
        reason: 'Son kayıt varsa previousQuantity = lastEntry.currentQuantity',
      );
    });

    test('previousQuantity: son kayıt yoksa product.quantity gelir', () async {
      final captured = <DailyStockEntry>[];
      when(mockSaveEntries(any)).thenAnswer((inv) async {
        captured.addAll(inv.positionalArguments[0] as List<DailyStockEntry>);
        return const Right(unit);
      });

      cubit.emit(DailyEntryLoaded(
        products: tProducts,
        currentQuantities: {'p1': 50},
        lastEntries: {'p1': null}, // son kayıt YOK
      ));

      await cubit.saveAll();

      expect(
        captured.first.previousQuantity,
        360, // tProducts[0].quantity
        reason: 'Son kayıt yoksa previousQuantity = product.quantity',
      );
    });
  });
}
