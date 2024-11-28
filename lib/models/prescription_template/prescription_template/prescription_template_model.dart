

import 'package:hive/hive.dart';
part 'prescription_template_model.g.dart';
@HiveType(typeId: 33)
class PrescriptionTemplateModel extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  int? web_id;

  @HiveField(2)
  int u_status;

  @HiveField(3)
  String template_name;

  @HiveField(4)
  String? note;

  @HiveField(5)
  int user_id;

  @HiveField(6)
  String uuid;

  @HiveField(7)
  String? cc_data;

  @HiveField(8)
  String? diagnosis_text;

  @HiveField(9)
  String? investigation_text;

  @HiveField(10)
  String? on_data;

  @HiveField(11)
  String? investigation_data;

  @HiveField(12)
  String? date;


  PrescriptionTemplateModel({
    required this.id,
    this.web_id,
    required this.u_status,
    required this.template_name,
    this.note,
    required this.user_id,
    required this.uuid,
    this.cc_data,
    this.diagnosis_text,
    this.investigation_text,
    this.on_data,
    this.investigation_data,
    this.date
  });

}