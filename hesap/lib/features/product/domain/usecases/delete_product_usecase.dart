import 'package:dartz/dartz.dart';
import 'package:hesap/core/errror/failure.dart';

import '../repositories/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteProduct(id);
  }
}
