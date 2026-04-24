import 'package:dartz/dartz.dart';
import 'package:hesap/core/errror/failure.dart';

import '../entities/product.dart';
import '../repositories/product_repository.dart';

class AddProductUseCase {
  final ProductRepository repository;

  AddProductUseCase(this.repository);

  Future<Either<Failure, Unit>> call(Product product) {
    return repository.addProduct(product);
  }
}
