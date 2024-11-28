// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientModelAdapter extends TypeAdapter<PatientModel> {
  @override
  final int typeId = 19;

  @override
  PatientModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PatientModel(
      id: fields[0] as int,
      name: fields[1] as String,
      uuid: fields[2] as String,
      date: fields[3] as String?,
      u_status: fields[4] as int,
      web_id: fields[5] as int?,
      dob: fields[6] as String?,
      sex: fields[7] as int?,
      marital_status: fields[8] as int?,
      guardian_name: fields[9] as String?,
      phone: fields[10] as String?,
      email: fields[11] as String?,
      area: fields[12] as String?,
      occupation: fields[13] as String?,
      education: fields[14] as String?,
      blood_group: fields[15] as int?,
      blood_group_new: fields[16] as String?,
      ageHours: fields[17] as num?,
      ageMin: fields[18] as num?,
      ageDays: fields[19] as num?,
      chamber_id: fields[20] as String?,
      p_type: fields[21] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PatientModel obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.u_status)
      ..writeByte(5)
      ..write(obj.web_id)
      ..writeByte(6)
      ..write(obj.dob)
      ..writeByte(7)
      ..write(obj.sex)
      ..writeByte(8)
      ..write(obj.marital_status)
      ..writeByte(9)
      ..write(obj.guardian_name)
      ..writeByte(10)
      ..write(obj.phone)
      ..writeByte(11)
      ..write(obj.email)
      ..writeByte(12)
      ..write(obj.area)
      ..writeByte(13)
      ..write(obj.occupation)
      ..writeByte(14)
      ..write(obj.education)
      ..writeByte(15)
      ..write(obj.blood_group)
      ..writeByte(16)
      ..write(obj.blood_group_new)
      ..writeByte(17)
      ..write(obj.ageHours)
      ..writeByte(18)
      ..write(obj.ageMin)
      ..writeByte(19)
      ..write(obj.ageDays)
      ..writeByte(20)
      ..write(obj.chamber_id)
      ..writeByte(21)
      ..write(obj.p_type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
