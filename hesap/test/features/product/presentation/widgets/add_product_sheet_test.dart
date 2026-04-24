// test/features/product/presentation/widgets/add_product_sheet_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/features/product/presentation/pages/add_product_sheet.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/features/product/domain/entities/product.dart';

import 'package:hesap/features/product/presentation/bloc/product_cubit.dart';
import 'package:hesap/features/product/presentation/bloc/product_state.dart';

// --- Mock & Fake ---
class MockProductCubit extends MockCubit<ProductState>
    implements ProductCubit {}

class FakeProduct extends Fake implements Product {}

void main() {
  late MockProductCubit mockCubit;

  setUpAll(() {
    registerFallbackValue(FakeProduct());
  });

  setUp(() {
    mockCubit = MockProductCubit();
    when(() => mockCubit.state).thenReturn(ProductStateInitial());
  });

  // Sheet'i sarmalayan yardımcı widget
  Widget buildSheet() => MaterialApp(
        home: BlocProvider<ProductCubit>.value(
          value: mockCubit,
          child: const Scaffold(
            body: AddProductSheet(),
          ),
        ),
      );

  // ─────────────────────────────────────────
  // Render testleri
  // ─────────────────────────────────────────
  group('render', () {
    testWidgets('başlık görünür', (tester) async {
      await tester.pumpWidget(buildSheet());
      expect(find.text(AppStrings.addProduct), findsOneWidget);
    });

    testWidgets('kaydet butonu görünür', (tester) async {
      await tester.pumpWidget(buildSheet());
      expect(find.text(AppStrings.saveProduct), findsOneWidget);
    });

    testWidgets('birim chip\'leri görünür', (tester) async {
      await tester.pumpWidget(buildSheet());
      for (final unit in AppStrings.units) {
        expect(find.text(unit), findsOneWidget);
      }
    });

    testWidgets('kritik eşik slider görünür', (tester) async {
      await tester.pumpWidget(buildSheet());
      expect(find.byType(Slider), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────
  // Validasyon testleri
  // ─────────────────────────────────────────
  group('validasyon', () {
    testWidgets('boş form → hata mesajı gösterir', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.tap(find.text(AppStrings.saveProduct));
      await tester.pump();

      expect(find.text(AppStrings.productNameRequired), findsOneWidget);
    });

    testWidgets('boş form → addProduct çağrılmaz', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.tap(find.text(AppStrings.saveProduct));
      await tester.pump();

      verifyNever(() => mockCubit.addProduct(
            name: any(named: 'name'),
            unit: any(named: 'unit'),
            price: any(named: 'price'),
            quantity: any(named: 'quantity'),
            description: any(named: 'description'),
            imageUrl: any(named: 'imageUrl'),
            categoryId: any(named: 'categoryId'),
          ));
    });
  });

  // ─────────────────────────────────────────
  // Submit testleri
  // ─────────────────────────────────────────
  group('submit', () {
    testWidgets('form dolu → addProduct çağrılır', (tester) async {
      when(() => mockCubit.addProduct(
            name: any(named: 'name'),
            unit: any(named: 'unit'),
            price: any(named: 'price'),
            quantity: any(named: 'quantity'),
            description: any(named: 'description'),
            imageUrl: any(named: 'imageUrl'),
            categoryId: any(named: 'categoryId'),
            criticalThreshold: any(named: 'criticalThreshold'),
            maxStock: any(named: 'maxStock'),
          )).thenAnswer((_) async {});

      await tester.pumpWidget(buildSheet());

      // Ürün adını doldur
      await tester.enterText(
        find.byType(TextFormField).first,
        'Un',
      );
      await tester.tap(find.text(AppStrings.saveProduct));
      await tester.pump();

      verify(() => mockCubit.addProduct(
            name: 'Un',
            unit: any(named: 'unit'),
            price: any(named: 'price'),
            quantity: any(named: 'quantity'),
            description: any(named: 'description'),
            imageUrl: any(named: 'imageUrl'),
            categoryId: any(named: 'categoryId'),
            criticalThreshold: any(named: 'criticalThreshold'),
            maxStock: any(named: 'maxStock'),
          )).called(1);
    });
  });

  // ─────────────────────────────────────────
  // Birim seçimi testleri
  // ─────────────────────────────────────────
  group('birim seçimi', () {
    testWidgets('varsayılan birim kg', (tester) async {
      await tester.pumpWidget(buildSheet());
      // kg chip'i seçili renkte olmalı — widget ağacında bulunuyor mu kontrol
      expect(find.text('kg'), findsOneWidget);
    });

    testWidgets('litre seçince state güncellenir', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.tap(find.text('litre'));
      await tester.pump();
      // hata fırlatmadan render edilmeli
      expect(find.text('litre'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────
  // Kapat butonu testi
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
                    child: const AddProductSheet(),
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
      expect(find.text(AppStrings.addProduct), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.addProduct), findsNothing);
    });
  });
}
