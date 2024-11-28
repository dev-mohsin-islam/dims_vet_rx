

import 'package:hive/hive.dart';
part 'history_model.g.dart';
@HiveType(typeId: 28)
class HistoryModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;

  @HiveField(6)
  String category;

  @HiveField(7)
  String type;

  HistoryModel(
      {required this.id,
      required this.name,
      required this.uuid,
      this.date,
      this.u_status,
      this.web_id,
      required this.category,
      required this.type,
      });
}