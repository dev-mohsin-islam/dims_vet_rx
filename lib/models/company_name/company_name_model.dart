






import 'package:hive/hive.dart';
part 'company_name_model.g.dart';

@HiveType(typeId: 11)
class CompanyNameModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String company_name;

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


  CompanyNameModel({required this.id, required this.company_name, this.uuid, this.date, this.u_status, this.web_id, this.dimsid});
}