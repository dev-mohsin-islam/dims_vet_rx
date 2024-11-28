// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_print_layout_setting_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrescriptionPrintLayoutSettingModelAdapter
    extends TypeAdapter<PrescriptionPrintLayoutSettingModel> {
  @override
  final int typeId = 27;

  @override
  PrescriptionPrintLayoutSettingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrescriptionPrintLayoutSettingModel(
      id: fields[0] as int,
      uuid: fields[1] as String,
      u_status: fields[2] as int,
      page_width: fields[4] as double,
      page_height: fields[5] as double,
      font_size: fields[6] as double?,
      font_color: fields[7] as String,
      top_mergin: fields[8] as double,
      right_mergin: fields[9] as double,
      bottom_mergin: fields[10] as double,
      left_mergin: fields[11] as double,
      sidebar_width: fields[12] as double,
      header_height: fields[13] as double,
      header_full_conten: fields[14] as String,
      header_two_column_left: fields[15] as String?,
      header_two_column_right: fields[16] as String?,
      header_three_column_left: fields[17] as String?,
      header_three_column_center: fields[18] as String?,
      header_three_column_right: fields[19] as String?,
      footer_height: fields[20] as double,
      footer_content: fields[21] as String?,
      ph_font_color: fields[22] as String?,
      ph_background_color: fields[23] as String,
      header_image: fields[24] as Uint8List?,
      footer_image: fields[25] as Uint8List?,
      background_image: fields[26] as Uint8List?,
      web_id: fields[27] as int?,
      print_header_footer_or_none: fields[28] as String,
      clinicalDataMargin: fields[29] as double?,
      brandDataMargin: fields[30] as double?,
      rxDataStartingTopMargin: fields[31] as double?,
      clinicalDataStartingTopMargin: fields[32] as double?,
      marginBeforePatientName: fields[33] as double?,
      marginBeforePatientAge: fields[34] as double?,
      marginBeforePatientId: fields[35] as double?,
      marginBeforePatientGender: fields[36] as double?,
      marginBeforePatientDate: fields[37] as double?,
      clinicalDataPrintingPerPage: fields[38] as double?,
      brandDataPrintingPerPage: fields[39] as double?,
      clinicalAndBrandDataPerPageGap: fields[40] as double?,
      marginAroundFullPage: fields[41] as double?,
      date: fields[42] as DateTime?,
      font_size_pa_info: fields[43] as num?,
      digital_signature: fields[44] as Uint8List?,
      rx_icon: fields[45] as Uint8List?,
      chamber_id: fields[46] as int?,
      advice_gap: fields[47] as int?,
      marginLeftClinicalData: fields[48] as double?,
      marginRightClinicalData: fields[49] as double?,
      marginLeftBrandData: fields[50] as double?,
      marginRightBrandData: fields[51] as double?,
    )..user_id = fields[3] as int?;
  }

  @override
  void write(BinaryWriter writer, PrescriptionPrintLayoutSettingModel obj) {
    writer
      ..writeByte(52)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uuid)
      ..writeByte(2)
      ..write(obj.u_status)
      ..writeByte(3)
      ..write(obj.user_id)
      ..writeByte(4)
      ..write(obj.page_width)
      ..writeByte(5)
      ..write(obj.page_height)
      ..writeByte(6)
      ..write(obj.font_size)
      ..writeByte(7)
      ..write(obj.font_color)
      ..writeByte(8)
      ..write(obj.top_mergin)
      ..writeByte(9)
      ..write(obj.right_mergin)
      ..writeByte(10)
      ..write(obj.bottom_mergin)
      ..writeByte(11)
      ..write(obj.left_mergin)
      ..writeByte(12)
      ..write(obj.sidebar_width)
      ..writeByte(13)
      ..write(obj.header_height)
      ..writeByte(14)
      ..write(obj.header_full_conten)
      ..writeByte(15)
      ..write(obj.header_two_column_left)
      ..writeByte(16)
      ..write(obj.header_two_column_right)
      ..writeByte(17)
      ..write(obj.header_three_column_left)
      ..writeByte(18)
      ..write(obj.header_three_column_center)
      ..writeByte(19)
      ..write(obj.header_three_column_right)
      ..writeByte(20)
      ..write(obj.footer_height)
      ..writeByte(21)
      ..write(obj.footer_content)
      ..writeByte(22)
      ..write(obj.ph_font_color)
      ..writeByte(23)
      ..write(obj.ph_background_color)
      ..writeByte(24)
      ..write(obj.header_image)
      ..writeByte(25)
      ..write(obj.footer_image)
      ..writeByte(26)
      ..write(obj.background_image)
      ..writeByte(27)
      ..write(obj.web_id)
      ..writeByte(28)
      ..write(obj.print_header_footer_or_none)
      ..writeByte(29)
      ..write(obj.clinicalDataMargin)
      ..writeByte(30)
      ..write(obj.brandDataMargin)
      ..writeByte(31)
      ..write(obj.rxDataStartingTopMargin)
      ..writeByte(32)
      ..write(obj.clinicalDataStartingTopMargin)
      ..writeByte(33)
      ..write(obj.marginBeforePatientName)
      ..writeByte(34)
      ..write(obj.marginBeforePatientAge)
      ..writeByte(35)
      ..write(obj.marginBeforePatientId)
      ..writeByte(36)
      ..write(obj.marginBeforePatientGender)
      ..writeByte(37)
      ..write(obj.marginBeforePatientDate)
      ..writeByte(38)
      ..write(obj.clinicalDataPrintingPerPage)
      ..writeByte(39)
      ..write(obj.brandDataPrintingPerPage)
      ..writeByte(40)
      ..write(obj.clinicalAndBrandDataPerPageGap)
      ..writeByte(41)
      ..write(obj.marginAroundFullPage)
      ..writeByte(42)
      ..write(obj.date)
      ..writeByte(43)
      ..write(obj.font_size_pa_info)
      ..writeByte(44)
      ..write(obj.digital_signature)
      ..writeByte(45)
      ..write(obj.rx_icon)
      ..writeByte(46)
      ..write(obj.chamber_id)
      ..writeByte(47)
      ..write(obj.advice_gap)
      ..writeByte(48)
      ..write(obj.marginLeftClinicalData)
      ..writeByte(49)
      ..write(obj.marginRightClinicalData)
      ..writeByte(50)
      ..write(obj.marginLeftBrandData)
      ..writeByte(51)
      ..write(obj.marginRightBrandData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrescriptionPrintLayoutSettingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
