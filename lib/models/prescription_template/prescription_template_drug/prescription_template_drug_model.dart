

import 'package:hive/hive.dart';
part 'prescription_template_drug_model.g.dart';
@HiveType(typeId: 34)
class PrescriptionTemplateDrugModel extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  int u_status;

  @HiveField(2)
  int template_id;


  @HiveField(3)
  String strength;

  @HiveField(4)
  String doze;

  @HiveField(5)
  String duration;

  @HiveField(6)
  String? note;

  @HiveField(7)
  String uuid;

  @HiveField(8)
  int brand_id;

  @HiveField(9)
  String condition;

  @HiveField(10)
  int generic_id;

  @HiveField(11)
  int? web_id;



  PrescriptionTemplateDrugModel(
      {required this.id,
      required this.u_status,
      required this.strength,
      required this.doze,
      required this.duration,
      this.note,
      required this.uuid,
      required this.brand_id,
      required this.condition,
      required this.template_id,
      required this.generic_id,
        this.web_id,
      });


}