

import 'package:hive/hive.dart';
part 'prescription_model.g.dart';
@HiveType(typeId: 21)
class PrescriptionModel extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  int? web_id;

  @HiveField(2)
  int u_status;

  @HiveField(3)
  int appointment_id;

  @HiveField(4)
  String? note;

  @HiveField(5)
  String? physical_findings;

  @HiveField(6)
  String uuid;

  @HiveField(7)
  String? cc_text;

  @HiveField(8)
  String? diagnosis_text;

  @HiveField(9)
  String? investigation_text;

  @HiveField(10)
  String? onexam_text;

  @HiveField(11)
  String? investigation_report_text;

  @HiveField(12)
  String? date;

  @HiveField(13)
  String? chamber_id;

  @HiveField(14)
  String? special_notes;

  @HiveField(15)
  String? treatment_plan;

  @HiveField(16)
  String? referral_short;


      PrescriptionModel({
        required this.id,
        this.web_id,
        required this.u_status,
        required this.appointment_id,
        this.note,
        this.physical_findings,
        required this.uuid,
        this.cc_text,
        this.diagnosis_text,
        this.investigation_text,
        this.onexam_text,
        this.investigation_report_text,
        required this.date,
        this.chamber_id,
        this.special_notes,
        this.treatment_plan,
        this.referral_short
      });

      }