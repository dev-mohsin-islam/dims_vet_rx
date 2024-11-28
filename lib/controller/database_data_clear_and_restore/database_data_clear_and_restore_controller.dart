


import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/models/drug_brand/drug_brand_model.dart';
import 'package:dims_vet_rx/models/drug_generic/drug_generic_model.dart';

import '../../database/hive_get_boxes.dart';
import '../sync_controller/json_to_db.dart';

class DbDataClearAndRestoreController extends GetxController{
  final Box<DrugBrandModel> boxDrug = Boxes.getDrugBrand();
  final Box<DrugGenericModel> boxGeneric = Boxes.getDrugGeneric();
  final InsertDataJsonToDb insertDataJsonToDbController = Get.put(InsertDataJsonToDb());

  // Future brandDataReStore()async{
  //   await insertDataJsonToDbController.insertDrugBrandData();
  // }
  // Future genericDataReStore()async{
  //   await insertDataJsonToDbController.insertDrugGenericData();
  // }

}