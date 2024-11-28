





import 'package:hive/hive.dart';
part 'money_receipt_model.g.dart';

@HiveType(typeId: 44)
class MoneyReceiptModel extends HiveObject{

  @HiveField(0)
  int id;

  @HiveField(1)
  int app_id;

  @HiveField(2)
  String? uuid;

  @HiveField(3)
  String? date;

  @HiveField(4)
  int? u_status;

  @HiveField(5)
  int? web_id;

  @HiveField(6)
  int? invoice_id;

  @HiveField(7)
  String? fee;

  @HiveField(8)
  String? description;



  MoneyReceiptModel({
    required this.app_id,
    required this.id,
    this.uuid,
    this.date,
    this.u_status,
    this.web_id,
    this.invoice_id,
    this.fee,
    this.description,

  });



}