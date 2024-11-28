// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_disease_image_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientDiseaseImageModelAdapter
    extends TypeAdapter<PatientDiseaseImageModel> {
  @override
  final int typeId = 38;

  @override
  PatientDiseaseImageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PatientDiseaseImageModel(
      id: fields[0] as int,
      uuid: fields[2] as String?,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
      app_id: fields[6] as int,
      url: fields[7] as Uint8List,
      title: fields[8] as String?,
      details: fields[9] as String?,
      disease_name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PatientDiseaseImageModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.disease_name)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.u_status)
      ..writeByte(5)
      ..write(obj.web_id)
      ..writeByte(6)
      ..write(obj.app_id)
      ..writeByte(7)
      ..write(obj.url)
      ..writeByte(8)
      ..write(obj.title)
      ..writeByte(9)
      ..write(obj.details);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientDiseaseImageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
