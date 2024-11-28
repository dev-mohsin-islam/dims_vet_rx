



import 'package:hive/hive.dart';
part 'prescription_handout_model.g.dart';

@HiveType(typeId: 23)
class PrescriptionHandoutModel extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  int u_status;

  @HiveField(2)
  int? web_id;

  @HiveField(3)
  String uuid;

  @HiveField(4)
  int prescription_id;

  @HiveField(5)
  String handout;


  PrescriptionHandoutModel(
      {required this.id,
      this.web_id,
      required this.u_status,
      required this.uuid,
      required this.prescription_id,
      required this.handout});


}