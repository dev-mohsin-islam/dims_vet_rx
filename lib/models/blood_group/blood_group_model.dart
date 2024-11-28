










import 'package:hive/hive.dart';
part 'blood_group_model.g.dart';

@HiveType(typeId: 17)
class BloodGroupModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? status;

  @HiveField(5)
  int? web_id;


  BloodGroupModel({required this.id, required this.name, this.uuid, this.date, this.status, this.web_id,});
}