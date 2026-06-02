import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesap/core/constants/app_colors.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/feature/stock/domain/entities/daily_stock_entry.dart';
import 'package:hesap/feature/stock/presentation/bloc/daily_entry_cubit.dart';
import 'package:hesap/feature/stock/presentation/bloc/daily_entry_state.dart';
import 'package:hesap/feature/stock/presentation/pages/daily_entry_page.dart';
import 'package:hesap/feature/stock/presentation/widgets/daily_entry_consumption_row.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';
import 'package:mocktail/mocktail.dart';

// ---------------------------------------------------------------------------
// Mock
// ---------------------------------------------------------------------------

class MockDailyEntryCubit extends MockCubit<DailyEntryState>
    implements DailyEntryCubit {}

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

Product _product({
  String id = 'p1',
  String name = 'Domates',
  String unit = 'kg',
  int quantity = 50,
  int maxStock = 100,
  double criticalThreshold = 15.0,
  double price = 5.0,
}) =>
    Product(
      id: id,
      name: name,
      unit: unit,
      quantity: quantity,
      maxStock: maxStock,
      criticalThreshold: criticalThreshold,
      price: price,
      description: 'Test urunu',
      imageUrl: '',
      categoryId: 'cat1',
      createdAt: DateTime(2024, 1, 1),
    );

// quantity=10, maxStock=100 → %10 < criticalThreshold=%15 → kritik
Product _criticalProduct() => _product(
      id: 'p2',
      name: 'Sogan',
      quantity: 10,
      maxStock: 100,
      criticalThreshold: 15.0,
    );

DailyStockEntry _entry({
  String productId = 'p1',
  int previousQuantity = 50,
  int currentQuantity = 50,
  double unitPrice = 5.0,
}) =>
    DailyStockEntry(
      id: 'e_$productId',
      productId: productId,
      productName: 'Test Urun',
      productUnit: 'kg',
      previousQuantity: previousQuantity,
      currentQuantity: currentQuantity,
      unitPrice: unitPrice,
      date: DateTime.now().subtract(const Duration(days: 1)),
    );

DailyEntryLoaded _loaded({
  List<Product>? products,
  Map<String, DailyStockEntry?>? lastEntries,
}) =>
    DailyEntryLoaded(
      products: products ?? [],
      currentQuantities: {},
      lastEntries: lastEntries ?? {},
    );

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

Widget _page(MockDailyEntryCubit cubit) => BlocProvider<DailyEntryCubit>(
      create: (_) => cubit,
      child: const MaterialApp(home: DailyEntryPage()),
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockDailyEntryCubit cubit;

  setUp(() {
    cubit = MockDailyEntryCubit();
    when(() => cubit.loadProducts()).thenAnswer((_) async {});
  });

  // 1. Loading
  testWidgets('Sayfa acilinca loading gosteriyor mu?', (tester) async {
    when(() => cubit.state).thenReturn(DailyEntryLoading());

    await tester.pumpWidget(_page(cubit));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  // 2. Bos state
  testWidgets('Urun yokken bos state mesaji cikiyor mu?', (tester) async {
    when(() => cubit.state).thenReturn(_loaded());

    await tester.pumpWidget(_page(cubit));
    await tester.pump();

    expect(find.text(AppStrings.noProductsDaily), findsOneWidget);
    expect(find.text(AppStrings.noProductsDailyHint), findsOneWidget);
  });

  // 3. Urun adi & birimi
  testWidgets('Urun kartlari dogru urun adi ve birimi gosteriyor mu?',
      (tester) async {
    when(() => cubit.state).thenReturn(
      _loaded(products: [_product(name: 'Domates', unit: 'kg')]),
    );

    await tester.pumpWidget(_page(cubit));
    await tester.pump();

    expect(find.text('Domates'), findsOneWidget);
    expect(find.text('kg'), findsOneWidget);
  });

  // 4. Kritik kart
  testWidgets('Kritik stoktaki urun kritik badge gosteriyor mu?',
      (tester) async {
    when(() => cubit.state).thenReturn(
      _loaded(products: [_criticalProduct()]),
    );

    await tester.pumpWidget(_page(cubit));
    await tester.pump();

    expect(find.text(AppStrings.criticalLabel), findsOneWidget);

    final dangerIcons = tester
        .widgetList<Icon>(find.byType(Icon))
        .where((i) => i.color == AppColors.danger)
        .toList();
    expect(dangerIcons, isNotEmpty);
  });

  // 5. Tuketim satiri gorunurlugu
  testWidgets('Inputa deger girilince tuketim satiri gorunuyor mu?',
      (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (_, setState) => Column(
              children: [
                TextField(
                  controller: controller,
                  onChanged: (_) => setState(() {}),
                ),
                DailyEntryConsumptionRow(
                  controller: controller,
                  previousQty: 50,
                  unit: 'kg',
                  price: 5.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text(AppStrings.consumptionLabel), findsNothing);
    expect(find.text(AppStrings.addedLabel), findsNothing);

    await tester.enterText(find.byType(TextField), '40');
    await tester.pump();

    expect(find.text(AppStrings.consumptionLabel), findsOneWidget);
  });

  // 6. Tuketim hesabi
  testWidgets('Tuketim satirinda dogru hesaplama gosteriyor mu?',
      (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (_, setState) => Column(
              children: [
                TextField(
                  controller: controller,
                  onChanged: (_) => setState(() {}),
                ),
                DailyEntryConsumptionRow(
                  controller: controller,
                  previousQty: 50,
                  unit: 'kg',
                  price: 5.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '30');
    await tester.pump();

    // previousQty=50, girilen=30 → diff=20, maliyet=20x5=100.00
    expect(find.textContaining('20'), findsWidgets);
    expect(find.textContaining('100.00'), findsOneWidget);
  });

  // 7. saveAll
  testWidgets('Tum Girisleri Kaydet butonu saveAll cagriliyor mu?',
      (tester) async {
    when(() => cubit.state).thenReturn(_loaded(products: [_product()]));
    when(() => cubit.saveAll()).thenAnswer((_) async {});

    await tester.pumpWidget(_page(cubit));
    await tester.pump();

    await tester.tap(find.text(AppStrings.dailyEntrySaveAll));
    await tester.pump();

    verify(() => cubit.saveAll()).called(1);
  });

  // 8. Basari snackbar
  testWidgets('Kayit basariliysa yesil snackbar cikiyor mu?', (tester) async {
    final product = _product();

    whenListen(
      cubit,
      Stream.fromIterable([
        _loaded(products: [product]),
        DailyEntrySaved(),
        _loaded(products: [product]),
      ]),
      initialState: _loaded(products: [product]),
    );

    await tester.pumpWidget(_page(cubit));
    await tester.pump();
    await tester.pump();

    expect(find.text(AppStrings.dailyEntrySaved), findsOneWidget);

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.backgroundColor, equals(AppColors.success));
  });

  // 9. Hata snackbar
  testWidgets('Hata durumunda kirmizi snackbar cikiyor mu?', (tester) async {
    final product = _product();
    const errorMessage = 'Kayit sirasinda bir hata olustu';

    whenListen(
      cubit,
      Stream.fromIterable([
        _loaded(products: [product]),
        DailyEntryError(errorMessage),
      ]),
      initialState: _loaded(products: [product]),
    );

    await tester.pumpWidget(_page(cubit));
    await tester.pump();
    await tester.pump();

    // Hata metni snackbar'da (BlocBuilder da gosterebilir — findsWidgets)
    expect(find.text(errorMessage), findsWidgets);

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.backgroundColor, equals(AppColors.danger));
  });
}
