import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/handout/handout.dart';
import 'package:dims_vet_rx/utilities/app_strings.dart';

import '../../../controller/advice/advice_controller.dart';
import '../../others_data_screen/add_new_advice_and_list.dart';
import '../../printing/handout_print/print.dart';



void showAddShortAdviceModal(context, fieldName, screenWidth, screenHeight, controller, selectedShortAdvice){
  final AdviceController adviceController = Get.put(AdviceController());
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            Text(fieldName),
            ElevatedButton(onPressed: (){
              adviceController.clearText();
              newAddAndUpdateDialogAdvice(context, 0, adviceController);
            }, child: Text("Create New")),

          ],
        ),
        content: SizedBox(
          width: screenWidth * 0.8, // Set the desired width
          height: screenHeight * 0.8, // Set the desired height
          // color: Colors.white,

          child: SingleChildScrollView(
            child: Wrap(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 0.6,
                  width: screenWidth * 0.3,
                  child: Obx(() =>  ListView.builder(
                      itemCount: controller.dataList.length,
                      itemBuilder: (context, index){
                        var item = controller.dataList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Obx(() => Container(
                        child: FilterChip(
                            checkmarkColor: Colors.deepPurple,
                            label: Text(item.label.toString(),  overflow: TextOverflow.ellipsis,),
                            selected: selectedShortAdvice.contains(item),
                            onSelected: (isSelected){
                              if(isSelected == true){
                                selectedShortAdvice.add(item);
                              }else{
                                selectedShortAdvice.remove(item);
                              }
                            }),
                          alignment: Alignment.centerLeft
                      )),
                    );
                  })),
                ),
                Container(
                  height: screenHeight * 0.6,
                  padding: EdgeInsets.all(10),
                  width: screenWidth * 0.4,
                    child: SingleChildScrollView(
                      child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  selectedShortAdvice.map<Widget>((item){
                          return  Column(
                            children: [
                             if(item.u_status !=3) Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:  Text(item.text),
                              ),
                            ],
                          );
                        }).toList(),
                      )),
                    ),

                )
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(AppButtonString.closeString),
              ),
              // FilledButton(onPressed: (){}, child: Text("Save"))
            ],
          )
        ],
      );
    },
  );
}
