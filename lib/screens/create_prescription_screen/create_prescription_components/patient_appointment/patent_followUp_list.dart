import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/prescription_controller.dart';
import 'package:dims_vet_rx/controller/history/history_controller.dart';
import 'package:dims_vet_rx/controller/investigation_report_image/investigation_report_image_cotroller.dart';
import 'package:dims_vet_rx/controller/patient_disease_image/patient_disease_image_controller.dart';
import 'package:dims_vet_rx/models/appointment/appointment_model.dart';
import 'package:dims_vet_rx/models/create_prescription/prescription/prescription_model.dart';
import 'package:dims_vet_rx/models/patient/patient_model.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';

import '../../../../controller/child_history/child_history_controller.dart';
import '../../../../controller/drawer_controller/drawer_controller.dart';
import '../../../../controller/gyn_and_obs/gyn_and_obs_controller.dart';
import '../../popup_screen.dart';
import '../clinical_data/left_clinical_widget.dart';

  patientFollowUpList(context, patient_id){
  final HistoryController historyController = Get.put(HistoryController());
  final childHistoryController = Get.put(ChildHistoryController());
  final gynAndObsController = Get.put(GynAndObsController());
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
  final InvestigationReportImageController investigationReportImageController = Get.put(InvestigationReportImageController());
  final PatientDiseaseImageController patientDiseaseImageController = Get.put(PatientDiseaseImageController());
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Follow Up List"),
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.close))
          ],
        ),
        actions: [

        ],
        content: SizedBox(
          height: 400,
          width: MediaQuery.of(context).size.width * 0.8,
          child:
          Column(
            children: [

              Obx(() =>  Expanded(
                  child:  Column(
                    children: [
                      if(prescriptionController.patientAppPrescriptionJoin.any((element) => element.patientAppointment.patient.id == patient_id))
                        Expanded(
                          child: ListView.builder(
                              itemCount: prescriptionController.patientAppPrescriptionJoin.length,
                              itemBuilder: (context, index){
                                var item = prescriptionController.patientAppPrescriptionJoin[index];
                                PatientModel patientModel = prescriptionController.patientAppPrescriptionJoin[index].patientAppointment.patient;
                                AppointmentModel appointmentModel = prescriptionController.patientAppPrescriptionJoin[index].patientAppointment.appointment;
                                PrescriptionModel prescriptionModel = prescriptionController.patientAppPrescriptionJoin[index].prescription;
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
                                      if(patientId == patient_id)
                                      Card(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Wrap(
                                                  children: [
                                                    const SizedBox(width: 10,),
                                                    Text("PID : "+patientId.toString()),
                                                    const SizedBox(width: 10,),
                                                    Text(" | Name : "+name.toString()),
                                                    const SizedBox(width: 10,),
                                                    Text(" | Phone : "+ phone.toString()),
                                                    const SizedBox(width: 10,),
                                                    Text("| Date : "+date.toString()),
                                                    const SizedBox(width: 10,),
                                                    if(patient_hospital_reg_id != null && patient_hospital_reg_id != '')
                                                      Text("| Patient Reg No : "+patient_hospital_reg_id.toString()),
                                                    const SizedBox(width: 10,),
                                                    if(hospitalId != null && hospitalId != '')
                                                      Text("| Hospital ID : "+hospitalId.toString()),
                                                  ]
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                              child: Wrap(
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
                                                    drawerMenuController.endDrawerCurrentScreen.value = EndDrawerScreenValues.patientDiseaseImageUpload;
                                                    customPopupDialog(context, "Patient Disease Image");
                                                  }, child: Text("Disease Image")),
                                                  FilledButton(onPressed: ()async{
                                                    await investigationReportImageController.getInvestigationReportImage(patientId);
                                                    drawerMenuController.endDrawerCurrentScreen.value = EndDrawerScreenValues.investigationReportImage;
                                                    customPopupDialog(context, "Investigation Report Image");
                                                  }, child: Text("Report Image")),

                                                  FilledButton(
                                                      onPressed: ()async{
                                                        await historyController.getSinglePatientHistory(patientId);
                                                        await childHistoryController.getChildHistory(patientId );
                                                        await gynAndObsController.getAllGynHistory(patientId);
                                                        drawerMenuController.endDrawerCurrentScreen.value = EndDrawerScreenValues.patientHistory;
                                                        customPopupDialog(context, "Patient History");
                                                      }, child: Text("Patient History")),

                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                  ],
                                );
                                return Container();
                              }),
                        ),
                    ],
                  )))
            ],
          ),
        ),
      );
    });
}