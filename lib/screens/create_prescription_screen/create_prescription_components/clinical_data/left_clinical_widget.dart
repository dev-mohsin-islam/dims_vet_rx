

  import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/models/history/history_model.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/clinical_data/physician_notes.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/clinical_data/procedure.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/clinical_data/referral_short.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/clinical_data/treatment_plan_modal.dart';

import '../../../../controller/advice/advice_controller.dart';
import '../../../../controller/appointment/appointment_controller.dart';
import '../../../../controller/chief_complain/chief_complain_controller.dart';
import '../../../../controller/child_history/child_history_controller.dart';
import '../../../../controller/create_prescription/prescription/methods/custom_findings_controller.dart';
import '../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../controller/diagnosis/diagnosis_controller.dart';
import '../../../../controller/drawer_controller/drawer_controller.dart';
import '../../../../controller/favorite_index/favorite_index_controller.dart';
import '../../../../controller/general_setting/data_ordering_controller.dart';
import '../../../../controller/general_setting/general_setting_controller.dart';
import '../../../../controller/gyn_and_obs/gyn_and_obs_controller.dart';
import '../../../../controller/history/history_controller.dart';
import '../../../../controller/investigation/investigation_controller.dart';
import '../../../../controller/investigation_report/Investigation_report_controller.dart';
import '../../../../controller/investigation_report_image/investigation_report_image_cotroller.dart';
import '../../../../controller/on_examination/on_examination_controller.dart';
import '../../../../controller/patient_disease_image/patient_disease_image_controller.dart';
import '../../../../controller/procedure/procedure_controller.dart';
import '../../../../models/chief_complain/chief_complain_model.dart';
import '../../../../models/diagnosis/diagnosis_modal.dart';
import '../../../../models/investigation/investigation_modal.dart';
import '../../../../models/investigation_report/investigation_report_model.dart';
import '../../../../models/on_examination/on_examination_model.dart';
import '../../../../utilities/app_icons.dart';
import '../../../../utilities/app_strings.dart';
import '../../../../utilities/helpers.dart';
import '../../../../utilities/style.dart';
import '../../../common_screen/common_screen.dart';
import '../../../others_data_screen/glass_prescription.dart';
import '../../create_prescription_screen.dart';
import '../../popup_screen.dart';
import '../patient_appointment/patient_disease_image_upload.dart';
import 'child_history_modal.dart';
import 'drop_down_search.dart';
import 'gyne_and_obs.dart';
import 'history_hx.dart';
import 'immunization.dart';
import 'investigation_image_upload.dart';

ClinicalDataWidgetList() {
   var context = Get.context;
   final generalSettingController = Get.put(GeneralSettingController());
   final prescriptionController = Get.put(PrescriptionController());
   final dataOrderingController = Get.put(DataOrderingController());
   double screenWidth = MediaQuery.of(context!).size.width;
   double screenHeight = MediaQuery.of(context).size.height;
   final ProcedureController procedureController = Get.put(ProcedureController());
   final AdviceController adviceController = Get.put(AdviceController());
   final selectedChiefComplain = prescriptionController.selectedChiefComplain;
   final selectedOnExamination  = prescriptionController.selectedOnExamination;
   final selectedDiagnosis     = prescriptionController.selectedDiagnosis;
   final selectedInvestigationAdvice = prescriptionController.selectedInvestigationAdvice;
   final selectedInvestigationReport = prescriptionController.selectedInvestigationReport;
   final selectedProcedure = procedureController.selectedProcedure;
   final selectedShortAdvice = prescriptionController.selectedShortAdvice;
   final historyController = Get.put(HistoryController());
   final selectedPersonalHistory = prescriptionController.selectedPersonalHistory;
   final selectedFamilyHistory = prescriptionController.selectedFamilyHistory;
   final selectedSocialHistory = prescriptionController.selectedSocialHistory;
   final selectedPast = prescriptionController.selectedPastHistory;
   final selectedAllergyHistory = prescriptionController.selectedAllergyHistory;
   final selectedAllHistory = prescriptionController.selectedAllHistory;
   final AppointmentController appointmentController = Get.put(AppointmentController());
   final ChiefComplainController ccController = Get.put(ChiefComplainController());
   final OnExaminationController oeController = Get.put(OnExaminationController());
   final DiagnosisController diController = Get.put(DiagnosisController());
   final InvestigationController iaController = Get.put(InvestigationController());
   final InvestigationReportController irController = Get.put(InvestigationReportController());
   final customFindingsController = Get.put(CustomFindingsController());

   List<Map<String, dynamic>> clinicalWidgetList = [
     {
       "index": 1,
       "isTemplateShow": true,
       "isShow":  generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "ChiefComplain"),
       "title": "Chief Complains",
       "Widget":  ClinicalCommonDropDown("Chief Complaint (C/C)",prescriptionController.selectedChiefComplain, ccController,FavSegment.chiefComplain,ChiefComplainModel),
     },
     {
       "index": 2,
       "isTemplateShow": true,
       "isShow":  generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "OnExamination"),
       "title": "On Examination ",
       "Widget":  Column(
         children: [
           ClinicalCommonDropDown("On Examination (OE)",prescriptionController.selectedOnExamination, oeController,FavSegment.oE,OnExaminationModel,mainKey: customFindingsController.keyOe),
           oEAppointmentData()
         ],
       ),
     },
     {
       "index": 2,
       "isTemplateShow": true,
       "isShow": generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Diagnosis"),
       "title": "Diagnosis",
       "Widget": ClinicalCommonDropDown("Diagnosis",prescriptionController.selectedDiagnosis, diController,FavSegment.dia,DiagnosisModal),
     },
     {
       "index": 2,
       "isTemplateShow": true,
       "isShow": generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "InvestigationAdvice"),
       "title": "Investigation Advice",
       "Widget": ClinicalCommonDropDown("Investigation Advice (I/A)",prescriptionController.selectedInvestigationAdvice, iaController,FavSegment.ia,InvestigationModal),
     },

     {
       "index": 2,
       "isTemplateShow": true,
       "isShow": generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "InvestigationReport"),
       "title": "Investigation Report",
       "Widget": ClinicalCommonDropDown("Investigation Report (I/R)", prescriptionController.selectedInvestigationReport, irController,FavSegment.ir,InvestigationReportModel,mainKey: customFindingsController.keyIr),
     },
     // {
     //   "index": 1,
     //   "isTemplateShow": true,
     //   "isShow":  generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "ChiefComplain"),
     //   "title": "Chief Complains",
     //   "Widget":  clinicalFieldWidget(context, EndDrawerScreenValues.chiefComplain, "Chief Complaint (C/C)",prescriptionController.selectedChiefComplain, ccController,FavSegment.chiefComplain,prescriptionController),
     // },
     // {
     //   "index": 2,
     //   "isTemplateShow": true,
     //   "isShow":  generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "OnExamination"),
     //   "title": "On Examination ",
     //   "Widget": Obx(() => Column(
     //     children: [
     //       clinicalFieldWidget(context, EndDrawerScreenValues.onExamination, "On Examination (OE)",prescriptionController.selectedOnExamination, oeController,FavSegment.oE,prescriptionController),
     //       oEAppointmentData()
     //     ],
     //   )),
     // },
     //
     // {
     //   "index": 2,
     //   "isTemplateShow": true,
     //   "isShow": generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Diagnosis"),
     //   "title": "Diagnosis",
     //   "Widget": clinicalFieldWidget(context, EndDrawerScreenValues.diagnosis, "Diagnosis",prescriptionController.selectedDiagnosis, diController,FavSegment.dia,prescriptionController),
     // },
     // {
     //   "index": 2,
     //   "isTemplateShow": true,
     //   "isShow": generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "InvestigationAdvice"),
     //   "title": "Investigation Advice",
     //   "Widget": clinicalFieldWidget(context, EndDrawerScreenValues.investigationAdvice, "Investigation Advice (I/A)",prescriptionController.selectedInvestigationAdvice, iaController,FavSegment.ia,prescriptionController),
     // },
     //
     // {
     //   "index": 2,
     //   "isTemplateShow": true,
     //   "isShow": generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "InvestigationReport"),
     //   "title": "Investigation Advice",
     //   "Widget": clinicalFieldWidget(context, EndDrawerScreenValues.investigationReport, "Investigation Report (I/R)", prescriptionController.selectedInvestigationReport, irController,FavSegment.ir,prescriptionController,),
     // },
     {
       "index": 2,
       "isTemplateShow": true,
       "isShow": generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "History"),
       "title": "History Hx",
       "Widget":  ClinicalCommonDropDown("History (Hx)", historyController.selectedHistory, historyController,FavSegment.history,HistoryModel),
     },{
       "index": 2,
       "isTemplateShow": true,
       "isShow": generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "GlassRecommendation"),
       "title": "Glass Recommendations",
       "Widget":  GlassPrescription(),
     },
     {
       "index": 2,
       "isTemplateShow": true,
       "isShow": generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "ChildHistory"),
       "title": "Child History",
       "Widget":  selectedChildHistory(context),
     },
     {
       "index": 2,
       "isTemplateShow": true,
       "isShow": generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "GyneObs"),
       "title": "Gyn And Obs",
       "Widget":  selectedGynHistory(context),
     },
     {
       "index": 2,
       "isTemplateShow": false,
       "isShow": generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Immunization"),
       "title": "Immunization",
       "Widget":  immunizationCard(context),
     }, {
       "index": 2,
       "isTemplateShow": false,
       "isShow": generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "TreatmentPlan"),
       "title": "Treatment Plan",
       "Widget": selectedTreatmentPlan(context),
     },{
       "index": 2,
       "isTemplateShow": false,
       "isShow": generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "PhysicianNotes"),
       "title": "Physician Note",
       "Widget": selectedPhysicianNotes(context),
     },{
       "index": 2,
       "isTemplateShow": false,
       "isShow": generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "ReferralShort"),
       "title": "Referral Short",
       "Widget": selectedReferralShort(context),
     },
     {
       "index": 2,
       "isTemplateShow": false,
       "isShow": generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Procedure"),
       "title": "Procedure",
       "Widget": clinicalFieldProcedureWidget(context, EndDrawerScreenValues.procedure, screenHeight, screenWidth, "Procedure",  selectedProcedure,),
     },
     {
       "index": 2,
       "isTemplateShow": false,
       "title": "Investigation I/R Image",
       "isShow": generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "InvestigationReportImage"),
       "name": true,
       "Widget": investigationImageUpload(prescriptionController, context),
     },
     {
       "index": 2,
       "isTemplateShow": false,
       "title": "Patient Disease Image",
       "isShow":  (generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "PatientDiseaseImage")),
       "name": true,
       "Widget": diseaseImageUploadCard(prescriptionController, context),
     },

   ];

   for(var item in clinicalWidgetList){
     for(var item2 in dataOrderingController.dataOrdering){
       if(item['title'] == item2['title']){
         if(item2['value'] != null){
           item['index'] = parseInt(item2['value']);
         }
       }
     }
   }
   clinicalWidgetList.sort((a, b) => a["index"].compareTo(b["index"]));
    return Container(
      child: Obx(() => Column(
        children: [
          if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "ClinicalDataOrder"))
            Column(
              children: [
                for(var item in clinicalWidgetList)
                  if(item['isShow'])
                    item['Widget']
              ],
            ),
          // if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "ClinicalDataOrder"))
          //   Column(
          //   children: [
          //     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "ChiefComplain"))
          //       clinicalFieldWidget(context, EndDrawerScreenValues.chiefComplain,"Chief Complaint (C/C)",  prescriptionController.selectedChiefComplain, ccController, FavSegment.chiefComplain,prescriptionController,),
          //     // clinicalFieldWidget(context, EndDrawerScreenValues.chiefComplain, screenHeight, screenWidth, "Chief Complaint (C/C)","Chief Complaint (C/C)", selectedChiefComplain,ccController.dataList,ccController,FavSegment.chiefComplain,prescriptionController)
          //     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "OnExamination"))
          //       Obx(() => Column(
          //         children: [
          //           clinicalFieldWidget(context, EndDrawerScreenValues.onExamination,  "On Examination (O/E)", prescriptionController.selectedOnExamination, oeController, FavSegment.oE,prescriptionController,),
          //           oEAppointmentData()
          //         ],
          //       )),
          //
          //     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Diagnosis"))
          //       clinicalFieldWidget(context, EndDrawerScreenValues.diagnosis, "Diagnosis (Dx)", prescriptionController.selectedDiagnosis, diController, FavSegment.dia,prescriptionController),
          //
          //     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "InvestigationAdvice"))
          //       clinicalFieldWidget(context, EndDrawerScreenValues.investigationAdvice,  "Investigation Advice (I/A)", prescriptionController.selectedInvestigationAdvice, iaController, FavSegment.ia,prescriptionController),
          //
          //     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "InvestigationReport"))
          //       clinicalFieldWidget(context, EndDrawerScreenValues.investigationReport,  "Investigation Report (I/R)", prescriptionController.selectedInvestigationReport, irController, FavSegment.ir,prescriptionController),
          //
          //     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "History"))
          //       history_hx(generalSettingController, prescriptionController, context),
          //
          //     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "ChildHistory"))
          //       selectedChildHistory(context),
          //
          //     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "GyneObs"))
          //       selectedGynHistory(context),
          //
          //     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Immunization"))
          //       immunizationCard(context),
          //
          //     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "TreatmentPlan"))
          //       selectedTreatmentPlan(context),
          //
          //     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "PhysicianNotes"))
          //       selectedPhysicianNotes(context),
          //
          //     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "ReferralShort"))
          //
          //       selectedReferralShort(context),
          //     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Procedure"))
          //       clinicalFieldProcedureWidget(context, EndDrawerScreenValues.procedure, screenHeight, screenWidth, "Procedure",  selectedProcedure,),
          //
          //     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "InvestigationReportImage"))
          //       investigationImageUpload(prescriptionController, context),
          //
          //     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "PatientDiseaseImage"))
          //       diseaseImageUploadCard(prescriptionController, context),
          //
          //     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "GlassRecommendation"))
          //       GlassPrescription(),
          //
          //   ],
          // ),
        ],
      )),
    );

}





    clinicalDataListScreen(context, fieldTitle, individualController,selectedDataList, prescriptionController, favoriteSegmentName,[isEditing = false]) {

    FavoriteIndexController favoriteIndexController = Get.put(FavoriteIndexController());

    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: ListTile(
          title:  Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(fieldTitle + "${individualController.dataList.length}"),
          if(individualController.dataList.isNotEmpty || individualController.dataList.isEmpty)
            Container(
              width: 300,
              child: TextField(
                controller: individualController.searchController,
                autofocus: true,
                decoration:  InputDecoration(
                  hintText: "Search..",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.all(2.0),
                  suffixIcon: IconButton(onPressed: ()async{
                    individualController.searchController.clear();
                    individualController.getAllData('');
                    individualController.dataList.refresh();
                  }, tooltip: "Clear", icon: Icon(Icons.clear),),
                ),
                onChanged: (value)async{
                  await individualController.getAllData(value);
                  print(value);
                  print(individualController.dataList.length);
                },
              ),
            ),
          if(Platform.isWindows)
            Container(
              width: 500,
              child: Column(
                children: [
                  if(favoriteSegmentName !=FavSegment.history)
                  Row(
                    children: [
                      Container(
                        width: 240,
                        child:  TextField(
                          // controller: prescriptionController.addNewClinicalDataController,
                          decoration: InputDecoration(
                              hintText: "Add New",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 2.0,horizontal: 10.0), //EdgeInsets.all(2.0),
                              prefixIcon:  Column(
                                  children: [

                                    Obx(() => Column(
                                        children: [
                                          Tooltip(
                                            message: individualController.isAddToFavorite.value ? "Remove from favorite" : "Also Add to favorite",
                                            child:  IconButton(onPressed: (){
                                              individualController.isAddToFavorite.value = !individualController.isAddToFavorite.value;
                                            }, icon: individualController.isAddToFavorite.value ? Icon(Icons.star) : Icon(Icons.star_border)),
                                          )
                                        ]
                                    ),),
                                  ]
                              )
                          ),
                          onChanged: (value){
                            prescriptionController.addNewClinicalDataController.text = value;
                            individualController.nameController.text = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            children: [
                              // FilledButton(onPressed: ()async{
                              //   // await prescriptionController.addNewClinicalDataToPrescription(1,type.toString());
                              //   prescriptionController.addNewClinicalDataToPrescription(1,favoriteSegmentName.toString());
                              //   await individualController.addData(individualController.dataList.length + 1);
                              // } , child: Text("Add to Rx")),
                              SizedBox(width: 10,),
                              FilledButton(onPressed: ()async{
                                prescriptionController.addNewClinicalDataToPrescription(1,favoriteSegmentName.toString());
                                await individualController.addData(individualController.dataList.length + 1);
                              } , child: Text("Add to Rx & List")),
                            ]
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if(Platform.isAndroid)
          FilledButton(onPressed: (){
            commonNewDataInsert(context, individualController, fieldTitle, favoriteSegmentName);
          }, child: Text("Create New")),
          IconButton(onPressed: (){
            individualController.searchController.clear();
            individualController.getAllData('');
            individualController.dataList.refresh();
            Navigator.pop(context);
          }, icon: Icon(Icons.close))
        ],
      ),),),
        content: Container(
          width: Platform.isAndroid ? MediaQuery.of(context).size.width * 0.9 : MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Obx(() => Column(
                  children: [

                    Container(
                      height: MediaQuery.of(context).size.height * .9,  // Set a fixed height
                      child: ListView.builder(
                        itemCount: individualController.dataList.length,
                        itemBuilder: (context, index) {
                          var item = individualController.dataList[index];
                          var favoriteId = favoriteIndexController.favoriteIndexDataList.firstWhere((element) => element.favorite_id == item.id && element.u_status !=2 && element.segment == favoriteSegmentName, orElse: () => null,);
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      if(favoriteId ==null)
                                        InkWell(
                                          onTap: ()async{
                                            await favoriteIndexController.addData(favoriteIndexController.favoriteIndexDataList.length + 1,favoriteSegmentName, item.id );
                                            await individualController.getAllData('');
                                            individualController.searchController.clear();
                                            individualController.dataList.refresh();
                                          },
                                          child: Icon(Icons.star_border),
                                        ),

                                      if(favoriteId !=null)
                                        InkWell(
                                          onTap: ()async{
                                            await favoriteIndexController.updateData(favoriteId.id,favoriteSegmentName, item.id);
                                            await individualController.getAllData('');
                                            individualController.searchController.clear();
                                            individualController.dataList.refresh();
                                          },
                                          child: Icon(Icons.star),
                                        ),
                                    ],
                                  ),
                                  Obx(() => Checkbox(
                                    value: selectedDataList.contains(item),
                                    onChanged: (value) {
                                      if(value == true){
                                        selectedDataList.add(item);
                                        selectedDataList.refresh();
                                        if(favoriteSegmentName == FavSegment.history){
                                          individualController.groupDataByCategory();
                                        }
                                      }else{
                                        selectedDataList.remove(item);
                                        selectedDataList.refresh();
                                      }
                                      // Handle checkbox toggle
                                    },
                                  ),),
                                  if(favoriteSegmentName != FavSegment.ir)
                                  Text(item.name),

                                  SizedBox(width: 10,),
                                  if(favoriteSegmentName == FavSegment.ir)
                                    Row(
                                      children: [
                                        Container(
                                          width: Platform.isWindows ? 400 : MediaQuery.of(context) .size.width * 0.8,
                                          height: 30,
                                          child: TextFormField(
                                            readOnly: selectedDataList.contains(item),
                                            initialValue: item.name + ': ',
                                            decoration:  InputDecoration(
                                              hintText: "Write value",
                                              border: OutlineInputBorder(),
                                              contentPadding: EdgeInsets.all(8),
                                            ),
                                            onChanged: (value){
                                              item.name = value;
                                            },
                                          ),
                                        )
                                      ],
                                    )
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      );

    });

  }
  // invReportDataList(context, fieldTitle, individualController,selectedDataList, prescriptionController, favoriteSegmentName,[isEditing = false]){
  //   FavoriteIndexController favoriteIndexController = Get.put(FavoriteIndexController());
  //
  //   showDialog(context: context, builder: (context){
  //     return AlertDialog(
  //       title: ListTile(
  //         title:  Obx(() => Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(fieldTitle + "${individualController.dataList.length}"),
  //             if(individualController.dataList.isNotEmpty || individualController.dataList.isEmpty)
  //               Container(
  //                 width: 300,
  //                 child: TextField(
  //                   controller: individualController.searchController,
  //                   autofocus: true,
  //                   decoration:  InputDecoration(
  //                     hintText: "Search..",
  //                     border: OutlineInputBorder(),
  //                     prefixIcon: Icon(Icons.search),
  //                     contentPadding: EdgeInsets.all(2.0),
  //                     suffixIcon: IconButton(onPressed: ()async{
  //                       individualController.searchController.clear();
  //                       individualController.getAllData('');
  //                       individualController.dataList.refresh();
  //                     }, tooltip: "Clear", icon: Icon(Icons.clear),),
  //                   ),
  //                   onChanged: (value)async{
  //                     await individualController.getAllData(value);
  //                     await individualController.dataList.refresh();
  //                     print(value);
  //                     print(individualController.dataList.length);
  //                   },
  //                 ),
  //               ),
  //
  //             // Obx(() => Wrap(
  //             //   direction: Axis.horizontal,
  //             //   alignment: WrapAlignment.start,
  //             //   spacing: 10,
  //             //   children: [
  //             //     if(sortedList.isNotEmpty || sortedList.isEmpty)
  //             //       Container(
  //             //         width: 300,
  //             //         child: TextField(
  //             //           controller: individualController.searchController,
  //             //           autofocus: true,
  //             //           decoration:  InputDecoration(
  //             //             hintText: "Search..",
  //             //             border: OutlineInputBorder(),
  //             //             prefixIcon: Icon(Icons.search),
  //             //             contentPadding: EdgeInsets.all(2.0),
  //             //             suffixIcon: IconButton(onPressed: ()async{
  //             //               individualController.searchController.clear();
  //             //               individualController.getAllData('');
  //             //               individualController.dataList.refresh();
  //             //               sortedList.refresh();
  //             //             }, tooltip: "Clear", icon: Icon(Icons.clear),),
  //             //           ),
  //             //           onChanged: (value)async{
  //             //             await individualController.getAllData(value);
  //             //           },
  //             //         ),
  //             //       ),
  //             //
  //             //     // Container(
  //             //     //   width: 600,
  //             //     //   child: Row(
  //             //     //     children: [
  //             //     //       Container(
  //             //     //         width: 240,
  //             //     //         child:  TextField(
  //             //     //           // controller: prescriptionController.addNewClinicalDataController,
  //             //     //           decoration: InputDecoration(
  //             //     //               hintText: "Add New",
  //             //     //               border: OutlineInputBorder(),
  //             //     //               contentPadding: EdgeInsets.symmetric(vertical: 2.0,horizontal: 10.0), //EdgeInsets.all(2.0),
  //             //     //               prefixIcon:  Column(
  //             //     //                   children: [
  //             //     //                     Obx(() => Column(
  //             //     //                         children: [
  //             //     //                           Tooltip(
  //             //     //                             message: controller.isAddToFavorite.value ? "Remove from favorite" : "Also Add to favorite",
  //             //     //                             child:  IconButton(onPressed: (){
  //             //     //                               controller.isAddToFavorite.value = !controller.isAddToFavorite.value;
  //             //     //                             }, icon: controller.isAddToFavorite.value ? Icon(Icons.star) : Icon(Icons.star_border)),
  //             //     //                           )
  //             //     //                         ]
  //             //     //                     ),),
  //             //     //                   ]
  //             //     //               )
  //             //     //           ),
  //             //     //           onChanged: (value){
  //             //     //             controller.nameController.text = value;
  //             //     //           },
  //             //     //         ),
  //             //     //       ),
  //             //     //       Padding(
  //             //     //         padding: const EdgeInsets.all(8.0),
  //             //     //         child: Row(
  //             //     //             children: [
  //             //     //               FilledButton(onPressed: ()async{
  //             //     //                 await prescriptionController.addNewClinicalDataToPrescription(1,type.toString());
  //             //     //                 // await controller.addData(controller.dataList.length + 1);
  //             //     //               } , child: Text("Add to Rx")),
  //             //     //               SizedBox(width: 10,),
  //             //     //               FilledButton(onPressed: ()async{
  //             //     //                 await prescriptionController.addNewClinicalDataToPrescription(1,type.toString());
  //             //     //                 await controller.addData(controller.dataList.length + 1);
  //             //     //               } , child: Text("Add to Rx & List")),
  //             //     //             ]
  //             //     //         ),
  //             //     //       ),
  //             //     //     ],
  //             //     //   ),
  //             //     // )
  //             //
  //             //   ],
  //             // ),),
  //             IconButton(onPressed: (){
  //               Navigator.pop(context);
  //             }, icon: Icon(Icons.close))
  //           ],
  //         ),),),
  //       content: Container(
  //         width: Platform.isAndroid ? MediaQuery.of(context).size.width * 0.9 : MediaQuery.of(context).size.width * 0.9,
  //         height: MediaQuery.of(context).size.height * 0.9,
  //         child: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               Obx(() => Column(
  //                 children: [
  //
  //                   Container(
  //                     height: MediaQuery.of(context).size.height * .9,  // Set a fixed height
  //                     child: ListView.builder(
  //                       itemCount: individualController.dataList.length,
  //                       itemBuilder: (context, index) {
  //                         var item = individualController.dataList[index];
  //                         var favoriteId = favoriteIndexController.favoriteIndexDataList.firstWhere((element) => element.favorite_id == item.id && element.u_status !=2 && element.segment == favoriteSegmentName, orElse: () => null,);
  //                         return Column(
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 Row(
  //                                   children: [
  //                                     if(favoriteId ==null)
  //                                       InkWell(
  //                                         onTap: ()async{
  //                                           await favoriteIndexController.addData(favoriteIndexController.favoriteIndexDataList.length + 1,favoriteSegmentName, item.id );
  //                                           await individualController.getAllData('');
  //                                           individualController.searchController.clear();
  //                                           individualController.dataList.refresh();
  //                                         },
  //                                         child: Icon(Icons.star_border),
  //                                       ),
  //
  //                                     if(favoriteId !=null)
  //                                       InkWell(
  //                                         onTap: ()async{
  //                                           await favoriteIndexController.updateData(favoriteId.id,favoriteSegmentName, item.id);
  //                                           await individualController.getAllData('');
  //                                           individualController.searchController.clear();
  //                                           individualController.dataList.refresh();
  //                                         },
  //                                         child: Icon(Icons.star),
  //                                       ),
  //                                   ],
  //                                 ),
  //                                 Obx(() => Checkbox(
  //                                   value: selectedDataList.contains(item),
  //                                   onChanged: (value) {
  //                                     if(value == true){
  //                                       selectedDataList.add(item);
  //                                       selectedDataList.refresh();
  //                                     }else{
  //                                       selectedDataList.remove(item);
  //                                       selectedDataList.refresh();
  //                                     }
  //                                     // Handle checkbox toggle
  //                                   },
  //                                 ),),
  //                                 Text(item.name),
  //                                 Row(
  //                                   children: [
  //                                     Container(width: 30,
  //                                       child: TextField(
  //                                         onChanged: (value){
  //                                           print("value");
  //                                         },
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 )
  //                               ],
  //                             ),
  //                           ],
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ))
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //
  //   });
  // }

  clinicalFieldWidget(context, screenValue, modalTitle, selectedData,[individualController,favSegment,prescriptionController]) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final PrescriptionController prescriptionController = Get.put(PrescriptionController());
    GeneralSettingController generalSettingController = Get.put(GeneralSettingController());
    bool isTransColor =  generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "clinicalCardColor");


    // textEditingController.text = selectedDataForEditing;
    TextEditingController nameController = TextEditingController();
    void _handleSave() {
      if (nameController.text.isNotEmpty) {
        if (screenValue == 0) {
          selectedData.add(ChiefComplainModel(id: selectedData.length + 1, name: nameController.text));
        } else if (screenValue == 1) {
          selectedData.add(DiagnosisModal(id: selectedData.length + 1, name: nameController.text));
        } else if (screenValue == 2) {
          selectedData.add(OnExaminationModel(id: selectedData.length + 1, name: nameController.text));
        } else if (screenValue == 3) {
          selectedData.add(InvestigationModal(id: selectedData.length + 1, name: nameController.text));
        } else if (screenValue == 4) {
          selectedData.add(InvestigationReportModel(id: selectedData.length + 1, name: nameController.text));
        } else if (screenValue == 5) {
          // Handle other cases
        }
        nameController.clear();
      }
    }

    return Card(
      elevation: 2,
      child: Obx(() => Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(modalTitle.toString(), style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),),
                      ),),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // color: Colors.black
                      ),
                      child: IconButton(
                        hoverColor: Colors.blueAccent,
                        onPressed: () async {

                          if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "EndDrawerClinicalData")){
                            // prescriptionController.endDrawerCurrentScreen.value = screenValue;
                            // customPopupDialog(context,modalTitle,true,selectedData,individualController,prescriptionController,favSegment);
                            clinicalDataListScreen(context, modalTitle, individualController,selectedData, prescriptionController, favSegment);
                          }
                          // if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "EndDrawerClinicalData")){
                          //   prescriptionController.endDrawerCurrentScreen.value = screenValue;
                          //   Scaffold.of(context).openEndDrawer();
                          // }
                        }, icon: Icon(Icons.add_box, size: Platform.isAndroid ? 30 : 25, color: Colors.black,),),
                    ),
                  ],
                ),
              ),
              if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "EnableTextWritingBox"))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: screenWidth,
                      child: Row(
                        children: [
                          SizedBox(
                            width: Platform.isAndroid ? screenWidth * 0.300 : screenWidth * 0.220,
                            height: 40,
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter ${modalTitle}',
                              ),
                              onSubmitted: (value){
                                _handleSave();
                              },
                              onChanged: (value){
                              },
                            ),
                          ),
                          IconButton(onPressed: (){
                            if(nameController.text.isNotEmpty){
                              _handleSave();
                            }
                          }, icon: Icon(Icons.save, size: Platform.isAndroid ? 30 : 25, color: Colors.blue,))
                        ],
                      ),
                    ),
                  ),
                ),
              if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "EnableRecentInvAdvHome"))
                if(screenValue == EndDrawerScreenValues.investigationAdvice)
                  Wrap(
                    children: [
                      for(var i=0; i< prescriptionController.usesInvestigationAdvice.length; i++)
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: FilterChip(
                              label: Text(prescriptionController.usesInvestigationAdvice[i]),
                              selected: selectedData.any((data) => (data.name.toString().contains(prescriptionController.usesInvestigationAdvice[i].toString()))),
                              // onSelected: (bool value) {  },),
                              onSelected: (value){
                                if(value){
                                  print(selectedData);
                                  // print(prescriptionController.usesInvestigationAdvice[i]);
                                  selectedData.add(InvestigationModal(id: selectedData.length + 1, name: prescriptionController.usesInvestigationAdvice[i].toString()));
                                }else{
                                  selectedData.removeWhere((element) => element.name == prescriptionController.usesInvestigationAdvice[i].toString());
                                }
                              }),
                        ),


                    ],
                  ),
            ],
          ),
          // if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "EnableTextWritingBox"))
          Container(
            // padding: const EdgeInsets.all(5.0),
            width: Responsive().clinicalFieldInPrescriptionW(context),
            // height: Responsive().clinicalFieldInPrescriptionH(context),
            decoration: const BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: selectedData.map<Widget>((item) {
                            return
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // border: Border.all(width: 1, color: Colors.grey)
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            selectedData.remove(item);
                                          },
                                          child: Icon(
                                            Icons.cancel,
                                            size: Platform.isAndroid ? 15 : 12,
                                          ),),
                                        const SizedBox(width: 5,),
                                        Flexible(child: Text(item.name, style: const TextStyle(fontSize: 16),)),
                                        const SizedBox(width: 5,),
                                        InkWell(
                                            onTap: (){
                                              clinicalFieldEditModal(context, item, selectedData, prescriptionController);
                                            },
                                            child: Icon(
                                              Icons.edit, size: Platform.isAndroid ? 15 : 12,)),
                                        const SizedBox(width: 5,),

                                      ],
                                    ),
                                  ),

                                ],
                              );
                          }).toList(),

                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
  clinicalFieldEditModal(context, item, selectedData, prescriptionController){
    final TextEditingController _nameController = TextEditingController(text: item.name);

    showDialog(
        context: context,
        builder: (
            BuildContext context){
          return AlertDialog(
            title: Container(
              alignment: Alignment.center,
              height: 300,
              width: 400,
              child: Column(
                  children: [
                    TextField(
                        controller: _nameController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),

                        )
                    ),
                    SizedBox(height: 10,),
                    FilledButton(
                      onPressed: ()async{
                        for(int i = 0; i < selectedData.length; i++){
                          if(selectedData[i].id == item.id){
                            selectedData[i].name  = _nameController.text;
                            break;
                          }
                        }
                        await selectedData.refresh();
                        await prescriptionController.refresh();
                        Navigator.pop(context);

                      }, child: Text("Update"),)
                  ]
              ),
            ),
          );
        });
  }

  commonNewDataInsert(context, individualController,title, type){
  final prescriptionController = Get.put(PrescriptionController());
  showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title"),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.close))
        ],
      ),
      content: Container(
        height: 300,
        width: Platform.isWindows ? 700 : MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              spacing: 10,
              children: [


                Container(
                  width: 600,
                  child: Row(
                    children: [
                      Container(
                        width: 240,
                        child:  TextField(
                          // controller: prescriptionController.addNewClinicalDataController,
                          decoration: InputDecoration(
                              hintText: "Add New",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 2.0,horizontal: 10.0), //EdgeInsets.all(2.0),
                              prefixIcon:  Column(
                                  children: [
                                    Obx(() => Column(
                                        children: [
                                          Tooltip(
                                            message: individualController.isAddToFavorite.value ? "Remove from favorite" : "Also Add to favorite",
                                            child:  IconButton(onPressed: (){
                                              individualController.isAddToFavorite.value = !individualController.isAddToFavorite.value;
                                            }, icon: individualController.isAddToFavorite.value ? Icon(Icons.star) : Icon(Icons.star_border)),
                                          )
                                        ]
                                    ),),
                                  ]
                              )
                          ),
                          onChanged: (value){
                            prescriptionController.addNewClinicalDataController.text = value;
                            individualController.nameController.text = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            children: [
                              FilledButton(onPressed: ()async{
                                // await prescriptionController.addNewClinicalDataToPrescription(1,type.toString());
                                prescriptionController.addNewClinicalDataToPrescription(1,type.toString());
                                await individualController.addData(individualController.dataList.length + 1);
                              } , child: Text("Add to Rx")),
                              SizedBox(width: 10,),
                              FilledButton(onPressed: ()async{
                                prescriptionController.addNewClinicalDataToPrescription(1,type.toString());
                                await individualController.addData(individualController.dataList.length + 1);
                              } , child: Text("Add to Rx & List")),
                            ]
                        ),
                      ),
                    ],
                  ),
                )

              ],
            )
          ],
        ),
      ),
    );
  });
  }