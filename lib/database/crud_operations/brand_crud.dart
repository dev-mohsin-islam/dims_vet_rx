
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:dims_vet_rx/utilities/default_value.dart';

import '../../utilities/helpers.dart';

class BrandCrudController{

  Future<bool?> deleteCommon(box, id, u_status) async {
    var index = await box.values.toList().indexWhere((data) => data.id == id);
    try {
      if (index != -1 && u_status == 3) {
        var existingData = await box.getAt(index)!;
        existingData.u_status = u_status;
        await box.putAt(index, existingData);
        if (kDebugMode) {
          print('Success');
        }
        return true;
      } else {
        if (kDebugMode) {
          print("Invalid index");
        }
        return false;
      }
    } catch (e) {
      print("Error in deleteCommon: $e");
      // Handle the error or log it based on your requirements.
      // You might want to return a specific value or rethrow the exception.
      return false;
    }
  }

  Future<bool?> deletePermanentCommon(box, id, status) async {
    var index = await box.values.toList().indexWhere((data) => data.id == id);
    try {
      if (index != -1) {
        await box.deleteAt(index)!;
        if (kDebugMode) {
          print('Success');
        }
        return true;
      } else {
        if (kDebugMode) {
          print("Invalid index");
        }
        return false;
      }
    } catch (e) {
      print("Error in deletePermanentCommon: $e");
      return false;
    }
  }

  Future<bool> saveBrand(boxBrand, object) async {

    try {
      List bradList = await boxBrand.values.toList();
      dynamic maxValue = bradList.map((e) => e.id).reduce((a, b) => a > b ? a : b);
        var index = await boxBrand.add(object);
        if(index != -1){
          var existingData = await boxBrand.getAt(index)!;
          existingData.id =await maxValue + 1;
          await boxBrand.putAt(index, existingData);
        }

        return true;
    } catch (e) {
      print("Error in saveCommon: $e");
      // Handle the error or log it based on your requirements.
      // You might want to return a specific value or rethrow the exception.
      return false;
    }
  }

  Future<bool?> updateBrand(box, id, nameController, statusUpdate) async {
    try {
      if (nameController.isNotEmpty) {
        var updateValue = nameController;
        final index = await box.values.toList().indexWhere((data) => data.id == id);
        if (index !=-1 && index >= 0 && index < box.length && updateValue.toString().isNotEmpty) {
          var existingData = await box.getAt(index)!;
          existingData.brand_name = updateValue;
          existingData.u_status = statusUpdate;
          await box.putAt(index, existingData);
        }
        Helpers.successSnackBar("Success!", "Update successfully");
        return true;
      } else {
        Helpers.errorSnackBar("Failed!", "Something went wrong");
        if (kDebugMode) {
          print("Field must not be empty $box");
        }
        return false;
      }
    } catch (e) {
      print("Error in updateBrand: $e");
      return false;
    }
  }




  Future<List?> getAllDataBrand(box, searchText) async {
    List dataList = [];
    try {
      dataList.clear();
      if(searchText.toString().isNotEmpty){
        for (int i = 0; i <await box.length; i++) {
          var item = await box.getAt(i);
          if (item != null &&
              item.brand_name != null &&
              item.u_status != DefaultValues.permanentDelete &&
              item.u_status != DefaultValues.Delete) {
            String brandName = item.brand_name.toLowerCase();
            String searchTerm = searchText.toLowerCase();
            // Check if brandName starts with searchTerm
            if (brandName.startsWith(searchTerm)) {
              dataList.add(item);
            }
          }
        }
      }else{
        dataList.clear();
        for (int i = 0; i <await box.length; i++) {
          var item = await box.getAt(i);
          if (item != null &&
              item.brand_name != null &&
              item.u_status != DefaultValues.permanentDelete &&
              item.u_status != DefaultValues.Delete) {
            dataList.add(item);
          }
        }
      }
      return dataList;
    } catch (e) {
      print("Error in getAllDataBrand: $e");
      return [];
    }
  }


  //this method not used, only experimental purpose created by me
  Future<List?> getAllDataBrandX(box, searchText) async {
    List dataList = [];
    try {
      dataList.clear();
      int count = 0;
      if (searchText.toString().isNotEmpty) {
        for (int i = 0; i < await box.length; i++) {
          var item = await box.getAt(i);
          if (item != null &&
              item.brand_name != null &&
              item.u_status != DefaultValues.permanentDelete &&
              item.u_status != DefaultValues.Delete) {
            String brandName = item.brand_name.toLowerCase();
            String searchTerm = searchText.toLowerCase();
            if (brandName.startsWith(searchTerm)) {
              dataList.add(item);
              count++;
              if (count >= 2000) {
                break;
              }
            }
          }
        }
      } else {
        dataList.clear();
        for (int i = 0; i < await box.length; i++) {
          var item = await box.getAt(i);
          if (item != null &&
              item.brand_name != null &&
              item.u_status != DefaultValues.permanentDelete &&
              item.u_status != DefaultValues.Delete) {
            dataList.add(item);
            count++;
            if (count >= 2000) {
              break;
            }
          }
        }
      }
      return dataList;
    } catch (e) {
      print("Error in getAllDataBrand: $e");
      return [];
    }
  }






}