import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';

/// Products sayfasının tüm UI durumunu taşıyan immutable state.
final class ProductsUiState {
  final bool isLoading;
  final List<Product> products;
  final String? error;
  final String filter;
  final String search;

  const ProductsUiState({
    this.isLoading = false,
    this.products = const [],
    this.error,
    this.filter = '',
    this.search = '',
  });

  const ProductsUiState.initial()
      : isLoading = false,
        products = const [],
        error = null,
        filter = '',
        search = '';

  bool get hasError => error != null;
  bool get hasProducts => products.isNotEmpty;

  ProductsUiState copyWith({
    bool? isLoading,
    List<Product>? products,
    String? error,
    String? filter,
    String? search,
    bool clearError = false,
  }) {
    return ProductsUiState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error: clearError ? null : (error ?? this.error),
      filter: filter ?? this.filter,
      search: search ?? this.search,
    );
  }
}
