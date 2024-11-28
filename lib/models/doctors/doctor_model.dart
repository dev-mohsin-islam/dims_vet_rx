






import 'package:hive/hive.dart';
part 'doctor_model.g.dart';

@HiveType(typeId: 43)
class DoctorModel extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  String? address;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;

  @HiveField(6)
  String? phone;

  @HiveField(7)
  String? name;

  @HiveField(8)
  String? degree;

  @HiveField(9)
  String? designation;




  DoctorModel({
    required this.id,
    this.uuid,
    this.date,
    this.u_status,
    this.web_id,
    this.phone,
    this.name,
    this.degree,
    this.designation,
    this.address

  });

}