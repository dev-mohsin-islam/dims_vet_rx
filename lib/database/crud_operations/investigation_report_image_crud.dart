import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../../utilities/helpers.dart';

class InvestigationReportImageCRUDController {
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

  Future<bool?> saveInvestigationReportImage(box, object) async {
    var appointmentId = object.app_id;
    var title = object.title;
    var date = object.date;
    var inv_name = object.inv_name;

    try {
      if (inv_name.toString().isNotEmpty) {
        var check = await box.values.toList().indexWhere((data) => data.date == date && data.app_id == appointmentId && data.title == title && data.inv_name == inv_name);
        if(check == -1){
          var index = await box.add(object);
          object.id = index;
          box.putAt(index, object);
          Helpers.successSnackBar("Success!", "Added successfully");
          _logger.i('Success');
        } else {
          _logger.i("Failed! Data already exists");
        }
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


  Future<List> getInvestigationImage(box, searchText) async {

    try {
      List dataList = [];
      for (int i = 0; i <await box.length; i++) {
        var item = await box.getAt(i);
        if(item.app_id == searchText){
          dataList.add(item);
        }
      }
        return dataList;

    } catch (e) {
      _logger.e("Error in getAllDataCommon: $e");
      return [];
    }
  }



}
