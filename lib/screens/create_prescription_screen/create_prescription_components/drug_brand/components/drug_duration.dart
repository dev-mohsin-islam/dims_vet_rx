

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:dims_vet_rx/controller/prescription_duration/prescription_duration_controller.dart';
import 'package:dims_vet_rx/models/create_prescription/prescription_duration/prescription_duration_model.dart';

import '../../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../common_screen/common_screen_widget.dart';

SizedBox drugDuration(drugData, int i, RxList<dynamic> durationList, PrescriptionController prescriptionController) {
  final durationController = Get.put(DurationController());
 if(drugData['dose'][i]['duration'] != null && drugData['dose'][i]['duration'] != '') {
   var exist =  durationList.any((element) => element.name == drugData['dose'][i]['duration']);
   if(!exist) {
     durationList.add(PrescriptionDurationModel(u_status: 1, id: durationList.length, name: drugData['dose'][i]['duration'], uuid: '', number: 0, type: '',));
   }
 }
 RxList newDurationList = [].obs;
 durationList.forEach((element) {
   if (newDurationList.contains(element.name)) {
     print("Duplicate found: ${element.name}");
   } else {
     newDurationList.add(element);
   }
 });


  return SizedBox(
    child: SingleChildScrollView(
      child: Card(
        color: drugData['dose'][i]['duration'] == '' ? Colors.brown[200] : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Row(
            children: [
              Tooltip(
                message: "Create new duration",
                child: IconButton(onPressed: (){
                  newAddAndUpdateDialog(Get.context, 0, durationController);
                }, icon: Icon(Icons.add)),
              ),
              // const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
              //     child: Text("Duration:")
              // ),
            ],
          ),
          Obx(() =>   Flexible(
            fit: FlexFit.tight,
            child: DropdownButton(
                isExpanded: true,
                underline: Container(),
                value: drugData['dose'][i]['duration'] == null ? '' : drugData['dose'][i]['duration'],
                items:  [
                  DropdownMenuItem(value: '', child: Text("Duration")),
                  for(var duration in newDurationList)
                    DropdownMenuItem(value: "${duration.name}", child: Text("${duration.name}", style: TextStyle(
                        color: duration.type != null && duration.type == 'মাস' ? Colors.blue : duration.type == 'সপ্তাহ' ? Colors.amber : duration.type == "দিন" ? Colors.redAccent : Colors.black
                    ),)),
                ],
                onChanged: (value) {
                  prescriptionController.onChangeDoseAdd(drugData['brand_id'],i,'duration', value);
            
                }),
          ))
          ],
        ),
      ),
    ),
  );
}