

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/prescription_template/prescription_template_controller.dart';

import '../../../controller/create_prescription/prescription/prescription_controller.dart';

Future saveAsTemplateDialog(context){
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final PrescriptionTemplateController prescriptionTemplateController = Get.put(PrescriptionTemplateController());

  return  Get.defaultDialog(
      barrierDismissible: true,
      title: "Save as Template",
      textConfirm: "Save",
    textCancel: "Close",
    content: Column(
      children: [
        TextFormField(
          controller: prescriptionTemplateController.templateNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Write template name",
          ),
        )
      ],
    ),
   onConfirm: ()async{
     await prescriptionController.clinicalDataConvertToString();
     var prescriptionDataMap = {
       "selectedMedicine": prescriptionController.selectedMedicine,
       "selectedChiefComplain": prescriptionController.selectedChiefComplainString,
       "selectedDiagnosis": prescriptionController.selectedDiagnosisString,
       "selectedOnExamination": prescriptionController.selectedOnExaminationString,
       "selectedInvestigationAdvice": prescriptionController.selectedInvestigationAdviceString,
       "note": prescriptionController.selectedShortAdviceString,
     };
     await prescriptionTemplateController.addTemplateData(context, prescriptionDataMap);
   }
  );
}