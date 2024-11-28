
import 'package:flutter/foundation.dart';

import '../../utilities/helpers.dart';

class GenericCrudController{

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

  Future<bool?>saveGeneric(boxGeneric, object)async{

    try{
      List genericList = await boxGeneric.values.toList();
      dynamic maxValue = genericList.map((e) => e.id).reduce((a, b) => a > b ? a : b);
      int index = await boxGeneric.add(object);
      if(index !=-1){
        var existingData = await boxGeneric.getAt(index)!;
        existingData.id = maxValue + 1;
        await boxGeneric.putAt(index, existingData);
      }
      Helpers.successSnackBar("Success!", "Added successfully");
      return true;
    }catch(e){
      Helpers.errorSnackBar("Failed!", "Something went wrong");
      if (kDebugMode) {
        print("Field must be not empty $boxGeneric");
      }
      return false;
    }


  }


  Future<bool?>updateGeneric(box, id, nameController, statusUpdate)async{
   try{
     if(nameController.toString().isNotEmpty){
       var updateValue = nameController;
       final index = await box.values.toList().indexWhere((data) => data.id == id);
       if(index >=0 && index < box.length && updateValue.toString().isNotEmpty){
         var existingData = await box.getAt(index)!;
         existingData.generic_name = updateValue;
         existingData.u_status = statusUpdate;
         await box.putAt(index, existingData);
       }
       Helpers.successSnackBar("Success!", "Update successfully");
       return true;
     }else{
       Helpers.errorSnackBar("Failed!", "Filed must not be empty");
       if (kDebugMode) {
         print("Field must be not empty $box");
       }
       return false;
     }
   }catch(e){
     Helpers.errorSnackBar("Failed!", "Something went wrong");
     if (kDebugMode) {
       print("Error in updateCommon: $e");
     }
   }
  }


  Future<List> getAllDataGeneric(box, searchText)async{
    List dataList = [];
    try {
      dataList.clear();
      for(int i =0; i<await box.length; i++){
        var item = await box.getAt(i);
        if(item !=null && item.generic_name !=null){
          String genericName = item.generic_name.toLowerCase();
          String searchTextLower = searchText.toLowerCase();
          if(genericName.startsWith(searchTextLower)){
            dataList.add(item);
          }
        }
      }
      return dataList;
      // if(searchText.isEmpty){
      //   dataList.clear();
      //   for(int i =0; i< box.length; i++){
      //     var item = await box.getAt(i);
      //     dataList.add(item);
      //   }
      //   return dataList;
      // }else{
      //   for(int i =0; i<await box.length; i++){
      //     var item = await box.getAt(i);
      //     if(item !=null && item.generic_name !=null){
      //       String genericName = item.generic_name.toLowerCase();
      //       String searchTextLower = searchText.toLowerCase();
      //       if(genericName.startsWith(searchTextLower)){
      //         dataList.add(item);
      //       }
      //       dataList.add(item);
      //     }
      //
      //   }
      //   return dataList;
      // }
    }catch(e){
      if (kDebugMode) {
        print("Error in getAllDataCommon: $e");
      }
      return dataList;
    }
  }
}