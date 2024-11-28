// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentModelAdapter extends TypeAdapter<AppointmentModel> {
  @override
  final int typeId = 20;

  @override
  AppointmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppointmentModel(
      id: fields[0] as int,
      uuid: fields[1] as String,
      u_status: fields[2] as int,
      web_id: fields[3] as int?,
      patient_id: fields[4] as int,
      date: fields[5] as String,
      next_visit: fields[6] as String?,
      appointed_by: fields[7] as int,
      appointed_to: fields[8] as int,
      pulse: fields[9] as int?,
      sys_blood_pressure: fields[10] as int?,
      dys_blood_pressure: fields[11] as int?,
      temparature: fields[12] as String?,
      weight: fields[13] as double?,
      height: fields[14] as double?,
      OFC: fields[15] as double?,
      waist: fields[16] as double?,
      hip: fields[17] as double?,
      rr: fields[18] as int?,
      complain: fields[19] as String?,
      medicine: fields[20] as String?,
      improvement: fields[21] as int?,
      fee: fields[22] as int?,
      status: fields[23] as int,
      report_patient: fields[24] as int?,
      serial: fields[25] as int?,
      chamber_id: fields[26] as String?,
      hospital_id: fields[27] as String?,
      patient_hospital_reg_id: fields[28] as String?,
      ward_no: fields[29] as String?,
      bed_no: fields[30] as String?,
      cabin_no: fields[31] as String?,
      room_no: fields[32] as String?,
      is_pregnant: fields[33] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AppointmentModel obj) {
    writer
      ..writeByte(34)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.u_status)
      ..writeByte(3)
      ..write(obj.web_id)
      ..writeByte(4)
      ..write(obj.patient_id)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.next_visit)
      ..writeByte(7)
      ..write(obj.appointed_by)
      ..writeByte(8)
      ..write(obj.appointed_to)
      ..writeByte(9)
      ..write(obj.pulse)
      ..writeByte(10)
      ..write(obj.sys_blood_pressure)
      ..writeByte(11)
      ..write(obj.dys_blood_pressure)
      ..writeByte(12)
      ..write(obj.temparature)
      ..writeByte(13)
      ..write(obj.weight)
      ..writeByte(14)
      ..write(obj.height)
      ..writeByte(15)
      ..write(obj.OFC)
      ..writeByte(16)
      ..write(obj.waist)
      ..writeByte(17)
      ..write(obj.hip)
      ..writeByte(18)
      ..write(obj.rr)
      ..writeByte(19)
      ..write(obj.complain)
      ..writeByte(20)
      ..write(obj.medicine)
      ..writeByte(21)
      ..write(obj.improvement)
      ..writeByte(22)
      ..write(obj.fee)
      ..writeByte(23)
      ..write(obj.status)
      ..writeByte(24)
      ..write(obj.report_patient)
      ..writeByte(25)
      ..write(obj.serial)
      ..writeByte(26)
      ..write(obj.chamber_id)
      ..writeByte(27)
      ..write(obj.hospital_id)
      ..writeByte(28)
      ..write(obj.patient_hospital_reg_id)
      ..writeByte(29)
      ..write(obj.ward_no)
      ..writeByte(30)
      ..write(obj.bed_no)
      ..writeByte(31)
      ..write(obj.cabin_no)
      ..writeByte(32)
      ..write(obj.room_no)
      ..writeByte(33)
      ..write(obj.is_pregnant);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
