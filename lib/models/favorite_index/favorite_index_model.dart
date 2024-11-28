






import 'package:hive/hive.dart';
part 'favorite_index_model.g.dart';

@HiveType(typeId: 31)
class FavoriteIndexModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String segment;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;

  @HiveField(6)
  int favorite_id;



  FavoriteIndexModel({required this.id, required this.segment, this.uuid, this.date, this.u_status, this.web_id, required this.favorite_id,});
}