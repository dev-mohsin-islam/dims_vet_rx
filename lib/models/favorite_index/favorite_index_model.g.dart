// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_index_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteIndexModelAdapter extends TypeAdapter<FavoriteIndexModel> {
  @override
  final int typeId = 31;

  @override
  FavoriteIndexModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteIndexModel(
      id: fields[0] as int,
      segment: fields[1] as String,
      uuid: fields[2] as String?,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
      favorite_id: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteIndexModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.segment)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.u_status)
      ..writeByte(5)
      ..write(obj.web_id)
      ..writeByte(6)
      ..write(obj.favorite_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteIndexModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
