










import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'prescription_print_layout_setting_model.g.dart';

@HiveType(typeId: 27)
class PrescriptionPrintLayoutSettingModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String uuid;

  @HiveField(2)
  int u_status;

  @HiveField(3)
  int? user_id;

  @HiveField(4)
  double page_width;

  @HiveField(5)
  double page_height;

  @HiveField(6)
  double? font_size;

  @HiveField(7)
  String font_color;

  @HiveField(8)
  double top_mergin;

  @HiveField(9)
  double right_mergin;

  @HiveField(10)
  double bottom_mergin;

  @HiveField(11)
  double left_mergin;

  @HiveField(12)
  double sidebar_width;

  @HiveField(13)
  double header_height;

  @HiveField(14)
  String header_full_conten;

  @HiveField(15)
  String? header_two_column_left;

  @HiveField(16)
  String? header_two_column_right;

  @HiveField(17)
  String? header_three_column_left;

  @HiveField(18)
  String? header_three_column_center;

  @HiveField(19)
  String? header_three_column_right;

  @HiveField(20)
  double footer_height;

  @HiveField(21)
  String? footer_content;

  @HiveField(22)
  String? ph_font_color;

  @HiveField(23)
  String ph_background_color;

  @HiveField(24)
   Uint8List? header_image;

  @HiveField(25)
   Uint8List? footer_image;

  @HiveField(26)
   Uint8List? background_image;

  @HiveField(27)
  int? web_id;

  @HiveField(28)
  String print_header_footer_or_none;

  @HiveField(29)
  double? clinicalDataMargin;

  @HiveField(30)
  double? brandDataMargin;

  @HiveField(31)
  double? rxDataStartingTopMargin;

  @HiveField(32)
  double? clinicalDataStartingTopMargin;

  @HiveField(33)
  double? marginBeforePatientName;

  @HiveField(34)
  double? marginBeforePatientAge;

  @HiveField(35)
  double? marginBeforePatientId;

  @HiveField(36)
  double? marginBeforePatientGender;

  @HiveField(37)
  double? marginBeforePatientDate;

  @HiveField(38)
  double? clinicalDataPrintingPerPage;

  @HiveField(39)
  double? brandDataPrintingPerPage;

  @HiveField(40)
  double? clinicalAndBrandDataPerPageGap;

  @HiveField(41)
  double? marginAroundFullPage;
  @HiveField(42)
  DateTime? date;

  @HiveField(43)
  num? font_size_pa_info;

  @HiveField(44)
  Uint8List? digital_signature;

  @HiveField(45)
  Uint8List? rx_icon;

  @HiveField(46)
  int? chamber_id;

  @HiveField(47)
  int? advice_gap;

  @HiveField(48)
  double? marginLeftClinicalData;

  @HiveField(49)
  double? marginRightClinicalData;

  @HiveField(50)
  double? marginLeftBrandData;

  @HiveField(51)
  double? marginRightBrandData;







  PrescriptionPrintLayoutSettingModel({
    required this.id,
    required this.uuid,
    required this.u_status,
    required this.page_width,
    required this.page_height,
    this.font_size,
    required this.font_color,
    required this.top_mergin,
    required this.right_mergin,
    required this.bottom_mergin,
    required this.left_mergin,
    required this.sidebar_width,
    required this.header_height,
    required this.header_full_conten,
    this.header_two_column_left,
    this.header_two_column_right,
    this.header_three_column_left,
    this.header_three_column_center,
    this.header_three_column_right,
    required this.footer_height,
    this.footer_content,
    this.ph_font_color,
    required this.ph_background_color,
    this.header_image,
    this.footer_image,
    this.background_image,
    this.web_id,
    required this.print_header_footer_or_none,
    this.clinicalDataMargin,
    this.brandDataMargin,
    this.rxDataStartingTopMargin,
    this.clinicalDataStartingTopMargin,
    this.marginBeforePatientName,
    this.marginBeforePatientAge,
    this.marginBeforePatientId,
    this.marginBeforePatientGender,
    required this.marginBeforePatientDate,
    required this.clinicalDataPrintingPerPage,
    required this.brandDataPrintingPerPage,
    this.clinicalAndBrandDataPerPageGap,
    this.marginAroundFullPage,
    this.date,
    this.font_size_pa_info,
    this.digital_signature,
    this.rx_icon,
    this.chamber_id,
    this.advice_gap,
    this.marginLeftClinicalData,
    this.marginRightClinicalData,
    this.marginLeftBrandData,
    this.marginRightBrandData,

  });
}