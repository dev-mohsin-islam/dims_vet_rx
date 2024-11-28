




import 'package:dims_vet_rx/models/investigation_report/investigation_report_model.dart';
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

class InvestigationReportController extends GetxController{
  final CommonController commonController = CommonController();
  final Box<InvestigationReportModel>boxInvestigationReport = Boxes.getInvestigationReportBox();
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
    try {
      int ? resId = await commonController.saveCommon(boxInvestigationReport, InvestigationReportModel(id: id, name: nameController.text.trim(), uuid: uuid, date: date, web_id: web_id, u_status: statusNewAdd));
      if(resId != -1 && isAddToFavorite.value){
        await favoriteIndexController.addData(favoriteIndexController.box.length + 1, FavSegment.ir, resId);
        isAddToFavorite.value = false;
      }
      nameController.clear();
      await getAllData('');
    }catch(e){
      print(e);
    }
    // isLoading.value = false;
  }

  Future<void> updateData(id)async{
    try{
      if(nameController.text.trim().isNotEmpty && id != null && id != -1){
        await commonController.updateCommon(boxInvestigationReport, id, nameController.text.trim(), statusUpdate);
        nameController.clear();
        await getAllData('');
      }else{
        Helpers.errorSnackBar('Error', 'Please enter name');
      }
    }catch(e){
      print(e);
    }
    // isLoading.value = false;

  }

  Future<void> deleteData(id)async{

    try {
      if(id !=-1 && id != null){
        await commonController.deleteCommon(boxInvestigationReport, id, statusDelete);
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
      var response = await commonController.getAllDataCommonSearch(boxInvestigationReport, searchText);
      dataList.clear();
      if(response.isNotEmpty){
        var favList = favoriteIndexController.favoriteIndexDataList.where((element) => element.segment == FavSegment.ir).toList().map((e) => e.favorite_id).toList() ?? []; // Provide an empty list if it's null
        List favoriteItems = response.where((item) => favList.contains(item.id)).toList();
        List nonFavoriteItems = response.where((item) => !favList.contains(item.id)).toList();
        favoriteItems.sort((a, b) => a.name.compareTo(b.name));
        dataList.value = [...favoriteItems, ...nonFavoriteItems];
      }
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
    super.dispose();
    dataList;
    nameController;
    searchController;
    uuid;
  }

}


