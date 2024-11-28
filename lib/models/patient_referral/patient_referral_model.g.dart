// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_referral_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientReferralModelAdapter extends TypeAdapter<PatientReferralModel> {
  @override
  final int typeId = 42;

  @override
  PatientReferralModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PatientReferralModel(
      app_id: fields[1] as String?,
      id: fields[0] as int,
      uuid: fields[2] as String?,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
      referred_to: fields[6] as int,
      special_notes: fields[7] as String?,
      reason_for_referral: fields[8] as String?,
      referred_by: fields[9] as String?,
      clinical_information: fields[10] as String?,
    )..referred_to_uuid = fields[11] as String?;
  }

  @override
  void write(BinaryWriter writer, PatientReferralModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.app_id)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.u_status)
      ..writeByte(5)
      ..write(obj.web_id)
      ..writeByte(6)
      ..write(obj.referred_to)
      ..writeByte(7)
      ..write(obj.special_notes)
      ..writeByte(8)
      ..write(obj.reason_for_referral)
      ..writeByte(9)
      ..write(obj.referred_by)
      ..writeByte(10)
      ..write(obj.clinical_information)
      ..writeByte(11)
      ..write(obj.referred_to_uuid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientReferralModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
