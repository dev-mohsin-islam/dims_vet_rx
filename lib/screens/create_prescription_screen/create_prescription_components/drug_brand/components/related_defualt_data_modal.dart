

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:dims_vet_rx/controller/drug_brand/drug_brand_controller.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';

brandDefaultModel(context, brandId){
  RxString selectedType = "SetDefault".obs;
  showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Obx(() => Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          // TextButton(
          //     onPressed: (){
          //       selectedType.value = "RelatedDose";
          //     }, child: Text("Related Dose", style: TextStyle(color: selectedType.value == "RelatedDose" ? Colors.blue : Colors.grey),)),
          TextButton(
              onPressed: (){
                selectedType.value = "SetDefault";
              }, child: Text("Set Default", style: TextStyle(color: selectedType.value == "SetDefault" ? Colors.blue : Colors.grey),)),
          // TextButton(onPressed: (){
          //   selectedType.value = "Custom";
          // }, child: Text("Custom", style: TextStyle(color: selectedType.value == "Custom" ? Colors.blue : Colors.grey),)),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.close))
        ],
      )),
      content: Container(
        height: 400,
        width: 400,
        child: Obx(() => Column(
          children: [

            Divider(color: Colors.black,),
            // if(selectedType.value == "RelatedDose")
            //   drugRelatedDose(context),
            if(selectedType.value == "SetDefault")
              setDefault(context, brandId),
            // if(selectedType.value == "Custom")
            //   customType(context),

          ],
        )),
      ),
    );
  });
}

setDefault(context, brandId){
  TextEditingController doseController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController instructionController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final drugBrandController = Get.put(DrugBrandController());
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      inputField("Write Dose here", doseController),
      SizedBox(height: 10,),
      inputField("Write Duration here", durationController),
      SizedBox(height: 10,),
      inputField("Write Instruction here", instructionController),
      SizedBox(height: 10,),
      inputField("Write Note here", noteController),
      SizedBox(height: 20,),
      FilledButton(onPressed: ()async{
        var response =await drugBrandController.insertDefaultDrugDoseDuration(brandId, doseController.text, durationController.text, instructionController.text, noteController.text);
        doseController.clear();
        durationController.clear();
        instructionController.clear();
        noteController.clear();
        Helpers.successSnackBar("Success", "Successfully Added");
        Navigator.pop(context);
      }, child: Text("Save"))
    ],
  );
}

Container inputField(label, TextEditingController textController) {
  return Container(
      width: 400,
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          suffix: IconButton(onPressed: (){
            textController.clear();
          }, icon: Icon(Icons.clear))
        ),
      ),
    );
}