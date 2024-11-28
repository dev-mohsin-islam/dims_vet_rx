


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/favorite_index/favorite_index_controller.dart';
import 'package:dims_vet_rx/controller/speciality/speciality_controller.dart';

import '../../controller/advice/advice_controller.dart';
import '../../utilities/default_value.dart';


Widget screenSingleData(screenTitle ,  controller, favoriteIndexController,favoriteSegmentName){

  var context  = Get.context;

  return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
      Obx((){
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        SizedBox(
                          child: Text(screenTitle, style: const TextStyle(fontSize: 20,color: Colors.black54),)),
                      SizedBox(
                        width: 300,
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
                        newAddAndUpdateDialog(context, 0, controller);
                      }, child: const Text("Create New")),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.dataList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      var item = controller.dataList[index];
                      var name = item.name;
                      var favoriteIndex = item.id;
                      print(index);
                      return Text("data");
                      // var favoriteId = favoriteIndexController.favoriteIndexDataList.firstWhere(
                      //       (element) => element.favorite_id == favoriteIndex && element.u_status != 2 && element.segment == favoriteSegmentName, orElse: () => null,);
                      // if (item != null && item.u_status != 3) {
                      //   return Card(
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      //       child: SizedBox(
                      //         height: 40,
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Row(
                      //               children: [
                      //                 if (favoriteSegmentName.isNotEmpty)
                      //                   favoriteId == null
                      //                       ? IconButton(
                      //                     onPressed: () async {
                      //                       await favoriteIndexController.addData(
                      //                         favoriteIndexController.favoriteIndexDataList.length + 1,
                      //                         favoriteSegmentName,
                      //                         favoriteIndex,
                      //                       );
                      //                       await controller.getAllData('');
                      //                       controller.dataList.refresh();
                      //                     },
                      //                     icon: const Icon(Icons.star_border),
                      //                   )
                      //                       : IconButton(
                      //                     onPressed: () async {
                      //                       favoriteIndexController.updateData(
                      //                         favoriteIndexController.favoriteIndexDataList.length + 1,
                      //                         favoriteSegmentName,
                      //                         favoriteIndex,
                      //                       );
                      //                       await controller.dataList.refresh();
                      //                     },
                      //                     icon: const Icon(Icons.star),
                      //                   ),
                      //                 const SizedBox(width: 10),
                      //                 // item name
                      //                 Container(
                      //                     width: MediaQuery.sizeOf(context).width * 0.7,
                      //                     child: Text(name)),
                      //               ],
                      //             ),
                      //             // if (item.uuid.isNotEmpty)
                      //             Row(
                      //               children: [
                      //                 IconButton(
                      //                   onPressed: () {
                      //                     controller.nameController.text = item.name;
                      //                     newAddAndUpdateDialog(context, item.id, controller);
                      //                   },
                      //                   icon: const Icon(Icons.edit),
                      //                 ),
                      //                 IconButton(
                      //                   onPressed: () {
                      //                     controller.deleteData(item.id);
                      //                   },
                      //                   icon: const Icon(Icons.delete),
                      //                 ),
                      //               ],
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   );
                      // }
                      // return SizedBox();

                }),
              )
              // controller.isLoading.value ? const Padding(
              //   padding: EdgeInsets.symmetric(vertical: 158.0),
              //   child: Center(child: CircularProgressIndicator(),),
              // )
              //     : controller.dataList.length > 0 ? _dataLis(context, controller, favoriteIndexController,favoriteSegmentName)
              //     :  const Padding(
              //           padding: EdgeInsets.symmetric(vertical: 158.0),
              //           child: Center(child: Column(
              //             children: [
              //               Icon(Icons.hourglass_empty, size: 80,),
              //               Text("Data Not Found"),
              //             ],
              //           ),),
              //         )
            ],
          ),
        );
      })
  );
}


Widget _dataLis(context, controller, favoriteIndexController, favoriteSegmentName) {

  return SingleChildScrollView(
    child: Column(
      children: [
        Obx(() {
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: controller.dataList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var item = controller.dataList[index];
                  var name = item.name;

                  var favoriteIndex = item.id;
                  var favoriteId = favoriteIndexController.favoriteIndexDataList.firstWhere(
                        (element) => element.favorite_id == favoriteIndex && element.u_status != 2 && element.segment == favoriteSegmentName, orElse: () => null,);
                  if (item != null && item.u_status != 3) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  if (favoriteSegmentName.isNotEmpty)
                                    favoriteId == null
                                        ? IconButton(
                                      onPressed: () async {
                                        await favoriteIndexController.addData(
                                          favoriteIndexController.favoriteIndexDataList.length + 1,
                                          favoriteSegmentName,
                                          favoriteIndex,
                                        );
                                        await controller.getAllData('');
                                        controller.dataList.refresh();
                                      },
                                      icon: const Icon(Icons.star_border),
                                    )
                                        : IconButton(
                                      onPressed: () async {
                                        favoriteIndexController.updateData(
                                          favoriteIndexController.favoriteIndexDataList.length + 1,
                                          favoriteSegmentName,
                                          favoriteIndex,
                                        );
                                        await controller.dataList.refresh();
                                      },
                                      icon: const Icon(Icons.star),
                                    ),
                                  const SizedBox(width: 10),
                                  // item name
                                  Container(
                                      width: MediaQuery.sizeOf(context).width * 0.7,
                                      child: Text(name)),
                                ],
                              ),
                              // if (item.uuid.isNotEmpty)
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        controller.nameController.text = item.name;
                                        newAddAndUpdateDialog(context, item.id, controller);
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        controller.deleteData(item.id);
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox(); // Return an empty widget if conditions are not met
                },
              ),
            ],
          );
        }),
      ],
    ),
  );
}

Future<void> newAddAndUpdateDialog(context, id, controller)async{
  Get.defaultDialog(
    title: id ==0 ? "Create New" : "Update",
    textConfirm: id ==0 ? "Add" : "Update",
    onConfirm: ()async{
      final idNewData = controller.dataList.length + 1;
      id ==0 ? await controller.addData(idNewData) : controller.updateData(id);
      controller.nameController.clear();
      Navigator.pop(context);
    },
    textCancel: "Close",
    onCancel: (){
      controller.nameController.clear();
      Navigator.pop(context);
    },
    barrierDismissible: false,
    content: Container(
      height: 200,
      width: 350,
      child: Column(
        children: [
          TextField(
            maxLines: 3,
            controller: controller.nameController,
            decoration: const InputDecoration(
                hintText: "Enter data",
                border: OutlineInputBorder()
            ),
          ),
        ],
      ),
    ),
  );
}


