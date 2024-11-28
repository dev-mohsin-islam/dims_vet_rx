

import 'package:hive/hive.dart';
part 'prescription_template_drug_dose_model.g.dart';
@HiveType(typeId: 35)
class PrescriptionTemplateDrugDoseModel extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  int u_status;

  @HiveField(2)
  int generic_id;

  @HiveField(3)
  String condition;

  @HiveField(4)
  String doze;

  @HiveField(5)
  String duration;

  @HiveField(6)
  String? note;

  @HiveField(7)
  String uuid;

  @HiveField(8)
  int drug_id;

  @HiveField(9)
  int? dose_serial;

  @HiveField(10)
  int template_id;



  PrescriptionTemplateDrugDoseModel(
      {
        required this.id,
        required this.u_status,
        required this.generic_id,
        required this.doze,
        required this.duration,
        this.note,
        required this.uuid,
        required this.drug_id,
        required this.condition,
        this.dose_serial,
        required this.template_id
      });
}