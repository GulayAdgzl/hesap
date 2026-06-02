import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_stock_entry.freezed.dart';

@freezed
abstract class DailyStockEntry with _$DailyStockEntry {
  const factory DailyStockEntry({
    required String id,
    required String productId,
    required String productName,
    required String productUnit,
    required int previousQuantity,
    required int currentQuantity,
    required double unitPrice,
    required DateTime date,
  }) = _DailyStockEntry;

  // Hesaplamalar
}

extension DailyStockEntryX on DailyStockEntry {
  int get consumed => previousQuantity - currentQuantity;
  double get totalCost => consumed * unitPrice;
  bool get hasNegativeStock => currentQuantity < 0;
}
