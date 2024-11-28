// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_template_drug_dose_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrescriptionTemplateDrugDoseModelAdapter
    extends TypeAdapter<PrescriptionTemplateDrugDoseModel> {
  @override
  final int typeId = 35;

  @override
  PrescriptionTemplateDrugDoseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrescriptionTemplateDrugDoseModel(
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
      template_id: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PrescriptionTemplateDrugDoseModel obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.template_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrescriptionTemplateDrugDoseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
