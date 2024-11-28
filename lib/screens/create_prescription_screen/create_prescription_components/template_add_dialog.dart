import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/prescription_template/prescription_template_controller.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';

import '../../../controller/create_prescription/prescription/prescription_controller.dart';

  addTemplate(context, fieldName, screenWidth, screenHeight) {
    final PrescriptionTemplateController prescriptionTemplateController = Get.put(PrescriptionTemplateController());
    final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(fieldName),
        content: Container(
          // color: Colors.white,
          child: SingleChildScrollView(
            child: Column( 
              children: [
                Container(
                  width: screenWidth * 0.3,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column( 
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ListView.builder(
                      //     itemCount: 2,
                      //     itemBuilder: (context, index){
                      //       return Card(
                      //         child: Text("Des"),
                      //       );
                      //     }
                      // )
                  
                      for(var template in prescriptionTemplateController.prescriptionTemplateList)
                        Column(
                          children: [
                  
                            Card(
                              child: Row(
                                children: [
                                  FilledButton(onPressed: ()async{
                                     if(template.id !=-1){
                                      await prescriptionController.getSingleTemplateData(template.id);
                                     }
                                     Helpers.successSnackBar("Success", "Template data added to prescription");
                                     Navigator.pop(context);
                                  }, child: const Text("Add")),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(template.template_name),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Close'),
              )
            ],
          ),
        ],
      );
    },
  );
}
