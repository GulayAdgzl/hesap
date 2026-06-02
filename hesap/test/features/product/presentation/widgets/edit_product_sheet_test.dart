// test/features/product/presentation/widgets/edit_product_sheet_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';
import 'package:hesap/feature/sub_feature/product/pages/edit_product_sheet.dart';
import 'package:hesap/feature/sub_feature/product/presentation/bloc/product_cubit.dart';
import 'package:hesap/feature/sub_feature/product/presentation/bloc/product_state.dart';
import 'package:mocktail/mocktail.dart';

// --- Mock & Fake ---
class MockProductCubit extends MockCubit<ProductState>
    implements ProductCubit {}

class FakeProduct extends Fake implements Product {}

// --- Test verisi ---
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
    when(() => mockCubit.state).thenReturn(ProductStateInitial());
  });

  Widget buildSheet({Product? product}) => MaterialApp(
        home: BlocProvider<ProductCubit>.value(
          value: mockCubit,
          child: Scaffold(
            body: EditProductSheet(product: product ?? fakeProduct()),
          ),
        ),
      );

  // ─────────────────────────────────────────
  // Render testleri
  // ─────────────────────────────────────────
  group('render', () {
    testWidgets('başlık görünür', (tester) async {
      await tester.pumpWidget(buildSheet());
      expect(find.text(AppStrings.editProduct), findsOneWidget);
    });

    testWidgets('kaydet butonu görünür', (tester) async {
      await tester.pumpWidget(buildSheet());
      expect(find.text(AppStrings.saveChanges), findsOneWidget);
    });

    testWidgets('mevcut ürün adı form alanında dolu gelir', (tester) async {
      await tester.pumpWidget(buildSheet(product: fakeProduct(name: 'Un')));
      expect(find.widgetWithText(TextFormField, 'Un'), findsOneWidget);
    });

    testWidgets('mevcut fiyat form alanında dolu gelir', (tester) async {
      await tester.pumpWidget(buildSheet(product: fakeProduct(price: 25.0)));
      expect(find.widgetWithText(TextFormField, '25.0'), findsOneWidget);
    });

    testWidgets('mevcut miktar form alanında dolu gelir', (tester) async {
      await tester.pumpWidget(buildSheet(product: fakeProduct(quantity: 200)));
      expect(find.widgetWithText(TextFormField, '200'), findsOneWidget);
    });

    testWidgets('birim chip\'leri görünür', (tester) async {
      await tester.pumpWidget(buildSheet());
      for (final unit in AppStrings.units) {
        expect(find.text(unit), findsOneWidget);
      }
    });

    testWidgets('slider görünür', (tester) async {
      await tester.pumpWidget(buildSheet());
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('kritik eşik yüzdesi gösterilir', (tester) async {
      await tester.pumpWidget(
        buildSheet(product: fakeProduct(criticalThreshold: 20.0)),
      );
      expect(find.text('%20'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────
  // Validasyon testleri
  // ─────────────────────────────────────────
  group('validasyon', () {
    testWidgets('ürün adı silinip boş submit → hata mesajı gösterir',
        (tester) async {
      await tester.pumpWidget(buildSheet());

      // Mevcut adı temizle
      await tester.enterText(find.byType(TextFormField).first, '');
      await tester.tap(find.text(AppStrings.saveChanges));
      await tester.pump();

      expect(find.text(AppStrings.productNameRequired), findsOneWidget);
    });

    testWidgets('boş ad → updateProduct çağrılmaz', (tester) async {
      await tester.pumpWidget(buildSheet());

      await tester.enterText(find.byType(TextFormField).first, '');
      await tester.tap(find.text(AppStrings.saveChanges));
      await tester.pump();

      verifyNever(() => mockCubit.updateProduct(
            product: any(named: 'product'),
          ));
    });
  });

  // ─────────────────────────────────────────
  // Submit testleri
  // ─────────────────────────────────────────
  group('submit', () {
    testWidgets('form geçerliyse updateProduct çağrılır', (tester) async {
      when(() => mockCubit.updateProduct(product: any(named: 'product')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(buildSheet(product: fakeProduct(name: 'Un')));
      await tester.tap(find.text(AppStrings.saveChanges));
      await tester.pump();

      verify(() => mockCubit.updateProduct(
            product: any(named: 'product'),
          )).called(1);
    });

    testWidgets('ad değiştirilip kaydedilince yeni adla updateProduct çağrılır',
        (tester) async {
      Product? capturedProduct;
      when(() => mockCubit.updateProduct(product: any(named: 'product')))
          .thenAnswer((invocation) async {
        capturedProduct =
            invocation.namedArguments[const Symbol('product')] as Product;
      });

      await tester.pumpWidget(buildSheet(product: fakeProduct(name: 'Un')));
      await tester.enterText(find.byType(TextFormField).first, 'Şeker');
      await tester.tap(find.text(AppStrings.saveChanges));
      await tester.pump();

      expect(capturedProduct?.name, 'Şeker');
    });
  });

  // ─────────────────────────────────────────
  // Birim seçimi testleri
  // ─────────────────────────────────────────
  group('birim seçimi', () {
    testWidgets('ürünün birimi varsayılan seçili gelir', (tester) async {
      await tester.pumpWidget(
        buildSheet(product: fakeProduct(unit: 'litre')),
      );
      expect(find.text('litre'), findsOneWidget);
    });

    testWidgets('farklı birim seçince güncellenir', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.tap(find.text('adet'));
      await tester.pump();
      expect(find.text('adet'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────
  // Navigasyon testleri
  // ─────────────────────────────────────────
  group('navigasyon', () {
    testWidgets('kapat butonuna basınca sheet kapanır', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (_) => BlocProvider<ProductCubit>.value(
                    value: mockCubit,
                    child: EditProductSheet(product: fakeProduct()),
                  ),
                ),
                child: const Text('Aç'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Aç'));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.editProduct), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.editProduct), findsNothing);
    });
  });
}
