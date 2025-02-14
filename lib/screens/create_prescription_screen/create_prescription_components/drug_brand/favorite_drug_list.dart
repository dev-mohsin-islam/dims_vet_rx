

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../controller/dose/dose_controller.dart';
import '../../../../controller/favorite_index/favorite_index_controller.dart';
import '../../../../controller/general_setting/general_setting_controller.dart';
import '../../../../controller/instruction/instruction_controller.dart';
import '../../../../controller/prescription_duration/prescription_duration_controller.dart';
import 'components/add_drug_main_container.dart';
import 'components/add_more_dose.dart';
import 'components/drug_add_to_prescription.dart';
import 'components/drug_dose.dart';
import 'components/drug_duration.dart';
import 'components/drug_instruction.dart';
import 'components/drug_note.dart';
import 'components/expansion_tile.dart';
import 'components/expansion_tile_title.dart';
import 'components/remove_dose.dart';

Widget favoriteDrugListWidget(){
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final brandList = prescriptionController.favoriteDrugList;
  final FavoriteIndexController favoriteIndexController = Get.put(FavoriteIndexController());
  final GeneralSettingController generalSettingController = Get.put(GeneralSettingController());


  //dose list
  final DoseController doseController = Get.put(DoseController());
  final doseList = doseController.dataList;


  final DurationController durationController = Get.put(DurationController());
  final durationList = durationController.dataList;

  //instruction
  final InstructionController instructionController = Get.put(
      InstructionController());
  final instructionList = instructionController.dataList;

  if(prescriptionController.favoriteDrugList.isEmpty)
    return Center(
      child: Column(
        children: [
          SizedBox(height: 30,),
          Text("Favorite Data List is empty",style: TextStyle(fontSize: 16),),
          SizedBox(height: 30,),
          TextButton(onPressed: (){
            prescriptionController.showFavoriteList.value = false;
          }, child: Text("Show All Data List"))
        ],
      ),
    );

  // if(prescriptionController.favoriteDrugList.isEmpty)
  return addDrugMainContainer(brandList, prescriptionController,favoriteIndexController, generalSettingController, doseList, durationList, instructionList);
}

 


