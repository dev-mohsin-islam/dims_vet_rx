







import 'package:dims_vet_rx/models/advice/advice_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../database/crud_operations/common_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../utilities/default_value.dart';
import '../../utilities/app_strings.dart';

class AdviceController extends GetxController{
  final CommonController commonController = CommonController();
  final Box<AdviceModel>box = Boxes.getAdvice();
  final RxList dataList =  [].obs;
  final TextEditingController labelController= TextEditingController();
  final TextEditingController textController= TextEditingController();

  final TextEditingController searchController= TextEditingController();
  RxBool isLoading = true.obs;



  void addData(id)async{
    await commonController.saveCommon(box, AdviceModel(id: id, label: labelController.text.trim(), uuid: DefaultValues.defaultUuid, date: DefaultValues.defaultDate, web_id: DefaultValues.defaultweb_id, u_status: DefaultValues.NewAdd, text: textController.text.trim()));
    labelController.clear();
    textController.clear();
    getAllData('');
    // isLoading.value = false;
  }

  Future<void> updateData(id)async{
    await commonController.updateShortAdvice(box, id, labelController.text.trim(), DefaultValues.Update, textController.text.trim());
    labelController.clear();
    dataList.refresh();
    // isLoading.value = false;

  }

  Future<void> deleteData(id)async{

    try {
      await commonController.deleteCommon(box, id, DefaultValues.Delete);
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
    var response = await commonController.getAllDataShortAdvice(box, searchText);
    dataList.clear();
    dataList.addAll(response);
    isLoading.value = false;
  }


  clearText()async{
    dataList.clear();
    labelController.clear();
    textController.clear();
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
    dataList;
    commonController;
    dataList;
    labelController.dispose();
    textController.dispose();
    searchController.dispose();
    super.dispose();
  }

}



