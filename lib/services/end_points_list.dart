

class Syncs{
  static const String BaseUrl = "http://dimsrx.itmapi.com/api/sync";
  // static const String BaseUrl = "http://nstaging.itmedicus.org/api/sync";
  static const String BaseUrlLogin = "http://dimsrx.itmapi.com/api";
  // static const String BaseUrlLogin = "http://nstaging.itmedicus.org/api";
  static const String BaseUrlLogOut = "http://dimsrx.itmapi.com/api";
  // static const String BaseUrlLogOut = "http://nstaging.itmedicus.org/api";


  static const String Login = "/login";
  static const String Logout = "/logout";
  static const String User = "/user";

  static const String ChiefComplain = "/chiefcomplain";
  static const String Diagnosis = "/diagnosis";
  static const String OnExamination = "/onexamination";
  static const String OnExaminationCategory = "/onexaminationCategory";

  static const String Investigation = "/investigation";
  static const String InvestigationReport = "/investigationReport";
  static const String Procedure = "/procedure";

  static const String History = "/history";
  static const String HistoryList = "/historyListSearch";
  static const String HistoryCategory = "/historyCategories";

  static const String Immunization = "/immunization";

  static const String Advice = "/advice";
  static const String Instruction = "/instruction";
  static const String Duration = "/duration";
  static const String Dose = "/dose";

  static const String Company = "/company";
  static const String Generic = "/generic";
  static const String Brand = "/brand";
  static const String BrandFormShort = "/brandFormShort";

  static const String Appointment = "/appointment";
  static const String Patients = "/patients";
  static const String PatientsOld = "/oldPatients";
  static const String AllHistory = "/history";
  static const String gynehistory = "/gynehistory";
  static const String childhistory = "/childhistory";

  static const String PatientsPersonalHistory= "/patientsPersonalHistory";
  static const String PatientsPastHistory = "/patientsPastHistory";
  static const String PatientsFamilyHistory = "/patientsFamilyHistory";
  static const String PatientsAllergyHistory = "/patientsAllergyHistory";

  static const String ImmunizationVaccines = "/immunizationVaccines";
  static const String ImmunizationVaccinesOptional = "/immunizationVaccinesOptional";
  static const String ImmunizationSchedule = "/immunizationSchedule";
  static const String ImmunizationScheduleOptional = "/immunizationScheduleOptional";
  static const String PrescriptionHandout = "/prescriptionHandout";
  static const String PrescriptionProcedure = "/prescriptionProcedure";
  static const String Prescription = "/prescription";
  static const String PrescriptionDrug = "/prescriptionDrug";
  static const String PrescriptionDrugDose = "/prescriptionDrugDose";
  static const String Favorite = "/favorite";
  static const String FavoriteDoctor = "/favoriteDoctor";

  static const String PrescriptionTemplate = "/prescriptionTemplate";
  static const String PrescriptionTemplateDrug = "/prescriptionTemplateDrug";
  static const String PrescriptionTemplateDrugDose = "/prescriptionTemplateDrugDose";

  static const String GyneObs = "/gyneobs";
  static const String ChildHistory = "/childhistory";
  static const String Refer = "/refer";
  static const String Certificate = "/certificate";
  static const String MoneyReceipt = "/moneyreceipt";

  static const String Fees = "/fees";
  static const String HandOut = "/handout";

  static const String Assistant = "/assistant";
  static const String InvestigationImage = "/investigationImage";
  static const String DiseaseImage = "/diseaseImage";
  static const String MedicalCertificate = "/medicalCertificate";
  static const String investigationImage = "/investigationImage";
  static const String diseaseImage = "/diseaseImage";
  static const String medicalCertificate = "/medicalCertificate";
  static const String historyCategory = "/historyCategory";
  static const String historyNew = "/history";

}
class ApiCUD{
  static const String BaseUrl = "http://dimsrx.itmapi.com/api";
  // static const String BaseUrl = "http://nstaging.itmedicus.org/api";

  static const String Login = "/login";
  static const String Logout = "/logout";
  static const String User = "/user";
  static const String updatePassword = "/user/updatepassword";
  static const String chambers = "/user/chambers";
  static const String Assistant = "/user/assistant";
  static const String rxIcon = "/user/chambers/rxicon";
  static const String signature = "/user/chambers/signature";
  static const String profileImage = "/user/profileImage";


  static const String ChiefComplain = "/cc";
  static const String Diagnosis = "/diagnosis";
  static const String OnExamination = "/oe";
  static const String specialNote = "/specialNote";
  static const String treatmentPlan = "/treatmentPlan";
  static const String OnExaminationCategory = "/oeCategory";

  static const String Investigation = "/investigation";
  static const String InvestigationReport = "/investigationReport";
  static const String Procedure = "/procedure";
  static const String History = "/history";
  static const String desktopSettingsGeneral = "/desktopsettings/general";
  static const String desktopSettingsPrescriptionLayout = "/desktopsettings/prescriptionLayout";
  static const String imageHeader = "/imageheader";
  static const String imageFooter = "/imagefooter";
  static const String imageFooterUpload = "/imagefooter/upload";
  static const String imageHeaderUpload = "/imageheader/upload";
  static const String inReportImage = "/investigationImage";
  static const String patientDisease = "/diseaseImage";
  static const String investigationImage = "/investigationImage";


  static const String Immunization = "/immunization";

  static const String Advice = "/advice";

  static const String Instruction = "/instruction";
  static const String Duration = "/duration";
  static const String Dose = "/dose";

  static const String Company = "/company";
  static const String Generic = "/generic";
  static const String Brand = "/brand";
  static const String BrandFormShort = "/brandFormShort";

  static const String Appointment = "/appointmentUpload";
  static const String AppointmentCancel = "/appointmentCancel";

  static const String Patients = "/patients";

  static const String PatientsPersonalHistory= "/patientsPersonalHistory";
  static const String PatientsPastHistory = "/patientsPastHistory";
  static const String PatientsFamilyHistory = "/patientsFamilyHistory";
  static const String PatientsAllergyHistory = "/patientsAllergyHistory";
  static const String ImmunizationVaccines = "/immunizationVaccines";
  static const String ImmunizationVaccinesOptional = "/immunizationVaccinesOptional";
  static const String ImmunizationSchedule = "/immunizationSchedule";
  static const String ImmunizationScheduleOptional = "/immunizationScheduleOptional";
  static const String PrescriptionHandout = "/prescriptionHandout";
  static const String PrescriptionProcedure = "/prescriptionProcedure";
  static const String CreatePrescription = "/createPrescription";
  static const String PatientHistory = "/patient/patienthistory";
  static const String BrandFieldSave = "/brandFieldSave";
  static const String PrescriptionDrug = "/prescriptionDrug";
  static const String Favorite = "/favoriteAdd";
  static const String FavoriteDoctor = "/favoriteDoctor";

  static const String PrescriptionTemplate = "/prescriptionTemplate";
  static const String TemplateName = "/templateItems";
  static const String PrescriptionTemplateDrug = "/prescriptionTemplateDrug";


  static const String GyneObs = "/gyneobs";
  static const String ChildHistory = "/childhistory";
  static const String Refer = "/refer";
  static const String Certificate = "/certificate";
  static const String MoneyReceipt = "/moneyreceipt";
  static const String Fee = "/fee";
  static const String HandOut = "/handout";
  static const String doctor = "/favoriteDoctor";
  static const String referral = "/referralSystem";
  static const String certificate = "/medicalCertificate";
  static const String pdfPrescription = "/pdfPrescription";
  static const String patientChildHistory = "/patient/childhistory";
  static const String gyneHistory = "/patient/gynehistory";
  static const String historyCategory = "/historyCategory";


}