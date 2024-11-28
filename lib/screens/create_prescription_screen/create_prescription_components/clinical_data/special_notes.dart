



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/prescription_controller.dart';

import '../../../../utilities/app_icons.dart';

specialNotesPlanDialog(context){
  PrescriptionController prescriptionController = Get.put(PrescriptionController());
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Physician Notes"),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.clear))
        ],
      ),
      actions: [
        ElevatedButton(onPressed: (){
            Navigator.pop(context);
        }, child: Text("Save"))
      ],
      content: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            children: [
              TextField(
                controller: prescriptionController.specialNotes,
                maxLines: 6,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write your notes here....',
                    suffixIcon: IconButton(onPressed: (){
                      prescriptionController.specialNotes.clear();
                    }, icon:  AppIcons.pAddClinicalData)
                ),
              ),

            ],
          ),
        ),
      ),
    );
  });
}