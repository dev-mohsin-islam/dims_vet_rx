






import 'package:hive/hive.dart';
part 'drug_generic_model.g.dart';

@HiveType(typeId: 10)
class DrugGenericModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String generic_name;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;


  @HiveField(6)
  int? dimsid;


  DrugGenericModel({required this.id, required this.generic_name, this.uuid, this.date, this.u_status, this.web_id, this.dimsid});
}