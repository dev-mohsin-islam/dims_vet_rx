

import 'package:hive/hive.dart';
part 'prescription_drug_model.g.dart';
@HiveType(typeId: 22)
class PrescriptionDrugModel extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  int u_status;

  @HiveField(2)
  int prescription_id;

  @HiveField(3)
  int generic_id;

  @HiveField(4)
  String strength;

  @HiveField(5)
  String doze;

  @HiveField(6)
  String duration;

  @HiveField(7)
  String? note;

  @HiveField(8)
  String uuid;

  @HiveField(9)
  int brand_id;

  @HiveField(10)
  String condition;

  @HiveField(11)
  int? web_id;

  @HiveField(12)
  int? company_id;

  @HiveField(13)
  String? date;


  @HiveField(14)
  String? chamber_id;



  PrescriptionDrugModel(
      {required this.id,
      required this.u_status,
      required this.prescription_id,
      required this.generic_id,
      required this.strength,
      required this.doze,
      required this.duration,
      this.note,
      required this.uuid,
      required this.brand_id,
      required this.condition,
      this.web_id,
      this.company_id,
      this.date,
        this.chamber_id
      });
}