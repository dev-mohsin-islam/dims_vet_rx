



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/drug_brand/components/expansion_tile.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/drug_brand/components/favorite_add_&_remove.dart';

import '../../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../../controller/favorite_index/favorite_index_controller.dart';
import '../../../../../controller/general_setting/general_setting_controller.dart';
import '../../../../../utilities/app_strings.dart';

Container addDrugMainContainer(List<dynamic> modifyDrugData, PrescriptionController prescriptionController, FavoriteIndexController favoriteIndexController, GeneralSettingController generalSettingController, RxList<dynamic> doseList, RxList<dynamic> durationList, RxList<dynamic> instructionList) {
  bool isFavorite = true;
  return Container(
    child:  Expanded(
      child: Column(
        children: [
          if(prescriptionController.selectedMedicine.length > 0)
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text("Selected Brands: ", style: TextStyle(fontWeight: FontWeight.bold),),
              // prescriptionController.selectedMedicine
              for(int i = 0; i < prescriptionController.selectedMedicine.length; i++)
                Tooltip(
                   message: prescriptionController.selectedMedicine[i]['generic_name'] + " - " + prescriptionController.selectedMedicine[i]['strength'] + " - " + prescriptionController.selectedMedicine[i]['form'],
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(prescriptionController.selectedMedicine[i]['brand_name'], style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                            InkWell(
                              onTap: (){
                                prescriptionController.selectedMedicine.removeAt(i);
                              },
                              child: Icon(Icons.delete_forever, size: 20, color: Colors.red,),
                            )
                          ],
                        ),
                      ),
                    )),

            ],
          ),
          Obx(() {
            return
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: modifyDrugData.length,
                    itemBuilder: (context, index){
                      var drugData = modifyDrugData[index];
                      var favoriteIndex =  modifyDrugData[index]['brand_id'];
                      var isSelected =  prescriptionController.selectedMedicine.indexWhere((element) => element['brand_id'] == drugData['brand_id']);
                      var favoriteId =   favoriteIndexController.favoriteIndexDataList.firstWhere((element) => element.favorite_id == favoriteIndex && element.u_status !=2 && element.segment ==FavSegment.brand, orElse: () => null,);

                      // if(prescriptionController.showFavoriteList.value ==false )
                      return Column(
                          children: [
                            if(isSelected == -1)
                            Row(
                              children: [
                                favoriteAndRemove(favoriteId, favoriteIndexController, favoriteIndex, prescriptionController),
                                Flexible(
                                  child: InkWell(
                                    onTap: (){

                                    },
                                    child: Card(
                                        color: isSelected == -1 ? Colors.grey[200] : Colors.blueAccent[100] ,
                                        child: Obx(() => expansionTile(prescriptionController, drugData, generalSettingController, doseList, durationList, instructionList, "addNew"))
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          ]

                      );


                    },

                ),
              );

          }),
        ],
      ),
    ),
  );
}

