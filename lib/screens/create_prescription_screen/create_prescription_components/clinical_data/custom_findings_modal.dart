

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/methods/custom_findings_controller.dart';
import 'package:dims_vet_rx/screens/printing/prescription_print/print_gp.dart';

import '../../../../controller/create_prescription/prescription/methods/glass_prescription_controller.dart';
import '../../../others_data_screen/glass_prescription.dart';

  customFindingModal(context, mainKey, title) {
    final customFindingsController = Get.put(CustomFindingsController());
  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      actions: [
        ElevatedButton(onPressed: (){
          customFindingsController.saveToPrescription(mainKey);
          Navigator.pop(context);
        }, child: Text("Save"))
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // alignment: WrapAlignment.spaceBetween,
        // spacing: 5,
        // crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          Text('$title Custom Findings'),
          Row(
            children: [
              Container(
                width: 200,
                height: 40,
                child: TextField(
                  controller: customFindingsController.findingsName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Write new field name",
                  ),
                ),
              ),
              ElevatedButton(onPressed: () {
                customFindingsController.findingOptionCreate(context, mainKey);
              }, child: Text("Add"))
            ],
          ),
          // Container(
          //   width: 300,
          //   child: Column(
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Row(
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             // Text("Field Name: "),
          //             Container(
          //               width: 250,
          //               child: TextField(
          //                 controller: customFindingsController.findingsName,
          //                 decoration: InputDecoration(
          //                     border: OutlineInputBorder()
          //                 ),
          //               ),
          //             ),
          //             FilledButton(onPressed: () {
          //               customFindingsController.findingOptionCreate(context);
          //             }, child: Text("Add"))
          //           ],
          //         ),
          //       ),
          //       // Padding(
          //       //   padding: const EdgeInsets.all(8.0),
          //       //   child: Row(
          //       //      crossAxisAlignment: CrossAxisAlignment.center,
          //       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       //     children: [
          //       //       Text("Default value (optional): "),
          //       //       Container(
          //       //         width: MediaQuery.of(context).size.width * 0.3,
          //       //         child: TextField(
          //       //           controller: customFindingsController.findingsValue,
          //       //           decoration: InputDecoration(
          //       //             border: OutlineInputBorder()
          //       //           ),
          //       //         ),
          //       //       )
          //       //     ],
          //       //   ),
          //       // ),
          //       // Padding(
          //       //   padding: const EdgeInsets.all(8.0),
          //       //   child: Row(
          //       //      crossAxisAlignment: CrossAxisAlignment.center,
          //       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       //     children: [
          //       //       Text("Default Note (optional): "),
          //       //       Container(
          //       //         width: MediaQuery.of(context).size.width * 0.3,
          //       //         child: TextField(
          //       //           controller: customFindingsController.findingsNote,
          //       //           decoration: InputDecoration(
          //       //             border: OutlineInputBorder()
          //       //           ),
          //       //         ),
          //       //       )
          //       //     ],
          //       //   ),
          //       // ),
          //     ],
          //   ),
          // ),
          // FilledButton(onPressed: (){
          //   createFindingsField(context);
          // }, child: Text("Create Finding Field")),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.clear)),
        ],
      ),
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(Platform.isWindows)
                      SizedBox(width: 50,),
                      // Container(
                      //     width: MediaQuery.of(context).size.width * 0.2,
                      //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      //     child: Text("Name")),
                      // Container(
                      //     width: MediaQuery.of(context).size.width * 0.2,
                      //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      //     child: Text("Value")),
                      // Container(
                      //     width: MediaQuery.of(context).size.width * 0.2,
                      //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      //     child: Text("Note")),
                      // Container(
                      //     width: MediaQuery.of(context).size.width * 0.2,
                      //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      //     child: Text("Action")),

                      Expanded(

                          child: Text("Name")),
                      Expanded(

                          child: Text("Value")),
                      Expanded(

                          child: Text("Note")),
                      Expanded(

                          child: Text("Action")),

                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Obx(() => Column(
                    children: [
                       for(int i = 0; i < customFindingsController.findingsList.length; i++)
                         if(customFindingsController.findingsList[i]['mainKey'] ==mainKey)
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             // Container(
                             //   width: MediaQuery.of(context).size.width * 0.2,
                             //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                             //   child: TextFormField(
                             //     initialValue: customFindingsController.findingsList[i]['name'],
                             //     onChanged: (value){
                             //       customFindingsController.findingsList[i]['name'] = value;
                             //     },
                             //     decoration: InputDecoration(
                             //       border: OutlineInputBorder(),
                             //       hintText: customFindingsController.findingsList[i]['name']
                             //     ),
                             //   ),
                             // ),
                             // Container(
                             //   width: MediaQuery.of(context).size.width * 0.2,
                             //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                             //   child: TextFormField(
                             //     initialValue: customFindingsController.findingsList[i]['value'],
                             //     onChanged: (value){
                             //       customFindingsController.findingsList[i]['value'] = value;
                             //     },
                             //     decoration: InputDecoration(
                             //         border: OutlineInputBorder(),
                             //         hintText: customFindingsController.findingsList[i]['value']
                             //     ),
                             //   ),
                             // ),
                             // Container(
                             //   width: MediaQuery.of(context).size.width * 0.2,
                             //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                             //   child: TextFormField(
                             //     initialValue: customFindingsController.findingsList[i]['note'],
                             //     onChanged: (value){
                             //       customFindingsController.findingsList[i]['note'] = value;
                             //     },
                             //     decoration: InputDecoration(
                             //         border: OutlineInputBorder(),
                             //         hintText: customFindingsController.findingsList[i]['note']
                             //     ),
                             //   ),
                             // ),
                             // Container(
                             //   width: MediaQuery.of(context).size.width * 0.2,
                             //   child: Row(
                             //     children: [
                             //       IconButton(onPressed: (){
                             //         customFindingsController.findingsList.removeAt(i);
                             //       }, icon: Icon(Icons.delete)),
                             //     ],
                             //   ),
                             // ),
                             Expanded(
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: TextFormField(
                                   initialValue: customFindingsController.findingsList[i]['name'],
                                   onChanged: (value){
                                     customFindingsController.findingsList[i]['name'] = value;
                                   },
                                   decoration: InputDecoration(
                                     border: OutlineInputBorder(),
                                     hintText: customFindingsController.findingsList[i]['name']
                                   ),
                                 ),
                               ),
                             ),
                             Expanded(
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: TextFormField(
                                   initialValue: customFindingsController.findingsList[i]['value'],
                                   onChanged: (value){
                                     customFindingsController.findingsList[i]['value'] = value;
                                   },
                                   decoration: InputDecoration(
                                       border: OutlineInputBorder(),
                                       hintText: customFindingsController.findingsList[i]['value']
                                   ),
                                 ),
                               ),
                             ),
                             Expanded(
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: TextFormField(
                                   initialValue: customFindingsController.findingsList[i]['note'],
                                   onChanged: (value){
                                     customFindingsController.findingsList[i]['note'] = value;
                                   },
                                   decoration: InputDecoration(
                                       border: OutlineInputBorder(),
                                       hintText: customFindingsController.findingsList[i]['note']
                                   ),
                                 ),
                               ),
                             ),
                             Expanded(
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Row(
                                   children: [
                                     IconButton(onPressed: (){
                                       customFindingsController.findingsList.removeAt(i);
                                     }, icon: Icon(Icons.delete)),
                                   ],
                                 ),
                               ),
                             ),
          
                             // Text(glassPrescription.findingsList[i]['name']),
                             // Text(glassPrescription.findingsList[i]['value']),
          
                             // IconButton(onPressed: (){
                             //   glassPrescription.findingsList.removeAt(i);
                             // }, icon: Icon(Icons.delete)),
                           ],
                         )
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  });
}

// createFindingsField(context){
//   final customFindingsController = Get.put(CustomFindingsController());
//     showDialog(context: context, builder: (context){
//       return AlertDialog(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Create Finding Field"),
//               IconButton(onPressed: () {
//                 Navigator.pop(context);
//               }, icon: Icon(Icons.clear))
//             ],
//           ),
//           actions: [
//             FilledButton(onPressed: () {
//                customFindingsController.findingOptionCreate(context);
//             }, child: Text("Add"))
//           ],
//           content: Container(
//               height: 300,
//               width: MediaQuery.of(context).size.width * 0.5,
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Field Name: "),
//                       Container(
//                         width: MediaQuery.of(context).size.width * 0.3,
//                         child: TextField(
//                           controller: customFindingsController.findingsName,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder()
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.all(8.0),
//                 //   child: Row(
//                 //      crossAxisAlignment: CrossAxisAlignment.center,
//                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //     children: [
//                 //       Text("Default value (optional): "),
//                 //       Container(
//                 //         width: MediaQuery.of(context).size.width * 0.3,
//                 //         child: TextField(
//                 //           controller: customFindingsController.findingsValue,
//                 //           decoration: InputDecoration(
//                 //             border: OutlineInputBorder()
//                 //           ),
//                 //         ),
//                 //       )
//                 //     ],
//                 //   ),
//                 // ),
//                 // Padding(
//                 //   padding: const EdgeInsets.all(8.0),
//                 //   child: Row(
//                 //      crossAxisAlignment: CrossAxisAlignment.center,
//                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //     children: [
//                 //       Text("Default Note (optional): "),
//                 //       Container(
//                 //         width: MediaQuery.of(context).size.width * 0.3,
//                 //         child: TextField(
//                 //           controller: customFindingsController.findingsNote,
//                 //           decoration: InputDecoration(
//                 //             border: OutlineInputBorder()
//                 //           ),
//                 //         ),
//                 //       )
//                 //     ],
//                 //   ),
//                 // ),
//               ],
//             ),
//           )
//     );
// });
// }