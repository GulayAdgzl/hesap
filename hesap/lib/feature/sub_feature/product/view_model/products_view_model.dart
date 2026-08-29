import 'package:flutter/foundation.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';
import 'package:hesap/feature/sub_feature/product/usecases/add_product_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/delete_product_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/get_all_products_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/update_product_usecase.dart';
import 'package:uuid/uuid.dart';

import 'products_ui_state.dart';

final class ProductsViewModel {
  final GetAllProductsUseCase _getAllProducts;
  final AddProductUseCase _addProduct;
  final UpdateProductUseCase _updateProduct;
  final DeleteProductUseCase _deleteProduct;

  final ValueNotifier<ProductsUiState> state =
      ValueNotifier(const ProductsUiState.initial());

  ProductsViewModel({
    required GetAllProductsUseCase getAllProducts,
    required AddProductUseCase addProduct,
    required UpdateProductUseCase updateProduct,
    required DeleteProductUseCase deleteProduct,
  })  : _getAllProducts = getAllProducts,
        _addProduct = addProduct,
        _updateProduct = updateProduct,
        _deleteProduct = deleteProduct;

  // ── Yükleme ───────────────────────────────────────────────────────────────

  Future<void> loadProducts() async {
    state.value = state.value.copyWith(isLoading: true, clearError: true);
    final result = await _getAllProducts();
    result.fold(
      (failure) => state.value = state.value.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (products) => state.value = state.value.copyWith(
        isLoading: false,
        products: products,
      ),
    );
  }

  // ── Ekleme ────────────────────────────────────────────────────────────────

  Future<void> addProduct({
    required String name,
    required String unit,
    required double price,
    required int quantity,
    double criticalThreshold = 15.0,
    int maxStock = 500,
  }) async {
    final product = Product(
      id: const Uuid().v4(),
      name: name,
      unit: unit,
      price: price,
      quantity: quantity,
      description: '',
      imageUrl: '',
      categoryId: '',
      createdAt: DateTime.now(),
      criticalThreshold: criticalThreshold,
      maxStock: maxStock,
    );
    final result = await _addProduct(product);
    result.fold(
      (failure) => state.value = state.value.copyWith(error: failure.message),
      (_) => loadProducts(),
    );
  }

  // ── Güncelleme ────────────────────────────────────────────────────────────

  Future<void> updateProduct(Product product) async {
    final result = await _updateProduct(product);
    result.fold(
      (failure) => state.value = state.value.copyWith(error: failure.message),
      (_) => loadProducts(),
    );
  }

  // ── Silme ─────────────────────────────────────────────────────────────────

  Future<void> deleteProduct(String id) async {
    final result = await _deleteProduct(id);
    result.fold(
      (failure) => state.value = state.value.copyWith(error: failure.message),
      (_) => loadProducts(),
    );
  }

  // ── Filtre / Arama ────────────────────────────────────────────────────────

  void updateFilter(String filter) =>
      state.value = state.value.copyWith(filter: filter);

  void updateSearch(String search) =>
      state.value = state.value.copyWith(search: search);

  void dispose() => state.dispose();
}
