
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';
import 'package:dims_vet_rx/controller/authentication/login_controller.dart';
import 'package:dims_vet_rx/controller/gyn_and_obs/gyn_and_obs_controller.dart';
import 'package:dims_vet_rx/controller/investigation_report_image/investigation_report_image_cotroller.dart';
import 'package:dims_vet_rx/controller/patient_disease_image/patient_disease_image_controller.dart';
import 'package:dims_vet_rx/models/patient_appointment_prescription.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/patient_appointment/patient_disease_image_upload.dart';
 import 'package:dims_vet_rx/utilities/default_value.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';

import '../../controller/appointment/methods/clear_appointment_data.dart';
import '../../controller/child_history/child_history_controller.dart';
import '../../controller/create_prescription/prescription/methods/method_prescription_data_clear.dart';
import '../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../controller/drawer_controller/drawer_controller.dart';
import '../../controller/general_setting/general_setting_controller.dart';
import '../../controller/sync_controller/live_sync_controller.dart';
import '../../models/patient_appointment_model.dart';
import '../../utilities/app_strings.dart';
import '../../utilities/style.dart';
import '../home_screen.dart';

class prescriptionScreen extends StatefulWidget {
  const prescriptionScreen({super.key});

  @override
  State<prescriptionScreen> createState() => _prescriptionScreenState();
}

class _prescriptionScreenState extends State<prescriptionScreen> {
  final PrescriptionController prescriptionController  = Get.put(PrescriptionController());
  final liveSyncController = Get.put(LiveSyncController());
  final generalSettingController = Get.put(GeneralSettingController());
  initialCall()async{
    if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.others && element['label'] == Settings.LiveDataSync)){
      await liveSyncController.prescriptionDownload();
    }
    await prescriptionController.getAllPrescriptionData('');
  }
    initState() {
      super.initState();
      initialCall();
    }
  @override
  Widget build(BuildContext context) {
    final patientAppPrescription = prescriptionController.patientAppPrescriptionJoin;

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
                          child: Text(ScreenTitle.Prescription, style: TextStyle(fontSize: 20,color: Colors.black54),)
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

              // Container(
              //   height: 30,
              //   color: Colors.deepPurple,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Expanded(
              //         child: Padding(
              //           padding: EdgeInsets.symmetric(horizontal: 20.0),
              //           child: Center(child: Text("Action", style: TextStyle(color: Colors.white, fontSize: 20),),),
              //         ),
              //       ),
              //       Expanded(
              //         child: Padding(
              //           padding: EdgeInsets.symmetric(horizontal: 18.0),
              //           child: Center(
              //             child: Text(
              //               Platform.isAndroid ? "P. Id" : "Patient Id",
              //               style: TextStyle(color: Colors.white, fontSize: 20),
              //             ),
              //           ),
              //         ),
              //       ),
              //
              //       Expanded(
              //         child: SizedBox(
              //           child: Padding(
              //             padding: EdgeInsets.symmetric(horizontal: 8.0),
              //             child: Text(
              //               Platform.isAndroid ? "Pres. Id" : "Prescription ID",
              //               style: TextStyle(color: Colors.white, fontSize: 20),
              //             ),
              //           ),
              //         ),
              //       ),
              //
              //       Expanded(
              //         child: Text("Name", style: TextStyle(color: Colors.white, fontSize: 20),),
              //       ),
              //       if(!Platform.isAndroid)
              //       Expanded(
              //         child: Text("Phone", style: TextStyle(color: Colors.white, fontSize: 20),),
              //       ),
              //       Expanded(
              //         child: Text("Date", style: TextStyle(color: Colors.white, fontSize: 20),),
              //       ),
              //     ],
              //   ),
              // ),
              prescriptionController.isLoading.value ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 158.0),
                child: Center(child: CircularProgressIndicator(),),
              )
                  : patientAppPrescription.isNotEmpty ? _dataList(context, patientAppPrescription)
                  :   const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Center(child: Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.hourglass_empty, size: 80,),
                      Text("Data Not Found"),
                    ],
                  ),
                ),),
              )
            ],
          );
        })
    );
  }
}

Widget _dataList(context, patientAppPrescription){
  final loginController = Get.put(LoginController());
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final AppointmentController appointmentController = Get.put(AppointmentController());
  final DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
  final InvestigationReportImageController investigationReportImageController = Get.put(InvestigationReportImageController());
  final PatientDiseaseImageController patientDiseaseImageController = Get.put(PatientDiseaseImageController());
  final childHistoryController = Get.put(ChildHistoryController());
  final gynAndObsController = Get.put(GynAndObsController());
  // patientAppPrescription.sort((a, b) => b['prescription_id'].compareTo(a['prescription_id']));
  return Expanded(
    child: Obx(() {
      return ListView.builder(
        itemCount: patientAppPrescription.length,
        itemBuilder: (context, index) {
          PatientAppointmentPrescriptionModel item = patientAppPrescription[index];
          PatientAppointment paAppointment = item.patientAppointment;
          var name =  paAppointment.patient.name  ?? "";
          var phone =  paAppointment.patient.phone ?? "Not Given";
          var date =  paAppointment.appointment.date ?? "";
          var status =  paAppointment.appointment.status ?? "";
          var prescriptionId =  item.prescription.id ?? "";
          var appointmentId =  paAppointment.appointment.id ?? "";
          var patientId =  paAppointment.patient.id ?? "";

          return Card(
            child: ListTile(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      runSpacing: 5,
                      spacing: 2,
                      children: [
                        Column(
                          children: [
                            if(status == DefaultValues.prescriptionReady)
                              FilledButton(onPressed: ()async{
                                showDialogLoading(context);
                                await Future.delayed(Duration(seconds: 1));

                                    // clearAppointmentData();
                                    // await appointmentController.getAllData('');
                                    // prescriptionDataClearMethod();
                                    await prescriptionController.getSinglePrescriptionEdit(context : context, PRESCRIPTION_ID : prescriptionId, isPrint: true);
                                   // Navigator.push(context, MaterialPageRoute(builder: (context)=>PrescriptionPrintScreen()));
                              }, child: Row(
                                children: [
                                  Icon(Icons.print, size: 15),
                                  SizedBox(width: 5,),
                                  Text("Print",),
                                ],
                              )),

                            // if(status != DefaultValues.prescriptionNotReady)
                            //   FilledButton(onPressed: (){
                            //     // controller.cancelAppointment(appointmentId);
                            //   }, child: Text("Rx Not Ready", style: TextStyle(color: Colors.grey),)),
                          ],
                        ),
                 if(loginController.selectedProfileType == "Doctor" && status == DefaultValues.prescriptionReady)
                    FilledButton(
                    onPressed: () async {
                      showDialogLoading(context);
                  await Future.delayed(Duration(seconds: 1));
                  try {
                    // Execute your long-running tasks
                    if (patientId != 5555555555 && appointmentId != 5555555555) {
                      await clearAppointmentData();
                      await prescriptionDataClearMethod();
                      await appointmentController.viewAppointmentDetails(paAppointment);
                      await prescriptionController.getPatientAndAppointmentID(patientId, appointmentId, prescriptionId);
                      await prescriptionController.getSinglePrescriptionEdit(
                        context: context,
                        PRESCRIPTION_ID: prescriptionId,
                        isPrint: false,
                      );
                      await investigationReportImageController.getInvestigationReportImage(appointmentId);
                      await patientDiseaseImageController.getPatientDiseaseImage(appointmentId);
                      await childHistoryController.getChildHistory(patientId);
                      await gynAndObsController.getAllGynHistory(patientId);

                      // Update drawer menu index
                      drawerMenuController.selectedMenuIndex.value = 0;
                    }
                  } catch (e) {
                    print('Error: $e');
                  } finally {
                        // Remove the dialog after tasks are completed
                        Navigator.of(context).pop();
                      }

                    },
                  child: Row(
                      children: [
                            Text("Rx Edit"),
                            SizedBox(width: 5),
                            Icon(
                              Icons.create,
                              size: 15,
                              color: Colors.yellow,
                              ),
                            ],
                      ),
                  ),


          if(loginController.selectedProfileType != "Doctor" && status == DefaultValues.prescriptionReady)
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
              subtitle:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Prescription ID: ", style: const TextStyle(fontWeight: FontWeight.bold),),
                          Text(prescriptionId.toString(), style: const TextStyle(fontWeight: FontWeight.w500),),
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
                              Clipboard.setData(ClipboardData(text: name));
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

