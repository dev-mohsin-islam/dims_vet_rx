

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_screen.dart';

import '../../../../../controller/create_prescription/prescription/prescription_controller.dart';

Row drugAddToPrescription(PrescriptionController prescriptionController, drugData, changeType) {

  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      const SizedBox(width: 10,),
      FilledButton.icon(
          onPressed: () async{
            // if(index != -1 && index !=null){
            //   prescriptionController.selectedMedicine[index]['dose'].clear();
            //   prescriptionController.selectedMedicine[index]['duration'].clear();
            //   prescriptionController.selectedMedicine[index]['instruction'].clear();
            // }
            /// how to find specific brand index from a list of map
            ///


            prescriptionController.brandSearchController.clear();
            //prescriptionController.getAllBrandData('');
            // prescriptionController.modifyDrugData.clear();
            if(!Platform.isAndroid){
              prescriptionController.getAllBrandData('');
              prescriptionController.modifyDrugData.clear();
            }
            if(Platform.isAndroid){
              // prescriptionController.getAllBrandData('');
              prescriptionController.brandSearchText.value = '';
            }
            prescriptionController.isExpanded.value = false;
            prescriptionController.selectedBrandId.value = 0;
            prescriptionController.onSelectedMedicine(drugData, changeType);
            // Navigator.pop(Get.context!);
           // if(!Platform.isAndroid){
           //   Get.back();
           // }

          },
          icon: const Icon(Icons.save),
          label: const Text("Add to Prescription")),

    ],);
}