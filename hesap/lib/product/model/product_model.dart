import 'package:hesap/feature/sub_feature/product/domain/entities/product.dart';
import 'package:hive_ce/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String imageUrl;

  @HiveField(6)
  final String categoryId;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final double criticalThreshold;

  @HiveField(9)
  final String unit;

  @HiveField(10)
  final int maxStock;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.description,
    required this.imageUrl,
    required this.categoryId,
    required this.createdAt,
    this.criticalThreshold = 15.0,
    this.unit = 'kg',
    this.maxStock = 500,
  });

  factory ProductModel.fromEntity(Product entity) => ProductModel(
        id: entity.id,
        name: entity.name,
        price: entity.price,
        quantity: entity.quantity,
        description: entity.description,
        imageUrl: entity.imageUrl,
        categoryId: entity.categoryId,
        createdAt: entity.createdAt,
        criticalThreshold: entity.criticalThreshold,
        unit: entity.unit,
        maxStock: entity.maxStock,
      );

  Product toEntity() => Product(
        id: id,
        name: name,
        price: price,
        quantity: quantity,
        description: description,
        imageUrl: imageUrl,
        categoryId: categoryId,
        createdAt: createdAt,
        criticalThreshold: criticalThreshold,
        unit: unit,
        maxStock: maxStock,
      );
}
