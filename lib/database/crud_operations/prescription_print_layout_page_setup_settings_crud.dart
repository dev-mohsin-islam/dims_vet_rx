
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../utilities/helpers.dart';

class PrescriptionPrintLayoutSetupCRUDController{
  final Logger _logger = Logger();

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



    Future<dynamic>savePrescriptionPrintLayout(box, object)async{

      try{
          if(object.chamber_id.toString().isNotEmpty){
            var index =  await box.values.toList().indexWhere((data) => data.chamber_id == object.chamber_id);
            if(index != -1){
              var existingData = await box.getAt(index)!;
              object.id =await existingData.id;
              await box.putAt(index, object);
              Helpers.successSnackBarDuration("Success", "Chamber Updated", 1000);
              _logger.i("success update");
            }else{
              var indexNew =  await box.add(object);
              if(indexNew != -1){
                object.id = await indexNew + 1;
                await box.putAt(indexNew, object);
                Helpers.successSnackBarDuration("Success", "Chamber Added", 1000);
                _logger.i("success insert");
              }
            }
          }


      }catch(e){
        if (kDebugMode) {
          print(e);
        }
      }

      return null;
    }




  // Future<bool?>updatePatient(box, id, labelController, statusUpdate, updateValueText)async{
  //   if(labelController.isNotEmpty){
  //     var updateLabel = labelController;
  //     final index = await box.values.toList().indexWhere((data) => data.id == id);
  //     if(index >=0 && index < box.length && updateLabel.toString().isNotEmpty){
  //       var existingData = await box.getAt(index)!;
  //       existingData.label = updateLabel;
  //       existingData.text = updateValueText;
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


  Future<List> getChamber(box, searchText)async{
    List dataList = [];
    try{
      dataList.clear();
      if(searchText.toString().isEmpty){
          var item = await box.values.toList();
          dataList.addAll(item);
        return dataList;
      }
      if(searchText.toString().isNotEmpty ){
        var index = await box.values.toList().indexWhere((data) => data.chamber_id == searchText);
        if(index != -1){
          var item = await box.getAt(index);
          dataList.add(item);
          // Helpers.successSnackBarDuration("Success", "Get chamber data", 1000);
          return dataList;

        }else{
          _logger.w('id not matched');
          return [];
        }

      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
    return [];
  }
}