

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/child_history/child_history_controller.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/prescription_controller.dart';
import 'package:dims_vet_rx/controller/gyn_and_obs/gyn_and_obs_controller.dart';
import 'package:dims_vet_rx/controller/history/history_controller.dart';
import 'package:dims_vet_rx/controller/immunization.dart';
import 'package:dims_vet_rx/controller/investigation_report_image/investigation_report_image_cotroller.dart';

import '../../../patient_disease_image/patient_disease_image_controller.dart';
import 'custom_findings_controller.dart';
import 'glass_prescription_controller.dart';


final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final _glassPrescription = Get.put(GlassPrescriptionController());
  final _customFindings = Get.put(CustomFindingsController());
  prescriptionDataClearMethod(){
    print("Clear rx" + DateTime.now().toString());
    final patientHistory = Get.put(HistoryController());
    final childHistory = Get.put(ChildHistoryController());
    final gynAndObsHistory = Get.put(GynAndObsController());
    final PrescriptionController prescriptionController = Get.put(PrescriptionController());
    final InvestigationReportImageController investigationReportImageController = Get.put(InvestigationReportImageController());
    final PatientDiseaseImageController patientDiseaseImageController = Get.put(PatientDiseaseImageController());
    final  immunization = Get.put(Immunization());

    prescriptionController.PATIENT_ID.value = 0;
    prescriptionController.APPOINTMENT_ID.value = 0;
    prescriptionController.PRESCRIPTION_ID.value = 0;
    prescriptionController.selectedMedicine.clear();
    prescriptionController.selectedChiefComplain.clear();
    prescriptionController.selectedOnExamination.clear();
    prescriptionController.selectedDiagnosis.clear();
    prescriptionController.selectedInvestigationAdvice.clear();
    prescriptionController.selectedShortAdvice.clear();
    prescriptionController.selectedAllergyHistory.clear();
    // prescriptionController.selectedProcedureForSave.clear();
    // prescriptionController.selectedProcedure.clear();
    prescriptionController.selectedPersonalHistory.clear();
    prescriptionController.selectedFamilyHistory.clear();
    prescriptionController.selectedSocialHistory.clear();
    prescriptionController.selectedInvestigationReport.clear();
    prescriptionController.selectedChiefComplainString = "";
    prescriptionController.selectedOnExaminationString = "";
    prescriptionController.selectedDiagnosisString = "";
    prescriptionController.selectedInvestigationAdviceString = "";
    prescriptionController.selectedInvestigationReportString = "";
    prescriptionController.searchController.clear();
    prescriptionController.selectedAllHistory.clear();
    prescriptionController.selectedPersonalHistory.clear();
    prescriptionController.selectedFamilyHistory.clear();
    prescriptionController.selectedAllergyHistory.clear();
    prescriptionController.selectedSocialHistory.clear();
    prescriptionController.selectedDrugAllergyHistory.clear();
    prescriptionController.selectedEnvironmentalAllergyHistory.clear();
    prescriptionController.selectedFoodsAllergyHistory.clear();
    prescriptionController.specialNotes.clear();
    prescriptionController.treatmentPlan.clear();
    prescriptionController.treatmentPlanX.value = "";
    prescriptionController.referralShort.clear();
    prescriptionController.referralShortX.value = "";


    prescriptionController.brandList.clear();
    prescriptionController.getAllBrandData('');
    // await prescriptionController.modifiedDrugBrandList();


    // prescriptionController.selectedProcedure.clear();
    // prescriptionController.selectedProcedureForSave.clear();
    investigationReportImageController.selectedInvestigationReportImage.clear();
    patientDiseaseImageController.selectedPatientDiseaseImage.clear();
    patientHistory.selectedHistory.clear();
    patientHistory.oldPatientHistoryList.clear();
    patientHistory.selectedHistoryGroupByCat.clear();

    if(childHistory.isDataExist.value == true){
      childHistory.dataClear();
      childHistory.isDataExist.value = false;
    }
    if(gynAndObsHistory.isDataExist.value == true){
      gynAndObsHistory.dataClear();
      gynAndObsHistory.isDataExist.value = false;
    }
    if(immunization.isDataExist.value == true){
      immunization.dataClear();
      immunization.isDataExist.value = false;
    }
    if(_glassPrescription.isDataExist.value == true){
      _glassPrescription.clearData();
    }
    if(_customFindings.isCustomFindingsDataExist.value == true){
      _customFindings.findingsList.clear();
      _customFindings.isCustomFindingsDataExist.value = false;
    }

  }

