
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/prescription_controller.dart';
import 'package:dims_vet_rx/models/investigation_report/investigation_report_model.dart';
import 'package:dims_vet_rx/models/on_examination/on_examination_model.dart';

import '../../../../database/hive_get_boxes.dart';
import '../../../../utilities/helpers.dart';

class CustomFindingsController extends GetxController{
  final prescriptionController = Get.put(PrescriptionController());
  final boxCustomFindings = Boxes.getKeyValuePayerField();
  final isCustomFindingsDataExist = false.obs;
  final keyOe = 'customFindingsOe';
  final keyIr = 'customFindingsIr';
  final findingsName = TextEditingController();
  final findingsValue = TextEditingController();
  final findingsNote = TextEditingController();
  RxList findingsList = [

  ].obs;

  Future<void> saveToPrescription(mainKey)async{
    for(var element in findingsList){
      if(element['name'] != '' && element['value'] != '' && mainKey == element['mainKey']){
        if(element['mainKey'] == keyOe){
          // prescriptionController.selectedOnExamination.where((element) => element.name == element['name'] + " : " + element['value'] + ' ' + element['note']).first;
          OnExaminationModel oeModel =  OnExaminationModel(id: 0, name: element['name'] + " : " + element['value'] + ' ' + element['note']);
          prescriptionController.selectedOnExamination.add(oeModel);
        }else if(element['mainKey'] == keyIr){
          InvestigationReportModel irModel =  InvestigationReportModel(id: 0, name: element['name'] + " : " + element['value'] + ' ' + element['note']);
          prescriptionController.selectedInvestigationReport.add(irModel);
        }
      }
    }
    isCustomFindingsDataExist.value = true;
  }
  Future findingOptionCreate(context,mainKey)async{
    print(mainKey);
    if(findingsName.text == ''){
      return Helpers.errorSnackBarDuration("Failed", "Please Enter Name", 2000);
    }else{
      // findingsList.add({
      //   'name': findingsName.text,
      //   'value': findingsValue.text,
      //   'note': findingsNote.text,
      // });
      var dataField = {
        'mainKey':  mainKey,
        "name": findingsName.text,
        "value": findingsValue.text,
        "note": findingsNote.text,

      };

      var dataFieldJson = jsonEncode(dataField);
      final dataFieldJsonMap = jsonDecode(dataFieldJson) as Map<String, dynamic>;
      await boxCustomFindings.add(dataFieldJsonMap);
      await getKeyValuePayerField(mainKey);
      findingsName.clear();
      findingsValue.clear();
      findingsNote.clear();
    }
  }

  Future getKeyValuePayerField(key)async{
    var response = await boxCustomFindings.values.toList();
    if (response.isNotEmpty) {
      for (var item in response) {
          // Convert the fields to String to ensure type compatibility
          var newEntry = {
            'mainKey': item['mainKey'].toString(),
            'name': item['name'].toString(),
            'value': item['value'].toString(),
            'note': item['note'].toString(),
          };

          // Check if the entry already exists in findingsList
          bool exists = findingsList.any((existingItem) =>
          existingItem['name'] == newEntry['name'] &&
              existingItem['value'] == newEntry['value'] &&
              existingItem['note'] == newEntry['note']
          );

          // If it doesn't exist, add the new entry
          if (!exists) {
            findingsList.add(newEntry);
          }

      }
    }


  }
  Future initialCall()async{
    getKeyValuePayerField('');
  }
  @override
  // TODO: implement initialized
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initialCall();
  }
}