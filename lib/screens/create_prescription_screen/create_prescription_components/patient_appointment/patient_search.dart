



import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/prescription_controller.dart';
import 'package:dims_vet_rx/controller/history/history_controller.dart';
import 'package:dims_vet_rx/controller/patient/patient_controller.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/patient_appointment/patent_followUp_list.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/patient_appointment/patient_disease_image_upload.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';

import '../../../../controller/appointment/methods/clear_appointment_data.dart';
import '../../../../controller/child_history/child_history_controller.dart';
import '../../../../controller/create_prescription/prescription/methods/method_prescription_data_clear.dart';
import '../../../../controller/drawer_controller/drawer_controller.dart';
import '../../../../controller/gyn_and_obs/gyn_and_obs_controller.dart';
import '../../../../controller/investigation_report_image/investigation_report_image_cotroller.dart';
import '../../../../controller/patient_disease_image/patient_disease_image_controller.dart';
import '../../../../models/appointment/appointment_model.dart';
import '../../../../models/create_prescription/prescription/prescription_model.dart';
import '../../../../models/patient/patient_model.dart';
import '../../../../utilities/style.dart';
import '../../../others_data_screen/patient_profile.dart';
import '../../popup_screen.dart';
import '../clinical_data/investigation_image_upload.dart';
import '../clinical_data/left_clinical_widget.dart';
import '../clinical_data/patient_histry.dart';

  searchOldPatient(context){
  final PatientController patientController = Get.put(PatientController());
  final AppointmentController appointmentController = Get.put(AppointmentController());
  final prescriptionController = Get.put(PrescriptionController());
  final investigationReportImageController = Get.put(InvestigationReportImageController());
  final historyController = Get.put(HistoryController());
  final childHistoryController = Get.put(ChildHistoryController());
  final gynAndObsController = Get.put(GynAndObsController());
  final patientDiseaseImageController = Get.put(PatientDiseaseImageController());
  final DrawerMenuController drawerMenuController = Get.put(
      DrawerMenuController());
 showDialog(context: context, builder: (context){
  return AlertDialog(
    title: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text("Search Follow-up Patient / Prescription", style: TextStyle(fontSize: 18),)),

            IconButton(onPressed: (){
              patientController.searchController.clear();
              Navigator.pop(context);

            }, icon: Icon(Icons.close))
          ],
        ),
      ],
    ),
    actions: [

    ] ,
    content: SizedBox(
    width: Platform.isWindows ? MediaQuery.of(context).size.width * 0.9 : MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.9,
    child:
    Column(
      children: [
        Container(
          child: TextField(
            controller: patientController.searchController,
            decoration:   InputDecoration(
                hintText: "Search by name, PID or phone",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(onPressed: (){
                  patientController.searchController.clear();
                  patientController.getAllData('');
                }, icon: const Icon(Icons.cancel_outlined))
            ),
            onChanged: (value){
              patientController.getAllData(value);
            },
          ),
        ),

        Obx(() =>  Expanded(
            child:  ListView.builder(
                itemCount: patientController.dataList.length,
                itemBuilder: (context, index){
                  var name = patientController.dataList[index].name;
                  var phone = patientController.dataList[index].phone ?? "";
                  var id = patientController.dataList[index].id;
                  var newValue = patientController.dataList[index];
                  var followUpList = prescriptionController.patientAppPrescriptionJoin.where((element) => element.patientAppointment.patient.id == id).toList();
                  return Card(
                    child: ExpansionTile(
                      collapsedBackgroundColor: Colors.grey.shade200,
                      childrenPadding: EdgeInsets.symmetric(vertical: 5),
                        title: ListTile(
                          title: Wrap(
                            runSpacing: 5,
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              Text(name, style: TextStyle(fontWeight: FontWeight.bold),),
                              TextButton(onPressed: (){
                                try{
                                  appointmentController.newAppointmentForTodayFromPatientList(patientController.dataList[index]);
                                }catch(e){
                                  print(e);
                                }finally{
                                  Navigator.pop(context);
                                }
                                Helpers.successSnackBar("Success", "Ready for appointment");
                              }, child: Text("Make Appointment")),

                            ],
                          ),
                          subtitle: Column(
                            children: [
                              Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  Text("Patient ID: ", style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(id.toString()),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Phone: ", style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(phone),
                                ],
                              ),
                            ],
                          ),
                        ),
                      children: [
                        if(followUpList.isNotEmpty)
                          Column(
                            children: [
                              for(int i = 0; i < followUpList.length; i++)
                                 patientAppointmentCard(context, followUpList[i])
                            ],
                          ),
                    
                        if(followUpList.isEmpty)
                          Column(
                            children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Data Not found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                  ),
                            ],
                          ),
                      ],
                    ),
                  );

                })))
      ],
    ),
  ),


 );
 });

}

Widget patientAppointmentCard(BuildContext context, item){
    final appointmentController = Get.put(AppointmentController());
  final investigationReportImageController = Get.put(InvestigationReportImageController());
  final historyController = Get.put(HistoryController());
  final childHistoryController = Get.put(ChildHistoryController());
  final gynAndObsController = Get.put(GynAndObsController());
  final patientDiseaseImageController = Get.put(PatientDiseaseImageController());
  final DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
  PatientModel patientModel = item.patientAppointment.patient;
  AppointmentModel appointmentModel = item.patientAppointment.appointment;
  PrescriptionModel prescriptionModel = item.prescription;
  var name =  patientModel.name;
  var phone =  patientModel.phone;
  var date =  appointmentModel.date;
  var prescriptionId =  prescriptionModel.id;
  var appointmentId =  prescriptionModel.appointment_id;
  var patientId =  patientModel.id;
  var patient_hospital_reg_id = appointmentModel.patient_hospital_reg_id;
  var hospitalId = appointmentModel.hospital_id;
    return Column(
      children: [
        Card(
          color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                    children: [
                      ListTile(
                        title: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 5,
                          children: [
                            IconButton(
                                tooltip: "View Profile",
                                onPressed: (){
                                  patientProfileDialog(context, item.patientAppointment);
                                }, icon: Icon(Icons.account_circle)),
                            Text("Date : "+date.toString()),
                          ],
                        ),
                        subtitle: Wrap(
                          spacing: 5,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            Text("Patient Reg No : "+patient_hospital_reg_id.toString()),
                            Text("Hospital ID : "+hospitalId.toString()),
                          ],
                        ),
                      )


                    ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Wrap(
                  runSpacing: 5,
                  spacing: 10,
                  children: [
                    FilledButton(onPressed: ()async{
                      await investigationReportImageController.getInvestigationReportImage(appointmentId);
                      await prescriptionController.getSinglePrescriptionEdit(context : context, PRESCRIPTION_ID : prescriptionId, isPrint: false);
                      Helpers.successSnackBar("Success", "Prescription is copied");
                      await historyController.getSinglePatientHistory(patientId);
                      await childHistoryController.getChildHistory(patientId );
                      await gynAndObsController.getAllGynHistory(patientId);
                      //appointmentController.viewAppointmentDetails(item);
                      Navigator.pop(context);
                    }, child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.copy),
                        SizedBox(width: 5,),
                        Text("Copy Rx")
                      ],
                    )),
                    FilledButton(onPressed: ()async{

                      try{

                        await investigationReportImageController.getInvestigationReportImage(appointmentId);
                        await prescriptionController.getSinglePrescriptionEdit(context : context, PRESCRIPTION_ID : prescriptionId, isPrint: false);
                        Helpers.successSnackBar("Success", "Prescription is copied");
                        await historyController.getSinglePatientHistory(patientId);
                        await childHistoryController.getChildHistory(patientId );
                        await gynAndObsController.getAllGynHistory(patientId);
                        //appointmentController.viewAppointmentDetails(item);
                        await appointmentController.newAppointmentForTodayFromPatientList(patientModel);
                        drawerMenuController.selectedMenuIndex.value = 0;
                        Navigator.pop(context);
                      }catch(e){
                      print("error : "+e.toString());
                      }

                    }, child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.copy),
                        SizedBox(width: 5,),
                        Flexible(child: Text("Rx Copy with Make Appointment"))
                      ],
                    )),
                    const SizedBox(width: 10,),
                    FilledButton(onPressed: ()async{
                      // appointmentController.newAppointmentForTodayFromPatientList(newValue);
                      await prescriptionController.getSinglePrescriptionEdit(context : context, PRESCRIPTION_ID : prescriptionId, isPrint: true);

                    }, child: const Text("Print Preview")),

                    // Card(
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    //     child: Text(id.toString()),
                    //   ),
                    // ),
                    FilledButton(onPressed: ()async{
                      await patientDiseaseImageController.getPatientDiseaseImage(appointmentId);
                      // drawerMenuController.endDrawerCurrentScreen.value = EndDrawerScreenValues.patientDiseaseImageUpload;
                      // customPopupDialog(context, "Patient Disease Image");
                      showDialog(context: context, builder: (context){
                        return  AlertDialog(
                          title: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              Text("Disease Image"),
                              IconButton(onPressed: (){
                                Navigator.pop(context);
                              }, icon: Icon(Icons.close))
                            ],
                          ),
                          content: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  patientDiseaseImageUpload(context),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    }, child: Text("Disease Image")),
                    FilledButton(onPressed: ()async{
                      await investigationReportImageController.getInvestigationReportImage(patientId);
                      // drawerMenuController.endDrawerCurrentScreen.value = EndDrawerScreenValues.investigationReportImage;
                      // customPopupDialog(context, "Investigation Report Image");
                      showDialog(context: context, builder: (context){
                        return   AlertDialog(
                          title: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              Text("Investigation Report Image"),
                              IconButton(onPressed: (){
                                Navigator.pop(context);
                              }, icon: Icon(Icons.close))
                            ],
                          ),
                          content: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: Column(
                              children: [
                                investigationReportUpload(context)
                              ],
                            ),
                          ),
                        );
                      });
                    }, child: Text("Report Image")),

                    FilledButton(
                        onPressed: ()async{
                          await historyController.getSinglePatientHistory(patientId);
                          await childHistoryController.getChildHistory(patientId );
                          await gynAndObsController.getAllGynHistory(patientId);
                          // drawerMenuController.endDrawerCurrentScreen.value = EndDrawerScreenValues.patientHistory;
                          // customPopupDialog(context, "Patient History");
                          showDialog(context: context, builder: (context){
                            return AlertDialog(
                              title: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  Text("Patient History"),
                                  IconButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, icon: Icon(Icons.close))
                                ],
                              ),
                              content: Container(
                                width: MediaQuery.of(context ).size.width * 0.9,
                                height: MediaQuery.of(context ).size.height * 0.9,
                                child: Column(
                                  children: [
                                    oldPatientHistory(context),
                                  ],
                                ),
                              ),
                            );
                          });
                        }, child: Text("Patient History")),

                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
}