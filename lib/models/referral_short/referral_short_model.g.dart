// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_short_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReferralShortModelAdapter extends TypeAdapter<ReferralShortModel> {
  @override
  final int typeId = 53;

  @override
  ReferralShortModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReferralShortModel(
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
  void write(BinaryWriter writer, ReferralShortModel obj) {
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
      other is ReferralShortModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
