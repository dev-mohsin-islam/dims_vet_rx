import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/advice/advice_controller.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';
import 'package:dims_vet_rx/controller/investigation_report_image/investigation_report_image_cotroller.dart';
import 'package:dims_vet_rx/controller/patient_certificate/patient_certificate_controller.dart';
import 'package:dims_vet_rx/controller/patient_disease_image/patient_disease_image_controller.dart';
import 'package:dims_vet_rx/controller/patient_referral/patient_referral_controller.dart';
import 'package:dims_vet_rx/controller/procedure/procedure_controller.dart';
import 'package:dims_vet_rx/controller/sms/sms_controller.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/patient_appointment/patent_followUp_list.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/template_add_new.dart';
import 'package:dims_vet_rx/screens/printing/money_receipet_print/mone_receipt_print.dart';
import 'package:dims_vet_rx/utilities/app_strings.dart';

import '../../../controller/appointment/methods/live_data_sync_controller.dart';
import '../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../controller/general_setting/general_setting_controller.dart';

import '../../../controller/sync_controller/live_sync_controller.dart';
import '../../../utilities/helpers.dart';
import '../../others_data_screen/doctors_referral.dart';
import '../../others_data_screen/money_receipt.dart';
import '../../others_data_screen/patient_certificate_create_&_list.dart';

MyCustomBottomBar(context, screenWidth, screenHeight, prescriptionOrTemplate) {
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final ProcedureController procedureController = Get.put(ProcedureController());
  final InvestigationReportImageController investigationReportImageController = Get.put(InvestigationReportImageController());
  final AdviceController adviceController = Get.put(AdviceController());
  final AppointmentController appointmentController = Get.put(AppointmentController());
  final PatientDiseaseImageController patientDiseaseImageController = Get.put(PatientDiseaseImageController());
  final PatientCertificateController patientCertificateController = Get.put(PatientCertificateController());
  final selectedShortAdvice = prescriptionController.selectedShortAdvice;
  final SMSController smsController = Get.put(SMSController());
  final liveSyncController = Get.put(LiveSyncController());
  final PaReferralController paRefCont = Get.put(PaReferralController());
  final GeneralSettingController generalSettingController = Get.put(GeneralSettingController());

  return Container(
      padding: EdgeInsets.all(10), // Background color of the custom bottom bar
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        alignment: WrapAlignment.end,
        children: [

          Obx(() => Row(
            children: [
              if(loginController.selectedProfileType.value !="Doctor")
                FilledButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    onPressed: ()async {
                      var prescriptionDataMap = {
                        "selectedMedicine": prescriptionController.selectedMedicine,
                        "specialNotes": prescriptionController.specialNotes.text,
                        "treatmentPlan": prescriptionController.treatmentPlan.text,
                        "referralShort": prescriptionController.referralShort.text,
                        "selectedChiefComplain": clinicalDataJoiningToString(prescriptionController.selectedChiefComplain) + appointmentController.complainTextEditingController.text,
                        "selectedDiagnosis": clinicalDataJoiningToString(prescriptionController.selectedDiagnosis),
                        "selectedOnExamination": clinicalDataJoiningToString(prescriptionController.selectedOnExamination),
                        "selectedInvestigationAdvice": clinicalDataJoiningToString(prescriptionController.selectedInvestigationAdvice),
                        "selectedPrescriptionProcedure": procedureController.selectedProcedureForSave,

                        "selectedPersonalHistory": prescriptionController.selectedPersonalHistory,
                        "selectedFamilyHistory": prescriptionController.selectedFamilyHistory,
                        "selectedFoodsAllergyHistory": prescriptionController.selectedFoodsAllergyHistory,
                        "selectedSocialHistory": prescriptionController.selectedSocialHistory,
                        "selectedEnvironmentalAllergyHistory": prescriptionController.selectedEnvironmentalAllergyHistory,
                        "selectedDrugAllergyHistory": prescriptionController.selectedDrugAllergyHistory,
                        "next_visit": appointmentController.selectedNextVisitDate,
                        "shortAdvice": prescriptionController.selectedShortAdvice,
                        "selectedInvestigationReport": clinicalDataJoiningToString(prescriptionController.selectedInvestigationReport),
                        "selectedInvestigationReportImage": investigationReportImageController.selectedInvestigationReportImage,
                        "selectedPatientDiseaseImage": patientDiseaseImageController.selectedPatientDiseaseImage,
                        "selectedNextVisitMethod": appointmentController.selectedNextVisitMethod,

                      };
                      // prescriptionController.selectedPersonalHistory.clear();
                      //sata pass for save to database (appointment and prescription)
                      var responseAppointment = await  appointmentController.savePatientAndAppointment(isSaveOnlyAppointment: true);
                      if(responseAppointment != null){
                        liveSyncController.appointmentDownload();
                      }
                      // await  appointmentController.prescriptionController.savePrescription(prescriptionDataMap,responseAppointment, context, true,false);

                    }, icon: const Icon(Icons.save), label: const Text(AppButtonString.pPrescriptionSave)),
            ],
          ),),

          Obx(() => Column(
            children: [
              if(loginController.selectedProfileType.value =="Doctor")
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  alignment: WrapAlignment.end,
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    FilledButton(
                        onPressed: () async {
                          appointmentController.selectedNextVisitDate.value = "";
                          await saveAsTemplateDialog(context);
                        },
                        child: const Text(AppButtonString.saveAsTemplateString)
                    ),
                    if(prescriptionOrTemplate == "createPrescription")
                      Obx(() =>  Wrap(
                        spacing: 5,
                        runSpacing: 20,
                        children: [

                          if(appointmentController.APPOINTMENT_ID.value != 0 && appointmentController.APPOINTMENT_ID.value != -1)
                            FilledButton(onPressed: ()async{
                              await patientFollowUpList(context, appointmentController.PATIENT_ID.value);
                            }, child: Text("Follow Up")),


                          SizedBox(width: 10,),


                          if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "PatientReferral"))
                            if(appointmentController.APPOINTMENT_ID.value != 0 && appointmentController.APPOINTMENT_ID.value != -1)
                              FilledButton(onPressed: (){
                                paRefCont.chiefComplain.text == prescriptionController.selectedChiefComplain.map((element) => element.name).join(", ");
                                paRefCont.onExamination.text = prescriptionController.selectedOnExamination.map((element) => element.name).join(", ");
                                paRefCont.diagnosis.text = prescriptionController.selectedDiagnosis.map((element) => element.name).join(", ");
                                referralCreateDialog(context, appointmentController.APPOINTMENT_ID.value);

                              }, child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.read_more_rounded, color: Colors.white,),
                                  Text("Referral"),
                                ],
                              )),

                          if(prescriptionOrTemplate == "createPrescription")
                            if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "MoneyReceipt"))
                              if(appointmentController.APPOINTMENT_ID.value != 0 && appointmentController.APPOINTMENT_ID.value != -1)
                                FilledButton(onPressed: (){
                                  moneyReceiptDialog(context, appointmentController.APPOINTMENT_ID.value, appointmentController.feeTextEditingController.text);

                                }, child: Text("Money Receipt")),


                          Obx(() =>   Column(
                            children: [
                              const SizedBox(width: 10,),
                              if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Certificate"))
                                Column(
                                  children: [
                                    if(appointmentController.APPOINTMENT_ID.value != 0 && appointmentController.APPOINTMENT_ID.value != -1)
                                      FilledButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                                          ),
                                          onPressed: (){
                                            if(prescriptionController.selectedDiagnosis.isNotEmpty){
                                              patientCertificateController.diagnosisController.text = prescriptionController.selectedDiagnosis.map((element) => element.name).join(", ");
                                            }
                                            certificateCreateModal(context, appointmentController.APPOINTMENT_ID.value);
                                          }, child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.print_outlined),
                                          Text("Certificate Print"),
                                        ],
                                      )),
                                  ],
                                ),


                            ],
                          )),


                          Obx(() =>   Column(
                            children: [
                              const SizedBox(width: 10,),
                              if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "SentPrescriptionSms"))
                                Column(
                                  children: [
                                    if(appointmentController.prescriptionController.PRESCRIPTION_ID.value != 0 && appointmentController.prescriptionController.PRESCRIPTION_ID.value != -1)
                                      FilledButton(
                                          onPressed: (){
                                            appointmentController.prescriptionController.getSinglePrescriptionEdit(context: context,PRESCRIPTION_ID: appointmentController.prescriptionController.PRESCRIPTION_ID.value, isPrint: false, isEmail: false, isSms: true);
                                          }, child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.send),
                                          SizedBox(width: 10,),
                                          Text("Rx SMS"),
                                        ],
                                      )),
                                  ],
                                ),


                            ],
                          )),
                          Obx(() =>   Column(
                            children: [
                              const SizedBox(width: 10,),
                              if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "SentPrescriptionEmail"))
                                Column(
                                  children: [
                                    if(appointmentController.prescriptionController.PRESCRIPTION_ID.value != 0 && appointmentController.prescriptionController.PRESCRIPTION_ID.value != -1)
                                      FilledButton(
                                          onPressed: (){
                                            appointmentController.prescriptionController.getSinglePrescriptionEdit(context: context,PRESCRIPTION_ID: appointmentController.prescriptionController.PRESCRIPTION_ID.value, isPrint: false, isEmail: true, isSms: false);
                                          }, child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.send),
                                          SizedBox(width: 10,),
                                          Text("Rx Email"),
                                        ],
                                      )),
                                  ],
                                ),


                            ],
                          )),

                        ],
                      ),),

                    // if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "GlassRecommendationPrint"))
                    //   FilledButton(onPressed: () async {
                    //     var prescriptionDataMap = {
                    //       "selectedMedicine": prescriptionController.selectedMedicine,
                    //       "specialNotes": prescriptionController.specialNotes.text,
                    //       "treatmentPlan": prescriptionController.treatmentPlan.text,
                    //       "referralShort": prescriptionController.referralShort.text,
                    //       "selectedChiefComplain": clinicalDataJoiningToString(prescriptionController.selectedChiefComplain) + appointmentController.complainTextEditingController.text,
                    //       "selectedDiagnosis": clinicalDataJoiningToString(prescriptionController.selectedDiagnosis),
                    //       "selectedOnExamination": clinicalDataJoiningToString(prescriptionController.selectedOnExamination),
                    //       "selectedInvestigationAdvice": clinicalDataJoiningToString(prescriptionController.selectedInvestigationAdvice),
                    //       "selectedPrescriptionProcedure": procedureController.selectedProcedureForSave,
                    //
                    //       "selectedPersonalHistory": prescriptionController.selectedPersonalHistory,
                    //       "selectedFamilyHistory": prescriptionController.selectedFamilyHistory,
                    //       "selectedFoodsAllergyHistory": prescriptionController.selectedFoodsAllergyHistory,
                    //       "selectedSocialHistory": prescriptionController.selectedSocialHistory,
                    //       "selectedEnvironmentalAllergyHistory": prescriptionController.selectedEnvironmentalAllergyHistory,
                    //       "selectedDrugAllergyHistory": prescriptionController.selectedDrugAllergyHistory,
                    //       "next_visit": appointmentController.selectedNextVisitDate,
                    //       "shortAdvice": prescriptionController.selectedShortAdvice,
                    //       "selectedInvestigationReport": clinicalDataJoiningToString(prescriptionController.selectedInvestigationReport),
                    //       "selectedInvestigationReportImage": investigationReportImageController.selectedInvestigationReportImage,
                    //       "selectedPatientDiseaseImage": patientDiseaseImageController.selectedPatientDiseaseImage,
                    //       "selectedNextVisitMethod": appointmentController.selectedNextVisitMethod,
                    //
                    //     };
                    //     var responseAppointment = await  appointmentController.savePatientAndAppointment();
                    //     await  appointmentController.prescriptionController.savePrescription(prescriptionDataMap,responseAppointment, context, false, true);
                    //   }, child: Text("GP Print")),

                    if(prescriptionOrTemplate == "createPrescription")
                      FilledButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blue),
                          ),
                          onPressed: ()async {
                            // await prescriptionController.clinicalDataConvertToString();

                            var prescriptionDataMap = {
                              "selectedMedicine": prescriptionController.selectedMedicine,
                              "specialNotes": prescriptionController.specialNotes.text,
                              "treatmentPlan": prescriptionController.treatmentPlan.text,
                              "referralShort": prescriptionController.referralShort.text,
                              "selectedChiefComplain": clinicalDataJoiningToString(prescriptionController.selectedChiefComplain) + appointmentController.complainTextEditingController.text,
                              "selectedDiagnosis": clinicalDataJoiningToString(prescriptionController.selectedDiagnosis),
                              "selectedOnExamination": clinicalDataJoiningToString(prescriptionController.selectedOnExamination),
                              "selectedInvestigationAdvice": clinicalDataJoiningToString(prescriptionController.selectedInvestigationAdvice),
                              "selectedPrescriptionProcedure": procedureController.selectedProcedureForSave,

                              "selectedPersonalHistory": prescriptionController.selectedPersonalHistory,
                              "selectedFamilyHistory": prescriptionController.selectedFamilyHistory,
                              "selectedFoodsAllergyHistory": prescriptionController.selectedFoodsAllergyHistory,
                              "selectedSocialHistory": prescriptionController.selectedSocialHistory,
                              "selectedEnvironmentalAllergyHistory": prescriptionController.selectedEnvironmentalAllergyHistory,
                              "selectedDrugAllergyHistory": prescriptionController.selectedDrugAllergyHistory,
                              "next_visit": appointmentController.selectedNextVisitDate,
                              "shortAdvice": prescriptionController.selectedShortAdvice,
                              "selectedInvestigationReport": clinicalDataJoiningToString(prescriptionController.selectedInvestigationReport),
                              "selectedInvestigationReportImage": investigationReportImageController.selectedInvestigationReportImage,
                              "selectedPatientDiseaseImage": patientDiseaseImageController.selectedPatientDiseaseImage,
                              "selectedNextVisitMethod": appointmentController.selectedNextVisitMethod,

                            };

                            // prescriptionController.selectedPersonalHistory.clear();
                            //sata pass for save to database (appointment and prescription)
                            var responseAppointment = await  appointmentController.savePatientAndAppointment();
                            await  appointmentController.prescriptionController.savePrescription(prescriptionDataMap,responseAppointment, context, false, false);
                            if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.others && element['label'] == Settings.LiveDataSync)) {
                              await liveSyncController.prescriptionUpload();
                                }

                          }, icon: const Icon(Icons.save), label: const Text(AppButtonString.pPrescriptionSaveAndPrint)),

                    if(prescriptionOrTemplate == "createPrescription")
                      FilledButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blue),
                          ),
                          onPressed: ()async {
                            var prescriptionDataMap = {
                              "selectedMedicine": prescriptionController.selectedMedicine,
                              "specialNotes": prescriptionController.specialNotes.text,
                              "treatmentPlan": prescriptionController.treatmentPlan.text,
                              "referralShort": prescriptionController.referralShort.text,
                              "selectedChiefComplain": clinicalDataJoiningToString(prescriptionController.selectedChiefComplain) + appointmentController.complainTextEditingController.text,
                              "selectedDiagnosis": clinicalDataJoiningToString(prescriptionController.selectedDiagnosis),
                              "selectedOnExamination": clinicalDataJoiningToString(prescriptionController.selectedOnExamination),
                              "selectedInvestigationAdvice": clinicalDataJoiningToString(prescriptionController.selectedInvestigationAdvice),
                              "selectedPrescriptionProcedure": procedureController.selectedProcedureForSave,

                              "selectedPersonalHistory": prescriptionController.selectedPersonalHistory,
                              "selectedFamilyHistory": prescriptionController.selectedFamilyHistory,
                              "selectedFoodsAllergyHistory": prescriptionController.selectedFoodsAllergyHistory,
                              "selectedSocialHistory": prescriptionController.selectedSocialHistory,
                              "selectedEnvironmentalAllergyHistory": prescriptionController.selectedEnvironmentalAllergyHistory,
                              "selectedDrugAllergyHistory": prescriptionController.selectedDrugAllergyHistory,
                              "next_visit": appointmentController.selectedNextVisitDate,
                              "shortAdvice": prescriptionController.selectedShortAdvice,
                              "selectedInvestigationReport": clinicalDataJoiningToString(prescriptionController.selectedInvestigationReport),
                              "selectedInvestigationReportImage": investigationReportImageController.selectedInvestigationReportImage,
                              "selectedPatientDiseaseImage": patientDiseaseImageController.selectedPatientDiseaseImage,
                              "selectedNextVisitMethod": appointmentController.selectedNextVisitMethod,

                            };
                            // prescriptionController.selectedPersonalHistory.clear();
                            //sata pass for save to database (appointment and prescription)
                            var responseAppointment = await  appointmentController.savePatientAndAppointment();
                            await  appointmentController.prescriptionController.savePrescription(prescriptionDataMap,responseAppointment, context, true,false);
                            if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.others && element['label'] == Settings.LiveDataSync)) {
                              await liveSyncController.prescriptionUpload();
                            }

                          }, icon: const Icon(Icons.save), label: const Text(AppButtonString.pPrescriptionSave)),
                  ],
                ),
            ],
          ),)
        ],
      )

  );
}



