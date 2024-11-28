






import 'package:hive/hive.dart';
part 'setting_pages_model.g.dart';

@HiveType(typeId: 30)
class SettingPagesModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String section;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;

  @HiveField(6)
  String label;


  SettingPagesModel({required this.id, required this.section, this.uuid, this.date, this.u_status, this.web_id, required this.label});
}