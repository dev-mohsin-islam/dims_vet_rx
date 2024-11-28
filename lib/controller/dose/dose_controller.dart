







import 'dart:convert';

import 'package:dims_vet_rx/models/dose/dose_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../database/crud_operations/common_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';

class DoseController extends GetxController{
  final CommonController commonController = CommonController();
  final Box<DoseModel>box = Boxes.getDose();
  final boxDosesFormShort = Boxes.getDosesFormShort();
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
  RxList doseFormSortList = [
    {
      "id": 1,
      "dose_name": "Eye Drop",
      "short_name": "ED",
    },
    {
      "id": 2,
      "dose_name": "Syrup",
      "short_name": "SY",
    },

  ].obs;
  RxList selectedDoseFormList = [].obs;

  RxList dosesList = [
    {
      "title": "Eye Drop",
      "key": "eyeDrop",
      "match_doses_form": ['Eye Drop',"Oral Drop",],
      "doses": [
        {"name": "Eye Drop", "id": 1},
        {"name": "Oral Drop", "id": 2},
      ]
    },
    {
      "title": "Eye Drop",
      "key": "eyeDrop",
      "match_doses_form": ['Eye Drop',"Oral Drop",],
      "doses": [
        {"name": "Eye Drop", "id": 1},
        {"name": "Oral Drop", "id": 2},
      ]
    },
    {
      "title": "Syrup",
      "key": "syrup",
      "match_doses_form": ['Syrup',"Suspension", "Oral Suspension", "Powder for Suspension"],
      "doses": [
        {"name": "২ চামচ করে দিনে ৩ বার", "id": 1},
        {"name": "১ চামচ করে দিনে ৩ বার", "id": 1},
        {"name": "১ চামচ করে সকালে এবং রাতে", "id": 2},
        {"name": "১/২ চামচ করে দিনে ৩ বার", "id": 2},
      ]
    },
    {
      "title": "Syrup",
      "key": "syrup",
      "match_doses_form": ['Syrup',"Suspension", "Oral Suspension", "Powder for Suspension"],
      "doses": [
        {"name": "২ চামচ করে দিনে ৩ বার", "id": 1},
        {"name": "১ চামচ করে দিনে ৩ বার", "id": 1},
        {"name": "১ চামচ করে সকালে এবং রাতে", "id": 2},
        {"name": "১/২ চামচ করে দিনে ৩ বার", "id": 2},
      ]
    },
  ].obs;

  void addData(id, [name])async{
    try {
      if(nameController.text.trim().isNotEmpty){
        await commonController.saveCommon(box, DoseModel(id: id, name: nameController.text.trim(), uuid: uuid, date: date, web_id: web_id, u_status: statusNewAdd));
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

  } catch (e) {
    print(e);
  }
    // isLoading.value = false;

  }

  Future<void> deleteData(id)async{

    try {
      await commonController.deleteCommon(box, id, statusDelete);
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
      var response = await commonController.getAllDataCommon(box, searchText);
      dataList.clear();
      dataList.addAll(response);
      isLoading.value = false;
    }catch(e){
      print(e);
    }
  }
  Future<void> insertDosesFormShort(selectedDoseForm)async{

    try{
      if(selectedDoseForm != null && selectedDoseForm.isNotEmpty){
        await boxDosesFormShort.clear();
        for(var item in selectedDoseForm){
          var json = jsonEncode(item);
          if(json != null){
            final jsonMap = jsonDecode(json) as Map<String, dynamic>;
            if(selectedDoseForm != null && selectedDoseForm.isNotEmpty){

              var response = await boxDosesFormShort.add(jsonMap);
              if(response == 0){
                Helpers.successSnackBar("Success", "Successfully Added");
              }
            }
          }
        }
      }

    }catch(e){
      print(e);
    }
  }
 Future getDosesFormShort(doseForm)async{
    try{
      var response = await boxDosesFormShort.values.toList();
      if(response != null){
        selectedDoseFormList.clear();
        selectedDoseFormList.value = response;
      }
      if(doseForm != null || doseForm !=''){
        var searchedData = selectedDoseFormList.where((element) => element['dose_name'] == doseForm).toList();
        if(searchedData != null && searchedData.isNotEmpty){
          for(var item in searchedData){
             return item['short_name'];
          }
        }
      }
      return response;
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

  initialCall()async{
    await getAllData('');
    await getDosesFormShort('');
  }

  @override
  void onInit() {
    // TODO: implement onInit
    initialCall();
    super.onInit();
  }

  @override
  void dispose() {
    getAllData('');
    dataList;
    nameController.dispose();
    searchController.dispose();
    uuid;
    date;
    web_id;
    statusNewAdd;
    statusUpdate;
    statusDelete;
    super.dispose();
  }

}



