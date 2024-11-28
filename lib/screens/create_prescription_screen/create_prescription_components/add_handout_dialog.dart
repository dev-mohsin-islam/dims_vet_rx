
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controller/handout/handout.dart';
import '../../../utilities/app_strings.dart';
import '../../printing/handout_print/print.dart';

void showHandOutModalModal(context, fieldName, screenWidth, screenHeight){
  final HandoutController controller = Get.put(HandoutController());
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(fieldName),
            IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.clear))
          ],
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            child: Expanded(
              child: Wrap(
                children: [
                  SizedBox(
                    height: screenHeight * 0.9,
                    width: screenWidth * 0.9,
                    child: Obx(() =>  ListView.builder(
                        itemCount: controller.dataList.length,
                        itemBuilder: (context, index){
                          var item = controller.dataList[index];
                          return Card(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [

                                Container(
                                  width: screenWidth * 0.8,
                                  child: ExpansionTile(
                                    title: Row(
                                      children: [
                                        Obx(() => Checkbox(
                                            value: controller.selectedHandOut.contains(item),
                                            onChanged: (value){
                                              if(value == true){
                                                controller.selectedHandOut.add(item);
                                              }else{
                                                controller.selectedHandOut.remove(item);
                                              }

                                            }),),
                                        Flexible(child: Text(item.label.toString(),  overflow: TextOverflow.ellipsis,)),
                                      ],
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:  Container(
                                          width: screenWidth * 0.7,
                                            child: Text(item.text)),
                                      ),
                                      // FilledButton(onPressed: ()async {
                                      //   List advices = [];
                                      //   advices.add(item);
                                      //   // Navigator.push(context, MaterialPageRoute(builder: (context) => HandOutPrintPreview(advices: advices,)),);
                                      // }, child: Row(
                                      //   mainAxisSize: MainAxisSize.min,
                                      //   children: [
                                      //     Icon(Icons.print),
                                      //     SizedBox(width: 6,),
                                      //     Text("Print"),
                                      //   ],
                                      // )),
                                    ],

                                  ),
                                ),
                              ],
                            ),
                          );
                        })),
                  ),
              
                ],
              ),
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
              FilledButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HandOutPrintPreview()),);
              }, child: Row(
                children: [
                  Icon(Icons.print),
                  SizedBox(width: 6,),
                  Text("Print Save"),
                ],
              ))
            ],
          )
        ],
      );
    },
  );
}