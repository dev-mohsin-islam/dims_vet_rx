
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/prescription_template/prescription_template_controller.dart';

import '../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../controller/drawer_controller/drawer_controller.dart';
import '../../utilities/app_strings.dart';


Widget prescriptionTemplateScreen(context){

  final PrescriptionTemplateController controller  = Get.put(PrescriptionTemplateController());


  return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
      Obx((){
        if (kDebugMode) {
          print(controller.isLoading);
        }
        return Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const SizedBox(
                        child: Text(ScreenTitle.PrescriptionTemplate, style: TextStyle(fontSize: 20,color: Colors.black54),)
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: controller.searchController,
                        decoration:   InputDecoration(
                          hintText: 'Search..',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: controller.searchController.text.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.cancel_outlined),
                            onPressed: () {
                              controller.clearText();
                            },
                          ) : null,
                        ),
                        onChanged: (value)async{
                          await controller.getAllData(value);
                        },
                      ),
                    ),
                    // ElevatedButton(onPressed: (){
                    //   controller.clearText();
                    //   newAddAndUpdateDialog(context, 0, controller);
                    // }, child: const Text("Create New")),
                  ],
                ),
              ),
            ),
            // Container(
            //   height: 30,
            //   color: Colors.deepPurple,
            //   child: const Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       SizedBox(
            //         width: 200,
            //         child: Padding(
            //           padding: EdgeInsets.symmetric(horizontal: 18.0),
            //           child: Text("Name", style: TextStyle(color: Colors.white, fontSize: 20),),
            //         ),
            //       ),
            //
            //       SizedBox(
            //         width: 210,
            //         child: Padding(
            //           padding: EdgeInsets.symmetric(horizontal: 18.0),
            //           child: Center(child: Text("Action", style: TextStyle(color: Colors.white, fontSize: 20),)),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            controller.isLoading.value ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 158.0),
              child: Center(child: CircularProgressIndicator(),),
            )
                : controller.prescriptionTemplateList.isNotEmpty ? _dataLis(context, controller)
                :   const Padding(
              padding: EdgeInsets.symmetric(vertical: 158.0),
              child: Center(child: Column(
                children: [
                  Icon(Icons.hourglass_empty, size: 80,),
                  Text("Data Not Found"),
                ],
              ),),
            )
          ],
        );
      })
  );
}

Widget _dataLis(context, controller){
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final PrescriptionTemplateController prescriptionTemplateController = Get.put(PrescriptionTemplateController());
  final DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
  return  Expanded(
    child: Obx(() {
      return ListView.builder(
        itemCount: controller.prescriptionTemplateList.length,
        itemBuilder: (context, index) {
          var item = controller.prescriptionTemplateList[index];
          var name =  controller.prescriptionTemplateList[index].template_name;
          var templateId =  controller.prescriptionTemplateList[index].id;
          if(item != null) {
            return Card(
                child:  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500),),
                        ),
                        Row(
                          children: [
                            FilledButton(onPressed: ()async{
                              if(templateId !=-1){
                                prescriptionTemplateController.templateNameController.text = name;
                                await prescriptionController.getSingleTemplateData(templateId);
                                drawerMenuController.selectedMenuIndex.value =15;
                              }
                            }, child: const Text("Edit Template")),
                            FilledButton(onPressed: ()async{
                              if(templateId !=-1){
                                await prescriptionTemplateController.deleteData(templateId);
                                // drawerMenuController.selectedMenuIndex.value =15;
                              }
                            }, child: const Text("Delete")),
                          ]
                        )
                      ],

                    ),
                  ),
                )
            );
          }
          return Container();
        },
      );
    }),
  );
}

Future<void> newAddAndUpdateDialog(context, id, controller)async{
  Get.defaultDialog(
    title: id ==0 ? "Create New" : "Update",
    textConfirm: id ==0 ? "Add" : "Update",
    onConfirm: ()async{
      final idNewData = controller.dataList.length + 1;
      id ==0 ?  controller.addData(idNewData) : controller.updateData(id);
      Navigator.pop(context);
    },
    textCancel: "Cancel",
    barrierDismissible: false,
    content: Column(
      children: [
        TextField(
          controller: controller.nameController,
          decoration: const InputDecoration(
              hintText: "Enter name",
              border: OutlineInputBorder()
          ),
        ),
      ],
    ),
  );
}

