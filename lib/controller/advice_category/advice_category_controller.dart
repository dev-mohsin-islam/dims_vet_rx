






import 'package:dims_vet_rx/models/advice_category/advice_category_model.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../database/crud_operations/common_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../utilities/default_value.dart';

class AdviceCategoryController extends GetxController{
  final CommonController commonController = CommonController();
  final Box<AdviceCategoryModel>box = Boxes.getAdviceCategory();
  final RxList dataList =  [].obs;
  final TextEditingController nameController= TextEditingController();

  final TextEditingController searchController= TextEditingController();
  RxBool isLoading = true.obs;



  Future<void> addData(id)async{
    if(nameController.text.trim().isNotEmpty){
      await commonController.saveCommon(box, AdviceCategoryModel(id: id, name: nameController.text.trim(), uuid: DefaultValues.defaultUuid, date: DefaultValues.defaultDate, web_id: DefaultValues.defaultweb_id, status: DefaultValues.NewAdd));
      nameController.clear();
      await getAllData('');
    }

    // isLoading.value = false;
  }

  Future<void> updateData(id)async{
    if(nameController.text.trim().isNotEmpty){
      await commonController.updateCommon(box, id, nameController.text.trim(), DefaultValues.Update);
      nameController.clear();
      await getAllData('');
    }

    // isLoading.value = false;

  }

  Future<void> deleteData(id)async{

    try {
      if(id != null && id !=-1) {
        await commonController.deleteCommon(box, id, DefaultValues.Delete);
        await getAllData('');
      }

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
    commonController;
    dataList;
    nameController.dispose();
    searchController.dispose();
    super.dispose();
  }

}



