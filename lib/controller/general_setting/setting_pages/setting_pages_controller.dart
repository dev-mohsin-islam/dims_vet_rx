

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../database/crud_operations/setting_pages_crud.dart';
import '../../../database/hive_get_boxes.dart';
import '../../../models/general_setting_pages/setting_pages_model.dart';

class SettingPagesController extends GetxController{
  final SettingPagesCRUDController settingPagesCRUDController = SettingPagesCRUDController();
  final Box<SettingPagesModel>box = Boxes.getSettingPages();


  final RxList dataList =  [].obs;
  RxBool isLoading = true.obs;
  // String? section;
  // String? label;




  void addData(id,section, label)async{
    print(section);
    print(label);
    // await settingPagesCRUDController.saveCommon(box, SettingPagesModel(id: id, section: section.toString().trim(), uuid: uuid, date: date, web_id: web_id, u_status: statusNewAdd, label: label.toString().trim()));

    getAllData('');
    // isLoading.value = false;
  }

  Future<void> updateData(id)async{
    // await settingPagesCRUDController.updateCommon(box, id, section.toString().trim(), statusUpdate);

    dataList.refresh();
    // isLoading.value = false;

  }

  Future<void> deleteData(id)async{

    try {
      // await settingPagesCRUDController.deleteCommon(box, id, statusDelete);
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
    var response = await settingPagesCRUDController.getAllData(box,  searchText);
    dataList.clear();
    dataList.addAll(response);
    dataList.sort((a, b) => a.company_name[0].compareTo(b.company_name[0]));
    isLoading.value = false;
  }
  myFunct()async{
    return await getAllData2('');
  }

  Future<List?> getAllData2(String searchText)async{
    isLoading.value = true;
    List response = await settingPagesCRUDController.getAllData(box,  searchText);
    await Future.delayed(const Duration(seconds: 10), (){

    });
    return response;
  }


  clearText()async{
    dataList.clear();
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
  }

}



