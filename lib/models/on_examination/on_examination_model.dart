


import 'package:hive/hive.dart';
part 'on_examination_model.g.dart';

@HiveType(typeId: 3)
class OnExaminationModel extends HiveObject{
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

  @HiveField(6)
  int? category;

  OnExaminationModel({required this.id, required this.name, this.uuid, this.date, this.u_status, this.web_id, this.category});
}