








import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'user_info_model.g.dart';

@HiveType(typeId: 49)
class UserInfoModel extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  String? uuid;

  @HiveField(2)
  String? date;

  @HiveField(3)
  int? type;

  @HiveField(4)
  int? web_id;

  @HiveField(5)
  String? details;

  @HiveField(6)
  int? identifier;

  @HiveField(7)
  String? token;

  @HiveField(8)
  String? name;

  @HiveField(9)
  String? phone;

  @HiveField(10)
  Uint8List? profile_image;

  @HiveField(11)
  String? speciality;



  UserInfoModel({
    required this.id,
    this.uuid,
    this.date,
    this.web_id,
    this.name,
    this.phone,
    this.profile_image,
    this.identifier,
    this.type,
    this.token,
    this.details,
    this.speciality

  });



}