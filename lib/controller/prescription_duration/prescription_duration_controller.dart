
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../database/crud_operations/common_crud.dart';
import '../../../database/hive_get_boxes.dart';
import '../../../models/create_prescription/prescription_duration/prescription_duration_model.dart';
import '../../../utilities/default_value.dart';
import '../../../utilities/helpers.dart';

class DurationController extends GetxController{
  final CommonController commonController = CommonController();
  final Box<PrescriptionDurationModel>box = Boxes.getDuration();
  late RxList dataList =  [].obs;
  final TextEditingController nameController= TextEditingController();


  final TextEditingController searchController= TextEditingController();
  RxBool isLoading = true.obs;

  final uuid = DefaultValues.defaultUuid;
  final date = DefaultValues.defaultDate;
  final web_id = DefaultValues.defaultweb_id;
  final statusNewAdd = DefaultValues.NewAdd;
  final statusUpdate = DefaultValues.Update;
  final statusDelete = DefaultValues.Delete;


  void addData(id)async{
     if(nameController.text.trim().isNotEmpty){
       await commonController.saveCommon(box, PrescriptionDurationModel(id: id, u_status: statusNewAdd, web_id: web_id, uuid: uuid, name: nameController.text.trim(), number: 0, type: ''));
       nameController.clear();
       getAllData('');
     }

    // isLoading.value = false;
  }

  Future<void> updateData(id)async{
    if(nameController.text.trim().isNotEmpty){
      await commonController.updateCommon(box, id, nameController.text.trim(), statusUpdate);
      nameController.clear();
      dataList.refresh();
    }else{
      Helpers.errorSnackBar("Failed", "Field can't be empty");
    }

    // isLoading.value = false;

  }

  Future<void> deleteData(id)async{

    try {
      await commonController.deleteCommon(box, id, statusDelete);
      getAllData('');
    } catch (e) {
      // Handle the exception
      if (kDebugMode) {
        print("Error deleting data: $e");
      }
    }
    // isLoading = false;
  }

  Future<void> getAllData(String searchText)async{
    isLoading.value = true;
    var response = await commonController.getAllDataCommon(box, searchText);
    dataList.clear();
    dataList.addAll(response);
    isLoading.value = false;
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
    isLoading;
    super.dispose();
  }

}



