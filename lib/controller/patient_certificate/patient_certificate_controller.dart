
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';
import 'package:dims_vet_rx/controller/general_setting/prescription_print_page_setup_controller.dart';
import 'package:dims_vet_rx/database/crud_operations/common_crud.dart';
import 'package:dims_vet_rx/models/appointment/appointment_model.dart';
import 'package:dims_vet_rx/utilities/default_value.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';

import '../../database/hive_get_boxes.dart';
import '../../models/patient_certificate/patient_certificate_model.dart';
import '../../screens/printing/patient_certificate_print/print.dart';

class PatientCertificateController extends GetxController{
  final Box<PatientCertificateModel> boxPaCertificate =  Boxes.getPatientCertificate();
  RxList patientCertificateList = [].obs;
  final CommonController commonController = Get.put(CommonController());
  final AppointmentController appController = Get.put(AppointmentController());
  final PrescriptionPrintPageSetupController prescriptionPrintPageSetupController = Get.put(PrescriptionPrintPageSetupController());
  TextEditingController diagnosisController = TextEditingController();
  TextEditingController formController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController gotToController = TextEditingController();
  TextEditingController isContinueController = TextEditingController();
  TextEditingController guardianSexController = TextEditingController();
  TextEditingController guardianNameController = TextEditingController();

  RxList<String> workingPlace = ["School", "College", "Work"  ].obs;

  Rx<String> selectedWorkPlace = "".obs;

  RxInt selectedCertificateIndex = 1.obs;
  RxString selectedTime = "".obs;

  saveCertificate(APPOINTMENT_id)async{

    if(selectedWorkPlace.value == "School") {
      gotToController.text =1.toString();
    }else if(selectedWorkPlace.value == "College")
    {gotToController.text =2.toString();
    } else if(selectedWorkPlace.value == "Work") {
      gotToController.text =3.toString();
    }
    if(formController.text.isEmpty || toController.text.isEmpty){
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("Form and To is required"),
        ),
      );
      return false;

    }
    if(diagnosisController.text.isEmpty){
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("Diagnosis is required"),
        ),
      );
      return false;
    }
    if(selectedCertificateIndex.value == 1){
      if( selectedTime.value.isEmpty){
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text("Duration is required"),
          ),
        );
        return false;
      }
    }else if(selectedCertificateIndex.value == 2){
      if( isContinueController.text.isEmpty && selectedWorkPlace.toString().isEmpty ){
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
            content: Text("Work place is required"),
          ),
        );
        return false;
      }
    }


    PatientCertificateModel patientCertificateModel = PatientCertificateModel(
        id: 0,
        appointment_id: APPOINTMENT_id.toString(),
        diagnosis: diagnosisController.text,
        form: formController.text,
        to: toController.text,
        type: selectedCertificateIndex.value.toString(),
        duration: selectedTime.value,
        got_to:  selectedWorkPlace.value,
        is_continue: isContinueController.text,
        guardian_name: guardianNameController.text,
        guardian_sex: null,
        u_status: DefaultValues.NewAdd,
        date: customDateTimeFormat(DateTime.now()),
    );
    int? responseCertId = await commonController.saveCertificate(boxPaCertificate, patientCertificateModel);
    if(responseCertId != null){
      singlePaCertPrint(responseCertId);
    }
  }
  singlePaCertPrint(id)async {
    prescriptionPrintPageSetupController.getAllData('');
    var response = await commonController.getCertificate(boxPaCertificate, id);
    print(id);
    if (response != null) {
      for(int i =0; i<response.length; i++){
        var certificate = response[i];
        String? app_id = response[i].appointment_id;
        if(app_id != null){
          var appointmentInfo = appController.patientAppointmentList.firstWhere((element) => element.appointment.id == parseInt(app_id), orElse: () => null);

          if(appointmentInfo != null){
            Navigator.push(Get.context!, MaterialPageRoute(builder: (context) => patientCertificatePrint(patientCertificateData: certificate,patientInfo: appointmentInfo)),);
          }
        }
      }

    }
  }

  getAllPaCertificate()async{
    await appController.getAllData('');
    var response = await commonController.getCertificate(boxPaCertificate, '');

    if(response != null){
      patientCertificateList.clear();
        for(int i =0; i<response.length; i++){
          String? app_id = response[i].appointment_id;
          print(app_id);
          if(app_id != null){
            var appIndex = appController.boxAppointment.values.toList().indexWhere((element) => element.id == parseInt(app_id),);
            if(appIndex != -1){
              var paId = appController.boxAppointment.values.toList()[appIndex].patient_id;
              var paInfo = appController.boxPatient.values.firstWhere((element) => element.id ==paId);
               Map certificate = {
                 "certificate": response[i],
                 "appointment": appController.boxAppointment.values.toList()[appIndex],
                 "patient": paInfo,
               };
               patientCertificateList.add(certificate);
            }
          }
        }
    }
  }




  @override
  void onInit() {
    super.onInit();
  }

  //create a dispose method
  @override
  void dispose() {
    commonController;
    appController;
    prescriptionPrintPageSetupController;
    diagnosisController;
    formController;
    toController;
    typeController;
    durationController;
    gotToController;
    isContinueController;
    guardianSexController;
    guardianNameController;
    workingPlace;
    selectedWorkPlace;
    selectedCertificateIndex;
    selectedTime;
    super.dispose();
  }

}