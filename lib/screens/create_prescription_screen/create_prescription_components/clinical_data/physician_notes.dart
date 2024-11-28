



import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/physician_note/TreatmentPlanController.dart';
import 'package:dims_vet_rx/controller/treatment_plan/treatment_plan_controller.dart';
import 'package:dims_vet_rx/utilities/app_icons.dart';
import 'package:dims_vet_rx/utilities/app_strings.dart';

import '../../../../controller/create_prescription/prescription/prescription_controller.dart';

selectedPhysicianNotes(context){
  PrescriptionController prescriptionController = Get.put(PrescriptionController());

  return Obx(() => Column(
    children: [
      Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text("Physician Notes", style: const TextStyle(  color: Colors.black, fontWeight: FontWeight.bold),),
            ),),
            // ElevatedButton(onPressed: (){
            //   treatmentPlanDialog(context);
            // }, child: Text("View Plans")),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: Colors.black
              ),
              child: IconButton(onPressed: () async {
                physicianNotesDialog(context);
              }, icon: Icon(Icons.add_box, size: Platform.isAndroid ? 30 : 25, color: Colors.black,),),
            ),
          ],
        ),
      ),
      if(prescriptionController.specialNotesX.value.isNotEmpty)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            maxLines: 5,
            controller: prescriptionController.specialNotes,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        )
    ],
  ));

}
physicianNotesDialog(context){
  PrescriptionController prescriptionController = Get.put(PrescriptionController());
  PhysicianNoteController physicianNoteController = Get.put(PhysicianNoteController());
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: ListTile(
        title: Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 5,
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text("Physician Note"),
            ElevatedButton(onPressed: (){
              createDialog(context);
            }, child: Text("Create New Note")),
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.clear))
          ],
        ),
      ),


      content: Center(
        child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Obx(() => Column(

              children: [

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Expanded(child: Text("Treatment Plan",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
                    // Text(treatmentPlanController.dataList.length.toString()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for(var item in physicianNoteController.dataList)
                          Column(
                            children: [
                              Card(
                                child: Row(
                                  children: [
                                    IconButton(onPressed: (){
                                      physicianNoteController.deletePhysicianNote(item.id);
                                    }, icon: Icon(Icons.delete)),

                                    IconButton(onPressed: (){
                                      physicianNoteController.nameController.text = item.name;
                                      physicianNoteController.detailsController.text = item.details;
                                      createDialog(context,item.id);
                                    }, icon: Icon(Icons.edit)),
                                    FilledButton(onPressed: (){
                                      prescriptionController.specialNotesX.value = item.details;
                                      prescriptionController.specialNotes.text = prescriptionController.specialNotes.text.isNotEmpty ? prescriptionController.specialNotes.text + "\n" + item.details : item.details + "\n";

                                    }, child: Text(item.name)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                            ],
                          )

                      ],
                    ),

                    Expanded(
                      flex: 2,
                      child: TextField(
                        autofocus: true,
                        controller: prescriptionController.specialNotes,
                        maxLines: 6,
                        onChanged: (value){
                          prescriptionController.specialNotesX.value = value;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Write your note here....',
                            suffixIcon: IconButton(onPressed: (){
                              prescriptionController.specialNotes.clear();
                              prescriptionController.specialNotesX.value = "";
                            }, icon:  AppIcons.pAddClinicalData)
                        ),
                      ),

                    ),


                  ],),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: (){
                  prescriptionController.specialNotesX.value = prescriptionController.specialNotes.text;
                  Navigator.pop(context);
                }, child: Text("Done"))

              ],
            ),)
        ),
      ),
    );
  });
}
createDialog(context,[id = 0]){
  PhysicianNoteController physicianNoteController = Get.put(PhysicianNoteController());
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Create New Note"),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.clear))
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          children: [
            TextField(
              controller: physicianNoteController.nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write name....',
                  suffixIcon: IconButton(onPressed: (){
                    physicianNoteController.nameController.clear();
                  }, icon:  AppIcons.pAddClinicalData)
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: physicianNoteController.detailsController,
              maxLines: 6,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write your note here....',
                  suffixIcon: IconButton(onPressed: (){
                    physicianNoteController.detailsController.clear();
                  }, icon:  AppIcons.pAddClinicalData)
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(onPressed: (){
          if(id == 0){
            physicianNoteController.saveAndEditPhysicianNote(physicianNoteController.boxPhysicianNote.length + 1, CRUD.add);
          }else{
            physicianNoteController.saveAndEditPhysicianNote(id, CRUD.update);
          }

          Navigator.pop(context);

        }, child: Text("Save")
        )],
    );
  });
}
