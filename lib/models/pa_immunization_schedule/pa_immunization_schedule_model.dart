





import 'package:hive/hive.dart';
part 'pa_immunization_schedule_model.g.dart';

@HiveType(typeId: 45)
class PaImmunizationScheduleModel extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  String? pa_id;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;

  @HiveField(6)
  int vaccines_id;

  @HiveField(7)
  String? given_date;

  @HiveField(8)
  String? note;



  PaImmunizationScheduleModel({
    required this.pa_id,
    required this.id,
    this.uuid,
    this.date,
    this.u_status,
    this.web_id,
    required this.given_date,
    this.note,
    required this.vaccines_id,

  });

}