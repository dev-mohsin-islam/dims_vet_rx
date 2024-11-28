// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handout_category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HandoutCategoryModelAdapter extends TypeAdapter<HandoutCategoryModel> {
  @override
  final int typeId = 15;

  @override
  HandoutCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HandoutCategoryModel(
      id: fields[0] as int,
      category_name: fields[1] as String,
      uuid: fields[2] as String?,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HandoutCategoryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category_name)
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
      other is HandoutCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
