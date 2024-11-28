

import 'package:hive/hive.dart';
part 'patient_history_model.g.dart';

@HiveType(typeId: 29)
class PatientHistoryModel extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  int patient_id;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;

  @HiveField(6)
  int history_id;

  @HiveField(7)
  String category;


  PatientHistoryModel({required this.id, required this.patient_id, required this.uuid, required this.date,  this.u_status, this.web_id, required this.history_id, required this.category});

}