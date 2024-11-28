// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_drug_dose_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrescriptionDrugDoseModelAdapter
    extends TypeAdapter<PrescriptionDrugDoseModel> {
  @override
  final int typeId = 32;

  @override
  PrescriptionDrugDoseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrescriptionDrugDoseModel(
      id: fields[0] as int,
      u_status: fields[1] as int,
      generic_id: fields[2] as int,
      doze: fields[4] as String,
      duration: fields[5] as String,
      note: fields[6] as String?,
      uuid: fields[7] as String,
      drug_id: fields[8] as int,
      condition: fields[3] as String,
      dose_serial: fields[9] as int?,
      prescription_id: fields[10] as int?,
      web_id: fields[11] as int?,
      strength: fields[12] as String?,
      chamber_id: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PrescriptionDrugDoseModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.u_status)
      ..writeByte(2)
      ..write(obj.generic_id)
      ..writeByte(3)
      ..write(obj.condition)
      ..writeByte(4)
      ..write(obj.doze)
      ..writeByte(5)
      ..write(obj.duration)
      ..writeByte(6)
      ..write(obj.note)
      ..writeByte(7)
      ..write(obj.uuid)
      ..writeByte(8)
      ..write(obj.drug_id)
      ..writeByte(9)
      ..write(obj.dose_serial)
      ..writeByte(10)
      ..write(obj.prescription_id)
      ..writeByte(11)
      ..write(obj.web_id)
      ..writeByte(12)
      ..write(obj.strength)
      ..writeByte(13)
      ..write(obj.chamber_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrescriptionDrugDoseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
