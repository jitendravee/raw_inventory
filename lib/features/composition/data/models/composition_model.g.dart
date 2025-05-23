// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'composition_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompositionModelAdapter extends TypeAdapter<CompositionModel> {
  @override
  final int typeId = 1;

  @override
  CompositionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompositionModel(
      productName: fields[0] as String,
      materialRequirements: (fields[1] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, CompositionModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.productName)
      ..writeByte(1)
      ..write(obj.materialRequirements);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompositionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
