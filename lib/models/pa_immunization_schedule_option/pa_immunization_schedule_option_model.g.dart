// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pa_immunization_schedule_option_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaImmunizationSchedOptionModelAdapter
    extends TypeAdapter<PaImmunizationSchedOptionModel> {
  @override
  final int typeId = 46;

  @override
  PaImmunizationSchedOptionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaImmunizationSchedOptionModel(
      pa_id: fields[1] as String?,
      id: fields[0] as int,
      uuid: fields[2] as String?,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
      given_date: fields[7] as String?,
      note: fields[8] as String?,
      vaccines_id: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PaImmunizationSchedOptionModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pa_id)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.u_status)
      ..writeByte(5)
      ..write(obj.web_id)
      ..writeByte(6)
      ..write(obj.vaccines_id)
      ..writeByte(7)
      ..write(obj.given_date)
      ..writeByte(8)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaImmunizationSchedOptionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
