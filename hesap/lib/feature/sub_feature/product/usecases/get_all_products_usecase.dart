import 'package:dartz/dartz.dart';
import 'package:hesap/core/errror/failure.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';

import '../data/repositories/product_repository.dart';

class GetAllProductsUseCase {
  final ProductRepository repository;

  GetAllProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call() {
    return repository.getAllProducts();
  }
}
