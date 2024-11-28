
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';
import 'package:dims_vet_rx/models/appointment/appointment_model.dart';
import 'package:dims_vet_rx/models/patient/patient_model.dart';
import 'package:dims_vet_rx/screens/others_data_screen/patient_profile.dart';
import 'package:dims_vet_rx/utilities/default_value.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';

import '../../controller/appointment/methods/clear_appointment_data.dart';
import '../../controller/authentication/login_controller.dart';
import '../../controller/child_history/child_history_controller.dart';
import '../../controller/create_prescription/prescription/methods/method_prescription_data_clear.dart';
import '../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../controller/drawer_controller/drawer_controller.dart';
import '../../controller/general_setting/general_setting_controller.dart';
import '../../controller/gyn_and_obs/gyn_and_obs_controller.dart';
import '../../controller/investigation_report_image/investigation_report_image_cotroller.dart';
import '../../controller/patient_disease_image/patient_disease_image_controller.dart';
import '../../controller/sync_controller/live_sync_controller.dart';
import '../../database/crud_operations/appointment_crud.dart';
import '../../models/patient_appointment_model.dart';
import '../../models/patient_appointment_prescription.dart';
import '../../utilities/app_strings.dart';
import 'package:flutter/services.dart';

import '../../utilities/style.dart';

class AppointmentList extends StatefulWidget {
  const AppointmentList({super.key});

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  AppointmentController appointmentController  = Get.put(AppointmentController());
  final liveSyncController = Get.put(LiveSyncController());
  final generalSettingController = Get.put(GeneralSettingController());
  initialCall()async{
    if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.others && element['label'] == Settings.LiveDataSync)){
      await liveSyncController.appointmentDownload();
    }
    appointmentController.getAllData('');
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialCall();

  }
  @override
  Widget build(BuildContext context) {
    final patientAppointment= appointmentController.patientAppointmentList;

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child:
        Obx((){
          return Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const SizedBox(
                          child: Text(ScreenTitle.Appointment, style: TextStyle(fontSize: 20,color: Colors.black54),)
                      ),

                      ElevatedButton(
                          onPressed: ()async{
                            showDialogLoading(context);
                            await initialCall();
                            Helpers.successSnackBar("Success", "Data download completed");
                            Navigator.pop(context);
                          }, child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.download),
                          Text("Sync")
                        ],
                      )),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: prescriptionController.searchController,
                          decoration:   InputDecoration(
                            hintText: 'Search..by name, phone',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: prescriptionController.searchController.text.isNotEmpty
                                ? IconButton(
                              icon: const Icon(Icons.cancel_outlined),
                              onPressed: () {
                                prescriptionController.clearText();
                              },
                            ) : null,
                          ),
                          onChanged: (value)async{
                            await prescriptionController.getAllPrescriptionData(value);
                          },
                        ),
                      ),
                      // ElevatedButton(onPressed: (){
                      //   controller.clearText();
                      //   newAddAndUpdateDialog(context, 0, controller);
                      // }, child: const Text("Create New")),
                    ],
                  ),
                ),
              ),
              prescriptionController.isLoading.value ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 158.0),
                child: Center(child: CircularProgressIndicator(),),
              )
                  : patientAppointment.isNotEmpty ? _dataList(context, patientAppointment)
                  :   const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Center(child: Column(
                  children: [
                    Icon(Icons.hourglass_empty, size: 80,),
                    Text("Data Not Found"),
                  ],
                ),),
              )
            ],
          );
        })
    );
  }
}

Widget _dataList(context, patientAppointment){
  var appointmentBox = Get.put(AppointmentBoxController());
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final loginController = Get.put(LoginController());
  final AppointmentController controller = Get.put(AppointmentController());
  final DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
  final InvestigationReportImageController investigationReportImageController = Get.put(InvestigationReportImageController());
  final PatientDiseaseImageController patientDiseaseImageController = Get.put(PatientDiseaseImageController());
  final childHistoryController = Get.put(ChildHistoryController());
  final gynAndObsController = Get.put(GynAndObsController());
  // patientAppPrescription.sort((a, b) => b['prescription_id'].compareTo(a['prescription_id']));
  return Expanded(
    child: Obx(() {
      return ListView.builder(
        itemCount: patientAppointment.length,
        itemBuilder: (context, index) {
          PatientAppointment paAppointment = patientAppointment[index];
          var name =  paAppointment.patient.name  ?? "";
          var phone =  paAppointment.patient.phone ?? "Not Given";
          var date =  paAppointment.appointment.date ?? "";
          var serial =  paAppointment.appointment.serial ;
          var appointmentId =  paAppointment.appointment.id;
          var patientId =  paAppointment.patient.id;;
          var status =  paAppointment.appointment.status;
          var reportPatient =  paAppointment.appointment.report_patient == 1 ? "Report Patient" : "New Patient";
          return Card(
            child: ListTile(
              title: Wrap(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Wrap(
                    runSpacing: 5,
                    spacing: 5,
                    children: [
                      IconButton(
                         tooltip: "Patient Profile",
                          onPressed: (){
                        patientProfileDialog(context, patientAppointment[index]);
                      }, icon: Icon(Icons.account_circle)),

                      Column(
                        children: [
                          if(status == DefaultValues.cancelAppointment)
                          FilledButton(onPressed: (){
                            controller.cancelAppointment(appointmentId);
                          }, child: Text("Cancelled", style: TextStyle(color: Colors.grey),)),

                          if(status != DefaultValues.cancelAppointment && status != DefaultValues.prescriptionReady)
                          FilledButton(onPressed: (){
                            controller.cancelAppointment(appointmentId);
                          }, child: Text("Cancel")),
                        ],
                      ),


                      if(loginController.selectedProfileType == "Doctor" && status != DefaultValues.prescriptionReady && status != DefaultValues.cancelAppointment)
                        FilledButton(onPressed: ()async{
                          showDialogLoading(context);
                          await Future.delayed(Duration(seconds: 1));
                          PatientAppointment patientAppointmentData = PatientAppointment(appointment: paAppointment.appointment, patient: paAppointment.patient);
                         await controller.viewAppointmentDetails(patientAppointmentData);
                          Navigator.pop(context);
                          drawerMenuController.selectedMenuIndex.value = 0;
                          var additionalData = await appointmentBox.getAppClinicalInfo(patientAppointmentData.appointment.id);
                          if(additionalData != null){
                            prescriptionController.getAppClinicalData(additionalData);
                          }
                        }, child: Text("Create Rx"),),

                      if(status == DefaultValues.prescriptionReady)
                        FilledButton(onPressed: ()async{
                        }, child: Text("Rx Ready", style: TextStyle(color: Colors.grey),)),
                    ],
                  ),
                  Text(
                    date,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  ]
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Serial: ", style: const TextStyle(fontWeight: FontWeight.bold),),
                          Text(serial !=null ? serial.toString() : '', style: const TextStyle(fontWeight: FontWeight.w500),),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Ph: ", style: const TextStyle(fontWeight: FontWeight.bold),),
                          Text(phone, style: const TextStyle(fontWeight: FontWeight.w500),),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Text("Name: ", style: const TextStyle(fontWeight: FontWeight.bold),),
                          Text(name, style: const TextStyle(fontWeight: FontWeight.w500),),
                        ],
                      ),
                      Row(
                        children: [
                              Text("PID: ", style: const TextStyle(fontWeight: FontWeight.bold),),
                              Text(patientId.toString(), style: const TextStyle(fontWeight: FontWeight.w500),),
                          SizedBox(width: 5,),
                          InkWell(
                            child: const Icon(Icons.copy),
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: patientId.toString()));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Patient Name copied to clipboard'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            
            ),
          );


        },
      );
    }),
  );
}
Future<void> newAddAndUpdateDialog(context, id, controller)async{
  Get.defaultDialog(
    title: id ==0 ? "Create New" : "Update",
    textConfirm: id ==0 ? "Add" : "Update",
    onConfirm: ()async{
      final idNewData = controller.dataList.length + 1;
      id ==0 ?  controller.addData(idNewData) : controller.updateData(id);
      Navigator.pop(context);
    },
    textCancel: "Cancel",
    barrierDismissible: false,
    content: Column(
      children: [
        TextField(
          controller: controller.nameController,
          decoration: const InputDecoration(
              hintText: "Enter name",
              border: OutlineInputBorder()
          ),
        ),
      ],
    ),
  );
}

