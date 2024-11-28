
//for prescription procedure


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';
import 'package:dims_vet_rx/controller/procedure/procedure_controller.dart';
import 'package:dims_vet_rx/utilities/app_icons.dart';
import 'package:dims_vet_rx/utilities/app_strings.dart';

import '../../../../controller/create_prescription/prescription/methods/method_prescription_data_clear.dart';
import '../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../controller/drawer_controller/drawer_controller.dart';
import '../../../../controller/favorite_index/favorite_index_controller.dart';
import '../../../../utilities/default_value.dart';
import '../../../../utilities/helpers.dart';
import '../../../../utilities/style.dart';
import '../../popup_screen.dart';
import 'clinical_field.dart';
import 'left_clinical_widget.dart';

Widget clinicalFieldProcedureWidget(context, screenValue, screenHeight, screenWidth, title, selectedData,) {
  final ProcedureController procedureController = Get.put(ProcedureController());
  final DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final selectedDataList = procedureController.selectedProcedure;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            ),),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: Colors.black
              ),
              child: IconButton(onPressed: () async {
                // drawerMenuController.endDrawerCurrentScreen.value = screenValue;
                // customPopupDialog(context,title,true);
                showDialog(context: context, builder: (context){
                  return   AlertDialog(
                    title: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        Text(title),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.close))
                      ],
                    ),
                    content: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // procedurePrescriptionWidget(context)
                            clinicalFieldProcedureDataList(context,procedureController,selectedDataList,"Procedure",)
                          ],
                        ),
                      ),
                    ),
                  );
                });
              }, icon: Icon(Icons.add_box, size: Platform.isAndroid ? 30 : 25, color: Colors.black,),),
            ),
          ],
        ),
      ),

      Card(
        child: Container(
          width: Responsive().clinicalFieldInPrescriptionW(context),
          // height: Responsive().clinicalFieldInPrescriptionH(context),
          decoration: const BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      return Column(
                        children: [
                          ListView.builder(
                              itemCount: procedureController.selectedProcedure.length,
                              shrinkWrap: true,
                              itemBuilder: (context , index){
                                var item = procedureController.selectedProcedure[index];


                            return Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(

                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      procedureController.selectedProcedure.remove(item);
                                    },
                                    child: Icon(Icons.cancel, size: Platform.isAndroid ? 15 : 12,),
                                  ),
                                  Text(item.procedure_name, style: const TextStyle(fontSize: 16,),),
                                  // Text(item ?? item.procedure_name.toString(), style: const TextStyle(fontSize: 16,),),
                                  InkWell(
                                    onTap: (){
                                      // procedureController.selectedProcedure.remove(item);
                                      // procedureController.procedureNameController.text = item.name;
                                      procedureModal(context,item, selectedData, true);
                                    },
                                    child: Icon(Icons.edit, size: Platform.isAndroid ? 15 : 12,),
                                  ),
                                ]
                              )
                            );
                          })
                        ]
                      );
                      // return Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: selectedData.map<Widget>((item) {
                      //
                      //     return
                      //       Column(
                      //         children: [
                      //           Container(
                      //             padding: const EdgeInsets.all(2),
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(5),
                      //               // border: Border.all(width: 1, color: Colors.grey)
                      //             ),
                      //             child: Row(
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: [
                      //                 InkWell(
                      //                     onTap: (){
                      //                       selectedData.remove(item);
                      //                     },
                      //                     child: const Icon(
                      //                       Icons.cancel,size: 12,)),
                      //                 const SizedBox(width: 5,),
                      //                 Flexible(child: Text(item.procedure_name, style: const TextStyle(fontSize: 16,),))
                      //
                      //               ],
                      //             ),
                      //           ),
                      //
                      //         ],
                      //       );
                      //   }).toList(),
                      //
                      // );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    ],
  );
}

Widget clinicalFieldProcedureDataList(context, procedureController,selectedDataList, type) {

  FavoriteIndexController favoriteIndexController = Get.put(FavoriteIndexController());


  return Column(
    children: [
      // Text(fieldTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
      Row(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 300,
                    padding: const EdgeInsets.all(10.00),
                    child: TextField(
                      controller: procedureController.searchController,
                      decoration: const InputDecoration(
                          hintText: "Search..",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search)
                      ),
                      onChanged: (value)async{
                        await procedureController.getAllData(value);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: 240,
            child:  TextField(
              controller: prescriptionController.addNewClinicalDataController,
              decoration: InputDecoration(
                hintText: "Add New",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 2.0,horizontal: 10.0), //EdgeInsets.all(2.0),
              ),
              onChanged: (value){
                procedureController.nameController.text = value;
              },
            ),
          ),

          if(!Platform.isAndroid)
            Obx(() => Column(
                children: [
                  Tooltip(
                    message: procedureController.isAddToFavorite.value ? "Remove from favorite" : "Also Add to favorite",
                    child:  IconButton(onPressed: (){
                      procedureController.isAddToFavorite.value = !procedureController.isAddToFavorite.value;
                    }, icon: procedureController.isAddToFavorite.value ? Icon(Icons.star) : Icon(Icons.star_border)),
                  )
                ]
            ),),

          if(!Platform.isAndroid)
            FilledButton(onPressed: ()async{
              await procedureController.addNewClinicalDataToPrescription(1,type);
              await procedureController.addData(procedureController.dataList.length + 1);
            } , child: Text("Create & Add to Rx")),
        ],
      ),

      Row(
        children: [
          if(Platform.isAndroid)
            Obx(() => Column(
                children: [
                  Tooltip(
                    message: procedureController.isAddToFavorite.value ? "Remove from favorite" : "Also Add to favorite",
                    child:  IconButton(onPressed: (){
                      procedureController.isAddToFavorite.value = !procedureController.isAddToFavorite.value;
                    }, icon: procedureController.isAddToFavorite.value ? Icon(Icons.star) : Icon(Icons.star_border)),
                  )
                ]
            ),),

          if(Platform.isAndroid)
            FilledButton(onPressed: ()async{
              await procedureController.addNewClinicalDataToPrescription(1,type);
              await procedureController.addData(procedureController.dataList.length + 1);
            } , child: Text("Create & Add to Rx")),
        ],
      ),

     Obx(() =>  allDataList(procedureController, selectedDataList,favoriteIndexController,FavSegment.procedure),),
     Obx(() =>  favoriteDataList(procedureController, selectedDataList,favoriteIndexController,FavSegment.procedure),)
    ],
  );

}

Row favoriteDataList(controller, selectedDataList,favoriteIndexController,favoriteSegmentName) {
  return Row(
     children: [
      if(favoriteIndexController.iShowFavorite == true)
       Column(
         children: [
           LayoutBuilder(
             builder: (context, constraints) {
               return Obx(() {
                 List data = [];
                 if(controller.dataList.length == 0){
                 }else if(controller.dataList.length > 0 && Platform.isAndroid){
                   data = splitList(controller.dataList, 1);
                 }else if(controller.dataList.length <20){
                   data = splitList(controller.dataList, 1);
                 }else if(controller.dataList.length >= 20 && controller.dataList.length < 40){
                   data = splitList(controller.dataList, 2);
                 }else if(controller.dataList.length >= 40){
                   data = splitList(controller.dataList, 2);
                 }

                 List dataList1 =[];
                 List dataList2 =[];
                 if(data.isEmpty){

                 }else if(data.length == 1){
                   dataList1 = data.isNotEmpty ? data[0] : [] ;
                 }else if(data.length == 2){
                   dataList1 = data.isNotEmpty ? data[0] : [];
                   dataList2 = data.isNotEmpty ? data[1] : [];
                 }else if(data.length == 3){
                   dataList1 = data.isNotEmpty ? data[0] : [];
                   dataList2 = data.isNotEmpty ? data[1] : [];
                 }
                 return Column(
                   children: [
                     Row(
                         children: [
                           if(dataList1.isNotEmpty)
                             dataList(context, dataList1, favoriteIndexController, favoriteSegmentName, controller, selectedDataList, true),
                           if(dataList2.isNotEmpty)
                             dataList(context, dataList2, favoriteIndexController, favoriteSegmentName, controller, selectedDataList, true),
                         ]
                     )

                   ],
                 );
               });


             },
           )
         ],
       ),

     ],
   );
}

Row allDataList(controller, selectedDataList,favoriteIndexController,favoriteSegmentName) {
  return Row(
     children: [
       if(favoriteIndexController.iShowFavorite == false)
       Column(
         children: [
           LayoutBuilder(
             builder: (context, constraints) {
               return Obx(() {
                 List data = [];
                 if(controller.dataList.length == 0){
                 }else if(controller.dataList.length > 0 && Platform.isAndroid){
                   data = splitList(controller.dataList, 1);
                 }else if(controller.dataList.length <20){
                   data = splitList(controller.dataList, 1);
                 }else if(controller.dataList.length >= 20 && controller.dataList.length < 40){
                   data = splitList(controller.dataList, 2);
                 }else if(controller.dataList.length >= 40){
                   data = splitList(controller.dataList, 2);
                 }

                 List dataList1 =[];
                 List dataList2 =[];
                 if(data.isEmpty){
                 }else if(data.length == 1){
                   dataList1 = data.isNotEmpty ? data[0] : [] ;
                 }else if(data.length == 2){
                   dataList1 = data.isNotEmpty ? data[0] : [];
                   dataList2 = data.isNotEmpty ? data[1] : [];
                 }else if(data.length == 3){
                   dataList1 = data.isNotEmpty ? data[0] : [];
                   dataList2 = data.isNotEmpty ? data[1] : [];
                 }
                 return Column(
                   children: [
                     Row(
                       children: [
                         if(dataList1.isNotEmpty)
                           dataList(context, dataList1, favoriteIndexController, favoriteSegmentName, controller, selectedDataList, false),
                         if(dataList2.isNotEmpty)
                           dataList(context, dataList2, favoriteIndexController, favoriteSegmentName, controller, selectedDataList,  false),
                       ]
                     )

                   ],
                 );
               });

             },
           )
         ],
       ),

     ],
   );
}


SizedBox dataList(BuildContext context, List<dynamic> dataList1, favoriteIndexController, favoriteSegmentName, controller, selectedDataList,isFavorite) {
  ProcedureController procedureController = Get.put(ProcedureController());
  return SizedBox(
           height: MediaQuery.of(context).size.width * 0.8,
           width: Platform.isAndroid ? MediaQuery.of(context).size.width * 0.8 : MediaQuery.of(context).size.width * 0.4,
           child: ListView.builder(
             scrollDirection: Axis.vertical,
             physics: const BouncingScrollPhysics(),
             itemCount:  dataList1.length,
             shrinkWrap: true,
             itemBuilder: (context, index) {
               var item = dataList1[index];
               var favoriteIndex = dataList1[index].id;
               var itemName = dataList1[index].name.toString();
               var favoriteId = favoriteIndexController.favoriteIndexDataList.firstWhere((element) => element.favorite_id == favoriteIndex && element.u_status !=2 && element.segment == favoriteSegmentName, orElse: () => null,);
               if(isFavorite){
                 if(item.u_status != DefaultValues.Delete && item.u_status !=DefaultValues.permanentDelete && favoriteId != null) {
                   return Obx(() =>
                       Container(
                           padding: const EdgeInsets.all(2),
                           alignment: Alignment.centerLeft,
                           child:  Row(
                             children: [
                               if(favoriteSegmentName.toString().isNotEmpty)
                                 favoriteId ==null
                                     ?
                                 IconButton(onPressed: ()async{
                                   await favoriteIndexController.addData(favoriteIndexController.favoriteIndexDataList.length + 1,favoriteSegmentName, favoriteIndex );
                                   await controller.getAllData('');
                                   controller.dataList.refresh();
                                 }, icon: const Icon(Icons.star_border))
                                     :
                                 IconButton(onPressed: ()async{
                                   await favoriteIndexController.updateData(favoriteId.id,favoriteSegmentName, favoriteIndex);

                                   await controller.getAllData('');
                                   await controller.dataList.refresh();
                                 }, icon: const Icon(Icons.star)),
                               const SizedBox(width: 10,),
                               FilterChip(
                                   label: Text(item.name,  overflow: TextOverflow.ellipsis,   ),
                                   selected: procedureController.selectedProcedure.any((map) => map.procedure_name == item.name),
                                   onSelected: (isSelected){
                                     procedureModal(context,item, selectedDataList, isSelected);
                                     controller.procedureNameController.text = item.name;
                                     // if(isSelected == true){
                                     //   selectedDataList.add(item);
                                     // }else{
                                     //   selectedDataList.remove(item);
                                     // }
                                   }),
                             ],
                           )
                       ));
                 }else{
                   return Container();
                 }
               }else{
                 if(item.u_status != DefaultValues.Delete && item.u_status !=DefaultValues.permanentDelete) {
                   return Obx(() =>
                       Container(
                           padding: const EdgeInsets.all(2),
                           alignment: Alignment.centerLeft,
                           child:  Row(
                             children: [
                               if(favoriteSegmentName.toString().isNotEmpty)
                                 favoriteId ==null
                                     ?
                                 IconButton(onPressed: ()async{
                                   await favoriteIndexController.addData(favoriteIndexController.favoriteIndexDataList.length + 1,favoriteSegmentName, favoriteIndex );
                                   await controller.getAllData('');
                                   controller.dataList.refresh();
                                 }, icon: const Icon(Icons.star_border))
                                     :
                                 IconButton(onPressed: ()async{
                                   await favoriteIndexController.updateData(favoriteId.id,favoriteSegmentName, favoriteIndex);

                                   await controller.getAllData('');
                                   await controller.dataList.refresh();
                                 }, icon: const Icon(Icons.star)),
                               const SizedBox(width: 10,),
                               FilterChip(
                                   checkmarkColor: Colors.deepPurple,
                                   label: Text(item.name,  overflow: TextOverflow.ellipsis,   ),
                                   selected: procedureController.selectedProcedure.any((element) => element.procedure_name == item.name),
                                   onSelected: (isSelected){
                                     controller.procedureNameController.text = item.name;
                                     procedureModal(context,item, selectedDataList, isSelected);
                                     controller.procedureNameController.text = item.name;
                                   }),
                             ],
                           )
                       ));
                 }else{
                   return Container();
                 }
               }

             },
           ),
         );
}

Future procedureModal(context,item, selectedDataList, isSelected){
  final ProcedureController procedureController = Get.put(ProcedureController());
  final AppointmentController appointmentController = Get.put(AppointmentController());
  if(isSelected == false){
    procedureController.procedureUpdateTextController(item);
  }
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
  return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Procedure"),
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.clear))
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.650,
                      width: screenWidth * 0.86,
                      child: SingleChildScrollView(

                        child: Column(
                          children: [
                            const SizedBox(height: 20,),
                            inputField(procedureController,procedureController.procedureNameController, AppInputLabel.procedureName),
                            inputField(procedureController,procedureController.diagnosisController, AppInputLabel.diagnosis),
                            inputField(procedureController,procedureController.anesthesiaController, AppInputLabel.anesthesia),
                            inputField(procedureController,procedureController.surgeonNameController, AppInputLabel.surgeonName),
                            inputField(procedureController,procedureController.assistantController, AppInputLabel.assistant),
                            inputField(procedureController,procedureController.incisionController, AppInputLabel.incision),
                            inputField(procedureController,procedureController.procedureDetailsController, AppInputLabel.procedureDetails),
                            inputField(procedureController,procedureController.prosthesisController, AppInputLabel.prosthesis),
                            inputField(procedureController,procedureController.closerController, AppInputLabel.closer),
                            inputField(procedureController,procedureController.findingsController, AppInputLabel.findings),
                            inputField(procedureController,procedureController.complicationsController, AppInputLabel.complications),
                            inputField(procedureController,procedureController.drainsController, AppInputLabel.drains),
                            inputField(procedureController,procedureController.postOperativeInstructionsController, AppInputLabel.postOperativeInstructions),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(isSelected == true)
                      ElevatedButton(onPressed: (){
                        if(isSelected == true){
                          procedureController.procedureAdd(item);
                          Navigator.pop(context);
                        }
                      }, child:   const Text(AppButtonString.saveString)),

                    ElevatedButton(onPressed: (){
                        var patientName = appointmentController.patientNameController.text.toString();
                        if(patientName.isNotEmpty){
                          var patientAge = "${ appointmentController.ageYearController.text}Y/ ${appointmentController.ageMonthController.text}M/ ${appointmentController.ageDayController.text}D";
                          var date = "${appointmentController.dateController.text}";

                          procedureController.procedurePrinting(context, item, patientName, patientAge, date);
                        }else{
                          Helpers.errorSnackBar("Error","Please Enter Patient Name");
                        }
                    }, child:   const Text("Print")),


                    if(isSelected == false)
                      ElevatedButton(onPressed: (){
                        procedureController.procedureUpdate(item);
                        Navigator.pop(context);
                      }, child: const Text(AppButtonString.updateString)),


                    if(isSelected == false)
                      ElevatedButton(onPressed: (){
                        bool response = procedureController.procedureRemove(item);
                        if(response == true){
                          procedureController.procedureTextClear();
                          Navigator.pop(context);
                        }

                      }, child: const Text(AppButtonString.removeString)),

                    ElevatedButton(onPressed: (){
                      procedureController.procedureTextClear();
                      Navigator.pop(context);
                    }, child: const Text(AppButtonString.closeString)),
                  ],
                )
              ],
            ),
          ),
        );
      }
  );

}

Padding inputField(ProcedureController procedureController, TextEditingController inputFieldNameController, String labelText) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
            controller:inputFieldNameController,
            decoration:  InputDecoration(
              label:   Text(labelText),
              contentPadding: const EdgeInsets.all( 15.0),
              suffixIcon: IconButton(onPressed: (){
                inputFieldNameController.clear();
              },  icon: AppIcons.inputFieldDataClear),
              border: const OutlineInputBorder(),
            ),
          ),
  );
}
