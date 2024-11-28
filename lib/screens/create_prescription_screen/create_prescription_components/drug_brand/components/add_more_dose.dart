


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controller/create_prescription/prescription/prescription_controller.dart';

IconButton  addDrugDose(PrescriptionController prescriptionController, drugData) {

  return  IconButton(
      onPressed: () {
        prescriptionController.addMoreDose(drugData['brand_id']);
        prescriptionController.modifyDrugData.refresh();
        prescriptionController.favoriteDrugList.refresh();
        prescriptionController.selectedMedicine.refresh();
      },
      icon: const Icon(Icons.add),
      tooltip: 'Add More dose'
  );
}