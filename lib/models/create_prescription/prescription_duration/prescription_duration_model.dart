





import 'package:hive/hive.dart';
part 'prescription_duration_model.g.dart';

@HiveType(typeId: 24)
class PrescriptionDurationModel extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  int u_status;

  @HiveField(2)
  int? web_id;

  @HiveField(3)
  String uuid;

  @HiveField(4)
  String name;

  @HiveField(5)
  int number;

  @HiveField(6)
  String type;


  PrescriptionDurationModel(
      {required this.id,
        this.web_id,
        required this.u_status,
        required this.uuid,
        required this.name,
        required this.number,
        required this.type

      });


}