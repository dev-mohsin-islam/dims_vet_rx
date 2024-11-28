import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:dims_vet_rx/utilities/default_value.dart';
import '../../utilities/helpers.dart';

class FavoriteIndexCrudController {

  Future<bool?> deleteCommon(box, id) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.id == id);
      if (index != -1) {
        var existingData = await box.getAt(index)!;
        if(existingData.u_status == DefaultValues.Synced){
          existingData.u_status = DefaultValues.favoriteDelete;
          await box.putAt(index, existingData);
          Logger().d('Success in deleteCommon');
        }else{
          await box.deleteAt(index);
        }

      } else {
        Logger().d("Invalid index in deleteCommon");
        return false;
      }
    } catch (e) {
      Logger().e("Error in deleteCommon: $e");
      return false;
    }
    return null;
  }



  Future<bool?> saveCommon(box, object) async {

    try {
      var favoriteIndex = object.favorite_id;
      var statusUpdate = object.u_status;
      var segment = object.segment;
      if (favoriteIndex !=-1) {
        final index = await box.values.toList().indexWhere((data) => data.favorite_id == favoriteIndex && data.segment == segment);
        if (index >= 0 && index < box.length) {
          var existingData = await box.getAt(index)!;
          existingData.u_status = statusUpdate;
          await box.putAt(index, existingData);
          Logger().d(existingData.u_status);
        } else {
          await box.add(object);
          Logger().i('Success in saveCommon $box');
          Helpers.successSnackBar("Success!", "Added successfully");
        }
        return true;
      } else {
        Logger().d("UUID must not be empty in saveCommon");
        return false;
      }
    } catch (e) {
      Logger().e("Error in saveCommon: $e");
      return false;
    }
  }

  Future<bool?> update(box, id, segment, favoriteIndex, statusUpdate) async {
    try {
      if (segment.toString().isNotEmpty && favoriteIndex.toString().isNotEmpty) {
        final index = await box.values.toList().indexWhere((data) => data.favorite_id == favoriteIndex && data.segment == segment);
        if (index !=-1) {
          var existingData = await box.getAt(index)!;
          existingData.u_status =await statusUpdate;
          await box.putAt(index, existingData);
          Logger().i('Success in update');
          Helpers.successSnackBar("Success!", "Remove successfully");
        }else{
          Logger().d("Invalid index in update");
        }
        return true;
      } else {
        Helpers.errorSnackBar("Failed!", "Something went wrong");
        Logger().d("Field must not be empty $box");
        return false;
      }
    } catch (e) {
      Logger().e("Error in update: $e");
      return false;
    }
  }

  Future<List> getAllData(box, searchText) async {
    try {
      List dataList = [];
      if (searchText.isEmpty) {
        for (int i = 0; i < box.length; i++) {
          var item = await box.getAt(i);
          if (item.favorite_id != null && item.u_status != 3 && item.u_status != 2) {
            dataList.add(item);
          }
        }
        return dataList;
      } else {
        return dataList;
      }
    } catch (e) {
      Logger().e("Error in getAllData: $e");
      return [];
    }
  }
}
