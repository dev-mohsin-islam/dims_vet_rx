
 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';

import '../../vet_controller/vet_controller.dart';


Future clearAppointmentData()async{
  print("Clear app" + DateTime.now().toString());
  AppointmentController appointmentController = Get.put(AppointmentController());

  final vetController = Get.put(VetController());
  appointmentController.PATIENT_ID.value = 0;
  appointmentController.APPOINTMENT_ID.value = 0;
  appointmentController.sexController.value = 0;
  appointmentController.dobController.value = '';
  appointmentController.marital_statusController.value = 0;
  appointmentController.patientNameController.clear();
  appointmentController.guardian_nameController.clear();
  appointmentController.phoneController.clear();
  appointmentController.emailController.clear();
  appointmentController.areaController.clear();
  appointmentController.occupationController.clear();
  appointmentController.educationController.clear();
  appointmentController.blood_groupController.clear();
  appointmentController.patientNameController.text= '';

//appointment info
  appointmentController.selectedNextVisitDate.value = '';
  appointmentController.PATIENT_ID.value = 0;
  appointmentController.APPOINTMENT_ID.value = 0;
  appointmentController.pulseTextEditingController.clear();
  appointmentController.sys_blood_pressureTextEditingController.clear();
  appointmentController.dys_blood_pressureTextEditingController.clear();
  appointmentController.temparatureTextEditingController.clear();
  appointmentController.temparatureCelsiusTextEditingController.clear();
  appointmentController.weightTextEditingController.clear();
  appointmentController.patientHeight ="".obs;
  appointmentController.heightCmTextEditingController.clear();
  appointmentController.heightFeetTextEditingController.clear();
  appointmentController.heightInchesTextEditingController.clear();
  appointmentController.heightMeterTextEditingController.clear();
  appointmentController.OFCTextEditingController.clear();
  appointmentController.OFCInchesTextEditingController.clear();
  appointmentController.waistTextEditingController.clear();
  appointmentController.waistCmTextEditingController.clear();
  appointmentController.hipTextEditingController.clear();
  appointmentController.hipCmTextEditingController.clear();
  appointmentController.rrTextEditingController.clear();
  appointmentController.complainTextEditingController.clear();
  appointmentController.medicineTextEditingController.clear();
  appointmentController.improvementTextEditingController.clear();
  appointmentController.feeTextEditingController.clear();
  appointmentController.report_patientTextEditingController.clear();
  appointmentController.isReportPatient.value = false;
  appointmentController.serialTextEditingController.clear();
  appointmentController.ageYearController.clear();
  appointmentController.ageHourController.clear();
  appointmentController.ageMonthController.clear();
  appointmentController.ageDayController.clear();
  appointmentController.ageMinutesController.clear();
  appointmentController.dobController = "".obs;
  appointmentController.blood_groupController.text = "";
  appointmentController.selectedBloodGroup.value = "";
  appointmentController.occupationController.text = "";
  appointmentController.occupationController.text = "";
  appointmentController.educationController.text = "";
  appointmentController.marital_statusController = 0.obs;
  appointmentController.sexController = 0.obs;
  appointmentController.hospitalId.clear();
  appointmentController.patientHospitalRegId.clear();
  appointmentController.selectedBloodGroupCont.clear();
  appointmentController.isPregnant?.value = "";

  //for vet
  vetController.selectedPetType.value = "";
  vetController.petNameController.clear();

}