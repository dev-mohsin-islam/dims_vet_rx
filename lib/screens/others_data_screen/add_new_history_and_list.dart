
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/favorite_index/favorite_index_controller.dart';
 import 'package:dims_vet_rx/utilities/app_strings.dart';

import '../../controller/history/history_controller.dart';
import '../../utilities/history_category.dart';
import '../common_screen/common_screen.dart';

Widget historyScreen(context){
  final HistoryController controller = Get.put(HistoryController());
  return Column(
    children: [
      Obx((){
        return Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 5,
                  children: [
                    const SizedBox(
                        child: Text(ScreenTitle.screenHistory, style: TextStyle(fontSize: 20,color: Colors.black54),)),
                    // SizedBox(
                    //   width: 300,
                    //   child: TextField(
                    //     controller: controller.searchController,
                    //     decoration:   InputDecoration(
                    //       hintText: 'Search..',
                    //       border: const OutlineInputBorder(),
                    //       prefixIcon: const Icon(Icons.search),
                    //       suffixIcon: controller.searchController.text.isNotEmpty
                    //           ? IconButton(
                    //         icon: const Icon(Icons.cancel_outlined),
                    //         onPressed: () {
                    //           controller.clearText();
                    //         },
                    //       ) : null,
                    //     ),
                    //     onChanged: (value)async{
                    //       await controller.getAllData(value);
                    //     },
                    //   ),
                    // ),
                    ElevatedButton(onPressed: (){
                      controller.clearText();
                      historyCategoryDialog(context);
                    }, child: const Text("Create New Category")),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.height * 0.8,
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         for(var i =0; i<controller.category.length; i++)
                           if(controller.category[i]["value"] !='')
                           Card(
                             child: Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Wrap(
                                 children: [
                                   Row(
                                     children: [
                                       Text(controller.category[i]["name"]),
                                     ],
                                   ),
                                   const Spacer(),
                                   Row(
                                     children: [
                                       ElevatedButton(onPressed: (){
                                         viewCategoryWiseData(context, controller.category[i]);
                                       }, child: Text("View All History")),
                                       IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
                                       IconButton(onPressed: (){

                                          }, icon: Icon(Icons.delete)),
                                     ],
                                   )
                                 ],
                               ),
                             ),
                           )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ) ;
      }),
    ],
  );
}

Widget _dataLis(context, controller){
  final HistoryController historyController = Get.put(HistoryController());
  return    SizedBox(
    height: MediaQuery.of(context).size.height * 0.7,

    child: Obx(() =>  SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          catDataLit(historyController, HistoryCategory.personalHistoryCategory, HistoryCategory.personalHistoryTitle),
          catDataLit(historyController, HistoryCategory.familyHistoryCategory, HistoryCategory.familyHistoryTitle),
          catDataLit(historyController, HistoryCategory.foodAllergyHistoryCategory, HistoryCategory.foodAllergyHistoryTitle),
          catDataLit(historyController, HistoryCategory.socialHistoryCategory, HistoryCategory.socialHistoryTitle),
          catDataLit(historyController, HistoryCategory.environmentalAllergyHistoryCategory, HistoryCategory.environmentalAllergyHistoryTitle),
          catDataLit(historyController, HistoryCategory.drugAllergyHistoryCategory, HistoryCategory.drugAllergyHistoryTitle),


        ],
      ),
    )),
  );;
}

  catDataLit(HistoryController historyController, categoryName, title) {
  final favoriteIndexController = Get.put(FavoriteIndexController());
  return Column(
    children: [
      Card(
              child: ExpansionTile(
                initiallyExpanded: false,
                title:   Text(title),
                children: [
                 ListView.builder(
                   shrinkWrap: true,
                   itemCount: historyController.dataList.length,
                   itemBuilder: (context, index) {
                     var item = historyController.dataList[index];
                     int favoriteId = item.id;
                     var favoriteIndex = favoriteIndexController.favoriteIndexDataList.firstWhere((element) => element.favorite_id == favoriteId && element.u_status !=2 && element.segment =='history', orElse: () => null,);
                       return  Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [

                           if (item.name != null && item.category == categoryName)
                           Card(
                             child: Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Row(
                                   children: [
                                     if(favoriteIndex != null)
                                       IconButton(onPressed: (){
                                         favoriteIndexController.updateData(favoriteIndexController.favoriteIndexDataList.length + 1,FavSegment.history, favoriteId );
                                         historyController.getAllData('');
                                         favoriteIndexController.getAllData('');
                                       },
                                         icon: Icon(Icons.star),
                                       ),
                                     if(favoriteIndex == null)
                                       IconButton(onPressed: (){
                                         favoriteIndexController.addData(favoriteIndexController.favoriteIndexDataList.length + 1,FavSegment.history, favoriteId );
                                         historyController.getAllData('');

                                         favoriteIndexController.getAllData('');
                                       },
                                         icon: Icon(Icons.star_border),

                                       ),
                                     Text(item.name),
                                   ]
                               ),
                             ),
                           ),
                         ],
                       );
                       {
                       return SizedBox.shrink();
                     }
                   },
                 )
                  ]
              ),
            ),
    ],
  );
}



Future  newAddAndUpdateDialog(context, id,  controller) async {

print(id);
  Get.defaultDialog(
    title: id == 0 ? "Create New" : "Update",
    textConfirm: id == 0 ? "Add" : "Update",
    onConfirm: () async {
      final idNewData = controller.dataList.length + 1;
      id == 0 ? (await controller.addData(idNewData)) : controller.updateData(id);
      Navigator.pop(context);
    },
    textCancel: "Cancel",
    barrierDismissible: false,
    content: SingleChildScrollView(
        child:   Column(
          children: [
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                hintText: "Enter history name",
                border: OutlineInputBorder(),
              ),
            ),
         Obx(() =>  Card(
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 8.0),
             child: DropdownButton<dynamic>(
                 value: controller.selectedCategory.value.toString(),
                 onChanged: (dynamic newValue) {
                   controller.selectedCategory.value = newValue;
                 },

                 items:
                 controller.category.map<DropdownMenuItem<dynamic>>((dynamic value) {
                   return DropdownMenuItem<dynamic>(
                     value: value['value'],
                     child: Text(value['name']),
                   );
                 }).toList()

             ),
           ),
         )),

          ],
        )) ,

  );
}


  historyCategoryDialog(context){
  HistoryController historyController = Get.put(HistoryController());
  showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Create New Category"),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.clear))
        ],
      ),
      actions: [
        FilledButton(onPressed: (){

          historyController.historyCategoryCUD(historyController.boxHistoryCategory.length + 1, CRUD.add);

        }, child: Text("Save"))
      ],
      content: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: TextField(
                controller: historyController.historyCatNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Category Name",
                ),
              ),
            )
          ],
        ),
      ),
    );
  });
}

  viewCategoryWiseData(context, category) {
  final historyController = Get.put(HistoryController());
  showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Wrap(
        children: [
          Text(category['name']),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              ElevatedButton(onPressed: (){
                historyController.clearText();
                newAddAndUpdateDialog(context, 0, historyController);
              }, child: const Text("Create New")),
              IconButton(onPressed: (){
                historyController.getAllData('');
                historyController.searchController.clear();
                Navigator.pop(context);
              }, icon: Icon(Icons.clear))
            ],
          )
        ],
      ),
      content: Obx(() => Column(
        children: [
          TextField(
            controller: historyController.searchController,
            onChanged: (value){
              historyController.getAllData(value);
              print(value);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Search",
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ListView.builder(
                    //     itemCount: 30,
                    //     itemBuilder: (context, index){
                    //   return  Text("History");
                    // })

                    ListView(
                      shrinkWrap: true,
                      children: [
                        for(var i = 0; i < historyController.dataList.length; i++)
                          if(historyController.dataList[i].category == category['value'])
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.center,

                                  children: [
                                    Text(historyController.dataList[i].name),
                                    Wrap(
                                      children: [

                                        IconButton(onPressed: (){
                                          historyController.nameController.text = historyController.dataList[i].name;
                                          newAddAndUpdateDialog(context, historyController.dataList[i].id, historyController);

                                        }, icon: Icon(Icons.edit)),
                                        IconButton(onPressed: (){
                                          Navigator.pop(context);
                                        }, icon: Icon(Icons.delete_outline)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                      ],
                    )
                  ],
                ),
              )),
        ],
      )),
    );
  });
}








