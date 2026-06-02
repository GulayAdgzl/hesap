import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';

abstract class ProductState {}

class ProductStateInitial extends ProductState {}

class ProductStateLoading extends ProductState {}

class ProductStateLoaded extends ProductState {
  final List<Product> products;
  ProductStateLoaded(this.products);
}

class ProductStateError extends ProductState {
  final String message;
  ProductStateError(this.message);
}
