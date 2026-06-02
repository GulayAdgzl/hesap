// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_stock_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyStockEntry {
  String get id;
  String get productId;
  String get productName;
  String get productUnit;
  int get previousQuantity;
  int get currentQuantity;
  double get unitPrice;
  DateTime get date;

  /// Create a copy of DailyStockEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DailyStockEntryCopyWith<DailyStockEntry> get copyWith =>
      _$DailyStockEntryCopyWithImpl<DailyStockEntry>(
          this as DailyStockEntry, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DailyStockEntry &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productUnit, productUnit) ||
                other.productUnit == productUnit) &&
            (identical(other.previousQuantity, previousQuantity) ||
                other.previousQuantity == previousQuantity) &&
            (identical(other.currentQuantity, currentQuantity) ||
                other.currentQuantity == currentQuantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, productId, productName,
      productUnit, previousQuantity, currentQuantity, unitPrice, date);

  @override
  String toString() {
    return 'DailyStockEntry(id: $id, productId: $productId, productName: $productName, productUnit: $productUnit, previousQuantity: $previousQuantity, currentQuantity: $currentQuantity, unitPrice: $unitPrice, date: $date)';
  }
}

/// @nodoc
abstract mixin class $DailyStockEntryCopyWith<$Res> {
  factory $DailyStockEntryCopyWith(
          DailyStockEntry value, $Res Function(DailyStockEntry) _then) =
      _$DailyStockEntryCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String productId,
      String productName,
      String productUnit,
      int previousQuantity,
      int currentQuantity,
      double unitPrice,
      DateTime date});
}

/// @nodoc
class _$DailyStockEntryCopyWithImpl<$Res>
    implements $DailyStockEntryCopyWith<$Res> {
  _$DailyStockEntryCopyWithImpl(this._self, this._then);

  final DailyStockEntry _self;
  final $Res Function(DailyStockEntry) _then;

  /// Create a copy of DailyStockEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = null,
    Object? productUnit = null,
    Object? previousQuantity = null,
    Object? currentQuantity = null,
    Object? unitPrice = null,
    Object? date = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productUnit: null == productUnit
          ? _self.productUnit
          : productUnit // ignore: cast_nullable_to_non_nullable
              as String,
      previousQuantity: null == previousQuantity
          ? _self.previousQuantity
          : previousQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      currentQuantity: null == currentQuantity
          ? _self.currentQuantity
          : currentQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _self.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [DailyStockEntry].
extension DailyStockEntryPatterns on DailyStockEntry {
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
    TResult Function(_DailyStockEntry value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DailyStockEntry() when $default != null:
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
    TResult Function(_DailyStockEntry value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailyStockEntry():
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
    TResult? Function(_DailyStockEntry value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailyStockEntry() when $default != null:
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
            String productId,
            String productName,
            String productUnit,
            int previousQuantity,
            int currentQuantity,
            double unitPrice,
            DateTime date)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DailyStockEntry() when $default != null:
        return $default(
            _that.id,
            _that.productId,
            _that.productName,
            _that.productUnit,
            _that.previousQuantity,
            _that.currentQuantity,
            _that.unitPrice,
            _that.date);
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
            String productId,
            String productName,
            String productUnit,
            int previousQuantity,
            int currentQuantity,
            double unitPrice,
            DateTime date)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailyStockEntry():
        return $default(
            _that.id,
            _that.productId,
            _that.productName,
            _that.productUnit,
            _that.previousQuantity,
            _that.currentQuantity,
            _that.unitPrice,
            _that.date);
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
            String productId,
            String productName,
            String productUnit,
            int previousQuantity,
            int currentQuantity,
            double unitPrice,
            DateTime date)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DailyStockEntry() when $default != null:
        return $default(
            _that.id,
            _that.productId,
            _that.productName,
            _that.productUnit,
            _that.previousQuantity,
            _that.currentQuantity,
            _that.unitPrice,
            _that.date);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DailyStockEntry implements DailyStockEntry {
  const _DailyStockEntry(
      {required this.id,
      required this.productId,
      required this.productName,
      required this.productUnit,
      required this.previousQuantity,
      required this.currentQuantity,
      required this.unitPrice,
      required this.date});

  @override
  final String id;
  @override
  final String productId;
  @override
  final String productName;
  @override
  final String productUnit;
  @override
  final int previousQuantity;
  @override
  final int currentQuantity;
  @override
  final double unitPrice;
  @override
  final DateTime date;

  /// Create a copy of DailyStockEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DailyStockEntryCopyWith<_DailyStockEntry> get copyWith =>
      __$DailyStockEntryCopyWithImpl<_DailyStockEntry>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DailyStockEntry &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productUnit, productUnit) ||
                other.productUnit == productUnit) &&
            (identical(other.previousQuantity, previousQuantity) ||
                other.previousQuantity == previousQuantity) &&
            (identical(other.currentQuantity, currentQuantity) ||
                other.currentQuantity == currentQuantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, productId, productName,
      productUnit, previousQuantity, currentQuantity, unitPrice, date);

  @override
  String toString() {
    return 'DailyStockEntry(id: $id, productId: $productId, productName: $productName, productUnit: $productUnit, previousQuantity: $previousQuantity, currentQuantity: $currentQuantity, unitPrice: $unitPrice, date: $date)';
  }
}

/// @nodoc
abstract mixin class _$DailyStockEntryCopyWith<$Res>
    implements $DailyStockEntryCopyWith<$Res> {
  factory _$DailyStockEntryCopyWith(
          _DailyStockEntry value, $Res Function(_DailyStockEntry) _then) =
      __$DailyStockEntryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String productId,
      String productName,
      String productUnit,
      int previousQuantity,
      int currentQuantity,
      double unitPrice,
      DateTime date});
}

/// @nodoc
class __$DailyStockEntryCopyWithImpl<$Res>
    implements _$DailyStockEntryCopyWith<$Res> {
  __$DailyStockEntryCopyWithImpl(this._self, this._then);

  final _DailyStockEntry _self;
  final $Res Function(_DailyStockEntry) _then;

  /// Create a copy of DailyStockEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = null,
    Object? productUnit = null,
    Object? previousQuantity = null,
    Object? currentQuantity = null,
    Object? unitPrice = null,
    Object? date = null,
  }) {
    return _then(_DailyStockEntry(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productUnit: null == productUnit
          ? _self.productUnit
          : productUnit // ignore: cast_nullable_to_non_nullable
              as String,
      previousQuantity: null == previousQuantity
          ? _self.previousQuantity
          : previousQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      currentQuantity: null == currentQuantity
          ? _self.currentQuantity
          : currentQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _self.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
