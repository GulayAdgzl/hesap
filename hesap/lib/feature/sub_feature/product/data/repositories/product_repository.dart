import 'package:dartz/dartz.dart';
import 'package:hesap/core/errror/failure.dart';
import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, Unit>> addProduct(Product product);
  Future<Either<Failure, List<Product>>> getAllProducts();
  Future<Either<Failure, Unit>> updateProduct(Product product);
  Future<Either<Failure, Unit>> deleteProduct(String id);
}
