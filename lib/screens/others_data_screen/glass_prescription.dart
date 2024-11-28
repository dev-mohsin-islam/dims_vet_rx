

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/create_prescription/prescription/methods/glass_prescription_controller.dart';

class GlassPrescription extends StatelessWidget {
  const GlassPrescription({super.key});

  @override
  Widget build(BuildContext context) {
    final glassPrescriptionController = Get.put(GlassPrescriptionController());
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text("Glass Prescription", style: const TextStyle(  color: Colors.black, fontWeight: FontWeight.bold),),
          ),
          IconButton(onPressed: (){
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  actions: [
                    FilledButton(onPressed: (){
                      glassPrescriptionController.isDataExist.value = true;
                      Navigator.pop(context);
                    }, child: Text("Save")),
                    // FilledButton(onPressed: (), child: child)
                  ],
                  title:   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Glass Prescription"),
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: Icon(Icons.close))
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Obx(() => Column(
                      children: [

                        Column(
                          children: [
                            Text("DISTANCE", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),),
                            Card(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Right Eye", style: TextStyle(color: Colors.blue),),
                                  ),
                                  Expanded(child: inputField(glassPrescriptionController.drSphereController, "Sphere")),
                                  Expanded(child: inputField(glassPrescriptionController.drCylinderController, "Cylinder")),
                                  Expanded(child: inputField(glassPrescriptionController.drAxisController, "Axis")),
                                  Expanded(child: inputField(glassPrescriptionController.drVAController, "V/A")),
                                ],
                              ),
                            ),
                            Card(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Left Eye", style: TextStyle(color: Colors.blue),),
                                  ),
                                  Expanded(child: inputField(glassPrescriptionController.dlSphereController, "Sphere")),
                                  Expanded(child: inputField(glassPrescriptionController.dlCylinderController, "Cylinder")),
                                  Expanded(child: inputField(glassPrescriptionController.dlAxisController, "Axis")),
                                  Expanded(child: inputField(glassPrescriptionController.dlVAController, "V/A")),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Column(
                          children: [
                            Text("NEAR ADD", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),),
                            Card(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Right Eye: ", style: TextStyle(color: Colors.blue),),
                                  ),
                                  Expanded(child: inputField(glassPrescriptionController.nrSphereController, "Sphere")),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Left Eye: ", style: TextStyle(color: Colors.blue),),
                                  ),
                                  Expanded(child: inputField(glassPrescriptionController.nlSphereController, "Sphere")),
                                ],

                              ),
                            ),

                          ],
                        ),
                        Divider(),
                        Column(
                          children: [
                            Text("Remarks", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),),
                            Wrap(
                              spacing: 10,
                              runSpacing: 5,
                              children: [
                                for(var item in glassPrescriptionController.remarks)
                                  FilterChip(
                                      selected: glassPrescriptionController.selectedRemarks.contains(item),
                                      label: Text("${item}"), onSelected: (value) {
                                        glassPrescriptionController.selectedRemarks.contains(item) ? glassPrescriptionController.selectedRemarks.remove(item) : glassPrescriptionController.selectedRemarks.add(item);
                                  }),

                              ],
                            ),
                            SizedBox(height: 10,),


                          ],
                        ),
                        Divider(),
                        Column(
                          children: [
                            Text("For", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),),
                            Wrap(
                              spacing: 10,
                              children: [
                                for(var item in glassPrescriptionController.forData)
                                  FilterChip(
                                      selected: glassPrescriptionController.selectedFor.contains(item),
                                      label: Text("${item}"), onSelected: (value) {
                                    glassPrescriptionController.selectedFor.contains(item) ? glassPrescriptionController.selectedFor.remove(item) : glassPrescriptionController.selectedFor.add(item);
                                  }),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Card(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("IPD (mm): "),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: glassPrescriptionController.ipdController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "IPD",
                                        suffix: Text("mm"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                  ),
                );
              },
            );

          }, icon: Icon(Icons.add_box, size: Platform.isAndroid ? 30 : 25, color: Colors.black,),),

        ],
      ),
    );
  }

    inputField(TextEditingController drSphereController, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
            width: 100,
            child: TextField(
              controller: drSphereController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: label,
              ),
            ),
          ),
    );
  }
}
