






import 'package:hive/hive.dart';
part 'pa_immunization_vaccines_option_model.g.dart';

@HiveType(typeId: 48)
class PaImmunizationVaccinesOptModel extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  String? uuid;

  @HiveField(2)
  String? date;

  @HiveField(3)
  int? u_status;

  @HiveField(4)
  int? web_id;

  @HiveField(5)
  String? group_name;

  @HiveField(6)
  String? recommended_age;

  @HiveField(7)
  String? dose_no;

  @HiveField(8)
  String? name;



  PaImmunizationVaccinesOptModel({
    required this.id,
    this.uuid,
    this.date,
    this.u_status,
    this.web_id,
     this.dose_no,
    this.group_name,
     this.name,
     this.recommended_age,

  });

}