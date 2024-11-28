// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money_receipt_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoneyReceiptModelAdapter extends TypeAdapter<MoneyReceiptModel> {
  @override
  final int typeId = 44;

  @override
  MoneyReceiptModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoneyReceiptModel(
      app_id: fields[1] as int,
      id: fields[0] as int,
      uuid: fields[2] as String?,
      date: fields[3] as String?,
      u_status: fields[4] as int?,
      web_id: fields[5] as int?,
      invoice_id: fields[6] as int?,
      fee: fields[7] as String?,
      description: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MoneyReceiptModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.app_id)
      ..writeByte(2)
      ..write(obj.uuid)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.u_status)
      ..writeByte(5)
      ..write(obj.web_id)
      ..writeByte(6)
      ..write(obj.invoice_id)
      ..writeByte(7)
      ..write(obj.fee)
      ..writeByte(8)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoneyReceiptModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
