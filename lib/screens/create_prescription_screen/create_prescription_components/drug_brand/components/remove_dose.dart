
import 'package:flutter/material.dart';

import '../../../../../controller/create_prescription/prescription/prescription_controller.dart';




SizedBox removeDose(int i, drugData, PrescriptionController prescriptionController) {
  return SizedBox(
    height: 35,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Dose: ${i + 1}", style: const TextStyle(color: Colors.black26),),
        IconButton(
            onPressed: () {
              var doseDel = drugData['dose'].removeAt(i);
              prescriptionController.selectedMedicine.refresh();
              prescriptionController.modifyDrugData.refresh();
              prescriptionController.favoriteDrugList.refresh();
            },
            icon:  const Icon(Icons.delete, color: Colors.red,)),
      ],
    ),
  );
}