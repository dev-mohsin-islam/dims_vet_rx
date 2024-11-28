// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_pages_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingPagesModelAdapter extends TypeAdapter<SettingPagesModel> {
  @override
  final int typeId = 30;

  @override
  SettingPagesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingPagesModel(
      id: fields[0] as int,
      section: fields[1] as String,
      uuid: fields[2] as String?,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
      label: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SettingPagesModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.section)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.u_status)
      ..writeByte(5)
      ..write(obj.web_id)
      ..writeByte(6)
      ..write(obj.label);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingPagesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
