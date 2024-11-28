

import 'package:hive/hive.dart';
part 'chamber_model.g.dart';

@HiveType(typeId: 41)
class ChamberModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String? chamber_name;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;

  @HiveField(6)
  String? chamber_address;

  @HiveField(7)
  String? npl_code;




  ChamberModel(
      {required this.id,
        this.chamber_name,
        this.chamber_address,
        this.npl_code,
        this.uuid,
        this.date,
        this.u_status,
        this.web_id,

      });
}