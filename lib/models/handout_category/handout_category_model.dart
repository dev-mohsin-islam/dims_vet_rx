











import 'package:hive/hive.dart';
part 'handout_category_model.g.dart';

@HiveType(typeId: 15)
class HandoutCategoryModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String category_name;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;


  HandoutCategoryModel({required this.id, required this.category_name, this.uuid, this.date, this.u_status, this.web_id,});
}