

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/company_name/company_name_controller.dart';
import 'package:dims_vet_rx/controller/drug_generic/drug_generic_controller.dart';
import '../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../others_data_screen/add_new_brand.dart';
import 'all_drug_brand_list.dart';
import 'favorite_drug_list.dart';

final PrescriptionController prescriptionController = Get.put(PrescriptionController());
showAddMedicineModal(context, fieldName){

  final CompanyNameController companyNameController = Get.put(CompanyNameController());
  final DrugGenericController drugGenericController = Get.put(DrugGenericController());

  var screenHeight = MediaQuery.of(context).size.height * 0.950;
  var screenWidth = MediaQuery.of(context).size.width  * 0.950;

      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: addMedicineTitleHeader(companyNameController, drugGenericController, context),

          content: addMedicineMainContent(screenWidth, screenHeight, drugGenericController, companyNameController),

        );
      });
}
addMedicineEndDrawer(context){
  final CompanyNameController companyNameController = Get.put(CompanyNameController());
  final DrugGenericController drugGenericController = Get.put(DrugGenericController());
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  var screenHeight = MediaQuery.of(context).size.height * 0.9;
  var screenWidth = MediaQuery.of(context).size.width  * 0.9;
  return SizedBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        addMedicineTitleHeader(companyNameController, drugGenericController, context),
        addMedicineMainContent(screenWidth, screenHeight, drugGenericController, companyNameController),
      ],
    ),
  );
}
Container addMedicineMainContent(double screenWidth, double screenHeight, DrugGenericController drugGenericController, CompanyNameController companyNameController) {
  return Container(
        width: screenWidth,
        height: screenHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Obx(() => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if(prescriptionController.searchedGenericName.isNotEmpty || prescriptionController.searchedCompanyName.isNotEmpty)
                      Row(
                        children: [
                          // ElevatedButton(onPressed: (){}, child: Text("${prescriptionController.searchedGenericName.value}")),
                          if(prescriptionController.searchedGenericName.isNotEmpty)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(prescriptionController.searchedGenericName[0].generic_name),
                                  IconButton(onPressed: ()async{
                                    drugGenericController.getAllData('');
                                    prescriptionController.searchedGenericName.clear();
                                    if(prescriptionController.searchedCompanyName.isEmpty){
                                      await prescriptionController.getAllBrandData('');
                                    }else{
                                      await prescriptionController.getAllBrandData('');
                                      prescriptionController.searchByCompany(prescriptionController.searchedCompanyName[0].id);
                                    }
                                  }, icon: Icon(Icons.close)),
                                ],
                              ),
                            ),
                          ),
                          if(prescriptionController.searchedCompanyName.isNotEmpty)
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(prescriptionController.searchedCompanyName[0].company_name),
                                  IconButton(onPressed: ()async{
                                    companyNameController.getAllData('');
                                    prescriptionController.searchedCompanyName.clear();
                                    if(prescriptionController.searchedGenericName.isEmpty){
                                      await prescriptionController.getAllBrandData('');
                                    }else{
                                      await prescriptionController.getAllBrandData('');
                                      prescriptionController.searchByGeneric(prescriptionController.searchedGenericName[0].id);
                                    }

                                  }, icon: Icon(Icons.close)),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),

                    if(!Platform.isAndroid)
                    if(prescriptionController.showFavoriteList.value != true )
                      allDrugListWidget(),
                    //
                    if(!Platform.isAndroid)
                    if(prescriptionController.showFavoriteList.value == true)
                      favoriteDrugListWidget(),

                    if(Platform.isAndroid)
                      if(prescriptionController.brandSearchController.text.toString().length > 1)
                        allDrugListWidget(),

                    if(Platform.isAndroid)
                      if(prescriptionController.brandSearchText.value.length < 1)
                      favoriteDrugListWidget(),



                  ],
                ),
                ),
              ),
            ],
          ),
        );
}

Column addMedicineTitleHeader(CompanyNameController companyNameController, DrugGenericController drugGenericController, BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: screenWidth > 900 ? 400 : screenWidth > 600 ? 300 : 250,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: true,
                      controller: prescriptionController.brandSearchController,
                      decoration:   InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "Search by brand name...",
                          // suffixIcon: IconButton(onPressed: (){
                          //   prescriptionController.brandSearchController.clear();
                          //   prescriptionController.getAllBrandData('');
                          // }, icon: const Icon(Icons.cancel_outlined,size: 12,))
                          suffixIcon: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(onPressed: (){
                                    // advanceSearch(context);
                                    prescriptionController.brandSearchController.clear();

                                    if(!Platform.isAndroid){
                                      if(prescriptionController.searchedCompanyName.isNotEmpty){
                                        companyNameController.getAllData('');
                                        prescriptionController.searchedCompanyName.clear();
                                      }
                                      if(prescriptionController.searchedGenericName.isNotEmpty){
                                        drugGenericController.getAllData('');
                                        prescriptionController.searchedGenericName..clear();
                                      }
                                      prescriptionController.getAllBrandData('');
                                    }
                                    if(Platform.isAndroid){
                                      prescriptionController.modifyDrugData.clear();
                                      if(prescriptionController.showFavoriteList.value){
                                        prescriptionController.getAllBrandData('');
                                      }


                                    }


                                  }, icon: const Icon(Icons.clear)),
                                  // ElevatedButton(onPressed: (){}, child: Text("Advance Search")),

                                  if(screenWidth > 600)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [


                                      if(!Platform.isAndroid)
                                      Tooltip(message: "Search By Generic", child: IconButton(onPressed: (){
                                      }, icon: IconButton(onPressed: (){
                                        genericSearchModal(context);
                                      }, icon: Icon(Icons.search)),)),

                                      if(!Platform.isAndroid)
                                      Tooltip(message: "Search By Company", child: IconButton(onPressed: (){
                                      }, icon: IconButton(onPressed: (){
                                        companySearchModal(context);
                                      }, icon: Icon(Icons.manage_search)),)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                      ),
                          onChanged: (value){

                            //for Tab and Mobile
                            if(!Platform.isAndroid){
                              prescriptionController.getAllBrandData(prescriptionController.brandSearchController.text.toString());
                            }

                            //desktop and web
                            if(Platform.isAndroid){
                              if(prescriptionController.brandSearchController.text.length > 2){
                                // prescriptionController.modifyDrugData.clear();
                                prescriptionController.brandSearchText.value = value;
                                prescriptionController.getAllBrandData(value);
                              }
                              if(prescriptionController.brandSearchController.text.length <= 1){
                                // prescriptionController.modifyDrugData.clear();
                                prescriptionController.brandSearchText.value = '';
                              }
                            }

                          },
                    ),
                  ),
                ),

                // if(!Platform.isAndroid)
                // Obx(() => FilterChip(
                //   label: Text("Show Favorite"),
                //   selected:  prescriptionController.showFavoriteList.value,
                //   onSelected: (bool isSelected) async{
                //     await prescriptionController.showFavoriteListFunction(isSelected);
                //     //prescriptionController.getAllBrandData('');
                //   },
                //   backgroundColor: Colors.grey[200],
                //   checkmarkColor: Colors.white,
                // )),

                if(screenWidth > 600)
                  FilledButton(onPressed: (){
                    addNewBrandModal(context);
                  }, child: Text("+ Create New")),

                IconButton(onPressed: (){
                  prescriptionController.brandSearchController.clear();
                  prescriptionController.searchedGenericName.clear();
                  prescriptionController.searchedCompanyName.clear();
                  if(!Platform.isAndroid){
                    prescriptionController.getAllBrandData('');
                  }else{
                    prescriptionController.brandSearchText.value = '';
                  }

                  Navigator.pop(context);
                }, icon: Icon(Icons.clear)),
              ],
            ),
            if(screenWidth < 600)
            Card(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ElevatedButton(onPressed: (){}, child: Text("Advance Search")),
              
                  if(!Platform.isAndroid)
                    Tooltip(message: "Search By Generic", child: IconButton(onPressed: (){
                    }, icon: IconButton(onPressed: (){
                      genericSearchModal(context);
                    }, icon: Icon(Icons.search)),)),
              
                  if(!Platform.isAndroid)
                    Tooltip(message: "Search By Company", child: IconButton(onPressed: (){
                    }, icon: IconButton(onPressed: (){
                      companySearchModal(context);
                    }, icon: Icon(Icons.manage_search)),)),
                ],
              ),
            ),

          ],
        );
}


Future addNewBrandModal(context){
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Add New Brand"),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.clear),)
        ]
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.width * 0.7,
        child: dropDownSearch(isShowAppBar: false,),
      ),
    );
  });
}

genericSearchModal(context){
  DrugGenericController genericController = Get.put(DrugGenericController());
  print(genericController.isSearch.value);
   showDialog(context: context, builder: (context){
     return AlertDialog(
       title: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           const Text("Search by Generic"),
           IconButton(onPressed: (){
             genericController.isSearch.value = false;
             genericController.searchController.clear();
             Navigator.pop(context);
           }, icon: Icon(Icons.clear),)
         ]
       ),
       content: Container(
         width: MediaQuery.of(context).size.width * 0.5,
         height: MediaQuery.of(context).size.height * 0.9,
         child: Obx(() => SingleChildScrollView(
           child: Column(
             children: [ 
               TextField(
               controller: genericController.searchController,
               decoration:   InputDecoration(
                   border: const OutlineInputBorder(),
                   hintText: "Search by generic..",
                   prefixIcon: const Icon(Icons.search),
                   suffixIcon: IconButton(onPressed: (){
                     // Navigator.pop(context);
                     genericController.searchController.clear();
                     genericController.isSearch.value = false;
                   }, icon: const Icon(Icons.clear))
               ),
               onChanged: (value){
                 // prescriptionController.drugBrandSearch(value);
                 if(value.length >2){
                   genericController.isSearch.value = true;
                   genericController.getAllData(value);
                 }
               },
             ),
               SingleChildScrollView(
                 child: Column(
                   children: [
                     if(genericController.isSearch.value == true)
                       SingleChildScrollView(
                         child: ListView.builder(
                           itemCount: genericController.dataList.length,
                           shrinkWrap: true,
                           itemBuilder: (context, index){
                             return ListTile(
                               title: Text(genericController.dataList[index].generic_name),
                               onTap: ()async{
                                genericController.isSearch.value = false;
                                 prescriptionController.showFavoriteList.value = false;
                                 prescriptionController.searchedGenericName.clear();
                                 await prescriptionController.getAllBrandData('');
                                 prescriptionController.searchedGenericName.add(genericController.dataList[index]);
                                 prescriptionController.searchByGeneric(genericController.dataList[index].id);
                                 genericController.searchController.clear();
                                 print(genericController.isSearch.value);
                                 Navigator.pop(context);
                               },
                             );
                           },
                         ),
                       )
                   ],
                 ),
               ),
             ],
           ),
         )),
       ),

     );
   });
}
companySearchModal(context){
  final CompanyNameController companyNameController = Get.put(CompanyNameController());
   showDialog(context: context, builder: (context){
     return AlertDialog(
       title: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           const Text("Search by Company"),
           IconButton(onPressed: (){
             companyNameController.isSearch.value = false;
             companyNameController.searchController.clear();
             Navigator.pop(context);
           }, icon: Icon(Icons.clear),)
         ]
       ),
       content: Container(
         width: MediaQuery.of(context).size.width * 0.5,
         height: MediaQuery.of(context).size.height * 0.9,
         child: Obx(() => SingleChildScrollView(
           child: Column(
             children: [
               TextField(
               controller: companyNameController.searchController,
               decoration:   InputDecoration(
                   border: const OutlineInputBorder(),
                   hintText: "Search by company..",
                   prefixIcon: const Icon(Icons.search),
                   suffixIcon: IconButton(onPressed: (){
                     // Navigator.pop(context);
                     companyNameController.searchController.clear();
                     companyNameController.isSearch.value = false;
                   }, icon: const Icon(Icons.clear))
               ),
               onChanged: (value){
                 // prescriptionController.drugBrandSearch(value);
                 if(value.length >2){
                   companyNameController.isSearch.value = true;
                   companyNameController.getAllData(value);
                 }
               },
             ),
               SingleChildScrollView(
                 child: Column(
                   children: [
                     if(companyNameController.isSearch.value == true)
                       SingleChildScrollView(
                         child: ListView.builder(
                           itemCount: companyNameController.dataList.length,
                           shrinkWrap: true,
                           itemBuilder: (context, index){
                             return ListTile(
                               title: Text(companyNameController.dataList[index].company_name),
                               onTap: (){
                                 companyNameController.isSearch.value = false;
                                 prescriptionController.showFavoriteList.value = false;
                                 prescriptionController.getAllBrandData('');
                                 prescriptionController.searchedCompanyName.add(companyNameController.dataList[index]);
                                 prescriptionController.searchByCompany(companyNameController.dataList[index].id);
                                 companyNameController.searchController.clear();
                                 Navigator.pop(context);
                               },
                             );
                           },
                         ),
                       )
                   ],
                 ),
               ),
             ],
           ),
         )),
       ),

     );
   });
}