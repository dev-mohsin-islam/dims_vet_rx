

import 'package:hive/hive.dart';
part 'patient_certificate_model.g.dart';

@HiveType(typeId: 40)
class PatientCertificateModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String? appointment_id;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;

  @HiveField(6)
  String? guardian_name;

  @HiveField(7)
  String? diagnosis;

  @HiveField(8)
  String? form;

  @HiveField(9)
  String? to;

  @HiveField(10)
  String? type;

  @HiveField(11)
  String? duration;

  @HiveField(12)
  String? got_to;

  @HiveField(13)
  String? is_continue;

  @HiveField(14)
  int? guardian_sex;




  PatientCertificateModel(
      {required this.id,
        this.appointment_id,
        this.guardian_name,
        this.guardian_sex,
        this.uuid,
        this.date,
        this.u_status,
        this.web_id,
        this.diagnosis,
        this.form,
        this.to,
        this.type,
        this.duration,
        this.got_to,
        this.is_continue
      });
}