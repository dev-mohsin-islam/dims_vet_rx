// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientHistoryModelAdapter extends TypeAdapter<PatientHistoryModel> {
  @override
  final int typeId = 29;

  @override
  PatientHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PatientHistoryModel(
      id: fields[0] as int,
      patient_id: fields[1] as int,
      uuid: fields[2] as String?,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
      history_id: fields[6] as int,
      category: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PatientHistoryModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.patient_id)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.u_status)
      ..writeByte(5)
      ..write(obj.web_id)
      ..writeByte(6)
      ..write(obj.history_id)
      ..writeByte(7)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
