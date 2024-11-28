


import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get.dart';

import '../../controller/drug_generic/drug_generic_controller.dart';
import '../../utilities/default_value.dart';
import '../../utilities/app_strings.dart';

Widget genericScreen(context ){
  final DrugGenericController controller = Get.put(DrugGenericController());
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
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 5,
                  children: [
                    SizedBox(
                        child: Text(ScreenTitle.DrugGeneric, style: const TextStyle(fontSize: 20,color: Colors.black54),)),
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
                    ElevatedButton(onPressed: (){
                      controller.clearText();
                      newAddAndUpdateGenericDialog(context, 0, controller);
                    }, child: const Text("Create New")),
                  ],
                ),
              ),
            ),
            controller.isLoading.value ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 158.0),
              child: Center(child: CircularProgressIndicator(),),
            )
                : controller.dataList.length > 0 ? _dataLis(context, controller)
                :  Padding(
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
  return  Expanded(
    child: Obx(() {
      return ListView.builder(
        itemCount: controller.dataList.length,
        itemBuilder: (context, index) {
          var item = controller.dataList[index];
          var name =  controller.dataList[index].generic_name;
          if(item != null && item.u_status !=3) {
            return Card(
                child:  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                  child: SizedBox(
                    child: Wrap( 
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 5,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 10,),
                            Flexible(child: Text(name)),

                          ],
                        ),

                        if(item.uuid == DefaultValues.defaultUuid)
                        Row(
                          children: [
                            IconButton(onPressed: (){
                              controller.nameController.text = name;
                              // newAddAndUpdateModal(context, item.id, controller);
                              newAddAndUpdateGenericDialog(context, item.id, controller);
                            }, icon: const Icon(Icons.edit)),
                            IconButton(onPressed: (){
                              controller.deleteData(item.id);
                            }, icon: const Icon(Icons.delete)),
                          ],
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

Future<void> newAddAndUpdateGenericDialog(context, id, controller)async{
  Get.defaultDialog(
    title: id ==0 ? "Create New" : "Update",
    textConfirm: id ==0 ? "Add" : "Update",
    onConfirm: ()async{
      final idNewData = controller.dataList.length + 1;
      id ==0 ? controller.addData(idNewData): controller.updateData(id);
      Navigator.pop(context);
    },
    textCancel: "Cancel",
    barrierDismissible: false,
    content: Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        children: [
          TextField(
            controller: controller.nameController,
            decoration: const InputDecoration(
                hintText: "Enter generic name",
                border: OutlineInputBorder()
            ),
          ),
        ],
      ),
    ),
  );
}

