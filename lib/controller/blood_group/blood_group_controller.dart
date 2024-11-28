

import 'package:dims_vet_rx/models/blood_group/blood_group_model.dart';
import 'package:dims_vet_rx/models/improvement_type/improvement_type_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../database/crud_operations/common_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../utilities/default_value.dart';

class BloodGroupController extends GetxController{
  final CommonController commonController = CommonController();
  final Box<BloodGroupModel>box = Boxes.getBloodGroup();
  final RxList dataList =  [].obs;
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
    await commonController.saveCommon(box, BloodGroupModel(id: id, name: nameController.text.trim(), uuid: uuid, date: date, web_id: web_id, status: statusNewAdd));
    nameController.clear();
    getAllData('');
    // isLoading.value = false;
  }

  Future<void> updateData(id)async{
    await commonController.updateCommon(box, id, nameController.text.trim(), statusUpdate);
    nameController.clear();
    dataList.refresh();
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
    dataList.sort((a, b) => a.name[0].compareTo(b.name[0]));
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
    super.dispose();
    commonController;
    dataList;
    nameController.dispose();
    searchController.dispose();
    uuid;
    date;
    web_id;
    statusNewAdd;
    statusUpdate;
    statusDelete;
  }

}



