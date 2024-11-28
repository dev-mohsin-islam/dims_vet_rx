





import 'package:hive/hive.dart';
part 'diagnosis_modal.g.dart';

@HiveType(typeId: 5)
class DiagnosisModal extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;


  DiagnosisModal({required this.id, required this.name, this.uuid, this.date, this.u_status, this.web_id,});
}