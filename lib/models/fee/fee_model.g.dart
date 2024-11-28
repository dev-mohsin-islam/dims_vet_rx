// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeeModelAdapter extends TypeAdapter<FeeModel> {
  @override
  final int typeId = 26;

  @override
  FeeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FeeModel(
      id: fields[0] as int,
      fee: fields[1] as int,
      uuid: fields[2] as String?,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, FeeModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fee)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.u_status)
      ..writeByte(5)
      ..write(obj.web_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
