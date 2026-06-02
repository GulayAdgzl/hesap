// test/features/product/presentation/pages/products_page_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';
import 'package:hesap/feature/sub_feature/product/pages/products_page.dart';
import 'package:hesap/feature/sub_feature/product/presentation/bloc/product_cubit.dart';
import 'package:hesap/feature/sub_feature/product/presentation/bloc/product_state.dart';
import 'package:mocktail/mocktail.dart';

class MockProductCubit extends MockCubit<ProductState>
    implements ProductCubit {}

class FakeProduct extends Fake implements Product {}

Product fakeProduct({
  String id = 'test-id',
  String name = 'Test Ürün',
  String unit = 'kg',
  double price = 10.0,
  int quantity = 100,
  double criticalThreshold = 15.0,
}) =>
    Product(
      id: id,
      name: name,
      unit: unit,
      price: price,
      quantity: quantity,
      description: '',
      imageUrl: '',
      categoryId: '',
      createdAt: DateTime(2024),
      criticalThreshold: criticalThreshold,
      maxStock: 500,
    );

void main() {
  late MockProductCubit mockCubit;

  setUpAll(() {
    registerFallbackValue(FakeProduct());
  });

  setUp(() {
    mockCubit = MockProductCubit();
    when(() => mockCubit.loadProducts()).thenAnswer((_) async {});
  });

  Widget buildPage() => MaterialApp(
        home: BlocProvider<ProductCubit>.value(
          value: mockCubit,
          child: const ProductsPage(),
        ),
      );

  // ─────────────────────────────────────────
  // Render testleri
  // ─────────────────────────────────────────
  group('render', () {
    testWidgets('sayfa başlığı görünür', (tester) async {
      when(() => mockCubit.state).thenReturn(ProductStateInitial());
      await tester.pumpWidget(buildPage());
      expect(find.text(AppStrings.productsTitle), findsOneWidget);
    });

    testWidgets('arama kutusu görünür', (tester) async {
      when(() => mockCubit.state).thenReturn(ProductStateInitial());
      await tester.pumpWidget(buildPage());
      expect(find.text(AppStrings.searchHint), findsOneWidget);
    });

    testWidgets('filtre chipler görünür', (tester) async {
      when(() => mockCubit.state).thenReturn(ProductStateInitial());
      await tester.pumpWidget(buildPage());
      expect(find.text(AppStrings.filterAll), findsOneWidget);
      expect(find.text(AppStrings.filterCritical), findsOneWidget);
      expect(find.text(AppStrings.filterNormal), findsOneWidget);
      expect(find.text(AppStrings.filterMostConsumed), findsOneWidget);
    });

    testWidgets('FAB görünür', (tester) async {
      when(() => mockCubit.state).thenReturn(ProductStateInitial());
      await tester.pumpWidget(buildPage());
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────
  // State testleri
  // ─────────────────────────────────────────
  group('state', () {
    testWidgets('Loading → spinner görünür', (tester) async {
      when(() => mockCubit.state).thenReturn(ProductStateLoading());
      await tester.pumpWidget(buildPage());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Error → hata mesajı görünür', (tester) async {
      when(() => mockCubit.state)
          .thenReturn(ProductStateError('Bir hata oluştu'));
      await tester.pumpWidget(buildPage());
      expect(find.text('Bir hata oluştu'), findsOneWidget);
    });

    testWidgets('Loaded boş liste → boş state mesajları görünür',
        (tester) async {
      when(() => mockCubit.state).thenReturn(ProductStateLoaded([]));
      await tester.pumpWidget(buildPage());
      expect(find.text(AppStrings.noProducts), findsOneWidget);
      expect(find.text(AppStrings.noProductsHint), findsOneWidget);
    });

    testWidgets('Loaded ürünler var → ürün adları görünür', (tester) async {
      when(() => mockCubit.state).thenReturn(ProductStateLoaded([
        fakeProduct(id: '1', name: 'Un'),
        fakeProduct(id: '2', name: 'Şeker'),
      ]));
      await tester.pumpWidget(buildPage());
      await tester.pump();
      expect(find.text('Un'), findsOneWidget);
      expect(find.text('Şeker'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────
  // Arama testleri
  // ─────────────────────────────────────────
  group('arama', () {
    testWidgets('arama yapınca eşleşmeyen ürün kaybolur', (tester) async {
      when(() => mockCubit.state).thenReturn(ProductStateLoaded([
        fakeProduct(id: '1', name: 'Un'),
        fakeProduct(id: '2', name: 'Şeker'),
      ]));
      await tester.pumpWidget(buildPage());
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'Un');
      await tester.pump();

      // TextField içindeki değil, ürün adı Text widget'ını bul
      expect(
        find.descendant(
          of: find.byType(ListView),
          matching: find.text('Un'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(ListView),
          matching: find.text('Şeker'),
        ),
        findsNothing,
      );
    });

    testWidgets('eşleşme yoksa noFilterResult gösterir', (tester) async {
      when(() => mockCubit.state).thenReturn(ProductStateLoaded([
        fakeProduct(id: '1', name: 'Un'),
      ]));
      await tester.pumpWidget(buildPage());
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.pump();

      expect(find.textContaining(AppStrings.noFilterResult), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────
  // Filtre testleri
  // ─────────────────────────────────────────
  group('filtre', () {
    testWidgets('Kritik filtresi → sadece kritik ürün görünür', (tester) async {
      when(() => mockCubit.state).thenReturn(ProductStateLoaded([
        fakeProduct(id: '1', name: 'Kritik Ürün', quantity: 5),
        fakeProduct(id: '2', name: 'Normal Ürün', quantity: 450),
      ]));
      await tester.pumpWidget(buildPage());
      await tester.pump();

      await tester.tap(find.text(AppStrings.filterCritical));
      await tester.pump();

      expect(find.text('Kritik Ürün'), findsOneWidget);
      expect(find.text('Normal Ürün'), findsNothing);
    });

    testWidgets('Normal filtresi → sadece normal ürün görünür', (tester) async {
      when(() => mockCubit.state).thenReturn(ProductStateLoaded([
        fakeProduct(id: '1', name: 'Kritik Ürün', quantity: 5),
        fakeProduct(id: '2', name: 'Normal Ürün', quantity: 450),
      ]));
      await tester.pumpWidget(buildPage());
      await tester.pump();

      await tester.tap(find.text(AppStrings.filterNormal).first);
      await tester.pump();
      ;

      expect(find.text('Normal Ürün'), findsOneWidget);
      expect(find.text('Kritik Ürün'), findsNothing);
    });
  });

  // ─────────────────────────────────────────
  // Silme dialog testleri
  // ─────────────────────────────────────────
  group('silme', () {
    testWidgets('sil ikonuna basınca dialog açılır', (tester) async {
      when(() => mockCubit.state).thenReturn(ProductStateLoaded([
        fakeProduct(id: '1', name: 'Un'),
      ]));
      await tester.pumpWidget(buildPage());
      await tester.pump();

      // 🗑️ emoji butonu
      await tester.tap(find.text('🗑️'));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.deleteProduct), findsOneWidget);
      expect(find.text(AppStrings.deleteYes), findsOneWidget);
      expect(find.text(AppStrings.cancel), findsOneWidget);
    });

    testWidgets('iptal → deleteProduct çağrılmaz', (tester) async {
      when(() => mockCubit.state).thenReturn(ProductStateLoaded([
        fakeProduct(id: '1', name: 'Un'),
      ]));
      await tester.pumpWidget(buildPage());
      await tester.pump();

      await tester.tap(find.text('🗑️'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.cancel));
      await tester.pumpAndSettle();

      verifyNever(() => mockCubit.deleteProduct(any()));
    });

    testWidgets('onayla → deleteProduct çağrılır', (tester) async {
      when(() => mockCubit.state).thenReturn(ProductStateLoaded([
        fakeProduct(id: '1', name: 'Un'),
      ]));
      when(() => mockCubit.deleteProduct('1')).thenAnswer((_) async {});

      await tester.pumpWidget(buildPage());
      await tester.pump();

      await tester.tap(find.text('🗑️'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.deleteYes));
      await tester.pumpAndSettle();

      verify(() => mockCubit.deleteProduct('1')).called(1);
    });
  });

  // ─────────────────────────────────────────
  // FAB testleri
  // ─────────────────────────────────────────
  group('FAB', () {
    testWidgets('FAB\'a basınca AddProductSheet açılır', (tester) async {
      when(() => mockCubit.state).thenReturn(ProductStateLoaded([]));
      await tester.pumpWidget(buildPage());
      await tester.pump();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.addProduct), findsOneWidget);
    });
  });
}
