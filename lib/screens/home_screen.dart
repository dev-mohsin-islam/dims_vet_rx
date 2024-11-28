
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';
import 'package:dims_vet_rx/controller/authentication/login_controller.dart';
import 'package:dims_vet_rx/controller/chambers/chamber_controller.dart';
import 'package:dims_vet_rx/controller/chief_complain/chief_complain_controller.dart';
import 'package:dims_vet_rx/controller/company_name/company_name_controller.dart';
import 'package:dims_vet_rx/controller/diagnosis/diagnosis_controller.dart';
import 'package:dims_vet_rx/controller/dose/dose_controller.dart';
import 'package:dims_vet_rx/controller/on_examination/on_examination_controller.dart';
import 'package:dims_vet_rx/controller/on_examination_category/on_examination_category.dart';
import 'package:dims_vet_rx/controller/procedure/procedure_controller.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/patient_appointment/patient_disease_image_upload.dart';
import 'package:dims_vet_rx/screens/general_settings_screen/general_setting_view.dart';
import 'package:dims_vet_rx/screens/common_screen/common_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/screens/others_data_screen/handout_list_create.dart';
import 'package:dims_vet_rx/screens/others_data_screen/patient_referral.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/appointment/methods/clear_appointment_data.dart';
import '../controller/assistant/assistant_controller.dart';
import '../controller/child_history/child_history_controller.dart';
import '../controller/create_prescription/prescription/methods/method_prescription_data_clear.dart';
import '../controller/create_prescription/prescription/prescription_controller.dart';
import '../controller/drawer_controller/drawer_controller.dart';
import '../controller/general_setting/prescription_print_page_setup_controller.dart';
import '../controller/gyn_and_obs/gyn_and_obs_controller.dart';
import '../controller/instruction/instruction_controller.dart';
import '../controller/investigation/investigation_controller.dart';
import '../controller/investigation_report/Investigation_report_controller.dart';
import '../controller/prescription_duration/prescription_duration_controller.dart';
import '../controller/sms/sms_controller.dart';
import '../controller/sync_controller/json_to_db.dart';
import '../controller/sync_controller/sync_db_to_server_controller.dart';
import '../utilities/app_strings.dart';
import '../utilities/box_data_clear_refresh.dart';
import '../utilities/style.dart';
import 'create_prescription_screen/create_prescription_components/clinical_data/child_history_modal.dart';
import 'create_prescription_screen/create_prescription_components/clinical_data/clinical_field.dart';
import 'create_prescription_screen/create_prescription_components/clinical_data/investigation_image_upload.dart';
import 'create_prescription_screen/create_prescription_components/drug_brand/add_medicine_modal.dart';
import 'create_prescription_screen/create_prescription_components/patient_appointment/appointment_info_home.dart';
import 'create_prescription_screen/create_prescription_components/clinical_data/patient_histry.dart';
import 'create_prescription_screen/create_prescription_components/patient_appointment/patient_search.dart';
import 'create_prescription_screen/create_prescription_components/patient_appointment/todays_appointment.dart';
import 'create_prescription_screen/create_prescription_screen.dart';

import 'drawer_items_screen/drawer_items.dart';

import 'general_settings_screen/general_setting_components/prescription_print_layout_html_builder.dart';
import 'general_settings_screen/general_setting_components/prescription_print_page_setup_new.dart';
import 'general_settings_screen/prescription_custom_header_footer.dart';
import 'general_settings_screen/prescription_print_page_setup_screen.dart';
import 'others_data_screen/add_new_advice_and_list.dart';
import 'others_data_screen/add_new_brand.dart';
import 'others_data_screen/add_new_compan_and_list.dart';
import 'others_data_screen/add_new_generic_and_list.dart';
import 'others_data_screen/add_new_history_and_list.dart';
import 'others_data_screen/app_sync_modal.dart';
import 'others_data_screen/appointment_list.dart';
import 'others_data_screen/assistant_create.dart';
import 'others_data_screen/clinical_data_ordering.dart';
import 'others_data_screen/company_wise_report.dart';
import 'others_data_screen/dashboard.dart';
import 'others_data_screen/doctors_referral.dart';
import 'others_data_screen/fee.dart';
import 'create_prescription_screen/create_prescription_components/clinical_data/gyne_and_obs.dart';
import 'others_data_screen/login_screen.dart';
import 'others_data_screen/money_receipt.dart';
import 'others_data_screen/patient_certificate_create_&_list.dart';
import 'others_data_screen/prescription_list.dart';
import 'others_data_screen/prescrption_template_list_screen.dart';
import 'others_data_screen/privacy_policy.dart';

 class AppRebuilder extends InheritedWidget {
   final VoidCallback rebuildApp;

   AppRebuilder({
     required Key key,
     required Widget child,
     required this.rebuildApp,
   }) : super(key: key, child: child);

   static AppRebuilder? of(BuildContext context) {
     return context.dependOnInheritedWidgetOfExactType<AppRebuilder>();
   }

   @override
   bool updateShouldNotify(AppRebuilder oldWidget) {
     return false;
   }
 }


class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DrawerMenuController drawerMenuController = Get.put(
      DrawerMenuController());
  final AppointmentController appointmentController = Get.put(
      AppointmentController());
  final PrescriptionController prescriptionController = Get.put(
      PrescriptionController());
  final AssistantController assistantController = Get.put(
      AssistantController());
  final InsertDataJsonToDb insertDataJsonToDb = Get.put(InsertDataJsonToDb());
  final BoxDataClearAndRefresh boxDataClearAndRefresh = Get.put(
      BoxDataClearAndRefresh());
  final LoginController loginController = Get.put(LoginController());
  final SMSController smsController = Get.put(SMSController());
  final ChildHistoryController childHistoryController = Get.put(
      ChildHistoryController());
  final GynAndObsController gynAndObsController = Get.put(
      GynAndObsController());

  final chambers = Get.put(ChamberController());
  final prescriptionSetup = Get.put(PrescriptionPrintPageSetupController());
  final ccController = Get.put(ChiefComplainController());
  final dxController = Get.put(DiagnosisController());
  final oeCatController = Get.put(OnExaminationCategoryController());
  final oeController = Get.put(OnExaminationController());
  final iaController = Get.put(InvestigationController());
  final irController = Get.put(InvestigationReportController());
  final procedureController = Get.put(ProcedureController());
  final companyController = Get.put(CompanyNameController());
  final doseController = Get.put(DoseController());
  final durationController = Get.put(DurationController());
  final instructionController = Get.put(InstructionController());
  callTermsCondition() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var res = await pref.getBool("termPolicy") ?? false;
    if(!res){
      TermsAndCondition(context);
    }
  }

  @override
  void initState() {
    super.initState();
    callTermsCondition();
    // Set the window close handler for desktop applications.
    if (!kIsWeb) {
      FlutterWindowClose.setWindowShouldCloseHandler(() async {
        return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: const Text('Do you really want to quit?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(
                              true); // User confirmed to close the window.
                        },
                        child: const Text('Yes')
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(
                              false); // User canceled the window close.
                        },
                        child: const Text('No')
                    )
                  ]
              );
            }
        );
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (!kIsWeb) {
      FlutterWindowClose.setWindowShouldCloseHandler(null);
    }
  }


  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    final DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
    final endDrawerCurrentScreenIndex = Get.put(PrescriptionController());
    final List<dynamic> dynamicPages = [
      PrescriptionCreateScreen("createPrescription"),
      AppointmentList(),
      prescriptionScreen(),
      DashboardPage(),
      prescriptionPrintPageSetup(context),
      PrescriptionPrintPageSetupNew(),
      CustomHeaderFooter(),
      ClinicalDataOrderingScreen(),
      GeneralSettingScreen(),
      brandScreen(context),
      genericScreen(context),
      GridViewExample(),
      // companyScreen(context, ScreenTitle.CompanyName, companyController),
      singleDataScreen(context, ScreenTitle.Dose, doseController, ''),
      singleDataScreen(context, ScreenTitle.Duration, durationController, ''),
      singleDataScreen(context, ScreenTitle.Instruction, instructionController, ''),
      PrescriptionCreateScreen("createPrescriptionTemplate"),
      prescriptionTemplateScreen(context),
      singleDataScreen(context, ScreenTitle.ChiefComplain, ccController, FavSegment.chiefComplain),
      singleDataScreen(context, ScreenTitle.OnExamination, oeController, FavSegment.oE),
      singleDataScreen(context, ScreenTitle.OnExaminationCategory, oeCatController, ""),
      singleDataScreen(context, ScreenTitle.Diagnosis, dxController, FavSegment.dia),
      singleDataScreen(context, ScreenTitle.Investigation, iaController, FavSegment.ia),
      singleDataScreen(context, ScreenTitle.InvestigationReport, irController, FavSegment.ir),
      singleDataScreen(context, ScreenTitle.Procedure, procedureController, FavSegment.procedure),
      historyScreen(context),
      advicePatientScreen(context),
      handoutScreen(context),
      DoctorReferralScreen(),
      PatientReferralScreen(),
      MoneyReceiptScreen(),
      AssistantScreen(),
      PatientCertificateList(),
      CompanyWiseReport(),

    ];


    // for prescription clinical field open on navigator drawer
    final List<Widget> endDrawerScreen = [
      chiefComplainPrescriptionWidget(context),
      onExaminationPrescriptionWidget(context),
      diagnosisPrescriptionWidget(context),
      investigationAdvicePrescriptionWidget(context),
      investigationReportPrescriptionWidget(context),
      patientHistory(context),
      // procedurePrescriptionWidget(context),
      investigationReportUpload(context),
      appointmentInfoFrontPageWidget(context, false),
      patientDiseaseImageUpload(context),
      addMedicineEndDrawer(context),
    ];
    String? _selectedItem;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Row(
          children: [
            if(screenWidth > 450)
            Image.asset('assets/images/navana_logo.jpg', width: 120,),
            //SizedBox(width: 16,),

            if(!Platform.isAndroid)
              Obx(() =>
                  Column(
                    children: [
                      Container(
                        child: ElevatedButton(onPressed: () {
                          drawerMenuController.selectedMenuIndex.value = 4;
                        }, child: Row(
                          children: [
                            Text(chambers.activeChamberName.value,),
                            Icon(Icons.edit_location_alt_outlined),
                          ],
                        )),

                      )

                    ],
                  ),),

            Obx(() => Tooltip(
              message: "Create New Rx",
              child: IconButton(onPressed: () async {
                showDialogLoading(context);

                try {
                  await Future.delayed(Duration(milliseconds: 500));
                  await prescriptionDataClearMethod();
                  await clearAppointmentData();
                  await gynAndObsController.dataClear();
                  await childHistoryController.dataClear();
                  await appointmentController.getAllData('');
                  Helpers.successSnackBarDuration(
                      "Success", "Ready for New Rx", 1000);
                  drawerMenuController.selectedMenuIndex.value = 0;
                }catch(e){

                }finally {
                  // Close the loading dialog
                  Navigator.pop(context);
                }
              }, icon: Icon(Icons.add_circle, color: appointmentController.PATIENT_ID.value == 0 ? Colors.white : Colors.red,)),
            ),)


            // InkWell(
            //   onTap: ()async{
            //     loader(context);
            //     await prescriptionDataClearMethod();
            //     await clearAppointmentData();
            //     Navigator.pop(context);
            //     appointmentController.todayAppointmentListMethod();
            //     drawerMenuController.selectedMenuIndex.value =0;
            //     Helpers.successSnackBar("Success", "Ready for New Rx");
            //   }
            //   ,child: Image.asset('assets/images/CreateRx.png', height: 20, width: 20,),
            // )

          ],
        ),

        actions: [
          Wrap(
            children: [
                  // Tooltip(message: "Today's Appointments",
                  //   child:
                  //       Obx(() => todayPatients(context)),
                  //
                  //   ),

              IconButton(onPressed: () {
                searchOldPatient(context);
              },
                icon: const Tooltip(message: 'Follow-Up Patient / Prescription',
                  child: Icon(Icons.search, color: Colors.white,),),),

              // Obx(() =>
              //     Row(
              //       children: [
              //         if(!appointmentController.isSyncing.value)
              //           IconButton(
              //             onPressed: () async {
              //               appointmentController.isSyncing.value = true;
              //               await SyncController().patient(context);
              //               await SyncController().appointment(context);
              //               Helpers.successSnackBar(
              //                   "Success", "Appointments Downloaded");
              //               appointmentController.isSyncing.value = false;
              //             },
              //             icon: const Tooltip(
              //               message: 'Sync Appointments from Online',
              //               child: Icon(
              //                 Icons.cloud_sync, color: Colors.white,),),),
              //         if(appointmentController.isSyncing.value)
              //           CircularProgressIndicator(color: Colors.white,),
              //       ],
              //     ),),

              IconButton(onPressed: () {
                Future.delayed(Duration.zero, () async {
                  drawerMenuController.selectedMenuIndex.value = 1;
                });
              },
                icon: const Tooltip(message: 'View Appointment List',
                  child: Icon(Icons.list_alt, color: Colors.white,),),),

              IconButton(onPressed: () {
                Future.delayed(Duration.zero, () async {
                  drawerMenuController.selectedMenuIndex.value = 2;
                });
              },
                icon: const Tooltip(message: 'View Prescription List',
                  child: Icon(
                    Icons.view_list_rounded, color: Colors.white,),),),

              IconButton(onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const syncScreenJsonToDb()));
                //  syncCRUDController.prescriptionLayoutSetting(context);
                drawerMenuController.selectedMenuIndex.value = 0;
              },
                icon: const Tooltip(message: 'Rx Home',
                  child: Icon(Icons.home, color: Colors.white,),),),


              IconButton(onPressed: () {
                drawerMenuController.selectedMenuIndex.value = 8;
              },
                icon: const Tooltip(message: 'General Settings',
                  child: Icon(Icons.settings, color: Colors.white,),),),

            ],
          )

        ],
      ),

      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              drawerItems(context),
            ],
          ),
        ),
      ),

      // endDrawer: Drawer(
      //     width: Responsive().endDrawer(context),
      //     // child: clinicalDataScreen(context)
      //     // width: MediaQuery.of(context).size.width * 0.90,
      //     child: Expanded(
      //       child: SingleChildScrollView(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             SizedBox(height: 2,),
      //             IconButton(onPressed: () {
      //               if(endDrawerCurrentScreenIndex.endDrawerCurrentScreen.value == 10){
      //                 prescriptionController.getAllBrandData('');
      //               }
      //               Navigator.pop(context);
      //             }, icon: Icon(Icons.cancel, size: 30,)),
      //
      //             Obx(() {
      //               if (endDrawerCurrentScreenIndex.endDrawerCurrentScreen.value >= 0 &&
      //                   endDrawerCurrentScreenIndex.endDrawerCurrentScreen.value < endDrawerScreen.length) {
      //                 return endDrawerScreen[endDrawerCurrentScreenIndex.endDrawerCurrentScreen.value];
      //               } else {
      //                 return const Center(child: Text("404 Page Not Found"),);
      //               }
      //             }),
      //
      //           ],
      //         ),
      //       ),
      //     )
      //
      // ),
      endDrawer:
      Drawer(

        width: Responsive().endDrawer(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2),
              IconButton(
                onPressed: () {
                  if (drawerMenuController.endDrawerCurrentScreen.value == 10) {
                    prescriptionController.getAllBrandData('');
                  }
                  Navigator.pop(context);
                },
                icon: Icon(Icons.cancel, size: 30),
              ),
              Obx(() {
                if (drawerMenuController.endDrawerCurrentScreen.value >= 0 &&
                    drawerMenuController.endDrawerCurrentScreen.value < endDrawerScreen.length) {
                  return endDrawerScreen[drawerMenuController.endDrawerCurrentScreen.value];
                } else {
                  return const Center(
                    child: Text("404 Page Not Found"),
                  );
                }
              }),
            ],
          ),
        ),
      ),

      body: Obx(() {
        if (drawerMenuController.selectedMenuIndex.value >= 0 &&
            drawerMenuController.selectedMenuIndex.value <
                dynamicPages.length) {
          return dynamicPages[drawerMenuController.selectedMenuIndex.value];
        } else {
          return const Center(child: Text("404 Page Not Found"),);
        }
      }),
    );
  }
}



 loader(BuildContext context) {
   showDialog(
     barrierDismissible: false,
     context: context,
     builder: (BuildContext context) {
       return Center(
         child: CircularProgressIndicator(),
       );
     },
   );
 }






