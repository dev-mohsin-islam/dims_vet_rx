










import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'referral_short_model.g.dart';

@HiveType(typeId: 53)
class ReferralShortModel extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  String? uuid;

  @HiveField(2)
  String? date;

  @HiveField(3)
  int? web_id;

  @HiveField(4)
  String? details;

  @HiveField(5)
  String? name;

  @HiveField(6)
  int? u_status;




  ReferralShortModel({
    required this.id,
    this.uuid,
    this.date,
    this.web_id,
    this.name,
    this.details,
    this.u_status,

  });



}