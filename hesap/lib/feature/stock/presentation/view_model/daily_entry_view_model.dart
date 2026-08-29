import 'package:flutter/foundation.dart';
import 'package:hesap/core/constants/app_string.dart';
import 'package:hesap/feature/stock/domain/entities/daily_stock_entry.dart';
import 'package:hesap/feature/stock/domain/usecases/get_last_entry_usecase.dart';
import 'package:hesap/feature/stock/domain/usecases/save_daily_entries_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/get_all_products_usecase.dart';
import 'package:uuid/uuid.dart';

import 'daily_entry_ui_state.dart';

final class DailyEntryViewModel {
  final GetAllProductsUseCase _getAllProducts;
  final SaveDailyEntriesUseCase _saveDailyEntries;
  final GetLastEntryForProductUseCase _getLastEntry;

  final ValueNotifier<DailyEntryUiState> state =
      ValueNotifier(const DailyEntryUiState.initial());

  DailyEntryViewModel({
    required GetAllProductsUseCase getAllProducts,
    required SaveDailyEntriesUseCase saveDailyEntries,
    required GetLastEntryForProductUseCase getLastEntry,
  })  : _getAllProducts = getAllProducts,
        _saveDailyEntries = saveDailyEntries,
        _getLastEntry = getLastEntry;

  // ── Yükleme ───────────────────────────────────────────────────────────────

  Future<void> loadProducts() async {
    state.value = state.value.copyWith(isLoading: true, clearError: true);

    final result = await _getAllProducts();
    await result.fold(
      (failure) async => state.value = state.value.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (products) async {
        final quantities = <String, int?>{};
        final lastEntries = <String, DailyStockEntry?>{};

        final results = await Future.wait(
          products.map((p) => _getLastEntry(p.id)),
        );

        for (var i = 0; i < products.length; i++) {
          final p = products[i];
          results[i].fold(
            (_) => lastEntries[p.id] = null,
            (entry) => lastEntries[p.id] = entry,
          );
          quantities[p.id] = null;
        }
        state.value = state.value.copyWith(
          isLoading: false,
          products: products,
          currentQuantities: quantities,
          lastEntries: lastEntries,
        );
      },
    );
  }

  // ── Miktar güncelleme ─────────────────────────────────────────────────────

  void updateQuantity(String productId, int? value) {
    final updated = Map<String, int?>.from(state.value.currentQuantities);
    updated[productId] = value;
    state.value = state.value.copyWith(currentQuantities: updated);
  }

  // ── Toplu kaydetme ────────────────────────────────────────────────────────

  Future<void> saveAll() async {
    final current = state.value;
    if (current.isLoading || current.isSaving) return;

    final entries = <DailyStockEntry>[];
    final now = DateTime.now();

    for (final product in current.products) {
      final qty = current.currentQuantities[product.id];
      if (qty == null) continue;

      final last = current.lastEntries[product.id];
      final previous = last?.currentQuantity ?? product.quantity;

      entries.add(DailyStockEntry(
        id: const Uuid().v4(),
        productId: product.id,
        productName: product.name,
        productUnit: product.unit,
        previousQuantity: previous,
        currentQuantity: qty,
        unitPrice: product.price,
        date: now,
      ));
    }
    if (entries.isEmpty) {
      state.value = state.value.copyWith(
        error: AppStrings.dailyEntryNoValue,
      );
      return;
    }
    state.value = state.value.copyWith(isSaving: true);
    final result = await _saveDailyEntries(entries);
    result.fold(
      (failure) => state.value = state.value.copyWith(
        isSaving: false,
        error: failure.message,
      ),
      (_) => state.value = state.value.copyWith(
        isSaving: false,
        savedSuccessfully: true,
      ),
    );
  }

  void dispose() => state.dispose();
}
