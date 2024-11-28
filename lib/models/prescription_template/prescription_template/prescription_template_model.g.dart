// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_template_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrescriptionTemplateModelAdapter
    extends TypeAdapter<PrescriptionTemplateModel> {
  @override
  final int typeId = 33;

  @override
  PrescriptionTemplateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrescriptionTemplateModel(
      id: fields[0] as int,
      web_id: fields[1] as int?,
      u_status: fields[2] as int,
      template_name: fields[3] as String,
      note: fields[4] as String?,
      user_id: fields[5] as int,
      uuid: fields[6] as String,
      cc_data: fields[7] as String?,
      diagnosis_text: fields[8] as String?,
      investigation_text: fields[9] as String?,
      on_data: fields[10] as String?,
      investigation_data: fields[11] as String?,
      date: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PrescriptionTemplateModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.web_id)
      ..writeByte(2)
      ..write(obj.u_status)
      ..writeByte(3)
      ..write(obj.template_name)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.user_id)
      ..writeByte(6)
      ..write(obj.uuid)
      ..writeByte(7)
      ..write(obj.cc_data)
      ..writeByte(8)
      ..write(obj.diagnosis_text)
      ..writeByte(9)
      ..write(obj.investigation_text)
      ..writeByte(10)
      ..write(obj.on_data)
      ..writeByte(11)
      ..write(obj.investigation_data)
      ..writeByte(12)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrescriptionTemplateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
