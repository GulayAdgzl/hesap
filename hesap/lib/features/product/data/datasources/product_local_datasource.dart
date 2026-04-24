import 'package:hive_ce/hive.dart';
import 'package:hesap/core/models/product_model.dart';
import 'package:hesap/features/product/domain/entities/product.dart';

abstract class ProductLocalDatasource {
  Future<void> addProduct(Product product);
  Future<List<Product>> getAllProducts();
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}

class ProductLocalDatasourceImpl implements ProductLocalDatasource {
  final Box<ProductModel> box;

  ProductLocalDatasourceImpl(this.box);

  @override
  Future<void> addProduct(Product product) async {
    await box.put(product.id, ProductModel.fromEntity(product));
  }

  @override
  Future<List<Product>> getAllProducts() async {
    return box.values.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateProduct(Product product) async {
    await box.put(product.id, ProductModel.fromEntity(product));
  }

  @override
  Future<void> deleteProduct(String id) async {
    await box.delete(id);
  }
}
