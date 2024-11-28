

import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';

import '../../database/hive_get_boxes.dart';

class DataOrderingController extends GetxController{
  final boxDataOrdering = Boxes.getDataOrdering();
  RxString clinicalDataHomePage = "clinicalDataHomePage".obs;
  RxString patientInfoPrintPage = "patientInfoPrintPage".obs;
  RxList dataOrdering =[
    {
      "title": "Chief Complains",
      "value": "1",
    },
    {
      "title": "On Examination",
      "value": "2",
    },
    {
      "title": "Diagnosis",
      "value": "3",
    },
    {
      "title": "Investigation Advice",
      "value": "4",
    },
    {
      "title": "Investigation Report",
      "value": "5",
    },
    {
      "title": "History Hx",
      "value": "6",
    },
    {
      "title": "Child History",
      "value": "7",
    },{
      "title": "Gyn And Obs",
      "value": "8",
    },{
      "title": "Immunization",
      "value": "9",
    },{
      "title": "Treatment Plan",
      "value": "10",
    },{
      "title": "Physician Note",
      "value": "11",
    },{
      "title": "Referral Short",
      "value": "12",
    },{
      "title": "Procedure",
      "value": "13",
    },{
      "title": "Investigation I/R Image",
      "value": "14",
    },
    {
      "title": "Patient Disease Image",
      "value": "15",
    },
  ].obs;
  RxList patientInfoOrderingForPrint =[
    {
      "title": "Patient Id",
      "value": "1",
    },
    {
      "title": "Name",
      "value": "2",
    },
    {
      "title": "Age",
      "value": "3",
    },
    {
      "title": "Gender",
      "value": "4",
    },
    {
      "title": "Date",
      "value": "5",
    },

  ].obs;
  Future<void>saveOrderingData()async{
    await saveClinicalHomeDataOrdering();
    Helpers.successSnackBar("Success", "Data saved successfully");
    await getOrderingData();
  }
  Future<void> saveClinicalHomeDataOrdering()async{
    Map<String, dynamic> dataOrderingMap = Map.fromIterable(dataOrdering, key: (e) => e['title'], value: (e) => e['value']);
    var jsonClinicalDataHome = jsonEncode(dataOrderingMap);
    final jsonClinicalDataHomeJsonMAp = jsonDecode(jsonClinicalDataHome) as Map<String, dynamic>;
    await boxDataOrdering.put(clinicalDataHomePage.value, jsonClinicalDataHomeJsonMAp);
  }
  Future<void> savePatientPrintDataOrdering()async{
    Map<String, dynamic> dataPatientPrintOrderingMap = Map.fromIterable(patientInfoOrderingForPrint, key: (e) => e['title'], value: (e) => e['value']);
    var jsonPatientPrintOrderingMap = jsonEncode(dataPatientPrintOrderingMap);
    final jsonPatientPrintOrderingJsonMap = jsonDecode(jsonPatientPrintOrderingMap) as Map<String, dynamic>;
    await boxDataOrdering.put(patientInfoPrintPage.value, jsonPatientPrintOrderingJsonMap);
  }
  Future<void>getOrderingData()async{
    await getClinicalHomeDataOrdering();
  }
  Future<void>getClinicalHomeDataOrdering()async{
    var jsonClinicalDataHome = await boxDataOrdering.get(clinicalDataHomePage.value);
    if(jsonClinicalDataHome != null){
      for(var item in dataOrdering){
        for (var itemJson in jsonClinicalDataHome.entries) {
          // itemJson is a MapEntry, so you access the key and value directly
          if (item['title'] == itemJson.key) {
            item['value'] = itemJson.value;
          }
        }
      }
    }else{
      await saveClinicalHomeDataOrdering();
    }
  }Future<void>getPatientInfoPrintOrdering()async{
    var jsonPatientInfoPrintPage = await boxDataOrdering.get(patientInfoPrintPage.value);
    if(jsonPatientInfoPrintPage != null){
      for(var item in dataOrdering){
        for (var itemJson in jsonPatientInfoPrintPage.entries) {
          // itemJson is a MapEntry, so you access the key and value directly
          if (item['title'] == itemJson.key) {
            item['value'] = itemJson.value;
          }
        }
      }
    }else{
      await savePatientPrintDataOrdering();
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getOrderingData();
  }
}