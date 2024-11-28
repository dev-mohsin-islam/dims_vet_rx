

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/drug_brand/components/drug_dose.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/drug_brand/components/drug_duration.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/drug_brand/components/drug_instruction.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/drug_brand/components/remove_dose.dart';

import '../../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../../controller/general_setting/general_setting_controller.dart';
import 'add_more_dose.dart';
import 'drug_add_to_prescription.dart';
import 'drug_note.dart';
import 'expansion_tile_title.dart';

  expansionTile(PrescriptionController prescriptionController, drugData, GeneralSettingController generalSettingController, RxList<dynamic> doseList, RxList<dynamic> durationList, RxList<dynamic> instructionList,changeType) {

  return  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     InkWell(
       onTap: (){
         if (changeType == 'changeCompany') {
           prescriptionController.onSelectedMedicine(drugData, changeType);
           prescriptionController.brandSearchController.clear();
           // pop
           Get.back();

         }else{
           prescriptionController.isExpanded.value = !prescriptionController.isExpanded.value;
           prescriptionController.selectedBrandId.value = drugData['brand_id'];
         }
       },
       child:  Padding(
         padding: const EdgeInsets.all(8.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
               SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                 child: Row(
                   mainAxisSize: MainAxisSize.max,
                   children: [
                     Tooltip(
                       message: "Add dose",
                       child: IconButton(
                         onPressed: () async {
                           if (changeType == 'changeCompany') {
                             prescriptionController.onSelectedMedicine(drugData, changeType);
                             prescriptionController.brandSearchController.clear();
                             // pop
                             Get.back();

                           }else{
                             prescriptionController.isExpanded.value = !prescriptionController.isExpanded.value;
                             prescriptionController.selectedBrandId.value = drugData['brand_id'];
                           }

                         },
                         icon: Icon(Icons.add_circle, color: Colors.green),
                       ),
                     ),
                     expansionTileTitle(drugData, generalSettingController),
                   ],
                 ),
               ),
             if (prescriptionController.isExpanded.value && prescriptionController.selectedBrandId.value == drugData['brand_id'])
               expansionChildren(drugData, doseList, prescriptionController, durationList, instructionList, changeType),
           ],
         ),
       ),
     )

    ],
  );
}



Wrap expansionChildren(drugData, RxList<dynamic> doseList, PrescriptionController prescriptionController, RxList<dynamic> durationList, RxList<dynamic> instructionList, changeType) {
  return Wrap(
    children: [
      for(var i =0; i<drugData['dose'].length; i++)
        Card(
          child: Container(
            width: 400,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),),
            child: Column(
              children: [
                drugDose(drugData, i, doseList, prescriptionController),
                drugDuration(drugData, i, durationList, prescriptionController),
                drugInstruction(drugData, i, instructionList, prescriptionController),
                drugNoteComment(drugData, i, prescriptionController,),
                removeDose(i, drugData, prescriptionController),
              ],
            ),
          ),
        ),
      addDrugDose(prescriptionController, drugData),
      drugAddToPrescription(prescriptionController, drugData, changeType),

    ],
  );
}



