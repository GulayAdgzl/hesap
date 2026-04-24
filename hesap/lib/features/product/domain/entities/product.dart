import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required double price,
    required int quantity,
    required String description,
    required String imageUrl,
    required String categoryId,
    required DateTime createdAt,
    @Default('kg') String unit,
    @Default(15.0) double criticalThreshold,
    @Default(500) int maxStock,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
