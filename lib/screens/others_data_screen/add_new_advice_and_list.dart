
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/utilities/default_value.dart';
import 'package:dims_vet_rx/utilities/app_strings.dart';

import '../../controller/advice/advice_controller.dart';

Widget advicePatientScreen(context){
  final AdviceController controller = Get.put(AdviceController());
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
                    const SizedBox(
                        child: Text(ScreenTitle.screenAdviceList, style: TextStyle(fontSize: 20,color: Colors.black54),)),
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
                      newAddAndUpdateDialogAdvice(context, 0, controller);
                    }, child: const Text("Create New")),
                  ],
                ),
              ),
            ),
            controller.isLoading.value ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 158.0),
              child: Center(child: CircularProgressIndicator(),),
            )
                : controller.dataList.length > 0 ? _dataList(context, controller)
                :  const Padding(
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

Widget _dataList(context, controller){

  return  Expanded(
    child: Obx(() {
      return ListView.builder(
        itemCount: controller.dataList.length,
        itemBuilder: (context, index) {
          var item = controller.dataList[index];
          var name =  controller.dataList[index].label;
          var text =  controller.dataList[index].text;
          if(item != null && item.u_status !=3) {
            return Container(

              child: Card(
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0,),
                    child: ListTile(
                      title: Wrap(
                        children: [
                          Text(name, style: const TextStyle(fontSize: 18),),
                          if(item.uuid !='')
                            Row(
                              children: [
                                IconButton(onPressed: (){
                                  controller.labelController.text = name;
                                  controller.textController.text = text;
                                  newAddAndUpdateDialogAdvice(context, item.id, controller);
                                }, icon: const Icon(Icons.edit)),
                                SizedBox(height: 20,),
                                IconButton(onPressed: (){
                                  controller.deleteData(item.id);
                                }, icon: const Icon(Icons.delete)),
                              ],
                            ),

                        ],
                      ),
                      subtitle: Text(text),
                    ),
                  )
              ),
            );
          }
          return Container();
        },
      );
    }),
  );
}

Future<void> newAddAndUpdateDialogAdvice(context, id, controller)async{
  Get.defaultDialog(
    title: id ==0 ? "Create New" : "Update",
    textConfirm: id ==0 ? "Add" : "Update",
    onConfirm: ()async{
      final idNewData = controller.dataList.length + 1;
      id ==0 ? await controller.addData(idNewData) : controller.updateData(id);
      Navigator.pop(context);
    },
    textCancel: "Cancel",
    barrierDismissible: false,
    content: Container(
      width: 500,
      child: Column(
        children: [
          TextField(
            controller: controller.labelController,
            decoration: const InputDecoration(
                hintText: "Enter label",
                border: OutlineInputBorder()
            ),
          ),
        const SizedBox(height: 10,),
          TextField(
            controller: controller.textController,
            maxLines: 5,
            decoration: const InputDecoration(
                hintText: "Description",
                border: OutlineInputBorder()
            ),
          ),
        ],
      ),
    ),
  );
}

