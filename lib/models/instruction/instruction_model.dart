







import 'package:hive/hive.dart';
part 'instruction_model.g.dart';

@HiveType(typeId: 13)
class InstructionModel extends HiveObject{
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


  InstructionModel({required this.id, required this.name, this.uuid, this.date, this.u_status, this.web_id,});
}