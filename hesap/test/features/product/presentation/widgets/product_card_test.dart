// test/features/product/presentation/widgets/product_card_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/features/product/domain/entities/product.dart';
import 'package:hesap/features/product/presentation/widgets/product_card.dart';

Product fakeProduct({
  String id = 'test-id',
  String name = 'Test Ürün',
  String unit = 'kg',
  double price = 10.0,
  int quantity = 100,
  int maxStock = 500,
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
      maxStock: maxStock,
    );

void main() {
  Widget buildCard({
    required Product product,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: ProductCard(
            product: product,
            onEdit: onEdit ?? () {},
            onDelete: onDelete ?? () {},
          ),
        ),
      );

  // ─────────────────────────────────────────
  // Render testleri
  // ─────────────────────────────────────────
  group('render', () {
    testWidgets('ürün adı görünür', (tester) async {
      await tester.pumpWidget(buildCard(product: fakeProduct(name: 'Un')));
      expect(find.text('Un'), findsOneWidget);
    });

    testWidgets('birim ve fiyat bilgisi görünür', (tester) async {
      await tester.pumpWidget(
        buildCard(product: fakeProduct(unit: 'kg', price: 25.0)),
      );
      expect(find.textContaining('kg'), findsWidgets);
      expect(find.textContaining('25.0'), findsOneWidget);
    });

    testWidgets('kalan stok bilgisi görünür', (tester) async {
      await tester.pumpWidget(
        buildCard(product: fakeProduct(quantity: 150, unit: 'kg')),
      );
      expect(
        find.textContaining('${AppStrings.remaining}: 150 kg'),
        findsOneWidget,
      );
    });

    testWidgets('max stok bilgisi görünür', (tester) async {
      await tester.pumpWidget(
        buildCard(product: fakeProduct(maxStock: 500, unit: 'kg')),
      );
      expect(
        find.textContaining('${AppStrings.max} 500 kg'),
        findsOneWidget,
      );
    });

    testWidgets('progress bar görünür', (tester) async {
      await tester.pumpWidget(buildCard(product: fakeProduct()));
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('edit ve delete butonları görünür', (tester) async {
      await tester.pumpWidget(buildCard(product: fakeProduct()));
      expect(find.text('✏️'), findsOneWidget);
      expect(find.text('🗑️'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────
  // Stok durumu testleri
  // ─────────────────────────────────────────
  group('stok durumu', () {
    testWidgets('quantity/maxStock <= 0.1 → Kritik etiketi', (tester) async {
      await tester.pumpWidget(
        buildCard(product: fakeProduct(quantity: 5, maxStock: 500)),
      );
      expect(find.text(AppStrings.statusCritical), findsOneWidget);
    });

    testWidgets('quantity/maxStock <= 0.4 → Dikkat etiketi', (tester) async {
      await tester.pumpWidget(
        buildCard(product: fakeProduct(quantity: 150, maxStock: 500)),
      );
      expect(find.text(AppStrings.statusWarning), findsOneWidget);
    });

    testWidgets('quantity/maxStock > 0.4 → Normal etiketi', (tester) async {
      await tester.pumpWidget(
        buildCard(product: fakeProduct(quantity: 450, maxStock: 500)),
      );
      expect(find.text(AppStrings.statusNormal), findsOneWidget);
    });

    testWidgets('maxStock 0 ise hata fırlatmaz', (tester) async {
      await tester.pumpWidget(
        buildCard(product: fakeProduct(quantity: 100, maxStock: 0)),
      );
      expect(find.byType(ProductCard), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────
  // Buton testleri
  // ─────────────────────────────────────────
  group('butonlar', () {
    testWidgets('edit butonuna basınca onEdit çağrılır', (tester) async {
      bool editCalled = false;
      await tester.pumpWidget(
        buildCard(
          product: fakeProduct(),
          onEdit: () => editCalled = true,
        ),
      );
      await tester.tap(find.text('✏️'));
      await tester.pump();
      expect(editCalled, true);
    });

    testWidgets('delete butonuna basınca onDelete çağrılır', (tester) async {
      bool deleteCalled = false;
      await tester.pumpWidget(
        buildCard(
          product: fakeProduct(),
          onDelete: () => deleteCalled = true,
        ),
      );
      await tester.tap(find.text('🗑️'));
      await tester.pump();
      expect(deleteCalled, true);
    });
  });
}
