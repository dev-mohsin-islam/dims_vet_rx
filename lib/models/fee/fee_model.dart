






import 'package:hive/hive.dart';
part 'fee_model.g.dart';

@HiveType(typeId: 26)
class FeeModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  int fee;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;


  FeeModel({required this.id, required this.fee, this.uuid, this.date, this.u_status, this.web_id,});
}