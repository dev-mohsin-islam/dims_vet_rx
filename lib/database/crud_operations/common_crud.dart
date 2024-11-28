import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:dims_vet_rx/models/money_receipt/money_receipt_model.dart';
import 'package:dims_vet_rx/models/patient_certificate/patient_certificate_model.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/drug_brand/all_drug_brand_list.dart';
import 'package:dims_vet_rx/utilities/app_strings.dart';
import 'package:dims_vet_rx/utilities/default_value.dart';
import '../../utilities/helpers.dart';

class CommonController {
  final Logger _logger = Logger();

  Future<bool?> deleteCommon(box, id, u_status) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.id == id);
      if (index != -1) {
        var existingData = await box.getAt(index)!;
        var u_status = existingData.u_status;
        if(u_status == DefaultValues.NewAdd || u_status == DefaultValues.Update){
          await box.deleteAt(index);
          Helpers.successSnackBar("Success!", "Deleted successfully");
        }else if(u_status == DefaultValues.Synced){
          existingData.u_status =await DefaultValues.Delete;
          await box.putAt(index, existingData);
          Helpers.successSnackBar("Success!", "Deleted successfully");
        }
        _logger.i('Success delete $box');
      } else {
        _logger.w("Invalid index $index in deleteCommon $box");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deleteCommon: $e");
    }
    return null;
  }
  Future<bool?> deletePermanentCommon(box, id, status) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.id == id);
      if (index != -1) {
        await box.deleteAt(index)!;
        _logger.i('Success');
        return true;
      } else {
        _logger.w("Invalid index");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deletePermanentCommon: $e");
    }
    return null;
  }


  Future<int?> saveCommon(box, object) async {
    try {
       int index = await box.add(object);
       if(index != -1){
         var existingData = await box.getAt(index)!;
         Helpers.successSnackBar("Success!", "Added successfully");
         _logger.i('Success');
         return existingData.id;
       }

    } catch (e) {
      _logger.e("Error in saveCommon: $e");
    }
    return null;
  }
  Future<int?> saveTreatmentPlan(box, object,method) async {
    try {
      if(method == CRUD.add){
        int isExit = await box.values.toList().indexWhere((data) => data.id == object.id);
        if(isExit != -1){
          var existingData = await box.getAt(isExit)!;
          await box.putAt(isExit, existingData);
          _logger.i('Success update');
          return existingData.id;
        }
        int index = await box.add(object);
        _logger.i('Success add new');
        return object.id;
      }else if(method == CRUD.update){
        int isExit = await box.values.toList().indexWhere((data) => data.id == object.id);
        if(isExit != -1){
          var existingData = await box.getAt(isExit)!;
          object.u_status = DefaultValues.Update;
          await box.putAt(isExit, object);
          Helpers.successSnackBar("Success!", "Updated successfully");
          _logger.i('Success update');
          return existingData.id;
        }
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e");
    }
    return null;
  }
  Future<int?> saveChamber(box, object) async {

    try {
       int isExit = await box.values.toList().indexWhere((data) => data.chamber_name == object.chamber_name);
       if(isExit != -1){
         var existingData = await box.getAt(isExit)!;
         await box.putAt(isExit, existingData);
         Helpers.successSnackBar("Success!", "Updated successfully");
         _logger.i('Success update');
         return existingData.id;
       }
       int index = await box.add(object);
       if(index != -1){
         var existingData = await box.getAt(index)!;
         Helpers.successSnackBar("Success!", "Added successfully");
         _logger.i('Success');
         return existingData.id;
       }
    } catch (e) {
      _logger.e("Error in saveCommon: $e");
    }
    return null;
  }
  Future<int?> saveRefDoc(box, object, method) async {
    try {
      if(method == "add"){
        int index = await box.add(object);
        if(index != -1){
          var existingData = await box.getAt(index)!;
          Helpers.successSnackBar("Success!", "Added successfully");
          _logger.i('Success');
          return existingData.id;
        }
      }
      if(method == "update"){
        int index = await box.values.toList().indexWhere((data) => data.id == object.id);
        if(index != -1){
          var existingData = await box.getAt(index)!;
          existingData.u_status =await DefaultValues.Update;
          await box.putAt(index, object);
          Helpers.successSnackBar("Success!", "Updated successfully");
          _logger.i('Success update');
          return existingData.id;
        }
      }
      if(method == "delete"){
        int index = await box.values.toList().indexWhere((data) => data.id == object.id);
        if(index != -1){
          var existingData = await box.getAt(index)!;
          existingData.u_status =await DefaultValues.Delete;
          await box.putAt(index, existingData);
          Helpers.successSnackBar("Success!", "Deleted successfully");
          _logger.i('Success delete');
          return object.id;
        }
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e");
    }
    return null;
  }
  Future<int?> saveRefPat(box, object, method) async {
    try {
      if(method == "add"){
        int checkIndex = await box.values.toList().indexWhere((data) => data.app_id == object.app_id);
        if(checkIndex != -1){
          var existingData = await box.getAt(checkIndex)!;
          object.id =await existingData.id;
          await box.putAt(checkIndex, object);
          Helpers.successSnackBar("Success!", "Added successfully");
          _logger.i('Success update');
          return existingData.id;
        }else{
          int index = await box.add(object);
          if(index != -1){
            var existingData = await box.getAt(index)!;
            Helpers.successSnackBar("Success!", "Added successfully");
            _logger.i('Success new added');
            return existingData.id;

          }
        }

      }
      if(method == "update"){
        int indexUpdate = await box.values.toList().indexWhere((data) => data.app_id == object.app_id);
        if(indexUpdate != -1){
          var existingData = await box.getAt(indexUpdate)!;
          existingData.u_status =await DefaultValues.Update;
          await box.putAt(indexUpdate, object);
          Helpers.successSnackBar("Success!", "Updated successfully");
          _logger.i('Success update');
          return existingData.id;
        }
      }
      if(method == "delete"){
        int index = await box.values.toList().indexWhere((data) => data.id == object.id);
        if(index != -1){
          var existingData = await box.getAt(index)!;
          existingData.u_status =await DefaultValues.Delete;
          await box.putAt(index, existingData);
          Helpers.successSnackBar("Success!", "Deleted successfully");
          _logger.i('Success delete');
          return object.id;
        }
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e");
    }
    return null;
  }
  Future<int?> saveMoneyReceipt(box, object, method) async {
    try {
      if(method == "add"){
        int checkIndex = await box.values.toList().indexWhere((data) => data.app_id == object.app_id);
        if(checkIndex != -1){
          var existingData = await box.getAt(checkIndex)!;
          object.id =await existingData.id;
          existingData.u_status =await DefaultValues.Update;
          await box.putAt(checkIndex, object);
          Helpers.successSnackBar("Success!", "Added successfully");
          _logger.i('Success update');
          return existingData.id;
        }else{

          int index = await box.add(object);
          if(index != -1){
            var existingData = await box.getAt(index)!;
            Helpers.successSnackBar("Success!", "Added successfully");
            _logger.i('Success new added');
            return existingData.id;

          }
        }

      }
      if(method == "update"){
        int indexUpdate = await box.values.toList().indexWhere((data) => data.app_id == object.app_id);
        if(indexUpdate != -1){
          var existingData = await box.getAt(indexUpdate)!;
          existingData.u_status =await DefaultValues.Update;
          await box.putAt(indexUpdate, object);
          Helpers.successSnackBar("Success!", "Updated successfully");
          _logger.i('Success update');
          return existingData.id;
        }
      }
      if(method == "delete"){
        int index = await box.values.toList().indexWhere((data) => data.id == object.id);
        if(index != -1){
          var existingData = await box.getAt(index)!;
          existingData.u_status =await DefaultValues.Delete;
          await box.putAt(index, existingData);
          Helpers.successSnackBar("Success!", "Deleted successfully");
          _logger.i('Success delete');
          return object.id;
        }
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e");
    }
    return null;
  }

  Future<int?> saveCertificate(box, object) async {
    String date = object.date;
    String appointmentId = object.appointment_id;
    try {
      int existingIndex =  await box.values.toList().indexWhere((data) => data.appointment_id == appointmentId && data.date == date);
      if(existingIndex == -1){
        object.id =await box.length + 1;
        await box.add(object);
        Helpers.successSnackBar("Success!", "Added successfully");
        _logger.i('Success $box' );
        return object.id;
      }else{
        var existingData = await box.getAt(existingIndex)!;
        object.id = await existingData.id;
        await box.putAt(existingIndex, object);
        _logger.i('update $box' );
        return object.id;
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e ");
    }
    return null;
  }
  Future<List<PatientCertificateModel>?> getCertificate(box, id) async {

    try {
      if(id != -1 && id != ""){
        var index = await box.values.toList().indexWhere((data) => data.id == id);
        if(index != -1){
          var existingData = await box.getAt(index)!;
          return [existingData]; // Return a list containing the existingData
        }
      } else {
        return box.values.toList(); // Return the list directly
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e ");
    }
    return null;
  }
  Future getMoneyReceipt(box, id) async {
    try {
          List data = [];
          data.clear();
      if(id != -1 && id != ""){
        var index = await box.values.toList().indexWhere((data) => data.id == id);
        if(index != -1){
          var existingData = await box.getAt(index)!;
          data.add(existingData);
          return data; // Return a list containing the existingData
        }
      } else {
        data.addAll(box.values.toList());
        return  data ; // Return the list directly
      }

    } catch (e) {
      _logger.e("Error in get: $e ");
    }
    return null;
  }

  /// update data from user
  Future<bool?> updateCommon(box, id, nameController, statusUpdate) async {
    try {
        var updateValue = nameController;
        final index = await box.values.toList().indexWhere((data) => data.id == id);
        if (index !=-1) {
          var existingData = await box.getAt(index)!;
          var u_status = existingData.u_status;
          if(u_status == DefaultValues.NewAdd){
            existingData.name = updateValue;
            existingData.u_status =DefaultValues.NewAdd;
            await box.putAt(index, existingData);
            _logger.i('Success');
            Helpers.successSnackBar("Success!", "Update successfully");
          }else if(u_status == DefaultValues.Synced){
            existingData.name = updateValue;
            existingData.u_status =DefaultValues.Update;
            await box.putAt(index, existingData);
            _logger.i('Success');
            Helpers.successSnackBar("Success!", "Update successfully");
          }
          return true;
        } else {
          _logger.w("Invalid index $box");
          Helpers.errorSnackBar("Failed!", "Something went wrong");
          return false;
        }

    } catch (e) {
      _logger.e("Error in updateCommon: $e");
    }
    return null;
  }
  Future<bool?> updateChamber(box, id, nameController, statusUpdate) async {
    try {
        var updateValue = nameController;
        final index = await box.values.toList().indexWhere((data) => data.id == id);
        if (index !=-1) {
          var existingData = await box.getAt(index)!;
          var u_status = existingData.u_status;
          if(u_status == DefaultValues.NewAdd){
            existingData.chamber_name = updateValue;
            existingData.u_status =DefaultValues.NewAdd;
            await box.putAt(index, existingData);
            _logger.i('Success');
            Helpers.successSnackBar("Success!", "Update successfully");
          }else if(u_status == DefaultValues.Synced){
            existingData.chamber_name = updateValue;
            existingData.u_status =DefaultValues.Update;
            await box.putAt(index, existingData);
            _logger.i('Success');
            Helpers.successSnackBar("Success!", "Update successfully");
          }
          return true;
        } else {
          _logger.w("Invalid index $box");
          Helpers.errorSnackBar("Failed!", "Something went wrong");
          return false;
        }

    } catch (e) {
      _logger.e("Error in updateCommon: $e");
    }
    return null;
  }
  Future<bool?> updateShortAdvice(box, id, labelController, statusUpdate, updateValueText) async {
    try {
      if (labelController.isNotEmpty) {
        var updateLabel = labelController;
        final index = await box.values.toList().indexWhere((data) => data.id == id);
        if (index >= 0 && index < box.length && updateLabel.toString().isNotEmpty) {
          var existingData = await box.getAt(index)!;
          existingData.label = updateLabel;
          existingData.text = updateValueText;
          existingData.u_status = statusUpdate;
          await box.putAt(index, existingData);
          _logger.i('Success');
          Helpers.successSnackBar("Success!", "Update successfully");
          return true;
        } else {
          _logger.w("Field must not be empty $box");
          Helpers.errorSnackBar("Failed!", "Something went wrong");
          return false;
        }
      } else {
        _logger.w("Label must not be empty");
        Helpers.errorSnackBar("Failed!", "Label must be not empty");
        return false;
      }
    } catch (e) {
      _logger.e("Error in updateShortAdvice: $e");
      Helpers.errorSnackBar("Failed!", "An error occurred");
      return false;
    }
  }
  Future<bool?> updateHandout(box, id, labelController, statusUpdate, updateValueText) async {
    try {
      if (labelController.isNotEmpty) {
        var updateLabel = labelController;
        final index = await box.values.toList().indexWhere((data) => data.id == id);
        if (index >= 0 && index < box.length && updateLabel.toString().isNotEmpty) {
          var existingData = await box.getAt(index)!;
          existingData.label = updateLabel;
          existingData.text = updateValueText;
          existingData.u_status = statusUpdate;
          await box.putAt(index, existingData);
          _logger.i('Success');
          Helpers.successSnackBar("Success!", "Update successfully");
          return true;
        } else {
          _logger.w("Field must not be empty $box");
          Helpers.errorSnackBar("Failed!", "Something went wrong");
          return false;
        }
      } else {
        _logger.w("Label must not be empty");
        Helpers.errorSnackBar("Failed!", "Label must be not empty");
        return false;
      }
    } catch (e) {
      _logger.e("Error in updateShortAdvice: $e");
      Helpers.errorSnackBar("Failed!", "An error occurred");
      return false;
    }
  }

  //get data
  Future<List> getAllDataCommon(box, searchText) async {
    try {
      List dataList = [];
      if (searchText.isEmpty) {
        dataList.clear();
        for (int i = 0; i <await box.length; i++) {
          var item = await box.getAt(i);
          if(item != null && item.u_status != DefaultValues.permanentDelete && item.u_status != DefaultValues.Delete){
            dataList.add(item);
          }
        }
        return dataList;
      } else {
        dataList.clear();
        for (int i = 0; i <await box.length; i++) {
          var item = await box.getAt(i);
          if (item != null && item.u_status != DefaultValues.Delete &&
              item.u_status != DefaultValues.permanentDelete &&
              (item.name.toLowerCase().contains(searchText.toLowerCase()))) {
            dataList.add(item);
          }
        }

        return dataList;
      }
    } catch (e) {
      _logger.e("Error in getAllDataCommon: $e");
      return [];
    }
  }
  Future<List> getChamber(box, searchText) async {
    try {
      List dataList = [];
      if (searchText.isEmpty) {
        dataList.clear();
        for (int i = 0; i <await box.length; i++) {
          var item = await box.getAt(i);
          if(item != null && item.u_status != DefaultValues.permanentDelete && item.u_status != DefaultValues.Delete){
            dataList.add(item);
          }
        }
        return dataList;
      } else {
        dataList.clear();
        for (int i = 0; i <await box.length; i++) {
          var item = await box.getAt(i);
          if (item != null && item.u_status != DefaultValues.Delete &&
              item.u_status != DefaultValues.permanentDelete &&
              (item.id.toLowerCase().contains(searchText.toLowerCase()))) {
            dataList.add(item);
          }

        }
        return dataList;
      }
    } catch (e) {
      _logger.e("Error in getAllDataCommon: $e");
      return [];
    }
  }
  Future<List> getRefPatient(box, searchText) async {
    try {
      List dataList = [];
      if (searchText.toString().isEmpty) {
        dataList.clear();
        for (int i = 0; i <await box.length; i++) {
          var item = await box.getAt(i);
          if(item != null && item.u_status != DefaultValues.permanentDelete && item.u_status != DefaultValues.Delete){
            dataList.add(item);
          }
        }
        return dataList;
      } else {
        dataList.clear();
        for (int i = 0; i <await box.length; i++) {
          var item = await box.getAt(i);
          if (item != null && item.u_status != DefaultValues.Delete &&
              item.u_status != DefaultValues.permanentDelete &&
              (item.id.toString().toLowerCase().contains(searchText.toString().toLowerCase()))) {
            dataList.add(item);
          }

        }
        return dataList;
      }
    } catch (e) {
      _logger.e("Error in getAllDataCommon: $e");
      return [];
    }
  }
  Future<List> getAllDataCommonSearch(box, searchText) async {
    List dataList = [];
    try {
      dataList.clear();
      if(searchText.isEmpty){
        for (int i = 0; i <await box.length; i++) {
          var item = await box.getAt(i);
          if(item != null && item.u_status != DefaultValues.permanentDelete && item.u_status != DefaultValues.Delete){
            dataList.add(item);
          }
        }
      }else{
        for (int i = 0; i < await box.length; i++) {
          var item = await box.getAt(i);
          if (item != null && item.name != null && item.u_status !=
              DefaultValues.permanentDelete &&
              item.u_status != DefaultValues.Delete) {
            String name = item.name.toLowerCase();
            String searchTerm = searchText.toLowerCase();
            if (name.startsWith(searchTerm)) {
              dataList.add(item);
            }
          }
        }
      }
      return dataList;
    } catch (e) {
      print("Error in $box: $e");
      return [];
    }
  }
  Future<List> getAllDataShortAdvice(box, searchText) async {
    try {
      List dataList = [];

      if (searchText.isEmpty) {
        dataList.clear();
        for (int i = 0; i <await box.length; i++) {
          var item = await box.getAt(i);
          dataList.add(item);
        }
        return dataList;
      } else {
        dataList.clear();
        for (int i = 0; i < box.length; i++) {
          var item = await box.getAt(i);
          if (item != null &&
              item.u_status != 2 &&
              (item.label.toLowerCase().contains(searchText.toLowerCase()))) {
            dataList.add(item);
          }
          dataList.reversed;
        }
        return dataList;
      }
    } catch (e) {
      _logger.e("Error in getAllDataShortAdvice: $e");
      return [];
    }
  }
///----------------------------End----------------------------------//






}
