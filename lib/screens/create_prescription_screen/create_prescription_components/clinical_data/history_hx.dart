

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/clinical_data/patient_histry.dart';

import '../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../controller/drawer_controller/drawer_controller.dart';
import '../../../../controller/general_setting/general_setting_controller.dart';
import '../../../../controller/history/history_controller.dart';
import '../../../../utilities/app_icons.dart';
import '../../../../utilities/app_strings.dart';

history_hx(GeneralSettingController generalSettingController, PrescriptionController prescriptionController, BuildContext context) {
  final historyController = Get.put(HistoryController());
  final DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
  return Column(
    children: [
      Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text("History (Hx)", style: const TextStyle(  color: Colors.black, fontWeight: FontWeight.bold),),
              // child: SearchBarApp(),
              // child: TextFormField(
              //   // controller: historyController,
              //   decoration: InputDecoration(
              //     // suffixIcon: Icon(Icons.search),
              //     border: InputBorder.none,
              //     labelText: "History (Hx)",
              //     // hintStyle: const TextStyle(  color: Colors.black, fontWeight: FontWeight.bold),
              //     labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              //     contentPadding: EdgeInsets.zero
              //   ),
              // ),
            ),),
            // ElevatedButton(onPressed: (){
            //   treatmentPlanDialog(context);
            // }, child: Text("View Plans")),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: Colors.black
              ),
              child: IconButton(onPressed: () async {
                  historyDialog(context);
              }, icon: Icon(Icons.add_box, size: Platform.isAndroid ? 30 : 25, color: Colors.black,),),
            ),
          ],
        ),
      ),
      historySelectedDataContainer(historyController)
    ],
  );
}

Container historySelectedDataContainer(HistoryController historyController) {
  return Container(
      child: Obx(() => Column(
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: historyController.selectedHistoryGroupByCat.length,
              itemBuilder: (context, index) {
                String category = historyController.selectedHistoryGroupByCat.keys.elementAt(index);
                List  items = historyController.selectedHistoryGroupByCat[category]!;
                var categoryData = historyController.category.firstWhere((element) => element['value'] == category, orElse: () => null);

                return ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(categoryData != null ? categoryData['name'] : 'History', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),),
                  children: items.map((item) {
                    return ListTile(
                      title: Row(
                        children: [
                          InkWell(onTap: (){
                            historyController.selectedHistory.remove(item);
                            historyController.selectedHistory.refresh();
                            historyController.groupDataByCategory();
                          }, child: AppIcons.clinicalDataRemove),
                          SizedBox(width: 5,),
                          Text(item.name),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            )
          ]
      )),
    );
}