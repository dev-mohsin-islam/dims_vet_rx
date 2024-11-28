





import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'patient_disease_image_model.g.dart';

@HiveType(typeId: 38)
class PatientDiseaseImageModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String disease_name;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;

  @HiveField(6)
  int app_id;

  @HiveField(7)
  Uint8List url;

  @HiveField(8)
  String? title;

  @HiveField(9)
  String? details;




  PatientDiseaseImageModel({required this.id,  this.uuid, this.date, this.u_status, this.web_id, required this.app_id, required this.url, this.title, this.details, required this.disease_name});
}