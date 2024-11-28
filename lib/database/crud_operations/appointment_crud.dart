
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';
import '../hive_get_boxes.dart';

class AppointmentBoxController{
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

  Future<int?>saveAppointment(boxAppointment, object)async{
    var patientId = object.patient_id;
    var appointmentId = object.id;
    var date = object.date;

    try{
        if(await boxAppointment.length >0){
          if(appointmentId != -1 && appointmentId != 0){
            var index = await boxAppointment.values.toList().indexWhere((data) => data.date == date && data.patient_id == patientId && data.id == appointmentId);
            if (index != -1) {
              // update existing recorde
              var existingData = await boxAppointment.getAt(index);
              object.id = await existingData.id;
              object.serial = await existingData.serial;
              await boxAppointment.putAt(index, object);
              print("Appointment Existing Id : ${object.id}");
              print("------------");
              return object.id;
            } else{
              int index = await  boxAppointment.add(object);
              int id = await PreFixIds.defaultPrefixAppId + index;
              var existingData = await boxAppointment.getAt(index);
              existingData.id  = await id;
              await boxAppointment.putAt(index, existingData);
              Helpers.successSnackBar("Success!", "Added successfully");
              return existingData.id;

            }
          }else{
            // Add a new record
            List appointmentList = await boxAppointment.values.toList();
            dynamic maxValue = appointmentList.map((e) => e.id).reduce((a,b) => a >b ? a : b);
            object.id =await maxValue + 1;
            int indexNew = await boxAppointment.add(object);
            print("Appointment New Index : ${indexNew}");
            print("Appointment New Id : ${object.id}");
            print("------------");
            return object.id;
          }

        }else{
          int index = await  boxAppointment.add(object);
          int id = await PreFixIds.defaultPrefixAppId + index;
          var existingData = await boxAppointment.getAt(index);
          existingData.id  = await id;
          await boxAppointment.putAt(index, existingData);
          Helpers.successSnackBar("Success!", "Added successfully");
          return existingData.id;
        }

    }catch(e){
      if (kDebugMode) {
        print("$e");
      }
    }
    return null;

  }

  Future deleteOldestAppointment(boxAppointment) async {
    List oldList = [];
    try{
      var list = await getAllDataAppointment(boxAppointment, '');
      for (var i = 0; i < list.length; i++) {
        if(await isSixMonthsOld(customParseDate(list[i].date))){
          // add to old list for deletion
          oldList.add(list[i]);
        }
      }

      // delete oldest
      for (var i = 0; i < oldList.length; i++) {
        var index = await boxAppointment.values.toList().indexWhere((data) => data.id == oldList[i].id);
        if(index !=-1){
          print('Deleted Appointment: ${oldList[i].patient_id}');
          await boxAppointment.deleteAt(index);
        }else{
          if (kDebugMode) {
            print("Invalid index");
          }
        }
      }

    }catch(e){
      if (kDebugMode) {
        print("$e");
      }
    }
  }

  Future appointmentCancel(boxAppointment, appId)async{
    print(appId);
    try{
      var index = await boxAppointment.values.toList().indexWhere((data) => data.id == appId);
      if(index !=-1){
        var existingData = await boxAppointment.getAt(index)!;
        existingData.status =await DefaultValues.cancelAppointment;
        await boxAppointment.putAt(index, existingData);
        Helpers.successSnackBar("Success!", "Cancelled successfully");
        return true;
      }else{
        if (kDebugMode) {
          print("Invalid index");
        }
      }
    }catch(e){
      if (kDebugMode) {
        print("$e");
      }
    }
  }
  Future appointmentPrescriptionIsReady(boxAppointment, appId)async{
    try{

      var index = await boxAppointment.values.toList().indexWhere((data) => data.id == appId);
      if(index !=-1){
        var existingData = await boxAppointment.getAt(index)!;
        existingData.status =await DefaultValues.prescriptionReady;
        await boxAppointment.putAt(index, existingData);
      }else{
        if (kDebugMode) {
          print("Invalid index");
        }
      }
    }catch(e){
      if (kDebugMode) {
        print("$e");
      }
    }
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


  Future<List> getAllDataAppointment(box, searchText)async{
    List dataList = [];
    try{
      if(searchText.isEmpty){
        dataList.clear();
        for(int i =0; i< box.length; i++){
          var item =await box.getAt(i);
          dataList.add(item);
        }
        return dataList;
      }else{
        dataList.clear();
        for(int i =0; i<box.length; i++){
          var item = await box.getAt(i);
          if(item !=null && item.u_status !=3 && (item.name.toLowerCase().contains(searchText.toLowerCase()))){
            dataList.add(item);
          }
        }
        return dataList;
      }
    }catch(e){
      print("$e");
      return [];
    }
  }

  Future getAppClinicalInfo(appId)async{
    var boxAppointment = Boxes.getAppClinicalData();
    try{
        var data = await boxAppointment.get(appId);
        if(data != null){
          return data;
        }else{
          return null;
        }
    }catch(e){
      if (kDebugMode) {
        print("$e");
      }
    }
  }
}