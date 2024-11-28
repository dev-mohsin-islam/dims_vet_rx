// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_handout_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrescriptionHandoutModelAdapter
    extends TypeAdapter<PrescriptionHandoutModel> {
  @override
  final int typeId = 23;

  @override
  PrescriptionHandoutModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrescriptionHandoutModel(
      id: fields[0] as int,
      web_id: fields[2] as int?,
      u_status: fields[1] as int,
      uuid: fields[3] as String,
      prescription_id: fields[4] as int,
      handout: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PrescriptionHandoutModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.u_status)
      ..writeByte(2)
      ..write(obj.web_id)
      ..writeByte(3)
      ..write(obj.uuid)
      ..writeByte(4)
      ..write(obj.prescription_id)
      ..writeByte(5)
      ..write(obj.handout);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrescriptionHandoutModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
