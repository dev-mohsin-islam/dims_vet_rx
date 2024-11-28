// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_duration_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrescriptionDurationModelAdapter
    extends TypeAdapter<PrescriptionDurationModel> {
  @override
  final int typeId = 24;

  @override
  PrescriptionDurationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrescriptionDurationModel(
      id: fields[0] as int,
      web_id: fields[2] as int?,
      u_status: fields[1] as int,
      uuid: fields[3] as String,
      name: fields[4] as String,
      number: fields[5] as int,
      type: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PrescriptionDurationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.u_status)
      ..writeByte(2)
      ..write(obj.web_id)
      ..writeByte(3)
      ..write(obj.uuid)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.number)
      ..writeByte(6)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrescriptionDurationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
