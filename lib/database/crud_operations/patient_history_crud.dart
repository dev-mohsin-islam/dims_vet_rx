
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';

class PatientHistoryCrudController{
  final Logger _logger = Logger();
  Future<bool?>deleteCommon(box,id, u_status)async{
    var index = await box.values.toList().indexWhere((data) => data.id == id);
    if(index !=-1 && u_status == 3){
      var existingData = await box.getAt(index)!;
      existingData.u_status = u_status;
      await box.putAt(index, existingData);
      _logger.i("Success $box");
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

  Future<bool?>savePatientHistory(box, object)async{

    var patientId = object.patient_id;
    var category = object.category;
    var history_id = object.history_id;

    if(patientId !=null && history_id !=0){
      var index = await box.values.toList().indexWhere((data) => data.patient_id == patientId && data.category == category.toString() && data.history_id == history_id);
      if(index ==-1){
        object.id = await box.length + 1;
        await box.add(object);
        _logger.i("Success $box");
      }else{
        var existingData = await box.getAt(index)!;
        object.id = await existingData.id;
         await box.putAt(index, object);
        _logger.i("Already exists update $box");
      }
    }
    return null;

  }





  // Future<bool?>updateBrand(box, id, nameController, statusUpdate)async{
  //   if(nameController.isNotEmpty){
  //     var updateValue = nameController;
  //     final index = await box.values.toList().indexWhere((data) => data.id == id);
  //     if(index >=0 && index < box.length && updateValue.toString().isNotEmpty){
  //       var existingData = await box.getAt(index)!;
  //       existingData.band_name = updateValue;
  //       existingData.u_status = statusUpdate;
  //       await box.putAt(index, existingData);
  //     }
  //     Helpers.successSnackBar("Success!", "Update successfully");
  //     return true;
  //   }else{
  //     Helpers.errorSnackBar("Failed!", "Something went wrong");
  //     if (kDebugMode) {
  //       print("Field must be not empty $box");
  //     }
  //     return false;
  //   }
  // }




  Future<List> getAllPatientHistoryData(box, searchText)async{
    List dataList = [];
    try{
      if(searchText.isEmpty){
        dataList.clear();
        for(int i =0; i< box.length; i++){
          var item = await box.getAt(i);
          dataList.add(item);
        }
        return dataList;
      }else{
        return [];
      }
    }catch(e){
      print(e);
      return [];
    }
  }


}