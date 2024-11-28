// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_certificate_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientCertificateModelAdapter
    extends TypeAdapter<PatientCertificateModel> {
  @override
  final int typeId = 40;

  @override
  PatientCertificateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PatientCertificateModel(
      id: fields[0] as int,
      appointment_id: fields[1] as String?,
      guardian_name: fields[6] as String?,
      guardian_sex: fields[14] as int?,
      uuid: fields[2] as String?,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
      diagnosis: fields[7] as String?,
      form: fields[8] as String?,
      to: fields[9] as String?,
      type: fields[10] as String?,
      duration: fields[11] as String?,
      got_to: fields[12] as String?,
      is_continue: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PatientCertificateModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.appointment_id)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.u_status)
      ..writeByte(5)
      ..write(obj.web_id)
      ..writeByte(6)
      ..write(obj.guardian_name)
      ..writeByte(7)
      ..write(obj.diagnosis)
      ..writeByte(8)
      ..write(obj.form)
      ..writeByte(9)
      ..write(obj.to)
      ..writeByte(10)
      ..write(obj.type)
      ..writeByte(11)
      ..write(obj.duration)
      ..writeByte(12)
      ..write(obj.got_to)
      ..writeByte(13)
      ..write(obj.is_continue)
      ..writeByte(14)
      ..write(obj.guardian_sex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientCertificateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
