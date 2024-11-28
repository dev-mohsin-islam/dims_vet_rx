// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pa_immunization_vaccines_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaImmunizationVaccinesModelAdapter
    extends TypeAdapter<PaImmunizationVaccinesModel> {
  @override
  final int typeId = 47;

  @override
  PaImmunizationVaccinesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaImmunizationVaccinesModel(
      id: fields[0] as int,
      uuid: fields[1] as String?,
      date: fields[2] as String?,
      u_status: fields[3] as int?,
      web_id: fields[4] as int?,
      dose_no: fields[6] as String?,
      parent: fields[7] as int?,
      name: fields[8] as String?,
    )..recommended_age = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, PaImmunizationVaccinesModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.u_status)
      ..writeByte(4)
      ..write(obj.web_id)
      ..writeByte(5)
      ..write(obj.recommended_age)
      ..writeByte(6)
      ..write(obj.dose_no)
      ..writeByte(7)
      ..write(obj.parent)
      ..writeByte(8)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaImmunizationVaccinesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
