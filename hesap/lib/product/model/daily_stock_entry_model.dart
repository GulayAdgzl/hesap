import 'package:hesap/feature/stock/domain/entities/daily_stock_entry.dart';
import 'package:hive_ce/hive.dart';

part 'daily_stock_entry_model.g.dart';

@HiveType(typeId: 2)
class DailyStockEntryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final String productName;

  @HiveField(3)
  final String productUnit;

  @HiveField(4)
  final int previousQuantity;

  @HiveField(5)
  final int currentQuantity;

  @HiveField(6)
  final double unitPrice;

  @HiveField(7)
  final DateTime date;

  DailyStockEntryModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productUnit,
    required this.previousQuantity,
    required this.currentQuantity,
    required this.unitPrice,
    required this.date,
  });

  factory DailyStockEntryModel.fromEntity(DailyStockEntry e) =>
      DailyStockEntryModel(
        id: e.id,
        productId: e.productId,
        productName: e.productName,
        productUnit: e.productUnit,
        previousQuantity: e.previousQuantity,
        currentQuantity: e.currentQuantity,
        unitPrice: e.unitPrice,
        date: e.date,
      );

  DailyStockEntry toEntity() => DailyStockEntry(
        id: id,
        productId: productId,
        productName: productName,
        productUnit: productUnit,
        previousQuantity: previousQuantity,
        currentQuantity: currentQuantity,
        unitPrice: unitPrice,
        date: date,
      );
}
