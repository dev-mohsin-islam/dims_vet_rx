
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/controller/general_setting/prescription_print_page_setup_controller.dart';
import 'package:dims_vet_rx/controller/prescription_template/prescription_template_controller.dart';
import 'package:dims_vet_rx/models/appointment/appointment_model.dart';
import 'package:dims_vet_rx/models/chambers/chamber_model.dart';
import 'package:dims_vet_rx/models/create_prescription/prescription_drug/prescription_drug_model.dart';
import 'package:dims_vet_rx/models/create_prescription/prescription_drug_dose/prescription_drug_dose_model.dart';
import 'package:dims_vet_rx/models/favorite_index/favorite_index_model.dart';
import 'package:dims_vet_rx/models/general_setting_pages/prescription_print_layout_settings/prescription_print_layout_setting_model.dart';
import 'package:dims_vet_rx/models/general_setting_pages/setting_pages_model.dart';
import 'package:dims_vet_rx/models/handout/handout_model.dart';
import 'package:dims_vet_rx/models/money_receipt/money_receipt_model.dart';
import 'package:dims_vet_rx/models/patient/patient_model.dart';
import 'package:dims_vet_rx/models/patient_certificate/patient_certificate_model.dart';
import 'package:dims_vet_rx/models/patient_history/patient_history_model.dart';
import 'package:dims_vet_rx/models/patient_referral/patient_referral_model.dart';
import 'package:dims_vet_rx/models/user_info/user_info_model.dart';
import 'package:dims_vet_rx/screens/others_data_screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/advice/advice_controller.dart';
import '../controller/chief_complain/chief_complain_controller.dart';
import '../controller/company_name/company_name_controller.dart';
import '../controller/create_prescription/prescription/prescription_controller.dart';
import '../controller/diagnosis/diagnosis_controller.dart';
import '../controller/drug_brand/drug_brand_controller.dart';
import '../controller/drug_generic/drug_generic_controller.dart';
import '../controller/dose/dose_controller.dart';
import '../controller/general_setting/general_setting_controller.dart';
import '../controller/handout_category/handout_category_controller.dart';
import '../controller/history/history_controller.dart';
import '../controller/instruction/instruction_controller.dart';
import '../controller/investigation/investigation_controller.dart';
import '../controller/investigation_report/Investigation_report_controller.dart';
import '../controller/on_examination/on_examination_controller.dart';
import '../controller/on_examination_category/on_examination_category.dart';
import '../controller/prescription_duration/prescription_duration_controller.dart';
import '../controller/procedure/procedure_controller.dart';
import '../database/hive_get_boxes.dart';
import '../models/advice/advice_model.dart';
import '../models/chief_complain/chief_complain_model.dart';
import '../models/company_name/company_name_model.dart';
import '../models/create_prescription/prescription/prescription_model.dart';
import '../models/create_prescription/prescription_duration/prescription_duration_model.dart';
import '../models/create_prescription/prescription_handout/prescription_handout_model.dart';
import '../models/diagnosis/diagnosis_modal.dart';
import '../models/dose/dose_model.dart';
import '../models/drug_brand/drug_brand_model.dart';
import '../models/drug_generic/drug_generic_model.dart';
import '../models/handout_category/handout_category_model.dart';
import '../models/history/history_model.dart';
import '../models/instruction/instruction_model.dart';
import '../models/investigation/investigation_modal.dart';
import '../models/investigation_report/investigation_report_model.dart';
import '../models/on_examination/on_examination_model.dart';
import '../models/on_examination_category/on_examination_category_model.dart';
import '../models/prescription_template/prescription_template/prescription_template_model.dart';
import '../models/prescription_template/prescription_template_drug/prescription_template_drug_model.dart';
import '../models/prescription_template/prescription_template_drug_dose/prescription_template_drug_dose_model.dart';
import '../models/procedure/procedure_model.dart';



class BoxDataClearAndRefresh extends GetxController{
  final ChiefComplainController chiefComplainController = Get.put(ChiefComplainController());
  final AdviceController adviceController = Get.put(AdviceController());
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final OnExaminationController onExaminationController = Get.put(OnExaminationController());
  final DiagnosisController diagnosisController = Get.put(DiagnosisController());
  final InvestigationController investigationController = Get.put(InvestigationController());
  final InvestigationReportController investigationReportController = Get.put(InvestigationReportController());
  final HistoryController historyController = Get.put(HistoryController());
  final HandoutCategoryController handoutCategoryController = Get.put(HandoutCategoryController());
  final CompanyNameController companyNameController = Get.put(CompanyNameController());
  final DrugBrandController drugBrandController = Get.put(DrugBrandController());
  final DrugGenericController drugGenericController = Get.put(DrugGenericController());
  final DoseController doseController = Get.put(DoseController());
  final DurationController durationController = Get.put(DurationController());
  final InstructionController instructionController = Get.put(InstructionController());
  final OnExaminationCategoryController onExaminationCategoryController = Get.put(OnExaminationCategoryController());
  final ProcedureController procedureController = Get.put(ProcedureController());
  final GeneralSettingController generalSettingController = Get.put(GeneralSettingController());
final PrescriptionPrintPageSetupController prescriptionPrintPageSetupController = Get.put(PrescriptionPrintPageSetupController());
  final PrescriptionTemplateController prescriptionTemplateController = Get.put(PrescriptionTemplateController());



  final Box<AdviceModel>boxAdvice = Boxes.getAdvice();
  final Box<HandoutModel>boxHandout = Boxes.getHandout();
  final Box<DrugBrandModel>boxDrugBrand = Boxes.getDrugBrand();
  final Box<InvestigationModal>boxInvestigation = Boxes.getInvestigation();
  final Box<InvestigationReportModel>boxInvestigationReport = Boxes.getInvestigationReportBox();
  final Box<OnExaminationModel>boxOnExamination = Boxes.getOnExamination();
  final Box<ChiefComplainModel>boxChiefComplain = Boxes.getChiefComplain();
  final Box<HistoryModel>boxHistory = Boxes.getHistory();
  final Box<DiagnosisModal> boxDiagnosis = Boxes.getDiagnosis();
  final Box<CompanyNameModel> boxCompanyName = Boxes.getCompanyName();
  final Box<DrugGenericModel> boxDrugGeneric = Boxes.getDrugGeneric();
  final Box<DoseModel> boxDose = Boxes.getDose();
  final Box<PrescriptionDurationModel> boxPrescriptionDuration = Boxes.getDuration();
  final Box<InstructionModel> boxInstruction = Boxes.getInstruction();
  final Box<SettingPagesModel> boxGeneralSetting = Boxes.getSettingPages();


  final Box<OnExaminationCategoryModel> boxOnExaminationCategory = Boxes.getOnExaminationCategory();
  final Box<ProcedureModel> boxProcedure = Boxes.getProcedure();
  final Box<HandoutCategoryModel> boxHandoutCategory = Boxes.getHandoutCategory();
  final Box<PrescriptionHandoutModel> boxPrescriptionHandout = Boxes.getPrescriptionHandout();
  final Box<FavoriteIndexModel> boxFavorite = Boxes.getFavoriteIndex();
  final Box<PatientModel> boxPatient = Boxes.getPatient();
  final Box<AppointmentModel> boxAppointment = Boxes.getAppointment();
  final Box<PrescriptionModel> boxPrescription = Boxes.getPrescription();
  final Box<PrescriptionDrugModel> boxPrescriptionDrug = Boxes.getPrescriptionDrug();
  final Box<PrescriptionDrugDoseModel> boxPrescriptionDrugDose = Boxes.getPrescriptionDrugDose();

  final Box<PrescriptionTemplateModel> boxPrescriptionTemplate = Boxes.getPrescriptionTemplate();
  final Box<PrescriptionTemplateDrugModel> boxPrescriptionTemplateDrug = Boxes.getPrescriptionTemplateDrug();
  final Box<PrescriptionTemplateDrugDoseModel> boxPrescriptionTemplateDrugDose = Boxes.getPrescriptionTemplateDrugDose();

  final Box<PatientHistoryModel> boxPatientHistory = Boxes.getPatientHistory();
final Box<PrescriptionPrintLayoutSettingModel> boxPrescriptionPrintLayoutSetting = Boxes.getPrescriptionPrintLayoutSettings();
final Box<ChamberModel> boxChamber = Boxes.getChamber();
final Box<PatientCertificateModel> boxPaCertificate = Boxes.getPatientCertificate();
final Box<PatientReferralModel> boxPatientReferral = Boxes.getPaReferral();
final Box<MoneyReceiptModel> boxMoneyReceipt = Boxes.getMoneyReceipt();
final Box<UserInfoModel> boxUserInfo = Boxes.getUserInfo();



  Future<bool>boxDataClearFunction()async{
    await boxAdvice.clear();
    await boxHandout.clear();
    await boxDrugBrand.clear();
    await boxInvestigation.clear();
    await boxInvestigationReport.clear();
    await boxOnExamination.clear();
    await boxChiefComplain.clear();
    await boxHistory.clear();
    await boxDiagnosis.clear();
    await boxCompanyName.clear();
    await boxDrugGeneric.clear();
    await boxPrescriptionDuration.clear();
    await boxInstruction.clear();
    await boxOnExaminationCategory.clear();
    await boxProcedure.clear();
    await boxFavorite.clear();
    await boxDose.clear();
    await boxHandout.clear();
    await boxHandoutCategory.clear();
    await boxFavorite.clear();
    await boxPatient.clear();
    await boxAppointment.clear();
    await boxPrescription.clear();
    await boxPrescriptionDrug.clear();
    await boxPrescriptionDrugDose.clear();
    await boxPrescriptionTemplate.clear();
    await boxPrescriptionTemplateDrug.clear();
    await boxPrescriptionTemplateDrugDose.clear();
    await boxPatientHistory.clear();
    await boxPrescriptionPrintLayoutSetting.clear();
    await boxGeneralSetting.clear();
    await boxPaCertificate.clear();
    await boxPatientReferral.clear();
    await boxMoneyReceipt.clear();
    await boxUserInfo.clear();
    await boxChamber.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();


   return true;
  }

}