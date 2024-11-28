// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chamber_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChamberModelAdapter extends TypeAdapter<ChamberModel> {
  @override
  final int typeId = 41;

  @override
  ChamberModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChamberModel(
      id: fields[0] as int,
      chamber_name: fields[1] as String?,
      chamber_address: fields[6] as String?,
      npl_code: fields[7] as String?,
      uuid: fields[2] as String?,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ChamberModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.chamber_name)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.u_status)
      ..writeByte(5)
      ..write(obj.web_id)
      ..writeByte(6)
      ..write(obj.chamber_address)
      ..writeByte(7)
      ..write(obj.npl_code);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChamberModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
