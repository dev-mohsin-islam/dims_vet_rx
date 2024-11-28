// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advice_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdviceModelAdapter extends TypeAdapter<AdviceModel> {
  @override
  final int typeId = 25;

  @override
  AdviceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdviceModel(
      id: fields[0] as int,
      label: fields[1] as String,
      uuid: fields[2] as String?,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
      text: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AdviceModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.u_status)
      ..writeByte(5)
      ..write(obj.web_id)
      ..writeByte(6)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdviceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
