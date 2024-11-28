
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/models/favorite_index/favorite_index_model.dart';

import '../../database/crud_operations/favorite_index_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../utilities/default_value.dart';

class FavoriteIndexController extends GetxController{
  final FavoriteIndexCrudController favoriteIndexCrudController = FavoriteIndexCrudController();
  final Box<FavoriteIndexModel>box = Boxes.getFavoriteIndex();
  final RxList favoriteIndexDataList =  [].obs;

  RxBool iShowFavorite = true.obs;

  RxBool isLoading = true.obs;
  final uuid = DefaultValues.defaultUuid;
  final date = DefaultValues.defaultDate;
  final web_id = DefaultValues.defaultweb_id;
  final statusNewAdd = DefaultValues.NewAdd;
  final statusUpdate = DefaultValues.Update;
  final statusDelete = DefaultValues.favoriteDelete;


   Future addData(id, segment, favorite_id)async{
    await favoriteIndexCrudController.saveCommon(box, FavoriteIndexModel(id: id, segment: segment.toString().trim(), uuid: uuid, date: date, web_id: web_id, u_status: statusNewAdd, favorite_id: favorite_id!));
    await getAllData('');
    // isLoading.value = false;
  }

  Future<void> updateData(id, segment, favorite_id)async{
     print('Remove ID : $favorite_id');
     await favoriteIndexCrudController.update(box, id, segment.toString().trim(), favorite_id, statusUpdate);
    await getAllData('');

  }

  Future<void> deleteData(id)async{
    try {
      await favoriteIndexCrudController.deleteCommon(box, id);
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
      var response = await favoriteIndexCrudController.getAllData(box, searchText);
      favoriteIndexDataList.clear();
      favoriteIndexDataList.addAll(response);
      print("favoriteIndexDataList : ${favoriteIndexDataList.length}");
      favoriteIndexDataList.refresh();
      isLoading.value = false;
    }catch(e){
      if (kDebugMode) {
        print("Error getting data: $e");
      }
    }
  }


  clearText()async{
    favoriteIndexDataList.clear();
    await getAllData('');
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllData('');
  }

  @override
  void dispose() {
    getAllData('');
    favoriteIndexDataList;
    uuid;
    date;
    web_id;
    statusNewAdd;
    statusUpdate;
    statusDelete;
    iShowFavorite;

    super.dispose();
  }

}



