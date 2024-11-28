// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_procedure_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrescriptionProcedureModelAdapter
    extends TypeAdapter<PrescriptionProcedureModel> {
  @override
  final int typeId = 36;

  @override
  PrescriptionProcedureModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrescriptionProcedureModel(
      id: fields[0] as int,
      u_status: fields[1] as int,
      prescription_id: fields[2] as int,
      procedure_id: fields[3] as int,
      diagnosis: fields[4] as String?,
      anesthesia: fields[5] as String?,
      incision: fields[6] as String?,
      surgeon: fields[7] as String?,
      uuid: fields[8] as String,
      assistant: fields[9] as String?,
      details: fields[10] as String?,
      prosthesis: fields[11] as String?,
      closer: fields[12] as String?,
      findings: fields[13] as String?,
      complications: fields[14] as String?,
      drains: fields[15] as String?,
      post_operative_instructions: fields[16] as String?,
      procedure_name: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PrescriptionProcedureModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.u_status)
      ..writeByte(2)
      ..write(obj.prescription_id)
      ..writeByte(3)
      ..write(obj.procedure_id)
      ..writeByte(4)
      ..write(obj.diagnosis)
      ..writeByte(5)
      ..write(obj.anesthesia)
      ..writeByte(6)
      ..write(obj.incision)
      ..writeByte(7)
      ..write(obj.surgeon)
      ..writeByte(8)
      ..write(obj.uuid)
      ..writeByte(9)
      ..write(obj.assistant)
      ..writeByte(10)
      ..write(obj.details)
      ..writeByte(11)
      ..write(obj.prosthesis)
      ..writeByte(12)
      ..write(obj.closer)
      ..writeByte(13)
      ..write(obj.findings)
      ..writeByte(14)
      ..write(obj.complications)
      ..writeByte(15)
      ..write(obj.drains)
      ..writeByte(16)
      ..write(obj.post_operative_instructions)
      ..writeByte(17)
      ..write(obj.procedure_name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrescriptionProcedureModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
