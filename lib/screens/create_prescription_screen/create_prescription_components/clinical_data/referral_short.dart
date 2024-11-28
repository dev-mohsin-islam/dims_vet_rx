





import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/patient_referral_short/patient_referral_short_controller.dart';
import 'package:dims_vet_rx/utilities/app_icons.dart';
import 'package:dims_vet_rx/utilities/app_strings.dart';

import '../../../../controller/create_prescription/prescription/prescription_controller.dart';

selectedReferralShort(context){
  PrescriptionController prescriptionController = Get.put(PrescriptionController());
  return Obx(() => Column(
    children: [
      Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text("Referral Short", style: const TextStyle(  color: Colors.black, fontWeight: FontWeight.bold),),
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
                referralShortDialog(context);
              }, icon: Icon(Icons.add_box, size: Platform.isAndroid ? 30 : 25, color: Colors.black,),),
            ),
          ],
        ),
      ),
      if(prescriptionController.referralShortX.value.isNotEmpty)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            maxLines: 5,
            controller: prescriptionController.referralShort,
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
referralShortDialog(context){
  PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final referralShortController = Get.put(ReferralShortController());
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Referral"),
          ElevatedButton(onPressed: (){
            createDialog(context);
          }, child: Text("Create New Note")),
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
                        for(var item in referralShortController.dataList)
                          Column(
                            children: [
                              Card(
                                child: Row(
                                  children: [
                                    IconButton(onPressed: (){
                                      referralShortController.deleteReferralShort(item.id);
                                    }, icon: Icon(Icons.delete)),

                                    IconButton(onPressed: (){
                                      referralShortController.nameController.text = item.name;
                                      referralShortController.detailsController.text = item.details;
                                      createDialog(context,item.id);
                                    }, icon: Icon(Icons.edit)),

                                    FilledButton(onPressed: (){
                                      prescriptionController.referralShortX.value = item.details;
                                      print(item.details);
                                      prescriptionController.referralShort.text = prescriptionController.referralShort.text.isNotEmpty ? prescriptionController.referralShort.text + "\n" + item.details : item.details + "\n" ;

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
                        controller: prescriptionController.referralShort,
                        maxLines: 6,
                        onChanged: (value){
                          prescriptionController.referralShortX.value = value;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Write your note here....',
                            suffixIcon: IconButton(onPressed: (){
                              prescriptionController.referralShort.clear();
                              prescriptionController.referralShortX.value = "";
                            }, icon:  AppIcons.pAddClinicalData)
                        ),
                      ),

                    ),


                  ],),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: (){
                  prescriptionController.referralShortX.value = prescriptionController.referralShort.text;
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
  ReferralShortController referralShortController = Get.put(ReferralShortController());
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Create New Referral"),
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
              controller: referralShortController.nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write name....',
                  suffixIcon: IconButton(onPressed: (){
                    referralShortController.nameController.clear();
                  }, icon:  AppIcons.pAddClinicalData)
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: referralShortController.detailsController,
              maxLines: 6,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Write your note here....',
                  suffixIcon: IconButton(onPressed: (){
                    referralShortController.detailsController.clear();
                  }, icon:  AppIcons.pAddClinicalData)
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(onPressed: (){
          if(id == 0){
            referralShortController.saveAndEditReferralShort(referralShortController.boxReferralShort.length + 1, CRUD.add);
          }else{
            referralShortController.saveAndEditReferralShort(id, CRUD.update);
          }

          Navigator.pop(context);

        }, child: Text("Save")
        )],
    );
  });
}
