// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrescriptionModelAdapter extends TypeAdapter<PrescriptionModel> {
  @override
  final int typeId = 21;

  @override
  PrescriptionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrescriptionModel(
      id: fields[0] as int,
      web_id: fields[1] as int?,
      u_status: fields[2] as int,
      appointment_id: fields[3] as int,
      note: fields[4] as String?,
      physical_findings: fields[5] as String?,
      uuid: fields[6] as String,
      cc_text: fields[7] as String?,
      diagnosis_text: fields[8] as String?,
      investigation_text: fields[9] as String?,
      onexam_text: fields[10] as String?,
      investigation_report_text: fields[11] as String?,
      date: fields[12] as String?,
      chamber_id: fields[13] as String?,
      special_notes: fields[14] as String?,
      treatment_plan: fields[15] as String?,
      referral_short: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PrescriptionModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.web_id)
      ..writeByte(2)
      ..write(obj.u_status)
      ..writeByte(3)
      ..write(obj.appointment_id)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.physical_findings)
      ..writeByte(6)
      ..write(obj.uuid)
      ..writeByte(7)
      ..write(obj.cc_text)
      ..writeByte(8)
      ..write(obj.diagnosis_text)
      ..writeByte(9)
      ..write(obj.investigation_text)
      ..writeByte(10)
      ..write(obj.onexam_text)
      ..writeByte(11)
      ..write(obj.investigation_report_text)
      ..writeByte(12)
      ..write(obj.date)
      ..writeByte(13)
      ..write(obj.chamber_id)
      ..writeByte(14)
      ..write(obj.special_notes)
      ..writeByte(15)
      ..write(obj.treatment_plan)
      ..writeByte(16)
      ..write(obj.referral_short);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrescriptionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
