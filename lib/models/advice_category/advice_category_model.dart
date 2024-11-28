

import 'package:hive/hive.dart';
part 'advice_category_model.g.dart';

@HiveType(typeId: 14)
class AdviceCategoryModel extends HiveObject{
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


  AdviceCategoryModel({required this.id, required this.name, this.uuid, this.date, this.status, this.web_id,});
}