// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handout_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HandoutModelAdapter extends TypeAdapter<HandoutModel> {
  @override
  final int typeId = 39;

  @override
  HandoutModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HandoutModel(
      id: fields[0] as int,
      category_id: fields[1] as int?,
      text: fields[6] as String?,
      label: fields[7] as String?,
      uuid: fields[2] as String?,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HandoutModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category_id)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.u_status)
      ..writeByte(5)
      ..write(obj.web_id)
      ..writeByte(6)
      ..write(obj.text)
      ..writeByte(7)
      ..write(obj.label);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HandoutModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
