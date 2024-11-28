







import 'package:dims_vet_rx/models/drug_generic/drug_generic_model.dart';
import 'package:dims_vet_rx/models/procedure/procedure_model.dart';
import 'package:dims_vet_rx/models/strength/strength_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../database/crud_operations/generic_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../utilities/default_value.dart';

class DrugGenericController extends GetxController{
  final GenericCrudController genericCrudController = GenericCrudController();
  final Box<DrugGenericModel>box = Boxes.getDrugGeneric();
  final TextEditingController nameController= TextEditingController();
  final TextEditingController searchController= TextEditingController();


  final RxList dataList =  [].obs;

  RxBool isLoading = true.obs;
  RxBool isSearch = false.obs;

  final uuid = DefaultValues.defaultUuid;
  final date = DefaultValues.defaultDate;
  final web_id = DefaultValues.defaultweb_id;
  final statusNewAdd = DefaultValues.NewAdd;
  final statusUpdate = DefaultValues.Update;
  final statusDelete = DefaultValues.Delete;


  void addData(id)async{
    try {
      if(nameController.text.trim().isNotEmpty){
        await genericCrudController.saveGeneric(box, DrugGenericModel(id: id, generic_name: nameController.text.trim(), uuid: uuid, date: date, web_id: web_id, u_status: statusNewAdd,));
        nameController.clear();
        await getAllData('');
      }
    }catch(e){
      print(e);
    }
    // isLoading.value = false;
  }

  Future<void> updateData(id)async{
   try {
     if(nameController.text.trim().isNotEmpty){
       await genericCrudController.updateGeneric(box, id, nameController.text.trim(), statusUpdate);
       nameController.clear();
       await getAllData('');
     }
   }catch(e){
     print(e);
   }
    // isLoading.value = false;

  }

  Future<void> deleteData(id)async{

    try {
      await genericCrudController.deleteCommon(box, id, statusDelete);
      await getAllData('');
    } catch (e) {
      // Handle the exception
      if (kDebugMode) {
        print("Error deleting data: $e");
      }
    }
    // isLoading = false;
  }

  Future<void> getAllData(String searchText)async{
    try {
      isLoading.value = true;
      var response = await genericCrudController.getAllDataGeneric(box, searchText);
      dataList.clear();
      dataList.addAll(response);
      dataList.sort((a, b) => a.generic_name[0].compareTo(b.generic_name[0]));
      isLoading.value = false;
    }catch(e){
      print(e);
    }
  }


  clearText()async{
    dataList.clear();
    nameController.clear();
    searchController.clear();
    await getAllData('');
  }


  @override
  void onInit() {
    // TODO: implement onInit
    getAllData('');
    super.onInit();
  }

  @override
  void dispose() {
    getAllData('');
    dataList;
    nameController;
    searchController;
    uuid;
    date;
    web_id;
    statusNewAdd;
    statusUpdate;
    statusDelete;
    super.dispose();
  }

}



