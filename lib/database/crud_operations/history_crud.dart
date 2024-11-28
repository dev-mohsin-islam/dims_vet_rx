
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utilities/app_strings.dart';
import '../../utilities/helpers.dart';

class HistoryCrudController{

  Future<bool?>deleteCommon(box,id, u_status)async{
    var index = await box.values.toList().indexWhere((data) => data.id == id);
    if(index !=-1 && u_status == 3){
      var existingData = await box.getAt(index)!;
      existingData.u_status = u_status;
      await box.putAt(index, existingData);
      if (kDebugMode) {
        print('Success');
      }
      return true;
    }else{
      if (kDebugMode) {
        print("Invalid index");
      }
      return false;
    }
  }

  Future<bool?>deletePermanentCommon(box,id, status)async{
    var index = await box.values.toList().indexWhere((data) => data.id == id);
    if(index !=-1){
      await box.deleteAt(index)!;
      if (kDebugMode) {
        print('Success');
      }
      return true;
    }else{
      if (kDebugMode) {
        print("Invalid index");
      }
      return false;
    }
  }

  Future<bool?>saveCommon(box, object)async{

      try{
        await box.add(object);
        ScaffoldMessenger.of(Get.context!).showSnackBar(Helpers.successSnackBar(Messages.success, Messages.addSuccess));
        return true;
      }catch(e){
        Helpers.errorSnackBar("Failed!", "Something went wrong");
        if (kDebugMode) {
          print("Field must be not empty $box");
        }
        return false;
      }

  }
  Future<bool?>saveHistoryCat(box, object, method)async{

      try{
        if(method == CRUD.add){
          var isExist = await box.values.toList().indexWhere((data) => data.id == object.id);
          if(isExist == -1){
            await box.add(object);
          }else{
            await box.putAt(isExist, object);
          }

          return true;
        }
        if(method == CRUD.update){
          var isExist = await box.values.toList().indexWhere((data) => data.id == object.id);
          if(isExist !=-1){
            await box.putAt(isExist, object);

          }
        }
        if(method == CRUD.update){
          var isExist = await box.values.toList().indexWhere((data) => data.id == object.id);
          if(isExist !=-1){
            await box.deleteAt(isExist);

          }
        }
        return true;
      }catch(e){
        Helpers.errorSnackBar("Failed!", "Something went wrong");
        return false;
      }

  }

  Future<bool?>updateHistory(box, id, nameController, category, statusUpdate)async{
    try{
      if(nameController.toString().isNotEmpty){
        var updateValue = nameController;
        final index = await box.values.toList().indexWhere((data) => data.id == id);
        if(index >=0 && index < box.length && updateValue.toString().isNotEmpty){
          var existingData = await box.getAt(index)!;
          existingData.name = updateValue;
          existingData.category = category;
          existingData.u_status = statusUpdate;
          await box.putAt(index, existingData);
        }
        Helpers.successSnackBar("Success!", "Update successfully");
        return true;
      }else{
        Helpers.errorSnackBar("Failed!", "Something went wrong");
        if (kDebugMode) {
          print("Field must be not empty $box");
        }
        return false;
      }
    }catch(e){
      Helpers.errorSnackBar("Failed!", "Something went wrong");
    }
    return null;
  }


  Future<List> getAllData(box, searchText)async{
    List dataList = [];
      try {
        if(searchText.isEmpty){
          for(int i =0; i< box.length; i++){
            var item = await box.getAt(i);
            if(item.name !=null && item.u_status !=3) {
              dataList.add(item);
            }
          }
          return dataList;
        }else{
          dataList.clear();
          for(int i =0; i<box.length; i++){
            var item = await box.getAt(i);
            if(item.name !=null && item.u_status !=3 && (item.name.toLowerCase().contains(searchText.toLowerCase()))) {
              dataList.add(item);
            }

          }
          return dataList;
        }
      }catch(e){
        print("Error in getAllData: $e");
        Helpers.errorSnackBar("Failed", "Something went wrong");
        return dataList;
      }
  }
  Future<List> getAllHistoryCat(box, searchText)async{
    List dataList = [];
      try {
        if(searchText.isEmpty){
          for(int i =0; i< box.length; i++){
            var item = await box.getAt(i);
            if(item.name !=null && item.u_status !=3) {
              dataList.add(item);
            }
          }
          return dataList;
        }else{
          dataList.clear();
          for(int i =0; i<box.length; i++){
            var item = await box.getAt(i);
            if(item.name !=null && item.u_status !=3 && (item.name.toLowerCase().contains(searchText.toLowerCase()))) {
              dataList.add(item);
            }

          }
          return dataList;
        }
      }catch(e){
        print("Error in getAllData: $e");
        Helpers.errorSnackBar("Failed", "Something went wrong");
        return dataList;
      }
  }



}