
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
import 'package:dims_vet_rx/models/money_receipt/money_receipt_model.dart';
import 'package:dims_vet_rx/models/on_examination_category/on_examination_category_model.dart';
import 'package:dims_vet_rx/models/pa_immunization_schedule/pa_immunization_schedule_model.dart';
import 'package:dims_vet_rx/models/pa_immunization_schedule_option/pa_immunization_schedule_option_model.dart';
import 'package:dims_vet_rx/models/pa_immunization_vaccines_options/pa_immunization_vaccines_option_model.dart';
import 'package:dims_vet_rx/models/patient/patient_model.dart';
import 'package:dims_vet_rx/models/patient_certificate/patient_certificate_model.dart';
import 'package:dims_vet_rx/models/patient_disease_image/patient_disease_image_model.dart';
import 'package:dims_vet_rx/models/patient_history/patient_history_model.dart';
import 'package:dims_vet_rx/models/patient_referral/patient_referral_model.dart';
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
import '../models/create_prescription/prescription_procedure/prescription_procedure_model.dart';
import '../models/general_setting_pages/prescription_print_layout_settings/prescription_print_layout_setting_model.dart';
import '../models/general_setting_pages/setting_pages_model.dart';
import '../models/on_examination/on_examination_model.dart';
import '../models/pa_immunization_vaccines/pa_immunization_vaccines_model.dart';
import '../models/prescription_template/prescription_template/prescription_template_model.dart';
import '../models/prescription_template/prescription_template_drug/prescription_template_drug_model.dart';


 class AdapterAssign{
  adapterList(){
    Hive.registerAdapter(ChiefComplainModelAdapter());
    Hive.registerAdapter(OnExaminationCategoryModelAdapter());
    Hive.registerAdapter(OnExaminationModelAdapter());
    Hive.registerAdapter(InvestigationModalAdapter());
    Hive.registerAdapter(InvestigationReportModelAdapter());
    Hive.registerAdapter(DiagnosisModalAdapter());
    Hive.registerAdapter(ProcedureModelAdapter());
    Hive.registerAdapter(StrengthModelAdapter());
    Hive.registerAdapter(DrugGenericModelAdapter());
    Hive.registerAdapter(DoseModelAdapter());
    Hive.registerAdapter(InstructionModelAdapter());
    Hive.registerAdapter(AdviceCategoryModelAdapter());
    Hive.registerAdapter(HandoutCategoryModelAdapter());
    Hive.registerAdapter(ImprovementTypeModelAdapter());
    Hive.registerAdapter(BloodGroupModelAdapter());
    Hive.registerAdapter(DrugBrandModelAdapter());
    Hive.registerAdapter(CompanyNameModelAdapter());
    Hive.registerAdapter(PrescriptionDurationModelAdapter());
    Hive.registerAdapter(AdviceModelAdapter());
    Hive.registerAdapter(FeeModelAdapter());
    Hive.registerAdapter(PrescriptionPrintLayoutSettingModelAdapter());
    Hive.registerAdapter(HistoryModelAdapter());
    Hive.registerAdapter(PatientHistoryModelAdapter());
    Hive.registerAdapter(SettingPagesModelAdapter());
    Hive.registerAdapter(FavoriteIndexModelAdapter());

    Hive.registerAdapter(PatientModelAdapter());
    Hive.registerAdapter(AppointmentModelAdapter());
    Hive.registerAdapter(PatientDiseaseImageModelAdapter());

    Hive.registerAdapter(PrescriptionModelAdapter());
    Hive.registerAdapter(InvestigationReportImageModelAdapter());
    Hive.registerAdapter(PrescriptionDrugModelAdapter());
    Hive.registerAdapter(PrescriptionDrugDoseModelAdapter());
    Hive.registerAdapter(PrescriptionProcedureModelAdapter());

    Hive.registerAdapter(PrescriptionTemplateModelAdapter());
    Hive.registerAdapter(PrescriptionTemplateDrugModelAdapter());
    Hive.registerAdapter(PrescriptionTemplateDrugDoseModelAdapter());
    Hive.registerAdapter(HandoutModelAdapter());
    Hive.registerAdapter(PatientCertificateModelAdapter());
    Hive.registerAdapter(ChamberModelAdapter());
    Hive.registerAdapter(PatientReferralModelAdapter());
    Hive.registerAdapter(DoctorModelAdapter());
    Hive.registerAdapter(MoneyReceiptModelAdapter());
    Hive.registerAdapter(PaImmunizationSchedOptionModelAdapter());
    Hive.registerAdapter(PaImmunizationVaccinesModelAdapter());
    Hive.registerAdapter(PaImmunizationScheduleModelAdapter());
    Hive.registerAdapter(PaImmunizationVaccinesOptModelAdapter());
    Hive.registerAdapter(UserInfoModelAdapter());
    Hive.registerAdapter(HistoryCategoryModelAdapter());
    Hive.registerAdapter(TreatmentPlanModelAdapter());
    Hive.registerAdapter(PhysicianNoteModelAdapter());
    Hive.registerAdapter(ReferralShortModelAdapter());
  }
}