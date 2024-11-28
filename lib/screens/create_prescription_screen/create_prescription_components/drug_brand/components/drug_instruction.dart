

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:dims_vet_rx/models/instruction/instruction_model.dart';

import '../../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../../controller/instruction/instruction_controller.dart';
import '../../../../common_screen/common_screen_widget.dart';


SizedBox drugInstruction(drugData, int i, RxList<dynamic> instructionList, PrescriptionController prescriptionController) {
  final instructionController = Get.put(InstructionController());
  if(drugData['dose'][i]['instruction'] != null && drugData['dose'][i]['instruction'] != ''){
    var exist =  instructionList.any((element) => element.name ==drugData['dose'][i]['instruction']);
    if(!exist) {
      instructionList.add(InstructionModel( id: instructionList.length, name: drugData['dose'][i]['instruction']));
    }
  }

  RxList newInstructionList = [].obs;
  instructionList.forEach((element) {
    if (newInstructionList.contains(element.name)) {
      print("Duplicate found: ${element.name}");
    } else {
      newInstructionList.add(element.name);
    }
  });


  return SizedBox(
    child: Card(
      color: drugData['dose'][i]['instruction'] == '' ? Colors.brown[200] : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Tooltip(
                message: "Create new instruction",
                child: IconButton(onPressed: (){
                  newAddAndUpdateDialog(Get.context, 0, instructionController);
                }, icon: Icon(Icons.add)),
              ),
              // const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
              //     child: Text("Instruction:")
              // ),
            ],
          ),
          Obx(() =>   Flexible(
            child: DropdownButton(
                isExpanded: true,
                itemHeight: null,
                underline: Container(),
                value:  drugData['dose'][i]['instruction'] == null ? '' : drugData['dose'][i]['instruction'],
                items:  [
                  const DropdownMenuItem(value: '', child: Text("Instruction")),
                  for(var instruction in newInstructionList)
                    DropdownMenuItem(value: "${instruction}", child: Text("${instruction}")),
                ],
                onChanged: (value) {
                  prescriptionController.onChangeDoseAdd(drugData['brand_id'],i,'instruction', value);
                }),
          ))
        ],
      ),
    ),
  );
}

