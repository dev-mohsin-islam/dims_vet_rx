import 'package:collection/collection.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/controller/chambers/chamber_controller.dart';
import 'package:dims_vet_rx/controller/child_history/child_history_controller.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/prescription_controller.dart';
import 'package:dims_vet_rx/controller/drug_generic/drug_generic_controller.dart';
import 'package:dims_vet_rx/controller/general_setting/general_setting_controller.dart';
import 'package:dims_vet_rx/controller/gyn_and_obs/gyn_and_obs_controller.dart';
import 'package:dims_vet_rx/controller/history/history_controller.dart';
import 'package:dims_vet_rx/controller/investigation_report_image/investigation_report_image_cotroller.dart';
import 'package:dims_vet_rx/database/crud_operations/common_crud.dart';
import 'package:dims_vet_rx/database/crud_operations/prescription_crud.dart';
import 'package:dims_vet_rx/database/crud_operations/prescription_template.dart';
import 'package:dims_vet_rx/models/appointment/appointment_model.dart';
import 'package:dims_vet_rx/models/chambers/chamber_model.dart';
import 'package:dims_vet_rx/models/create_prescription/prescription/prescription_model.dart';
import 'package:dims_vet_rx/models/doctors/doctor_model.dart';
import 'package:dims_vet_rx/models/favorite_index/favorite_index_model.dart';
import 'package:dims_vet_rx/models/general_setting_pages/prescription_print_layout_settings/prescription_print_layout_setting_model.dart';
import 'package:dims_vet_rx/models/general_setting_pages/setting_pages_model.dart';
import 'package:dims_vet_rx/models/handout/handout_model.dart';
import 'package:dims_vet_rx/models/history_category/history_category_model.dart';
import 'package:dims_vet_rx/models/imvestigation_report_image/investigation_report_image_model.dart';
import 'package:dims_vet_rx/models/patient/patient_model.dart';
import 'package:dims_vet_rx/models/patient_certificate/patient_certificate_model.dart';
import 'package:dims_vet_rx/models/patient_disease_image/patient_disease_image_model.dart';
import 'package:dims_vet_rx/models/patient_history/patient_history_model.dart';
import 'package:dims_vet_rx/models/patient_referral/patient_referral_model.dart';
import 'package:dims_vet_rx/models/physician_notes/physician_notes_model.dart';
import 'package:dims_vet_rx/models/prescription_template/prescription_template/prescription_template_model.dart';
import 'package:dims_vet_rx/models/prescription_template/prescription_template_drug/prescription_template_drug_model.dart';
import 'package:dims_vet_rx/models/prescription_template/prescription_template_drug_dose/prescription_template_drug_dose_model.dart';
import 'package:dims_vet_rx/models/treatment_plan/treatment_plan_model.dart';
import 'package:dims_vet_rx/models/user_info/user_info_model.dart';
import 'package:dims_vet_rx/utilities/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as Io;
import '../../database/crud_operations/sync_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../models/advice/advice_model.dart';
import '../../models/chief_complain/chief_complain_model.dart';
import '../../models/company_name/company_name_model.dart';
import '../../models/create_prescription/prescription_drug/prescription_drug_model.dart';
import '../../models/create_prescription/prescription_drug_dose/prescription_drug_dose_model.dart';
import '../../models/create_prescription/prescription_duration/prescription_duration_model.dart';
import '../../models/create_prescription/prescription_handout/prescription_handout_model.dart';
import '../../models/diagnosis/diagnosis_modal.dart';
import '../../models/dose/dose_model.dart';
import '../../models/drug_brand/drug_brand_model.dart';
import '../../models/drug_generic/drug_generic_model.dart';
import '../../models/handout_category/handout_category_model.dart';
import '../../models/history/history_model.dart';
import '../../models/instruction/instruction_model.dart';
import '../../models/investigation/investigation_modal.dart';
import '../../models/investigation_report/investigation_report_model.dart';
import '../../models/on_examination/on_examination_model.dart';
import '../../models/on_examination_category/on_examination_category_model.dart';
import '../../models/procedure/procedure_model.dart';
import '../../screens/others_data_screen/app_sync_modal.dart';
import '../../services/api/db_to_server/data_upload_sync.dart';
import '../../services/api/db_to_server/file_upload.dart';
import '../../services/api/server_to_db/data_download_sync.dart';
import '../../services/end_points_list.dart';
import '../../utilities/box_data_clear_refresh.dart';
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';
import '../../utilities/history_category.dart';
import '../authentication/login_controller.dart';
import 'json_to_db.dart';

class DbToServerSyncController extends GetxController{
  RxBool servError = false.obs;
  RxBool syncStatus = false.obs;

  final SyncCRUDController commonController = SyncCRUDController();
  final CommonController commonCRUDController = CommonController();
  final BoxDataClearAndRefresh boxDataClearAndRefresh = BoxDataClearAndRefresh();
  final InsertDataJsonToDb insertDataJsonToDb = Get.put(InsertDataJsonToDb());
  final LoginController loginController = Get.put(LoginController());

  final Box<AdviceModel>boxAdvice = Boxes.getAdvice();
  final Box<DrugBrandModel>boxDrugBrand = Boxes.getDrugBrand();
  final Box<InvestigationModal>boxInvestigation = Boxes.getInvestigation();
  final Box<InvestigationReportModel>boxInvestigationReport = Boxes.getInvestigationReportBox();
  final Box<InvestigationReportImageModel>boxIRImage = Boxes.getInvestigationReportImage();
  final Box<PatientDiseaseImageModel>boxPaDiseaseImage = Boxes.getPatientDiseaseImage();
  final Box<OnExaminationModel>boxOnExamination = Boxes.getOnExamination();
  final Box<PhysicianNoteModel>boxPhysicianNotes = Boxes.getPhysicianNote();
  final Box<TreatmentPlanModel>boxTreatmentPlan = Boxes.getTreatmentPlan();
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
  final Box<PatientModel> boxPatient = Boxes.getPatient();
  final Box<PatientHistoryModel> boxPatientHistory = Boxes.getPatientHistory();
  final Box<AppointmentModel> boxAppointment = Boxes.getAppointment();
  final Box<PrescriptionModel> boxPrescription = Boxes.getPrescription();
  final Box<PrescriptionDrugModel> boxPrescriptionDrug = Boxes.getPrescriptionDrug();
  final Box<PrescriptionDrugDoseModel> boxPrescriptionDrugDose = Boxes.getPrescriptionDrugDose();
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final PrescriptionBoxCRUDController prescriptionBoxCRUDController = Get.put(PrescriptionBoxCRUDController());
  final PrescriptionTemplateBoxCRUDController prescriptionTemplateBoxCRUDController = Get.put(PrescriptionTemplateBoxCRUDController());
  final Box<PrescriptionTemplateDrugModel> boxPrescriptionTemplateDrug = Boxes.getPrescriptionTemplateDrug();
  final Box<PrescriptionTemplateDrugDoseModel> boxPrescriptionTemplateDrugDose = Boxes.getPrescriptionTemplateDrugDose();
  final Box<PrescriptionTemplateModel> boxPrescriptionTemplate = Boxes.getPrescriptionTemplate();
  final Box<FavoriteIndexModel> boxFavoriteIndex = Boxes.getFavoriteIndex();
  final DrugGenericController drugGenericController = Get.put(DrugGenericController());
  final Box<SettingPagesModel> boxGeneralSetting = Boxes.getSettingPages();
  final Box<PrescriptionPrintLayoutSettingModel> boxPrescriptionPrintLayout = Boxes.getPrescriptionPrintLayoutSettings();
  final Box<ChamberModel> boxChamber = Boxes.getChamber();
  final Box<DoctorModel> boxDoctor = Boxes.getDoctors();
  final Box<PatientReferralModel> boxReferral = Boxes.getPaReferral();
  final Box<PatientCertificateModel> boxCertificate = Boxes.getPatientCertificate();
  final Box<UserInfoModel> boxUserInfo = Boxes.getUserInfo();
  final Box<HistoryCategoryModel> boxHistoryCategory = Boxes.getHistoryCategory();

  RxDouble updateSyncProgress = 0.0.obs;
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

  Future<void> chiefComplainMethod(context)async{
    const maxRetries = 3;
    var retryCount = 0;
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.ChiefComplain}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true; 
    print("upload sync start: $URL");

      try{
        if(isInternet){
          if(token.isNotEmpty){
            if(statusApi){
              var response = await  commonCRUDController.getAllDataCommon(boxChiefComplain, '');
              if(response.isNotEmpty){
                List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
                List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
                List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
                if(newData.isNotEmpty){
                  for(var item in newData){
                    String name = item.name;
                    var response = servError.value ?  await ifServError().ApiService(URL, "post", token, name) : await ApiCreateDbToServer().ApiService(URL, "post", token, name);
                    print(response);
                    if(response['success'] == true){
                      var data = response['data'];
                      int id = data['id'];
                      String uuid = data['uuid'];
                      String name = data['name'];
                      await commonController.updateCommonServerToDb(boxChiefComplain, ChiefComplainModel(id: item.id, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                    }
                  }

                }
                if(updateData.isNotEmpty){
                  for(var item in updateData){
                    String name = item.name;
                    String uuid = item.uuid;
                    var response = servError.value ?  await ifServError().ApiService(URL + '/$uuid', "put", token, name) : await ApiCreateDbToServer().ApiService(URL + '/$uuid', "put", token, name);
                    if(response['success'] == true){
                      await commonController.updateCommonServerToDb(boxChiefComplain, ChiefComplainModel(id: item.id, web_id: item.web_id, name: item.name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                    }
                  }
                }
                if(deleteData.isNotEmpty){
                  for(var item in deleteData){
                    String uuid = item.uuid;
                    var response = servError.value ?  await ifServError().ApiService(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().ApiService(URL + '/$uuid', "delete", token, '');
                    if(response['success'] == true){
                      print(response);
                      await commonController.deleteCommonDbServer(boxChiefComplain, item.id);
                    }
                  }
                }
                await Future.delayed(Duration(seconds: 1));
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.cc, "${DateTime.now().toString()}");
              }
            }
          }else{
            Helpers.errorSnackBar('Error', 'Invalid token');
          }
        }else{
         print("Error : No Internet Connection");
        }
      } catch(e){
        print("Exception occurred: $e");
        if (e is SocketException) {
          print('Socket timeout: $e');
          retryCount++;
          await Future.delayed(Duration(seconds: 2 * retryCount));
        } else {
          print('Error: $e');

        }
      }
  }





  Future<void> physicianNotes(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.specialNote}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxPhysicianNotes, '');
            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  String name = item.name;
                  var response =servError.value ?  await ifServError().PhysicianNotesApiService(URL, "post", token, item) : await ApiCreateDbToServer().PhysicianNotesApiService(URL, "post", token, item);
                  if(response['success'] == true){
                    var data = response['data'];
                    await commonController.updateCommonServerToDb(boxPhysicianNotes, PhysicianNoteModel(id: item.id,details: item.details, web_id: data['id'], name: name, uuid: data['uuid'], u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String uid = item.web_id.toString();
                  var response =servError.value ?  await ifServError().PhysicianNotesApiService(URL + '/${uid}', "put", token, item) : await ApiCreateDbToServer().PhysicianNotesApiService(URL + '/${uid}', "put", token, item);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxPhysicianNotes, PhysicianNoteModel(id: item.id,details: item.details, web_id: item.web_id, name: item.name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.web_id.toString();
                  var response =servError.value ?  await ifServError().PhysicianNotesApiService(URL + '/${uuid}', "delete", token, '') : await ApiCreateDbToServer().PhysicianNotesApiService(URL + '/${uuid}', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxPhysicianNotes, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.physicianNotes, "${DateTime.now().toString()}");
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
        print('Error No Internet Connection');
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> treatmentPlan(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.treatmentPlan}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
      print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxTreatmentPlan, '');
            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  String name = item.name;
                  var response =servError.value ?  await ifServError().TreatmentPlanApiService(URL, "post", token, item) : await  ApiCreateDbToServer().TreatmentPlanApiService(URL, "post", token, item);
                  if(response['success'] == true){
                    var data = response['data'];
                    await commonController.updateCommonServerToDb(boxTreatmentPlan, TreatmentPlanModel(id: item.id, details: item.details, web_id: data['id'], name: name, uuid: data['uuid'], u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String uid = item.web_id.toString();
                  var response =servError.value ? ifServError().TreatmentPlanApiService(URL + '/${uid}', "put", token, item) : await ApiCreateDbToServer().TreatmentPlanApiService(URL + '/${uid}', "put", token, item);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxTreatmentPlan, TreatmentPlanModel(id: item.id,details: item.details, web_id: item.web_id, name: item.name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.web_id.toString();
                  var response =servError.value ? ifServError().TreatmentPlanApiService(URL + '/${uuid}', "delete", token, '') : await ApiCreateDbToServer().TreatmentPlanApiService(URL + '/${uuid}', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxTreatmentPlan, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.treatmentPlan, "${DateTime.now().toString()}");
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
        print('Error No Internet Connection');
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> onExaminationMethod(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.OnExamination}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
      print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxOnExamination, '');

            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  String name = item.name;
                  int category_id = item.category;
                  var response =servError.value ? ifServError().OnExaminationApiService(URL, "post", token, name,category_id) : await ApiCreateDbToServer().OnExaminationApiService(URL, "post", token, name,category_id);
                  if(response['success'] == true){
                    var data = response['data'];
                    int id = data['id'];
                    String uuid = data['uuid'];
                    String name = data['name'];
                    await commonController.updateCommonServerToDb(boxOnExamination, OnExaminationModel(id: item.id, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String name = item.name;
                  String uid = item.uuid;
                  var response = servError.value ? ifServError().ApiService(URL + '/${uid}', "put", token, name) : await ApiCreateDbToServer().ApiService(URL + '/${uid}', "put", token, name);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxOnExamination, OnExaminationModel(id: item.id, web_id: item.web_id, name: item.name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? ifServError().ApiService(URL + '/${uuid}', "delete", token, '') : await ApiCreateDbToServer().ApiService(URL + '/${uuid}', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxOnExamination, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.onExamination, "${DateTime.now().toString()}");
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
        print('Error No Internet Connection');
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> onExaminationCategoryMethod(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.OnExaminationCategory}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
      print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxOnExaminationCategory, '');

            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  String name = item.name;
                  var response =servError.value ? ifServError().OnExaminationCatApiService(URL, "post", token, name) : await ApiCreateDbToServer().OnExaminationCatApiService(URL, "post", token, name);
                  if(response['success'] == true){
                    var data = response['data'];
                    int id = data['id'];
                    String uuid = data['uuid'];
                    String name = data['name'];
                    await commonController.updateCommonServerToDb(boxOnExaminationCategory, OnExaminationCategoryModel(id: item.id, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String name = item.name;
                  String uid = item.uuid;
                  var response =servError.value ? ifServError().ApiService(URL + '/${uid}', "put", token, name) : await ApiCreateDbToServer().ApiService(URL + '/${uid}', "put", token, name);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxOnExamination, OnExaminationModel(id: item.id, web_id: item.web_id, name: item.name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? ifServError().ApiService(URL + '/${uuid}', "delete", token, '') : await ApiCreateDbToServer().ApiService(URL + '/${uuid}', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxOnExamination, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.onExaminationCategory, "${DateTime.now().toString()}");
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
        print('Error No Internet Connection');
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> investigationAdviceMethod(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.Investigation}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxInvestigation, '');
            if(response.isNotEmpty){
              print(response.length);
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  String name = item.name;
                  var response =servError.value ? ifServError().ApiService(URL, "post", token, name) : await ApiCreateDbToServer().ApiService(URL, "post", token, name);
                  if(response['success'] == true){
                    var data = response['data'];
                    int id = data['id'];
                    String uuid = data['uuid'];
                    String name = data['name'];
                    await commonController.updateCommonServerToDb(boxInvestigation, InvestigationModal(id: item.id, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String name = item.name;
                  String uid = item.uuid;
                  var response =servError.value ? ifServError().ApiService(URL + '/$uid', "put", token, name) : await ApiCreateDbToServer().ApiService(URL + '/$uid', "put", token, name);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxInvestigation, InvestigationModal(id: item.id, web_id: item.web_id, name: item.name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? ifServError().ApiService(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().ApiService(URL + '/$uuid', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxInvestigation, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.investigationAdvice, "${DateTime.now().toString()}");

            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
        print('Error No Internet Connection');
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> diagnosisMethod(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.Diagnosis}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
 print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxDiagnosis, '');
            if(response.isNotEmpty){ 
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  String name = item.name;
                  var response =servError.value ? ifServError().ApiService(URL, "post", token, name) : await ApiCreateDbToServer().ApiService(URL, "post", token, name);
                  if(response['success'] == true){
                    var data = response['data'];
                    int id = data['id'];
                    String uuid = data['uuid'];
                    String name = data['name'];
                    await commonController.updateCommonServerToDb(boxDiagnosis, DiagnosisModal(id: item.id, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String name = item.name;
                  String uid = item.uuid;
                  var response =servError.value ? ifServError().ApiService(URL + '/$uid', "put", token, name) : await ApiCreateDbToServer().ApiService(URL + '/$uid', "put", token, name);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxDiagnosis, DiagnosisModal(id: item.id, web_id: item.web_id, name: item.name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? ifServError().ApiService(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().ApiService(URL + '/$uuid', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxDiagnosis, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.diagnosis, "${DateTime.now().toString()}");
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
        print('Error No Internet Connection');
      }
    } catch(e){
      print(e);
    }
  }


  Future<void> investigationReportMethod(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.InvestigationReport}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxInvestigationReport, '');
            if(response.isNotEmpty){
              print(response.length);
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  String name = item.name;
                  var response =servError.value ? await ifServError().ApiService(URL, "post", token, name) : await ApiCreateDbToServer().ApiService(URL, "post", token, name);
                  if(response['success'] == true){
                    var data = response['data'];
                    int id = data['id'];
                    String uuid = data['uuid'];
                    String name = data['name'];
                    await commonController.updateCommonServerToDb(boxInvestigationReport, InvestigationReportModel(id: item.id, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String name = item.name;
                  String uid = item.uuid;
                  var response =servError.value ? await ifServError().ApiService(URL + '/$uid', "put", token, name) : await ApiCreateDbToServer().ApiService(URL + '/$uid', "put", token, name);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxInvestigationReport, InvestigationReportModel(id: item.id, web_id: item.web_id, name: item.name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? await ifServError().ApiService(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().ApiService(URL + '/$uuid', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxInvestigationReport, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.investigationReport, "${DateTime.now().toString()}");
            }
          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
        print('Error No Internet Connection');
      }
    } catch(e){
      print(e);
    }
  }

  Future<void> procedureMethod(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.Procedure}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();

    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxProcedure, '');
            if(response.isNotEmpty){
              print(response.length);
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  String name = item.name;
                  var response =servError.value ? await ifServError().ApiService(URL, "post", token, name) : await ApiCreateDbToServer().ApiService(URL, "post", token, name);
                  if(response['success'] == true){
                    var data = response['data'];
                    int id = data['id'];
                    String uuid = data['uuid'];
                    String name = data['name'];
                    await commonController.updateCommonServerToDb(boxProcedure, ProcedureModel(id: item.id, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String name = item.name;
                  String uid = item.uuid;
                  var response =servError.value ? await ifServError().ApiService(URL + '/$uid', "put", token, name) : await ApiCreateDbToServer().ApiService(URL + '/$uid', "put", token, name);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxProcedure, ProcedureModel(id: item.id, web_id: item.web_id, name: item.name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? await ifServError().ApiService(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().ApiService(URL + '/$uuid', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxProcedure, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.procedure, "${DateTime.now().toString()}");
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
        print('Error No Internet Connection');
      }
    } catch(e){
      print(e);
    }
  }

  //checking required
  Future<void> historyMethod(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.History}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxHistory, '');

            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  String name = item.name;
                  String category = item.category;
                  var response =servError.value ? await ifServError().HistoryApiService(URL, "post", token, name, category) : await ApiCreateDbToServer().HistoryApiService(URL, "post", token, name, category);

                  print(response['message']);
                  if(response['success'] == true){
                    var data = response['data'] ;
                    int id = data['id'];
                    String uuid = data['uuid'];
                    await commonController.updateCommonServerToDb(boxHistory, HistoryModel(id: item.id, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}", category: category, type: '' ));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String name = item.name;
                  int id = item.name;
                  String uuid = item.uuid;
                  String category = item.categiry;
                  var response =servError.value ? await ifServError().HistoryApiService(URL + '/$uuid', "put", token, name, category) : await ApiCreateDbToServer().HistoryApiService(URL + '/$uuid', "put", token, name, category);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxHistory, HistoryModel(id: item.id, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}", category: category, type: '' ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? ifServError().ApiService(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().ApiService(URL + '/$uuid', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxHistory, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.history, "${DateTime.now().toString()}");
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
        print('Error No Internet Connection');
      }
    } catch(e){
      print(e);
    }
  }

  //checking required
  Future<void> adviceMethod(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.Advice}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();

    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxAdvice, '');
            if(response.isNotEmpty){
              print("advice");
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty) {
                for (var item in newData) {
                  String label = item.label;
                  String text = item.text;
                  int id = item.id;
                  var response =servError.value ? await ifServError().AdviceApiService(URL, "post", token, label,text) : await ApiCreateDbToServer().AdviceApiService(URL, "post", token, label,text);
                  print("my advice");
                  print(response);
                  if (response['success'] == true) {
                    var data = response['data'];
                    int web_id = data['id'];
                    String uuid = data['uuid'];
                    String label = data['label'];
                    String text = data['label'];
                    await commonController.updateCommonServerToDb(boxAdvice,
                        AdviceModel(id: id,
                            web_id: web_id,
                            uuid: uuid,
                            label: label,
                            text: text,
                            u_status: DefaultValues.Synced));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String label = item.label;
                  String text = item.text;
                  String uuid = item.uuid;
                  int web_id = item.web_id;
                  int id = item.id;
                  var response =servError.value ? await ifServError().AdviceApiService(URL + '/$uuid', "put", token, label,text) : await ApiCreateDbToServer().AdviceApiService(URL + '/$uuid', "put", token, label,text);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxAdvice,
                        AdviceModel(id: id,
                            web_id: web_id,
                            uuid: uuid,
                            label: label,
                            text: text,
                            u_status: DefaultValues.Synced));
                     }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? ifServError().ApiService(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().ApiService(URL + '/$uuid', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxAdvice, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.advice, "${DateTime.now().toString()}");
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
        print('Error No Internet Connection');
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> doctorSync(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.doctor}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();

    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxDoctor, '');
            if(response.isNotEmpty){
              print(response.length);
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty) {
                for (var item in newData) {
                  var response =servError.value ? await ifServError().DoctorApiService(URL, "post", token, item) : await ApiCreateDbToServer().DoctorApiService(URL, "post", token, item);
                  if(response !=null){
                    if (response['success'] == true ) {

                      var data = response['data'];
                      item.web_id = data['id'];
                       item.uuid = data['uuid'];
                       item.u_status = DefaultValues.Synced;
                      await commonController.updateCommonServerToDb(boxDoctor,item);
                    }
                  }else{
                    print("Not inserted");
                  }

                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String uuid = item.uuid;
                  var response =servError.value ? await ifServError().DoctorApiService(URL + '/$uuid', "put", token, item) : await ApiCreateDbToServer().DoctorApiService(URL + '/$uuid', "put", token, item);
                  if(response['success'] == true){
                    var data = response['data'];
                    item.web_id = data['id'];
                    item.uuid = data['uuid'];
                    item.u_status =  DefaultValues.Synced;
                    await commonController.updateCommonServerToDb(boxAdvice,item);
                     }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? ifServError().DoctorApiService(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().DoctorApiService(URL + '/$uuid', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxDoctor, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              // await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.advice, "${DateTime.now().toString()}");
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
        print('Error No Internet Connection');
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> referral(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.referral}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();

    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxReferral, '');
            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();

              if(newData.isNotEmpty) {
                for (var item in newData) {
                  var AppIndex = await boxAppointment.values.toList().indexWhere((data) => data.id == parseInt(item.app_id.toString()));
                  var DocIndex = await boxDoctor.values.toList().indexWhere((data) => data.id == item.referred_to);
                  if(AppIndex != -1 && DocIndex != -1){
                      var oldAppId = item.app_id;
                      item.app_id =await boxAppointment.getAt(AppIndex)?.uuid;
                      item.referred_to_uuid =await boxDoctor.getAt(DocIndex)?.uuid;
                    var response =servError.value ? await ifServError().ReferralApiService(URL, "post", token, item) : await ApiCreateDbToServer().ReferralApiService(URL, "post", token, item);

                      if (response['success'] == true) {
                        var data = response['data'];
                        item.uuid = data['uuid'];
                        item.web_id = data['id'];
                        item.app_id = oldAppId;
                        item.u_status = DefaultValues.Synced;
                        await commonController.updateCommonServerToDb(boxReferral,item);
                      }
                  }

                }
              }
              // if(updateData.isNotEmpty){
              //   for(var item in updateData){
              //     String uuid = item.uuid;
              //     if(uuid != ""){
              //       var response =await ApiCreateDbToServer().ReferralApiService(URL + '/$uuid', "put", token, item);
              //       if(response['success'] == true){
              //         var data = response['data'];
              //         item.uuid = data['uuid'];
              //         item.web_id = data['id'];
              //         item.u_status = DefaultValues.Synced;
              //         PatientReferralModel referralModel =  item;
              //         await commonController.updateCommonServerToDb(boxReferral,referralModel);
              //       }
              //     }
              //
              //   }
              // }
              // if(deleteData.isNotEmpty){
              //   for(var item in deleteData){
              //     String uuid = item.uuid;
              //     var response =await ApiCreateDbToServer().ReferralApiService(URL + '/$uuid', "delete", token, '');
              //     if(response['success'] == true){
              //       await commonController.deleteCommonDbServer(boxReferral, item.id);
              //     }
              //   }
              // }
              await Future.delayed(Duration(seconds: 1));
              // await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.advice, "${DateTime.now().toString()}");
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
        print('Error No Internet Connection');
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> medicalCertificate(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.certificate}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxCertificate, '');
            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              print(response.length);
              if(newData.isNotEmpty) {
                for (var item in newData) {
                  print(item.appointment_id);
                  var AppIndex = await boxAppointment.values.toList().indexWhere((data) => data.id == parseInt(item.appointment_id.toString()));
                  if(AppIndex != -1){
                    item.appointment_id = await boxAppointment.getAt(AppIndex)?.web_id.toString();
                    item.guardian_name = "dem";
                    if(item.form != null && item.form != ""){
                      item.form = customDateTimeFormatReverse(DateTime.parse(item.form));
                    }
                   if(item.to != null && item.to != ""){
                     item.to = customDateTimeFormatReverse(DateTime.parse(item.to));
                   }

                    if(item.is_continue != null && item.is_continue != ""){
                      item.is_continue = customDateTimeFormatReverse(DateTime.parse(item.is_continue ));
                    }
                    if(item.diagnosis == null && item.diagnosis == ""){
                      item.diagnosis = "N/N";
                    }

                    var response =servError.value ? await ifServError().CertificateApiService(URL, "post", token, item) : await ApiCreateDbToServer().CertificateApiService(URL, "post", token, item);
                    if (response['success'] == true) {
                      var data = response['data'];
                      item.uuid = data['uuid'];
                      item.web_id = data['id'];
                      item.u_status = DefaultValues.Synced;
                      await commonController.updateCertificate(boxCertificate,item);
                    }
                  }

                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String uuid = item.uuid;
                  if(uuid != ""){
                    var response =servError.value ? await ifServError().CertificateApiService(URL + '/$uuid', "put", token, item): await ApiCreateDbToServer().CertificateApiService(URL + '/$uuid', "put", token, item);
                    if (response['success'] == true) {
                      var data = response['data'];
                      item.uuid = data['uuid'];
                      item.web_id = data['id'];
                      item.u_status = DefaultValues.Synced;
                      // await commonController.updateCommonServerToDb(boxCertificate,item);
                    }
                  }

                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? await ifServError().CertificateApiService(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().CertificateApiService(URL + '/$uuid', "delete", token, '');
                  if(response['success'] == true){
                    // await commonController.deleteCommonDbServer(boxCertificate, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              // await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.advice, "${DateTime.now().toString()}");
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> handOut(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.HandOut}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();

    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await boxHandout.values.toList();
            print("response.length");
            print(response.length);
            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              print(newData.length);
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty) {
                for (var item in newData) {
                  var response = servError.value ? await ifServError().HandOut(URL, "post", token, item) : await ApiCreateDbToServer().HandOut(URL, "post", token, item);
                  print(response);
                  if(response['success'] == true) {
                    var data = response['data'];
                    item.uuid = data['uuid'];
                    item.web_id = data['id'];
                    item.u_status = DefaultValues.Synced;
                    HandoutModel handoutModel =  item;
                    await commonController.updateCommonServerToDb(boxHandout,handoutModel);
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String uuid = item.uuid;
                  if(uuid != ""){
                    var response =servError.value ? await ifServError().HandOut(URL + '/$uuid', "put", token, item) : await ApiCreateDbToServer().HandOut(URL + '/$uuid', "put", token, item);
                    if (response['success'] == true) {
                      var data = response['data'];
                      item.uuid = data['uuid'];
                      item.web_id = data['id'];
                      item.u_status = DefaultValues.Synced;
                      HandoutModel handoutModel =  item;
                      await commonController.updateCommonServerToDb(boxHandout,handoutModel);
                    }
                  }

                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? await ifServError().HandOut(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().HandOut(URL + '/$uuid', "delete", token, '');
                  if(response['success'] == true){

                    await commonController.deleteCommonDbServer(boxHandout, item.id);
                  }
                }
              }
              print("api call end : $URL");
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.advice, "${DateTime.now().toString()}");
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }

  //not complete

  Future<void> instructionMethod(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.Instruction}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxInstruction, '');
            if(response.isNotEmpty){
              print(response.length);
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  String name = item.name;
                  var response =servError.value ? await ifServError().ApiService(URL, "post", token, name) : await ApiCreateDbToServer().ApiService(URL, "post", token, name);
                  if(response['success'] == true){
                    var data = response['data'];
                    int id = data['id'];
                    String uuid = data['uuid'];
                    String name = data['name'];
                    await commonController.updateCommonServerToDb(boxInstruction, InstructionModel(id: item.id, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String name = item.name;
                  String uid = item.uuid;
                  var response =servError.value ? await ifServError().ApiService(URL + '/$uid', "put", token, name) : await ApiCreateDbToServer().ApiService(URL + '/$uid', "put", token, name);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxInstruction, InstructionModel(id: item.id, web_id: item.web_id, name: item.name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? await ifServError().ApiService(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().ApiService(URL + '/$uuid', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxInstruction, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.instruction, "${DateTime.now().toString()}");
            }
          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> doseMethod(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.Dose}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxDose, '');
            if(response.isNotEmpty){
              print(response.length);
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  String name = item.name;
                  var response =servError.value ? await ifServError().ApiService(URL, "post", token, name) : await ApiCreateDbToServer().ApiService(URL, "post", token, name);
                  if(response['success'] == true){
                    var data = response['data'];
                    int id = data['id'];
                    String uuid = data['uuid'];
                    String name = data['name'];
                    await commonController.updateCommonServerToDb(boxDose, DoseModel(id: item.id, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String name = item.name;
                  String uid = item.uuid;
                  var response =servError.value ? await ifServError().ApiService(URL + '/$uid', "put", token, name) : await ApiCreateDbToServer().ApiService(URL + '/$uid', "put", token, name);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxDose, DoseModel(id: item.id, web_id: item.web_id, name: item.name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? await ifServError().ApiService(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().ApiService(URL + '/$uuid', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxDose, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.dose, "${DateTime.now().toString()}");
            }
          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }

  //not completed
  Future<void> durationMethod(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.Duration}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxPrescriptionDuration, '');
            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  String name = item.name;
                  var response =servError.value ? await ifServError().ApiService(URL, "post", token, name) : await ApiCreateDbToServer().ApiService(URL, "post", token, name);
                  print(response);
                  if(response['success'] == true){
                    var data = response['data'];
                    int id = data['id'];
                    String uuid = data['uuid'];
                    String name = data['name'];
                    await commonController.updateCommonServerToDb(boxPrescriptionDuration, PrescriptionDurationModel(id: id, u_status: DefaultValues.Synced, uuid: uuid, name: name, number: 0, type: ""));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String name = item.name;
                  String uid = item.uuid;
                  var response =servError.value ? await ifServError().ApiService(URL + '/$uid', "put", token, name) : await ApiCreateDbToServer().ApiService(URL + '/$uid', "put", token, name);
                  if(response['success'] == true){
                    // await commonController.updateCommonServerToDb(boxPrescriptionDuration, PrescriptionDurationModel(id: item.id, web_id: item.web_id, name: item.name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? await ifServError().ApiService(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().ApiService(URL + '/$uuid', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxPrescriptionDuration, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.duration, "${DateTime.now().toString()}");
            }
          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }

  //checking required
  Future<void> companyMethod(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.Company}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxCompanyName, '');
            if(response.isNotEmpty){
              print(response.length);
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  String company_name = item.company_name;
                  var response =servError.value ? await ifServError().ApiService(URL, "post", token, company_name) : await ApiCreateDbToServer().ApiService(URL, "post", token, company_name);
                  if(response['success'] == true){
                    var data = response['data'];
                    int company_id = data['company_id'];
                    String uuid = data['uuid'];
                    String company_name = data['company_name'];
                    await commonController.updateCommonServerToDb(boxCompanyName, CompanyNameModel(id: item.id, web_id: company_id,  company_name: company_name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String name = item.company_name;
                  String uid = item.uuid;
                  var response =servError.value ? await ifServError().ApiService(URL + '/$uid', "put", token, name) : await ApiCreateDbToServer().ApiService(URL + '/$uid', "put", token, name);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxCompanyName, CompanyNameModel(id: item.id, web_id: item.web_id,   company_name: item.name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? await ifServError().ApiService(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().ApiService(URL + '/$uuid', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxCompanyName, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.company, "${DateTime.now().toString()}");
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }

  //checking required
  Future<void> genericMethod(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.Generic}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();

    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxDrugGeneric, '');
            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  String generic_name = item.generic_name;
                  var response =servError.value ? await ifServError().GenericApiService(URL, "post", token, generic_name) : await ApiCreateDbToServer().GenericApiService(URL, "post", token, generic_name);
                  if(response['success'] == true){
                    var data = response['data'];
                    int id = data['generic_id'];
                    String uuid = data['uuid'];
                    String name = data['generic_name'];
                    await commonController.updateCommonServerToDb(boxDrugGeneric, DrugGenericModel(id: item.id, web_id: item.web_id,  generic_name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String generic_name = item.generic_name;
                  String uuid = item.uuid;
                  var response =servError.value ? await ifServError().GenericApiService(URL + '/$uuid', "put", token, generic_name) : await ApiCreateDbToServer().GenericApiService(URL + '/$uuid', "put", token, generic_name);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxDrugGeneric, DrugGenericModel(id: item.id, web_id: item.web_id,  generic_name: item.generic_name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? await ifServError().GenericApiService(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().GenericApiService(URL + '/$uuid', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxDrugGeneric, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.generic, "${DateTime.now().toString()}");
            }
          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }

  //checking required
  Future<void> brandMethod(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.Brand}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await commonCRUDController.getAllDataCommon(boxDrugBrand, '');
            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();

              if(newData.isNotEmpty){
                for(var item in newData){
                  int generic_id = item.generic_id;
                  int company_id = item.company_id;
                  String brand_name = item.brand_name;
                  String form = item.form;
                  String strength = item.strength;
                  var response =servError.value ? await ifServError().brandApiService(URL, "post", token, brand_name,generic_id,company_id,form,strength) : await ApiCreateDbToServer().BrandApiService(URL, "post", token,brand_name,generic_id,company_id,form,strength);
                  print("my brand response: $response");
                  if(response['success'] == true){
                    var data = response['data'];
                    String uuid = data['uuid'];
                    var web_id = data['brand_id'] ?? 0;
                    await commonController.updateDrugBrandServerToDb(boxDrugBrand,item.id,web_id, uuid );
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  int generic_id = item.generic_id;
                  int company_id = item.company_id;
                  String brand_name = item.brand_name;
                  String form = item.form;
                  String strength = item.strength;
                  String uuid = item.uuid;
                  var response =servError.value ? await ifServError().brandApiService(URL + '/$uuid', "put", token, brand_name,generic_id,company_id,form,strength) : await ApiCreateDbToServer().BrandApiService(URL + '/$uuid', "put", token, brand_name,generic_id,company_id,form,strength);
                  if(response['success'] == true){
                    var data = response['data'];
                    var web_id = data['brand_id'] ?? 0;
                    await commonController.updateDrugBrandServerToDb(boxDrugBrand,item.id,web_id, uuid );
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? await ifServError().GenericApiService(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().GenericApiService(URL + '/$uuid', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxDrugBrand, item.id);
                  }
                }
              }
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.brand, "${DateTime.now().toString()}");
            }
          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }

  //not called
  Future<void> patient(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.Patients}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await commonCRUDController.getAllDataCommon(boxPatient, '');
            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  String name = item.name;
                  print(item.dob);
                  var response =servError.value ? await ifServError().ApiService(URL, "post", token, name) : await ApiCreateDbToServer().ApiService(URL, "post", token, name);
                  if(response['success'] == true){
                    var data = response['data'];
                    int id = data['id'];
                    String uuid = data['uuid'];
                    String name = data['name'];
                    await commonController.updateCommonServerToDb(boxChiefComplain, ChiefComplainModel(id: item.id, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String name = item.name;
                  String uuid = item.uuid;
                  var response =servError.value ? await ifServError().ApiService(URL + '/$uuid', "put", token, name) : await ApiCreateDbToServer().ApiService(URL + '/$uuid', "put", token, name);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxChiefComplain, ChiefComplainModel(id: item.id, web_id: item.web_id, name: item.name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String uuid = item.uuid;
                  var response =servError.value ? await ifServError().ApiService(URL + '/$uuid', "delete", token, '') : await ApiCreateDbToServer().ApiService(URL + '/$uuid', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonServerToDb(boxChiefComplain, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.patient, "${DateTime.now().toString()}");
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }

  Future<void> appointment(context)async{
     const  URL = '${ApiCUD.BaseUrl}${ApiCUD.Appointment}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var responsePatient = await commonCRUDController.getAllDataCommon(boxPatient, '');

            var responseAppointment = await commonCRUDController.getAllDataCommon(boxAppointment, '');

            var newPatients = responsePatient.where((data) => data.u_status == DefaultValues.NewAdd).toList();
            var newAppointments = responseAppointment.where((data) => data.u_status == DefaultValues.NewAdd).toList();

            if(newAppointments.isNotEmpty){
              for(var patients in newPatients){

                int patientId = patients.id;
                var appointmentInfo = newAppointments.firstWhere((element) => element.patient_id == patientId, orElse: () => null,);

                if(appointmentInfo != null){

                  var response =servError.value ? await ifServError().AppointmentApiService(URL, "post", token, patients,appointmentInfo) : await ApiCreateDbToServer().AppointmentApiService(URL, "post", token, patients,appointmentInfo);
                  print("Appointment Response");
                  print(response);
                  if(response['success'] == true){
                    var data = response['data'];
                    var appWebId = data['id'];
                    var appUUID = data['uuid'];
                    if(data != null){
                      var patient = data['patient'];
                      if(patient != null){
                        int paWebId = patient['id'];
                        String paUUID = patient['uuid'];
                        await commonController.updatePatientServerToDb2(boxPatient, patientId, paWebId, paUUID);
                      }
                      await commonController.updateAppointmentServerToDb2(boxAppointment, boxPrescription, appointmentInfo.id, appWebId, appUUID,);

                    }
                  }
                }
              }
            }
            await Future.delayed(Duration(seconds: 1));
            await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.patient, "${DateTime.now().toString()}");
            await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.appointment, "${DateTime.now().toString()}");
            print("upload sync end ${URL}");
          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }

  Future<void> prescription(context)async{
    await prescriptionController.getAllBrandData('');
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.CreatePrescription}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxPrescription, '');
            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var prescription in newData){
                  List prescriptionDrugListEachPrescription = [];
                  int prescriptionId = prescription.id;
                  List prescriptionDrug = await prescriptionBoxCRUDController.getPrescriptionDrug(boxPrescriptionDrug, prescription.id);
                  if(prescriptionDrug.isNotEmpty){
                    for(var i =0; i<prescriptionDrug.length; i++){
                      var multipleDrugDoseEach = [];
                      var drugId = prescriptionDrug[i].id;
                      var brandId = prescriptionDrug[i].brand_id;
                      var genericID = prescriptionDrug[i].generic_id;
                      List prescriptionDrugDose =  await prescriptionBoxCRUDController.getPrescriptionDrugDose(boxPrescriptionDrugDose,prescription.id, drugId);
                      if(drugId !=-1){
                        if(prescriptionDrugDose.isNotEmpty){
                          for(var j =0; j<prescriptionDrugDose.length; j++){
                            var doseId = prescriptionDrugDose[j].id;
                            var dose = prescriptionDrugDose[j].doze ?? "";
                            var duration = prescriptionDrugDose[j].duration ?? "";
                            var condition = prescriptionDrugDose[j].condition ?? "";
                            var note = prescriptionDrugDose[j].note ?? "";
                            var status = prescriptionDrugDose[j].u_status;
                            var genericId = prescriptionDrugDose[j].generic_id;
                            var drugDose = {"dose":dose ,"duration":duration,"instruction": condition,"comment": note ?? "", "serial": j.toString()};
                            multipleDrugDoseEach.add(drugDose);
                          }
                        }
                      }

                      int? checkWebBrandId;
                      for(int i =0; i< await boxDrugBrand.length; i++){
                          var drugs = await boxDrugBrand.getAt(i);
                        if(drugs?.id == brandId){
                          checkWebBrandId = drugs?.web_id;
                        }
                      }
                      int? checkGenericWebId;
                      for(int i =0; i< await boxDrugGeneric.length; i++){
                          var generics = await boxDrugGeneric.getAt(i);
                        if(generics?.id == genericID){
                          checkGenericWebId = generics?.web_id;
                        }
                      }
                      if(checkWebBrandId !=null && checkWebBrandId !=0 && checkWebBrandId !=-1 && checkGenericWebId !=null && checkGenericWebId !=0 && checkGenericWebId !=-1){
                          var brand = await prescriptionController.modifyDrugData.toList().firstWhere((element) => element['brand_id'] == brandId, orElse: () => null);
                          if(brand !=null ){
                            brand["index"] = i;
                            brand["brand_id"] = checkWebBrandId;
                            brand["generic_id"] = checkGenericWebId;
                            brand['dose'] = multipleDrugDoseEach;
                            prescriptionDrugListEachPrescription.add(brand);
                          }
                      }
                    }
                  }

                  var medicines = [];
                  if(prescriptionDrugListEachPrescription.isNotEmpty){
                    for(var medicine in prescriptionDrugListEachPrescription){
                      var multiDosesEchBrand = [];
                      var medicinesBrand = {
                        "index" : medicine['index'],
                        "brand_name" : medicine['brand_name'],
                        "brand_id" : medicine['brand_id'],
                        "form" : medicine['form'],
                        "strength" : medicine['strength'],
                        "company_name" : medicine['company_name'],
                        "company_id" : medicine['company_id'],
                        "generic_id" : medicine['generic_id'],
                        "generic_name" : medicine['generic_name'],
                      };

                      for(var doses in medicine['dose']){
                        var multiDose = {
                          "duration": doses['duration'],
                          "instruction": doses['instruction'],
                          "note": doses['note'],
                          "dose": doses['dose'],
                          "serial": doses['serial'],
                          "strength": doses['strength'],
                        };
                        multiDosesEchBrand.add(multiDose);
                      }

                      medicinesBrand['dose'] = multiDosesEchBrand;
                      medicines.add(medicinesBrand);

                    }
                  }

                  var jsonMedicine = jsonEncode(medicines);
                  if(prescription.uuid.isNotEmpty){
                    var response =servError.value
                        ? await ifServError().PrescriptionApiService(URL, "post", token, prescription, jsonMedicine,)
                        :await ApiCreateDbToServer().PrescriptionApiService(URL, "post", token, prescription, jsonMedicine,);
                   // var response = await ApiCreateDbToServer().PrescriptionApiService(URL, "post", token, prescription, jsonMedicine,);
                    print(response);
                    if(response['success'] == true){
                      var data = response['data'];
                      var uuid = data[0]['uuid'];
                      await commonController.updatePrescriptionServerToDb(boxPrescription,prescriptionId, uuid);
                    }
                    prescriptionDrugListEachPrescription.clear();
                  }else{
                    print("UUID is missing");
                  }

                }
              }
              // if(updateData.isNotEmpty){
              //   for(var item in updateData){
              //     String name = item.generic_name;
              //     String uuid = item.uuid;
              //     var response =await ApiCreateDbToServer().ApiService(URL + '/$uuid', "put", token, name);
              //     if(response['success'] == true){
              //       await commonController.updateCommonServerToDb(boxDrugGeneric, DrugGenericModel(id: item.id, web_id: item.web_id, generic_id: item.generic_id, generic_name: item.generic_name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
              //     }
              //   }
              // }
              // if(deleteData.isNotEmpty){
              //   for(var item in deleteData){
              //     String uuid = item.uuid;
              //     var response =await ApiCreateDbToServer().ApiService(URL + '/$uuid', "delete", token, '');
              //     if(response['success'] == true){
              //       await commonController.deleteCommonServerToDb(boxDrugGeneric, item.id);
              //     }
              //   }
              // }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.prescription, "${DateTime.now().toString()}");
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.prescriptionDrug, "${DateTime.now().toString()}");
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.prescriptionDrugDose, "${DateTime.now().toString()}");

            }
          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> patientChildHistory(context)async{
    ChildHistoryController childHistoryController = Get.put(ChildHistoryController());
    await prescriptionController.getAllBrandData('');
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.patientChildHistory}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxPatient, '');
            if(response.isNotEmpty){
              for(var patient in response){

                var patient_id = patient.id;
                var res = await childHistoryController.getForSaveToServer(patient_id);
                if(res !=null){
                  var jsonHistory = {"childHistory": [
                    res
                   ]};
                  var serverResponse =servError.value ? await ifServError().PatientChildHistory(URL, "post", token, patient_id, jsonEncode(jsonHistory)) : await ApiCreateDbToServer().PatientChildHistory(URL, "post", token,patient_id, jsonEncode(jsonHistory));
                  print(serverResponse);
                }
              }
              await Future.delayed(Duration(seconds: 1));

            }
          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> patientGynHistory(context)async{
    GynAndObsController gynAndObsController = Get.put(GynAndObsController());
    await prescriptionController.getAllBrandData('');
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.gyneHistory}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxPatient, '');
            if(response.isNotEmpty){
              for(var patient in response){
                var patient_id = patient.id;
                var res = await gynAndObsController.getForSaveToServer(patient_id);
                if(res !=null){
                  var jsonHistory = {"gynObsHistory": [
                    res
                   ]};
                  var serverResponse = servError.value ? await ifServError().PatientGynAndObsHistory(URL, "post", token, patient_id, jsonEncode(jsonHistory)) : await ApiCreateDbToServer().PatientGynAndObsHistory(URL, "post", token,patient_id, jsonEncode(jsonHistory));

                }
              }
              await Future.delayed(Duration(seconds: 1));

            }
          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }

  Future<void> prescriptionTemplate(context)async{
    await prescriptionController.getAllBrandData('');
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.PrescriptionTemplate}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxPrescriptionTemplate, '');
            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();

              if(newData.isNotEmpty){
                for(var item in newData){
                  List prescriptionDrugListEachPrescription = [];
                  int prescriptionTemplateId = item.id;
                  String name = item.template_name;
                  String note = item.note ?? "";
                  String cc_text = item.cc_data ?? "";
                  String diagnosis_text = item.diagnosis_text ?? "";
                  String onexam_text = item.on_data ?? "";
                  String investigation_text = item.investigation_text ?? "";
                  String investigation_report_text = item.investigation_data ?? "";

                  List templateDrug = await prescriptionTemplateBoxCRUDController.getPrescriptionTemplateDrug(boxPrescriptionTemplateDrug, prescriptionTemplateId);
                  if(templateDrug.isNotEmpty){
                    for(var i =0; i<templateDrug.length; i++){
                      var multipleDrugDoseEach = [];
                      var drugId = templateDrug[i].id;
                      var brandId = templateDrug[i].brand_id;
                      var genericID = templateDrug[i].generic_id;
                      List templateDrugDose =  await prescriptionTemplateBoxCRUDController.getPrescriptionTemplateDrugDose(boxPrescriptionTemplateDrugDose,prescriptionTemplateId, drugId);
                      if(drugId !=-1){
                        if(templateDrugDose.isNotEmpty){
                          for(var j =0; j<templateDrugDose.length; j++){
                            var doseId = templateDrugDose[j].id;
                            var dose = templateDrugDose[j].doze ?? "";
                            var duration = templateDrugDose[j].duration ?? "";
                            var condition = templateDrugDose[j].condition ?? "";
                            var note = templateDrugDose[j].note ?? "";
                            var status = templateDrugDose[j].u_status;
                            var genericId = templateDrugDose[j].generic_id;
                            var drugDose = {"dose":dose ,"duration":duration,"instruction": condition,"comment": note ?? "", "serial": j.toString()};
                            multipleDrugDoseEach.add(drugDose);
                          }
                        }
                      }
                      int? checkWebBrandId;
                      for(int i =0; i< await boxDrugBrand.length; i++){
                        var drugs = await boxDrugBrand.getAt(i);
                        if(drugs?.id == brandId){
                          checkWebBrandId = drugs?.web_id;
                        }
                      }
                      int? checkGenericWebId;
                      for(int i =0; i< await boxDrugGeneric.length; i++){
                        var generics = await boxDrugGeneric.getAt(i);
                        if(generics?.id == genericID){
                          checkGenericWebId = generics?.web_id;
                        }
                      }

                      if(checkWebBrandId !=null && checkGenericWebId !=null){
                        var brand = await prescriptionController.modifyDrugData.toList().firstWhere((element) => element['brand_id'] == brandId, orElse: () => null);
                        if(brand !=null ){
                          brand["index"] = i;
                          brand["brand_id"] = checkWebBrandId;
                          brand["generic_id"] = checkGenericWebId;
                          brand['dose'] = multipleDrugDoseEach;
                          prescriptionDrugListEachPrescription.add(brand);
                        }
                      }
                    }
                  }


                  var medicines = [];
                  if(prescriptionDrugListEachPrescription.isNotEmpty){
                    for(var medicine in prescriptionDrugListEachPrescription){
                      var multiDosesEchBrand = [];
                      var medicinesBrand = {
                        "index" : medicine['index'],
                        "brand_name" : medicine['brand_name'],
                        "brand_id" : medicine['brand_id'],
                        "form" : medicine['form'],
                        "strength" : medicine['strength'],
                        "company_name" : medicine['company_name'],
                        "company_id" : medicine['company_id'],
                        "generic_id" : medicine['generic_id'],
                        "generic_name" : medicine['generic_name'],
                      };

                      for(var doses in medicine['dose']){
                        var multiDose = {
                          "duration": doses['duration'],
                          "instruction": doses['instruction'],
                          "note": doses['note'],
                          "dose": doses['dose'],
                          "serial": doses['serial'],
                          "strength": doses['strength'],
                        };
                        multiDosesEchBrand.add(multiDose);
                      }

                      medicinesBrand['dose'] = multiDosesEchBrand;
                      medicines.add(medicinesBrand);

                    }
                  }

                  var jsonMedicine = jsonEncode(medicines);
                  var response =servError.value
                      ? ifServError().TemplateApiService(URL, "post", token, name, note, cc_text, diagnosis_text, onexam_text, investigation_text, investigation_report_text, jsonMedicine,)
                      :  await ApiCreateDbToServer().TemplateApiService(URL, "post", token, name, note, cc_text, diagnosis_text, onexam_text, investigation_text, investigation_report_text, jsonMedicine,);

                  if(response['success'] == true){
                    print(response);
                    var data = response['data'];
                    var uuid = data['uuid'];
                    var web_id = data['id'];
                    await commonController.updatePrescriptionTemplateServerToDb(boxPrescriptionTemplate,prescriptionTemplateId,web_id, uuid);
                  }
                  prescriptionDrugListEachPrescription.clear();
                  // var response =await ApiCreateDbToServer().ApiService(URL, "post", token, name);
                  // if(response['success'] == true){
                  //   var data = response['data'];
                  //   int id = data['generic_id'];
                  //   String uuid = data['uuid'];
                  //   String name = data['generic_name'];
                  //   await commonController.updateCommonServerToDb(boxDrugGeneric, PrescriptionModel(id: item.id, web_id: item.web_id, generic_id: id, generic_name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  // }
                }
              }
              // if(updateData.isNotEmpty){
              //   for(var item in newData){
              //     List prescriptionDrugListEachPrescription = [];
              //     int prescriptionTemplateId = item.id;
              //     int uuid = item.uuid;
              //     String name = item.template_name;
              //     String note = item.note ?? "";
              //     String cc_text = item.cc_data ?? "";
              //     String diagnosis_text = item.diagnosis_text ?? "";
              //     String onexam_text = item.on_data ?? "";
              //     String investigation_text = item.investigation_text ?? "";
              //     String investigation_report_text = item.investigation_data ?? "";
              //
              //     List templateDrug = await prescriptionTemplateBoxCRUDController.getPrescriptionTemplateDrug(boxPrescriptionTemplateDrug, prescriptionTemplateId);
              //
              //     if(templateDrug.isNotEmpty){
              //       for(var i =0; i<templateDrug.length; i++){
              //         var multipleDrugDoseEach = [];
              //         var drugId = templateDrug[i].id;
              //         var brandId = templateDrug[i].brand_id;
              //         List templateDrugDose =  await prescriptionTemplateBoxCRUDController.getPrescriptionTemplateDrugDose(boxPrescriptionTemplateDrugDose,prescriptionTemplateId, drugId);
              //         if(drugId !=-1){
              //           if(templateDrugDose.isNotEmpty){
              //             for(var j =0; j<templateDrugDose.length; j++){
              //               var doseId = templateDrugDose[j].id;
              //               var dose = templateDrugDose[j].doze ?? "";
              //               var duration = templateDrugDose[j].duration ?? "";
              //               var condition = templateDrugDose[j].condition ?? "";
              //               var note = templateDrugDose[j].note ?? "";
              //               var status = templateDrugDose[j].u_status;
              //               var genericId = templateDrugDose[j].generic_id;
              //               var drugDose = {"dose":dose ,"duration":duration,"instruction": condition,"comment": note ?? "", "serial": j.toString()};
              //               multipleDrugDoseEach.add(drugDose);
              //             }
              //           }
              //         }
              //         var brand = await prescriptionController.modifyDrugData.toList().firstWhere((element) => element['brand_id'] == brandId, orElse: () => null);
              //         if(brand !=null){
              //           brand["index"] = i;
              //           brand['dose'] = multipleDrugDoseEach;
              //           prescriptionDrugListEachPrescription.add(brand);
              //         }
              //       }
              //     }
              //
              //
              //     var medicines = [];
              //     if(prescriptionDrugListEachPrescription.isNotEmpty){
              //       for(var medicine in prescriptionDrugListEachPrescription){
              //         var multiDosesEchBrand = [];
              //         var medicinesBrand = {
              //           "index" : medicine['index'],
              //           "brand_name" : medicine['brand_name'],
              //           "brand_id" : medicine['brand_id'],
              //           "form" : medicine['form'],
              //           "strength" : medicine['strength'],
              //           "company_name" : medicine['company_name'],
              //           "company_id" : medicine['company_id'],
              //           "generic_id" : medicine['generic_id'],
              //           "generic_name" : medicine['generic_name'],
              //         };
              //
              //         for(var doses in medicine['dose']){
              //           var multiDose = {
              //             "duration": doses['duration'],
              //             "instruction": doses['instruction'],
              //             "note": doses['note'],
              //             "dose": doses['dose'],
              //             "serial": doses['serial'],
              //             "strength": doses['strength'],
              //           };
              //           multiDosesEchBrand.add(multiDose);
              //         }
              //
              //         medicinesBrand['dose'] = multiDosesEchBrand;
              //         medicines.add(medicinesBrand);
              //
              //       }
              //     }
              //
              //     var jsonMedicine = jsonEncode(medicines);
              //     var response =await ApiCreateDbToServer().TemplateApiService(URL + "/$uuid" , "put", token,
              //       name,
              //       note,
              //       cc_text,
              //       diagnosis_text,
              //       onexam_text,
              //       investigation_text,
              //       investigation_report_text,
              //       jsonMedicine,
              //     );
              //
              //     if(response['success'] == true){
              //       var data = response['data'];
              //       var uuid = data['uuid'];
              //       // await commonController.updatePrescriptionTemplateServerToDb(boxPrescriptionTemplate,prescriptionTemplateId,uuid);
              //     }
              //     prescriptionDrugListEachPrescription.clear();
              //     // var response =await ApiCreateDbToServer().ApiService(URL, "post", token, name);
              //     // if(response['success'] == true){
              //     //   var data = response['data'];
              //     //   int id = data['generic_id'];
              //     //   String uuid = data['uuid'];
              //     //   String name = data['generic_name'];
              //     //   await commonController.updateCommonServerToDb(boxDrugGeneric, PrescriptionModel(id: item.id, web_id: item.web_id, generic_id: id, generic_name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
              //     // }
              //   }
              // }
              // // if(updateData.isNotEmpty){
              // //   for(var item in updateData){
              // //     String name = item.generic_name;
              // //     String uuid = item.uuid;
              // //     var response =await ApiCreateDbToServer().ApiService(URL + '/$uuid', "put", token, name);
              // //     if(response['success'] == true){
              // //       await commonController.updateCommonServerToDb(boxDrugGeneric, DrugGenericModel(id: item.id, web_id: item.web_id, generic_id: item.generic_id, generic_name: item.generic_name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
              // //     }
              // //   }
              // // }
              // if(deleteData.isNotEmpty){
              //   for(var item in deleteData){
              //     String uuid = item.uuid;
              //     if(uuid.isNotEmpty){
              //       var response =await ApiCreateDbToServer().ApiService(URL + '/$uuid', "delete", token, '');
              //       if(response['success'] == true){
              //         await commonController.deleteCommonServerToDb(boxPrescriptionTemplate, item.uuid);
              //       }
              //     }
              //   }
              // }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.template, "${DateTime.now().toString()}");
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.templateDrug, "${DateTime.now().toString()}");
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.templateDrugDose, "${DateTime.now().toString()}");
            }
          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }

  Future<void> patientHistory(context)async{
    final historyController = Get.put(HistoryController());
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.PatientHistory}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi) {
            var response = await commonCRUDController.getAllDataCommon(boxPatientHistory, '');
            if(response.isNotEmpty){
              List newData =await response.where((data) => data.u_status == DefaultValues.NewAdd).toList();


              if(newData.isNotEmpty){
                var groupedData = groupBy(newData, (data) => data.patient_id);
                // Iterate over the grouped data
                groupedData.forEach((patientId, items) async {
                  String historyWebIdString = '';
                  for (var item in items) {
                    var historyWebId = historyController.box.values.toList().firstWhere((element) => element.id == item.history_id);
                    historyWebIdString = historyWebIdString + historyWebId.web_id.toString();
                  }
                  if(historyWebIdString.isNotEmpty){
                      var response =servError.value ? await ApiCreateDbToServer().PatientHistoryApiService(URL, "post", token, patientId,historyWebIdString) : await ApiCreateDbToServer().PatientHistoryApiService(URL, "post", token, patientId,historyWebIdString);
                      print(response);
                      if(response['success'] == true){
                        List<int> numberList = historyWebIdString.split('').map(int.parse).toList();
                        for(var item in items){
                          await commonController.updateHistoryServerToDb(boxPatientHistory, item.id, patientId);
                        }
                      }

                  }
                });



              }
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> favorite(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.Favorite}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxFavoriteIndex, '');
            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.favoriteDelete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  int id = item.id;
                  String segment = item.segment;
                  int favorite_id = item.favorite_id;
                  int status = DefaultValues.Update;
                  if(segment ==FavSegment.chiefComplain){
                    final index = await boxChiefComplain.values.toList().indexWhere((data) => data.id == favorite_id);
                    if(index != -1){
                      var existingData = await boxChiefComplain.getAt(index);
                      int? webIdFavorite = existingData?.web_id;
                      if(webIdFavorite != null){
                        favorite_id = webIdFavorite;
                      }
                    }
                  }
                  if(segment ==FavSegment.oE){
                    final index = await boxOnExamination.values.toList().indexWhere((data) => data.id == favorite_id);
                    if(index != -1){
                      var existingData = await boxOnExamination.getAt(index);
                      int? webIdFavorite = existingData?.id;
                      if(webIdFavorite != null){
                        favorite_id = webIdFavorite;
                      }

                    }
                  }
                  if(segment ==FavSegment.brand){
                    final index = await boxDrugBrand.values.toList().indexWhere((data) => data.id == favorite_id);
                    if(index != -1){
                      var existingData = await boxDrugBrand.getAt(index);
                      int? webIdFavorite = existingData?.id;
                      if(webIdFavorite != null){
                        favorite_id = webIdFavorite;
                      }
                    }
                  }
                  if(segment ==FavSegment.ia){
                    final index = await boxInvestigation.values.toList().indexWhere((data) => data.id == favorite_id);
                    if(index != -1){
                      var existingData = await boxInvestigation.getAt(index);
                      int? webIdFavorite = existingData?.id;
                      if(webIdFavorite != null){
                        favorite_id = webIdFavorite;
                      }
                    }
                  }
                  if(segment ==FavSegment.ir){
                    final index = await boxInvestigationReport.values.toList().indexWhere((data) => data.id == favorite_id);
                    if(index != -1){
                      var existingData = await boxInvestigationReport.getAt(index);
                      int? webIdFavorite = existingData?.id;
                      if(webIdFavorite != null){
                        favorite_id = webIdFavorite;
                      }
                    }
                  }
                  if(segment ==FavSegment.dia){
                    final index = await boxDiagnosis.values.toList().indexWhere((data) => data.id == favorite_id);
                    if(index != -1){
                      var existingData = await boxDiagnosis.getAt(index);
                      int? webIdFavorite = existingData?.id;
                      if(webIdFavorite != null){
                        favorite_id = webIdFavorite;
                      }
                    }
                  }
                  if(segment ==FavSegment.procedure){
                    final index = await boxProcedure.values.toList().indexWhere((data) => data.web_id == favorite_id);
                    if(index != -1){
                      var existingData = await boxProcedure.getAt(index);
                      int? webIdFavorite = existingData?.id;
                      if(webIdFavorite != null){
                        favorite_id = webIdFavorite;
                      }
                    }
                  }

                  var response = servError.value ? await ApiCreateDbToServer().FavoriteApiService(URL, "post", token, segment, favorite_id, 0) : await ApiCreateDbToServer().FavoriteApiService(URL, "post", token, segment, favorite_id, 1);
                  print("favorite response");
                  print(response);
                  if(response['success'] == true){
                    await commonController.updateFavoriteServerToDb(boxFavoriteIndex, id);
                    }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in newData){
                  int id = item.id;
                  String segment = item.segment;
                  int favorite_id = item.favorite_id;
                  int status = DefaultValues.Update;

                  if(segment ==FavSegment.chiefComplain){
                    final index = await boxChiefComplain.values.toList().indexWhere((data) => data.id == favorite_id);
                    if(index != -1){
                      var existingData = await boxChiefComplain.getAt(index);
                      int? webIdFavorite = existingData?.web_id;
                      if(webIdFavorite != null){
                        favorite_id = webIdFavorite;
                      }
                    }
                  }
                  if(segment ==FavSegment.oE){
                    final index = await boxOnExamination.values.toList().indexWhere((data) => data.id == favorite_id);
                    if(index != -1){
                      var existingData = await boxOnExamination.getAt(index);
                      int? webIdFavorite = existingData?.id;
                      if(webIdFavorite != null){
                        favorite_id = webIdFavorite;
                      }

                    }
                  }
                  if(segment ==FavSegment.brand){
                    final index = await boxDrugBrand.values.toList().indexWhere((data) => data.id == favorite_id);
                    if(index != -1){
                      var existingData = await boxDrugBrand.getAt(index);
                      int? webIdFavorite = existingData?.id;
                      if(webIdFavorite != null){
                        favorite_id = webIdFavorite;
                      }
                    }
                  }
                  if(segment ==FavSegment.ia){
                    final index = await boxInvestigation.values.toList().indexWhere((data) => data.id == favorite_id);
                    if(index != -1){
                      var existingData = await boxInvestigation.getAt(index);
                      int? webIdFavorite = existingData?.id;
                      if(webIdFavorite != null){
                        favorite_id = webIdFavorite;
                      }
                    }
                  }
                  if(segment ==FavSegment.ir){
                    final index = await boxInvestigationReport.values.toList().indexWhere((data) => data.id == favorite_id);
                    if(index != -1){
                      var existingData = await boxInvestigationReport.getAt(index);
                      int? webIdFavorite = existingData?.id;
                      if(webIdFavorite != null){
                        favorite_id = webIdFavorite;
                      }
                    }
                  }
                  if(segment ==FavSegment.dia){
                    final index = await boxDiagnosis.values.toList().indexWhere((data) => data.id == favorite_id);
                    if(index != -1){
                      var existingData = await boxDiagnosis.getAt(index);
                      int? webIdFavorite = existingData?.id;
                      if(webIdFavorite != null){
                        favorite_id = webIdFavorite;
                      }
                    }
                  }
                  if(segment ==FavSegment.procedure){
                    final index = await boxProcedure.values.toList().indexWhere((data) => data.web_id == favorite_id);
                    if(index != -1){
                      var existingData = await boxProcedure.getAt(index);
                      int? webIdFavorite = existingData?.id;
                      if(webIdFavorite != null){
                        favorite_id = webIdFavorite;
                      }
                    }
                  }

                  var response =servError.value ? await ApiCreateDbToServer().FavoriteApiService(URL, "post", token, segment, favorite_id, 1) : await ApiCreateDbToServer().FavoriteApiService(URL, "post", token, segment, favorite_id, 0);
                  if(response['success'] == true){
                    await commonController.deleteFavoriteServerToDb(boxFavoriteIndex, id);
                    }
                }
              }

            }
          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> generalSetting(context)async{
    final generalSettingController = Get.put(GeneralSettingController());
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.desktopSettingsGeneral}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    var lastSync = await getStoreKeyWithValue(syncTimeSharedPrefsKey.generalSettings);
    print("upload call start $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxGeneralSetting, '');
              List AppointmentPage = [];
              List PrescriptionCreatePage = [];
              List PrescriptionPrintPage = [];
             DateTime lastUpdatedDate =  await generalSettingController.getData();
            print(lastSync);
            print(lastUpdatedDate);
            if(response.isNotEmpty){
              if(timeDifference(lastSync.toString(), lastUpdatedDate)){
                print("Server insert");
                AppointmentPage.clear;
                PrescriptionCreatePage.clear;
                PrescriptionPrintPage.clear;
                for(int i = 0; i < response.length; i++){
                  print(response[i].section);
                }
                for(var item in response){
                  if(item.section == 'AppointmentPage'){
                    AppointmentPage.add(item.label);
                  }
                  if(item.section == Settings.settingHome){
                    PrescriptionCreatePage.add(item.label);
                  }

                  if(item.section == 'PrescriptionPrintPage'){
                    PrescriptionPrintPage.add(item.label);
                  }
                }
                var settings ={
                  settingAppointment: AppointmentPage,
                  Settings.settingHome:PrescriptionCreatePage,
                  "PrescriptionPrintPage":PrescriptionPrintPage
                };
                var settingsJson = jsonEncode(settings);
                var responseSer = servError.value ? await ApiCreateDbToServer().generalSettingsApiService(URL, "post", token, settingsJson) : await ApiCreateDbToServer().generalSettingsApiService(URL, "post", token, settingsJson);

              }else{
                print("server not insert");
              }

            }
             Future.delayed(Duration(seconds: 1));
            await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.generalSettings, "${DateTime.now().toString()}");
          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }
  Future<void>chamberCreate()async{
      String URL = '${ApiCUD.BaseUrl}${ApiCUD.chambers}';
      String token = await Helpers().checkToken();
      bool isInternet = await InternetConnectionStatus();
      print("upload call start $URL");
     try{
       if(isInternet){
         if(token.isNotEmpty){
           var chambers = await commonCRUDController.getAllDataCommon(boxChamber, '');
           List newData =await chambers.where((data) => data.u_status == DefaultValues.NewAdd).toList();
           List deleteData =await chambers.where((data) => data.u_status == DefaultValues.Delete).toList();
           List updateData =await chambers.where((data) => data.u_status == DefaultValues.Update).toList();
           if(newData.isNotEmpty){
             for(var i = 0; i<newData.length; i++){
               var chamber_name = newData[i].chamber_name;
               var chamber_id = newData[i].id;
               var response =servError.value ?  await ifServError().chamberApiService(URL, "post", token, chamber_name) : await ApiCreateDbToServer().chamberApiService(URL, "post", token, chamber_name);
               if(response['success'] == true){
                 var data = response['data'];
                 int web_id = data['id'];
                 await commonController.updateChamber(boxChamber, chamber_id, web_id);
                 // await getChamberList();
                 // chamberNameController.clear();
                 // Navigator.pop(Get.context!);
               }
             }
           }
           if(updateData.isNotEmpty){
             for(var i = 0; i<updateData.length; i++){
               var chamber_name = updateData[i].chamber_name;
               var id = updateData[i].id;
               var web_id = updateData[i].web_id;
               if(web_id != null){
                 var response =servError.value ?  await ifServError().chamberApiService(URL + '/$web_id?name=$chamber_name' , "put", token, chamber_name) : await ApiCreateDbToServer().chamberApiService(URL + '/$web_id?name=$chamber_name' , "put", token, chamber_name);
                 if(response['success'] == true){
                   await commonController.updateChamber(boxChamber, id, web_id);
                 }
               }

             }

           }
           if(deleteData.isNotEmpty){
             for(var i = 0; i<deleteData.length; i++){
               var chamber_name = deleteData[i].chamber_name;
               var id = deleteData[i].id;
               var chamber_id = deleteData[i].web_id;
               if(chamber_id != null){
                 var response =servError.value ?  await ifServError().chamberApiService(URL + '/$chamber_id' , "delete", token, '') : await ApiCreateDbToServer().chamberApiService(URL + '/$chamber_id' , "delete", token, '');
                 if(response['success'] == true){
                   await commonController.removeChamber(boxChamber, id);
                   Helpers.successSnackBar("Success", "Chamber Update Successfully");
                 }
               }

             }

           }

         }
       }else{
         Helpers.errorSnackBar("Failed", "Internet Connection Failed");
       }
     }catch(e){
       print(e);
     }

  }
  Future<void>irReportImage()async{
      String URL = '${ApiCUD.BaseUrl}${ApiCUD.inReportImage}';
      String token = await Helpers().checkToken();
      bool isInternet = await InternetConnectionStatus();
      print("upload call start $URL");
     try{
       if(isInternet){
         if(token.isNotEmpty){
           var response = await commonCRUDController.getAllDataCommon(boxIRImage, '');
           List newData =await response.where((data) => data.u_status == DefaultValues.NewAdd).toList();

           List deleteData =await response.where((data) => data.u_status == DefaultValues.Delete).toList();
           List updateData =await response.where((data) => data.u_status == DefaultValues.Update).toList();
           if(newData.isNotEmpty){
             for(var item in newData){
               print(item.app_id);
               var appObject =await boxAppointment.values.toList().indexWhere((element) => element.id == item.app_id);
               print(appObject);
               if(appObject != -1){

                 item.app_id = await boxAppointment.getAt(appObject)!.web_id;
                 print(item.app_id);
                 var response = await patientIRApiService(URL, token, "post",item.url, item);
                 print(response);
                 if(response['success'] == true){
                   var data = response['data'];
                   item.web_id = data['id'];
                   item.uuid = data['uuid'];
                   item.u_status = DefaultValues.Synced;
                   await commonController.updateIRImage(boxIRImage, item);
                   // await getChamberList();
                   // chamberNameController.clear();
                   // Navigator.pop(Get.context!);
                 }
               }


             }
           }

         }
       }else{
         Helpers.errorSnackBar("Failed", "Internet Connection Failed");
       }
     }catch(e){
       print(e);
     }

  }
  Future<void>patientDiseaseImage()async{
      String URL = '${ApiCUD.BaseUrl}${ApiCUD.patientDisease}';
      String token = await Helpers().checkToken();
      bool isInternet = await InternetConnectionStatus();
      print("upload call start $URL");
     try{
       if(isInternet){
         if(token.isNotEmpty){
           var response = await commonCRUDController.getAllDataCommon(boxPaDiseaseImage, '');
           List newData =await response.where((data) => data.u_status == DefaultValues.NewAdd).toList();

           List deleteData =await response.where((data) => data.u_status == DefaultValues.Delete).toList();
           List updateData =await response.where((data) => data.u_status == DefaultValues.Update).toList();
           if(newData.isNotEmpty){
             for(var item in newData){
               print(item.app_id);
               var appObject =await boxAppointment.values.toList().indexWhere((element) => element.id == item.app_id);
               print(appObject);
               if(appObject != -1){

                 item.app_id = await boxAppointment.getAt(appObject)!.web_id;
                 var response = await patientDiseaseImageApiService(URL, token, "post",item.url, item);
                 print(response);
                 if(response['success'] == true){
                   var data = response['data'];
                   item.web_id = data['id'];
                   item.uuid = data['uuid'];
                   item.u_status = DefaultValues.Synced;
                   await commonController.updateIRImage(boxPaDiseaseImage, item);
                   // await getChamberList();
                   // chamberNameController.clear();
                   // Navigator.pop(Get.context!);
                 }
               }

             }
           }
           if(deleteData.isNotEmpty){

           }
         }
         print("end call start $URL");
       }else{
         Helpers.errorSnackBar("Failed", "Internet Connection Failed");
       }
     }catch(e){
       print(e);
     }

  }

  Future<void>profileImage()async{
      String URL = '${ApiCUD.BaseUrl}${ApiCUD.profileImage}';
      String token = await Helpers().checkToken();
      bool isInternet = await InternetConnectionStatus();
      print("upload call start $URL");
     try{
       if(isInternet){
         if(token.isNotEmpty){
           var response = await boxUserInfo.values.toList(); ;
             if(response.isNotEmpty){
               for(var item in response){
                 var response = servError.value ?  await error_profileImageApiService(URL, token, "post",item.profile_image!, item) : await profileImageApiService(URL, token, "post",item.profile_image!, item);
                 print(response);
               }
             }

         }
         print("end call start $URL");
       }else{
         Helpers.errorSnackBar("Failed", "Internet Connection Failed");
       }
     }catch(e){
       print(e);
     }

  }
  Future<void> prescriptionLayoutSetting(context)async{
    print("my print setting");
    ChamberController chamberController = Get.put(ChamberController());
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.desktopSettingsPrescriptionLayout}';
    String URLHeader = '${ApiCUD.BaseUrl}${ApiCUD.imageHeaderUpload}';
    String URLFooter = '${ApiCUD.BaseUrl}${ApiCUD.imageFooterUpload}';
    String URLRxIcon = '${ApiCUD.BaseUrl}${ApiCUD.rxIcon}';
    String URLSignature = '${ApiCUD.BaseUrl}${ApiCUD.signature}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.prescriptionLayoutSettings);
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxPrescriptionPrintLayout, '');
            if(response.isNotEmpty){
              List imageList = [];
              imageList.clear();
              List printSetUpList = [];
              printSetUpList.clear();
              for(var i =0; i< response.length; i++){
                var item = response[i];
                  var chamberIndex = await chamberController.boxChamber.values.toList().indexWhere((element) => element.id == item.chamber_id);
                if(chamberIndex != -1){
                  var chamber = chamberController.boxChamber.getAt(chamberIndex)!;
                   var chamberWeb_id = chamber.web_id;
                   var localTableDateTime = DateTime.parse(item.date.toString());
                    print("timeDifference(lastSyncDate, localTableDateTime)");
                    print(timeDifference(lastSyncDate, localTableDateTime));
                   if(chamberWeb_id != null){
                     var images = {
                       "header_image": item.header_image ,
                       "footer_image": item.footer_image,
                       "digital_signature_image": item.digital_signature,
                       "rx_icon_image": item.rx_icon,
                       "background_image": item.background_image,
                       "chamber_id": chamberWeb_id,
                     };
                     var prescriptionLayout = {
                       "page_width": item.page_width,
                       "page_height": item.page_height,
                       "font_size": item.font_size,
                       "font_size_pa_info": item.font_size_pa_info,
                       "font_color": item.font_color,
                       "top_mergin": item.top_mergin,
                       "right_mergin": item.right_mergin,
                       "bottom_mergin": item.bottom_mergin,
                       "left_mergin": item.left_mergin,
                       "sidebar_width": item.sidebar_width,
                       "header_height": item.header_height,
                       "header_full_conten": item.header_full_conten,
                       "header_two_column_left": item.header_two_column_left,
                       "header_two_column_right": item.header_two_column_right,
                       "header_three_column_left": item.header_three_column_left,
                       "header_three_column_center": item.header_three_column_center,
                       "header_three_column_right": item.header_three_column_right,
                       "footer_height": item.footer_height,
                       "footer_content": item.footer_content,
                       "ph_font_color": item.ph_font_color,
                       "ph_background_color": item.ph_background_color,
                       "web_id": item.web_id,
                       "print_header_footer_or_none": item.print_header_footer_or_none,
                       "clinicalDataMargin": item.clinicalDataMargin,
                       "brandDataMargin": item.brandDataMargin,
                       "rxDataStartingTopMargin": item.rxDataStartingTopMargin,
                       "clinicalDataStartingTopMargin": item.clinicalDataStartingTopMargin,
                       "marginBeforePatientName": item.marginBeforePatientName,
                       "marginBeforePatientAge": item.marginBeforePatientAge,
                       "marginBeforePatientId": item.marginBeforePatientId,
                       "marginBeforePatientGender": item.marginBeforePatientGender,
                       "marginBeforePatientDate": item.marginBeforePatientDate,
                       "clinicalDataPrintingPerPage": item.clinicalDataPrintingPerPage,
                       "brandDataPrintingPerPage": item.brandDataPrintingPerPage,
                       "clinicalAndBrandDataPerPageGap": item.clinicalAndBrandDataPerPageGap,
                       "marginAroundFullPage": item.marginAroundFullPage,
                       "chamber_id": chamberWeb_id,
                       "advice_gap": item.advice_gap,
                     };
                     imageList.add(images);
                     printSetUpList.add(prescriptionLayout);
                   }
                }
              }
              var printLayoutSettingsJson = jsonEncode(printSetUpList);
              print(printLayoutSettingsJson);
              var responseSer = servError.value ? await ApiCreateDbToServer().prescriptionLayoutSettingsApiService(URL, "put", token, printLayoutSettingsJson) : await ApiCreateDbToServer().prescriptionLayoutSettingsApiService(URL, "post", token, printLayoutSettingsJson);
              print("responseSer");
              print(responseSer);
              try{
                for(var i =0; i< imageList.length; i++) {
                  var item = imageList[i];

                  var header_image = item["header_image"];
                  var footer_image = item["footer_image"];
                  // var background_image = item["background_image"];
                  var rx_icon_image = item["rx_icon_image"];
                  var digital_signature_image = item["digital_signature_image"];

                 try{
                   var chamber_id = item["chamber_id"];
                   if(header_image !=null && header_image !="" && header_image.isNotEmpty){
                     Uint8List imageDataHeader = Uint8List.fromList(header_image);
                     var responseHeader =await imageUpload(URLHeader, imageDataHeader,'header',chamber_id, token);
                     print(responseHeader);
                   }
                   if(footer_image !=null && footer_image !="" && footer_image.isNotEmpty){
                     Uint8List imageDataFooter = Uint8List.fromList(footer_image);
                     var responseFooter =await imageUpload(URLFooter, imageDataFooter, 'footer', chamber_id, token);
                     print(responseFooter);

                   }
                   // if(background_image !=null && background_image !=""){
                   //   Uint8List imageDataBackground = Uint8List.fromList(background_image);
                   //   sendBackgroundImageToServer(URLBackground, imageDataBackground, token);
                   // // }
                   if(digital_signature_image !=null && digital_signature_image !="" && digital_signature_image.isNotEmpty){
                     Uint8List imageDataDigitalSignature = Uint8List.fromList(digital_signature_image);
                     var signRes =await sendDigitalSignImageToServer(URLSignature, imageDataDigitalSignature, chamber_id, token);
                     print(signRes);

                   }
                   if(rx_icon_image !=null && rx_icon_image !="" && rx_icon_image.isNotEmpty){
                     Uint8List imageDataRxIcon = Uint8List.fromList(rx_icon_image);
                     var rxRes = await sendRxIconImageToServer(URLRxIcon, imageDataRxIcon,chamber_id, token);
                     print(rxRes);
                   }

                 }catch(e){
                   print(e);
                 }

                }
              }catch(e){
                print(e);
              }
            }
            Future.delayed(Duration(seconds: 1));
            await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.prescriptionLayoutSettings, "${DateTime.now().toString()}");
          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
       print("Error : No Internet Connection");
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> historyCategory()async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.historyCategory}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxHistoryCategory, '');

            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  String name = item.name;
                  var response =servError.value ? await ifServError().ApiService(URL, "post", token, name) : await ApiCreateDbToServer().ApiService(URL, "post", token, name);
                  if(response['success'] == true){
                    var data = response['data'];
                    int id = data['id'];
                    String name = data['name'];
                    await commonController.updateCommonServerToDb(boxHistoryCategory, HistoryCategoryModel(id: item.id, web_id: id, name: name, uuid: '', u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String name = item.name;
                  String uid = item.web_id.toString();
                  var response =servError.value ? await ifServError().ApiService(URL + '/${uid}', "put", token, name) : await ApiCreateDbToServer().ApiService(URL + '/${uid}', "put", token, name);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxHistoryCategory, HistoryCategoryModel(id: item.id, web_id: item.web_id, name: item.name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  String webId = item.web_id.toString();
                  var response =servError.value ? await ifServError().ApiService(URL + '/${webId}', "delete", token, '') : await ApiCreateDbToServer().ApiService(URL + '/${webId}', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxHistoryCategory, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.historyCategory, "${DateTime.now().toString()}");
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
        print('Error No Internet Connection');
      }
    } catch(e){
      print(e);
    }
  }
  Future<void> historyNew()async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.historyCategory}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    bool statusApi = true;
    print("upload sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            var response = await  commonCRUDController.getAllDataCommon(boxHistory, '');

            if(response.isNotEmpty){
              List newData = response.where((data) => data.u_status == DefaultValues.NewAdd).toList();
              List updateData = response.where((data) => data.u_status == DefaultValues.Update).toList();
              List deleteData = response.where((data) => data.u_status == DefaultValues.Delete).toList();
              if(newData.isNotEmpty){
                for(var item in newData){
                  var response =servError.value ? await ifServError().HistoryNewApiService(URL, "post", token, item.name, item.category.toString()) : await ApiCreateDbToServer().HistoryNewApiService(URL, "post", token, item.name, item.category.toString());
                  if(response['success'] == true){
                    var data = response['data'];
                    int id = data['id'];
                    String name = data['name'];
                    await commonController.updateCommonServerToDb(boxHistory, HistoryModel(id: item.id, web_id: id, name: name, uuid: '', u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}", category: item.category, type: '' ));
                  }
                }
              }
              if(updateData.isNotEmpty){
                for(var item in updateData){
                  String name = item.name;
                  String category_id = item.category;
                  var response =servError.value ? await ifServError().HistoryNewApiService(URL + '/${item.web_id.toString()}', "put", token, name, category_id) : await ApiCreateDbToServer().HistoryNewApiService(URL + '/${item.web_id.toString()}', "put", token, name, category_id);
                  if(response['success'] == true){
                    await commonController.updateCommonServerToDb(boxHistory, HistoryModel(id: item.id, web_id: item.web_id, name: item.name, uuid: item.uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}", category: item.category, type: '' ));
                  }
                }
              }
              if(deleteData.isNotEmpty){
                for(var item in deleteData){
                  var response =servError.value ? await ifServError().ApiService(URL + '/${item.web_id.toString()}', "delete", token, '') : await ApiCreateDbToServer().ApiService(URL + '/${item.web_id.toString()}', "delete", token, '');
                  if(response['success'] == true){
                    await commonController.deleteCommonDbServer(boxHistory, item.id);
                  }
                }
              }
              await Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.historyNew, "${DateTime.now().toString()}");
            }

          }
        }else{
          Helpers.errorSnackBar('Error', 'Invalid token');
        }
      }else{
        print('Error No Internet Connection');
      }
    } catch(e){
      print(e);
    }
  }

 Future SyncAll(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool HandshakeExceptionError = await prefs.getBool('HandshakeExceptionError') ?? false;
    print( "HandshakeExceptionError : $HandshakeExceptionError");
    servError.value = HandshakeExceptionError;

   syncStatus.value = true;

   currentSyncingData.value = "Chief Complain";
    await updateProgress(0.0);
    await chiefComplainMethod(context);
    await updateProgress(0.1);


   currentSyncingData.value = "On Examination";
    await onExaminationMethod(context);
   await updateProgress(0.150);

   currentSyncingData.value = "onExamination Category";
    await onExaminationCategoryMethod(context);
   await updateProgress(0.200);

   currentSyncingData.value = "Investigation Advice";
    await investigationAdviceMethod(context);
    await updateProgress(0.250);

    currentSyncingData.value = "Diagnosis";
    await diagnosisMethod(context);
    await updateProgress(0.300);

    currentSyncingData.value = "Investigation Report";
    await investigationReportMethod(context);
    await updateProgress(0.350);

    currentSyncingData.value = "Procedure";
    await procedureMethod(context);
    await updateProgress(0.400);


    currentSyncingData.value = "Advice";
    await adviceMethod(context);
    await updateProgress(0.475);

    currentSyncingData.value = "Handout";
    await handOut(context);
    await updateProgress(0.500);

    currentSyncingData.value = "Instruction";
    await instructionMethod(context);
    await updateProgress(0.530);

    currentSyncingData.value = "Dose";
    await doseMethod(context);
    await updateProgress(0.550);

    currentSyncingData.value = "Duration";
    await durationMethod(context);
    await updateProgress(0.575);

    currentSyncingData.value = "Company";
    await companyMethod(context);
    await updateProgress(0.590);

    currentSyncingData.value = "Generic";
    await genericMethod(context);
    await updateProgress(0.625);

    currentSyncingData.value = "Brand ";
    await brandMethod(context);
    await updateProgress(0.675);

   currentSyncingData.value = "Appointment";
    await appointment(context);
    await updateProgress(0.750);

   currentSyncingData.value = "Prescription";
    await prescription(context);
    await updateProgress(0.850);


    currentSyncingData.value = "Prescription Template";
    await prescriptionTemplate(context);
    await updateProgress(0.890);

    currentSyncingData.value = "Chamber";
    await chamberCreate();
    await updateProgress(0.900);

    if(loginController.selectedProfileType.value == "Doctor"){
      currentSyncingData.value = "General Setting";
      await generalSetting(context);
      await updateProgress(0.920);

      currentSyncingData.value = "Prescription Layout Setting";
      await prescriptionLayoutSetting(context);
      await updateProgress(0.950);
    }


    currentSyncingData.value = "Favorite";
    await favorite(context);
    await updateProgress(0.960);

    currentSyncingData.value = "Doctor";
    await doctorSync(context);
    await updateProgress(.970);

    currentSyncingData.value = "Referral";
    await referral(context);
    await updateProgress(.980);

    currentSyncingData.value = "Child History";
    await patientChildHistory(context);
    await updateProgress(.985);

    currentSyncingData.value = "Gyn and Obs History";
    await patientGynHistory(context);
    await updateProgress(.989);

    currentSyncingData.value = "Certificate";
    await medicalCertificate(context);
    await updateProgress(.990);
   //
    currentSyncingData.value = "Investigation Report";
    await irReportImage();
    await updateProgress(.993);
   //
    currentSyncingData.value = "Patient Disease Image";
    await patientDiseaseImage();
    await updateProgress(0.995);
   //
    currentSyncingData.value = "Profile Image";
    await profileImage();
    await updateProgress(1.0);

    currentSyncingData.value = "History Category";
    await historyCategory();
    await updateProgress(1.0);

    currentSyncingData.value = "History";
    await historyNew();
    await updateProgress(1.0);

    currentSyncingData.value = "Physician Notes";
    await physicianNotes(context);
    await updateProgress(1.0);

    currentSyncingData.value = "Treatment Plan";
    await treatmentPlan(context);
    await updateProgress(1.0);

   currentSyncingData.value = "Patient History";
   await patientHistory(context);
   await updateProgress(1.0);

   syncStatus.value = false;
   return true;
  }

  Future<void> updateProgress(double increment)async{
    updateSyncProgress.value = increment;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    updateSyncProgress;
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