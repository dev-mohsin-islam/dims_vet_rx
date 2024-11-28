import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/controller/general_setting/general_setting_controller.dart';
import 'package:dims_vet_rx/controller/general_setting/prescription_print_page_setup_controller.dart';
import 'package:dims_vet_rx/models/chief_complain/chief_complain_model.dart';
import 'package:dims_vet_rx/models/company_name/company_name_model.dart';
import 'package:dims_vet_rx/models/create_prescription/prescription_duration/prescription_duration_model.dart';
import 'package:dims_vet_rx/models/diagnosis/diagnosis_modal.dart';
import 'package:dims_vet_rx/models/dose/dose_model.dart';
import 'package:dims_vet_rx/models/drug_generic/drug_generic_model.dart';
import 'package:dims_vet_rx/models/handout_category/handout_category_model.dart';
import 'package:dims_vet_rx/models/history_category/history_category_model.dart';
import 'package:dims_vet_rx/models/instruction/instruction_model.dart';
import 'package:dims_vet_rx/models/investigation/investigation_modal.dart';
import 'package:dims_vet_rx/models/investigation_report/investigation_report_model.dart';
import 'package:dims_vet_rx/models/on_examination/on_examination_model.dart';
import 'package:dims_vet_rx/models/on_examination_category/on_examination_category_model.dart';
import 'package:dims_vet_rx/models/procedure/procedure_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/crud_operations/sync_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../models/advice/advice_model.dart';
import '../../models/drug_brand/drug_brand_model.dart';
import '../../models/handout/handout_model.dart';
import '../../models/history/history_model.dart';
import '../../screens/home_screen.dart';
import '../../screens/others_data_screen/app_sync_modal.dart';
import '../../utilities/box_data_clear_refresh.dart';
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';

class InsertDataJsonToDb extends GetxController{
  final SyncCRUDController commonSyncController = SyncCRUDController();
  final BoxDataClearAndRefresh boxDataClearAndRefresh = BoxDataClearAndRefresh();


  final Box<AdviceModel>boxAdvice = Boxes.getAdvice();
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
  final Box<OnExaminationCategoryModel> boxOnExaminationCategory = Boxes.getOnExaminationCategory();
  final Box<ProcedureModel> boxProcedure = Boxes.getProcedure();
  final Box<HandoutCategoryModel> boxHandoutCategory = Boxes.getHandoutCategory();
  final Box<HandoutModel> boxHandout = Boxes.getHandout();
  final Box<HistoryCategoryModel> boxHistoryCategory = Boxes.getHistoryCategory();


  RxDouble overallProgress = 0.0.obs;
  RxString currentSyncingData = ''.obs;


  RxBool advice = false.obs;
  RxBool brand = false.obs;
  RxBool cc = false.obs;
  RxBool company = false.obs;
  RxBool diagnosis = false.obs;
  RxBool dose = false.obs;
  RxBool duration = false.obs;
  RxBool generic = false.obs;
  RxBool handout = false.obs;
  RxBool history = false.obs;
  RxBool instruction = false.obs;
  RxBool investigationAdvice = false.obs;
  RxBool investigationReport = false.obs;
  RxBool onExamination = false.obs;
  RxBool onExaminationCategory = false.obs;
  RxBool procedure = false.obs;




  Future<void> adviceFunction() async {
    String jsonString = await rootBundle.loadString('assets/db/advice.json');
    final jsonResponse = await json.decode(jsonString);
    final data = await jsonResponse['data'] ?? [];
      if(data.isNotEmpty){
        for (var item in data) {
          int id = item['id'];
          String label = item['label'];
          String name = item['text'];
          int web_id = item['id'];
          await commonSyncController.saveCommonServerToDb(boxAdvice, AdviceModel(id: id, label: label, text: name, uuid: '',u_status: DefaultValues.Synced, web_id: web_id, date: '${DateTime.now()}' ));
        }
        advice.value =  !advice.value;
      }
  }



  Future<void> ccFunction() async {
    String jsonString = await rootBundle.loadString('assets/db/cc.json');
    final jsonResponse = await json.decode(jsonString);
    final data = await jsonResponse['data']['data'] ?? [];
      if(data.isNotEmpty){
        for (var item in data) {
          int web_id = item['id'] ?? 0;
          String name = item['name'] ?? '';
          if(web_id != 0 && name.isNotEmpty){
            await commonSyncController.saveCommonServerToDb(boxChiefComplain, ChiefComplainModel(id: 0, name: name, uuid: "", u_status: DefaultValues.Synced, web_id: web_id, date: '${DateTime.now()}'));
          }
        }
        cc.value = true;
      }
  }

  Future<void> companyFunction() async {
    String jsonString = await rootBundle.loadString('assets/db/company.json');
    final jsonResponse = await json.decode(jsonString);
    final data = await jsonResponse['data'] ?? [];
      if(data.length > 0){
        for (var item in data) {
          int company_id  = item["company_id"] ?? 0;
          String company_name  = item["company_name"] ?? '';
          if(company_id != 0 && company_name !=""){
            await commonSyncController.saveCompanyServerToDb(boxCompanyName, CompanyNameModel(id: company_id,web_id: company_id,  company_name: company_name, uuid: "", u_status: DefaultValues.Synced, date: "${DateTime.now()}"));
          }
        }
        company.value = true;
      }
  }
  Future<void> genericFunction() async {

    String jsonString = await rootBundle.loadString('assets/db/generic.json');
    final jsonResponse = await json.decode(jsonString);
    final List data = await jsonResponse['data'] ?? [];
    if(data.isNotEmpty){
      for (var item in data) {
        int generic_id = item['generic_id'] ?? 0;
        String generic_name = item['generic_name'] ?? "";
        if(generic_id != 0 && generic_name != ""){
          await commonSyncController.saveGenericServerToDb(boxDrugGeneric, DrugGenericModel(id: generic_id,web_id: generic_id, generic_name: generic_name, uuid: "", u_status: DefaultValues.Synced, date: "${DateTime.now()}"));
        }

      }
      generic.value = true;
    }
  }
  Future<void> brandFunction() async {
    String jsonString = await rootBundle.loadString('assets/db/brand.json');
    final jsonResponse = await json.decode(jsonString);
    final List data = await jsonResponse['data'] ?? [];
    if (data.isNotEmpty) {
      for (var item in data) {
        int web_id= item['brand_id'] ?? 0;
        int brand_id = item['brand_id'] ?? 0;
        int generic_id = item['generic_id'] ?? 0;
        int company_id = item['company_id'] ?? 0;
        String brand_name = item['brand_name'] ?? '';
        var form = item['form'] ?? '';
        var strength = item['strength'] ?? '';
        if (brand_id == 0 && generic_id == 0 && company_id == 0 && brand_name.isEmpty && form.isEmpty) {

        } else {
          await commonSyncController.saveBrandJsnToDb(boxDrugBrand, DrugBrandModel(
              id: brand_id,
              brand_name: brand_name,
              generic_id: generic_id,
              company_id: company_id,
              form: form,
              strength: strength,
              web_id: web_id,
              date: '${DateTime.now()}',
              uuid: ""));
        }

      }
      brand.value = true;
    }
  }

  Future<void> diagnosisFunction() async {
    String jsonString = await rootBundle.loadString('assets/db/diagnosis.json');
    final jsonResponse = await json.decode(jsonString);
    final data = await jsonResponse['data']['data'] ?? [];
      if(data.isNotEmpty){
        for (var item in data) {
          int id = item['id'] ?? 0;
          String name = item['name']  ?? '';
          if(id !=0 && name !=""){
            await commonSyncController.saveCommonServerToDb(boxDiagnosis, DiagnosisModal(id: 0, web_id: id, name: name, uuid: "", u_status: DefaultValues.Synced, date: '${DateTime.now()}'));
          }

        }
        diagnosis.value = true;
      }
  }

  Future<void> doseFunction() async {
    String jsonString = await rootBundle.loadString('assets/db/dose.json');
    final jsonResponse = await json.decode(jsonString);
    List data = await jsonResponse['data']['data'] ?? [];
      if(data.isNotEmpty){
        for (var item in data) {
          int id = item['id'] ?? 0;
          String name = item['name'] ?? '';
          if(id !=0 && name !=""){
            await commonSyncController.saveCommonServerToDb(boxDose, DoseModel(id: 0, name: name, uuid: "", web_id: id, u_status: DefaultValues.Synced, date: '${DateTime.now()}'));
          }

        }
        dose.value = true;
      }
  }

  Future<void> durationFunction() async {
    String jsonString = await rootBundle.loadString('assets/db/duration.json');
    final jsonResponse = await json.decode(jsonString);
    final data = await jsonResponse['data']['data'] ?? [];
    if(data.isNotEmpty){
      for (var item in data) {
          int id = item['id'] ?? 0;
          String name = item['name'] ?? '';
          int number = item['number'] ?? 0;
          String type = item['type'] ?? '';
          if(id !=0 && name !=""){
            await commonSyncController.saveCommonServerToDb(boxPrescriptionDuration, PrescriptionDurationModel(id: 0,  uuid: "", name: name, number: number, type: type, u_status: DefaultValues.Synced, web_id: id, ));
          }
           }
        duration.value = true;
      }
  }



  Future<void> handoutFunction() async {
    String jsonString = await rootBundle.loadString('assets/db/handout.json');
    final jsonResponse = await json.decode(jsonString);
    final data = await jsonResponse['data'] ?? [];
      if(data.length > 0){
        for (var item in data) {
          int id = item['id'];
          int category_id = item['category_id'];
          String label = item['label'];
          String text = item['text'];
          await commonSyncController.saveCommonServerToDb(boxHandout, HandoutModel(id: 0, web_id: id,  u_status: DefaultValues.Synced, category_id: category_id, label: label, text: text, uuid: "",));
        }
        handout.value = true;
      }
  }

  Future<void> historyFunction() async {
    String jsonString = await rootBundle.loadString('assets/db/history.json');
    final jsonResponse = await json.decode(jsonString);
    final List data = await jsonResponse['data'] ?? [];

      if(data.isNotEmpty){
        for (var item in data) {
          String category = item['category'] ?? "";
          final List items = item['data'] ?? [];
          if(items.isNotEmpty){
            for(var items in items){
              int id = items['id'] ?? 0;
              String name = items['name'] ?? "";
              if(id != 0 && name != ""){
                await commonSyncController.saveCommonServerToDb(boxHistory, HistoryModel(id: 0, web_id: id, name: name, uuid: "", category: category, type: category, u_status: DefaultValues.Synced, date: '${DateTime.now()}'));
              }
            }
          }
           }
        history.value = true;
      }
  }

  Future<void> instructionFunction() async {
    String jsonString = await rootBundle.loadString('assets/db/instruction.json');
    final jsonResponse = await json.decode(jsonString);
    final data = await jsonResponse['data']['data'] ?? [];
    List reversedData = data.reversed.toList();
    if(reversedData.isNotEmpty){
      for (var item in reversedData) {
          int id = item['id'] ?? 0;
          String name = item['name'] ?? "";
          if(id != 0 && name != ""){
            await commonSyncController.saveCommonServerToDb(boxInstruction, InstructionModel(id: 0, web_id: id, name: name, uuid: "", u_status: DefaultValues.Synced, date: '${DateTime.now()}'));
          }
        }
        instruction.value = true;
      }
  }

  Future<void> investigationAdviceFunction() async {
    String jsonString = await rootBundle.loadString('assets/db/investigationAdvice.json');
    final jsonResponse = await json.decode(jsonString);
    final data = await jsonResponse['data']['data'] ?? [];
      if(data.isNotEmpty){
        for (var item in data) {
          int id = item['id'] ?? 0;
          String name = item['name'] ?? "";
          if(id != 0 && name != ""){
            await commonSyncController.saveCommonServerToDb(boxInvestigation, InvestigationModal(id: 0, web_id: id, name: name, uuid: "", u_status: DefaultValues.Synced));
          }

        }
        investigationAdvice.value = true;
      }
  }

  Future<void> investigationReportFunction() async {
    String jsonString = await rootBundle.loadString('assets/db/investigationReport.json');
    final jsonResponse = await json.decode(jsonString);
    final data = await jsonResponse['data']['data'] ?? [];
      if(data.isNotEmpty){
        for (var item in data) {
          int id = item['id'] ?? 0;
          String name = item['name'] ?? "";
          if(id != 0 && name != ""){
            await commonSyncController.saveCommonServerToDb(boxInvestigationReport, InvestigationReportModel(id: 0, web_id: id, name: name, uuid: "", u_status: DefaultValues.Synced));
          }
        }
        investigationReport.value = true;
      }
  }

  Future<void> onExaminationFunction() async {
    String jsonString = await rootBundle.loadString('assets/db/onExamination.json');
    final jsonResponse = await json.decode(jsonString);
    final List data = await jsonResponse['data'] ?? [];
      if(data.length > 0){
        for (var item in data) {
          int id = item['id'] ?? 0;
          int category_id = item['category_id'] ?? 0;
          String name = item['name'] ?? "";
          if(id != 0 && name != ""){
            await commonSyncController.saveCommonServerToDb(boxOnExamination, OnExaminationModel(id: 0, web_id: id, name: name, uuid: "", category: category_id, u_status: DefaultValues.Synced, date: '${DateTime.now()}'));
          }

        }
        onExamination.value = true;
      }
  }Future<void> onExaminationCategoryFunction() async {
    String jsonString = await rootBundle.loadString('assets/db/onExaminationCategory.json');
    final jsonResponse = await json.decode(jsonString);
    final data = await jsonResponse['data'] ?? [];
      if(data.isNotEmpty){
        for (var item in data) {
          int id = item['id'] ?? 0;
          String name = item['name'] ?? "";
          if(id != 0 && name != ""){
            await commonSyncController.saveCommonServerToDb(boxOnExaminationCategory, OnExaminationCategoryModel(id: 0, web_id: id, name: name, uuid: "", u_status: DefaultValues.Synced));
          }
        }
        onExaminationCategory.value = true;
      }
  }

  Future<void> procedureFunction() async {
    String jsonString = await rootBundle.loadString('assets/db/procedure.json');
    final jsonResponse = await json.decode(jsonString);
    final List data = await jsonResponse['data']['data'] ?? [];
      if(data.isNotEmpty){
        for (var item in data) {
          int id = item['id'] ?? 0;
          String name = item['name'] ?? "";
          if(id != 0 && name != ""){
            await commonSyncController.saveCommonServerToDb(boxProcedure, ProcedureModel(id: 0, web_id: id, name: name, uuid: "", u_status: DefaultValues.Synced));
          }
        }
      }
      procedure.value = true;
  }

  Future<void> historyCategory() async {
    String jsonString = await rootBundle.loadString('assets/db/history_category.json');

    final jsonResponse = await json.decode(jsonString);
    final List data = await jsonResponse['data'] ?? [];
    if(data.isNotEmpty){
      for (var item in data) {
            int id = item['id'] ?? 0;
            String name = item['name'] ?? "";
            if(id != 0 && name != ""){
              await commonSyncController.saveCommonServerToDb(boxHistoryCategory, HistoryCategoryModel(id: 0, web_id: id, name: name, uuid: "", u_status: DefaultValues.Synced, date: '${DateTime.now()}'));
            }


      }
    }
  }
  Future<void> historyNew() async {
    String jsonString = await rootBundle.loadString('assets/db/history_new.json');
    final jsonResponse = await json.decode(jsonString);
    final List data = await jsonResponse['data'] ?? [];
    if(data.isNotEmpty){
      for (var item in data) {
            int id = item['id'] ?? 0;
            String name = item['name'] ?? "";
            String category = item['category_id'].toString();
            if(id != 0 && name != ""){
              await commonSyncController.saveHistoryServerToDb(boxHistory,boxHistoryCategory, HistoryModel(id: 0, web_id: id, name: name, uuid: "", u_status: DefaultValues.Synced, date: '${DateTime.now()}', category: category, type: '' ));
            }
      }
    }

  }


  Future<void> callAllJsonData(String defaultSyncDownload) async {
    Navigator.push(Get.context!, MaterialPageRoute(builder: (context) =>syncScreenJsonToDb()));
    if(await performOneTimeInitialization(defaultSyncDownload) == false){
     try{
       // Update progress bar with initial value
       await updateProgress(0.0);
       currentSyncingData.value = "Generic";
       await genericFunction();
       await updateProgress(0.1);

       currentSyncingData.value = "Drug Company";
       await companyFunction();
       await updateProgress(0.150);

       currentSyncingData.value = "Brand Data";
       await brandFunction();
       await updateProgress(0.5);

       currentSyncingData.value = "Chief Complaint";
       await ccFunction();
       await updateProgress(0.6);


       currentSyncingData.value = "Diagnosis";
       await diagnosisFunction();
       await updateProgress(0.7);

       currentSyncingData.value = "Drug Dose";
       await doseFunction();
       await updateProgress(0.750);

       currentSyncingData.value = "Drug Duration";
       await durationFunction();
       await updateProgress(0.775);

       currentSyncingData.value = "Instruction";
       await instructionFunction();
       await updateProgress(0.790);

       currentSyncingData.value = "On Examination Category";
       await onExaminationCategoryFunction();
       await updateProgress(0.8);

       currentSyncingData.value = "On Examination";
       await onExaminationFunction();
       await updateProgress(0.850);


       currentSyncingData.value = "History";
       await historyFunction();
       await updateProgress(0.875);


       currentSyncingData.value = "Investigation Advice";
       await investigationAdviceFunction();
       await updateProgress(0.890);

       currentSyncingData.value = "Investigation Advice Report";
       await investigationReportFunction();
       await updateProgress(0.9);


       currentSyncingData.value = "Procedure";
       await procedureFunction();
       await updateProgress(0.920);



       currentSyncingData.value = "Advice";
       await adviceFunction();
       await updateProgress(0.945);

       currentSyncingData.value = "Handout";
       await handoutFunction();
       await updateProgress(0.950);

       currentSyncingData.value = "History Category";
       await historyCategory();
       await updateProgress(0.960);

       currentSyncingData.value = "History";
       await historyNew();
       await updateProgress(0.960);

       currentSyncingData.value = "";
       await updateProgress(0.960);

       await setValueAfterInsertingData();
       await updateProgress(0.980); // Completion
       // await removeSpecificFile();
       // Helpers.successSnackBar("Success", "Sync Successfully completed");
       // Navigator.pushAndRemoveUntil(Get.context!, MaterialPageRoute(builder: (context) =>  HomeScreen(),), (route) => false);

     }catch(e){
       print(e);
     }
    }else{
      // Helpers.errorSnackBarDuration("Success", "Pre-data insertion failed", 3000);
      print("json not working");
    }
  }
  Future<void> updateProgress(double increment)async{
    overallProgress.value = increment;
  }


  @override
  void dispose() {
    // TODO: implement dispose
    overallProgress;
    currentSyncingData;
    boxAdvice.close();
    boxDrugBrand.close();
    boxInvestigation.close();
    boxInvestigationReport.close();
    boxOnExamination.close();
    boxChiefComplain.close();
    boxHistory.close();
    boxDiagnosis.close();
    boxCompanyName.close();
    boxDrugGeneric.close();
    boxDose.close();
    boxPrescriptionDuration.close();
    boxInstruction.close();
    boxOnExaminationCategory.close();
    boxProcedure.close();
    boxHandoutCategory.close();
    boxHandout.close();
    super.dispose();
  }


}

Future<bool> performOneTimeInitialization(String defaultSyncDownload) async {
  final GeneralSettingController generalSettingController = Get.put(GeneralSettingController());
  final PrescriptionPrintPageSetupController prescriptionPrintPageSetupController = Get.put(PrescriptionPrintPageSetupController());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool initialized = prefs.getBool('initialized') ?? false;
  if (!initialized) {
    await generalSettingController.functionDefaultSettings();
    await prescriptionPrintPageSetupController.defaultPrescriptionPrintSetup();
    await setSharedPreferences(defaultSyncDownload);
    return false;
  }else{
    return true;
  }
}

Future<void>setValueAfterInsertingData()async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Sync completed');
    // Save the initialized flag to prevent running the initialization again
    await prefs.setBool('initialized', true);
}




