import 'package:hesap/feature/stock/domain/entities/daily_stock_entry.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';

/// DailyEntry sayfasının tüm UI durumunu taşıyan immutable state.
///
/// [savedSuccessfully] → tek seferlik "kayıt başarılı" sinyali;
/// gösterildikten hemen sonra [copyWith(clearSaved: true)] ile temizlenir.
final class DailyEntryUiState {
  final bool isLoading;
  final bool isSaving;
  final List<Product> products;
  final Map<String, int?> currentQuantities;
  final Map<String, DailyStockEntry?> lastEntries;
  final String? error;
  final bool savedSuccessfully;

  const DailyEntryUiState({
    this.isLoading = false,
    this.isSaving = false,
    this.products = const [],
    this.currentQuantities = const {},
    this.lastEntries = const {},
    this.error,
    this.savedSuccessfully = false,
  });

  const DailyEntryUiState.initial()
      : isLoading = false,
        isSaving = false,
        products = const [],
        currentQuantities = const {},
        lastEntries = const {},
        error = null,
        savedSuccessfully = false;

  bool get hasError => error != null;
  bool get hasProducts => products.isNotEmpty;

  DailyEntryUiState copyWith({
    bool? isLoading,
    bool? isSaving,
    List<Product>? products,
    Map<String, int?>? currentQuantities,
    Map<String, DailyStockEntry?>? lastEntries,
    String? error,
    bool? savedSuccessfully,
    bool clearError = false,
    bool clearSaved = false,
  }) {
    return DailyEntryUiState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      products: products ?? this.products,
      currentQuantities: currentQuantities ?? this.currentQuantities,
      lastEntries: lastEntries ?? this.lastEntries,
      error: clearError ? null : (error ?? this.error),
      savedSuccessfully:
          clearSaved ? false : (savedSuccessfully ?? this.savedSuccessfully),
    );
  }
}
