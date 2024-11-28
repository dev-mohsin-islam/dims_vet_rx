

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../../controller/create_prescription/prescription/prescription_controller.dart';



SizedBox drugNoteComment( drugData, int i,prescriptionController) {
   print(drugData['dose'][i]);
  return SizedBox(
    height: 70,
    child: Card(
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text("Write Comments:")),
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: drugData['brand_id'] == null ? '' : drugData['dose'][i]['comment'],
                    onChanged: (value){
                      prescriptionController.onChangeDoseAdd(drugData['brand_id'],i,'comment', value);
                    },
                    decoration: const InputDecoration(
                        hintText: "Edg: If you have a fever, take this medicine",
                        border: OutlineInputBorder()),
                  ),
                ))
          ],
        ),
      ),
    ),
  );
}