// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investigation_report_image_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvestigationReportImageModelAdapter
    extends TypeAdapter<InvestigationReportImageModel> {
  @override
  final int typeId = 37;

  @override
  InvestigationReportImageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvestigationReportImageModel(
      id: fields[0] as int,
      inv_name: fields[1] as String,
      uuid: fields[2] as String?,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
      app_id: fields[6] as int,
      url: fields[7] as Uint8List,
      title: fields[8] as String?,
      details: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, InvestigationReportImageModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.inv_name)
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
      other is InvestigationReportImageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
