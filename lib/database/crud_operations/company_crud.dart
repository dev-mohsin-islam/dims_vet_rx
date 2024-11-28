
import 'package:flutter/foundation.dart';
import 'package:dims_vet_rx/utilities/default_value.dart';

import '../../utilities/helpers.dart';



class CompanyCrudController {

  Future<bool?> deleteCommon(box, id, u_status) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.id == id);
      if (index != -1 && u_status == 3) {
        var existingData = await box.getAt(index)!;
        existingData.u_status = u_status;
        await box.putAt(index, existingData);
        if (kDebugMode) {
          print('Success in deleteCommon');
        }
        return true;
      } else {
        if (kDebugMode) {
          print("Invalid index in deleteCommon");
        }
        return false;
      }
    } catch (e) {
      print("Error in deleteCommon: $e");
      // Handle the error or log it based on your requirements.
      // Example: Notify the user or write to a log file.
      return false;
    }
  }

  Future<bool?> deletePermanentCommon(box, id, status) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.id == id);
      if (index != -1) {
        await box.deleteAt(index)!;
        if (kDebugMode) {
          print('Success in deletePermanentCommon');
        }
        return true;
      } else {
        if (kDebugMode) {
          print("Invalid index in deletePermanentCommon");
        }
        return false;
      }
    } catch (e) {
      print("Error in deletePermanentCommon: $e");

      Helpers.errorSnackBar("Failed", "Something went wrong");
      return false;
    }
  }

  Future<bool?> saveCompany(boxCompany, object) async {
    try {
      List companyList = await boxCompany.values.toList();
      dynamic maxValue = companyList.map((e) => e.id).reduce((a, b) => a > b ? a : b);
      object.id = maxValue + 1;
        var index = await boxCompany.add(object);
        if(index != -1){
          Helpers.successSnackBar("Success!", "Added successfully");
          return true;
        } else {
          Helpers.errorSnackBar("Failed!", "Something went wrong");
          if (kDebugMode) {
            print("Field must be not empty $boxCompany");
          }
          return false;
        }
    } catch (e) {
      print("Error in saveCommon: $e");
      Helpers.errorSnackBar("Failed", "Something went wrong");
      return false;
    }
  }
 

  Future<bool?> updateCompany(box, id, nameController, statusUpdate) async {
    try {

        var updateValue = nameController;
        final index = await box.values.toList().indexWhere((data) => data.id == id);
        if (index !=-1) {
          var existingData = await box.getAt(index)!;
          var u_status = existingData.u_status;
          if(u_status == DefaultValues.NewAdd){
            existingData.company_name = updateValue;
            await box.putAt(index, existingData);

          }else if(u_status == DefaultValues.Synced){
            existingData.company_name = updateValue;
            existingData.u_status = DefaultValues.NewAdd;
            await box.putAt(index, existingData);
          }
          Helpers.successSnackBar("Success!", "Update successfully");
          return true;
        } else {
          Helpers.errorSnackBar("Failed!", "Invalid index or update value in updateCompany");
          if (kDebugMode) {
            print("Invalid index or update value in updateCompany");
          }
          return false;
        }

    } catch (e) {
      print("Error in updateCompany: $e");
      Helpers.errorSnackBar("Failed", "Something went wrong");
      return false;
    }
  }

  Future<List> getAllDataCompany(box, searchText) async {
    print(searchText);
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
          if (item != null && (item.company_name.toLowerCase().contains(searchText.toLowerCase()))) {
            dataList.add(item);
          }
        }
        dataList = dataList.reversed.toList();
        return dataList;
      }
    } catch (e) {
      print("Error in getAllDataCompany: $e");
      Helpers.errorSnackBar("Failed", "Something went wrong");
      return [];
    }
  }
}
