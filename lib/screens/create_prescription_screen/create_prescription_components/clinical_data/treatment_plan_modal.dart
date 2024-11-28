

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/treatment_plan/treatment_plan_controller.dart';
import 'package:dims_vet_rx/utilities/app_icons.dart';
import 'package:dims_vet_rx/utilities/app_strings.dart';

import '../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../utilities/default_value.dart';

selectedTreatmentPlan(context){
  PrescriptionController prescriptionController = Get.put(PrescriptionController());

  return Obx(() => Column(
    children: [
      Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text("Treatment Plan", style: const TextStyle(  color: Colors.black, fontWeight: FontWeight.bold),),
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
                treatmentPlanDialog(context);
              }, icon: Icon(Icons.add_box, size: Platform.isAndroid ? 30 : 25, color: Colors.black,),),
            ),
          ],
        ),
      ),
      if(prescriptionController.treatmentPlanX.value.isNotEmpty)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            maxLines: 5,
            controller: prescriptionController.treatmentPlan,
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
treatmentPlanDialog(context){
  PrescriptionController prescriptionController = Get.put(PrescriptionController());
  TreatmentPlanController treatmentPlanController = Get.put(TreatmentPlanController());
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Treatment Plan"),
          ElevatedButton(onPressed: (){
            createDialog(context);
          }, child: Text("Create New Plan")),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.clear))
        ],
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
                    for(var item in treatmentPlanController.dataList)
                      if(item.u_status != DefaultValues.Delete && item.u_status != DefaultValues.permanentDelete)
                      Column(
                        children: [
                         Card(
                           child: Row(
                             children: [
                               IconButton(onPressed: (){
                                 treatmentPlanController.deleteTreatmentPlan(item.id);
                               }, icon: Icon(Icons.delete)),
                               IconButton(onPressed: (){
                                 treatmentPlanController.nameController.text = item.name;
                                 treatmentPlanController.detailsController.text = item.details;
                                 createDialog(context,item.id);
                               }, icon: Icon(Icons.edit)),
                               FilledButton(onPressed: (){
                                 prescriptionController.treatmentPlanX.value = item.details;
                                 prescriptionController.treatmentPlan.text = prescriptionController.treatmentPlan.text + "\n" + item.details;

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
                    controller: prescriptionController.treatmentPlan,
                    maxLines: 6,
                    onChanged: (value){
                      prescriptionController.treatmentPlanX.value = value;
                      print(prescriptionController.treatmentPlanX.value );
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Write your treatment plan here....',
                        suffixIcon: IconButton(onPressed: (){
                          prescriptionController.treatmentPlan.clear();
                          prescriptionController.treatmentPlanX.value = "";
                        }, icon:  AppIcons.pAddClinicalData)
                    ),
                  ),

                ),


              ],),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                prescriptionController.treatmentPlanX.value = prescriptionController.treatmentPlan.text;
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
  TreatmentPlanController trePlanCont = Get.put(TreatmentPlanController());
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Create New Plan"),
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
              controller: trePlanCont.nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write name....',
                  suffixIcon: IconButton(onPressed: (){
                    trePlanCont.nameController.clear();
                  }, icon:  AppIcons.pAddClinicalData)
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: trePlanCont.detailsController,
              maxLines: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write your treatment plan here....',
                suffixIcon: IconButton(onPressed: (){
                  trePlanCont.detailsController.clear();
                }, icon:  AppIcons.pAddClinicalData)
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(onPressed: (){
          if(id == 0){
            trePlanCont.saveAndEditTreatmentPlan(trePlanCont.boxTreatmentPlan.length + 1, CRUD.add);
          }else{
            trePlanCont.saveAndEditTreatmentPlan(id, CRUD.update);
          }

          Navigator.pop(context);

        }, child: Text("Save")
        )],
    );
  });
}
