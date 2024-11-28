






import 'package:hive/hive.dart';
part 'dose_model.g.dart';

@HiveType(typeId: 12)
class DoseModel extends HiveObject{
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


  DoseModel({required this.id, required this.name, this.uuid, this.date, this.u_status, this.web_id,});
}