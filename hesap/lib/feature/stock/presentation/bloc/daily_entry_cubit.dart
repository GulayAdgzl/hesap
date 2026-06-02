import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hesap/feature/stock/domain/entities/daily_stock_entry.dart';
import 'package:hesap/feature/stock/domain/usecases/get_last_entry_usecase.dart';
import 'package:hesap/feature/stock/domain/usecases/save_daily_entries_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/get_all_products_usecase.dart';
import 'package:uuid/uuid.dart';

import 'daily_entry_state.dart';

class DailyEntryCubit extends Cubit<DailyEntryState> {
  final GetAllProductsUseCase getAllProductsUseCase;
  final SaveDailyEntriesUseCase saveDailyEntriesUseCase;
  final GetLastEntryForProductUseCase getLastEntryForProductUseCase;

  DailyEntryCubit({
    required this.getAllProductsUseCase,
    required this.saveDailyEntriesUseCase,
    required this.getLastEntryForProductUseCase,
  }) : super(DailyEntryInitial());

  Future<void> loadProducts() async {
    emit(DailyEntryLoading());
    final result = await getAllProductsUseCase();
    result.fold(
      (failure) => emit(DailyEntryError(failure.message)),
      (products) async {
        final quantities = <String, int?>{};
        final lastEntries = <String, DailyStockEntry?>{};
        for (final p in products) {
          final entryResult = await getLastEntryForProductUseCase(p.id);
          entryResult.fold(
            (_) => lastEntries[p.id] = null,
            (entry) => lastEntries[p.id] = entry,
          );
          quantities[p.id] = null;
        }
        emit(DailyEntryLoaded(
          products: products,
          currentQuantities: quantities,
          lastEntries: lastEntries,
        ));
      },
    );
  }

  void updateQuantity(String productId, int? value) {
    final state = this.state;
    if (state is! DailyEntryLoaded) return;
    final updated = Map<String, int?>.from(state.currentQuantities);
    updated[productId] = value;
    emit(DailyEntryLoaded(
      products: state.products,
      currentQuantities: updated,
      lastEntries: state.lastEntries,
    ));
  }

  Future<void> saveAll() async {
    final state = this.state;
    if (state is! DailyEntryLoaded) return;

    final entries = <DailyStockEntry>[];
    final now = DateTime.now();

    for (final product in state.products) {
      final current = state.currentQuantities[product.id];
      if (current == null) continue;

      final last = state.lastEntries[product.id];
      final previous = last?.currentQuantity ?? product.quantity;

      entries.add(DailyStockEntry(
        id: const Uuid().v4(),
        productId: product.id,
        productName: product.name,
        productUnit: product.unit,
        previousQuantity: previous,
        currentQuantity: current,
        unitPrice: product.price,
        date: now,
      ));
    }

    if (entries.isEmpty) {
      emit(DailyEntryError('Lütfen en az bir ürün için değer girin'));
      return;
    }

    final result = await saveDailyEntriesUseCase(entries);
    result.fold(
      (failure) => emit(DailyEntryError(failure.message)),
      (_) => emit(DailyEntrySaved()),
    );
  }
}
