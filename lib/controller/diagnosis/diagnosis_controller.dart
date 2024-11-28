


import 'package:dims_vet_rx/models/diagnosis/diagnosis_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../database/crud_operations/common_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../screens/common_screen/common_screen.dart';
import '../../utilities/app_strings.dart';
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';

class DiagnosisController extends GetxController{
  final CommonController commonController = CommonController();
  final Box<DiagnosisModal>box = Boxes.getDiagnosis();

  final RxList dataList =  [].obs;
  final RxList favDataList =  [].obs;

  final TextEditingController nameController= TextEditingController();
  final TextEditingController searchController= TextEditingController();

  RxBool isLoading = true.obs;
  RxBool isSearch = false.obs;

  void isSearchFunction(String name)async{
    if(name.trim().isNotEmpty){
      isSearch.value = true;
    }else{
      isSearch.value = false;
    }
  }
  RxBool isAddToFavorite = false.obs;
  final uuid = DefaultValues.defaultUuid;
  final date = DefaultValues.defaultDate;
  final web_id = DefaultValues.defaultweb_id;
  final statusNewAdd = DefaultValues.NewAdd;
  final statusUpdate = DefaultValues.Update;
  final statusDelete = DefaultValues.Delete;


  void addData(id)async{
    int ? resId = await commonController.saveCommon(box, DiagnosisModal(id: id, name: nameController.text.trim(), uuid: uuid, date: date, web_id: web_id, u_status: statusNewAdd));
    if(resId != -1 && isAddToFavorite.value){
      await favoriteIndexController.addData(favoriteIndexController.box.length + 1, FavSegment.dia, resId);
      isAddToFavorite.value = false;
    }
    nameController.clear();
    getAllData('');
    // isLoading.value = false;
  }

  Future<void> updateData(id)async{
    if(nameController.text.trim().isNotEmpty){
      await commonController.updateCommon(box, id, nameController.text.trim(), statusUpdate);
      nameController.clear();
      dataList.refresh();
      // isLoading.value = false;
    }else{
      Helpers.errorSnackBar("Failed", "Field can't be empty");
    }


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
    try {
        var response = await commonController.getAllDataCommonSearch(box, searchText);
        dataList.clear();
        dataList.addAll(response);
        favDataList.clear();
        if(response.isNotEmpty){
          for(var i =0; i < response.length; i++){
            var item = response[i];
            var favoriteIndex = item.id;
            var favoriteId = favoriteIndexController.favoriteIndexDataList.firstWhere((element) => element.favorite_id == favoriteIndex && element.u_status !=2 && element.segment == FavSegment.dia, orElse: () => null,);
            if(favoriteId != null){
              favDataList.add(item);
            }
          }
        }
        // dataList.sort((a, b) => a.name[0].compareTo(b.name[0]));
        isLoading.value = false;

    }catch(e){
      if (kDebugMode) {
        print(e);
      }
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
    dataList;
    commonController;
    box;
    dataList;
    favDataList;
    nameController;
    searchController;
    isLoading;
    isSearch;
    super.dispose();
  }

}



