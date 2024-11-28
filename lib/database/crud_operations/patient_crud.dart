import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';

class PatientCRUDController {
  final Logger logger = Logger();

  Future<bool?> deleteCommon(box, id, u_status) async {
    var index = await box.values.toList().indexWhere((data) => data.id == id);
    try {
      if (index != -1 && u_status == 3) {
        var existingData = await box.getAt(index)!;
        existingData.u_status = u_status;
        await box.putAt(index, existingData);
        logger.i('Success');
        return true;
      } else {
        logger.w("Invalid index");
        return false;
      }
    } catch (e) {
      logger.e("Error in deleteCommon: $e");
      return null;
    }

  }

  Future<bool?> deletePermanentCommon(box, id, status) async {
    var index = await box.values.toList().indexWhere((data) => data.id == id);
    try {
      if (index != -1) {
        await box.deleteAt(index)!;
        logger.i('Success');
        return true;
      } else {
        logger.w("Invalid index");
        return false;
      }
    } catch (e) {
      logger.e("Error in deletePermanentCommon: $e");
    }
    return null;
  }

  Future<int?> savePatient(boxPatient, object) async {
    var phone = await object.phone.toString();
    int? patientId;
    if(object.id != null){
      patientId =await object.id;

    }
    try {
      if(await boxPatient.length != 0){

          if (patientId != -1 && patientId != 0 && patientId != null) {
             print("phone not empty");
             var existingIndex = await boxPatient.values.toList().indexWhere((data) => data.id == patientId);
             print("Patient Existing Index : $existingIndex");
             if(existingIndex != -1){
               var existingData = await boxPatient.getAt(existingIndex);
               await boxPatient.putAt(existingIndex, object);
               print("Patient existingIndex id : ${existingData.id} = ${object.id} = ${patientId}");
               return existingData.id;
             }else{
               print("Patient id not found but patient id is not  ${patientId}");
               Helpers.errorSnackBarDuration("Failed", "Something went wrong, Please try new patient", 1000);
               return null;
             }

          }else{
            List patientList = await boxPatient.values.toList();
            dynamic maxValue = patientList.map((e) => e.id).reduce((a, b) => a > b ? a : b);

            var Index = await boxPatient.add(object);
            if (Index != null && Index !=-1) {
              // var lastPatientIndex =  PreFixIds.defaultPrefixPatientId + await boxPatient.length + 1;
              // var idString = DefaultValues.identifier.toString() + lastPatientIndex.toString();
              // int id = parseInt(idString);
              print("Patient New Index : $Index");
              var existingDataForIDUpdate = await boxPatient.getAt(Index);
              existingDataForIDUpdate.id = await maxValue + 1;
              await boxPatient.putAt(Index, existingDataForIDUpdate);
              print("Patient New Id : ${existingDataForIDUpdate.id}");
              return existingDataForIDUpdate.id;
            }else{
              print("Create but index not found");
              return null;
            }
          }
      }else{
         var IndexEx = await boxPatient.add(object);
         if (IndexEx != null && IndexEx !=-1) {
           var lastPatientIndex =  PreFixIds.defaultPrefixPatientId + await boxPatient.length + 1;
           var idString = DefaultValues.identifier.toString() + lastPatientIndex.toString();
           int id = parseInt(idString);
           var existingDataForIDUpdate = await boxPatient.getAt(IndexEx);
           existingDataForIDUpdate.id = await id;
           await boxPatient.putAt(IndexEx, existingDataForIDUpdate);
           print("Added Patient -new Index : ${IndexEx}");
           print("Added Patient -new Id : ${existingDataForIDUpdate.id}");
           return existingDataForIDUpdate.id;
         }
      }

    } catch (e) {
      logger.e("Error in savePatient: $e");
      return null;
    }
    return null;

  }

  Future deleteOldestPatient(boxPatient) async {
    List oldList = [];
    try{
      var list = await getAllPatient(boxPatient, '');
      for (var i = 0; i < list.length; i++) {
        bool isSixMonths = await isSixMonthsOld(customParseDate(list[i].date));
        if(list[i].date != null && isSixMonths){
          // add to old list for deletion
          oldList.add(list[i]);
        }
      }

      // delete oldest
      for (var i = 0; i < oldList.length; i++) {
        var index = await boxPatient.values.toList().indexWhere((data) => data.id == oldList[i].id);
        if(index !=-1){
          print('Deleted Patient: ${oldList[i].name}');
          await boxPatient.deleteAt(index);
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

  Future<List> getAllPatient(box, searchText) async {
    List dataList = [];
    try {
      if (searchText.isEmpty) {
        for (int i = 0; i <await box.length; i++) {
          var item =await box.getAt(i);
          dataList.add(item);
        }
        logger.i('Success! Retrieved data');
        return dataList;
      } else {
        dataList.clear();
        for (int i = 0; i < await box.length; i++) {
          var item = await box.getAt(i);
          if (item != null && (item.name.toLowerCase().contains(searchText.toString().toLowerCase()) || item.phone.toString().toLowerCase().contains(searchText.toString().toLowerCase()) ||
                  item.id.toString().toLowerCase().contains(searchText.toString().toLowerCase()))) {
            dataList.add(item);

          }
        }

        return  dataList;
      }
    } catch (e) {
      logger.e("Error in get all patient data: $e");
      return [];
    }

  }
}
