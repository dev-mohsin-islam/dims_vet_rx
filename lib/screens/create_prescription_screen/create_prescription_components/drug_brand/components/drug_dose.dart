

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:dims_vet_rx/controller/dose/dose_controller.dart';
import 'package:dims_vet_rx/models/dose/dose_model.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/drug_brand/components/related_defualt_data_modal.dart';

import '../../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../common_screen/common_screen_widget.dart';

SizedBox drugDose(drugData, int i, RxList<dynamic> doseList, PrescriptionController prescriptionController) {
  final doseController = Get.put(DoseController());
  if(drugData['dose'][i]['dose'] != null && drugData['dose'][i]['dose'] != ''){
    var exist =  doseList.any((element) => element.name ==drugData['dose'][i]['dose']);
    if(!exist) {
      doseList.add(DoseModel(id: doseList.length+1, name:  drugData['dose'][i]['dose']));
    }
  }
  RxList newDoseList = [].obs;
  doseList.forEach((element) {
    if (newDoseList.contains(element.name)) {
      print("Duplicate found: ${element.name}");
    } else {
      newDoseList.add(element.name);
    }
  });
  return SizedBox( 
    child: SingleChildScrollView(
      child: Card(
        color: drugData['dose'][i]['dose'] == '' ? Colors.brown[200] : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Tooltip(
                  message: "Create new dose",
                  child: IconButton(onPressed: (){
                    // newAddAndUpdateDialog(Get.context, 0, doseController);
                    // brandDefaultModel(Get.context);
                  }, icon: Icon(Icons.add)),
                ),
      
                // const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
                //     child: Text("Dose: ")
                // ),
              ],
            ),
      
            Obx(() =>   Flexible(
              fit: FlexFit.tight,
              child: DropdownButton(
                  isExpanded: true,
                  itemHeight: null,
                  underline: Container(),
                  value: drugData['dose'][i]['dose'] == null ? '' : drugData['dose'][i]['dose'],
                  items:  [
                    if(drugData['dose'][i]['dose'] == '')
                    DropdownMenuItem(value: '', child: Text("Dose")),
                    for(var dose in newDoseList)
                      DropdownMenuItem(value: "${dose}", child: Text("${dose}")),
                  ],
                  onChanged: (value) {
                    prescriptionController.onChangeDoseAdd(drugData['brand_id'],i,'dose', value);
                  }),
            )),
      
          ],
        ),
      ),
    ),
  );
}