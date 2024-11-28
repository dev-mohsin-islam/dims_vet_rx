import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../utilities/helpers.dart';

class GeneralSettingsCRUDController {
  final Logger _logger = Logger();

  Future<bool?> deleteCommon(box, object) async {
    var section = object.section;
    var label = object.label;
    try {
      int index = await box.values.toList().indexWhere((data) => data.section == section && data.label == label);
      if (index != -1) {
        await box.deleteAt(index);
        Helpers.successSnackBar("Success", "Successfully removed");
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

  Future<bool?> saveSettings(isDefault, box, object) async {
    var section = object.section;
    var label = object.label;
    try {
      var index  =await box.values.toList().indexWhere((data) =>data.section ==section && data.label == label);
      if (object.uuid != null && index !=-1) {
        var update =await box.put(index, object);
        return true;
      } else {
        await box.add(object);
        if(isDefault !=  true){
          Helpers.successSnackBar("Success!", "Added successfully");
        }
        _logger.i('Success');
        return true;
      }
    } catch (e) {
      _logger.e("Error in saveCommon: $e");
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

  Future<List> getAllDataCommon(box, searchText) async {
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
              item.u_status != 3 &&
              (item.name.toLowerCase().contains(searchText.toLowerCase()))) {
            dataList.add(item);
          }
          dataList.reversed;
        }
        return dataList;
      }
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
