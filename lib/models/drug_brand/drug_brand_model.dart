











import 'package:get/get_connect/http/src/request/request.dart';
import 'package:hive/hive.dart';
part 'drug_brand_model.g.dart';

@HiveType(typeId: 18)
class DrugBrandModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String brand_name;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;

  @HiveField(6)
  int generic_id;

  @HiveField(7)
  int company_id;

  @HiveField(8)
  String form;

  @HiveField(9)
  String strength;

  @HiveField(10)
  int? dimsid;


  DrugBrandModel({required this.id, required this.brand_name, this.uuid, this.date, this.u_status, this.web_id, required this.generic_id, required this.company_id, required this.form, required this.strength, this.dimsid});
}