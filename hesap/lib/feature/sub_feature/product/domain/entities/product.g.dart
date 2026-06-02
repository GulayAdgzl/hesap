// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      categoryId: json['categoryId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      unit: json['unit'] as String? ?? 'kg',
      criticalThreshold:
          (json['criticalThreshold'] as num?)?.toDouble() ?? 15.0,
      maxStock: (json['maxStock'] as num?)?.toInt() ?? 500,
    );

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'categoryId': instance.categoryId,
      'createdAt': instance.createdAt.toIso8601String(),
      'unit': instance.unit,
      'criticalThreshold': instance.criticalThreshold,
      'maxStock': instance.maxStock,
    };
