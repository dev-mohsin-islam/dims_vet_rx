import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart'; // Import the logger package
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';

class PrescriptionTemplateBoxCRUDController {
  final Logger _logger = Logger(); // Create a logger instance

  Future<bool?> deleteCommon(box, id, u_status) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.id == id);
      if (index != -1) {
        var existingData = await box.getAt(index)!;
        existingData.u_status = u_status;
        await box.putAt(index, existingData);
        _logger.d('Success in deleteCommon ');
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

  Future<int> savePrescriptionTemplate(box, object) async {
    var date = object.date;
    var templateName = object.template_name;
    try {
      if(templateName != null) {
        var checkIndex = await box.values.toList().indexWhere((data) =>data.template_name == templateName && data.u_status != DefaultValues.Delete);
        if (checkIndex !=-1 && checkIndex !=null) {
          await box.putAt(checkIndex, object);
          if(checkIndex !=-1){
            var existingData = await box.getAt(checkIndex);
            existingData.id  = await checkIndex;
            await box.putAt(checkIndex, existingData);
            _logger.d('Success in savePrescriptionTemplate (update)');
            return checkIndex;
          }
        } else {
          var newIndex = await box.add(object);
          if (newIndex !=-1 && newIndex !=null) {
            var checkIndex = await box.values.toList().indexWhere((data) => data.template_name == templateName && data.u_status != DefaultValues.Delete);
            if(checkIndex !=null && checkIndex !=-1){
              var existingData = await box.getAt(checkIndex);
              existingData.id = await newIndex;
              await box.putAt(newIndex, existingData);
              _logger.d('Success in savePrescriptionTemplate (add)');
              Helpers.successSnackBar("Success!", "Added successfully");
              return newIndex;
            }
          }
        }
      } else {
        _logger.d("UUID must not be empty");
      }
      return -1;
    } catch (e) {
      _logger.e("Error in savePrescriptionTemplate: $e");
      return -1;
    }
  }

  Future<bool> deleteTemplateDrug(box,boxPrescriptionDrugDose,selectedMedicineList, prescriptionTemplateID)async{
    try{
      if(prescriptionTemplateID !=null){
        await box.values.where((item) => item.template_id == prescriptionTemplateID).toList().forEach((item) {
          box.delete(item.key);
        });
        await boxPrescriptionDrugDose.values.where((item) => item.template_id == prescriptionTemplateID).toList().forEach((item) {
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
  Future<bool> deleteTemplateDrugDose(box, drugId)async{
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
      _logger.e("Error in savePrescriptionTemplateDrug: $e");
      return false;
    }

  }


  Future savePrescriptionTemplateDrug(boxPrescriptionTemplateDrug, templateId, dataObject)async{
    var brand_id =  dataObject.brand_id;
    try{
      var index = await boxPrescriptionTemplateDrug.values.toList().indexWhere((data) =>data.template_id == templateId && data.brand_id == brand_id);
      if(index !=-1){
      }else{
        var newIndex = await boxPrescriptionTemplateDrug.add(dataObject);
        if(newIndex !=null && newIndex !=-1){
          var indexCheck = await boxPrescriptionTemplateDrug.values.toList().indexWhere((data) =>data.template_id == templateId && data.brand_id == brand_id);
          if(indexCheck !=null && indexCheck !=-1){
            var existingData = await boxPrescriptionTemplateDrug.getAt(indexCheck);
            existingData.id = await indexCheck;
            var update = await boxPrescriptionTemplateDrug.putAt(indexCheck, existingData);
            return existingData.id;
          }
        }

      }

    }catch(e){
      _logger.e("Error in savePrescriptionTemplateDrug: $e");
    }
  }


  Future<int?> savePrescriptionTemplateDrugDose(boxPrescriptionTemplateDrugDose, drugId, doseSerial, dataObject) async {
    var templateId = dataObject.template_id;
    try{
      var index = await boxPrescriptionTemplateDrugDose.values.toList().indexWhere((data) =>data.drug_id == drugId && data.template_id == templateId && data.dose_serial == doseSerial);
      if(index !=-1){
      }else{
        var newIndex = await boxPrescriptionTemplateDrugDose.add(dataObject);
        if(newIndex !=null && newIndex !=-1){
          var indexCheck = await boxPrescriptionTemplateDrugDose.values.toList().indexWhere((data) =>data.drug_id == drugId && data.template_id == templateId && data.dose_serial == doseSerial);
          if(indexCheck !=null && indexCheck !=-1){
            var existingData = await boxPrescriptionTemplateDrugDose.getAt(indexCheck);
            existingData.id = await indexCheck;
            await boxPrescriptionTemplateDrugDose.putAt(indexCheck, existingData);
            return indexCheck;
          }
        }
      }

    }catch(e){
      _logger.e("Error in savePrescriptionTemplateDrug: $e");
    }
    return null;

  }

  Future<List> getAllDataPrescriptionTemplate(box, searchText) async {
    try {
      List dataList = [];
      if (searchText.toString().isEmpty) {
        for (int i = 0; i <await box.length; i++) {
          var item = await box.getAt(i);
          if(item != null && item.u_status != DefaultValues.Delete){
            dataList.add(item);
          }
        }
        _logger.d('Success in getAllDataPrescriptionTemplate');
        return dataList;
      } else {
        for (int i = 0; i <await box.length; i++) {
          var item = await box.getAt(i);
          if (item != null && item.u_status != DefaultValues.Delete && (item.name.toLowerCase().contains(searchText.toLowerCase()))) {
            dataList.add(item);
          }
        }
        _logger.d('Success in getAllDataPrescriptionTemplate (with search)');
        return dataList;
      }
    } catch (e) {
      _logger.e("Error in getAllDataPrescriptionTemplate: $e");
      return [];
    }
  }

  Future<List> getSinglePrescriptionTemplateData(box, templateId) async {
    List singlePrescription = [];
    try {
      if (templateId != null && templateId !=-1) {
        int index = await box.values.toList().indexWhere((item) => item.id == templateId);
        if (index != -1) {
          var data = await box.getAt(index);
          singlePrescription.clear();
          singlePrescription.add(data);
          _logger.d('Success in getSinglePrescriptionTemplateData');
          return singlePrescription;
        }
      }
      return[];
    } catch (e) {
      _logger.e("Error in getSinglePrescriptionTemplateData: $e");
      return[];
    }

  }

  Future<List> getPrescriptionTemplateDrug(box, templateId) async {
    List prescriptionTemplateDrug = [];
    prescriptionTemplateDrug.clear();
    try {
      List<int> indices = [];
      // Find all indices where the condition is true
      for (int i = 0; i <await box.length; i++) {
        var item = await box.getAt(i);
        if (item.template_id == templateId) {
          indices.add(i);
        }
      }

      // Retrieve items at the found indices
      for (int index in indices) {
        var data = await box.getAt(index);
        prescriptionTemplateDrug.add(data);
      }


      return prescriptionTemplateDrug;
    } catch (e) {
      _logger.e("Error in getPrescriptionTemplateDrug: $e");
      return [];
    }
  }


  Future<List> getPrescriptionTemplateDrugDose(box,prescriptionTemplateId, drugId) async {
    List prescriptionTemplateDrugDose = [];
    prescriptionTemplateDrugDose.clear();
    try {
      List<int> indices = [];
      // Find all indices where the condition is true
      for (int i = 0; i <await box.length; i++) {
        var item = await box.getAt(i);
        if (item.drug_id == drugId && item.template_id ==prescriptionTemplateId) {
          indices.add(i);
        }
      }

      // Retrieve items at the found indices
      for (int index in indices) {
        var data = await box.getAt(index);
        prescriptionTemplateDrugDose.add(data);
      }

      return prescriptionTemplateDrugDose;
    } catch (e) {
      _logger.e("Error in getPrescriptionTemplateDrug: $e");
      return [];
    }
  }


}
