// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'physician_notes_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhysicianNoteModelAdapter extends TypeAdapter<PhysicianNoteModel> {
  @override
  final int typeId = 52;

  @override
  PhysicianNoteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhysicianNoteModel(
      id: fields[0] as int,
      uuid: fields[1] as String?,
      date: fields[2] as String?,
      web_id: fields[3] as int?,
      name: fields[5] as String?,
      details: fields[4] as String?,
      u_status: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PhysicianNoteModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.web_id)
      ..writeByte(4)
      ..write(obj.details)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.u_status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhysicianNoteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
