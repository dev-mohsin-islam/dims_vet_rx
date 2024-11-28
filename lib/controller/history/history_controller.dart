


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/database/crud_operations/patient_history_crud.dart';
import 'package:dims_vet_rx/models/history/history_model.dart';
import 'package:dims_vet_rx/models/history_category/history_category_model.dart';
import 'package:win32/win32.dart';

import '../../database/crud_operations/history_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../models/patient_history/patient_history_model.dart';
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';
import '../../utilities/history_category.dart';

class HistoryController extends GetxController{
  final HistoryCrudController historyCrudController = HistoryCrudController();
  final PatientHistoryCrudController patientHistoryCrudController = PatientHistoryCrudController();
  final Box<PatientHistoryModel>boxPatientHistory = Boxes.getPatientHistory();
  final Box<HistoryModel>box = Boxes.getHistory();
  final Box<HistoryCategoryModel>boxHistoryCategory = Boxes.getHistoryCategory();
  final RxList dataList =  [].obs;
  final RxList oldPatientHistoryList = [].obs;
  final TextEditingController nameController= TextEditingController();
  final TextEditingController searchController= TextEditingController();

  final TextEditingController historyCatNameController = TextEditingController();

  //this history get from database only
  final RxList patientHistoryList = [].obs;

  RxString? selectedCategory = "".obs;
  RxList selectedHistory = [].obs;
  RxList dropDownSelectedHistory = [].obs;
  RxMap selectedHistoryGroupByCat = {}.obs;

  RxBool isLoading = true.obs;

  final uuid = DefaultValues.defaultUuid;
  final date = DefaultValues.defaultDate;
  final web_id = DefaultValues.defaultweb_id;
  final statusNewAdd = DefaultValues.NewAdd;
  final statusUpdate = DefaultValues.Update;
  final statusDelete = DefaultValues.Delete;

  List category = [].obs;


  void addData(id)async{
   try {
     if(nameController.toString().isNotEmpty && selectedCategory.toString().isNotEmpty) {
       await historyCrudController.saveCommon(box, HistoryModel(id: id, name: nameController.text.trim(), uuid: uuid, date: date, web_id: web_id, u_status: statusNewAdd, category: selectedCategory.toString().trim(), type: ''));
     }
     nameController.clear();
     selectedCategory?.value = "";
     await getAllData('');
   }catch(e){
     print(e);
   }
    // isLoading.value = false;
  }

  historyCategoryCUD(id, method)async{
    if(historyCatNameController.text.isNotEmpty){
      HistoryCategoryModel historyCategoryModel = HistoryCategoryModel(id: id, name: historyCatNameController.text.trim(), uuid: uuid, date: date, web_id: web_id, u_status: statusNewAdd);
        await historyCrudController.saveHistoryCat(boxHistoryCategory, historyCategoryModel, method);
        historyCatNameController.clear();
      getAllHistoryCategory('');
      Navigator.pop(Get.context!);
    }else{
     // ScaffoldMessenger.of(Get.context!).showSnackBar(Helpers.errorSnackBar("Failed!", "Field must be not empty"));
    }
  }
  Future<void>catWiseDataSearch(catId)async{
    var response =await historyCrudController.getAllHistoryCat(box, '');
    if(response.isNotEmpty){
      dataList.clear();
      for(var item in response){
        if(item.category == catId){
          dataList.add(item);
        }
      }
    }
  }
  getAllHistoryCategory(searchText)async{
    try {
      isLoading.value = true;
      var response =await historyCrudController.getAllHistoryCat(boxHistoryCategory, searchText);
      if(response.isNotEmpty){
        category.clear();
        category.add({'name': "Select History Category", "value": ''});
        for(var item in response){
          category.add({'name': item.name, "value": item.id.toString()});
        }
      }

      isLoading.value = false;
    }catch(e){
      print(e);
    }
  }
  Future<void> updateData(id)async{
    try {
      await historyCrudController.updateHistory(box, id, nameController.text.trim(), selectedCategory.toString().trim(), statusUpdate);
      nameController.clear();
      await getAllData('');
    }catch(e){
      print(e);
    }
    // isLoading.value = false;
  }

  Future<void> deleteData(id)async{

    try {
      await historyCrudController.deleteCommon(box, id, statusDelete);
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
     var response = await historyCrudController.getAllData(box, searchText);
     dataList.clear();
     dataList.addAll(response);
     isLoading.value = false;
   }catch(e){
     print(e);
   }
  }

  //individual patient history data save to database
  patientHistorySaveToDatabase(PATIENTID)async{
    try {

      if(selectedHistory.isNotEmpty){
        for(int i=0; i<selectedHistory.length; i++){
          var history = PatientHistoryModel(id: 0, u_status: statusNewAdd, patient_id: PATIENTID, uuid: uuid, date: date, history_id: selectedHistory[i].id, category: selectedHistory[i].category.toString());
          await patientHistoryCrudController.savePatientHistory(boxPatientHistory, history);
        }
      }

      await getAllPatientHistoryData('');
    }catch(e){
      print(e);
    }
  }

  Future getAllPatientHistoryData(searchText)async{
    try {
      var response = await patientHistoryCrudController.getAllPatientHistoryData(boxPatientHistory, searchText);
      patientHistoryList.clear();
      patientHistoryList.addAll(response);
      return response;
    }catch(e){
      print(e);
    }
  }

  //this for printing patient history called from prescription controller (get single prescription data)
   getSinglePatientHistoryData(PATIENTID, Category){
    List patientHistory = [];
    patientHistory.clear();
    for(int i=0; i<patientHistoryList.length; i++){
      if(PATIENTID == patientHistoryList[i].patient_id && Category == patientHistoryList[i].category){
         var historyId = patientHistoryList[i].history_id;
         var historyData = dataList.firstWhere((element) => element.id == historyId, orElse: () => null,);
         patientHistory.add(historyData);
      }
    }
    return patientHistory;
  }

  getSinglePatientHistory(patientID)async{
    oldPatientHistoryList.clear();
    var myHistory =await getSinglePatientHistoryPrint(patientID);
     var oldList =await groupDataByCategoryForPrint(myHistory);
     print(oldList);

    // myHistory.clear();
    // var patientHistory =await getAllPatientHistoryData('');
    // for(int i=0; i<patientHistory.length; i++){
    //   if(patientID == patientHistory[i].patient_id){
    //     var historyId = patientHistory[i].history_id;
    //     var historyData = dataList.firstWhere((element) => element.id == historyId, orElse: () => null,);
    //     if(historyData != null){
    //       myHistory.add(historyData);
    //     }
    //   }
    // }
    if(oldList != null){
      oldPatientHistoryList.addAll(oldList);
    }

  }
  getSinglePatientHistoryX(patientID)async{
    selectedHistory.clear();
    var myHistory = [];
    myHistory.clear();
    var patientHistory =await getAllPatientHistoryData('');
    for(int i=0; i<patientHistory.length; i++){
      if(patientID == patientHistory[i].patient_id){
         var historyId = patientHistory[i].history_id;
         var historyData = dataList.firstWhere((element) => element.id == historyId, orElse: () => null,);
          if(historyData != null){
            selectedHistory.add(historyData);
            myHistory.add(historyData);
          }
      }
    }
    groupDataByCategory();
    return myHistory;
  }

  groupDataByCategory() {
    // Declare a Map to store the grouped data
    Map<String, List> groupedData = {};
    for (var item in selectedHistory) {
      if (groupedData.containsKey(item.category)) {
        groupedData[item.category]!.add(item);
      } else {

        groupedData[item.category] = [item];
      }
    }
    selectedHistoryGroupByCat.clear();
    selectedHistoryGroupByCat.addAll(groupedData);
  }

  getSinglePatientHistoryPrint(patientID)async{

    var myHistory = [];
    myHistory.clear();
    var patientHistoryX =await getAllPatientHistoryData('');
    for(int i=0; i<patientHistoryX.length; i++){
      if(patientID == patientHistoryX[i].patient_id){
         var historyId = patientHistoryX[i].history_id;
         var historyData =await dataList.firstWhere((element) => element.id == historyId, orElse: () => null,);
          if(historyData != null){
            myHistory.add(historyData);
          }
      }
    }

    return myHistory;

  }


  groupDataByCategoryForPrint(PrintHistory) {
    var modifyList = [];
    modifyList.clear();
    Map<String, List> groupedData = {};

    for (var item in PrintHistory) {
      if (groupedData.containsKey(item.category)) {
        groupedData[item.category]!.add(item);
      } else {
        groupedData[item.category] = [item];
      }
    }

    if(groupedData.isNotEmpty){
      for(int i=0; i<groupedData.length; i++){
        String categoryId = groupedData.keys.elementAt(i);
        List  items = groupedData[categoryId]!;
        var categoryData = category.firstWhere((element) => element['value'] == categoryId, orElse: () => null);
        var historyData = {
          "category": categoryData['name'],
          "items": items
        };
        modifyList.add(historyData);
      }
      return modifyList;
    }
  }

  searchHistoryForAddToRx(history)async{
    var historyList = box.values.toList();
    if(historyList.isNotEmpty){
       if(history.isNotEmpty){
            for(int i=0; i<historyList.length; i++){
              if(historyList[i].name.contains(history)){
                selectedHistory.add(historyList[i]);
                selectedHistory.refresh();
                groupDataByCategory();
                break;
              }
            }
       }
    }
  }

  //this for viewing patient history
  getSinglePatientHistoryDataForView(PATIENTID, Category){
    List patientHistory = [];
    patientHistory.clear();
    for(int i=0; i<patientHistoryList.length; i++){
      if(PATIENTID == patientHistoryList[i].patient_id && Category == patientHistoryList[i].category){
        var historyId = patientHistoryList[i].history_id;
        var historyData = dataList.firstWhere((element) => element.id == historyId, orElse: () => null,);
        patientHistory.add(historyData);
      }
    }

    return patientHistory;
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
    getAllPatientHistoryData('');
    getAllHistoryCategory('');
    super.onInit();
  }

  @override
  void dispose() {
    dataList;
    nameController;
    searchController;
    uuid;
    oldPatientHistoryList;
    patientHistoryList;
    isLoading;
    super.dispose();
  }

}



