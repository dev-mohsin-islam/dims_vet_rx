// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInfoModelAdapter extends TypeAdapter<UserInfoModel> {
  @override
  final int typeId = 49;

  @override
  UserInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInfoModel(
      id: fields[0] as int,
      uuid: fields[1] as String?,
      date: fields[2] as String?,
      web_id: fields[4] as int?,
      name: fields[8] as String?,
      phone: fields[9] as String?,
      profile_image: fields[10] as Uint8List?,
      identifier: fields[6] as int?,
      type: fields[3] as int?,
      token: fields[7] as String?,
      details: fields[5] as String?,
      speciality: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserInfoModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.web_id)
      ..writeByte(5)
      ..write(obj.details)
      ..writeByte(6)
      ..write(obj.identifier)
      ..writeByte(7)
      ..write(obj.token)
      ..writeByte(8)
      ..write(obj.name)
      ..writeByte(9)
      ..write(obj.phone)
      ..writeByte(10)
      ..write(obj.profile_image)
      ..writeByte(11)
      ..write(obj.speciality);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
