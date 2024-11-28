
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';
import 'package:dims_vet_rx/controller/child_history/child_history_controller.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/methods/glass_prescription_controller.dart';
import 'package:dims_vet_rx/controller/dose/dose_controller.dart';
import 'package:dims_vet_rx/controller/drug_brand/drug_brand_controller.dart';
import 'package:dims_vet_rx/controller/favorite_index/favorite_index_controller.dart';
import 'package:dims_vet_rx/controller/general_setting/general_setting_controller.dart';
import 'package:dims_vet_rx/controller/general_setting/prescription_print_page_setup_controller.dart';
import 'package:dims_vet_rx/controller/gyn_and_obs/gyn_and_obs_controller.dart';
import 'package:dims_vet_rx/controller/history/history_controller.dart';
import 'package:dims_vet_rx/controller/immunization.dart';
import 'package:dims_vet_rx/controller/patient_disease_image/patient_disease_image_controller.dart';
import 'package:dims_vet_rx/controller/prescription_duration/prescription_duration_controller.dart';
import 'package:dims_vet_rx/controller/procedure/procedure_controller.dart';
import 'package:dims_vet_rx/database/crud_operations/prescription_procedure.dart';
import 'package:dims_vet_rx/models/advice/advice_model.dart';
import 'package:dims_vet_rx/models/appointment/appointment_model.dart';
import 'package:dims_vet_rx/models/chief_complain/chief_complain_model.dart';
import 'package:dims_vet_rx/models/diagnosis/diagnosis_modal.dart';
import 'package:dims_vet_rx/models/drug_brand/drug_brand_model.dart';
import 'package:dims_vet_rx/models/history/history_model.dart';
import 'package:dims_vet_rx/models/investigation/investigation_modal.dart';
import 'package:dims_vet_rx/models/on_examination/on_examination_model.dart';
import 'package:dims_vet_rx/models/patient_appointment_prescription.dart';

import '../../../database/crud_operations/appointment_crud.dart';
import '../../../database/crud_operations/brand_crud.dart';
import '../../../database/crud_operations/common_crud.dart';
import '../../../database/crud_operations/patient_crud.dart';
import '../../../database/crud_operations/prescription_crud.dart';
import '../../../database/crud_operations/prescription_template.dart';
import '../../../database/hive_get_boxes.dart';
import '../../../models/create_prescription/prescription/prescription_model.dart';
import '../../../models/create_prescription/prescription_drug/prescription_drug_model.dart';
import '../../../models/create_prescription/prescription_drug_dose/prescription_drug_dose_model.dart';
import '../../../models/create_prescription/prescription_procedure/prescription_procedure_model.dart';
import '../../../models/investigation_report/investigation_report_model.dart';
import '../../../models/patient/patient_model.dart';
import '../../../models/patient_appointment_model.dart';
import '../../../models/prescription_template/prescription_template/prescription_template_model.dart';
import '../../../models/prescription_template/prescription_template_drug/prescription_template_drug_model.dart';
import '../../../models/prescription_template/prescription_template_drug_dose/prescription_template_drug_dose_model.dart';
import '../../../screens/others_data_screen/prescription_list.dart';
import '../../../screens/page_route_builder.dart';
import '../../../screens/printing/prescription_pdf_for_email/print.dart';
import '../../../screens/printing/prescription_print/print.dart';
import '../../../screens/printing/prescription_print/print_gp.dart';
import '../../../utilities/default_value.dart';
import '../../../utilities/app_strings.dart';
import '../../../utilities/helpers.dart';
import '../../company_name/company_name_controller.dart';
import '../../drawer_controller/drawer_controller.dart';
import '../../drug_generic/drug_generic_controller.dart';
import '../../instruction/instruction_controller.dart';
import '../../investigation_report_image/investigation_report_image_cotroller.dart';
import '../../prescription_template/prescription_template_controller.dart';

class PrescriptionController extends GetxController{
  final Box<PatientModel>boxPatient = Boxes.getPatient();
  final Box<DrugBrandModel>brandBox = Boxes.getDrugBrand();
  final Box<AppointmentModel>boxAppointment = Boxes.getAppointment();
  final Box<PrescriptionModel>boxPrescription = Boxes.getPrescription();
  final Box<PrescriptionDrugModel>boxPrescriptionDrug = Boxes.getPrescriptionDrug();
  final Box<PrescriptionDrugDoseModel>boxPrescriptionDrugDose = Boxes.getPrescriptionDrugDose();
  final Box<PrescriptionProcedureModel>boxPrescriptionProcedure = Boxes.getPrescriptionProcedure(); 
  final Box<PrescriptionTemplateModel>boxPrescriptionTemplate = Boxes.getPrescriptionTemplate();
  final Box<PrescriptionTemplateDrugModel>boxPrescriptionTemplateDrug = Boxes.getPrescriptionTemplateDrug();
  final Box<PrescriptionTemplateDrugDoseModel>boxPrescriptionTemplateDrugDose = Boxes.getPrescriptionTemplateDrugDose();
  final Box boxLastDrugDoseDuration = Boxes.getLastDrugDoseDuration();

  final FavoriteIndexController favoriteIndexController = Get.put(FavoriteIndexController());
  final ProcedureController _procedureController = Get.put(ProcedureController());
  final  _glassPrescriptionController = Get.put(GlassPrescriptionController());
  final PatientCRUDController patientCRUDController = Get.put(PatientCRUDController());
  final PatientDiseaseImageController patientDiseaseImageController = Get.put(PatientDiseaseImageController());
  final InvestigationReportImageController investigationReportImageController = Get.put(InvestigationReportImageController());
  final HistoryController historyController = Get.put(HistoryController());
  final CompanyNameController companyNameController = Get.put(CompanyNameController());
  final DrugGenericController genericController = Get.put(DrugGenericController());
  final DrugBrandController drugBrandController = Get.put(DrugBrandController());
  final BrandCrudController brandCrudController = Get.put(BrandCrudController());
  final doseController = Get.put(DoseController());

  final PrescriptionBoxCRUDController prescriptionBoxCRUDController = Get.put(PrescriptionBoxCRUDController());
  final PrescriptionProcedureCRUDBoxController prescriptionProcedureCRUDBoxController = Get.put(PrescriptionProcedureCRUDBoxController());
  final PrescriptionTemplateBoxCRUDController prescriptionTemplateBoxCRUDController = Get.put(PrescriptionTemplateBoxCRUDController());
  final PrescriptionTemplateController prescriptionTemplateController = Get.put(PrescriptionTemplateController());
  final GeneralSettingController generalSettingController = Get.put(GeneralSettingController());

  final AppointmentBoxController appointmentBoxController = Get.put(AppointmentBoxController());
  final CommonController commonController = Get.put(CommonController());
  final ChildHistoryController childHistoryController = Get.put(ChildHistoryController());
  final GynAndObsController gynAndObsController = Get.put(GynAndObsController());
  final immunizationController = Get.put(Immunization());

  final PrescriptionPrintPageSetupController prescriptionPrintPageSetupController = Get.put(PrescriptionPrintPageSetupController());

  TextEditingController specialNotes = TextEditingController();
  RxString specialNotesX = ''.obs;
  TextEditingController treatmentPlan = TextEditingController();
  RxString treatmentPlanX = ''.obs;
  TextEditingController referralShort = TextEditingController();
  RxString referralShortX = ''.obs;

  RxBool isExpanded = false.obs;
  RxInt selectedBrandId = 0.obs;
  RxBool showFavoriteList =  false.obs;
  List PrescriptionSettings = [];
  RxList searchedGenericName = [].obs;
  RxList searchedCompanyName = [].obs;
  showFavoriteBrandFirst(){
    bool vale  = generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "DefaultFavoriteBrandShowFirst");
    showFavoriteList.value = vale;
     }

  //only prescription data get from prescription database
  final RxList prescriptionList =  [].obs;


  //appointment data get from appointment table
  final RxList appointmentList =  [].obs;

  //patient data, get from patient table
  final RxList patientInfo =  [].obs;

  //patient and appointment table data join
  final RxList patientAndAppointmentInfoJoin =  [].obs;
  final RxList patientAppPrescriptionJoin =  [].obs;

  //medicine (brand) data get from drug brand table
  final RxList brandList = [].obs;

  //medicine (brand) data, join data list (generic, company, brand) table join
  final RxList modifyDrugData =  [].obs;
  final RxList drugDataForPrint =  [].obs;
  final RxList modifyDrugDataForSearch =  [].obs;
  final RxList favoriteDrugList =  [].obs;
  final RxString brandSearchText =  ''.obs;

  // received from appointment controller (this value use for default id)
  RxInt PATIENT_ID_FOR_FOLLOWUP = 0.obs;
  RxInt PATIENT_ID = 0.obs;
  RxInt APPOINTMENT_ID = 0.obs;
  RxInt PRESCRIPTION_ID = 0.obs;
  RxInt PRESCRIPTION_ID_FOR_PRINT = 0.obs;

  // these list use for get data from prescription when user create a prescription
  //--start
  RxList selectedMedicine = [].obs;
  RxList selectedChiefComplain = [].obs;
  String selectedChiefComplainString = "";
  RxList selectedOnExamination = [].obs;
  RxList selectedOnExaminationApp = [].obs;
  String selectedOnExaminationString = "";
  RxList selectedDiagnosis = [].obs;
  String selectedDiagnosisString = "";
  RxList selectedInvestigationAdvice = [].obs;
  String selectedInvestigationAdviceString = "";
  RxList selectedInvestigationReport = [].obs;
  String selectedInvestigationReportString = "";
  RxList selectedShortAdvice = [].obs;
  String selectedShortAdviceString = "";

  RxList selectedAllHistory = [].obs;
  RxList selectedAllergyHistory = [].obs;
  RxList selectedPersonalHistory = [].obs;
  RxList selectedFamilyHistory = [].obs;
  RxList selectedPastHistory = [].obs;
  RxList selectedSocialHistory = [].obs;
  RxList selectedFoodsAllergyHistory = [].obs;
  RxList selectedDrugAllergyHistory = [].obs;
  RxList selectedEnvironmentalAllergyHistory = [].obs;

  RxList selectedPatientAndAppointmentInfo = [].obs;
  RxList usesInvestigationAdvice = [].obs;

  RxString ageDemo = "".obs;

  final TextEditingController addNewClinicalDataController = TextEditingController();

  //--end


  final TextEditingController templateNameController= TextEditingController();
  final TextEditingController brandSearchController= TextEditingController();

  // use for open right drawer (insert clinical data into prescription)



  final TextEditingController searchController= TextEditingController();
  RxBool isLoading = true.obs;

  final uuid = DefaultValues.defaultUuid;
  final date = DefaultValues.defaultDate;
  final web_id = DefaultValues.defaultweb_id;
  final statusNewAdd = DefaultValues.NewAdd;
  final statusUpdate = DefaultValues.Update;
  final statusDelete = DefaultValues.Delete;

  Map<String, dynamic> prescriptionDataIn = {
    "note": "",
    "physical_findings": "",

    "investigation_report_text": "",
  };

  // get patient and appointment id from appointment controller
  Future<void> getPatientAndAppointmentID(patientId,appointmentId, [prescriptionId = 0])async{
      PATIENT_ID.value =  patientId;
      APPOINTMENT_ID.value = appointmentId;
      PATIENT_ID_FOR_FOLLOWUP.value = patientId;
      PRESCRIPTION_ID.value = prescriptionId;
  }


  //for clinical data box----start
  List chiefComplainList = [];
  List diagnosisList = [];
  List onExaminationList = [];
  List investigationAdviceList = [];
  List investigationReportList = [];
  stringToListClinicalData(type, string){
    if(type == EndDrawerScreenValues.chiefComplain){
      chiefComplainList = string;
    }else if(type == EndDrawerScreenValues.diagnosis){
      diagnosisList = string;
    }else if(type == EndDrawerScreenValues.onExamination){
      onExaminationList = string;
    }else if(type == EndDrawerScreenValues.investigationAdvice){
      investigationAdviceList = string;
    }else if(type == EndDrawerScreenValues.investigationReport){
      investigationReportList = string;
    }
  }
  stringListConvertToString()async{
    if(chiefComplainList.isNotEmpty){
      selectedChiefComplainString = chiefComplainList.join('\n');
    }
    if(diagnosisList.isNotEmpty){
      selectedDiagnosisString = diagnosisList.join( '\n');
    }
    if(onExaminationList.isNotEmpty){
      selectedOnExaminationString = onExaminationList.join('\n');
    }
    if(investigationAdviceList.isNotEmpty){
      selectedInvestigationAdviceString = investigationAdviceList.join('\n');
    }
    if(investigationReportList.isNotEmpty){
      selectedInvestigationReportString = investigationReportList.join('\n');
    }
    if(selectedShortAdvice.isNotEmpty){
      selectedShortAdviceString = await shortAdviceDataJoiningToString(selectedShortAdvice);
    }

  }

//for clinical data box----end

  RxList selectedHandoutFilters = [].obs ;

  // this method use for create new clinical data into prescription
   addNewClinicalDataToPrescription(id,type){
    if(addNewClinicalDataController.text.isNotEmpty){
      if(type ==FavSegment.chiefComplain){
        selectedChiefComplain.add(ChiefComplainModel(id: id, name: addNewClinicalDataController.text));
      }else if(type ==FavSegment.dia){
        selectedDiagnosis.add(DiagnosisModal(id: id, name: addNewClinicalDataController.text));
      }else if(type ==FavSegment.oE){
        selectedOnExamination.add(OnExaminationModel(id: id, name: addNewClinicalDataController.text));
      }else if(type ==FavSegment.ia){
        selectedInvestigationAdvice.add(InvestigationModal(id: id, name: addNewClinicalDataController.text));
      }else if(type ==FavSegment.ir){
        selectedInvestigationReport.add(InvestigationReportModel(id: id, name: addNewClinicalDataController.text));
      }
    }else{
      Helpers.errorSnackBar("Failed", "Field must be not empty");
    }
    addNewClinicalDataController.clear();
  }




  // clinical data convert list to string for insert in database
  Future<dynamic> clinicalDataConvertToString()async{
      selectedChiefComplainString = await  clinicalDataJoiningToString(selectedChiefComplain);
      selectedDiagnosisString = await clinicalDataJoiningToString(selectedDiagnosis);
      selectedOnExaminationString = await clinicalDataJoiningToString(selectedOnExamination);
      selectedInvestigationAdviceString = await clinicalDataJoiningToString(selectedInvestigationAdvice);
      selectedInvestigationReportString = await clinicalDataJoiningToString(selectedInvestigationReport);
      selectedShortAdviceString = await shortAdviceDataJoiningToString(selectedShortAdvice);
  }


  showFavoriteListFunction(value){
    showFavoriteList.value = !showFavoriteList.value;
  }

  favoriteListFunction()async{
    favoriteDrugList.clear();
    if(modifyDrugData.isNotEmpty){
      for(var DrugData in modifyDrugData){
        var favoriteIndex = DrugData['brand_id'];
        var favoriteId = await favoriteIndexController.favoriteIndexDataList.firstWhere((element) => element.favorite_id == favoriteIndex && element.segment ==FavSegment.brand, orElse: () => null,);
        if(favoriteId !=null){
          favoriteDrugList.add(DrugData);
        }
      }

    }

  }
  // favoriteListFunction() async {
  //   favoriteDrugList.clear();
  //   // Create a copy of modifyDrugData to avoid concurrent modification issues.
  //   var drugDataCopy = List.from(modifyDrugData);
  //
  //   if (drugDataCopy.isNotEmpty) {
  //     for (var drugData in drugDataCopy) {
  //       var favoriteIndex = drugData['brand_id'];
  //       var favoriteId = await favoriteIndexController.favoriteIndexDataList.firstWhere(
  //             (element) => element.favorite_id == favoriteIndex && element.segment == AppConstantsFavoriteSegments.brand,
  //         orElse: () => null,
  //       );
  //       if (favoriteId != null) {
  //         favoriteDrugList.add(drugData);
  //       }
  //     }
  //   }
  // }


  Future<void> deleteOldPrescription() async {
    await prescriptionBoxCRUDController.deleteOldestPrescription(boxPrescription);
  }

  // this method use for Save prescription data to database(box)
  Future<void> savePrescription(prescriptionConvertedData,responseAppointment, context, [bool isSaveOnly = false, isGpPrint = false])async{
      String? specialNotes = prescriptionConvertedData['specialNotes'].toString();
      String? treatmentPlan = prescriptionConvertedData['treatmentPlan'].toString();
      String? referralShort = prescriptionConvertedData['referralShort'].toString();
      var selectedMedicineList = prescriptionConvertedData['selectedMedicine'];
      String selectedChiefComplainConverted = prescriptionConvertedData['selectedChiefComplain'];
      String selectedDiagnosisConverted = prescriptionConvertedData['selectedDiagnosis'];
      String selectedOnExaminationConverted = prescriptionConvertedData['selectedOnExamination'];

      String selectedInvestigationAdviceConverted = prescriptionConvertedData['selectedInvestigationAdvice'];
      String selectedInvestigationReportConverted = prescriptionConvertedData['selectedInvestigationReport'];

      List selectedInvestigationReportImage = prescriptionConvertedData['selectedInvestigationReportImage'] ?? [];
      List selectedPatientDiseaseImage = prescriptionConvertedData['selectedPatientDiseaseImage'] ?? [];
      // String selectedShortAdvice = prescriptionConvertedData['shortAdvice'];
      String selectedShortAdvice ='';

      List selectedProcedure = prescriptionConvertedData['selectedPrescriptionProcedure'];


      if(PATIENT_ID.value !=-1 && PATIENT_ID.value !=0 && APPOINTMENT_ID.value !=-1 && APPOINTMENT_ID.value !=0){
         await patientDiseaseImageController.addData(APPOINTMENT_ID.value, selectedPatientDiseaseImage);
         await investigationReportImageController.addDataInvImage(APPOINTMENT_ID.value, selectedInvestigationReportImage);
         await historyController.patientHistorySaveToDatabase(
           PATIENT_ID.value,
        );
         if(_glassPrescriptionController.isDataExist.value == true){
           _glassPrescriptionController.saveGlassPrescription(PATIENT_ID.value, APPOINTMENT_ID.value);
         }
         if(childHistoryController.isDataExist.value == true){
           childHistoryController.saveChildHistory(PATIENT_ID.value);
         }
         if(gynAndObsController.isDataExist.value == true){
           gynAndObsController.savePatientGynHistory(PATIENT_ID.value);
         }
         if(immunizationController.isDataExist.value == true){
           immunizationController.saveImmunization(PATIENT_ID.value);
         }


        int prescriptionId = await prescriptionBoxCRUDController.savePrescription(boxPrescription,APPOINTMENT_ID.value,
            PrescriptionModel(
              id:0,
              web_id:web_id,
              u_status:statusNewAdd,
              appointment_id:APPOINTMENT_ID.value,
              note: selectedShortAdvice,
              physical_findings: prescriptionDataIn['physical_findings'],
              uuid:uuid,
              cc_text: selectedChiefComplainConverted,
              diagnosis_text: selectedDiagnosisConverted,
              investigation_text: selectedInvestigationAdviceConverted,
              onexam_text: selectedOnExaminationConverted,
              investigation_report_text: selectedInvestigationReportConverted,
              date:date,
              chamber_id: prescriptionPrintPageSetupController.activeChamberId.value.toString(),
              special_notes: specialNotes,
              treatment_plan: treatmentPlan,
              referral_short: referralShort,
            ));

        if(prescriptionId !=-1 && prescriptionId !=0){
          PRESCRIPTION_ID.value = prescriptionId;
          _procedureController.saveProcedureToDb(prescriptionId);
          var isDrugDelete = await prescriptionBoxCRUDController.deleteDrug(boxPrescriptionDrug, boxPrescriptionDrugDose, selectedMedicineList, prescriptionId);
          var deleteProcedure = await prescriptionProcedureCRUDBoxController.deleteProcedure(boxPrescriptionProcedure, prescriptionId);
          if(isDrugDelete == true){
            for(var i =0; i<selectedMedicineList.length; i++){
              // print(selectedMedicineList[i]);
              var brandId = selectedMedicineList[i]['brand_id'] ;
              var companyId = selectedMedicineList[i]['company_id'] ;
              var genericId = selectedMedicineList[i]['generic_id'];
              var strength = selectedMedicineList[i]['strength'];
              var brandName = selectedMedicineList[i]['brand_name'];
              var drugId = await prescriptionBoxCRUDController.savePrescriptionDrug(boxPrescriptionDrug, prescriptionId,
                  PrescriptionDrugModel(
                      id: 0,
                      u_status: DefaultValues.NewAdd,
                      prescription_id: prescriptionId,
                      generic_id: genericId,
                      company_id: companyId,
                      strength: strength,
                      doze: "",
                      duration: "",
                      uuid: uuid,
                      brand_id: brandId,
                      date: date,
                      condition: "",
                     chamber_id: prescriptionPrintPageSetupController.activeChamberId.value.toString(),
                  ));

              if(drugId !=null && drugId !=-1){
                var isDoseDelete = true;
                // var isDoseDelete = await prescriptionBoxCRUDController.deleteDrugDose(boxPrescriptionDrugDose, drugId);
                var doses = selectedMedicineList[i]['dose'];
                if(isDoseDelete == true){
                  for(var j =0; j <doses.length; j++){
                    var doseSerial = j + 1 ;
                    var dose = doses[j];
                    var doze = dose['dose'];
                    var duration = dose['duration'];
                    var condition = dose['instruction'];
                    var note = dose['comment'];
                    var doseId = await prescriptionBoxCRUDController.savePrescriptionDrugDose(boxPrescriptionDrugDose, drugId, doseSerial,
                        PrescriptionDrugDoseModel(
                            id: 0,
                            u_status: DefaultValues.NewAdd,
                            generic_id: 0,
                            doze: doze,
                            duration: duration,
                            note: note,
                            uuid: uuid,
                            drug_id: drugId,
                            condition: condition,
                            dose_serial: doseSerial,
                            prescription_id: prescriptionId,
                           chamber_id: prescriptionPrintPageSetupController.activeChamberId.value.toString(),
                        ));
                    await insertDrugDoseDuration(brandId, doze, duration, condition, note);
                  }
                }
              }
            }
          }
          if(selectedProcedure.isNotEmpty){
              addPrescriptionProcedure(selectedProcedure, prescriptionId);
          }
          // prescriptionList.clear();
          // appointmentList.clear();
          // patientInfo.clear();
          //
          //
          // await getAllPrescriptionData('');
          // await getAllBrandData('');

          // this method use for get prescription data from database and Printing it in prescription screen

          if(isSaveOnly == true){
            Helpers.successSnackBar("Success", "Prescription Saved");
          }else{
            // await getSinglePrescriptionDataForPrintingAndEdit(context: context,PRESCRIPTION_ID: prescriptionId, isPrint: true);
            prescriptionConvertedData['patientId'] = PATIENT_ID.value;
            await prescriptionPrint(context: context,prescriptionConvertedData: prescriptionConvertedData,patientAppointment: responseAppointment,PRESCRIPTION_ID: prescriptionId, isPrint: true, isGpPrint: isGpPrint);
          }


        }
      }

  }

//this method for print prescription instantly from home
  Future<void> prescriptionPrint({context,prescriptionConvertedData,patientAppointment, PRESCRIPTION_ID, isPrint,isGpPrint, isEmail, isSms})async{
          AppointmentModel appointmentInfo = patientAppointment.appointment;
          if(prescriptionConvertedData !=null){
            final List advice = [];

            if(prescriptionConvertedData['shortAdvice'] != null && prescriptionConvertedData['shortAdvice'].isNotEmpty){
              var adviceString = "";
              for(int i=0; i<prescriptionConvertedData['shortAdvice'].length; i++){
                adviceString = adviceString + prescriptionConvertedData['shortAdvice'][i].text.toString() + "\n" + "\n";
              }
              if(adviceString.isNotEmpty){
                advice.addAll(clinicalDataConvertStringToList(adviceString));
              }
            }

            final List selectedMedicineDataColumn2 =  prescriptionConvertedData['selectedMedicine'];
            List<String?> callGynAndObsHistory = await  gynAndObsController.getAllGynHistory(appointmentInfo.patient_id.toString());
            var clinicalDataListMap = [
              {
                "index": 1,
                "isPrinting":true,
                "title": "Chief Complaint",
                "data": prescriptionConvertedData['selectedChiefComplain']
              },
              {
                "index": 1,
                "isPrinting":true,
                "title": "Diagnosis",
                "data": prescriptionConvertedData['selectedDiagnosis']
              },
              {
                "index": 1,
                "isPrinting":true,
                "title": "On Examination",
                "data": prescriptionConvertedData['selectedOnExamination']
              },
              {
                "index": 1,
                "isPrinting":true,
                "title": "Investigation Advice",
                "data": prescriptionConvertedData['selectedInvestigationAdvice']
              },
              {
                "index": 1,
                "isPrinting":true,
                "title": "Investigation Report",
                "data": prescriptionConvertedData['selectedInvestigationReport']
              },{
                "index": 1,
                "isPrinting":true,
                "title": "Gyn and Obs History",
                "data": callGynAndObsHistory.length > 0 ? callGynAndObsHistory : ""
              },
              // {
              //   "index": 1,
              //   "isPrinting":true,
              //   "title": "",
              //   "data": await _glassPrescriptionController.getGlassPressSingle(appointmentInfo.id)
              // },
              {
                "index": 1,
                "isPrinting":true,
                "title": "Treatment Plan",
                "data": prescriptionConvertedData['treatmentPlan']
              },{
                "index": 1,
                "isPrinting":true,
                "title": "Physician Notes",
                "data": prescriptionConvertedData['specialNotes']
              },{
                "index": 1,
                "isPrinting":true,
                "title": "Referred By",
                "data": prescriptionConvertedData['referralShort']
              },
            ];
            List<String>? selectedClinicalDataColumn1 = [];
            selectedClinicalDataColumn1.clear();
            for(int i=0; i<clinicalDataListMap.length; i++){
              if(clinicalDataListMap[i]['isPrinting'] == true){
                if(clinicalDataListMap[i]['data'].toString().isNotEmpty && clinicalDataListMap[i]['data'] !=null){
                  selectedClinicalDataColumn1.add(clinicalDataListMap[i]['title'].toString());
                  if(clinicalDataListMap[i]['title'] != "Gyn and Obs History" && clinicalDataListMap[i]['title'] != "Glass Recommendation"){
                    selectedClinicalDataColumn1.addAll(clinicalDataListMap[i]['data'].toString().split('\n'));
                  }
                  if(clinicalDataListMap[i]['title'] == "Gyn and Obs History"){
                    for(int i = 0; i < callGynAndObsHistory.length; i++){
                      selectedClinicalDataColumn1.add(callGynAndObsHistory[i]!);
                    }
                  }
                  // if(clinicalDataListMap[i]['title'] == "Glass Recommendation"){
                  //   for(var item in clinicalDataListMap[i]['data'].entries){
                  //     if(item.value.toString() != '' && item.key.toString() != 'patientId'){
                  //       selectedClinicalDataColumn1.add(item.key + ": " + item.value.toString());
                  //     }
                  //   }
                  // }
                }
                if(clinicalDataListMap[i]['title'] == "On Examination"){
                  try{

                    if(clinicalDataListMap[i]['data'].toString().isEmpty){
                      if(clinicalDataListMap[i]['data'].toString().isEmpty){
                        if(appointmentInfo.weight != null && appointmentInfo.weight != 0.0){
                          selectedClinicalDataColumn1.add("On Examination");
                        }
                        else if(appointmentInfo.sys_blood_pressure != null && appointmentInfo.dys_blood_pressure != null && appointmentInfo.sys_blood_pressure !=0){
                          selectedClinicalDataColumn1.add("On Examination");
                        }else if(appointmentInfo.pulse != null && appointmentInfo.pulse != 0.0){
                          selectedClinicalDataColumn1.add("On Examination");
                        } else if(appointmentInfo.rr != null && appointmentInfo.rr != 0.0){
                          selectedClinicalDataColumn1.add("On Examination");
                        } else if(appointmentInfo.temparature != null && appointmentInfo.temparature !='' ){
                          selectedClinicalDataColumn1.add("On Examination");
                        } else if(appointmentInfo.height != null && appointmentInfo.height != 0.0){
                          selectedClinicalDataColumn1.add("On Examination");
                        } else if( appointmentInfo.hip != null && appointmentInfo.hip != 0.0){
                          selectedClinicalDataColumn1.add("On Examination");
                        } else if(appointmentInfo.waist != null && appointmentInfo.waist !=0.0){
                          selectedClinicalDataColumn1.add("On Examination");
                        } else if( appointmentInfo.OFC != null && appointmentInfo.OFC != 0.0){
                          selectedClinicalDataColumn1.add("On Examination");
                        }else if(patientAppointment.patient.blood_group !=null && patientAppointment.patient.blood_group !=0 ){
                          selectedClinicalDataColumn1.add("On Examination");
                        }
                      }
                    }
                    if(appointmentInfo.weight != null && appointmentInfo.weight! > 0.0){
                      selectedClinicalDataColumn1.add("Weight: ${appointmentInfo.weight} Kg");
                    }
                    if(appointmentInfo.sys_blood_pressure != null && appointmentInfo.dys_blood_pressure != null && appointmentInfo.sys_blood_pressure! > 0 && appointmentInfo.dys_blood_pressure! > 0){
                      selectedClinicalDataColumn1.add("BP: ${appointmentInfo.sys_blood_pressure} / ${appointmentInfo.dys_blood_pressure} mmHg");
                    }
                    if(appointmentInfo.pulse != null && appointmentInfo.pulse! > 0){
                      selectedClinicalDataColumn1.add("Pulse: ${appointmentInfo.pulse} bpm");
                    }
                    if(appointmentInfo.rr != null && appointmentInfo.rr! > 0){
                      selectedClinicalDataColumn1.add("RR: ${appointmentInfo.rr} b/min");
                    }

                    if(appointmentInfo.temparature != null && appointmentInfo.temparature !=''){
                      if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "TemperatureCelsius")){
                        selectedClinicalDataColumn1.add("Temperature: ${roundString(fahrenheitToCelsius(parseDouble(appointmentInfo.temparature.toString())).toString())} °C");
                      }else{
                        selectedClinicalDataColumn1.add("Temperature: ${appointmentInfo.temparature} °F");
                      }
                    }

                    if(appointmentInfo.height != null && parseDouble(appointmentInfo.height.toString()) > 0.0){
                      if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "Height")){
                        selectedClinicalDataColumn1.add("Height: ${cmToFeetAndInches(parseDouble(appointmentInfo.height.toString()))}");
                      }else if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "HeightMeter")){
                        selectedClinicalDataColumn1.add("Height: ${centimeterToMeter(parseDouble(appointmentInfo.height.toString()))} meter");
                      }else{
                        selectedClinicalDataColumn1.add("Height: ${appointmentInfo.height} cm");
                      }
                    }

                    if(appointmentInfo.hip != null && parseDouble(appointmentInfo.hip.toString()) > 0.0){
                      if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "Hip")){
                        selectedClinicalDataColumn1.add("Hip: ${roundString(cmToInch(parseDouble(appointmentInfo.hip.toString())).toString())} inch");
                      }else{
                        selectedClinicalDataColumn1.add("Hip: ${appointmentInfo.hip.toString()} cm");
                      }
                    }
                    if(appointmentInfo.waist != null && parseDouble(appointmentInfo.waist.toString())> 0.0){
                      if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "Waist")){
                        selectedClinicalDataColumn1.add("Waist: ${roundString(cmToInch(parseDouble(appointmentInfo.waist.toString())).toString())} inch");
                      }else{
                        selectedClinicalDataColumn1.add("Waist: ${appointmentInfo.waist.toString()} cm");
                      }
                    }
                    if(appointmentInfo.OFC != null && parseDouble(appointmentInfo.OFC.toString()) > 0.0){
                      if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "OFC")){
                        selectedClinicalDataColumn1.add("OFC: ${roundString(cmToInches(parseDouble(appointmentInfo.OFC.toString())).toString())} inch");
                      }else{
                        selectedClinicalDataColumn1.add("OFC: ${appointmentInfo.OFC.toString()} cm");
                      }
                    }
                    print("patientAppointment.patient.blood_group");
                    print(patientAppointment.patient.blood_group);
                    if(patientAppointment.patient.blood_group !=null && patientAppointment.patient.blood_group >0){
                      selectedClinicalDataColumn1.add("Blood Group: ${bloodGroupNumToString(patientAppointment.patient.blood_group.toString())}");
                    }

                  }catch(e){}
                }
              }
            }

            var patientHistory = [];
            if(isPrint){
              if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "History")){
                var historyList = await historyController.getSinglePatientHistoryPrint(appointmentInfo.patient_id.toString());
                if(historyList.isNotEmpty){
                  var historyGroupResponse = await historyController.groupDataByCategoryForPrint(historyList);
                  if(historyGroupResponse.isNotEmpty){
                    patientHistory.addAll(historyGroupResponse);
                  }
                }
              }
            }

            if(isPrint == true && isGpPrint == false){

              // Navigator.push(context, MaterialPageRoute(builder: (context) =>PrintPreview(
              //   selectedClinicalDataColumn1 : selectedClinicalDataColumn1,
              //   selectedMedicineDataColumn2:selectedMedicineDataColumn2,
              //   printPatientAndAppointmentInfo: patientAppointment,
              //   advices: advice,
              //   prescriptionSettingData: prescriptionPrintPageSetupController.prescriptionPageSetupData ,
              //   generalSetting: generalSettingController.settingsItemsDataList,
              //   patientHistory: patientHistory,
              // )));
              Navigator.of(context).push(createRoute(PrintPreview(
                selectedClinicalDataColumn1 : selectedClinicalDataColumn1,
                selectedMedicineDataColumn2:selectedMedicineDataColumn2,
                printPatientAndAppointmentInfo: patientAppointment,
                advices: advice,
                prescriptionSettingData: prescriptionPrintPageSetupController.prescriptionPageSetupData ,
                generalSetting: generalSettingController.settingsItemsDataList,
                patientHistory: patientHistory,
              )));
            }
            if(isGpPrint == true){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>GpPrintPreview(
                selectedClinicalDataColumn1 : selectedClinicalDataColumn1,
                selectedMedicineDataColumn2:selectedMedicineDataColumn2,
                printPatientAndAppointmentInfo: patientAppointment,
                advices: advice,
                prescriptionSettingData: prescriptionPrintPageSetupController.prescriptionPageSetupData ,
                generalSetting: generalSettingController.settingsItemsDataList
              )));
            }
            if(isSms == true || isEmail == true){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>PdfEmail(
                  selectedClinicalDataColumn1 : selectedClinicalDataColumn1,
                  selectedMedicineDataColumn2:selectedMedicineDataColumn2,
                  printPatientAndAppointmentInfo: patientAppointment,
                  advices: advice,
                  prescriptionSettingData: prescriptionPrintPageSetupController.prescriptionPageSetupData ,
                  generalSetting: generalSettingController.settingsItemsDataList
              )));
              final pdfFile = await smsPdf(selectedClinicalDataColumn1, selectedMedicineDataColumn2, patientAppointment, advice, prescriptionPrintPageSetupController.prescriptionPageSetupData, generalSettingController.settingsItemsDataList, patientHistory);
              if(await pdfFile.exists()){
                if(isSms == true){
                  await smsController.prescriptionFileUpload(patientAppointment,pdfFile, 'sms');
                }
                if(isEmail == true){
                  await smsController.prescriptionFileUpload(patientAppointment,pdfFile, 'email');
                }

              }

            }



      }
  }

  //this method use for prescription print from list, and edit prescription also send email and sms
  Future<void> getSinglePrescriptionEdit({context, PRESCRIPTION_ID, isPrint, isEmail, isSms})async{

    await getAllPrescriptionData('');
    await getAllBrandData('');

    List prescriptionDrugListEachPrescription = [];
    prescriptionDrugListEachPrescription.clear();

    if(PRESCRIPTION_ID !=0 && PRESCRIPTION_ID != null && PRESCRIPTION_ID != -1){

      if(isPrint == false){
        selectedChiefComplain.clear();
        selectedOnExamination.clear();
        selectedDiagnosis.clear();
        selectedInvestigationAdvice.clear();
        selectedInvestigationReport.clear();
        selectedMedicine.clear();
        selectedShortAdvice.clear();
        selectedFamilyHistory.clear();
        selectedSocialHistory.clear();
        selectedPersonalHistory.clear();
        selectedAllergyHistory.clear();
        selectedPastHistory.clear();
      }


      var prescription =  patientAppPrescriptionJoin.firstWhere((element) => element.prescription.id == PRESCRIPTION_ID, orElse: () => null);

      if(prescription !=null){

        PrescriptionModel prescriptionModel = prescription.prescription;
        AppointmentModel appointmentInfo = prescription.patientAppointment.appointment;
        PatientModel patientInfo = prescription.patientAppointment.patient;

        final int prescriptionId = prescriptionModel.id;
        if(prescriptionId !=-1){
          List drugs = await prescriptionBoxCRUDController.getPrescriptionDrug(boxPrescriptionDrug, prescriptionId);
          if(drugs.isNotEmpty){
            for(var i =0; i<drugs.length; i++){
              var multipleDrugDoseEach = [];
              var drugId = drugs[i].id;
              var brandId = drugs[i].brand_id;
              if(drugId !=-1){
                List doses =  await prescriptionBoxCRUDController.getPrescriptionDrugDose(boxPrescriptionDrugDose,prescriptionId, drugId);
                if(doses.isNotEmpty){
                  for(var j =0; j<doses.length; j++){
                    var doseId = doses[j].id;
                    var dose = doses[j].doze;
                    var duration = doses[j].duration;
                    var condition = doses[j].condition;
                    var note = doses[j].note;
                    var status = doses[j].u_status;
                    var genericId = doses[j].generic_id;
                    var drugDose = {"dose":dose ,"duration":duration,"instruction": condition,"comment": note ?? ""};
                    multipleDrugDoseEach.add(drugDose);
                  }
                }
              }
              var brand = await modifyDrugData.toList().firstWhere((element) => element['brand_id'] == brandId, orElse: () => null);
              print(brand);
              if(brand !=null){
                brand['dose'] = multipleDrugDoseEach;
                prescriptionDrugListEachPrescription.add(brand);
              }
            }
          }


          final List chiefComplain = [];

          if(prescriptionModel.cc_text.toString().isNotEmpty && prescriptionModel.cc_text != null){
            chiefComplain.addAll(clinicalDataConvertStringToList(prescriptionModel.cc_text.toString()));
          }
          final List onExamination= [];
          if(prescriptionModel.onexam_text.toString().isNotEmpty && prescriptionModel.onexam_text != null){
            onExamination.addAll(clinicalDataConvertStringToList(prescriptionModel.onexam_text.toString()));
          }
          final List diagnosis = [];
          if(prescriptionModel.diagnosis_text.toString().isNotEmpty && prescriptionModel.diagnosis_text != null){
            diagnosis.addAll(clinicalDataConvertStringToList(prescriptionModel.diagnosis_text.toString()));
          }
          final List investigationAdvice = [];
          if(prescriptionModel.investigation_text.toString().isNotEmpty && prescriptionModel.investigation_text != null){
            investigationAdvice.addAll(clinicalDataConvertStringToList(prescriptionModel.investigation_text.toString()));
          }
          final List investigationReport = [];
          if(prescriptionModel.investigation_report_text.toString().isNotEmpty && prescriptionModel.investigation_report_text != null){
            investigationReport.addAll(clinicalDataConvertStringToList(prescriptionModel.investigation_report_text.toString()));
          }

          final List treatmentPl = [];
          if(prescriptionModel.treatment_plan.toString().isNotEmpty && prescriptionModel.treatment_plan != null){
            treatmentPl.addAll(clinicalDataConvertStringToList(prescriptionModel.treatment_plan.toString()));
          }

          final List physicianNoteL = [];
          if(prescriptionModel.special_notes.toString().isNotEmpty && prescriptionModel.special_notes != null){
            physicianNoteL.addAll(clinicalDataConvertStringToList(prescriptionModel.special_notes.toString()));
          }
          final List referralShortL = [];
          if(prescriptionModel.referral_short.toString().isNotEmpty && prescriptionModel.referral_short != null){
            referralShortL.addAll(clinicalDataConvertStringToList(prescriptionModel.referral_short.toString()));
          }

          final List advice = [];
          if(prescriptionModel.note != null && prescriptionModel.note.toString().isNotEmpty){
            advice.addAll(clinicalDataConvertStringToList(prescriptionModel.note.toString()));
          }


          final List procedureList = await prescriptionProcedureCRUDBoxController.getPrescriptionProcedure(boxPrescriptionProcedure, prescriptionId);

          if(!isPrint){
            for(int i=0; i<chiefComplain.length; i++){
              if(chiefComplain[i].name.toString().isNotEmpty){
                selectedChiefComplain.add(ChiefComplainModel(id: chiefComplain[i].id, name: chiefComplain[i].name));
              }

            }
            for(int i=0; i<onExamination.length; i++){
              if(onExamination[i].name.toString().isNotEmpty){
                selectedOnExamination.add(OnExaminationModel(id: onExamination[i].id, name: onExamination[i].name));
              }
            }
            for(int i=0; i<diagnosis.length; i++){
              if(diagnosis[i].name.toString().isNotEmpty){
                selectedDiagnosis.add(DiagnosisModal(id: diagnosis[i].id, name: diagnosis[i].name));
              }
            }
            for(int i=0; i<investigationAdvice.length; i++){
              if(investigationAdvice[i].name.toString().isNotEmpty){
                selectedInvestigationAdvice.add(InvestigationModal(id: investigationAdvice[i].id, name: investigationAdvice[i].name));
              }
            }
            for(int i=0; i<investigationReport.length; i++){
              if(investigationReport[i].name.toString().isNotEmpty){
                selectedInvestigationReport.add(InvestigationReportModel(id: investigationReport[i].id, name: investigationReport[i].name));
              }
            }

            for(int i=0; i<advice.length; i++){
              if(advice[i].name.toString().isNotEmpty){
                selectedShortAdvice.add(AdviceModel(id: advice[i].id, label: advice[i].name, text: advice[i].name));
              }
            }
            for(int i=0; i<treatmentPl.length; i++){
              print(treatmentPl[i].name);
              if(treatmentPl[i].name.toString().isNotEmpty){
                treatmentPlan.text = treatmentPlan.text +  treatmentPl[i].name.toString();
                treatmentPlanX.value = treatmentPlanX.value + treatmentPl[i].name.toString();
              }
            }

            for(int i=0; i<physicianNoteL.length; i++){
              if(physicianNoteL[i].name.toString().isNotEmpty){
                specialNotes.text = specialNotes.text +  physicianNoteL[i].name.toString();
                specialNotesX.value = specialNotesX.value + physicianNoteL[i].name.toString();
              }
            }
            for(int i=0; i<referralShortL.length; i++){
              if(referralShortL[i].name.toString().isNotEmpty){
                referralShort.text = referralShort.text +  referralShortL[i].name.toString();
                referralShortX.value = referralShortX.value + referralShortL[i].name.toString();
              }
            }

            historyController.getSinglePatientHistoryX(patientInfo.id);

            selectedMedicine.addAll(prescriptionDrugListEachPrescription);
          }


          //for printing column 2 (medicine data)
          final List<Map<String, dynamic>> selectedMedicineDataColumn2 =  [];

          List presDrugList = prescriptionDrugListEachPrescription;

          for(var i=0; i<presDrugList.length; i++){
            var DoseList = [];
            var brandName = presDrugList[i]['brand_name'].toString();
            var brandId = presDrugList[i]['brand_id'].toString();

            var genericName = presDrugList[i]['genericName'].toString();
            var companyName = presDrugList[i]['companyName'].toString();
            var form = presDrugList[i]['form'].toString();
            var strength = presDrugList[i]['strength'].toString();
            var doses = presDrugList[i]['dose'];

            for(int j=0; j<doses.length; j++){
              print(doses[j]);
              var duration = doses[j]['duration'];
              var instruction = doses[j]['instruction'];

              var comment = doses[j]['comment'];
              var dose = doses[j]['dose'];
              var doseList = {
                'duration': duration,
                'instruction': instruction,
                'comment': comment,
                'dose': dose
              };
              DoseList.add(doseList);
            }
            var drugData = {
              'index': i,
              'brand_name': brandName,
              'brand_id': brandId,
              'form': form,
              'strength': strength,
              'company_name': companyName,
              'company_id': 5,
              'generic_id': 4,
              'generic_name': genericName,
              'dose':
              DoseList
            };
            selectedMedicineDataColumn2.add(drugData);
          };
          // var patientAge = customDateConvertForPrint(patientInformation['dob'] !=null ? patientInformation['dob'] : []);
          // var patientAge = customDateConvertForPrint(patientInformation['dob'] !=null ? patientInformation['dob'] : []);
          var appointmentId = appointmentInfo.id;


          List<String>? selectedClinicalDataColumn1 = [];
          selectedClinicalDataColumn1.clear();


          var bloodGroup = patientInfo.blood_group;


          if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "chiefComplain")){
            List<String> ccList = clinicalDataIterationForPrinting(chiefComplain,"Chief Complaint");
            if(ccList.isNotEmpty){
              selectedClinicalDataColumn1.addAll(ccList);
            }
          }

          if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "Examination")){
            List<String> oEList = clinicalDataIterationForPrinting(onExamination, "On Examination");

            if(oEList.isNotEmpty){
              selectedClinicalDataColumn1.addAll(oEList);
            }

            if(onExamination.isEmpty){
              if(appointmentInfo.weight != null && appointmentInfo.weight != 0.0){
                selectedClinicalDataColumn1.add("On Examination");
              }
              else if(appointmentInfo.sys_blood_pressure != null && appointmentInfo.dys_blood_pressure != null && appointmentInfo.sys_blood_pressure !=0){
                selectedClinicalDataColumn1.add("On Examination");
              }else if(appointmentInfo.pulse != null && appointmentInfo.pulse != 0.0){
                selectedClinicalDataColumn1.add("On Examination");
              } else if(appointmentInfo.rr != null && appointmentInfo.rr != 0.0){
                selectedClinicalDataColumn1.add("On Examination");
              } else if(appointmentInfo.temparature != null && appointmentInfo.temparature !='' ){
                selectedClinicalDataColumn1.add("On Examination");
              } else if(appointmentInfo.height != null && appointmentInfo.height != 0.0){
                selectedClinicalDataColumn1.add("On Examination");
              } else if( appointmentInfo.hip != null && appointmentInfo.hip != 0.0){
                selectedClinicalDataColumn1.add("On Examination");
              } else if(appointmentInfo.waist != null && appointmentInfo.waist !=0.0){
                selectedClinicalDataColumn1.add("On Examination");
              } else if( appointmentInfo.OFC != null && appointmentInfo.OFC != 0.0){
                selectedClinicalDataColumn1.add("On Examination");
              }else if(bloodGroup !=null && bloodGroup !=0 ){
                selectedClinicalDataColumn1.add("On Examination");
              }
            }


            if(appointmentInfo.weight != null && appointmentInfo.weight! > 0.0){
              selectedClinicalDataColumn1.add("Weight: ${appointmentInfo.weight} Kg");
            }
            if(appointmentInfo.sys_blood_pressure != null && appointmentInfo.dys_blood_pressure != null && appointmentInfo.sys_blood_pressure! > 0 && appointmentInfo.dys_blood_pressure! > 0){
              selectedClinicalDataColumn1.add("BP: ${appointmentInfo.sys_blood_pressure} / ${appointmentInfo.dys_blood_pressure} mmHg");
            }
            if(appointmentInfo.pulse != null && appointmentInfo.pulse! > 0){
              selectedClinicalDataColumn1.add("Pulse: ${appointmentInfo.pulse} bpm");
            }
            if(appointmentInfo.rr != null && appointmentInfo.rr! > 0){
              selectedClinicalDataColumn1.add("RR: ${appointmentInfo.rr} b/min");
            }

            if(appointmentInfo.temparature != null && appointmentInfo.temparature !=''){
              if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "TemperatureCelsius")){
                selectedClinicalDataColumn1.add("Temperature: ${roundString(fahrenheitToCelsius(parseDouble(appointmentInfo.temparature.toString())).toString())} °C");
              }else{
                selectedClinicalDataColumn1.add("Temperature: ${appointmentInfo.temparature} °F");
              }
            }

            if(appointmentInfo.height != null && parseDouble(appointmentInfo.height.toString()) > 0.0){
              if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "Height")){
                selectedClinicalDataColumn1.add("Height: ${cmToFeetAndInches(parseDouble(appointmentInfo.height.toString()))}");
              }else if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "HeightMeter")){
                selectedClinicalDataColumn1.add("Height: ${centimeterToMeter(parseDouble(appointmentInfo.height.toString()))} meter");
              }else{
                selectedClinicalDataColumn1.add("Height: ${appointmentInfo.height} cm");
              }
            }

            if(appointmentInfo.hip != null && parseDouble(appointmentInfo.hip.toString()) > 0.0){
              if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "Hip")){
                selectedClinicalDataColumn1.add("Hip: ${roundString(cmToInch(parseDouble(appointmentInfo.hip.toString())).toString())} inch");
              }else{
                selectedClinicalDataColumn1.add("Hip: ${appointmentInfo.hip.toString()} cm");
              }
            }
            if(appointmentInfo.waist != null && parseDouble(appointmentInfo.waist.toString())> 0.0){
              if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "Waist")){
                selectedClinicalDataColumn1.add("Waist: ${roundString(cmToInch(parseDouble(appointmentInfo.waist.toString())).toString())} inch");
              }else{
                selectedClinicalDataColumn1.add("Waist: ${appointmentInfo.waist.toString()} cm");
              }
            }
            if(appointmentInfo.OFC != null && parseDouble(appointmentInfo.OFC.toString()) > 0.0){
              if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "OFC")){
                selectedClinicalDataColumn1.add("OFC: ${roundString(cmToInches(parseDouble(appointmentInfo.OFC.toString())).toString())} inch");
              }else{
                selectedClinicalDataColumn1.add("OFC: ${appointmentInfo.OFC.toString()} cm");
              }

            }
            if(bloodGroup !=null && bloodGroup >0 && bloodGroup <9){
              selectedClinicalDataColumn1.add("Blood Group: ${bloodGroupNumToString(bloodGroup.toString())}");
            }

          }


          if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "Diagnosis")){
            List<String> diagnosisList = clinicalDataIterationForPrinting(diagnosis, "Diagnosis");
            if(diagnosisList.isNotEmpty){
              selectedClinicalDataColumn1.addAll(diagnosisList);
            }
          }
          if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "InvestigationAdvice")){
            List<String> inAdvice = clinicalDataIterationForPrinting(investigationAdvice, "Investigation Advice");
            if(inAdvice.isNotEmpty){
              selectedClinicalDataColumn1.addAll(inAdvice);
            }
          }

          if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "InvestigationReport")){
            List<String> invReport = clinicalDataIterationForPrinting(investigationReport, "Investigation Report");
            if(invReport.isNotEmpty){
              selectedClinicalDataColumn1.addAll(invReport);
            }
          }
          List<String?> callGynAndObsHistory = await  gynAndObsController.getAllGynHistory(patientInfo.id);
          if(callGynAndObsHistory.length > 0){
            selectedClinicalDataColumn1.add("Gyn and Obs History");
            for(int i = 0; i < callGynAndObsHistory.length; i++){
              selectedClinicalDataColumn1.add(callGynAndObsHistory[i]!);
            }
          }

          var specialNotesZ = prescriptionModel.special_notes;
          var treatmentPlans = prescriptionModel.treatment_plan;
          var referralShortZ = prescriptionModel.referral_short;

          if(specialNotesZ != null && specialNotesZ.isNotEmpty ){
            if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "PhysicianNotes")){
              List<String> specialNote =  ['Physician Notes', specialNotesZ];
              if(specialNotesZ.isNotEmpty){
                selectedClinicalDataColumn1.addAll(specialNote);
              }
            }
          }
          if(referralShortZ != null && referralShortZ.isNotEmpty ){
            if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "ReferralShort")){
              List<String> referralShort =  ['Referred By', referralShortZ];
              if(referralShortZ.isNotEmpty){
                selectedClinicalDataColumn1.addAll(referralShort);
              }
            }
          }
          if(treatmentPlans != null && treatmentPlans.isNotEmpty ){
            if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "TreatmentPlan")){
              List<String> treatmentPlan =  ['Treatment Plan', treatmentPlans];
              if(treatmentPlans.isNotEmpty){
                selectedClinicalDataColumn1.addAll(treatmentPlan);
              }
            }
          }
          var glassData =await _glassPrescriptionController.getGlassPressSingle(appointmentId);
          if(glassData != null){
            selectedClinicalDataColumn1.add("Glass Recommendation");
            for(var item in glassData.entries){
              if(item.value.toString() != '' && item.key.toString() != 'patientId'){
                selectedClinicalDataColumn1.add(item.key + ": " + item.value.toString());
              }
            }
          }

          // if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "DiseaseActivity")){
          //   List<String> invReport = clinicalDataIterationForPrinting(investigationReport, "Disease Activity Score");
          //   if(invReport.isNotEmpty){
          //     selectedClinicalDataColumn1.addAll(invReport);
          //   }
          // }

          var patientHistory = [];
          if(isPrint){
            if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.print && element['label'] == "History")){
              var historyList = await historyController.getSinglePatientHistoryPrint(patientInfo.id);
              if(historyList.isNotEmpty){
                var historyGroupResponse = await historyController.groupDataByCategoryForPrint(historyList);
                if(historyGroupResponse.isNotEmpty){
                  patientHistory.addAll(historyGroupResponse);
                }
              }
            }
          }


          // printPdf(selectedClinicalDataColumn1,printMedicine,printPatientAndAppointmentInfo,advices,FooterImage,HeaderImage,isHeaderFooterActive, prescriptionSettingData);
          if(prescriptionPrintPageSetupController.prescriptionPageSetupData.isEmpty){
            prescriptionPrintPageSetupController.defaultPrescriptionPrintSetup();
          }


            if(isPrint == true){
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) =>PrintPreview(
                selectedClinicalDataColumn1 : selectedClinicalDataColumn1,
                selectedMedicineDataColumn2:selectedMedicineDataColumn2,
                printPatientAndAppointmentInfo: prescription.patientAppointment,
                advices: advice,
                prescriptionSettingData: prescriptionPrintPageSetupController.prescriptionPageSetupData ,
                generalSetting: generalSettingController.settingsItemsDataList,
                patientHistory: patientHistory,
              )));
            }



          if(isSms == true || isEmail == true){
            // Navigator.push(context, MaterialPageRoute(builder: (context) =>PdfEmail(
            //     selectedClinicalDataColumn1 : selectedClinicalDataColumn1,
            //     selectedMedicineDataColumn2:selectedMedicineDataColumn2,
            //     printPatientAndAppointmentInfo: prescription.patientAppointment,
            //     advices: advice,
            //     prescriptionSettingData: prescriptionPrintPageSetupController.prescriptionPageSetupData ,
            //     generalSetting: generalSettingController.settingsItemsDataList
            // )));
            print(selectedMedicineDataColumn2);
            final pdfFile = await smsPdf(selectedClinicalDataColumn1, selectedMedicineDataColumn2, prescription.patientAppointment, advice, prescriptionPrintPageSetupController.prescriptionPageSetupData, generalSettingController.settingsItemsDataList, patientHistory);
            if(await pdfFile.exists()){
              if(isSms == true){
                await smsController.prescriptionFileUpload(prescription.patientAppointment,pdfFile, 'sms');
              }
              if(isEmail == true){
                await smsController.prescriptionFileUpload(prescription.patientAppointment,pdfFile, 'email');
              }

            }

          }

        }

      }

    }
  }


  // get single template data with set to prescription
  Future<void>getSingleTemplateData(templateId)async{

    List? responseTemplateData = await prescriptionTemplateController.getSinglePrescriptionTemplateData(modifyDrugData, templateId);
    if(responseTemplateData !=null && responseTemplateData.isNotEmpty){

        for(int i=0; i<responseTemplateData[0]['chiefComplains'].length; i++){
          if(responseTemplateData[0]['chiefComplains'][i].name.toString().isNotEmpty){
            selectedChiefComplain.add(ChiefComplainModel(id: responseTemplateData[0]['chiefComplains'][i].id, name: responseTemplateData[0]['chiefComplains'][i].name));
          }

        }
        for(int i=0; i<responseTemplateData[0]['onExaminations'].length; i++){
          if(responseTemplateData[0]['onExaminations'][i].name.toString().isNotEmpty){
            selectedOnExamination.add(OnExaminationModel(id: responseTemplateData[0]['onExaminations'][i].id, name: responseTemplateData[0]['onExaminations'][i].name));
          }
        }
        for(int i=0; i<responseTemplateData[0]['diagnosis'].length; i++){
          if(responseTemplateData[0]['diagnosis'][i].name.toString().isNotEmpty){
            selectedDiagnosis.add(DiagnosisModal(id: responseTemplateData[0]['diagnosis'][i].id, name: responseTemplateData[0]['diagnosis'][i].name));
          }
        }
        for(int i=0; i<responseTemplateData[0]['investigationAdvices'].length; i++){
          if(responseTemplateData[0]['investigationAdvices'][i].name.toString().isNotEmpty){
            selectedInvestigationAdvice.add(InvestigationModal(id: responseTemplateData[0]['investigationAdvices'][i].id, name: responseTemplateData[0]['investigationAdvices'][i].name));
          }
        }
        for(int i=0; i<responseTemplateData[0]['note'].length ; i++){
          if(responseTemplateData[0]['note'][i].name.toString().isNotEmpty){
            selectedShortAdvice.add(AdviceModel(id: responseTemplateData[0]['note'][i].id, label: responseTemplateData[0]['note'][i].name, text: responseTemplateData[0]['note'][i].name));
          }

        }
        // for(int i=0; i<investigationReport.length; i++){
        //   if(investigationReport[i].name.toString().isNotEmpty){
        //     selectedInvestigationReport.add(InvestigationReportModel(id: chiefComplain[i].id, name: chiefComplain[i].name));
        //   }
        // }
        // for(int i=0; i<procedureList.length; i++){
        //   if(procedureList[i].name.toString().isNotEmpty){
        //     selectedProcedure.add(ProcedureModel(id: chiefComplain[i].id, name: chiefComplain[i].name));
        //   }
        // }


      selectedMedicine.addAll(responseTemplateData[0]['selectedMedicine']);
      // selectedChiefComplain.addAll(responseTemplateData[0]['chiefComplains']);
      // selectedOnExamination.addAll(responseTemplateData[0]['onExaminations']);
      // selectedDiagnosis.addAll(responseTemplateData[0]['diagnosis']);
      // selectedInvestigationAdvice.addAll(responseTemplateData[0]['investigationAdvices']);
    }else{
      print("Template data empty");
    }
  }



  // this method use for delete prescription
  Future<void> deleteData(id)async{
    try {
      await commonController.deleteCommon(boxPrescription, id, statusDelete);
      //called get prescription list
      getAllPrescriptionData('');
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting data: $e");
      }
    }
    // isLoading = false;
  }


  Future<void> getAllPrescriptionData(searchText)async{
    isLoading.value = true;
    var res = await boxPrescription.values.toList().obs;
    var appointmentController = Get.put(AppointmentController());
    await appointmentController.getAllData(searchText);
    if(res.isNotEmpty){
      patientAppPrescriptionJoin.clear();
      for(var prescription in res){
        var patientAppointment = appointmentController.patientAppointmentList.firstWhere((element) => element.appointment.id == prescription.appointment_id, orElse: ()=> null);
        if(patientAppointment != null){
          patientAppPrescriptionJoin.add(PatientAppointmentPrescriptionModel(
              patientAppointment: patientAppointment,
              prescription: prescription
          ));
        }
      }
      patientAppPrescriptionJoin.sort((a, b) => b.prescription.id.compareTo(a.prescription.id));
    }
    isLoading.value = false;
  }

  // get brand (medicine) from database
  Future getAllBrandData(String searchText)async{

    var companyList  = companyNameController.dataList;
    var genericList  = genericController.dataList;
    var response = await brandCrudController.getAllDataBrand(brandBox, searchText);
   if(response != null){
     modifyDrugData.clear();
     var favList = favoriteIndexController.favoriteIndexDataList.where((element) => element.segment == FavSegment.brand).toList().map((e) => e.favorite_id).toList() ?? []; // Provide an empty list if it's null
     List favoriteItems = response.where((item) => favList.contains(item.id)).toList();
     List nonFavoriteItems = response.where((item) => !favList.contains(item.id)).toList();
     favoriteItems.sort((a, b) => a.brand_name.compareTo(b.brand_name));
     RxList sortedList = [...favoriteItems, ...nonFavoriteItems].obs;
       for(var i =0; i<sortedList.length; i++){
         var brandCompanyId = sortedList[i].company_id;
         var brandGenericId = sortedList[i].generic_id;
         var company = companyList.firstWhere((element) => element.id == brandCompanyId, orElse: () => null);
         var generic = genericList.firstWhere((element) => element.id == brandGenericId, orElse: () => null);
         if(company !=null && generic !=null && sortedList[i].brand_name !=null){
           var companyName =company.company_name;
           var genericName = generic.generic_name;
           var brandName   = sortedList[i].brand_name;
           var brandId     = sortedList[i].id;
           var dosesForm   = sortedList[i].form;
           var strength    = sortedList[i].strength;
           // var useBrandIndex = boxPrescriptionDrug.values.toList().lastIndexWhere((element) => element.brand_id == brandId);
           var defaultDoseDurationInstruction =await drugBrandController.getDefaultDrugDoseDuration(brandId);
           var doseShortForm = await doseController.getDosesFormShort(dosesForm.toString());
           if(defaultDoseDurationInstruction !=null){
             insertMissingDoseDurations(defaultDoseDurationInstruction);
             var  brandInfo = {
               "brand_name"  : brandName,
               "brand_id"      : brandId,
               "form"         : dosesForm,
               "sortForm"       : doseShortForm ?? '',
               "strength"    : strength,
               "company_name": companyName,
               "company_id":brandCompanyId,
               "generic_id":brandGenericId,
               "generic_name":genericName,
               "dose": [
                 {"dose":defaultDoseDurationInstruction['dose'],"duration":defaultDoseDurationInstruction['duration'],"instruction":defaultDoseDurationInstruction['instruction'],"comment":defaultDoseDurationInstruction['notes']}
               ]
             };
             modifyDrugData.add(brandInfo);
           }else{
             var usesDoseDurationAndInstruction = await getLastDrugDoseDuration(brandId);
             if (usesDoseDurationAndInstruction != null) {
               // var usedBrandDose = boxPrescriptionDrugDose.values.toList()[boxPrescriptionDrug.values.toList()[useBrandIndex].id] ;
               insertMissingDoseDurations(usesDoseDurationAndInstruction);
               var  brandInfo = {
                 "brand_name"  : brandName,
                 "brand_id"      : brandId,
                 "form"         : dosesForm,
                 "sortForm"     : doseShortForm ?? '',
                 "strength"    : strength,
                 "company_name": companyName,
                 "company_id":brandCompanyId,
                 "generic_id":brandGenericId,
                 "generic_name":genericName,
                 "dose": [
                   {"dose":usesDoseDurationAndInstruction['dose'],"duration":usesDoseDurationAndInstruction['duration'],"instruction":usesDoseDurationAndInstruction['instruction'],"comment":usesDoseDurationAndInstruction['notes']}
                 ]

               };
               modifyDrugData.add(brandInfo);
             }else{
               var  brandInfo = {
                 "brand_name"  : brandName,
                 "brand_id"      : brandId,
                 "form"         : dosesForm,
                 "strength"    : strength,
                 "company_name": companyName,
                 "company_id":brandCompanyId,
                 "generic_id":brandGenericId,
                 "generic_name":genericName,
                 "dose": [
                   {"dose":"","duration":"","instruction":"","comment":""},
                 ]
               };
               modifyDrugData.add(brandInfo);
             }
           }



         }
       }
     modifyDrugData.sort((a, b) => a['brand_name'].compareTo(b['brand_name']));
       if(Platform.isAndroid && searchText.isEmpty){
         favoriteListFunction();
       }
       if(!Platform.isAndroid){
         favoriteDrugList.clear();
         await favoriteListFunction();
       }

     }

  }

  //search by brand name, company & generic
   drugBrandSearch(String searchText) {
    if (searchText.isNotEmpty) {
      modifyDrugData.clear(); // Clear before starting the search
      for (var i = 0; i < modifyDrugDataForSearch.length; i++) {
        var item = modifyDrugDataForSearch[i];
        if (item['brand_name'].toLowerCase().startsWith(searchText.toLowerCase()) || item['generic_name'].toLowerCase().startsWith(searchText.toLowerCase()) || item['company_name'].toLowerCase().startsWith(searchText.toLowerCase())) {
           var isExist = modifyDrugData.indexWhere((element) => element['brand_id'] == item['brand_id'] );
           if(isExist == -1){
             modifyDrugData.add(item);
           }
        }
      }
    } else {
      modifyDrugData.clear();
    }
  }

// appointment clinical data
 Future getAppClinicalData(additionalData)async{

  var data = additionalData;
  var oe = data['onExamination'] == null ? '' : data['onExamination'].toString();
  if(oe.isNotEmpty){
    var oeList = clinicalDataConvertStringToList(oe);
    for (int i = 0; i < oeList.length; i++) {
      if (oeList[i].name.toString().isNotEmpty) {
        selectedOnExamination.add(OnExaminationModel(id: 12, name: oeList[i].name));
      }

    }
  }


  var cc = data['chiefComplain'] == null ? '' : data['chiefComplain'].toString();
  if(cc.isNotEmpty){
    var ccList = clinicalDataConvertStringToList(cc);
    selectedChiefComplain.clear();
    for(int i=0; i<ccList.length; i++){
      if(ccList[i].name.toString().isNotEmpty){
        selectedChiefComplain.add(ChiefComplainModel(id: ccList[i].id, name: ccList[i].name));
      }
    }
  }
  var dx = data['diagnosis'] == null ? '' : data['diagnosis'].toString();
  if(dx.isNotEmpty){
    var dxList = clinicalDataConvertStringToList(dx);
    selectedDiagnosis.clear();
    for(int i=0; i<dxList.length; i++){
      if(dxList[i].name.toString().isNotEmpty){
        selectedDiagnosis.add(DiagnosisModal(id: dxList[i].id, name: dxList[i].name));
      }
    }
  }
  var ia = data['investigationAdvice'] == null ? '' : data['investigationAdvice'].toString();
  if(ia.isNotEmpty){
    var iaList = clinicalDataConvertStringToList(ia);
    selectedInvestigationAdvice.clear();
    for(int i=0; i<iaList.length; i++){
      if(iaList[i].name.toString().isNotEmpty){
        selectedInvestigationAdvice.add(InvestigationModal(id: iaList[i].id, name: iaList[i].name));
      }
    }
  }
  var ir = data['investigationReport'] == null ? '' : data['investigationReport'].toString();
  if(ir.isNotEmpty){
    var irList = clinicalDataConvertStringToList(ir);
    selectedInvestigationReport.clear();
    for(int i=0; i<irList.length; i++){
      if(irList[i].name.toString().isNotEmpty){
        selectedInvestigationReport.add(InvestigationModal(id: irList[i].id, name: irList[i].name));
      }
    }
  }
  var paHistory = data['history'] == null ? '' : data['history'].toString();
  if(paHistory.isNotEmpty){

    var paHistoryList = clinicalDataConvertStringToList(paHistory);
    historyController.selectedHistory.clear();
    for(int i=0; i<paHistoryList.length; i++){
      if(paHistoryList[i].name.toString().isNotEmpty){
        historyController.selectedHistory.add(HistoryModel(id: 7, name: paHistoryList[i].name, uuid: '', category: '', type: ''));
      }
    }
    historyController.groupDataByCategory();
  }
}


    insertMissingDoseDurations(usesDoseDurationAndInstruction)async{

    DoseController doseController = Get.put(DoseController());
    DurationController durationController = Get.put(DurationController());
    InstructionController instructionController = Get.put(InstructionController());

    if(usesDoseDurationAndInstruction['dose'] != null || usesDoseDurationAndInstruction['dose'] != ''){
      var isDoseExist =await doseController.box.values.toList().indexWhere((data) => data.name.toString().trim() == usesDoseDurationAndInstruction['dose'].toString().trim());
      if(isDoseExist == -1){
        doseController.nameController.text = usesDoseDurationAndInstruction['dose'];
        doseController.addData(doseController.dataList.length + 1);
      }
    }


    // if(usesDoseDurationAndInstruction['duration'] == null || usesDoseDurationAndInstruction['duration'] == ''){
    //   var exist =await durationController.dataList.any((element) => element.name == usesDoseDurationAndInstruction['duration']);
    //   if(!exist){
    //     durationController.nameController.text = usesDoseDurationAndInstruction['duration'];
    //     durationController.addData(durationController.dataList.length + 1);
    //   }
    // }
    //
    // if(usesDoseDurationAndInstruction['instruction'] == null || usesDoseDurationAndInstruction['instruction'] == ''){
    //   var exist =await instructionController.dataList.any((element) => element.name == usesDoseDurationAndInstruction['instruction']);
    //   if(!exist){
    //     instructionController.nameController.text = usesDoseDurationAndInstruction['instruction'];
    //     instructionController.addData(instructionController.dataList.length + 1);
    //   }
    // }

  }

  // append dose value into modifyDrug list
  void onChangeDoseAdd(drugId,index,key,value)async{


    var isExistModify =await modifyDrugData.indexWhere((element) => element['brand_id'] == drugId);
    var isExistFavorite =await favoriteDrugList.indexWhere((element) => element['brand_id'] == drugId);
    var isExistSelected =await selectedMedicine.indexWhere((element) => element['brand_id'] == drugId);

    if(Platform.isAndroid){

        if(brandSearchText.value == ''){
          if(isExistSelected !=-1){
            selectedMedicine[isExistSelected]['dose'][index][key] = value;
          }else{
            favoriteDrugList[isExistFavorite]['dose'][index][key] = value;
          }
          favoriteDrugList.refresh();
          selectedMedicine.refresh();
        }else{
          if(isExistSelected !=-1){
            selectedMedicine[isExistSelected]['dose'][index][key] = value;
          }else if(isExistModify !=-1){
            modifyDrugData[isExistModify]['dose'][index][key] = value;
          }
          selectedMedicine.refresh();
          modifyDrugData.refresh();
        }
    }else{
      if(isExistSelected !=-1){
        selectedMedicine[isExistSelected]['dose'][index][key] = value;
      }else if(isExistModify !=-1){
        modifyDrugData[isExistModify]['dose'][index][key] = value;
      }else if(isExistFavorite !=-1){
        favoriteDrugList[isExistFavorite]['dose'][index][key] = value;
      }
    }

    var drugIndex = modifyDrugData.indexWhere((element) => element['brand_id'] == drugId);
    var selectedDrugDose = selectedMedicine.indexWhere((element) => element['brand_id'] == drugId);
    if(drugIndex !=-1){
      modifyDrugData[drugIndex]['dose'][index][key] = value;
      modifyDrugData.refresh();
      favoriteDrugList.refresh();
    }
    if(selectedDrugDose !=-1){
      selectedMedicine[selectedDrugDose]['dose'][index][key] = value;
      selectedMedicine.refresh();
      favoriteDrugList.refresh();
    }

  }

  // for multiple dose field
  void addMoreDose(drugId){
    var drugIndex = modifyDrugData.indexWhere((element) => element['brand_id'] == drugId);
    var selectedDrugDose = selectedMedicine.indexWhere((element) => element['brand_id'] == drugId);
    var favorite = favoriteDrugList.indexWhere((element) => element['brand_id'] == drugId);

    if(selectedDrugDose !=-1){
      var addNewS = {"dose":"", "duration":"", "instruction":"", "comment":""};
      selectedMedicine[selectedDrugDose]['dose'].add(addNewS);
    }
    if(drugIndex !=-1){
      var addNew = {"dose":"", "duration":"", "instruction":"", "comment":""};
      modifyDrugData[drugIndex]['dose'].add(addNew);
    }
    if(favorite !=-1 && brandSearchText.value == ''){
      var addNewF = {"dose":"", "duration":"", "instruction":"", "comment":""};
      favoriteDrugList[favorite]['dose'].add(addNewF);
    }
    modifyDrugData.refresh();
    selectedMedicine.refresh();
    favoriteDrugList.refresh();

  }

  //save medicine to prescription
   Future<bool?> onSelectedMedicine(object, changeType) async{

    var existingBrand = await selectedMedicine.firstWhere((element) => element['generic_id'] == object['generic_id'], orElse: () => null);
      var dose = object['dose'];
      object['index'] = selectedMedicine.length;
     if(changeType == 'addNew'){
       for(var j=0; j <dose.length; j++){
         var dose = object['dose'][j];
         if(dose['dose'].isNotEmpty && dose['duration'].isNotEmpty){
             selectedMedicine.add(object);
           if(j ==0){
             Helpers.successSnackBar("Success!", "Brand added to prescription");
           }
           return true;
         } else{
           if(j ==0){
             Helpers.errorSnackBar("Failed!", "Field Must be not empty");
             return false;
           }
         }
       }
     }else if(existingBrand != null && changeType == "editBrandId"){
       for(var j=0; j <dose.length; j++){
         var dose = object['dose'][j];
         var existingIndex = await selectedMedicine.indexWhere((element) => element['brand_id'] == object['brand_id']);
         if(dose['dose'].isNotEmpty && dose['duration'].isNotEmpty){
           if(existingIndex !=-1){
             selectedMedicine[existingIndex] = object;
           }else{
             selectedMedicine.add(object);
           }
           if(j ==0){
             Helpers.successSnackBar("Success!", "Brand added to prescription");
           }
           return true;
         } else{
           if(j ==0){
             Helpers.errorSnackBar("Failed!", "Field Must be not empty");
             return false;
           }
         }
       }
     } else if(existingBrand !=null && changeType == "changeBrand"){
      var existingIndex =await selectedMedicine.indexWhere((element) => element['generic_id'] == object['generic_id']);
      object['dose'] = existingBrand['dose'];
      selectedMedicine[existingIndex] = object;
      Helpers.successSnackBar("Success!", "Brand changed to prescription");
      return true;
    }else if(existingBrand !=null && changeType == "changeCompany") {
       var existingIndex =await selectedMedicine.indexWhere((
           element) => element['generic_id'] == object['generic_id']);
       object['dose'] = existingBrand['dose'];
       selectedMedicine[existingIndex] = object;
       Helpers.successSnackBar("Success!", "Company changed to prescription");
       return true;
     }

    selectedMedicine.refresh();
    modifyDrugData.refresh();

    return null;

  }

  getOEFindingFromApp(field, value){
    if(field == "weight" && value !=null && value.toString().isNotEmpty){
      selectedOnExaminationApp.add({"field":field, "value":value});
      print(selectedOnExamination.length);
      selectedOnExamination.refresh();
    }
  }

  //prescription procedure section----------------------------------

  //save prescription  procedure data to database, this function called from addData function
  Future<void> addPrescriptionProcedure(selectedProcedure, PRESCRIPTIONID)async{
    try{
      for(var i=0; i<selectedProcedure.length; i++){
        var data = selectedProcedure[i];
        await prescriptionProcedureCRUDBoxController.savePrescriptionProcedure(boxPrescriptionProcedure, PRESCRIPTIONID, PrescriptionProcedureModel(
          id: 0,
          u_status: statusNewAdd,
          prescription_id: PRESCRIPTIONID,
          procedure_id: data['id'],
          diagnosis: data['diagnosis'],
          anesthesia: data['anesthesia'],
          incision: data['incision'],
          surgeon: data['surgeon'],
          uuid: uuid,
          assistant: data['assistant'],
          details: data['details'],
          prosthesis: data['prosthesis'],
          closer: data['closer'],
          findings: data['findings'],
          complications: data['complications'],
          drains: data['drains'],
          post_operative_instructions: data['post_operative_instructions'],
        ));
      }
    }catch(e){
      print('$e');
    }

  }
  //prescription procedure section----------------------------------



 void clearText()async{
    prescriptionList.clear();
    searchController.clear();
    await getAllPrescriptionData('');
  }
  searchByGeneric(genericID)async{
    var searchedData = [];
    searchedData.clear();
    for(var i=0; i<modifyDrugData.length; i++){
      var data = modifyDrugData[i];
      if(genericID == data['generic_id']){
        searchedData.add(data);
      }
    }
    print(searchedData.length);
    modifyDrugData.clear();
    modifyDrugData.addAll(searchedData);
    modifyDrugData.refresh();
  }
  searchByCompany(companyID)async{
    var searchedData = [];
    searchedData.clear();
    for(var i=0; i<modifyDrugData.length; i++){
      var data = modifyDrugData[i];
      if(companyID == data['company_id']){
        searchedData.add(data);
      }
    }
    modifyDrugData.clear();
    modifyDrugData.addAll(searchedData);
    modifyDrugData.refresh();
  }

  Future<void> insertDrugDoseDuration(brandId,Dose,Duration,Instruction,Notes)async{

    var jsonDrugDose = {
        "brand_id": brandId,
        "dose": Dose,
        "duration": Duration,
        "instruction": Instruction,
        "notes": Notes
    };
    var jsonLastDrugDose = jsonEncode(jsonDrugDose);
    final jsonILastDrugDoseJsonMAp = jsonDecode(jsonLastDrugDose) as Map<String, dynamic>;
    var response = await boxLastDrugDoseDuration.put('$brandId', jsonILastDrugDoseJsonMAp);

  }
    getLastDrugDoseDuration(brandId)async{
    var response = await boxLastDrugDoseDuration.get('$brandId');
     return response;
  }
  Future <void> usesClinicalData() async {
    if(prescriptionList.isNotEmpty){
      for (var i = 0; i < 20; i++) {
        if (prescriptionList[i].investigation_text.isNotEmpty &&
            prescriptionList[i].investigation_text != null) {
          List<String> invList = prescriptionList[i].investigation_text.toString().split(RegExp(r"\n"));
          for(var j = 0; j < invList.length; j++){
            if (!usesInvestigationAdvice.contains(invList[j])) {
              usesInvestigationAdvice.add(invList[j]);
            }
          }
          // var exist = usesInvestigationAdvice.contains(prescriptionList[i].investigation_text.toString().split(RegExp(r"\n")));
          // if (!exist) {
          //   usesInvestigationAdvice.add(prescriptionList[i].investigation_text.toString().split(RegExp(r"\n")));
          //   // print(prescriptionList[i].investigation_text.toString().split("\n"));
          // }
        }
      }
    }

  }

  @override
  void onInit() {
    getAllPrescriptionData('');
    getAllBrandData('');
    super.onInit();
  }

  @override
  void dispose() {
    prescriptionList;
    // boxPatient.close();
    // brandBox.close();
    // boxAppointment.close();
    // boxPrescription.close();
    // boxPrescriptionDrug.close();
    // boxPrescriptionDrugDose.close();
    // boxPrescriptionProcedure.close();
    // boxPrescriptionTemplate.close();
    // boxPrescriptionTemplateDrug.close();
    // boxPrescriptionTemplateDrugDose.close();
    favoriteIndexController;
    _procedureController;
    patientCRUDController;
    patientDiseaseImageController;
    investigationReportImageController;
    historyController;
    companyNameController;
    genericController;
    brandCrudController;
    prescriptionBoxCRUDController;
    prescriptionProcedureCRUDBoxController;
    prescriptionTemplateBoxCRUDController;
    prescriptionTemplateController;
    generalSettingController;
    appointmentBoxController;
    commonController;
    prescriptionPrintPageSetupController;
    PrescriptionSettings;
    prescriptionList;
    appointmentList;
    patientInfo;
    patientAndAppointmentInfoJoin;
    brandList;
    modifyDrugData;
    modifyDrugDataForSearch;
    favoriteDrugList;
    selectedMedicine;
    selectedChiefComplain;
    selectedChiefComplainString;
    selectedOnExamination;
    selectedOnExaminationApp;
    selectedOnExaminationString;
    selectedDiagnosis;
    selectedDiagnosisString;
    selectedInvestigationAdvice;
    selectedInvestigationAdviceString;
    selectedInvestigationReport;
    selectedInvestigationReportString;
    selectedShortAdvice;
    selectedShortAdviceString;
    selectedAllHistory;
    selectedAllergyHistory;
    selectedPersonalHistory;
    selectedFamilyHistory;
    selectedPastHistory;
    selectedSocialHistory;
    selectedFoodsAllergyHistory;
    selectedDrugAllergyHistory;
    selectedEnvironmentalAllergyHistory;
    selectedPatientAndAppointmentInfo;
    super.dispose();
  }

}



