import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controller/child_history/child_history_controller.dart';
import '../../controller/drawer_controller/drawer_controller.dart';
import '../../controller/gyn_and_obs/gyn_and_obs_controller.dart';
import '../../controller/investigation_report_image/investigation_report_image_cotroller.dart';
import '../../controller/patient_disease_image/patient_disease_image_controller.dart';
import '../common_screen/common_screen.dart';
import 'create_prescription_components/clinical_data/left_clinical_widget.dart';
import 'create_prescription_components/clinical_data/patient_histry.dart';

customPopupDialog(context, title, [showFavButton = false,selectedData,individualController,prescriptionController,favoriteSegmentName]) {

  final screenWidth = MediaQuery.of(context).size.width;
  final childHistory = Get.put(ChildHistoryController());
  final gynAndObs = Get.put(GynAndObsController());
  final DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
  final List<Widget> endDrawerScreen = [
    patientHistory(context),
    // procedurePrescriptionWidget(context),
    // oldPatientHistory(context),
    // procedureScreen(context),
  ];

  showDialog(context: context, builder: (context){
    PatientDiseaseImageController patientDiseaseImageController = Get.put(PatientDiseaseImageController());
    InvestigationReportImageController investigationReportImageController = Get.put(InvestigationReportImageController());
    return AlertDialog(
      title: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          Text(title.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth > 600 ? 20 : 15),),
          if(showFavButton && screenWidth > 600)
            // Obx(() =>  FilterChip(
            //     selected: favoriteIndexController.iShowFavorite.value,
            //     label: Text("Show Favorite"),
            //     onSelected: (selected){
            //       favoriteIndexController.iShowFavorite.value = !favoriteIndexController.iShowFavorite.value;
            //     }
            // ),),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              // if(showFavButton && screenWidth < 600)
              //   Obx(() =>  FilterChip(
              //       selected: favoriteIndexController.iShowFavorite.value,
              //       label: Text("Show Favorite"),
              //       onSelected: (selected){
              //         favoriteIndexController.iShowFavorite.value = !favoriteIndexController.iShowFavorite.value;
              //       }
              //   ),),
              IconButton(onPressed: (){
                individualController.getAllData('');
                individualController.searchController.clear();
                Navigator.pop(context);
                favoriteIndexController.iShowFavorite.value = true;
                patientDiseaseImageController.patientDiseaseList.clear();
                investigationReportImageController.investigationReportImageList.clear();
                if(childHistory.isDataExist.value == true){
                  childHistory.dataClear();
                }
                if(gynAndObs.isDataExist.value == true){
                  gynAndObs.dataClear();
                }
              }, icon: Icon(Icons.clear)),
            ],
          )
        ],
      ),
      contentPadding: EdgeInsets.all(10),
      content: Container(
        height: MediaQuery.of(context).size.height * .9,
        width: MediaQuery.of(context).size.width * .9,
        child: SingleChildScrollView(
          child: Obx(() => Column(
              children: [
                if(drawerMenuController.commonClinicalPopupCurrentScreen.value >=0 && drawerMenuController.commonClinicalPopupCurrentScreen.value <=4)
                Column(
                  children: [
                    clinicalDataListScreen(context,title, individualController,selectedData,prescriptionController, favoriteSegmentName,true),
                  ],
                ),

              ]
          )),
        ),

      ),
    );
  });
}