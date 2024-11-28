






import 'package:hive/hive.dart';
part 'pa_immunization_vaccines_model.g.dart';

@HiveType(typeId: 47)
class PaImmunizationVaccinesModel extends HiveObject{

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
  String? recommended_age;

  @HiveField(6)
  String? dose_no;

  @HiveField(7)
  int? parent;

  @HiveField(8)
  String? name;



  PaImmunizationVaccinesModel({
    required this.id,
    this.uuid,
    this.date,
    this.u_status,
    this.web_id,
     this.dose_no,
    this.parent,
     this.name,

  });

}