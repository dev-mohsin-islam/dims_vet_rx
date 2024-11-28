// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_template_drug_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrescriptionTemplateDrugModelAdapter
    extends TypeAdapter<PrescriptionTemplateDrugModel> {
  @override
  final int typeId = 34;

  @override
  PrescriptionTemplateDrugModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrescriptionTemplateDrugModel(
      id: fields[0] as int,
      u_status: fields[1] as int,
      strength: fields[3] as String,
      doze: fields[4] as String,
      duration: fields[5] as String,
      note: fields[6] as String?,
      uuid: fields[7] as String,
      brand_id: fields[8] as int,
      condition: fields[9] as String,
      template_id: fields[2] as int,
      generic_id: fields[10] as int,
      web_id: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PrescriptionTemplateDrugModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.u_status)
      ..writeByte(2)
      ..write(obj.template_id)
      ..writeByte(3)
      ..write(obj.strength)
      ..writeByte(4)
      ..write(obj.doze)
      ..writeByte(5)
      ..write(obj.duration)
      ..writeByte(6)
      ..write(obj.note)
      ..writeByte(7)
      ..write(obj.uuid)
      ..writeByte(8)
      ..write(obj.brand_id)
      ..writeByte(9)
      ..write(obj.condition)
      ..writeByte(10)
      ..write(obj.generic_id)
      ..writeByte(11)
      ..write(obj.web_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrescriptionTemplateDrugModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
