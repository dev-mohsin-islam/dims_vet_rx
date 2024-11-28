// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_drug_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrescriptionDrugModelAdapter extends TypeAdapter<PrescriptionDrugModel> {
  @override
  final int typeId = 22;

  @override
  PrescriptionDrugModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrescriptionDrugModel(
      id: fields[0] as int,
      u_status: fields[1] as int,
      prescription_id: fields[2] as int,
      generic_id: fields[3] as int,
      strength: fields[4] as String,
      doze: fields[5] as String,
      duration: fields[6] as String,
      note: fields[7] as String?,
      uuid: fields[8] as String,
      brand_id: fields[9] as int,
      condition: fields[10] as String,
      web_id: fields[11] as int?,
      company_id: fields[12] as int?,
      date: fields[13] as String?,
      chamber_id: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PrescriptionDrugModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.u_status)
      ..writeByte(2)
      ..write(obj.prescription_id)
      ..writeByte(3)
      ..write(obj.generic_id)
      ..writeByte(4)
      ..write(obj.strength)
      ..writeByte(5)
      ..write(obj.doze)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.note)
      ..writeByte(8)
      ..write(obj.uuid)
      ..writeByte(9)
      ..write(obj.brand_id)
      ..writeByte(10)
      ..write(obj.condition)
      ..writeByte(11)
      ..write(obj.web_id)
      ..writeByte(12)
      ..write(obj.company_id)
      ..writeByte(13)
      ..write(obj.date)
      ..writeByte(14)
      ..write(obj.chamber_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrescriptionDrugModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
