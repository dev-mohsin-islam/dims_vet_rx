import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/advice/advice_controller.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';
import 'package:dims_vet_rx/controller/procedure/procedure_controller.dart';
import 'package:dims_vet_rx/models/advice/advice_model.dart';
import 'package:dims_vet_rx/utilities/app_icons.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';

import '../../controller/create_prescription/prescription/methods/ReBuildController.dart';
import '../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../controller/drawer_controller/drawer_controller.dart';
import '../../controller/general_setting/data_ordering_controller.dart';
import '../../controller/general_setting/general_setting_controller.dart';
import '../../controller/sync_controller/json_to_db.dart';
import '../../utilities/app_strings.dart';
import '../page_route_builder.dart';
import 'create_prescription_components/add_handout_dialog.dart';
import 'create_prescription_components/add_short_advice_dialog.dart';
import 'create_prescription_components/bottm_nav_bar_widget.dart';
import 'create_prescription_components/clinical_data/left_clinical_widget.dart';
import 'create_prescription_components/drug_brand/add_medicine_modal.dart';
import 'create_prescription_components/drug_brand/drug_search_bar_home.dart';
import 'create_prescription_components/drug_brand/selected_drug_brand_list.dart';
import 'create_prescription_components/patient_appointment/appointment_info_home.dart';
import 'create_prescription_components/prescription_header_footer_widget.dart';
import 'create_prescription_components/template_add_dialog.dart';

class PrescriptionCreateScreen extends StatefulWidget {
  final prescriptionOrTemplate;
  const PrescriptionCreateScreen(String this.prescriptionOrTemplate, {super.key});

  @override
  State<PrescriptionCreateScreen> createState() => _PrescriptionCreateScreenState();
}

class _PrescriptionCreateScreenState extends State<PrescriptionCreateScreen> {
  var loginWithProfileStatus = "";

  var clinicalWidgetListNew = [];
  Future getSharedValue() async {
    loginWithProfileStatus = await getStoreKeyWithValue("profileType") ?? "";
  }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedValue();

  }
  rebuildWidget() {
    setState(() {

    });
  }

  @override

  @override
  Widget build(BuildContext context) {
    final RebuildController rebuildController = RebuildController(rebuildWidget);
    String prescriptionOrTemplate =  widget.prescriptionOrTemplate;

    final ProcedureController procedureController = Get.put(ProcedureController());
    final PrescriptionController prescriptionController = Get.put(PrescriptionController());
    final AdviceController adviceController = Get.put(AdviceController());
    final selectedChiefComplain = prescriptionController.selectedChiefComplain;
    final selectedOnExamination  = prescriptionController.selectedOnExamination;
    final selectedDiagnosis     = prescriptionController.selectedDiagnosis;
    final selectedInvestigationAdvice = prescriptionController.selectedInvestigationAdvice;
    final selectedInvestigationReport = prescriptionController.selectedInvestigationReport;
    final selectedProcedure = procedureController.selectedProcedure;
    final selectedShortAdvice = prescriptionController.selectedShortAdvice;

    final selectedPersonalHistory = prescriptionController.selectedPersonalHistory;
    final selectedFamilyHistory = prescriptionController.selectedFamilyHistory;
    final selectedSocialHistory = prescriptionController.selectedSocialHistory;
    final selectedPast = prescriptionController.selectedPastHistory;
    final selectedAllergyHistory = prescriptionController.selectedAllergyHistory;
    final selectedAllHistory = prescriptionController.selectedAllHistory;

    final AppointmentController appointmentController = Get.put(AppointmentController());
    GeneralSettingController generalSettingController = Get.put(GeneralSettingController());
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    //Clinical option visible and invisible
    final dataOrderingController = Get.put(DataOrderingController());
    var image = "assets/images/rx_icon.png";

    return Scaffold(
      bottomNavigationBar:   MyCustomBottomBar(context, screenWidth, screenHeight, prescriptionOrTemplate),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "PrescriptionHeader"))
              Container(
                color: Colors.grey,
                child: prescriptionHeaderFooter("headerImage"),
              ),
            // Patient appointment information---------------------------------------------------
            SizedBox(height: 5,),
            if(prescriptionOrTemplate == "createPrescription")
            Column(
              children: [
               appointmentInfoFrontPageWidget(context,  true)
              ],
            ),

            const Divider(color: Colors.black87, thickness: 1,),

            // prescription create section--------------------------------------------------------
            if(screenWidth <600)
            Column(
              children: [
                Card(child: ExpansionTile(
                    title: Text("Clinical Data Section"),
                    children:  [
                      ClinicalDataWidgetList()
                    ]
                )),
                Card(child: ExpansionTile(
                    title: Text("Medicine Data Section"),
                    children: [
                      medicineSection(context, image, generalSettingController, prescriptionController, screenWidth, screenHeight, selectedShortAdvice, prescriptionOrTemplate, appointmentController, adviceController),
                    ],

                )),

              ],
            ),
            if(screenWidth > 600)
            ListTile(
              title: Row(
                // alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.300,
                      child: ClinicalDataWidgetList()
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: medicineSection(context, image, generalSettingController, prescriptionController, screenWidth, screenHeight, selectedShortAdvice, prescriptionOrTemplate, appointmentController, adviceController),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10,),
            if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "PrescriptionHeader"))
            Container(
              color: Colors.grey,
              child: prescriptionHeaderFooter("footerImage"),
            ),
          ],

        ),
      ),
    );
  }

  Card medicineSection(BuildContext context, String image, GeneralSettingController generalSettingController, PrescriptionController prescriptionController, double screenWidth, double screenHeight, RxList<dynamic> selectedShortAdvice, String prescriptionOrTemplate, AppointmentController appointmentController, AdviceController adviceController) {
    var screenWidth = MediaQuery.of(context).size.width;
    final DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
    return Card(
            child: Container(
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   ListTile(
                     title: Wrap(
                       alignment: WrapAlignment.spaceBetween,
                       children: [
                         Wrap(
                           children: [
                             Container(
                               child: Image.asset(image,width: 50, ),
                             ),
                             Container(
                               child: IconButton(
                                   tooltip: "Add Medicine",
                                   onPressed: () {
                                     // popupTransition(context,showAddMedicineModal(context, "Add Medicine"));
                                     if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "EndDrawerMedicineAdd"))
                                       showAddMedicineModal(context, "Add Medicine");

                                     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "EndDrawerMedicineAdd"))
                                       drawerMenuController.endDrawerCurrentScreen.value = 10;


                                     if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "EndDrawerMedicineAdd"))
                                       Scaffold.of(context).openEndDrawer();

                                   }, icon: Icon(Icons.add_box, size: Platform.isAndroid ? 50 : 40,)),
                             ),
                           ],
                         ),
                         if(screenWidth < 600)
                         Container(
                           child: IconButton(
                               tooltip: "Add Template",
                               icon: Icon(Icons.add_circle, size: Platform.isAndroid ? 40 :  30, color: Colors.blueAccent),
                               onPressed: () {
                                 addTemplate(context, "Templates", screenWidth, screenHeight);
                               }
                           ),
                         ),

                         Container(
                           width: 300,
                           child: SearchBarApp(),
                         ),

                         if(screenWidth > 600)
                           Container(
                             child: IconButton(
                                 tooltip: "Add Template",
                                 icon: Icon(Icons.add_circle, size: Platform.isAndroid ? 40 :  30, color: Colors.blueAccent),
                                 onPressed: () {
                                   addTemplate(context, "Templates", screenWidth, screenHeight);
                                 }
                             ),
                           ),
                       ],
                     ),
                   ),

                  Column(
                    children: [
                      selectedMedicineFinal2(),
                      const SizedBox(height: 10,),

                      //Advice Section----------------------------------------------
                      Obx(() =>  Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            for(int i=0; i<selectedShortAdvice.length; i++)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Column(
                                  children: [
                                    Card(
                                      child: Row(
                                        children: [
                                          Column(
                                            children: [
                                              IconButton(onPressed: () {
                                                selectedShortAdvice.removeAt(i);
                                              }, icon: const Icon(Icons.delete_forever_outlined)), IconButton(onPressed: () {
                                                editAdviceModal(context, selectedShortAdvice,selectedShortAdvice[i], i);
                                              }, icon: const Icon(Icons.edit)),
                                            ],
                                          ),
                                          Flexible(child:   Text(selectedShortAdvice[i].text),)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ]
                      )),
                      if(prescriptionOrTemplate == "createPrescription")
                        Obx(() =>    Column(
                          children: [
                            if(appointmentController.selectedNextVisitDate.value.toString() != "")
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    IconButton(onPressed: (){
                                      appointmentController.selectedNextVisitDate.value = "";
                                    }, icon: AppIcons.inputFieldDataClear),
                                    Text("Next Visit: "),
                                    SizedBox(width: 10,),
                                    Text(appointmentController.selectedNextVisitDate.value.toString())
                                  ],
                                ),
                              ),
                          ],
                        )),
                    ],
                  ),

                  const Divider(),
                  Wrap(
                    runSpacing: 5,
                      children: [
                        if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Advice"))
                          ElevatedButton(onPressed: () {
                            showAddShortAdviceModal(
                                context, "Short Advice", screenWidth, screenHeight, adviceController, selectedShortAdvice);
                          }, child: const Text("Advice")),
                        const SizedBox(width: 10,),

                        if(prescriptionOrTemplate == "createPrescription")
                          if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Handout"))
                            ElevatedButton(onPressed: () {
                              InsertDataJsonToDb json = Get.put(InsertDataJsonToDb());
                              // json.handoutFunction();
                              showHandOutModalModal(
                                  context, "Handout Advice", screenWidth, screenHeight);
                            }, child: const Text("Handout")),

                        const SizedBox(width: 10,),

                        if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "NextVisit"))
                          ElevatedButton(
                              onPressed: () async {
                                final newDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (newDate != null) {
                                  appointmentController.selectedNextVisitMethod(newDate);
                                  appointmentController.selectedNextVisitDate.refresh();
                                }
                              },
                              child: const Text('Next Visit')
                          ),
                        const SizedBox(width: 10,),



                        // Next Visit-------------------------------------------------
                        if(prescriptionOrTemplate == "createPrescription")
                          if(appointmentController.selectedNextVisitDate.value.isNotEmpty)

                            const SizedBox(width: 10,),

                      ]),
                ],
              )),
            ),);
  }
}


editAdviceModal(context,selectedShortAdviceCont, selectedShortAdvice, index){
  print(selectedShortAdviceCont);
  var advice = selectedShortAdviceCont[index].text;
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Edit Advice"),
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.clear))
          ],
        ),
        actions: [
          FilledButton(onPressed: (){

            selectedShortAdviceCont[index] = AdviceModel(
                id: selectedShortAdviceCont[index].id,
                label: selectedShortAdviceCont[index].label,
                text: advice
            );
            Navigator.pop(context);

          }, child: Text("Save"),)
        ],
        content: Container(
          height: 200,
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextFormField(
              maxLines: 5,
            initialValue: advice,
            onChanged: (value){
              advice = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder()
            ),
          )
        )
      );
    });
}




oEAppointmentData(){
  PrescriptionController prescriptionController = Get.put(PrescriptionController());
  AppointmentController appController = Get.put(AppointmentController());
  return Obx(() => Column(
    children: [
      ListView(
        shrinkWrap: true,
        children: [

            Column(
              children: [
                if(appController.weight.value.isNotEmpty)
                Row(
                  children: [
                    IconButton(onPressed: (){
                      appController.weight.value = "";
                      appController.weightTextEditingController.clear();
                    }, icon: AppIcons.inputFieldDataClear),
                    Text(appController.weight.value),
                  ],
                ),


                //
                // if(appController.bp2.value.isNotEmpty)
                // Row(
                //   children: [
                //     IconButton(onPressed: (){
                //       appController.bp2.value = "";
                //     }, icon: AppIcons.inputFieldDataClear),
                //     Text(appController.bp2.value),
                //   ],
                // ),

                if(appController.pulse.value.isNotEmpty)
                Row(
                  children: [
                    IconButton(onPressed: (){
                      appController.pulse.value = "";
                      appController.pulseTextEditingController.clear();
                    }, icon: AppIcons.inputFieldDataClear),
                    Text(appController.pulse.value + " bpm"),
                  ],
                ),


                if(appController.bp1.value.isNotEmpty)
                  Row(
                    children: [
                      IconButton(onPressed: (){
                        appController.bp1.value = "";
                        appController.bp2.value = "";
                        appController.dys_blood_pressureTextEditingController.clear();
                        appController.sys_blood_pressureTextEditingController.clear();

                      }, icon: AppIcons.inputFieldDataClear),
                      Text(appController.bp1.value + "" + appController.bp2.value + " mmHg"),
                    ],
                  ),

                if(appController.rr.value.isNotEmpty)
                Row(
                  children: [
                    IconButton(onPressed: (){
                      appController.rr.value = "";
                      appController.rrTextEditingController.clear();
                    }, icon: AppIcons.inputFieldDataClear),
                    Text(appController.rr.value),
                  ],
                ),

                if(appController.selectedBloodGroup.isNotEmpty)
                  Row(
                    children: [
                      IconButton(onPressed: (){
                        appController.selectedBloodGroupCont.clear();
                        appController.selectedBloodGroup.value = "";
                      }, icon: AppIcons.inputFieldDataClear),
                      Text("Blood Group : " + appController.selectedBloodGroupCont.text),
                    ],
                  ),

                if(appController.temparature.value.isNotEmpty)
                Row(
                  children: [
                    IconButton(onPressed: (){
                      appController.temparature.value = "";
                      appController.temparatureCelsiusTextEditingController.clear();
                      appController.temparatureTextEditingController.clear();
                    }, icon: AppIcons.inputFieldDataClear),
                    Text(appController.temparature.value),
                  ],
                ),

                if(appController.height.value.isNotEmpty)
                Row(
                  children: [
                    IconButton(onPressed: (){
                      appController.height.value = "";
                      appController.heightFeetTextEditingController.clear();
                      appController.heightInchesTextEditingController.clear();
                      appController.heightCmTextEditingController.clear();
                      appController.heightMeterTextEditingController.clear();

                    }, icon: AppIcons.inputFieldDataClear),
                    Text(appController.height.value),
                  ],
                ),

                if(appController.OFC.value.isNotEmpty)
                  Row(
                    children: [
                      IconButton(onPressed: (){
                        appController.OFC.value = "";
                        appController.OFCInchesTextEditingController.clear();
                        appController.OFCTextEditingController.clear();
                      }, icon: AppIcons.inputFieldDataClear),
                      Text(appController.OFC.value),
                    ],
                  ),

                if(appController.waist.value.isNotEmpty)
                  Row(
                    children: [
                      IconButton(onPressed: (){
                        appController.waist.value = "";
                        appController.waistCmTextEditingController.clear();
                        appController.waistTextEditingController.clear();
                      }, icon: AppIcons.inputFieldDataClear),
                      Text(appController.waist.value),
                    ],
                  ),

                if(appController.hip.value.isNotEmpty)
                Row(
                  children: [
                    IconButton(onPressed: (){
                      appController.hip.value = "";
                      appController.hipTextEditingController.clear();
                      appController.hipCmTextEditingController.clear();
                    }, icon: AppIcons.inputFieldDataClear),
                    Text(appController.hip.value),
                  ],
                ),


                if(appController.medicineHistory.value.isNotEmpty)
                Row(
                  children: [
                    IconButton(onPressed: (){
                      appController.medicineHistory.value = "";
                      appController.medicineTextEditingController.clear();
                    }, icon: AppIcons.inputFieldDataClear),
                    Flexible(child: Text(appController.medicineHistory.value)),
                  ],
                ),


              ],

            )
        ],
      )
    ],
  ));
}

