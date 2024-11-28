


import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../utilities/helpers.dart';

class PrescriptionProcedureCRUDBoxController{
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
  Future savePrescriptionProcedure(boxPrescriptionProcedure, prescriptionId, dataObject)async{
    try{

      var newIndex = await boxPrescriptionProcedure.add(dataObject);
      if(newIndex !=null && newIndex !=-1){
        var indexCheck = await boxPrescriptionProcedure.values.toList().indexWhere((data) =>data.prescription_id == prescriptionId);
        if(indexCheck !=null && indexCheck !=-1){
          var existingData = await boxPrescriptionProcedure.getAt(indexCheck);
          existingData.id = await indexCheck;
          var update = await boxPrescriptionProcedure.putAt(indexCheck, existingData);
          return existingData.id;
        }
      }

    }catch(e){
      _logger.e("Error in savePrescriptionDrug: $e");
    }
  }


  Future<bool?> deleteProcedure(box, prescriptionID)async{
    try{
      if(prescriptionID !=null){
        await box.values.where((item) => item.prescription_id == prescriptionID).toList().forEach((item) {
          box.delete(item.key);
        });
        return true;
      }
    }catch(e){
      print("$e");
      return true;
    }

  }

  Future<List> getPrescriptionProcedure(box, prescriptionId) async {
    List prescriptionDrug = [];
    prescriptionDrug.clear();
    try {
      List<int> indices = [];
      // Find all indices where the condition is true
      for (int i = 0; i < box.length; i++) {
        var item = await box.getAt(i);
        if (item.prescription_id == prescriptionId) {
          indices.add(i);
        }
      }
      // Retrieve items at the found indices
      for (int index in indices) {
        var data = await box.getAt(index);
        prescriptionDrug.add(data);
      }

      if (prescriptionDrug.isNotEmpty) {
        _logger.d('Success in getPrescriptionDrug');
      } else {
        _logger.d('No matching prescription found');
      }

      return prescriptionDrug;
    } catch (e) {
      _logger.e("Error in getPrescriptionDrug: $e");
      return [];
    }
  }
}