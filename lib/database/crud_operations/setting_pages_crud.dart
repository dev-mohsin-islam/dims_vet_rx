import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart'; // Import the logger package
import '../../utilities/helpers.dart';

class SettingPagesCRUDController {
  final Logger _logger = Logger(); // Create a logger instance

  Future<bool?> deleteCommon(box, id, u_status) async {
    var index = await box.values.toList().indexWhere((data) => data.id == id);
    try {
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
    var index = await box.values.toList().indexWhere((data) => data.id == id);
    if (index != -1) {
      await box.deleteAt(index)!;
      _logger.i('Success');
      return true;
    } else {
      _logger.w("Invalid index");
      return false;
    }
  }

  Future<bool?> saveCommon(box, object) async {
    try {
      if (object.uuid != null) {
        box.add(object);
        _logger.i("Success! Added successfully");
        return true;
      } else {
        _logger.w("UUID must not be empty");
        return false;
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
        }
        _logger.i("Success! Update successfully");
        return true;
      } else {
        _logger.w("Failed! Something went wrong. Field must not be empty $box");
        return false;
      }
    } catch (e) {
      _logger.e("Error in updateCommon: $e");
    }
    return null;
  }

  Future<List> getAllData(box, searchText) async {
    List dataList = [];
    try {
      if (searchText.isEmpty) {
        dataList.clear();
        for (int i = 0; i < box.length; i++) {
          var item = await box.getAt(i);
          dataList.add(item);
        }
      }
      _logger.i("Success! Retrieved data");
    } catch (e) {
      _logger.e("Error in getAllData: $e");
    }
    return dataList;
  }
}
