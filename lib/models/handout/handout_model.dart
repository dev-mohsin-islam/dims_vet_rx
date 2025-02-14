











import 'package:hive/hive.dart';
part 'handout_model.g.dart';

@HiveType(typeId: 39)
class HandoutModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  int? category_id;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;

  @HiveField(6)
  String? text;
  @HiveField(7)
  String? label;


  HandoutModel(
      {required this.id,
      this.category_id,
      this.text,
      this.label,
      this.uuid,
      this.date,
      this.u_status,
      this.web_id});
}