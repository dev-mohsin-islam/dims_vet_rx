
  import 'dart:typed_data';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

const String settingHome = "PrescriptionCretePage";
  const String settingAppointment = "AppointmentPage";

  class Settings{
    static const String settingHome = "PrescriptionCretePage";
    static const String appointment = "AppointmentPage";
    static const String print = "PrescriptionPrintPage";
    static const String assistantAccess = "assistantAccess";
    static const String assistantDoctorAccess = "assistantDoctorAccess";
    static const String others = "others";



    static const String LiveDataSync = "LiveDataSync";

  }

class FavSegment{
  static const chiefComplain = "chiefcomplain";
  static const ia = "investigation";
  static const ir = "investigationReport";
  static const dia = "diagnosis";
  static const procedure = "procedure";
  static const oE = "oe";
  static const brand = "brand";
  static const history = "history";
}

class CRUD{
  static const add = "add";
  static const update = "update";
  static const delete = "delete";
}
class Messages{
  static const success = "Success";
  static const addSuccess = "Added successfully";
  static const updateSuccess = "Updated successfully";
  static const deleteSuccess = "Deleted successfully";
  static const failed = "Failed";
}

class syncTimeSharedPrefsKey{
  static const activeChamberId = "activeChamberId";
  static const advice = "advice";
  static const brand = "brand";
  static const cc = "cc";
  static const company = "company";
  static const diagnosis = "diagnosis";
  static const dose = "dose";
  static const duration = "duration";
  static const generic = "generic";
  static const handout = "handout";
  static const history = "history";
  static const instruction = "instruction";
  static const investigationAdvice = "investigationAdvice";
  static const investigationReport = "investigationReport";
  static const onExamination = "onExamination";
  static const onExaminationCategory = "onExaminationCategory";
  static const procedure = "procedure";
  static const patient = "patient";
  static const appointment = "appointment";
  static const prescription = "prescription";
  static const prescriptionDrug = "prescriptionDrug";
  static const prescriptionDrugDose = "prescriptionDrugDose";
  static const template = "template";
  static const templateDrug = "templateDrug";
  static const templateDrugDose = "templateDrugDose";
  static const favorite = "favorite";
  static const patientsSocialHistory = "patientsSocialHistory";
  static const patientsAllergyHistory = "patientsAllergyHistory";
  static const patientsFamilyHistory = "patientsFamilyHistory";
  static const generalSettings = "generalSettings";
  static const prescriptionLayoutSettings = "prescriptionLayoutSettings";
  static const certificate = "certificate";
  static const diseaseImage = "diseaseImage";
  static const investigationImage = "investigationImage";
  static const gynehistory = "gynehistory";
  static const childHistory = "childHistory";
  static const historyCategory = "historyCategory";
  static const historyNew = "historyNew";
  static const physicianNotes = "physicianNotes";
  static const treatmentPlan = "treatmentPlan";
}


class ScreenTitle{
  static const String ChiefComplain = "Chief Complaints";
  static const String OnExaminationCategory = "On Examination Category's";
  static const String OnExamination = "On Examinations";
  static const String Investigation = "Investigations";
  static const String Diagnosis = "Diagnosis List";
  static const String InvestigationReport = "Investigation Reports";
  static const String Procedure = "Procedures";
  static const String Strength = "Strengths";
  static const String DrugGeneric = "Generics";
  static const String CompanyName = "Company Names";
  static const String Dose = "Doses";
  static const String Instruction = "Instructions";
  static const String AdviceCategory = "Advice Categorys";
  static const String HandoutCategory = "Handout Categorys";
  static const String ImprovementType = "Improvement Types";
  static const String Speciality = "Speciality";
  static const String BloodGroup = "Blood Group";
  static const String DrugBrand = "Drug Brands";
  static const String Patient = "Patient List";
  static const String Appointment = "Appointments";
  static const String Prescription = "Prescriptions";
  static const String PrescriptionTemplate = "Templates";
  static const String Duration = "Durations";
  static const String screenAdviceList = "Advices";
  static const String screenHandout = "Handouts";
  static const String screenFeeList = "Fees";
  static const String screenPrescriptionPrintLayoutSettings = "Prescription Print Layout Settings";
  static const String screenAllergyHistory = "Allergy History";
  static const String screenFamilyHistory = "Family History";
  static const String screenPersonalHistory = "Personal History";
  static const String screenPastHistory = "Past History";
  static const String screenHistory = "History";
}

class AppButtonString{
  static const String saveString = "Save";
  static const String pPrescriptionSaveAndPrint = "Save & Print";
  static const String pPrescriptionSave = "Save only";
  static const String closeString = "Close";
  static const String updateString = "Update";
  static const String cancelString = "Cancel";
  static const String removeString = "Remove";
  static const String saveAsTemplateString = "Save As Template";
  static const String DefaultSettingSetup = "Default Settings Setup";
}

class AppInputLabel{
  static const patientName = "Patient Name";
  static const postOperativeInstructions = "Post Operative Instructions";
  static const drains = "Drains";
  static const complications = "Complications";
  static const findings = "Findings";
  static const closer = "Closer";
  static const prosthesis = "Prosthesis";
  static const procedureDetails = "Procedure Details";
  static const incision = "Incision";
  static const assistant = "Assistant";
  static const surgeonName = "Surgeon Name";
  static const anesthesia = "Anesthesia";
  static const diagnosis = "Diagnosis";
  static const procedureName = "Procedure Name";

  //print setup page
  static const pageHeight = "Page Height (inc)";
  static const pageWidth = "Page width (inc)";
  static const sideBarWidth = "Side bar width (inc)";
  static const headerHeight = "Header Height (inc)";
  static const footerHeight = "Footer Height (inc)";
  static const fontSize = "Font Size";
  static const fontSizePaInfo = "Font Size (Patient Info)";
  static const fontColor = "Font Color";
  static const marginTop = "Top";
  static const marginBottom = "Bottom";
  static const marginLeft = "Left";
  static const marginRight = "Right";

  static const clinicalDataMargin = "Gap Between Clinical Data";
  static const brandDataMargin = "Gap Between Brand Data";
  static const rxDataStartingTopMargin = "Top Margin of Brand Data";
  static const clinicalDataStartingTopMargin = "Top Margin of Clinical Data";
  static const adviceGapBetween = "Gap Between Advice Data";

  static const marginBeforePatientId = "Gap Before ID";
  static const marginBeforePatientName = "Gap Before Name";
  static const marginBeforePatientAge = "Gap Before Age";
  static const marginBeforePatientGender = "Gap Before Gender";
  static const marginBeforePatientDate = "Gap Before Date";

  static const clinicalDataPrintingPerPage = "Clinical data Show Per Page";
  static const brandDataPrintingPerPage = "Medicine Show Per Page";
  static const clinicalAndBrandDataPerPageGap = "Item Gap (Developer option)";
  static const marginAroundFullPage = "Margin Around Full Page";
  static const clinicalDataLeftMargin = "Clinical Data Left Margin";
  static const clinicalDataRightMargin = "Clinical Data Right Margin";
  static const brandDataRightMargin = "Brand Data Right Margin";
  static const brandDataLeftMargin = "Brand Data Left Margin";

}



final List bloodGroupList = [

   {"value":2, "label": "A RhD positive (A+)"},
   {"value":3, "label": "A RhD negative (A-)"},
  {"value":1, "label": "B RhD positive (B+)"},
   {"value":4, "label": "B RhD negative (B-)"},
  {"value":7, "label": "O RhD positive (O+)"},
  {"value":8, "label": "O RhD negative (O-)"},
   {"value":5, "label": "AB RhD positive (AB+)"},
   {"value":6, "label": "AB RhD negative (AB-)"},
   {"value":0, "label": "None"},
 ]
;

  List<String> timePeriodsForCertificate = [
    '1 day', '2 days', '3 days', '4 days', '5 days', '6 days', '7 days',
    '1 week', '2 weeks', '3 weeks', '4 weeks', '5 weeks', '6 weeks', '7 weeks',
    '1 month', '2 months', '3 months', '4 months', '5 months', '6 months',
    '1 year', '2 years', '3 years'
  ];

  List chamberList = [
    {"id":1, "chamber_name": "Upper", },
    {"id":2, "chamber_name": "Lower", },
    {"id":3, "chamber_name": "Both", },
    {"id":0, "chamber_name": "None", },
  ];

  const List reasonToRef = ['Evaluation & Management', 'Consultation', '2nd Opinion', 'Surgery', 'Other', 'All the required documents are supplied.'];

  RxList<Map<String, dynamic>> headerFooterAndBgImageC= [
    {"headerImage":  Uint8List(0),"footerImage":  Uint8List(0), "backgroundImage":  Uint8List(0), "digitalSignature":  Uint8List(0), "rxIcon":  Uint8List(0)},
  ].obs;