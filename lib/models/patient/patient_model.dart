






import 'package:hive/hive.dart';
part 'patient_model.g.dart';

@HiveType(typeId: 19)
class PatientModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int u_status;

  @HiveField(5)
  int? web_id;

  @HiveField(6)
  String? dob;

  @HiveField(7)
  int? sex;

  @HiveField(8)
  int? marital_status;

  @HiveField(9)
  String? guardian_name;

  @HiveField(10)
  String? phone;

  @HiveField(11)
  String? email;

  @HiveField(12)
  String? area;

  @HiveField(13)
  String? occupation;

  @HiveField(14)
  String? education;

  @HiveField(15)
  int? blood_group;

  @HiveField(16)
  String? blood_group_new;

  @HiveField(17)
  num? ageHours;

  @HiveField(18)
  num? ageMin;
  @HiveField(19)
  num? ageDays;

  @HiveField(20)
  String? chamber_id;

  @HiveField(21)
  String? p_type;


  PatientModel({
    required this.id,
    required this.name,
    required this.uuid,
    this.date, required
    this.u_status,
    this.web_id,
    required this.dob,
    required this.sex,
    required this.marital_status,
    this.guardian_name,
    this.phone,
    this.email,
    this.area,
    this.occupation,
    this.education,
    this.blood_group,
    this.blood_group_new,
    this.ageHours,
    this.ageMin,
    this.ageDays,
    this.chamber_id,
    this.p_type
  });
}