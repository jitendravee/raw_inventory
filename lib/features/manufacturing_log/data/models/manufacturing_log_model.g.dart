// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manufacturing_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ManufacturingLogModelAdapter extends TypeAdapter<ManufacturingLogModel> {
  @override
  final int typeId = 3;

  @override
  ManufacturingLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ManufacturingLogModel(
      date: fields[0] as DateTime,
      productName: fields[1] as String,
      quantity: fields[2] as int,
      notes: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ManufacturingLogModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ManufacturingLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
