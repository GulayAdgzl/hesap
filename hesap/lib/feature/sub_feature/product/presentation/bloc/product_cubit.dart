import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';
import 'package:hesap/feature/sub_feature/product/usecases/add_product_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/delete_product_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/get_all_products_usecase.dart';
import 'package:hesap/feature/sub_feature/product/usecases/update_product_usecase.dart';
import 'package:uuid/uuid.dart';

import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final AddProductUseCase addProductUseCase;
  final GetAllProductsUseCase getAllProductsUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  ProductCubit({
    required this.addProductUseCase,
    required this.getAllProductsUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  }) : super(ProductStateInitial());

  Future<void> loadProducts() async {
    emit(ProductStateLoading());
    final result = await getAllProductsUseCase();
    result.fold(
      (failure) => emit(ProductStateError(failure.message)),
      (products) => emit(ProductStateLoaded(products)),
    );
  }

  Future<void> addProduct({
    required String name,
    required String unit,
    required double price,
    required int quantity,
    required String description,
    required String imageUrl,
    required String categoryId,
    double criticalThreshold = 15.0,
    int maxStock = 500,
  }) async {
    final product = Product(
      id: const Uuid().v4(),
      name: name,
      unit: unit,
      price: price,
      quantity: quantity,
      description: description,
      imageUrl: imageUrl,
      categoryId: categoryId,
      createdAt: DateTime.now(),
      criticalThreshold: criticalThreshold,
      maxStock: maxStock,
    );
    final result = await addProductUseCase(product);
    result.fold(
      (failure) => emit(ProductStateError(failure.message)),
      (_) => loadProducts(),
    );
  }

  Future<void> updateProduct({required Product product}) async {
    final result = await updateProductUseCase(product);
    result.fold(
      (failure) => emit(ProductStateError(failure.message)),
      (_) => loadProducts(),
    );
  }

  Future<void> deleteProduct(String id) async {
    final result = await deleteProductUseCase(id);
    result.fold(
      (failure) => emit(ProductStateError(failure.message)),
      (_) => loadProducts(),
    );
  }
}
