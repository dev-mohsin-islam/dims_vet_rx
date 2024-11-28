

import 'package:hive/hive.dart';
part 'prescription_procedure_model.g.dart';
@HiveType(typeId: 36)
class PrescriptionProcedureModel extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  int u_status;

  @HiveField(2)
  int prescription_id;

  @HiveField(3)
  int procedure_id;

  @HiveField(4)
  String? diagnosis;

  @HiveField(5)
  String? anesthesia;

  @HiveField(6)
  String? incision;

  @HiveField(7)
  String? surgeon;

  @HiveField(8)
  String uuid;

  @HiveField(9)
  String? assistant;

  @HiveField(10)
  String? details;

  @HiveField(11)
  String? prosthesis;

  @HiveField(12)
  String? closer;

  @HiveField(13)
  String? findings;

  @HiveField(14)
  String? complications;

  @HiveField(15)
  String? drains;

  @HiveField(16)
  String? post_operative_instructions;

  @HiveField(17)
  String? procedure_name;



  PrescriptionProcedureModel(
      {
        required this.id,
        required this.u_status,
        required this.prescription_id,
        required this.procedure_id,
         this.diagnosis,
         this.anesthesia,
        this.incision,
        this.surgeon,
        required this.uuid,
        this.assistant,
        this.details,
        this.prosthesis,
        this.closer,
        this.findings,
        this.complications,
        this.drains,
        this.post_operative_instructions,
        this.procedure_name,

      });


}