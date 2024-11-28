import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart'; // Import the logger package
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';

class PrescriptionBoxCRUDController {
  final Logger _logger = Logger(); // Create a logger instance

  Future<bool?> deleteCommon(box, id, u_status) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.id == id);
      if (index != -1 && u_status == 3) {
        var existingData = await box.getAt(index)!;
        existingData.u_status = u_status;
        await box.putAt(index, existingData);
        _logger.d('Success in deleteCommon');
        return true;
      } else {
        _logger.d("Invalid index in deleteCommon");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deleteCommon: $e");
      return false;
    }
  }

  Future<bool?> deletePermanentCommon(box, id, status) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.id == id);
      if (index != -1) {
        await box.deleteAt(index)!;
        _logger.d('Success in deletePermanentCommon');
        return true;
      } else {
        _logger.d("Invalid index in deletePermanentCommon");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deletePermanentCommon: $e");
      return false;
    }
  }

  Future<int> savePrescription(boxPrescription, appointmentId, object) async {
    var date = object.date;
    try {
      if(appointmentId != -1 ) {
        var index = await boxPrescription.values.toList().indexWhere((data) =>data.date == date && data.appointment_id == appointmentId);
        if (index !=-1 && index !=null) {
            var existingData = await boxPrescription.getAt(index);
            var id = existingData.id;
            object.id = id;
            await boxPrescription.putAt(index, object);
            _logger.d('Success in savePrescription (update)');
            print(existingData.cc_text);
            return existingData.id;
        } else {
          int Index = await boxPrescription.add(object);
          if (Index !=-1 && Index !=null) {
            int id =  PreFixIds.defaultPrefixPrescriptionId + Index;
              var existingData = await boxPrescription.getAt(Index);
              existingData.id = id;
              await boxPrescription.putAt(Index, existingData);
              _logger.d('Success in savePrescription (add)');
              return id;
          }
        }
      } else {
        _logger.d("UUID must not be empty");
      }
      return -1;
    } catch (e) {
      _logger.e("Error in savePrescription: $e");
      return -1;
    }
  }

  Future<bool> deleteDrug(box,boxPrescriptionDrugDose,selectedMedicineList, prescriptionID)async{
    try{
      if(prescriptionID !=null){
        await box.values.where((item) => item.prescription_id == prescriptionID).toList().forEach((item) {
          box.delete(item.key);
        });
        await boxPrescriptionDrugDose.values.where((item) => item.prescription_id == prescriptionID).toList().forEach((item) {
          boxPrescriptionDrugDose.delete(item.key);
        });
        return true;
      }else{
        return true;
      }
    }catch(e){
      print("$e");
      return true;
    }

  }

  Future<bool> deleteDrugDose(box, drugId)async{
    try{
      if(drugId !=null && drugId !=-1){
        await box.values.where((item) => item.drug_id == drugId).toList().forEach((item) {
          box.delete(item.key);
        });
        return true;
      }else{
        return true;
      }
    }catch(e){
      _logger.e("Error in savePrescriptionDrug: $e");
      return false;
    }

  }

  Future savePrescriptionDrug(boxPrescriptionDrug, prescriptionId, dataObject)async{
    var brand_id =  dataObject.brand_id;
    try{
      var index = await boxPrescriptionDrug.values.toList().indexWhere((data) =>data.prescription_id == prescriptionId && data.brand_id == brand_id);
      if(index !=-1){
      }else{
        var newIndex = await boxPrescriptionDrug.add(dataObject);
        if(newIndex !=null && newIndex !=-1){
          var indexCheck = await boxPrescriptionDrug.values.toList().indexWhere((data) =>data.prescription_id == prescriptionId && data.brand_id == brand_id);
          if(indexCheck !=null && indexCheck !=-1){
           var existingData = await boxPrescriptionDrug.getAt(indexCheck);
           existingData.id = await indexCheck;
            await boxPrescriptionDrug.putAt(indexCheck, existingData);
           return indexCheck;
          }
        }

      }

    }catch(e){
      _logger.e("Error in savePrescriptionDrug: $e");
    }
  }

  Future<int?> savePrescriptionDrugDose(boxPrescriptionDrugDose, drugId, doseSerial, dataObject) async {
    var prescriptionID = dataObject.prescription_id;
    try{
      var index = await boxPrescriptionDrugDose.values.toList().indexWhere((data) =>data.drug_id == drugId && data.prescription_id == prescriptionID && data.dose_serial == doseSerial);
      if(index !=-1){
      }else{
        var newIndex = await boxPrescriptionDrugDose.add(dataObject);
        if(newIndex !=null && newIndex !=-1){
          var indexCheck = await boxPrescriptionDrugDose.values.toList().indexWhere((data) =>data.drug_id == drugId && data.prescription_id == prescriptionID && data.dose_serial == doseSerial);
          if(indexCheck !=null && indexCheck !=-1){
            var existingData = await boxPrescriptionDrugDose.getAt(indexCheck);
            existingData.id = await indexCheck;
            await boxPrescriptionDrugDose.putAt(indexCheck, existingData);
            _logger.d('Success in savePrescriptionDrugDose ($boxPrescriptionDrugDose)');
            return indexCheck;
          }
        }

      }

    }catch(e){
      _logger.e("Error in $boxPrescriptionDrugDose: $e");
    }
    return null;

  }

  Future deleteOldestPrescription(boxPrescription) async {
    List oldList = [];
    try{
      var list = await getAllDataPrescription(boxPrescription, '');
      for (var i = 0; i < list.length; i++) {
        if(await isSixMonthsOld(customDateFormat(list[i].date))){
          // add to old list for deletion
          oldList.add(list[i]);
        }
      }

      // delete oldest
      for (var i = 0; i < oldList.length; i++) {
        var index = await boxPrescription.values.toList().indexWhere((data) => data.id == oldList[i].id);
        if(index !=-1){
          print('Deleted Prescription: ${oldList[i].appointment_id}');
          await boxPrescription.deleteAt(index);
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

  Future<List> getAllDataPrescription(box, searchText) async {
    try {
      List dataList = [];
      if (searchText.isEmpty) {
        dataList.clear();
        for (int i = 0; i <await box.length; i++) {
          var item = await box.getAt(i);
          dataList.add(item);
          print('Item Prescription: ${item.date.toString()}');
        }
        _logger.d('Success in getAllDataPrescription');
        return dataList;
      } else {
        dataList.clear();
        for (int i = 0; i < await box.length; i++) {
          var item = await box.getAt(i);
          if (item != null &&
              item.u_status != 3 &&
              (item.name.toLowerCase().contains(searchText.toLowerCase()))) {
            dataList.add(item);
          }
        }
        dataList = dataList.reversed.toList(); // Reverse the list in place
        _logger.d('Success in getAllDataPrescription (with search)');
        return dataList;
      }

    } catch (e) {
      _logger.e("Error in getAllDataPrescription: $e");
      return [];
    }
  }

  Future<List> getSinglePrescriptionData(box, prescriptionID) async {
    List singlePrescription = [];
    try {
      if (prescriptionID != null) {
        int index = await box.values.toList().indexWhere((item) => item.id == prescriptionID);
        if (index != -1) {
          var data = await box.getAt(index);
          singlePrescription.clear();
          singlePrescription.add(data);
          _logger.d('Success in getSinglePrescriptionData');
          return singlePrescription;
        }
      }
      return[];
    } catch (e) {
      _logger.e("Error in getSinglePrescriptionData: $e");
      return[];
    }

  }

  Future<List> getPrescriptionDrug(box, prescriptionId) async {
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
      return prescriptionDrug;
    } catch (e) {
      _logger.e("Error in getPrescriptionDrug: $e");
      return [];
    }
  }

  Future<List> getPrescriptionDrugDose(box,prescriptionId, drugId) async {
    List prescriptionDrugDose = [];
    prescriptionDrugDose.clear();
    try {
      List<int> indices = [];
      // Find all indices where the condition is true
      for (int i = 0; i < box.length; i++) {
        var item = await box.getAt(i);
        if (item.drug_id == drugId && item.prescription_id == prescriptionId) {
          indices.add(i);
        }
      }

      // Retrieve items at the found indices
      for (int index in indices) {
        var data = await box.getAt(index);
        prescriptionDrugDose.add(data);
      }

      if (prescriptionDrugDose.isNotEmpty) {
        _logger.d('Success in getPrescriptionDrug');
      } else {
        _logger.d('No matching prescription found');
      }

      return prescriptionDrugDose;
    } catch (e) {
      _logger.e("Error in getPrescriptionDrug: $e");
      return [];
    }
  }


}
