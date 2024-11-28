











import 'package:hive/hive.dart';
part 'advice_model.g.dart';

@HiveType(typeId: 25)
class AdviceModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String label;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;

  @HiveField(6)
  String text;


  AdviceModel({required this.id, required this.label, this.uuid, this.date, this.u_status, this.web_id, required this.text,});
}