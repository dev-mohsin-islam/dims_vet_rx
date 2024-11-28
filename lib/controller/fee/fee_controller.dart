








import 'package:dims_vet_rx/models/fee/fee_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../database/crud_operations/common_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';

class FeeController extends GetxController{
  final CommonController commonController = CommonController();
  final Box<FeeModel>box = Boxes.getFee();
  final RxList dataList =  [].obs;
  final TextEditingController feeController= TextEditingController();

  final TextEditingController searchController= TextEditingController();
  RxBool isLoading = true.obs;

  final uuid = DefaultValues.defaultUuid;
  final date = DefaultValues.defaultDate;
  final web_id = DefaultValues.defaultweb_id;
  final statusNewAdd = DefaultValues.NewAdd;
  final statusUpdate = DefaultValues.Update;
  final statusDelete = DefaultValues.Delete;


  void addData(id)async{
    await commonController.saveCommon(box, FeeModel(id: id, fee: int.parse(feeController.text), uuid: uuid, date: date, web_id: web_id, u_status: statusNewAdd));
    feeController.clear();
    getAllData('');
    // isLoading.value = false;
  }

  Future<void> updateData(id)async{
    try {
      if(feeController.text.isNotEmpty){
        await commonController.updateCommon(box, id, feeController.text.trim(), statusUpdate);
        feeController.clear();
        dataList.refresh();
      }else{
        Helpers.errorSnackBar("Failed", "Field can't be empty");
      }
    }catch(e){
      print(e);
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
    dataList.sort((a, b) => a.name[0].compareTo(b.name[0]));
    isLoading.value = false;
  }


  clearText()async{
    dataList.clear();
    feeController.clear();
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
    feeController;
    searchController;
    isLoading;

    super.dispose();
  }

}



