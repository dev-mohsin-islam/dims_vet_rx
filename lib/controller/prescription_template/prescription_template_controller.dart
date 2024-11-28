
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/models/chief_complain/chief_complain_model.dart';
import 'package:dims_vet_rx/models/diagnosis/diagnosis_modal.dart';
import 'package:dims_vet_rx/models/drug_brand/drug_brand_model.dart';
import 'package:dims_vet_rx/models/investigation/investigation_modal.dart';
import 'package:dims_vet_rx/models/on_examination/on_examination_model.dart';

import '../../../database/hive_get_boxes.dart';
import '../../../utilities/helpers.dart';
import '../../database/crud_operations/brand_crud.dart';
import '../../database/crud_operations/prescription_template.dart';
import '../../models/prescription_template/prescription_template/prescription_template_model.dart';
import '../../models/prescription_template/prescription_template_drug/prescription_template_drug_model.dart';
import '../../models/prescription_template/prescription_template_drug_dose/prescription_template_drug_dose_model.dart';
import '../../utilities/default_value.dart';
import '../company_name/company_name_controller.dart';
import '../drug_generic/drug_generic_controller.dart';

class PrescriptionTemplateController extends GetxController{
  final CompanyNameController companyNameController = Get.put(CompanyNameController());
  final DrugGenericController genericController = Get.put(DrugGenericController());
  final BrandCrudController brandCrudController = BrandCrudController();
  final PrescriptionTemplateBoxCRUDController prescriptionTemplateBoxCRUDController = PrescriptionTemplateBoxCRUDController();


  final Box<PrescriptionTemplateModel>boxPrescriptionTemplate = Boxes.getPrescriptionTemplate();
  final Box<PrescriptionTemplateDrugModel>boxPrescriptionTemplateDrug = Boxes.getPrescriptionTemplateDrug();
  final Box<PrescriptionTemplateDrugDoseModel>boxPrescriptionTemplateDrugDose = Boxes.getPrescriptionTemplateDrugDose();

  final Box<DrugBrandModel>brandBox = Boxes.getDrugBrand();



  //only prescription data get from prescription database
  final RxList prescriptionTemplateList =  [].obs;


  // received from appointment controller (this value use for default id)
  int PATIENTID = 5555555555;
  int APPOINTMENTID = 5555555555;
  int PRESCRIPTIONID = 5555555555;
  RxInt PRESCRIPTION_ID_FOR_PRINT = 0.obs;


  // these list use for get data from prescription when user create a prescription
  //--start
  RxList selectedMedicine = [].obs;
  RxList selectedChiefComplain = [].obs;
  String selectedChiefComplainString = "";
  RxList selectedOnExamination = [].obs;
  String selectedOnExaminationString = "";
  RxList selectedDiagnosis = [].obs;
  String selectedDiagnosisString = "";
  RxList selectedInvestigationAdvice = [].obs;
  String selectedInvestigationAdviceString = "";
  RxList selectedShortAdvice = [].obs;
  RxList selectedHistory = [].obs;
  var selectedNextVisitDate = "".obs;
  final TextEditingController addNewClinicalDataController = TextEditingController();
  //--end

  final TextEditingController templateNameController= TextEditingController();
  final TextEditingController brandSearchController= TextEditingController();

  final TextEditingController searchController= TextEditingController();
  RxBool isLoading = false.obs;

  final uuid = DefaultValues.defaultUuid;
  final date = DefaultValues.defaultDate;
  final web_id = DefaultValues.defaultweb_id;
  final statusNewAdd = DefaultValues.NewAdd;
  final statusUpdate = DefaultValues.Update;
  final statusDelete = DefaultValues.Delete;

  Map<String, dynamic> prescriptionData = {
    "note": "",
    "cc_text": "",
    "diagnosis_text": "",
    "investigation_text": "",
    "onexam_text": "",
    "investigation_report_text": "",
  };



  // this method use for create new clinical data into prescription
  void addNewClinicalDataToPrescription(id,type){
    if(addNewClinicalDataController.text.isNotEmpty){
      if(type =="chiefComplain"){
        selectedChiefComplain.add(ChiefComplainModel(id: id, name: addNewClinicalDataController.text));
      }else if(type =="diagnosis"){
        selectedDiagnosis.add(DiagnosisModal(id: id, name: addNewClinicalDataController.text));
      }else if(type =="onExamination"){
        selectedOnExamination.add(OnExaminationModel(id: id, name: addNewClinicalDataController.text));
      }else if(type =="investigationAdvice"){
        selectedInvestigationAdvice.add(InvestigationModal(id: id, name: addNewClinicalDataController.text));
      }
    }else{
      Helpers.errorSnackBar("Failed", "Field must be not empty");
    }
    addNewClinicalDataController.clear();
  }



  // this method use for Save prescription data to database
  Future<void> addData(convertedPrescriptionData)async{

      print("convertedPrescriptionData['note']");
      print(convertedPrescriptionData['note']);
    var selectedMedicineList = convertedPrescriptionData['selectedMedicine'];
    String selectedChiefComplain = convertedPrescriptionData['selectedChiefComplain'];
    String selectedDiagnosis = convertedPrescriptionData['selectedDiagnosis'];
    String selectedOnExamination = convertedPrescriptionData['selectedOnExamination'];
    String selectedInvestigationAdvice = convertedPrescriptionData['selectedInvestigationAdvice'];
    String templateName = (templateNameController.text);

    try{
      if(templateName.isNotEmpty){
        if(selectedMedicineList !=null || selectedChiefComplain.isNotEmpty || selectedDiagnosis.isNotEmpty && selectedOnExamination.isNotEmpty || selectedInvestigationAdvice.isNotEmpty){
          int templateId = await prescriptionTemplateBoxCRUDController.savePrescriptionTemplate(boxPrescriptionTemplate,
              PrescriptionTemplateModel(
                id:PRESCRIPTIONID,
                web_id:web_id,
                u_status:statusNewAdd,
                note:prescriptionData['note'],
                uuid:uuid,
                cc_data: selectedChiefComplain,
                diagnosis_text: selectedDiagnosis,
                investigation_text: selectedInvestigationAdvice,
                on_data: selectedOnExamination,
                investigation_data:prescriptionData['investigation_report_text'],
                date:date,
                template_name: templateName,
                user_id: 0,
              ));

          if(templateId !=-1 && templateId != 5555555555){
            var isDrugDelete = await prescriptionTemplateBoxCRUDController.deleteTemplateDrug(boxPrescriptionTemplateDrug, boxPrescriptionTemplateDrugDose, selectedMedicineList, templateId);

            if(isDrugDelete == true){
              for(var i =0; i<selectedMedicineList.length; i++){
                var brandId = selectedMedicineList[i]['brand_id'];
                var genericId = selectedMedicineList[i]['generic_id'];
                var strength = selectedMedicineList[i]['strength'];
                var brandName = selectedMedicineList[i]['brand_name'];
                var drugId = await prescriptionTemplateBoxCRUDController.savePrescriptionTemplateDrug(boxPrescriptionTemplateDrug,templateId, PrescriptionTemplateDrugModel(id: 0, u_status: 0, template_id: templateId, generic_id: genericId, strength: strength, doze: "", duration: "", uuid: uuid, brand_id: brandId, condition: ""));

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
                      var note = dose['note'];
                      var doseId = await prescriptionTemplateBoxCRUDController.savePrescriptionTemplateDrugDose(boxPrescriptionTemplateDrugDose, drugId, doseSerial, PrescriptionTemplateDrugDoseModel(id: drugId, u_status: 0, generic_id: 0, doze: doze, duration: duration, note: note, uuid: uuid, drug_id: drugId, condition: condition, dose_serial: doseSerial, template_id: templateId));
                    }
                  }
                }
              }
            }
          }
          await getAllData('');
          // await getSinglePrescriptionData(context: context,TEMPLATE_ID: prescriptionId);
        }

      }else{
        Helpers.errorSnackBar("Failed", "Template name must be not empty");
      }
    }catch(e){
      print(e);
    }

  }

  // get single prescription data by id for printing
  Future<List?>  getSinglePrescriptionTemplateData(modifyDrugData, TEMPLATE_ID)async{
    await getAllData('');

    List prescriptionDrugListEachPrescription = [];
    prescriptionDrugListEachPrescription.clear();

    try{
      if(TEMPLATE_ID !=5555555555 && TEMPLATE_ID !=-1){

        List responsePrescriptionTemplate = await prescriptionTemplateBoxCRUDController.getSinglePrescriptionTemplateData(boxPrescriptionTemplate, TEMPLATE_ID);

        if(responsePrescriptionTemplate.isNotEmpty){
          for(var k =0; k< responsePrescriptionTemplate.length; k++){
            final String templateName = responsePrescriptionTemplate[k].template_name;
            final int prescriptionTemplateId = responsePrescriptionTemplate[k].id;
            final List chiefComplain = (clinicalDataConvertStringToList(responsePrescriptionTemplate[k].cc_data.toString()));
            final List selectedOnExamination=(clinicalDataConvertStringToList(responsePrescriptionTemplate[k].on_data.toString()));
            final List selectedDiagnosis =(clinicalDataConvertStringToList(responsePrescriptionTemplate[k].diagnosis_text.toString()));
            final List selectedInvestigationAdvice =(clinicalDataConvertStringToList(responsePrescriptionTemplate[k].investigation_text.toString()));
            final List note =(clinicalDataConvertStringToList(responsePrescriptionTemplate[k].note.toString()));
            if(prescriptionTemplateId !=-1){
              List drugs = await prescriptionTemplateBoxCRUDController.getPrescriptionTemplateDrug(boxPrescriptionTemplateDrug, prescriptionTemplateId);

              if(drugs.isNotEmpty){

                for(var i =0; i<await drugs.length; i++){
                  var multipleDrugDoseEach = [];
                  var drugId = drugs[i].id;
                  var brandId = drugs[i].brand_id;
                  if(drugId !=-1){
                    // List doses =  await prescriptionTemplateBoxCRUDController.getPrescriptionTemplateDrugDose(boxPrescriptionTemplateDrugDose,prescriptionTemplateId, drugId);
                    List doses =  [];
                    for(var i =0; i<boxPrescriptionTemplateDrugDose.length; i++){
                      var dose = boxPrescriptionTemplateDrugDose.getAt(i);
                      if( dose?.drug_id == drugId && dose?.template_id == prescriptionTemplateId){
                        doses.add(dose);
                      }
                    }
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
                  if(brand !=null){
                    brand['dose'] = multipleDrugDoseEach;
                    prescriptionDrugListEachPrescription.add(brand);

                  }
                }
              }

              Future.delayed(const Duration(seconds: 2));

              final List templateData = [
                {
                  'templateName': templateName,
                  'selectedMedicine': prescriptionDrugListEachPrescription,
                  'chiefComplains': chiefComplain,
                  'onExaminations': selectedOnExamination,
                  'diagnosis': selectedDiagnosis,
                  'investigationAdvices': selectedInvestigationAdvice,
                  'note': note,
                }
              ];

              return templateData;
            }
          }

        }

      }
    }catch(e){
      print(e);
    }
    return null;
  }

  // get all prescription template from database
  Future<void> getAllData(String searchText)async{
    try{
      var response = await prescriptionTemplateBoxCRUDController.getAllDataPrescriptionTemplate(boxPrescriptionTemplate, searchText);
      prescriptionTemplateList.clear();
      prescriptionTemplateList.addAll(response);
    }catch(e){
      print(e);
    }

  }

  //save template from prescription page
  Future<void> addTemplateData(context, prescriptionData)async{

    var selectedMedicineList = prescriptionData['selectedMedicine'];
    String selectedChiefComplain = prescriptionData['selectedChiefComplain'];
    String selectedDiagnosis = prescriptionData['selectedDiagnosis'];
    String selectedOnExamination = prescriptionData['selectedOnExamination'];
    String selectedInvestigationAdvice = prescriptionData['selectedInvestigationAdvice'];
    String templateName = (templateNameController.text);
    print(prescriptionData['note']);

   try {
     if(templateName.isNotEmpty){
       if(selectedMedicineList !=null || selectedChiefComplain.isNotEmpty || selectedDiagnosis.isNotEmpty && selectedOnExamination.isNotEmpty || selectedInvestigationAdvice.isNotEmpty){
         int templateId = await prescriptionTemplateBoxCRUDController.savePrescriptionTemplate(boxPrescriptionTemplate,
             PrescriptionTemplateModel(
               id:PRESCRIPTIONID,
               web_id:web_id,
               u_status:statusNewAdd,
               note:prescriptionData['note'],
               uuid:uuid,
               cc_data: selectedChiefComplain,
               diagnosis_text: selectedDiagnosis,
               investigation_text: selectedInvestigationAdvice,
               on_data: selectedOnExamination,
               investigation_data:prescriptionData['investigation_report_text'],
               date:date,
               template_name: templateName,
               user_id: 0,
             ));
         if(templateId !=-1 && templateId != 5555555555){
           var isDrugDelete = await prescriptionTemplateBoxCRUDController.deleteTemplateDrug(boxPrescriptionTemplateDrug, boxPrescriptionTemplateDrugDose, selectedMedicineList, templateId);

           if(isDrugDelete == true){
             for(var i =0; i<selectedMedicineList.length; i++){
               var drug = await selectedMedicineList[i];
               var brandId = selectedMedicineList[i]['brand_id'];
               var genericId = selectedMedicineList[i]['generic_id'];
               var strength = selectedMedicineList[i]['strength'];
               var brandName = selectedMedicineList[i]['brand_name'];
               var drugId = await prescriptionTemplateBoxCRUDController.savePrescriptionTemplateDrug(boxPrescriptionTemplateDrug,templateId, PrescriptionTemplateDrugModel(id: 0, u_status: 0, template_id: templateId, generic_id: genericId, strength: strength, doze: "", duration: "", uuid: uuid, brand_id: brandId, condition: ""));

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
                     var note = dose['note'];
                     var doseId = await prescriptionTemplateBoxCRUDController.savePrescriptionTemplateDrugDose(boxPrescriptionTemplateDrugDose, drugId, doseSerial, PrescriptionTemplateDrugDoseModel(id: drugId, u_status: 0, generic_id: 0, doze: doze, duration: duration, note: note, uuid: uuid, drug_id: drugId, condition: condition, dose_serial: doseSerial, template_id: templateId));
                   }
                 }
               }
             }
           }
         }
         await getAllData('');
         // await getSinglePrescriptionData(context: context,TEMPLATE_ID: prescriptionId);
       }

     }else{
       Helpers.errorSnackBar("Failed", "Template name must be not empty");}
     Navigator.pop(context);
   }catch(e){
     print(e);
   }
  }

  // this method use for delete prescription
  Future<void> deleteData(id)async{
    try {
      if(id !=-1 && id != null){
        await prescriptionTemplateBoxCRUDController.deleteCommon(boxPrescriptionTemplate, id, statusDelete);
        await getAllData('');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting data: $e");
      }
    }
    // isLoading = false;
  }





  //save medicine to prescription
  void onSelectedMedicine(object){
    var dose = object['dose'];
    for(var j=0; j <dose.length; j++){
      var dose = object['dose'][j];
      var existingIndex = selectedMedicine.indexWhere((element) => element['brand_id'] == object['brand_id']);
      if(dose['dose'].isNotEmpty && dose['duration'].isNotEmpty && dose['instruction'].isNotEmpty){
        if(existingIndex !=-1){
          selectedMedicine[existingIndex] = object;
        }else{
          selectedMedicine.add(object);
          Helpers.successSnackBar("Success!", "Brand added to prescription");
        }
      }
      else{
        Helpers.errorSnackBar("Failed!", "Field Must be not empty");
      }
    }

  }

  // clean prescription data for create a new prescription
  void prescriptionAllDataClearMethod(){
    PATIENTID = 5555555555;
    APPOINTMENTID = 5555555555;
    selectedMedicine.clear();
    selectedChiefComplain.clear();
    selectedOnExamination.clear();
    selectedDiagnosis.clear();
    selectedInvestigationAdvice.clear();
    selectedShortAdvice.clear();
    selectedNextVisitDate = "".obs;
  }

  void clearText()async{
    prescriptionTemplateList.clear();
    templateNameController.clear();
    searchController.clear();
    await getAllData('');
  }



  @override
  void onInit() {
    getAllData('');
    super.onInit();
  }

  @override
  void dispose() {
    prescriptionTemplateList;
    templateNameController;
    searchController;
    isLoading;
    selectedMedicine;
    selectedChiefComplain;
    selectedOnExamination;
    selectedDiagnosis;
    selectedInvestigationAdvice;
    selectedShortAdvice;
    selectedNextVisitDate;

    super.dispose();
  }

}



