

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/child_history/child_history_controller.dart';
import 'package:dims_vet_rx/controller/gyn_and_obs/gyn_and_obs_controller.dart';
import 'package:dims_vet_rx/controller/history/history_controller.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/clinical_data/child_history_modal.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/clinical_data/gyne_and_obs.dart';

import '../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../controller/favorite_index/favorite_index_controller.dart';
import '../../../../utilities/app_strings.dart';
import '../../../../utilities/history_category.dart';
import 'dart:math';

import '../../../others_data_screen/add_new_history_and_list.dart';



  patientHistory(context){
    final HistoryController historyController = Get.put(HistoryController());
    final PrescriptionController prescriptionController = Get.put(PrescriptionController());

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
    height: screenHeight * .7,
    child: Column(
       children: [
            Container(
                width: screenWidth * .4,
                child: TextField(
              controller: historyController.searchController,
              onChanged: (value){
                historyController.getAllData(value);

              },
              decoration:   InputDecoration(
                hintText: 'Search..',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(() => IconButton(onPressed: (){
                      historyController.searchController.clear();
                      historyController.getAllData('');
                    }, icon: Icon(Icons.clear)),),
                    IconButton(onPressed: (){
                      cateWiseSearch(context);
                    }, icon: Icon(Icons.filter_alt_sharp)),
                  ],
                )
              )
            )),
      Expanded(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: SingleChildScrollView(
            child: Obx(() => ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: historyController.dataList.length,
                itemBuilder: (context, index){
                  var history = historyController.dataList[index];
                  var category = historyController.category.firstWhere((element) => element['value'] == history.category, orElse: () => null);
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => FilterChip(
                              label: Text(history.name.toString()),
                              selected: historyController.selectedHistory.any((data) => data.id.toString().contains(history.id.toString())),
                              onSelected: (value){
                                print(value);
                                if(value == true){
                                  historyController.selectedHistory.add(history);
                                  historyController.selectedHistory.refresh();
                                }else{
                                  historyController.selectedHistory.remove(history);
                                  historyController.selectedHistory.refresh();
                                }
                              }
                          ),),
                          Text(category['name'].toString()),
                        ],
                      ),
                    ),
                  );
                })),
          ),
        ),
      )

    ],
            ),
  );
}

  //for popup
  historyDialog(context){
    final HistoryController historyController = Get.put(HistoryController());
    final PrescriptionController prescriptionController = Get.put(PrescriptionController());
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: historyTitleSection(context, historyController),
        actions: [
          ElevatedButton(onPressed: (){
            // historyController.clearText();
            historyController.groupDataByCategory();
            Navigator.pop(context);
            // newAddAndUpdateDialog(context, 0, historyController);
          }, child: const Text("Save")),

          ElevatedButton(onPressed: (){
            // historyController.clearText();
            historyController.groupDataByCategory();
            Navigator.pop(context);
            // newAddAndUpdateDialog(context, 0, historyController);
          }, child: const Text("Close", style: TextStyle(color: Colors.red),)),
        ],
        content:  historyMainContentSection(context, historyController),
      );
    });
  }


  SizedBox historyMainContentSection(BuildContext context, HistoryController historyController) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Obx(() => Column(
            children: [
              ListView.builder(
                 shrinkWrap: true,
                  itemCount: historyController.dataList.length,
                  itemBuilder: (context, index){
                    var history = historyController.dataList[index];
                    var category = historyController.category.firstWhere((element) => element['value'] == history.category, orElse: () => null);
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          children: [
                            Obx(() => FilterChip(
                                label: Text(history.name.toString()),
                                selected: historyController.selectedHistory.any((data) => data.id.toString().contains(history.id.toString())),
                                onSelected: (value){
                                  if(value == true){
                                    historyController.selectedHistory.add(history);
                                    historyController.selectedHistory.refresh();
                                  }else{
                                    historyController.selectedHistory.remove(history);
                                    historyController.selectedHistory.refresh();
                                  }
                                }
                            ),),
                            // Text(category['name'] == null ? "" : category['name'].toString()),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          )),
        ),
      );
  }

    historyTitleSection(BuildContext context, HistoryController historyController) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          if(screenWidth < 600)
          Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                      controller: historyController.searchController,
                      onChanged: (value){
                        historyController.getAllData(value);
                      },
                      decoration:   InputDecoration(
                          hintText: 'Search History',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(onPressed: (){
                                historyController.searchController.clear();
                                historyController.getAllData('');
                              }, icon: Icon(Icons.clear)),
                              IconButton(onPressed: (){
                                cateWiseSearch(context);
                              }, icon: Icon(Icons.filter_alt_sharp)),
                            ],
                          )
                      )
                  )),
              ElevatedButton(onPressed: (){
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Create New'),
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.clear))
                        ]
                    ),
                    content: Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child:  SingleChildScrollView(child: historyScreen(context)),
                    ),
                  );
                });
              }, child: const Text("Create New")),
            ],
          ),
          if(screenWidth > 600)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                      controller: historyController.searchController,
                      onChanged: (value){
                        historyController.getAllData(value);
                      },
                      decoration:   InputDecoration(
                          hintText: 'Search History',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(onPressed: (){
                                historyController.searchController.clear();
                                historyController.getAllData('');
                              }, icon: Icon(Icons.clear)),
                              IconButton(onPressed: (){
                                cateWiseSearch(context);
                              }, icon: Icon(Icons.filter_alt_sharp)),
                            ],
                          )
                      )
                  )),
              ElevatedButton(onPressed: (){
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Create New'),
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.clear))
                        ]
                    ),
                    content: Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child:  SingleChildScrollView(child: historyScreen(context)),
                    ),
                  );
                });
              }, child: const Text("Create New")),

            ],
          ),

        ],
      );
  }


cateWiseSearch(context){
 final historyController = Get.put(HistoryController());
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Filter By Category'),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          child:  SingleChildScrollView(
            child: Column(
              children: [
                 ListView(
                   shrinkWrap: true,
                   children: [
                     for(var i=0; i < historyController.category.length; i++)
                       if(i !=0)
                     Obx(() =>  Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: FilterChip(
                           checkmarkColor: Colors.deepPurple,
                           label: Text(historyController.category[i]['name'].toString(),  overflow: TextOverflow.ellipsis,   ),
                           // selected: prescriptionController.selectedCategory.contains(historyController.category[i]),
                           onSelected: (isSelected){
                             historyController.catWiseDataSearch(historyController.category[i]['value']);
                             Navigator.pop(context);
                             // if(isSelected == true){
                             //   // prescriptionController.selectedCategory.add(historyController.category[i]);
                             // }else{
                             //   // prescriptionController.selectedCategory.remove(historyController.category[i]);
                             // }
                           }),
                     ),),
            
                   ],
                 )
              ],
            ),
          ),
        ),
      );
    });
    

}

Widget oldPatientHistory(context){
  final  historyController = Get.put(HistoryController());
  final  childHistoryController = Get.put(ChildHistoryController());
  final  gynAndObsController = Get.put(GynAndObsController());
  return SingleChildScrollView(
    child: Container(
      child: Column(
          children: [
            Obx(() => Column(
                children: [
                  if(historyController.oldPatientHistoryList.isNotEmpty)
                    ExpansionTile(
                      title: Text("General History"),
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: historyController.oldPatientHistoryList.length,
                          itemBuilder: (context, index) {
                            var history = historyController.oldPatientHistoryList[index];
                            List  items = history['items']!;
                            return Card(
                              child: ExpansionTile(
                                initiallyExpanded: false,
                                title: Text(history['category'], style: TextStyle(fontWeight: FontWeight.w500),),
                                children: items.map((item) {
                                  return ListTile(
                                    title: Row(
                                      children: [
                                        // InkWell(onTap: (){
                                        //   historyController.selectedHistory.remove(item);
                                        //   historyController.selectedHistory.refresh();
                                        //   historyController.groupDataByCategory();
                                        // }, child: AppIcons.clinicalDataRemove),
                                        SizedBox(width: 5,),
                                        Text(item.name),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  if(historyController.oldPatientHistoryList.isEmpty && childHistoryController.isDataExist.value == false && gynAndObsController.isDataExist.value == false)
                    Center(child: Text("Patient History Not Found")),
                  if(childHistoryController.isDataExist.value == true)
                    ExpansionTile(
                      title: Text("Child History"),
                      children: [
                        selectedChildHistory(context, true),
                      ],
                    ),

                  if(gynAndObsController.isDataExist.value == true)
                    ExpansionTile(
                      title: Text("Gyn And Obs History"),
                      children: [
                        selectedGynHistory(context, true),
                      ],
                    ),

                ]
            )),


          ]
      ),
    ),
  );
}