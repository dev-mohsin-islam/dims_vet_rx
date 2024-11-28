// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drug_generic_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DrugGenericModelAdapter extends TypeAdapter<DrugGenericModel> {
  @override
  final int typeId = 10;

  @override
  DrugGenericModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DrugGenericModel(
      id: fields[0] as int,
      generic_name: fields[1] as String,
      uuid: fields[2] as String?,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
      dimsid: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DrugGenericModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.generic_name)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.u_status)
      ..writeByte(5)
      ..write(obj.web_id)
      ..writeByte(6)
      ..write(obj.dimsid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrugGenericModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
