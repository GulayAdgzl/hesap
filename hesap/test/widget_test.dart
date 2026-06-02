import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/errror/failure.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';
import 'package:hesap/feature/sub_feature/product/presentation/bloc/product_cubit.dart';
import 'package:hesap/feature/sub_feature/product/presentation/bloc/product_state.dart';
import 'package:hesap/feature/sub_feature/product/usecases/add_product_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/delete_product_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/get_all_products_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/update_product_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllProductsUseCase extends Mock implements GetAllProductsUseCase {}

class MockAddProductUseCase extends Mock implements AddProductUseCase {}

class MockUpdateProductUseCase extends Mock implements UpdateProductUseCase {}

class MockDeleteProductUseCase extends Mock implements DeleteProductUseCase {}

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
  late MockGetAllProductsUseCase mockGetAll;
  late MockAddProductUseCase mockAdd;
  late MockUpdateProductUseCase mockUpdate;
  late MockDeleteProductUseCase mockDelete;
  late ProductCubit cubit;

  setUp(() {
    mockGetAll = MockGetAllProductsUseCase();
    mockAdd = MockAddProductUseCase();
    mockUpdate = MockUpdateProductUseCase();
    mockDelete = MockDeleteProductUseCase();

    cubit = ProductCubit(
      getAllProductsUseCase: mockGetAll,
      addProductUseCase: mockAdd,
      updateProductUseCase: mockUpdate,
      deleteProductUseCase: mockDelete,
    );
  });

  tearDown(() => cubit.close());

  group('loadProducts', () {
    blocTest<ProductCubit, ProductState>(
      'başarılı → Loading sonra Loaded',
      build: () {
        when(() => mockGetAll())
            .thenAnswer((_) async => Right([fakeProduct()]));
        return cubit;
      },
      act: (c) => c.loadProducts(),
      expect: () => [
        isA<ProductStateLoading>(),
        isA<ProductStateLoaded>()
            .having((s) => s.products.length, 'ürün sayısı', 1),
      ],
    );

    blocTest<ProductCubit, ProductState>(
      'hata → Loading sonra Error',
      build: () {
        when(() => mockGetAll())
            .thenAnswer((_) async => Left(ServerFailure('Yükleme hatası')));
        return cubit;
      },
      act: (c) => c.loadProducts(),
      expect: () => [
        isA<ProductStateLoading>(),
        isA<ProductStateError>()
            .having((s) => s.message, 'hata mesajı', 'Yükleme hatası'),
      ],
    );
  });

  group('addProduct', () {
    blocTest<ProductCubit, ProductState>(
      'başarılı → loadProducts tetiklenir, Loaded döner',
      build: () {
        when(() => mockAdd(any())).thenAnswer((_) async => const Right(unit));
        when(() => mockGetAll())
            .thenAnswer((_) async => Right([fakeProduct(name: 'Un')]));
        return cubit;
      },
      act: (c) => c.addProduct(
        name: 'Un',
        unit: 'kg',
        price: 5.0,
        quantity: 200,
        description: '',
        imageUrl: '',
        categoryId: '',
      ),
      expect: () => [
        isA<ProductStateLoading>(),
        isA<ProductStateLoaded>()
            .having((s) => s.products.first.name, 'ürün adı', 'Un'),
      ],
    );

    blocTest<ProductCubit, ProductState>(
      'hata → Error state',
      build: () {
        when(() => mockAdd(any()))
            .thenAnswer((_) async => Left(ServerFailure('Ekleme hatası')));
        return cubit;
      },
      act: (c) => c.addProduct(
        name: 'Un',
        unit: 'kg',
        price: 5.0,
        quantity: 200,
        description: '',
        imageUrl: '',
        categoryId: '',
      ),
      expect: () => [
        isA<ProductStateError>()
            .having((s) => s.message, 'hata mesajı', 'Ekleme hatası'),
      ],
    );
  });

  group('deleteProduct', () {
    blocTest<ProductCubit, ProductState>(
      'başarılı → silinmiş ürün listede yok',
      build: () {
        when(() => mockDelete('1')).thenAnswer((_) async => const Right(unit));
        when(() => mockGetAll())
            .thenAnswer((_) async => Right([fakeProduct(id: '2')]));
        return cubit;
      },
      act: (c) => c.deleteProduct('1'),
      expect: () => [
        isA<ProductStateLoading>(),
        isA<ProductStateLoaded>().having(
            (s) => s.products.any((p) => p is Product ? p.id == '1' : false),
            'id=1 yok',
            false),
      ],
    );

    blocTest<ProductCubit, ProductState>(
      'hata → Error state',
      build: () {
        when(() => mockDelete('1'))
            .thenAnswer((_) async => Left(ServerFailure('Silme hatası')));
        return cubit;
      },
      act: (c) => c.deleteProduct('1'),
      expect: () => [
        isA<ProductStateError>()
            .having((s) => s.message, 'hata mesajı', 'Silme hatası'),
      ],
    );
  });

  group('updateProduct', () {
    blocTest<ProductCubit, ProductState>(
      'başarılı → güncellenmiş ürün Loaded state içinde',
      build: () {
        final updated = fakeProduct(name: 'Güncellendi');
        when(() => mockUpdate(updated))
            .thenAnswer((_) async => const Right(unit));
        when(() => mockGetAll()).thenAnswer((_) async => Right([updated]));
        return cubit;
      },
      act: (c) => c.updateProduct(product: fakeProduct(name: 'Güncellendi')),
      expect: () => [
        isA<ProductStateLoading>(),
        isA<ProductStateLoaded>()
            .having((s) => s.products.first.name, 'yeni ad', 'Güncellendi'),
      ],
    );

    blocTest<ProductCubit, ProductState>(
      'hata → Error state',
      build: () {
        when(() => mockUpdate(any()))
            .thenAnswer((_) async => Left(ServerFailure('Güncelleme hatası')));
        return cubit;
      },
      act: (c) => c.updateProduct(product: fakeProduct()),
      expect: () => [
        isA<ProductStateError>()
            .having((s) => s.message, 'hata mesajı', 'Güncelleme hatası'),
      ],
    );
  });
}
