import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../../utilities/helpers.dart';

class PatientDiseaseImageCRUDController {
  final Logger _logger = Logger();

  Future<bool?> deleteCommon(box, id, u_status) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.id == id);
      if (index != -1 && u_status == 3) {
        var existingData = await box.getAt(index)!;
        existingData.u_status = u_status;
        await box.putAt(index, existingData);
        _logger.i('Success');
        return true;
      } else {
        _logger.w("Invalid index");
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

  Future<bool?> savePatientDiseaseImage(box, object) async {
    var appointmentId = object.app_id;
    var title = object.title;
    var date = object.date;
    var disease_name = object.disease_name;

    try {
        var check = await box.values.toList().indexWhere((data) => data.date == date && data.app_id == appointmentId && data.title == title && data.disease_name == disease_name);
        if(check == -1){
          var index = await box.add(object);
          object.id = index;
          box.putAt(index, object);
          _logger.i('Success $box');
        } else {
          _logger.i('Image already exists $box');
        }
        return true;

    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }

  Future<bool?> updateCommon(box, id, nameController, statusUpdate) async {
    try {
      if (nameController.isNotEmpty) {
        var updateValue = nameController;
        final index = await box.values.toList().indexWhere((data) => data.id == id);
        if (index >= 0 && index < box.length && updateValue.toString().isNotEmpty) {
          var existingData = await box.getAt(index)!;
          existingData.name = updateValue;
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
        _logger.w("Field must not be empty");
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
        if (index >= 0 && index < box.length) {
          var existingData = await box.getAt(index)!;
          existingData.label = updateLabel;
          existingData.text = updateValueText;
          existingData.u_status = statusUpdate;
          await box.putAt(index, existingData);
          _logger.i('Success');
          Helpers.successSnackBar("Success!", "Update successfully");
          return true;
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

  Future<List> getAllDataCommon(box, searchText) async {
    try {
      List dataList = [];
      dataList.clear();
      for (int i = 0; i < box.length; i++) {
        var item = await box.getAt(i);
        if (item.app_id == searchText) {
          dataList.add(item);
        }
      }
        return dataList;

    } catch (e) {
      _logger.e("Error in getAllDataCommon: $e");
      return [];
    }
  }

  Future<List> getAllDataShortAdvice(box, searchText) async {
    try {
      List dataList = [];

      if (searchText.isEmpty) {
        dataList.clear();
        for (int i = 0; i < box.length; i++) {
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

}
