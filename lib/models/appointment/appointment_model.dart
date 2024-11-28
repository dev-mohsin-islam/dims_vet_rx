
import 'package:hive/hive.dart';
part 'appointment_model.g.dart';

@HiveType(typeId: 20)
class AppointmentModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String uuid;

  @HiveField(2)
  int u_status;

  @HiveField(3)
  int? web_id;

  @HiveField(4)
  int patient_id;

  @HiveField(5)
  String date;

  @HiveField(6)
  String? next_visit;

  @HiveField(7)
  int appointed_by;

  @HiveField(8)
  int appointed_to;

  @HiveField(9)
  int? pulse;

  @HiveField(10)
  int? sys_blood_pressure;

  @HiveField(11)
  int? dys_blood_pressure;

  @HiveField(12)
  String? temparature;

  @HiveField(13)
  double? weight;

  @HiveField(14)
  double? height;

  @HiveField(15)
  double? OFC;

  @HiveField(16)
  double? waist;

  @HiveField(17)
  double? hip;

  @HiveField(18)
  int? rr;

  @HiveField(19)
  String? complain;

  @HiveField(20)
  String? medicine;

  @HiveField(21)
  int? improvement;

  @HiveField(22)
  int? fee;

  @HiveField(23)
  int status;

  @HiveField(24)
  int? report_patient;

  @HiveField(25)
  int? serial;

  @HiveField(26)
  String? chamber_id;

  @HiveField(27)
  String? hospital_id;

  @HiveField(28)
  String? patient_hospital_reg_id;

  @HiveField(29)
  String? ward_no;

  @HiveField(30)
  String? bed_no;

  @HiveField(31)
  String? cabin_no;

  @HiveField(32)
  String? room_no;

  @HiveField(33)
  String? is_pregnant;



  AppointmentModel({
    required this.id,
    required this.uuid,
    required this.u_status,
    this.web_id,
    required this.patient_id,
    required this.date,
    this.next_visit,
    required this.appointed_by,
    required this.appointed_to,
    this.pulse,
    this.sys_blood_pressure,
    this.dys_blood_pressure,
    this.temparature,
    this.weight,
    this.height,
    this.OFC,
    this.waist,
    this.hip,
    this.rr,
    this.complain,
    this.medicine,
    this.improvement,
    this.fee,
    required this.status,
    this.report_patient,
    this.serial,
    this.chamber_id,
    this.hospital_id,
    this.patient_hospital_reg_id,
    this.ward_no,
    this.bed_no,
    this.cabin_no,
    this.room_no,
    this.is_pregnant
  });
}