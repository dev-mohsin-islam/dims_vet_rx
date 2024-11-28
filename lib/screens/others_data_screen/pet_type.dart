

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/vet_controller/vet_controller.dart';

petType(context){
  final vetController = Get.put(VetController());
  showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          Text("Pet Type"),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Save & Close"))

        ],
      ),
      content: Container(
        width: Platform.isAndroid ? MediaQuery.of(context).size.width * 0.9 : 500,
        child: SingleChildScrollView(
          child: Obx(() => Column(
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 300,
                    child: TextField(
                      controller: vetController.petNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Write pet name here.."
                      ),
                    ),
                  ),
                  ElevatedButton(onPressed: (){
                    vetController.createPetType();
                  }, child: Text("Create New"))
                ],
              ),
               ListView.builder(
                shrinkWrap: true, itemCount: vetController.petTypeList.length,
                   itemBuilder: (context, index){
                     return Card(
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Obx(() => RadioMenuButton( 
                               value: vetController.petTypeList[index],
                               groupValue: vetController.selectedPetType.value,
                               onChanged: (value){ 
                                 vetController.selectedPetType.value = value.toString();
                                 vetController.selectedPetType.refresh();
                                 vetController.petTypeList.refresh();
                               },
                               child: Text(vetController.petTypeList[index])),),

                           IconButton(onPressed: (){
                             showDialog(context: context, builder: (context){
                               return AlertDialog(
                                 title: Text("Are you sure to delete ?"),
                                 actions: [
                                   ElevatedButton(onPressed: ()async{
                                    await vetController.deletePetType(vetController.petTypeList[index]);
                                     Navigator.pop(context);
                                   }, child: Text("Yes")),
                                   ElevatedButton(onPressed: (){
                                     Navigator.pop(context);
                                   }, child: Text("No"))
                                 ],
                               );
                             });
                           }, icon: Icon(Icons.delete_forever))

                           // Checkbox(
                           //   value: vetController.selectedPetType.value == vetController.petTypeList[index],
                           //   onChanged: (value){
                           //     vetController.selectedPetType.value = vetController.petTypeList[index];
                           //     Navigator.pop(context);
                           //   },
                           // ),

                         ],
                       ),
                     );
                   })
            ],
          )),
        ),
      ),
    );
  });
}