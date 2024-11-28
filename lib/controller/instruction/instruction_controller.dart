









import 'package:dims_vet_rx/models/instruction/instruction_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../database/crud_operations/common_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';

class InstructionController extends GetxController{
  final CommonController commonController = CommonController();
  final Box<InstructionModel>box = Boxes.getInstruction();
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
    try {
      if(nameController.text.trim().isNotEmpty && nameController.text.toString().length >0  ) {
        await commonController.saveCommon(box, InstructionModel(id: id, name: nameController.text.trim(), uuid: uuid, date: date, web_id: web_id, u_status: statusNewAdd));
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
        await commonController.updateCommon(box, id, nameController.text.trim(), statusUpdate);
        nameController.clear();
        await getAllData('');
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
      if(id != null && id != 0 && id !=-1){
        await commonController.deleteCommon(box, id, statusDelete);
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
    try {
      isLoading.value = true;
      var response = await commonController.getAllDataCommon(box, searchText);
      dataList.clear();
      response.reversed.toList();
      dataList.addAll(response);
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

    super.dispose();
  }

}



