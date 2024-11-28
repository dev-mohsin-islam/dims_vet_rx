





import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'investigation_report_image_model.g.dart';

@HiveType(typeId: 37)
class InvestigationReportImageModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String inv_name;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;

  @HiveField(6)
  int app_id;

  @HiveField(7)
  Uint8List url;

  @HiveField(8)
  String? title;

  @HiveField(9)
  String? details;


  InvestigationReportImageModel({required this.id, required this.inv_name, this.uuid, this.date, this.u_status, this.web_id, required this.app_id, required this.url, this.title, this.details,});
}