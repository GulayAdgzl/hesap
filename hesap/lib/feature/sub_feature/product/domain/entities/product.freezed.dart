// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {
  String get id;
  String get name;
  double get price;
  int get quantity;
  String get description;
  String get imageUrl;
  String get categoryId;
  DateTime get createdAt;
  String get unit;
  double get criticalThreshold;
  int get maxStock;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductCopyWith<Product> get copyWith =>
      _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Product &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.criticalThreshold, criticalThreshold) ||
                other.criticalThreshold == criticalThreshold) &&
            (identical(other.maxStock, maxStock) ||
                other.maxStock == maxStock));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      price,
      quantity,
      description,
      imageUrl,
      categoryId,
      createdAt,
      unit,
      criticalThreshold,
      maxStock);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, quantity: $quantity, description: $description, imageUrl: $imageUrl, categoryId: $categoryId, createdAt: $createdAt, unit: $unit, criticalThreshold: $criticalThreshold, maxStock: $maxStock)';
  }
}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) =
      _$ProductCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      double price,
      int quantity,
      String description,
      String imageUrl,
      String categoryId,
      DateTime createdAt,
      String unit,
      double criticalThreshold,
      int maxStock});
}

/// @nodoc
class _$ProductCopyWithImpl<$Res> implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? quantity = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? categoryId = null,
    Object? createdAt = null,
    Object? unit = null,
    Object? criticalThreshold = null,
    Object? maxStock = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      unit: null == unit
          ? _self.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      criticalThreshold: null == criticalThreshold
          ? _self.criticalThreshold
          : criticalThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      maxStock: null == maxStock
          ? _self.maxStock
          : maxStock // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Product value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Product() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Product value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Product():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Product value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Product() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String name,
            double price,
            int quantity,
            String description,
            String imageUrl,
            String categoryId,
            DateTime createdAt,
            String unit,
            double criticalThreshold,
            int maxStock)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Product() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.price,
            _that.quantity,
            _that.description,
            _that.imageUrl,
            _that.categoryId,
            _that.createdAt,
            _that.unit,
            _that.criticalThreshold,
            _that.maxStock);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String name,
            double price,
            int quantity,
            String description,
            String imageUrl,
            String categoryId,
            DateTime createdAt,
            String unit,
            double criticalThreshold,
            int maxStock)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Product():
        return $default(
            _that.id,
            _that.name,
            _that.price,
            _that.quantity,
            _that.description,
            _that.imageUrl,
            _that.categoryId,
            _that.createdAt,
            _that.unit,
            _that.criticalThreshold,
            _that.maxStock);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String name,
            double price,
            int quantity,
            String description,
            String imageUrl,
            String categoryId,
            DateTime createdAt,
            String unit,
            double criticalThreshold,
            int maxStock)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Product() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.price,
            _that.quantity,
            _that.description,
            _that.imageUrl,
            _that.categoryId,
            _that.createdAt,
            _that.unit,
            _that.criticalThreshold,
            _that.maxStock);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Product implements Product {
  const _Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.quantity,
      required this.description,
      required this.imageUrl,
      required this.categoryId,
      required this.createdAt,
      this.unit = 'kg',
      this.criticalThreshold = 15.0,
      this.maxStock = 500});
  factory _Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double price;
  @override
  final int quantity;
  @override
  final String description;
  @override
  final String imageUrl;
  @override
  final String categoryId;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final String unit;
  @override
  @JsonKey()
  final double criticalThreshold;
  @override
  @JsonKey()
  final int maxStock;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductCopyWith<_Product> get copyWith =>
      __$ProductCopyWithImpl<_Product>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Product &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.criticalThreshold, criticalThreshold) ||
                other.criticalThreshold == criticalThreshold) &&
            (identical(other.maxStock, maxStock) ||
                other.maxStock == maxStock));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      price,
      quantity,
      description,
      imageUrl,
      categoryId,
      createdAt,
      unit,
      criticalThreshold,
      maxStock);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, quantity: $quantity, description: $description, imageUrl: $imageUrl, categoryId: $categoryId, createdAt: $createdAt, unit: $unit, criticalThreshold: $criticalThreshold, maxStock: $maxStock)';
  }
}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) =
      __$ProductCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double price,
      int quantity,
      String description,
      String imageUrl,
      String categoryId,
      DateTime createdAt,
      String unit,
      double criticalThreshold,
      int maxStock});
}

/// @nodoc
class __$ProductCopyWithImpl<$Res> implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? quantity = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? categoryId = null,
    Object? createdAt = null,
    Object? unit = null,
    Object? criticalThreshold = null,
    Object? maxStock = null,
  }) {
    return _then(_Product(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      unit: null == unit
          ? _self.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      criticalThreshold: null == criticalThreshold
          ? _self.criticalThreshold
          : criticalThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      maxStock: null == maxStock
          ? _self.maxStock
          : maxStock // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
