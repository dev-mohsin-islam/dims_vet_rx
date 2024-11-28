// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drug_brand_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DrugBrandModelAdapter extends TypeAdapter<DrugBrandModel> {
  @override
  final int typeId = 18;

  @override
  DrugBrandModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DrugBrandModel(
      id: fields[0] as int,
      brand_name: fields[1] as String,
      uuid: fields[2] as String?,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
      generic_id: fields[6] as int,
      company_id: fields[7] as int,
      form: fields[8] as String,
      strength: fields[9] as String,
      dimsid: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DrugBrandModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.brand_name)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.u_status)
      ..writeByte(5)
      ..write(obj.web_id)
      ..writeByte(6)
      ..write(obj.generic_id)
      ..writeByte(7)
      ..write(obj.company_id)
      ..writeByte(8)
      ..write(obj.form)
      ..writeByte(9)
      ..write(obj.strength)
      ..writeByte(10)
      ..write(obj.dimsid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrugBrandModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
