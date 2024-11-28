


import 'package:dims_vet_rx/models/advice/advice_model.dart';
import 'package:dims_vet_rx/models/advice_category/advice_category_model.dart';
import 'package:dims_vet_rx/models/appointment/appointment_model.dart';
import 'package:dims_vet_rx/models/blood_group/blood_group_model.dart';
import 'package:dims_vet_rx/models/chambers/chamber_model.dart';
import 'package:dims_vet_rx/models/chief_complain/chief_complain_model.dart';
import 'package:dims_vet_rx/models/company_name/company_name_model.dart';
import 'package:dims_vet_rx/models/diagnosis/diagnosis_modal.dart';
import 'package:dims_vet_rx/models/doctors/doctor_model.dart';
import 'package:dims_vet_rx/models/dose/dose_model.dart';
import 'package:dims_vet_rx/models/drug_brand/drug_brand_model.dart';
import 'package:dims_vet_rx/models/drug_generic/drug_generic_model.dart';
import 'package:dims_vet_rx/models/favorite_index/favorite_index_model.dart';
import 'package:dims_vet_rx/models/fee/fee_model.dart';
import 'package:dims_vet_rx/models/handout/handout_model.dart';
import 'package:dims_vet_rx/models/handout_category/handout_category_model.dart';
import 'package:dims_vet_rx/models/history/history_model.dart';
import 'package:dims_vet_rx/models/history_category/history_category_model.dart';
import 'package:dims_vet_rx/models/improvement_type/improvement_type_model.dart';
import 'package:dims_vet_rx/models/imvestigation_report_image/investigation_report_image_model.dart';
import 'package:dims_vet_rx/models/instruction/instruction_model.dart';
import 'package:dims_vet_rx/models/investigation/investigation_modal.dart';
import 'package:dims_vet_rx/models/investigation_report/investigation_report_model.dart';
import 'package:dims_vet_rx/models/on_examination_category/on_examination_category_model.dart';
import 'package:dims_vet_rx/models/patient/patient_model.dart';
import 'package:dims_vet_rx/models/patient_certificate/patient_certificate_model.dart';
import 'package:dims_vet_rx/models/patient_disease_image/patient_disease_image_model.dart';
import 'package:dims_vet_rx/models/patient_history/patient_history_model.dart';
import 'package:dims_vet_rx/models/physician_notes/physician_notes_model.dart';
import 'package:dims_vet_rx/models/prescription_template/prescription_template_drug_dose/prescription_template_drug_dose_model.dart';
import 'package:dims_vet_rx/models/procedure/procedure_model.dart';
import 'package:dims_vet_rx/models/referral_short/referral_short_model.dart';
import 'package:dims_vet_rx/models/speciality/speciality_model.dart';
import 'package:dims_vet_rx/models/strength/strength_model.dart';
import 'package:dims_vet_rx/models/treatment_plan/treatment_plan_model.dart';
import 'package:dims_vet_rx/models/user_info/user_info_model.dart';
import 'package:dims_vet_rx/utilities/app_strings.dart';
import 'package:hive/hive.dart';

import '../models/create_prescription/prescription/prescription_model.dart';
import '../models/create_prescription/prescription_drug/prescription_drug_model.dart';
import '../models/create_prescription/prescription_drug_dose/prescription_drug_dose_model.dart';
import '../models/create_prescription/prescription_duration/prescription_duration_model.dart';
import '../models/create_prescription/prescription_handout/prescription_handout_model.dart';
import '../models/create_prescription/prescription_procedure/prescription_procedure_model.dart';
import '../models/general_setting_pages/prescription_print_layout_settings/prescription_print_layout_setting_model.dart';
import '../models/general_setting_pages/setting_pages_model.dart';
import '../models/money_receipt/money_receipt_model.dart';
import '../models/on_examination/on_examination_model.dart';
import '../models/pa_immunization_schedule/pa_immunization_schedule_model.dart';
import '../models/pa_immunization_schedule_option/pa_immunization_schedule_option_model.dart';
import '../models/pa_immunization_vaccines/pa_immunization_vaccines_model.dart';
import '../models/pa_immunization_vaccines_options/pa_immunization_vaccines_option_model.dart';
import '../models/patient_referral/patient_referral_model.dart';
import '../models/prescription_template/prescription_template/prescription_template_model.dart';
import '../models/prescription_template/prescription_template_drug/prescription_template_drug_model.dart';
import 'hive_boxes_name.dart';

// get boxes
class Boxes{
  static Box<DoseModel> getDose() => Hive.box<DoseModel>(AppDatabaseBoxName.boxDose);
  static Box<StrengthModel> getStrength() => Hive.box<StrengthModel>(AppDatabaseBoxName.boxStrength);
  static Box<ProcedureModel> getProcedure() => Hive.box<ProcedureModel>(AppDatabaseBoxName.boxProcedure);
  static Box<DiagnosisModal> getDiagnosis() => Hive.box<DiagnosisModal>(AppDatabaseBoxName.boxDiagnosis);
  static Box<DrugGenericModel> getDrugGeneric() => Hive.box<DrugGenericModel>(AppDatabaseBoxName.boxDrugGeneric);
  static Box<CompanyNameModel> getCompanyName() => Hive.box<CompanyNameModel>(AppDatabaseBoxName.boxCompanyName);
  static Box<InstructionModel> getInstruction() => Hive.box<InstructionModel>(AppDatabaseBoxName.boxInstruction);
  static Box<ChiefComplainModel> getChiefComplain() => Hive.box<ChiefComplainModel>(AppDatabaseBoxName.boxChiefComplain);
  static Box<InvestigationModal> getInvestigation() => Hive.box<InvestigationModal>(AppDatabaseBoxName.boxInvestigation);
  static Box<OnExaminationModel> getOnExamination() => Hive.box<OnExaminationModel>(AppDatabaseBoxName.boxOnExamination);
  static Box<AdviceCategoryModel> getAdviceCategory() => Hive.box<AdviceCategoryModel>(AppDatabaseBoxName.boxAdviceCategory);
  static Box<HandoutCategoryModel> getHandoutCategory() => Hive.box<HandoutCategoryModel>(AppDatabaseBoxName.boxHandoutCategory);
  static Box<InvestigationReportModel> getInvestigationReportBox() => Hive.box<InvestigationReportModel>(AppDatabaseBoxName.boxInvestigationReport);
  static Box<ImprovementTypeModel> getImprovementType() => Hive.box<ImprovementTypeModel>(AppDatabaseBoxName.boxImprovementType);
  static Box<OnExaminationCategoryModel> getOnExaminationCategory() => Hive.box<OnExaminationCategoryModel>(AppDatabaseBoxName.boxOnExaminationCategory);
  static Box<SpecialityModel> getSpeciality() => Hive.box<SpecialityModel>(AppDatabaseBoxName.boxSpecialty);
  static Box<BloodGroupModel> getBloodGroup() => Hive.box<BloodGroupModel>(AppDatabaseBoxName.boxBloodGroup);
  static Box<DrugBrandModel> getDrugBrand() => Hive.box<DrugBrandModel>(AppDatabaseBoxName.boxDrugBrand);

  static Box<PrescriptionHandoutModel> getPrescriptionHandout() => Hive.box<PrescriptionHandoutModel>(AppDatabaseBoxName.boxPrescriptionHandout);
  static Box<PrescriptionDurationModel> getDuration() => Hive.box<PrescriptionDurationModel>(AppDatabaseBoxName.boxDuration);
  static Box<AdviceModel> getAdvice() => Hive.box<AdviceModel>(AppDatabaseBoxName.boxAdvice);
  static Box<FeeModel> getFee() => Hive.box<FeeModel>(AppDatabaseBoxName.boxFee);
  static Box<PrescriptionPrintLayoutSettingModel> getPrescriptionPrintLayoutSettings() => Hive.box<PrescriptionPrintLayoutSettingModel>(AppDatabaseBoxName.boxPrescriptionPrintLayout);
  static Box<HistoryModel> getHistory() => Hive.box<HistoryModel>(AppDatabaseBoxName.boxHistory);
  static Box<PatientHistoryModel> getPatientHistory() => Hive.box<PatientHistoryModel>(AppDatabaseBoxName.boxPatientHistory);
  static Box<HandoutModel> getHandout() => Hive.box<HandoutModel>(AppDatabaseBoxName.boxHandout);
  static Box<SettingPagesModel> getSettingPages() => Hive.box<SettingPagesModel>(AppDatabaseBoxName.boxSettingsPage);
  static Box<FavoriteIndexModel> getFavoriteIndex() => Hive.box<FavoriteIndexModel>(AppDatabaseBoxName.boxFavoriteIndex);
  static Box<ChamberModel> getChamber() => Hive.box<ChamberModel>(AppDatabaseBoxName.boxChamber);


  static Box<PatientModel> getPatient() => Hive.box<PatientModel>(AppDatabaseBoxName.boxPatient);
  static Box<PatientCertificateModel> getPatientCertificate() => Hive.box<PatientCertificateModel>(AppDatabaseBoxName.boxPatientCertificate);
  static Box<AppointmentModel> getAppointment() => Hive.box<AppointmentModel>(AppDatabaseBoxName.boxAppointment);
  static Box<PatientDiseaseImageModel> getPatientDiseaseImage() => Hive.box<PatientDiseaseImageModel>(AppDatabaseBoxName.boxPatientDiseaseImage);
  static Box<InvestigationReportImageModel>getInvestigationReportImage() => Hive.box<InvestigationReportImageModel>(AppDatabaseBoxName.boxPatientInvestigationReportImage);

  static Box<PrescriptionModel> getPrescription() => Hive.box<PrescriptionModel>(AppDatabaseBoxName.boxPrescription);
  static Box<PrescriptionDrugModel> getPrescriptionDrug() => Hive.box<PrescriptionDrugModel>(AppDatabaseBoxName.boxPrescriptionDrug);
  static Box<PrescriptionDrugDoseModel> getPrescriptionDrugDose() => Hive.box<PrescriptionDrugDoseModel>(AppDatabaseBoxName.boxPrescriptionDrugDose);
  static Box<PrescriptionProcedureModel> getPrescriptionProcedure() => Hive.box<PrescriptionProcedureModel>(AppDatabaseBoxName.boxPrescriptionProcedure);

  static Box<PrescriptionTemplateModel> getPrescriptionTemplate() => Hive.box<PrescriptionTemplateModel>(AppDatabaseBoxName.boxPrescriptionTemplate);
  static Box<PrescriptionTemplateDrugModel> getPrescriptionTemplateDrug() => Hive.box<PrescriptionTemplateDrugModel>(AppDatabaseBoxName.boxPrescriptionTemplateDrug);
  static Box<PrescriptionTemplateDrugDoseModel> getPrescriptionTemplateDrugDose() => Hive.box<PrescriptionTemplateDrugDoseModel>(AppDatabaseBoxName.boxPrescriptionTemplateDrugDose);
  static Box<PatientReferralModel> getPaReferral() => Hive.box<PatientReferralModel>(AppDatabaseBoxName.boxPatientReferral);
  static Box<DoctorModel> getDoctors() => Hive.box<DoctorModel>(AppDatabaseBoxName.boxDoctorCreate);
  static Box<MoneyReceiptModel> getMoneyReceipt() => Hive.box<MoneyReceiptModel>(AppDatabaseBoxName.boxMoneyReceipt);
  static Box<PaImmunizationSchedOptionModel> getPaImmunizationSchedOption() => Hive.box<PaImmunizationSchedOptionModel>(AppDatabaseBoxName.boxPaImmunizationSchedOption);
  static Box<PaImmunizationScheduleModel> getPaImmunizationSchedule() => Hive.box<PaImmunizationScheduleModel>(AppDatabaseBoxName.boxPaImmunizationSched);
  static Box<PaImmunizationVaccinesModel> getPaImmunizationVaccines() => Hive.box<PaImmunizationVaccinesModel>(AppDatabaseBoxName.boxPaImmunizationVaccines);
  static Box<PaImmunizationVaccinesOptModel> getPaImmunizationVaccinesOpt() => Hive.box<PaImmunizationVaccinesOptModel>(AppDatabaseBoxName.boxPaImmunizationVaccinesOption);
  static Box<UserInfoModel> getUserInfo() => Hive.box<UserInfoModel>(AppDatabaseBoxName.boxUserProfile);
  static Box<HistoryCategoryModel> getHistoryCategory() => Hive.box<HistoryCategoryModel>(AppDatabaseBoxName.boxHistoryCat);
  static Box<TreatmentPlanModel> getTreatmentPlan() => Hive.box<TreatmentPlanModel>(AppDatabaseBoxName.boxTreatmentPlan);
  static Box<PhysicianNoteModel> getPhysicianNote() => Hive.box<PhysicianNoteModel>(AppDatabaseBoxName.boxPhysicianNote);
  static Box<ReferralShortModel> getReferralShort() => Hive.box<ReferralShortModel>(AppDatabaseBoxName.boxReferralShort);
  static Box getChildHistory() => Hive.box(AppDatabaseBoxName.boxChildHistory);
  static Box getGynAndObs() => Hive.box(AppDatabaseBoxName.boxGynAndObs);
  static Box getImmunization() => Hive.box(AppDatabaseBoxName.boxImmunization);
  static Box getLastDrugDoseDuration() => Hive.box(AppDatabaseBoxName.boxLastDugDoseDurations);
  static Box getDataOrdering() => Hive.box(AppDatabaseBoxName.boxDataOrdering);
  static Box getGlassPrescription() => Hive.box(AppDatabaseBoxName.boxGlassPrescription);
  static Box getAppClinicalData() => Hive.box(AppDatabaseBoxName.boxAppClinicalData);
  static Box getSmsSuccess() => Hive.box(AppDatabaseBoxName.boxSmsSuccess);
  static Box getPrintPageSetupNew() => Hive.box(AppDatabaseBoxName.boxPrintPageSetupNew);
  static Box getKeyValuePayerField() => Hive.box(AppDatabaseBoxName.boxKeyValuePayerFiled);
  static Box getDefaultDoseDurationInstruction() => Hive.box(AppDatabaseBoxName.boxDefaultDoseDurationInstruction);
  static Box getDosesFormShort() => Hive.box(AppDatabaseBoxName.boxDosesFormShort);
  static Box getVet() => Hive.box(AppDatabaseBoxName.boxVet);

}

