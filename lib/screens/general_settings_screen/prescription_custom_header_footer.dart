

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/general_setting/prescription_print_page_setup_controller.dart';

class CustomHeaderFooter extends StatelessWidget {
  const CustomHeaderFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrescriptionPrintPageSetupController());

    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => Column(
                children: [
                  Text("I want to build my custom header with"),
                  Row(
                    children: [
                      Card(
                          child: RadioMenuButton(value: 1, groupValue: controller.selectedCustomHeader, onChanged: (value){
                            controller.selectedCustomHeader.clear();
                            for(var i=0; i<3; i++){
                              controller.selectedCustomHeader.add(controller.customHeaderContent);
                            }
                          }, child: Text("Left/Middle/Right"))),
                      Card(
                          child: RadioMenuButton(value: 1, groupValue: controller.selectedCustomHeader, onChanged: (value){
                            controller.selectedCustomHeader.clear();
                            for(var i=0; i<3; i++){
                              controller.selectedCustomHeader.add(controller.customHeaderContent);
                            }
                          }, child: Text("Left/Right"))),
                      Card(
                          child: RadioMenuButton(value: 2, groupValue: controller.selectedCustomHeader, onChanged: (value){
                            controller.selectedCustomHeader.clear();
                              controller.selectedCustomHeader.add(controller.customHeaderContent);
                          }, child: Text("Middle (only one)"))),

                    ],
                  ),


                  for(var i=0; i<controller.selectedCustomHeader.length; i++)
                   Column(
                     children: [
                       for(var j=0; j<controller.selectedCustomHeader[i].length; j++)
                       Column(
                           children: [

                             ExpansionTile(
                               subtitle:  Row(
                                 children: [
                                   Text("What type of header do you want?"),
                                   for(var k=0; k<controller.selectedCustomHeader[i][j]['type'].length; k++)
                                     Card(
                                         child: RadioMenuButton(value: 1, groupValue: controller.selectedCustomHeader, onChanged: (value){
                                           controller.selectedCustomHeader[i][j]['selectedType'] = controller.selectedCustomHeader[i][j]['type'][k]['key'];
                                           controller.selectedCustomHeader.refresh();
                                         }, child: Text(controller.selectedCustomHeader[i][j]['type'][k]['key']))),
                                 ],
                               ),
                                 title:  Column(
                                   children: [

                                     Row(
                                       children: [
                                         Text("What the position of header do you want?"),
                                         for(var l=0; l<controller.selectedCustomHeader[i][j]['headerPosition'].length; l++)
                                           Card(
                                               child: RadioMenuButton(value: 1, groupValue: controller.selectedCustomHeader, onChanged: (value){
                                                 controller.selectedCustomHeader[i][j]['selectedPosition'] = controller.selectedCustomHeader[i][j]['headerPosition'][l]['key'];
                                               }, child: Text(controller.selectedCustomHeader[i][j]['headerPosition'][l]['key']))),
                                       ],
                                     ),
                                   ],
                                 ),
                               children: [

                                 for(var m=0; m<controller.selectedCustomHeader[i][j]['data'].length; m++)
                                   Card(
                                     child: Wrap(
                                       alignment: WrapAlignment.spaceEvenly,
                                       children: [
                                         Wrap(
                                           children: [
                                             Column(
                                               children: [
                                                 Text(controller.selectedCustomHeader[i][j]['data'][m]['label']),
                                                 Container(
                                                   width: 300,
                                                   child: Padding(
                                                     padding: const EdgeInsets.all(8.0),
                                                     child: TextField(
                                                       onChanged: (value){
                                                         controller.selectedCustomHeader[i][j]['data'][m]['value'] = value;
                                                       },
                                                       decoration: const InputDecoration(
                                                         border: OutlineInputBorder(),
                                                         hintText: 'Write value',
                                                       ),
                                                     ),
                                                   ),
                                                 ),
                                               ],
                                             ),
                                            Column(
                                              children: [
                                                Text("Font Size"),
                                                Container(
                                                  width: 100,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                      initialValue: controller.selectedCustomHeader[i][j]['data'][m]['fontSize'],
                                                      onChanged: (value){
                                                        controller.selectedCustomHeader[i][j]['data'][m]['fontSize'] = value;
                                                      },
                                                      decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        hintText: 'Write value',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                             SizedBox(width: 10,),
                                             Column(
                                              children: [
                                                Text("Position"),
                                                Container(
                                                  width: 100,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                      initialValue: controller.selectedCustomHeader[i][j]['data'][m]['orderIndex'],
                                                      onChanged: (value){
                                                        controller.selectedCustomHeader[i][j]['data'][m]['orderIndex'] = value;
                                                      },
                                                      decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        hintText: 'Write value',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                             SizedBox(width: 10,),
                                             Column(
                                               children: [
                                                 Text("Font Color"),
                                                 Container(
                                                   width: 100,
                                                   child: Padding(
                                                     padding: const EdgeInsets.all(8.0),
                                                     child: TextFormField(
                                                       initialValue: controller.selectedCustomHeader[i][j]['data'][m]['orderIndex'],
                                                       onChanged: (value){
                                                         controller.selectedCustomHeader[i][j]['data'][m]['orderIndex'] = value;
                                                       },
                                                       decoration: const InputDecoration(
                                                         border: OutlineInputBorder(),
                                                         hintText: 'Write value',
                                                       ),
                                                     ),
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           ],

                                         ),

                                         Row(
                                           children: [
                                             Card(
                                               child: Row(
                                                 children: [
                                                   Text("Is Bold or Normal?"),
                                                   Card(
                                                       child: RadioMenuButton(value: 1, groupValue: controller.selectedCustomHeader, onChanged: (value){
                                                         controller.selectedCustomHeader[i][j]['data'][m]['fontSize'] = value;
                                                       }, child: Text("Normal"),)),
                                                   Card(
                                                       child: RadioMenuButton(value: 1, groupValue: controller.selectedCustomHeader, onChanged: (value){
                                                         controller.selectedCustomHeader[i][j]['data'][m]['fontSize'] = value;
                                                       }, child: Text("Bold"),)),
                                                 ],
                                               ),
                                             ),

                                             Card(
                                               child: Row(
                                                 children: [
                                                   Text("Is Italic or Normal?"),
                                                   Card(
                                                       child: RadioMenuButton(value: 1, groupValue: controller.selectedCustomHeader, onChanged: (value){
                                                         controller.selectedCustomHeader[i][j]['data'][m]['fontSize'] = value;
                                                       }, child: Text("Normal"),)),
                                                   Card(
                                                       child: RadioMenuButton(value: 1, groupValue: controller.selectedCustomHeader, onChanged: (value){
                                                         controller.selectedCustomHeader[i][j]['data'][m]['fontSize'] = value;
                                                       }, child: Text("Italic"),))
                                                 ],
                                               ),
                                             ),
                                             Card(
                                               child: Row(
                                                 children: [
                                                   Text("Is Underline or Normal?"),
                                                   Card(
                                                       child: RadioMenuButton(value: 1, groupValue: controller.selectedCustomHeader, onChanged: (value){
                                                         controller.selectedCustomHeader[i][j]['data'][m]['fontSize'] = value;
                                                       }, child: Text("Normal"),)),
                                                   Card(
                                                       child: RadioMenuButton(value: 1, groupValue: controller.selectedCustomHeader, onChanged: (value){
                                                         controller.selectedCustomHeader[i][j]['data'][m]['fontSize'] = value;
                                                       }, child: Text("Underline"),))
                                                 ],
                                               ),
                                             ),
                                           ],
                                         ),

                                       ],
                                     ),
                                   )
                               ],

                             ),
                           ],
                       )
                     ],
                   )
                ],

              ),),
            ],
          ),
        )
      ),
    );
  }
}
