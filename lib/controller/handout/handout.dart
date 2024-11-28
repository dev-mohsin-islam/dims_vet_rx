

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/utilities/default_value.dart';

import '../../database/crud_operations/common_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../models/handout/handout_model.dart';
import '../../screens/printing/handout_print/print.dart';

class HandoutController extends GetxController {
  CommonController commonController = Get.put(CommonController());
  final Box<HandoutModel>box = Boxes.getHandout();
  RxList dataList = [].obs;
  RxList selectedHandOut = [].obs;
  TextEditingController searchController = TextEditingController();
  TextEditingController labelController = TextEditingController();
  TextEditingController textController = TextEditingController();


  handoutPrint(){
     if(dataList.length>0){
       // Navigator.push(Get.context!, MaterialPageRoute(builder: (context) =>   HandOutPrintPreview(advices: selectedHandOut, )));
     }
  }

 Future addData(id)async{
    if(labelController.text.isNotEmpty &&  textController.text.isNotEmpty){
      var response = commonController.saveCommon(box, HandoutModel(id: box.length + 1, u_status: DefaultValues.NewAdd, uuid: DefaultValues.defaultUuid, label: labelController.text, text: textController.text, category_id: 1, date: DateTime.now().toString(),));
    }
    labelController.clear();
    textController.clear();
    getAllData('');
  }
  getAllData(String searchText)async{
    dataList.value =await box.values.toList();
  }

  Future<void> updateData(id)async{
    await commonController.updateHandout(box, id, labelController.text.trim(), DefaultValues.Update, textController.text.trim());
    labelController.clear();
    dataList.refresh();
    // isLoading.value = false;

  }

  clearText(){
    searchController.clear();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getAllData('');
    super.onInit();
  }
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    labelController.dispose();
    textController.dispose();
    super.dispose();
  }

}