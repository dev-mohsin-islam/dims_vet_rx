



import 'package:hive/hive.dart';
part 'patient_referral_model.g.dart';

@HiveType(typeId: 42)
class PatientReferralModel extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  String? app_id;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;

  @HiveField(6)
  int referred_to;

  @HiveField(7)
  String? special_notes;

  @HiveField(8)
  String? reason_for_referral;

  @HiveField(9)
  String? referred_by;

  @HiveField(10)
  String? clinical_information;

  @HiveField(11)
  String? referred_to_uuid;


  PatientReferralModel({
    required this.app_id,
    required this.id,
      this.uuid,
    this.date,
    this.u_status,
    this.web_id,
    required this.referred_to,
    this.special_notes,
    this.reason_for_referral,
    this.referred_by,
    this.clinical_information

  });

}