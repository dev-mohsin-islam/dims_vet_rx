
import 'package:get/get_rx/get_rx.dart';
import 'package:dims_vet_rx/models/chief_complain/chief_complain_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';

import '../../database/crud_operations/common_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../screens/common_screen/common_screen.dart';
import '../../utilities/app_strings.dart';
import '../../utilities/default_value.dart';

class ChiefComplainController extends GetxController{
  final CommonController commonController = CommonController();
  final Box<ChiefComplainModel>box = Boxes.getChiefComplain();
  final TextEditingController nameController= TextEditingController();
  final TextEditingController searchController= TextEditingController();
  final RxList dataList =  [].obs;
  final RxList favDataList =  [].obs;

  RxBool isLoading = true.obs;
  RxBool isAddToFavorite = false.obs;
  RxBool isSearch = false.obs;

  void isSearchFunction(String name)async{
    if(name.trim().isNotEmpty){
      isSearch.value = true;
    }else{
      isSearch.value = false;
    }
  }

  void addData(id)async{
    if(nameController.text.trim().isNotEmpty){
      int ? resId = await commonController.saveCommon(box, ChiefComplainModel(id: id, name: nameController.text.trim(), uuid: DefaultValues.defaultUuid, date: DefaultValues.defaultDate, web_id: DefaultValues.defaultweb_id, u_status: DefaultValues.NewAdd));
      if(resId != -1 && isAddToFavorite.value){
        await favoriteIndexController.addData(favoriteIndexController.box.length + 1, FavSegment.chiefComplain, resId);
        isAddToFavorite.value = false;
      }
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
    }else{
      Helpers.errorSnackBar("Failed", "Field can't be empty");
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

   Future getAllData(String searchText)async{
      isLoading.value = true;
      try {
        var response = await commonController.getAllDataCommonSearch(box, searchText);
        dataList.clear();
        if(response.isNotEmpty){
          var favList = favoriteIndexController.favoriteIndexDataList.where((element) => element.segment == FavSegment.chiefComplain).toList().map((e) => e.favorite_id).toList() ?? []; // Provide an empty list if it's null
          List favoriteItems = response.where((item) => favList.contains(item.id)).toList();
          List nonFavoriteItems = response.where((item) => !favList.contains(item.id)).toList();
          favoriteItems.sort((a, b) => a.name.compareTo(b.name));
          dataList.value = [...favoriteItems, ...nonFavoriteItems];
        }
        return response;
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

   initialCall()async{
    await getAllData('');
   }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initialCall();
  }

  @override
  void dispose() {
    getAllData('');
    dataList;
    commonController;
    nameController.dispose();
    searchController.dispose();
    super.dispose();
  }

}



