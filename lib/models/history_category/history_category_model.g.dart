// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryCategoryModelAdapter extends TypeAdapter<HistoryCategoryModel> {
  @override
  final int typeId = 50;

  @override
  HistoryCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryCategoryModel(
      id: fields[0] as int,
      name: fields[1] as String,
      uuid: fields[2] as String,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryCategoryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.u_status)
      ..writeByte(5)
      ..write(obj.web_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}