





import 'package:hive/hive.dart';
part 'investigation_report_model.g.dart';

@HiveType(typeId: 6)
class InvestigationReportModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;


  InvestigationReportModel({required this.id, required this.name, this.uuid, this.date, this.u_status, this.web_id,});
}