// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_stock_entry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyStockEntryModelAdapter extends TypeAdapter<DailyStockEntryModel> {
  @override
  final typeId = 2;

  @override
  DailyStockEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyStockEntryModel(
      id: fields[0] as String,
      productId: fields[1] as String,
      productName: fields[2] as String,
      productUnit: fields[3] as String,
      previousQuantity: (fields[4] as num).toInt(),
      currentQuantity: (fields[5] as num).toInt(),
      unitPrice: (fields[6] as num).toDouble(),
      date: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DailyStockEntryModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.productUnit)
      ..writeByte(4)
      ..write(obj.previousQuantity)
      ..writeByte(5)
      ..write(obj.currentQuantity)
      ..writeByte(6)
      ..write(obj.unitPrice)
      ..writeByte(7)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyStockEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
