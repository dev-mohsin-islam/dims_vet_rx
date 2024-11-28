// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pa_immunization_vaccines_option_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaImmunizationVaccinesOptModelAdapter
    extends TypeAdapter<PaImmunizationVaccinesOptModel> {
  @override
  final int typeId = 48;

  @override
  PaImmunizationVaccinesOptModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaImmunizationVaccinesOptModel(
      id: fields[0] as int,
      uuid: fields[1] as String?,
      date: fields[2] as String?,
      u_status: fields[3] as int?,
      web_id: fields[4] as int?,
      dose_no: fields[7] as String?,
      group_name: fields[5] as String?,
      name: fields[8] as String?,
      recommended_age: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PaImmunizationVaccinesOptModel obj) {
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
      ..write(obj.group_name)
      ..writeByte(6)
      ..write(obj.recommended_age)
      ..writeByte(7)
      ..write(obj.dose_no)
      ..writeByte(8)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaImmunizationVaccinesOptModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
