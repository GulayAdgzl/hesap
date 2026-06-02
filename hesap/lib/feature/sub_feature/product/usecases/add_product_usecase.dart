import 'package:dartz/dartz.dart';
import 'package:hesap/core/errror/failure.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';

import '../data/repositories/product_repository.dart';

class AddProductUseCase {
  final ProductRepository repository;

  AddProductUseCase(this.repository);

  Future<Either<Failure, Unit>> call(Product product) {
    return repository.addProduct(product);
  }
}
