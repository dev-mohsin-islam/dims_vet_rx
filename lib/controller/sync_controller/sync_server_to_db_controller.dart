

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/controller/chambers/chamber_controller.dart';
import 'package:dims_vet_rx/controller/child_history/child_history_controller.dart';
import 'package:dims_vet_rx/controller/general_setting/general_setting_controller.dart';
import 'package:dims_vet_rx/controller/gyn_and_obs/gyn_and_obs_controller.dart';
import 'package:dims_vet_rx/database/crud_operations/common_crud.dart';
import 'package:dims_vet_rx/models/appointment/appointment_model.dart';
import 'package:dims_vet_rx/models/chambers/chamber_model.dart';
import 'package:dims_vet_rx/models/create_prescription/prescription/prescription_model.dart';
import 'package:dims_vet_rx/models/create_prescription/prescription_drug/prescription_drug_model.dart';
import 'package:dims_vet_rx/models/doctors/doctor_model.dart';
import 'package:dims_vet_rx/models/favorite_index/favorite_index_model.dart';
import 'package:dims_vet_rx/models/general_setting_pages/prescription_print_layout_settings/prescription_print_layout_setting_model.dart';
import 'package:dims_vet_rx/models/general_setting_pages/setting_pages_model.dart';
import 'package:dims_vet_rx/models/handout/handout_model.dart';
import 'package:dims_vet_rx/models/history_category/history_category_model.dart';
import 'package:dims_vet_rx/models/imvestigation_report_image/investigation_report_image_model.dart';
import 'package:dims_vet_rx/models/patient/patient_model.dart';
import 'package:dims_vet_rx/models/patient_disease_image/patient_disease_image_model.dart';
import 'package:dims_vet_rx/models/patient_history/patient_history_model.dart';
import 'package:dims_vet_rx/models/prescription_template/prescription_template/prescription_template_model.dart';
import 'package:dims_vet_rx/models/prescription_template/prescription_template_drug/prescription_template_drug_model.dart';
import 'package:dims_vet_rx/models/prescription_template/prescription_template_drug_dose/prescription_template_drug_dose_model.dart';
import 'package:dims_vet_rx/utilities/app_strings.dart';
import 'package:dims_vet_rx/utilities/history_category.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/crud_operations/sync_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../models/advice/advice_model.dart';
import '../../models/chief_complain/chief_complain_model.dart';
import '../../models/company_name/company_name_model.dart';
import '../../models/create_prescription/prescription_drug_dose/prescription_drug_dose_model.dart';
import '../../models/create_prescription/prescription_duration/prescription_duration_model.dart';
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
import '../../models/patient_certificate/patient_certificate_model.dart';
import '../../models/patient_referral/patient_referral_model.dart';
import '../../models/procedure/procedure_model.dart';
import '../../services/api/db_to_server/data_upload_sync.dart';
import '../../services/api/server_to_db/data_download_sync.dart';
import '../../services/end_points_list.dart';
import '../../utilities/box_data_clear_refresh.dart';
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';
import '../general_setting/prescription_print_page_setup_controller.dart';


class SyncController extends GetxController{
  RxBool servError = false.obs;
  final SyncCRUDController commonController = SyncCRUDController();
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
  final Box<FavoriteIndexModel> boxFavoriteIndex = Boxes.getFavoriteIndex();

  final Box<PatientModel> boxPatient = Boxes.getPatient();
  final Box<AppointmentModel> boxAppointment = Boxes.getAppointment();
  final Box<PrescriptionModel> boxPrescription = Boxes.getPrescription();
  final Box<PrescriptionTemplateModel> boxTemplate = Boxes.getPrescriptionTemplate();
  final Box<PrescriptionTemplateDrugModel> boxTemplateDrug = Boxes.getPrescriptionTemplateDrug();
  final Box<PrescriptionTemplateDrugDoseModel> boxTemplateDrugDose = Boxes.getPrescriptionTemplateDrugDose();
  final Box<PatientHistoryModel>boxPatientHistory = Boxes.getPatientHistory();
  final Box<PrescriptionDrugModel> boxPrescriptionDrug = Boxes.getPrescriptionDrug();
  final Box<PrescriptionDrugDoseModel> boxPrescriptionDrugDose = Boxes.getPrescriptionDrugDose();
  final Box<SettingPagesModel> boxGeneralSettings = Boxes.getSettingPages();
  final Box<PrescriptionPrintLayoutSettingModel> boxPrescriptionLayout = Boxes.getPrescriptionPrintLayoutSettings();
  final Box<ChamberModel> boxChamber = Boxes.getChamber();
  final Box<DoctorModel> boxDoctor = Boxes.getDoctors();
  final Box<PatientReferralModel> boxReferral = Boxes.getPaReferral();
  final Box<PatientCertificateModel> boxCertificate = Boxes.getPatientCertificate();
  final Box<InvestigationReportImageModel> boxInvReImage = Boxes.getInvestigationReportImage();
  final Box<PatientDiseaseImageModel> boxPaDisImage = Boxes.getPatientDiseaseImage();
  final Box<HistoryCategoryModel> boxHistoryCat = Boxes.getHistoryCategory();

  RxBool syncStatus = false.obs;

  RxBool isBrandSync = false.obs;
 //000000212-0005
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

  RxDouble downloadSyncProgress = 0.0.obs;
  RxString currentSyncingData = ''.obs;


  Future<void> chiefComplainMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.ChiefComplain}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.cc);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.cc);
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String? updated_at = data[i]['updated_at'] ?? null;
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                  String name = data[i]['name'] ?? '';
                  String uuid = data[i]['uuid'] ?? '';
                  int id = data[i]['id'] ?? 0;
                  if(name.isNotEmpty && id != 0 && deleted_at ==null){
                    await commonController.saveCommonServerToDb(boxChiefComplain, ChiefComplainModel(id: 0, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                  if(deleted_at != null && uuid.isNotEmpty && id != 0){
                    await commonController.deleteCommonServerToDb(boxChiefComplain, uuid);
                  }
                }
              }
              if(data.isNotEmpty){
                statusApi = true;
                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.cc, page++);
                page = page++;
                continue;
              }else{

                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.cc, 1);
                print("api call end $URL");
                statusApi = false;
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.cc, "${DateTime.now().toString()}");
                cc.value =  true;
                break;

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
  Future<void> onExaminationMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.OnExamination}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.onExamination);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.onExamination);
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String name = data[i]['name'] ?? '';
                  String uuid = data[i]['uuid'] ?? '';
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                  String? updated_at = data[i]['updated_at'] ?? null;
                  int id = data[i]['id'] ?? 0;
                  if(name.isNotEmpty && id != 0 && deleted_at == null){
                    await commonController.saveCommonServerToDb(boxOnExamination, OnExaminationModel(id: 0, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                  if(deleted_at != null && uuid.isNotEmpty && id != 0){
                    await commonController.deleteCommonServerToDb(boxOnExamination, uuid);
                  }
                }
              }
              if(data.isNotEmpty){
                statusApi = true;
                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.onExamination, page++);
                page = page++;
                continue;
              }else{

                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.onExamination, 1);
                statusApi = false;
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.onExamination, "${DateTime.now().toString()}");
                onExamination.value =  true;
                break;

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
  Future<void> onExaminationCategoryMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.OnExaminationCategory}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.onExaminationCategory);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.onExaminationCategory);
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String name = data[i]['name'] ?? '';
                  String uuid = data[i]['uuid'] ?? '';
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                  String? updated_at = data[i]['updated_at'] ?? null;
                  int id = data[i]['id'] ?? 0;
                  if(name.isNotEmpty && id != 0 && deleted_at == null){
                    await commonController.saveCommonServerToDb(boxOnExaminationCategory, OnExaminationCategoryModel(id: 0, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                  if(deleted_at != null && uuid.isNotEmpty && id != 0){
                    await commonController.deleteCommonServerToDb(boxOnExamination, uuid);
                  }
                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.onExaminationCategory, page++);
                page = page++;
                continue;
              }else{

                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.onExaminationCategory, 1);
                statusApi = false;
                print("api call end $URL");

                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.onExaminationCategory, "${DateTime.now().toString()}");
                onExaminationCategory.value =  true;
                break;

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
  Future<void> investigationAdviceMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.Investigation}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.investigationAdvice);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.investigationAdvice);;
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String name = data[i]['name'] ?? '';
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                  String? update_at = data[i]['updated_at'] ?? null;
                  String uuid = data[i]['uuid'] ?? '';
                  int id = data[i]['id'] ?? 0;
                  if(name.isNotEmpty && id != 0 && deleted_at == null){
                    await commonController.saveCommonServerToDb(boxInvestigation, InvestigationModal(id: 0, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }

                  if(deleted_at != null && uuid.isNotEmpty && id != 0){
                    await commonController.deleteCommonServerToDb(boxInvestigation, uuid);
                  }
                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.investigationAdvice, page++);
                page = page++;
                continue;
              }else{

                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.investigationAdvice, 1);
                statusApi = false;
                print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.investigationAdvice, "${DateTime.now().toString()}");
                investigationAdvice.value =  true;
                break;
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
  Future<void> diagnosisMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.Diagnosis}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.diagnosis);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.diagnosis);
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String name = data[i]['name'] ?? '';
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                  String? updated_at = data[i]['updated_at'] ?? null;
                  String uuid = data[i]['uuid'] ?? '';
                  int id = data[i]['id'] ?? 0;
                  if(name.isNotEmpty && id != 0 && deleted_at == null){
                    await commonController.saveCommonServerToDb(boxDiagnosis, DiagnosisModal(id: 0, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }

                  if(deleted_at != null && uuid.isNotEmpty && id != 0){
                    await commonController.deleteCommonServerToDb(boxDiagnosis, uuid);
                  }
                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.diagnosis, page++);
                page = page++;
                continue;
              }else{

                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.diagnosis, 1);
                statusApi = false;
                print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.diagnosis, "${DateTime.now().toString()}");
                diagnosis.value =  true;
                break;
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
  Future<void> investigationReportMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.InvestigationReport}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.investigationReport);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.investigationReport);
    int per_page = 50;
    bool statusApi = true;
print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];

              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String name = data[i]['name'] ?? '';
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                  String? updated_at = data[i]['updated_at'] ?? null;
                  String uuid = data[i]['uuid'] ?? '';
                  int id = data[i]['id'] ?? 0;
                  if(name.isNotEmpty && id != 0 && deleted_at == null){
                    await commonController.saveCommonServerToDb(boxInvestigationReport, InvestigationReportModel(id: 0, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }

                  if(deleted_at != null && uuid.isNotEmpty && id != 0){
                    await commonController.deleteCommonServerToDb(boxInvestigationReport, uuid);
                  }
                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.investigationReport, page++);
                page = page++;
                continue;
              }else{

                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.investigationReport, 1);
                statusApi = false;
                print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.investigationReport, "${DateTime.now().toString()}");
                investigationReport.value =  true;
                break;

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
  Future<void> procedureMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.Procedure}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.procedure);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.procedure);
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];

              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String name = data[i]['name'] ?? '';
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                  String? updated_at = data[i]['updated_at'] ?? null;
                  String uuid = data[i]['uuid'] ?? '';
                  int id = data[i]['id'] ?? 0;
                  if(name.isNotEmpty && id != 0 && deleted_at == null){
                    var response = await commonController.saveCommonServerToDb(boxProcedure, ProcedureModel(id: 0, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }

                  if(deleted_at != null && uuid.isNotEmpty){
                   var response = await commonController.deleteCommonServerToDb(boxProcedure, uuid);

                  }
                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.procedure, page++);
                page = page++;
                continue;
              }else{

                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.procedure, 1);
                statusApi = false;
                print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.procedure, "${DateTime.now().toString()}");
                procedure.value =  true;
                break;
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
  Future<void> historyMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.History}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.history);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.history);
    int per_page = 50;
    bool statusApi = true;
    print("download sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);

              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String name = data[i]['name'] ?? '';
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                   String? updated_at = data[i]['updated_at'] ?? null;
                  String uuid = data[i]['uuid'] ?? '';
                  String type = data[i]['type'] ?? '';
                  int id = data[i]['id'] ?? 0;
                  if(name.isNotEmpty && id != 0 && deleted_at == null){
                    await commonController.saveCommonServerToDb(boxHistory, HistoryModel(id: 0, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, type: type, category: type, date: "${DateTime.now().toString()}", ));
                  }
                  // if(updated_at != null && id != 0 && deleted_at == null){
                  //   await commonController.updateCommonServerToDb(boxHistory, HistoryModel(id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, type: type, category: type,date: "${DateTime.now().toString()}" ));
                  // }
                  if(deleted_at != null && uuid.isNotEmpty && id != 0){
                    await commonController.deleteCommonServerToDb(boxHistory, uuid);
                  }
                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.history, page++);
                page = page++;
                continue;
              }else{

                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.history, 1);
                statusApi = false;print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.history, "${DateTime.now().toString()}");
                history.value =  true;
                break;
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
  Future<void> adviceMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.Advice}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.advice);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.advice);
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String label = data[i]['label'] ?? '';
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                   String? updated_at = data[i]['updated_at'] ?? null;
                  String uuid = data[i]['uuid'] ?? '';
                  String text = data[i]['text'] ?? '';
                  int id = data[i]['id'] ?? 0;
                  if(label.isNotEmpty && id != 0 && deleted_at == null){
                    await commonController.saveCommonServerToDb(boxAdvice, AdviceModel(id: 0, web_id: id, label: label, uuid: uuid, u_status: DefaultValues.Synced, text: text, date: "${DateTime.now().toString()}", ));
                  }

                  if(deleted_at != null && uuid.isNotEmpty && id != 0){
                    await commonController.deleteCommonServerToDb(boxAdvice, uuid);
                  }
                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.advice, page++);
                page = page++;
                continue;
              }else{
                statusApi = false;
                print("api call end $URL");
                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.advice, 1);
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.advice, "${DateTime.now().toString()}");
                advice.value =  true;
                break;
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
  Future<void> handoutMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.HandOut}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.handout);
    int page = 1;
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];

              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String label = data[i]['label'] ?? '';
                  int category_id = data[i]['category_id'] ?? '';
                  String? deleted_at = data[i]['deleted_at'];
                  String uuid = data[i]['uuid'] ?? '';
                  String text = data[i]['text'] ?? '';
                  int id = data[i]['id'];
                  if(label.isNotEmpty && id != 0 && deleted_at == null){
                    await commonController.saveCommonServerToDb(boxHandout, HandoutModel(id: 0, label: label, web_id: id, category_id: category_id, uuid: uuid, u_status: DefaultValues.Synced, text: text, date: "${DateTime.now().toString()}", ));
                  }
                  if(deleted_at != null && id != 0){
                    await commonController.deleteCommonServerToDb(boxHandout, id);
                  }
                }
              }
              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.handout, page++);
                page = page++;
                continue;
              }else{
                statusApi = false;
                print("api call end $URL");
                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.handout, 1);
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.handout, "${DateTime.now().toString()}");
                handout.value =  true;
                break;
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
    handout.value =  true;
  }
  Future<void> instructionMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.Instruction}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.instruction);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.instruction);
    int per_page = 50;
    bool statusApi = true;
    print("download sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String name = data[i]['name'] ?? '';
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                   String? updated_at = data[i]['updated_at'] ?? null;
                  String uuid = data[i]['uuid'] ?? '';
                  int id = data[i]['id'] ?? 0;
                  if(name.isNotEmpty && deleted_at == null){
                    await commonController.saveCommonServerToDb(boxInstruction, InstructionModel(id: 0, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}", ));
                  }

                  if(deleted_at != null && uuid.isNotEmpty && id != 0){
                    await commonController.deleteCommonServerToDb(boxInstruction, uuid);
                  }
                }
              }
              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.instruction, page++);
                page = page++;
                continue;
              }else{
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.instruction, 1);
                statusApi = false;print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.instruction, "${DateTime.now().toString()}");
                instruction.value = true;
                break;

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
  Future<void> doseMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.Dose}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.dose);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.dose);
    int per_page = 50;
    bool statusApi = true;
    print("Download sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              print("dose download");
              print(response);
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String name = data[i]['name'] ?? '';
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                   String? updated_at = data[i]['updated_at'] ?? null;
                  String uuid = data[i]['uuid'] ?? '';
                  int id = data[i]['id'] ?? 0;
                  if(name.isNotEmpty && deleted_at == null){
                    await commonController.saveCommonServerToDb(boxDose, DoseModel(id: 0, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}", ));
                  }

                  if(deleted_at != null && uuid.isNotEmpty && id != 0){
                    await commonController.deleteCommonServerToDb(boxDose, uuid);
                  }

                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.dose, page++);
                page = page++;
                continue;
              }else{

                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.dose, 1);
                statusApi = false;print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.dose, "${DateTime.now().toString()}");
                dose.value = true;
                break;

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
  Future<void> favoriteMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.Favorite}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.favorite);
    // String lastSyncDate = '2024-05-02 10:15:00';
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.favorite);
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);

              var data = response['data'] ?? [];
              print(data.length);
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  int favorite_id = data[i]['favorite_id'];
                  String segment = data[i]['segment'] ?? '';
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                  String? updated_at = data[i]['updated_at'] ?? null;

                  int id = data[i]['id'];
                  if(deleted_at == null){
                    await commonController.saveFavoriteServerToDb(boxFavoriteIndex, FavoriteIndexModel(id: 0, web_id: id, segment: segment, favorite_id: favorite_id, u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}", ));
                  }
                  if(deleted_at != null){
                    await commonController.deleteFavoriteToDb(boxFavoriteIndex, id);
                  }
                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.favorite, page++);
                page = page++;
                continue;
              }else{

                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.favorite, 1);
                statusApi = false;print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.favorite, "${DateTime.now().toString()}");
                dose.value = true;
                break;

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
  Future<void> durationMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.Duration}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.duration);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.duration);
    int per_page = 50;
    bool statusApi = true;
print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String name = data[i]['name'] ?? '';
                  int number = data[i]['number'] ?? '';
                  String type = data[i]['type'] ?? '';
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                   String? updated_at = data[i]['updated_at'] ?? null;
                  String uuid = data[i]['uuid'] ?? '';
                  int id = data[i]['id'] ?? 0;
                  if(name.isNotEmpty && id != 0 && deleted_at == null && uuid.isNotEmpty){
                    await commonController.saveCommonServerToDb(boxPrescriptionDuration, PrescriptionDurationModel(id: 0, web_id: id, name: name, uuid: uuid, u_status: DefaultValues.Synced, type: type, number: number, ));
                  }

                  if(deleted_at != null && uuid.isNotEmpty && id != 0){
                    await commonController.deleteCommonServerToDb(boxPrescriptionDuration, uuid);
                  }

                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.duration, page++);
                page = page++;
                continue;
              }else{

                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.duration, 1);
                statusApi = false;print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.duration, "${DateTime.now().toString()}");
                duration.value = true;
                break;
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
  Future<void> companyMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.Company}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.company);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.company);
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String company_name = data[i]['company_name'] ?? '';
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                   String? updated_at = data[i]['updated_at'] ?? null;
                  String uuid = data[i]['uuid'] ?? '';
                  int company_id = data[i]['company_id'] ?? 0;
                  if(company_name.isNotEmpty && company_id != 0 && deleted_at == null && uuid.isNotEmpty){
                    await commonController.saveCompanyCompanyServerToDb(boxCompanyName, CompanyNameModel(id: 0, web_id: company_id, company_name: company_name, uuid: uuid, u_status: DefaultValues.Synced, ));
                  }
                  if(company_id != 0 && deleted_at != null && uuid.isNotEmpty){
                    await commonController.deleteCommonCompanyServerToDb(boxCompanyName, uuid);
                  }
                }
              }


              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.company, page++);
                page = page++;
                continue;
              }else{

                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.company, 1);
                statusApi = false;print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.company, "${DateTime.now().toString()}");
                company.value = true;
                break;
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
  Future<void> genericMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.Generic}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.generic);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.generic);
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String generic_name = data[i]['generic_name'] ?? '';
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                   String? updated_at = data[i]['updated_at'] ?? null;
                  String uuid = data[i]['uuid'] ?? '';
                  int generic_id = data[i]['generic_id'] ?? 0;
                  if(generic_name.isNotEmpty && generic_id != 0 && deleted_at == null){
                    await commonController.saveCommonGenericServerToDb(boxDrugGeneric, DrugGenericModel(id: 0, web_id: generic_id, generic_name: generic_name, uuid: uuid, u_status: DefaultValues.Synced, ));
                  }

                  if(deleted_at != null && uuid.isNotEmpty){
                    await commonController.deleteCommonGenericServerToDb(boxDrugGeneric, uuid);
                  }
                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.generic, page++);
                page = page++;
                continue;
              }else{

                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.generic, 1);
                statusApi = false;print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.generic, "${DateTime.now().toString()}");
                generic.value = true;
                break;
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
  Future<void> brandMethod(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.Brand}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.brand);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.brand);
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  int brand_id = data[i]['brand_id'] ?? 0;
                  int generic_id = data[i]['generic_id'] ?? 0;
                  int company_id = data[i]['company_id'] ?? 0;
                  String brand_name = data[i]['brand_name'] ?? '';
                  var form = data[i]['form'] ?? '';
                  var strength = data[i]['strength'] ?? '';
                  String uuid = data[i]['uuid'] ?? '';
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                   String? updated_at = data[i]['updated_at'] ?? null;
                  if(brand_name.isNotEmpty && generic_id != 0 && company_id != 0 && brand_id != 0 && deleted_at == null){
                    await commonController.saveCommonBrandServerToDb(boxDrugBrand,   DrugBrandModel(id: brand_id, web_id: brand_id, brand_name: brand_name, generic_id: generic_id, company_id: company_id, form: form, strength: strength, uuid: uuid, u_status: DefaultValues.Synced, ));
                  }
                  if(deleted_at != null && uuid.isNotEmpty){
                    await commonController.deleteCommonBrandServerToDb(boxDrugBrand, uuid);
                  }
                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.brand, page++);
                page = page++;
                continue;
              }else{

                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.brand, 1);
                statusApi = false;print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.brand, "${DateTime.now().toString()}");
                brand.value = true;
                break;
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
  Future<void> patient(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.Patients}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    // String lastSyncDate = '2023-04-20';
    // int page =  1;
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.patient);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.patient);
    int per_page = 50;
    bool statusApi = true;
      print("sync start: $URL");
    try{
      if(isInternet){
         if(token.isNotEmpty){
          if(statusApi){
            for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              print("Patient Sync Data");
              print(response);
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  var id = data[i]['id'] ?? 0;
                  var name = data[i]['name'] ?? '';
                  var dob;
                  try{
                    if(data[i]['dob'] != null) {
                      dob = data[i]['dob'];
                    }
                  }catch(e){
                    print(e);
                  }
                  var sex = data[i]['sex'] ?? 0;
                  var maritual_status = data[i]['maritual_status'] ?? null;
                  var guardian_name = data[i]['guardian_name'] ?? null;
                  var phone = data[i]['phone'] ?? null;
                  var email = data[i]['email'] ?? null;
                  var area = data[i]['area'] ?? null;
                  var occupation = data[i]['occupation'] ?? null;
                  var blood_group = data[i]['blood_group'] ?? null;
                  var uuid = data[i]['uuid'] ?? '';
                  var deleted_at = data[i]['deleted_at'] ?? null;
                   var updated_at = data[i]['updated_at'] ?? null;

                  if(deleted_at == null && name.isNotEmpty && id != 0){
                    await commonController.savePatientServerToDb(boxPatient,PatientModel(
                        id: id,
                        web_id: id,
                        name: name,
                        uuid: uuid,
                        u_status: DefaultValues.Synced,
                        dob: dob,
                        sex: sex,
                        marital_status: maritual_status,
                        guardian_name: guardian_name,
                        phone: phone,
                        email: email,
                        area: area,
                        occupation: occupation,
                        blood_group: blood_group
                    ));
                  }
                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.patient, page++);
                page = page++;
                continue;
              }else{

                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.patient, 1);
                statusApi = false;
                print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.patient, "${DateTime.now().toString()}");
                brand.value = true;
                break;
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
  Future<void> patientGynHistory(context)async{
    final GynAndObsController gynAndObsController = Get.put(GynAndObsController());
    String URL = '${Syncs.BaseUrl}${Syncs.gynehistory}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    // String lastSyncDate = '2023-04-20';
    // int page =  1;
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.gynehistory);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.patient);
    int per_page = 50;
    bool statusApi = true;
      print("sync start: $URL");
    try{
      if(isInternet){
         if(token.isNotEmpty){
          if(statusApi){
            for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
               var data = response['data'] ?? [];
               var jsonData = json.decode(response['data'][0]['details']);;
              var gynAndObsHistory = jsonData['gynAndObsHistory'];
               var patientId = data[0]['patient_id'];
              if(gynAndObsHistory.isNotEmpty){
                for(int i = 0; i < gynAndObsHistory.length; i++) {
                  var history = gynAndObsHistory[i];
                  if(history != null){
                    await gynAndObsController.saveFromSeverToLocal(patientId, history);
                  }
                }

              }
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.gynehistory, "${DateTime.now().toString()}");
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
    final ChildHistoryController childHistoryController = Get.put(ChildHistoryController());
    String URL = '${Syncs.BaseUrl}${Syncs.childhistory}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    // String lastSyncDate = '2023-04-20';
    // int page =  1;
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.gynehistory);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.patient);
    int per_page = 50;
    bool statusApi = true;
      print("sync start: $URL");
    try{
      if(isInternet){
         if(token.isNotEmpty){
          if(statusApi){
            for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
               var data = response['data'] ?? [];
               var jsonData = json.decode(response['data'][0]['details']);;
              var childHistory = jsonData['childHistory'];
               var patientId = data[0]['patient_id'];
              if(childHistory.isNotEmpty){
                for(int i = 0; i < childHistory.length; i++) {
                  var history = childHistory[i];
                  if(history != null){
                    await childHistoryController.saveChildHistoryFromServeToLocal(patientId, history);
                  }
                }
              }
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.childHistory, "${DateTime.now().toString()}");
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
    if(await boxPatient.length == 0){
      await patient(context);
    }
    String URL = '${Syncs.BaseUrl}${Syncs.Appointment}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.appointment);
    print(' lastSyncDateAppointment: $lastSyncDate');
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.appointment);
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
         if(token.isNotEmpty){
          if(statusApi){
            for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              print("check appointment sync");
              print(response);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                try{
                  for(int i = 0; i < data.length; i++){
                    print(data[i]);
                    int id = data[i]['id'] ?? 0;
                    int patient_id = parseInt(data[i]['patient_id'] !=null ? data[i]['patient_id'] : 0);
                    String date = data[i]['date'] !=null ? customDateTimeFormat(DateTime.parse(data[i]['date'])) : '';


                    String next_visit = data[i]['next_visit'] !=null ? data[i]['next_visit'] : '';

                    int appointed_by = data[i]['appointed_by'] ?? 0;
                    int appointed_to = data[i]['appointed_to'] ?? 0;

                    int pulse = data[i]['pulse'] !=null ? data[i]['pulse'] : 0;
                    int sys_blood_pressure = data[i]['sys_blood_pressure'] !=null ? data[i]['sys_blood_pressure'] : 0;
                    int dys_blood_pressure = data[i]['dys_blood_pressure'] != null ? data[i]['dys_blood_pressure'] : 0;

                    String temperature =  '';
                    double weight = 0.0;
                    double height = 0.0;
                    double OFC = 0.0;
                    double waist = 0.0;
                    double hip = 0.0;
                    print(data[i]['temparature']);
                    try {
                      if (data[i]['temparature'] != null) {
                        if(data[i]['temparature'].toString().isNotEmpty){
                          temperature = data[i]['temparature'].toString();
                        }
                      }
                    } catch (e) {
                      print("Error parsing temparature: $e");
                    }
                    try {
                      if (data[i]['weight'] != null) {
                        weight = double.parse(data[i]['weight'].toString());
                      }
                    } catch (e) {
                      print("Error parsing weight: $e");
                      continue;
                    }

                    try {
                      if (data[i]['height'] != null) {
                        height = double.parse(data[i]['height'].toString());
                      }
                    } catch (e) {
                      print("Error parsing height: $e");
                    }

                    try {
                      if (data[i]['OFC'] != null) {
                        OFC = double.parse(data[i]['OFC'].toString());
                      }
                    } catch (e) {
                      print("Error parsing OFC: $e");
                    }

                    try {
                      if (data[i]['waist'] != null) {
                        waist = double.parse(data[i]['waist'].toString());
                      }
                    } catch (e) {
                      print("Error parsing waist: $e");
                    }

                    try {
                      if (data[i]['hip'] != null) {
                        hip = double.parse(data[i]['hip'].toString());
                      }
                    } catch (e) {
                      print("Error parsing hip: $e");
                    }

                    try{
                      int rr = data[i]['rr'] !=null ? data[i]['rr'] : 0;
                      String complain = data[i]['complain'] !=null ? data[i]['complain'] : '';
                      String medicine = data[i]['medicine'] !=null ? data[i]['medicine'] : '';
                      int improvement = data[i]['improvement'] !=null ? data[i]['improvement'] : 0;
                      int fee = data[i]['fee'] !=null ? data[i]['fee'] : 0;
                      int chamber_id = data[i]['chamber_id'] !=null ? data[i]['chamber_id'] : 0;
                      int status = data[i]['status'] !=null ? data[i]['status'] : 0;
                      int serial = data[i]['sl_no'] !=null ? data[i]['sl_no'] : 0;
                      String uuid = data[i]['uuid'] !=null ? data[i]['uuid'] : '';
                      String hospital_registration_no = data[i]['hospital_registration_no'] !=null ? data[i]['hospital_registration_no'] : '';
                      String? deleted_at = data[i]['deleted_at'];
                      int report_patient = data[i]['report_patient'] !=null ? data[i]['report_patient'] : 0;
                      var additionalData = data[i]['additional_data'];

                      if(patient_id != 0 && deleted_at == null){
                        await commonController.saveAppointmentServerToDb(boxAppointment, boxPatient,additionalData, AppointmentModel(
                          id: 0,
                          uuid: uuid,
                          u_status: DefaultValues.Synced,
                          patient_id: patient_id,
                          date: date,
                          appointed_by: appointed_by,
                          appointed_to: appointed_to,
                          status: 0,
                          next_visit: next_visit,
                          pulse: pulse,
                          sys_blood_pressure: sys_blood_pressure,
                          dys_blood_pressure: dys_blood_pressure,
                          temparature: temperature,
                          weight: weight,
                          height: height,
                          OFC: OFC,
                          waist: waist,
                          hip: hip,
                          rr: rr,
                          complain: complain,
                          medicine: medicine,
                          improvement: improvement,
                          fee: fee,
                          report_patient: report_patient,
                          hospital_id: hospital_registration_no,
                          serial: serial,
                          web_id: id,
                          chamber_id: chamber_id.toString(),
                        ));
                      }
                    }catch(e){
                      print(e);
                      continue;
                    }
                  }
                }catch(e){
                  print(e);
                  continue;
                }

              }else{
                print("Appointment Not found");
              }

              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.appointment, page++);
                page = page++;
                continue;
              }else{
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.appointment, 1);
                statusApi = false;
                print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.appointment, "${DateTime.now().toString()}");
                brand.value = true;
                break;
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
  Future<void> prescription(context)async{
    if(await boxAppointment.length == 0){
      await appointment(context);
    }
    String URL = '${Syncs.BaseUrl}${Syncs.Prescription}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.prescription);
    print(' lastSyncDatePrescription: $lastSyncDate');
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.prescription);
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];

              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  var id = data[i]['id'] ?? 0;
                  var note = data[i]['note'] ?? '';
                  var physical_findings = data[i]['physical_findings'] ?? '';
                  var uuid = data[i]['uuid'] ?? '';
                  var chamber_id = data[i]['chamber_id'] ?? '';
                  var cc_text = data[i]['cc_text'] != null ? data[i]['cc_text'] : '';
                  var diagnosis_text = data[i]['diagnosis_text'] !=null ? data[i]['diagnosis_text'] : '';
                  var investigation_text = data[i]['investigation_text'] !=null ? data[i]['investigation_text'] : '';
                  var onexam_text = data[i]['onexam_text'] !=null ? data[i]['onexam_text'] : '';
                  var investigation_report_text = data[i]['investigation_report_text'] !=null ? data[i]['investigation_report_text'] : '';
                  var special_note = data[i]['special_note'] !=null ? data[i]['special_note'] : '';
                  var treatment_plan = data[i]['treatment_plan'] !=null ? data[i]['treatment_plan'] : '';
                  var created_at = data[i]['created_at'] ?? '';
                  var updated_at = data[i]['updated_at'] ?? '';
                  var deleted_at = data[i]['deleted_at'] ?? null;

                  if(deleted_at == null){
                   await commonController.savePrescriptionServerToDb(boxPrescription, boxAppointment,  PrescriptionModel(
                      id: 0,
                      web_id : id,
                      u_status: DefaultValues.Synced,
                      appointment_id: 0,
                      note: note,
                      physical_findings: "",
                      uuid: uuid,
                      cc_text : cc_text,
                      diagnosis_text : diagnosis_text,
                      investigation_text: investigation_text,
                      onexam_text: onexam_text,
                      investigation_report_text: investigation_report_text,
                      special_notes: special_note,
                      treatment_plan: treatment_plan,
                      date: "${DateTime.now().toString()}",
                     chamber_id: chamber_id.toString(),
                    ));
                  }
                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.prescription, page++);
                page = page++;
                continue;
              }else{
                statusApi = false;
                print("api call end $URL");
                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.prescription, 1);
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.prescription, "${DateTime.now().toString()}");
                break;
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
  Future<void> prescriptionDrug(context)async{
    if(await boxPrescription.length == 0){
      await prescription(context);
    }
    String URL = '${Syncs.BaseUrl}${Syncs.PrescriptionDrug}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.prescriptionDrug);
    // String lastSyncDate = '2024-04-22';
    // print("lastSyncDate");
    // print(lastSyncDate);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.prescriptionDrug);
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];

              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  print(data[i]);
                   int id = data[i]['id'] ?? 0;
                   int prescription_id = data[i]['prescription_id'] ?? 0;
                   int brand_id = data[i]['brand_id'] ?? 0;
                   int generic_id = data[i]['generic_id'];
                   String strength = data[i]['strength'] ?? '';
                   String uuid = data[i]['uuid'] ?? '';
                   String created_at = data[i]['created_at'] ?? '';
                   String updated_at = data[i]['updated_at'] ?? '';
                   String? deleted_at = data[i]['deleted_at'];

                   var index = data[i]['index'] ?? null;
                   if(deleted_at == null){

                     await commonController.savePrescriptionDrugServerToDb(boxPrescriptionDrug,boxPrescription,  PrescriptionDrugModel(
                         id: 0,
                         web_id: id,
                         u_status: DefaultValues.Synced,
                         prescription_id: prescription_id,
                         generic_id: generic_id,
                         strength: strength,
                         doze: '',
                         duration: '',
                         uuid: uuid,
                         brand_id: brand_id,
                         condition: ''
                     ));
                   }
                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.prescriptionDrug, page++);
                page = page++;
                continue;
              }else{

                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.prescriptionDrug, 1);
                statusApi = false;
                print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.prescriptionDrug, "${DateTime.now().toString()}");
                brand.value = true;
                break;
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
  Future<void> prescriptionDrugDose(context)async{
    // if(await boxPrescriptionDrug.length == 0){
    //   await prescriptionDrug(context);
    // }
    String URL = '${Syncs.BaseUrl}${Syncs.PrescriptionDrugDose}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    // String lastSyncDate = '2024-04-22';
    // print("lastSyncDate");
    // print(lastSyncDate);
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.prescriptionDrugDose);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.prescriptionDrugDose);

    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
         if(token.isNotEmpty){
          if(statusApi){
            for(int i = 0; i < page; i++){
              var response = servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  print(data[i]);
                   int id = data[i]['id'];
                   int prescription_drug_id = data[i]['prescription_drug_id'];
                   String dose = data[i]['dose'] ?? "";
                   String duration = data[i]['duration'] ?? "";
                   String instruction = data[i]['instruction'] ?? "";
                   String note = data[i]['note'] ?? "";
                   int serial = data[i]['serial'] !=null ? data[i]['serial'] : 0;
                   String strength = data[i]['strength'] ?? '';
                   String created_at = data[i]['created_at'] ?? '';
                   String updated_at = data[i]['updated_at'] ?? '';
                   String? deleted_at = data[i]['deleted_at'];
                   if(deleted_at == null){
                      await commonController.savePrescriptionDrugDoseServerToDb(boxPrescriptionDrugDose, boxPrescriptionDrug,  PrescriptionDrugDoseModel(
                          id: 0,
                          web_id: id,
                          u_status: DefaultValues.Synced,
                          prescription_id: 0,
                          drug_id: prescription_drug_id,
                          doze: dose,
                          duration: duration,
                          condition: instruction,
                          note: note,
                          strength: strength,
                          generic_id: 0,
                          uuid: '',
                          dose_serial: serial,
                      ));
                   }
                }
              }
              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.prescriptionDrugDose, page++);
                page = page++;
                continue;
              }else{

                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.prescriptionDrugDose, 1);
                statusApi = false;
                print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.prescriptionDrugDose, "${DateTime.now().toString()}");
                brand.value = true;
                break;
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
  Future<void> prescriptionTemplate(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.PrescriptionTemplate}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.template);
    // String lastSyncDate = '2024-04-22';
    // print("lastSyncDate");
    // print(lastSyncDate);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.template);
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response = servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  print(data[i]);
                  var id = data[i]['id'] ?? 0;
                  var template_name = data[i]['template_name'] ?? "";
                  var note = data[i]['note'] ?? '';
                  var uuid = data[i]['uuid'] ?? '';
                  var cc_data = data[i]['cc_data'] ?? '';
                  var diagnosis_data = data[i]['diagnosis_data'] ?? '';
                  var investigation_data = data[i]['investigation_data'] ?? '';
                  var oe_data = data[i]['oe_data'] ?? '';
                  var investigation_report_text = data[i]['investigation_report_text'] ?? '';
                  var created_at = data[i]['created_at'] ?? '';
                  var updated_at = data[i]['updated_at'] ?? '';
                  var deleted_at = data[i]['deleted_at'] ?? null;

                  if(deleted_at == null){
                   await commonController.saveTemplateServerToDb(boxTemplate, PrescriptionTemplateModel(
                      id: 0,
                     template_name: template_name,
                      web_id : id,
                      u_status: DefaultValues.Synced,
                      cc_data: cc_data,
                      on_data: oe_data,
                      note: note,
                      uuid: uuid,
                      diagnosis_text : diagnosis_data,
                      investigation_data : investigation_data,
                      investigation_text: investigation_report_text,
                      date: created_at,
                      user_id: 0,

                    ));
                  }
                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.template, page++);
                page = page++;
                continue;
              }else{

                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.template, 1);
                statusApi = false;
                print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.template, "${DateTime.now().toString()}");
                brand.value = true;
                break;
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
  Future<void> prescriptionTemplateDrug(context)async{
    if(await boxTemplate.length == 0){
      await prescriptionTemplate(context);
    }
    String URL = '${Syncs.BaseUrl}${Syncs.PrescriptionTemplateDrug}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.templateDrug);
    // String lastSyncDate = '2024-04-22';
    // print("lastSyncDate");
    // print(lastSyncDate);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.templateDrug);
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response = servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];

              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  print(data[i]);
                   int template_id = data[i]['template_id'] !=null ? data[i]['template_id'] : 0;
                   int id = data[i]['id'] !=null ? data[i]['id'] : 0;
                   int brand_id = data[i]['brand_id'] !=null ? data[i]['brand_id'] : 0;
                   int generic_id = data[i]['generic_id'] ?? 0;
                   String strength = data[i]['strength'] ?? '';
                   String uuid = data[i]['uuid'] ?? '';
                   String created_at = data[i]['created_at'] ?? '';
                   String updated_at = data[i]['updated_at'] ?? '';
                   String? deleted_at = data[i]['deleted_at'] ?? null;
                   if(deleted_at == null){
                     await commonController.saveTemplateDrugServerToDb(boxTemplateDrug,boxTemplate,  PrescriptionTemplateDrugModel(
                         id: 0,
                         web_id: id,
                         u_status: DefaultValues.Synced,
                         brand_id: brand_id,
                         template_id: template_id,
                         generic_id: generic_id,
                         strength: strength,
                         doze: '',
                         duration: '',
                         uuid: uuid,
                         condition: ''
                     ));
                   }
                }
              }

              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.templateDrug, page++);
                page = page++;
                continue;
              }else{

                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.templateDrug, 1);
                statusApi = false;print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.templateDrug, "${DateTime.now().toString()}");
                brand.value = true;
                break;
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
  Future<void> prescriptionTemplateDrugDose(context)async{
    if(await boxTemplateDrug.length == 0){
      await prescriptionTemplateDrug(context);
    }
    String URL = '${Syncs.BaseUrl}${Syncs.PrescriptionTemplateDrugDose}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.templateDrugDose);
    // String lastSyncDate = '2024-04-22';
    print("lastSyncDate");
    print(lastSyncDate);
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.templateDrugDose);

    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            print(page);
            print(statusApi);
            for(int i = 0; i < page; i++){
              var response = servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];

              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  print(data[i]);
                   try{
                     int id = data[i]['id'] ?? 0;
                     int template_drug_id =data[i]['template_drug_id'] !=null ? data[i]['template_drug_id'] : 0;
                     String dose = data[i]['dose'] ?? "";
                     String duration = data[i]['duration'] ?? "";
                     String instruction = data[i]['instruction'] ?? "";
                     String note = data[i]['note'] ?? "";
                     int serial = data[i]['serial'];
                     String strength = data[i]['strength'] ?? '';
                     String created_at = data[i]['created_at'] ?? '';
                     String updated_at = data[i]['updated_at'] ?? '';
                     String? deleted_at = data[i]['deleted_at'];

                     if(deleted_at == null ){
                       await commonController.saveTemplateDrugDoseServerToDb(boxTemplateDrugDose, boxTemplateDrug,  PrescriptionTemplateDrugDoseModel(
                         id: 0,
                         u_status: DefaultValues.Synced,
                         drug_id: template_drug_id,
                         doze: dose,
                         duration: duration,
                         condition: instruction,
                         note: note,
                         generic_id: 0,
                         uuid: '',
                         dose_serial: serial,
                         template_id: 0,
                       ));
                     }

                   }catch(e){
                     print(e);
                   }
                }
              }
              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.templateDrugDose, page++);
                 page = page++;
                continue;
              }else{

                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.templateDrugDose, 1);
                statusApi = false;
                print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.templateDrugDose, "${DateTime.now().toString()}");
                dose.value = true;
                break;
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

  Future<void> patientsPersonalHistory(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.PatientsPersonalHistory}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue('patientsPersonalHistory');
    int page = 1;
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response = servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                      var patient_id = data[i]['patient_id'];
                      var history_id = data[i]['history'];

                      var uuid = data[i]['uuid'] ?? '';
                      var deleted = data[i]['deleted_at'] ?? null;
                      var updated = data[i]['updated_at'] ?? null;
                      if(deleted == null){
                        await commonController.saveCommonServerToDb(boxPatientHistory, PatientHistoryModel(
                          id: 0,
                          patient_id: patient_id,
                          web_id: patient_id,
                          category: HistoryCategory.personalHistoryCategory,
                          u_status: DefaultValues.Synced,
                          history_id: history_id,
                          uuid: uuid,
                          date: DateTime.now().toString(),
                        ));
                      }
                      if(deleted != null){
                        await commonController.deleteCommonServerToDb(boxPatientHistory, uuid);
                      }
                }
              }
              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.onExamination, page++);
                page = page++;
                continue;
              }else{

                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.onExamination, 1);
                statusApi = false;print("api call end $URL");
                await setStoreKeyWithDefaultValue('patientsPersonalHistory', "${DateTime.now().toString()}");
                brand.value = true;
                break;
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
  Future<void> patientsAllergyHistory(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.PatientsAllergyHistory}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue('patientsAllergyHistory');
    int page = 1;
    int per_page = 50;
    bool statusApi = true;
print("sync start: $URL");
    try{
      // if(isInternet){
      //   if(token.isNotEmpty){
      //     if(statusApi){
       //       for(int i = 0; i < page; i++){
      //         var response =await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
      //         var data = response['data'] ?? [];
      //         if(data.isNotEmpty){
      //           for(int i = 0; i < data.length; i++){
      //                 var patient_id = data[i]['patient_id'];
      //                 var history_id = data[i]['history'];
      //                 var uuid = data[i]['uuid'] ?? '';
      //                 var deleted = data[i]['deleted_at'] ?? null;
      //                 var updated = data[i]['updated_at'] ?? null;
      //                 if(deleted == null){
      //                   await commonController.saveCommonServerToDb(boxPatientHistory, PatientHistoryModel(
      //                     id: 0,
      //                     patient_id: patient_id,
      //                     web_id: patient_id,
      //                     category: HistoryCategory.allergyHistoryCategory,
      //                     u_status: DefaultValues.Synced,
      //                     history_id: history_id,
      //                     uuid: uuid,
      //                     date: DateTime.now().toString(),
      //                   ));
      //                 }
      //                 if(deleted != null){
      //                   await commonController.deleteCommonServerToDb(boxPatientHistory, uuid);
      //                 }
      //           }
      //         }
      //         if(data.isNotEmpty){
      //           statusApi = true;
      //           page++;
      //           continue;
      //         }else{
      //           statusApi = false;print("api call end $URL");
      //           // await setStoreKeyWithDefaultValue('patientsAllergyHistory', "${DateTime.now().toString()}");
      //           brand.value = true;
      //           break;
      //         }
      //
      //       }
      //     }
      //   }else{
      //     Helpers.errorSnackBar('Error', 'Invalid token');
      //   }
      // }else{
      //  print("Error : No Internet Connection");
      // }
    } catch(e){
      print(e);
    }
  }

  Future<void> patientsFamilyHistory(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.PatientsFamilyHistory}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue('patientsFamilyHistory');
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.onExamination);
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                      var patient_id = data[i]['patient_id'];
                      var history_id = data[i]['history'];
                      var uuid = data[i]['uuid'] ?? '';
                      var deleted = data[i]['deleted_at'] ?? null;
                      var updated = data[i]['updated_at'] ?? null;
                      if(deleted == null){
                        await commonController.saveCommonServerToDb(boxPatientHistory, PatientHistoryModel(
                          id: 0,
                          patient_id: patient_id,
                          web_id: patient_id,
                          category: HistoryCategory.familyHistoryCategory,
                          u_status: DefaultValues.Synced,
                          history_id: history_id,
                          uuid: uuid,
                          date: DateTime.now().toString(),
                        ));
                      }
                      if(deleted != null){
                        await commonController.deleteCommonServerToDb(boxPatientHistory, uuid);
                      }
                }
              }
              if(data.isNotEmpty){
                statusApi = true;
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.patientsFamilyHistory, page++);
                page = page++;
                continue;
              }else{
                 await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.patientsFamilyHistory, 1);
                statusApi = false;print("api call end $URL");
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.patientsFamilyHistory, "${DateTime.now().toString()}");
                brand.value = true;
                break;
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
  Future<void> generalSettings(context)async{
    GeneralSettingController generalSettingController = Get.put(GeneralSettingController());
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.desktopSettingsGeneral}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.generalSettings);
    int page = 1;
    int per_page = 50;
    bool statusApi = true;
    print("download sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
             for(int i = 0; i < page; i++){
              var response =servError.value ? await ifServErrorApiCreateServerToDb().generalSettingsApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().generalSettingsApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              print(response);
              print(lastSyncDate);
              if(data['general_settings'] != null && data['general_settings'] !='null'){
                String serverUpdatedDate = DateTime.parse(data['updated_at'].toString()).toString() ?? '';
                DateTime lastUpdatedDate =  await generalSettingController.getData();
                try{
                  if(!timeDifference(serverUpdatedDate, DateTime.parse(lastSyncDate.toString()))){
                    print("download insert");
                    if(data['general_settings'].length > 0){
                      var AppointmentPage = data['general_settings'][Settings.appointment];
                      var PrescriptionPrintPage = data['general_settings'][Settings.print];
                      var PrescriptionCreatePage = data['general_settings'][Settings.settingHome];
                      if(AppointmentPage != null){
                        for(int i = 0; i < AppointmentPage.length; i++){
                          await commonController.saveGeneralSettingsServerToDb(boxGeneralSettings, SettingPagesModel(
                              id: 0, section: 'AppointmentPage', label: AppointmentPage[i],date: DateTime.now().toString(), u_status: DefaultValues.Synced
                          ));
                        }
                      }
                      if(PrescriptionPrintPage != null){
                        for(int i = 0; i < PrescriptionPrintPage.length; i++){
                          await commonController.saveGeneralSettingsServerToDb(boxGeneralSettings, SettingPagesModel(
                              id: 0, section: 'PrescriptionPrintPage', label: PrescriptionPrintPage[i],date: DateTime.now().toString(), u_status: DefaultValues.Synced
                          ));
                        }

                      }
                      if(PrescriptionCreatePage != null){
                        for(int i = 0; i < PrescriptionCreatePage.length; i++){
                          await commonController.saveGeneralSettingsServerToDb(boxGeneralSettings, SettingPagesModel(
                              id: 0, section: Settings.settingHome, date: DateTime.now().toString(), label: PrescriptionCreatePage[i], u_status: DefaultValues.Synced
                          ));
                        }
                      }
                    }else{
                      print("length not working");
                    }
                  }else{
                    print("Download not insert");
                  }
                }catch(e){
                  print(e);
                }

              }else{
                await generalSettingController.functionDefaultSettings();
              }
              statusApi = false;
              print("api call end $URL");
              Future.delayed(Duration(seconds: 1));
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.generalSettings, "${DateTime.now().toString()}");
              brand.value = true;
              break;
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

  Future<void> prescriptionLayoutSettingsNew(context)async{
    final PrescriptionPrintPageSetupController prescriptionPrintLayout = Get.put(PrescriptionPrintPageSetupController());
    CommonController commonCrudController = Get.put(CommonController());
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.desktopSettingsPrescriptionLayout}';
    String URLHeader = '${ApiCUD.BaseUrl}${ApiCUD.imageHeader}';
    String URLFooter = '${ApiCUD.BaseUrl}${ApiCUD.imageFooter}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.prescriptionLayoutSettings);
    int page = 1;
    int per_page = 50;
    bool statusApi = true;
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
              var response = servError.value ? await ifServErrorApiCreateServerToDb().prescriptionLayoutSettingsApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().prescriptionLayoutSettingsApiService(URL, token, lastSyncDate, page, per_page);
              var responseHeaderImg =await ApiCreateServerToDb().prescriptionLayoutSettingsApiService(URLHeader, token, lastSyncDate, page, per_page);
              var responseFooterImg =await ApiCreateServerToDb().prescriptionLayoutSettingsApiService(URLFooter, token, lastSyncDate, page, per_page);
              print("my print settings");
              print(response);
              var data = response['data'] ?? [];
                  if(data.isNotEmpty && data  != null){
                      if(data['prescription_layout'].length > 0){
                        try{
                          for(var item in data['prescription_layout']){
                            var chamberIndex = boxChamber.values.toList().indexWhere((element) => element.web_id == item['chamber_id']);
                            if(chamberIndex != -1){
                              var chamber =await boxChamber.getAt(chamberIndex)!;
                              var responseSetting = await prescriptionPrintLayout.getDataByChamberId(chamber.id);
                              if(responseSetting !=null && response['data']['updated_at'] != null){
                                String serverUpdateDate = DateTime.parse(response['data']['updated_at'].toString()).toString();
                                print(timeDifferenceNew(serverUpdateDate, responseSetting));
                                print(timeDifference(serverUpdateDate, responseSetting));
                                if(!timeDifference(serverUpdateDate, responseSetting)){
                                  print("Insert setting");
                                  prescriptionPrintLayout.headerFooterAndBgImage.clear();
                                  prescriptionPrintLayout.headerFooterAndBgImage.addAll(headerFooterAndBgImageC);
                                  prescriptionPrintLayout.pageWidthController.text = item['page_width'].toString(); //
                                  prescriptionPrintLayout.pageHeightController.text = item['page_height'].toString(); //
                                  prescriptionPrintLayout.pageSideBarWidthController.text = item['sidebar_width'].toString();
                                  prescriptionPrintLayout.pageHeaderHeightController.text = item['header_height'].toString();
                                  prescriptionPrintLayout.pageFooterHeightController.text = item['footer_height'].toString(); //
                                  prescriptionPrintLayout.pageFontSizeController.text = item['font_size'].toString();
                                  prescriptionPrintLayout.fontSizePaInfoController.text = item['font_size_pa_info'].toString();
                                  prescriptionPrintLayout.pageFontColorController.text = item[''].toString();
                                  prescriptionPrintLayout.pageMarginTopController.text = item['top_mergin'].toString(); //
                                  prescriptionPrintLayout.pageMarginBottomController.text = item['bottom_mergin'].toString(); //
                                  prescriptionPrintLayout.pageMarginLeftController.text = item['left_mergin'].toString(); //
                                  prescriptionPrintLayout.pageMarginRightController.text = item['right_mergin'].toString();
                                  prescriptionPrintLayout.clinicalDataMarginController.text = item['clinicalDataMargin'].toString();
                                  prescriptionPrintLayout.brandDataMarginController.text = item['brandDataMargin'].toString();
                                  prescriptionPrintLayout.rxDataStartingTopMarginController.text = item['page_width'].toString();
                                  prescriptionPrintLayout.clinicalDataStartingTopMarginController.text = item['clinicalDataStartingTopMargin'].toString();
                                  prescriptionPrintLayout.marginBeforePatientNameController.text = item['marginBeforePatientName'].toString();
                                  prescriptionPrintLayout.marginBeforePatientAgeController.text = item['marginBeforePatientAge'].toString();
                                  prescriptionPrintLayout.marginBeforePatientIdController.text = item['marginBeforePatientId'].toString();
                                  prescriptionPrintLayout.marginBeforePatientGenderController.text = item['marginBeforePatientGender'].toString();
                                  prescriptionPrintLayout.marginBeforePatientDateController.text = item['marginBeforePatientDate'].toString();
                                  prescriptionPrintLayout.clinicalDataPrintingPerPageController.text = item['clinicalDataPrintingPerPage'].toString();
                                  prescriptionPrintLayout.brandDataPrintingPerPageController.text = item['brandDataPrintingPerPage'].toString();
                                  prescriptionPrintLayout.clinicalAndBrandDataPerPageGapController.text = item['clinicalAndBrandDataPerPageGap'].toString();
                                  prescriptionPrintLayout.marginAroundFullPageController.text = item['marginAroundFullPage'].toString();
                                  prescriptionPrintLayout.printHeaderFooterOrNonValue.value = item['print_header_footer_or_none'].toString();
                                  prescriptionPrintLayout.gapBetweenAdviceController.text = item['advice_gap'].toString();
                                  // prescriptionPrintLayout.activeChamberId.value = item['chamber_id'];
                                 try{
                                   var responseHeaderImg =await ApiCreateServerToDb().prescriptionLayoutSettingsApiService(URLHeader + '?${item['chamber_id']}', token, lastSyncDate, page, per_page);

                                   var responseFooterImg =await ApiCreateServerToDb().prescriptionLayoutSettingsApiService(URLFooter + '?${item['chamber_id']}', token, lastSyncDate, page, per_page);

                                   var headerImg = responseHeaderImg !=null ? await HeaderFooterImage(responseHeaderImg['data']['header']) : false ;

                                   Uint8List unit8ListHeader;
                                   if(headerImg !=false){
                                     unit8ListHeader =await base64.decode(headerImg);
                                   } else{
                                     unit8ListHeader = Uint8List(0);
                                   }
                                   var footerImg =responseFooterImg !=null ? await HeaderFooterImage(responseFooterImg['data']['footer']) : false;
                                   Uint8List unit8ListFooter;
                                   if(footerImg !=false){
                                     unit8ListFooter =await base64.decode(footerImg);
                                   }else{
                                     unit8ListFooter = Uint8List(0);
                                   }

                                   // if(unit8ListHeader.isNotEmpty){
                                   //   await commonController.saveHeader(boxPrescriptionLayout,unit8ListHeader);
                                   // }
                                   // if(unit8ListFooter.isNotEmpty){
                                   //   commonController.saveFooter(boxPrescriptionLayout,unit8ListFooter);
                                   // }

                                   if(unit8ListHeader.isNotEmpty){
                                     prescriptionPrintLayout.headerFooterAndBgImage[0]['headerImage'] = unit8ListHeader;
                                   }
                                   if(unit8ListFooter.isNotEmpty){
                                     prescriptionPrintLayout.headerFooterAndBgImage[0]['footerImage'] = unit8ListFooter;
                                   }

                                   // var chamberIndex = boxChamber.values.toList().indexWhere((element) => element.web_id == item['chamber_id']);

                                   if(chamberIndex != -1){

                                     var chamber = boxChamber.getAt(chamberIndex)!;
                                     prescriptionPrintLayout.chamberIdController.text = chamber.id.toString();
                                     await prescriptionPrintLayout.saveData();
                                   }
                                 }catch(e){

                                 }

                                }else{
                                  print("Time is greater than last sync time");
                                }
                              }
                            }

                          }

                        }catch(e){
                          print(e);
                        }
                      }
              }else{
                    prescriptionPrintLayout.defaultPrescriptionPrintSetup();
                  }

              statusApi = false;
              print("api call end $URL");
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.prescriptionLayoutSettings, "${DateTime.now().toString()}");
              brand.value = true;
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
  Future<void>getChamberList()async{
    final chamberController = Get.put(ChamberController());
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.chambers}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    if(isInternet){
      if(token.isNotEmpty){
        var response =servError.value ? await ifServError().chamberApiService(URL, "get", token, '') : await ApiCreateDbToServer().chamberApiService(URL, "get", token, '');
        try{
          if(response['success'] == true){
            var data = response['data'];
            if(data.isNotEmpty){
              for(var i=0;i<data.length;i++){
                var deleted_at = response['deleted_at'];
                if(deleted_at == null){
                  ChamberModel chamberModel = ChamberModel(
                    id: 0,
                    chamber_name: data[i]['name'] ?? '',
                    web_id: data[i]['id'] ?? 0,
                    u_status: DefaultValues.Synced,
                    date: data[i]['created_at'],
                  );
                  await commonController.saveChamber(boxChamber, chamberModel);
                }
                if(deleted_at != null){
                  commonController.removeChamberServerSync(boxChamber, data['id']);
                }
              }
              chamberController.initCall();
            }

          }
        }catch(e){
          print(e);
        }

      }
    }
  }
  Future<void> doctor(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.doctor}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    if(isInternet){
      if(token.isNotEmpty){
        var response = servError.value ? await ApiCreateDbToServer().DoctorApiService(URL, "get", token, '') : await ApiCreateDbToServer().DoctorApiService(URL, "get", token, '');
        try{
          if(response['success'] == true){
            var data = response['data'];
            if(data.isNotEmpty){
              for(var i=0;i<data.length;i++){
                var deleted_at = data[i]['deleted_at'];
                if(deleted_at == null){
                  DoctorModel doctorModel = DoctorModel(
                    id: 0,
                    web_id: data[i]['id'] ?? 0,
                    u_status: DefaultValues.Synced,
                    date: data[i]['created_at'],
                    name: data[i]['name'],
                    phone: data[i]['phone'],
                    address: data[i]['address'],
                    designation: data[i]['description'],
                    uuid: data[i]['uuid'],
                    degree: data[i]['degree'],

                  );
                  await commonController.saveDoctor(boxDoctor, doctorModel);
                }
                if(deleted_at != null){
                  commonController.removeDoctorServerSync(boxDoctor, data['uuid']);
                }
              }

            }

          }
        }catch(e){
          print(e);
        }

      }
    }
  }
  Future<void> certificate(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.medicalCertificate}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.certificate);
    int page = 1;
    int per_page = 50;
    print("Download start $URL");
    if(isInternet){
      if(token.isNotEmpty){
        var response = servError.value ? await ApiCreateServerToDb().CertificateApiService(URL,token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().CertificateApiService(URL,token, lastSyncDate, page, per_page);
        try{
          if(response['success'] == true){
            var data = response['data'];
            if(data.isNotEmpty){
              for(var i=0;i<data.length;i++){
                var deleted_at = data[i]['deleted_at'];
                if(deleted_at == null){
                  try{
                    var appIndex = await boxAppointment.values.toList().indexWhere((element) => element.web_id == parseInt(data[i]['app_id'].toString()));
                    if(appIndex != -1){
                      var appId = boxAppointment.getAt(appIndex)?.id;
                      PatientCertificateModel certificateModel = PatientCertificateModel(
                        id: 0,
                        web_id: data[i]['id'] ?? 0,
                        u_status: DefaultValues.Synced,
                        date: data[i]['created_at'],
                        appointment_id: "${appId.toString()}",
                        uuid: data[i]['uuid'],
                        diagnosis: data[i]['diagnosis'],
                        form: data[i]['form'].toString(),
                        to: data[i]['to'].toString(),
                        type: data[i]['type'].toString(),
                        duration: data[i]['duration'].toString(),
                        got_to: data[i]['got_to'],
                        is_continue: data[i]['continue'] ,
                      );
                      await commonController.saveCertificate(boxCertificate, certificateModel);
                    }
                  }catch(e){
                    print(e );
                  }

                }
                if(deleted_at != null){
                  commonController.removeCertificateServerSync(boxCertificate, data['uuid']);
                }
              }

            }
            if(data.isEmpty){
              await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.certificate, "${DateTime.now().toString()}");
            }

          }
        }catch(e){
          print(e);
        }

      }
    }
  }
  Future<void> referral(context)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.referral}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    print("download sync start: $URL");
    if(isInternet){
      if(token.isNotEmpty){
        var response = servError.value ? await ifServError().ReferralApiService(URL, "get", token, '') : await ApiCreateDbToServer().ReferralApiService(URL, "get", token, '');
        print(response);
        try{
          if(response['success'] == true){
            var data = response['data'];
            if(data.isNotEmpty){
              for(var i=0;i<data.length;i++){
                var deleted_at = data[i]['deleted_at'];
                if(deleted_at == null){
                  PatientReferralModel patientReferralModel = PatientReferralModel(
                    id: 0,
                    web_id: data[i]['id'] ?? 0,
                    u_status: DefaultValues.Synced,
                    date: data[i]['created_at'],
                    app_id: data[i]['app_id'],
                    referred_to: data[i]['referred_to'],
                    special_notes: data[i]['special_notes'],
                    uuid: data[i]['uuid'],
                    reason_for_referral: data[i]['reason_for_referral'],
                  );
                  await commonController.saveReferral(boxReferral, patientReferralModel);
                }
                if(deleted_at != null){
                  commonController.removeCertificateServerSync(boxReferral, data['uuid']);
                }
              }
            }

          }
          print("end sync : $URL");
        }catch(e){
          print(e);
        }

      }
    }
  }
  Future<void> investigationImage(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.investigationImage}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.investigationImage);
    // String lastSyncDate = "2024-05-18 20:54:38.887878";
    print("download sync start: $URL");
    int page = 1;
    int per_page = 50;
    if(isInternet){
      if(token.isNotEmpty){
        var response = servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate,page,per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate,page,per_page);

        try{
          var data = response['data'];
          print(data.length);
          if(data.length > 0){
            if(data.isNotEmpty){
              print(data);
              for(var i=0;i<data.length;i++){
                var deleted_at = data[i]['deleted_at'];
                if(deleted_at == null){
                     var imageString =await HeaderFooterImage(data[i]['url']) ?? '';
                     Uint8List unit8ListImage =await base64.decode(imageString);
                     
                    InvestigationReportImageModel invRepImage = InvestigationReportImageModel(
                    id: 0,
                    web_id: data[i]['id'] ?? 0,
                    u_status: DefaultValues.Synced,
                    date: data[i]['created_at'],
                    app_id: parseInt(data[i]['appointment_id']),
                    inv_name: data[i]['inv_name'] ?? '',
                    title: data[i]['title'],
                    uuid: data[i]['uuid'],
                    details: data[i]['details'],
                    url: unit8ListImage,
                  );
                  await commonController.saveInvReportImage(boxInvReImage, invRepImage);
                }
                if(deleted_at != null){
                  commonController.removeInvRImage(boxInvReImage, data[i]['uuid']);
                }
              }
              if(data.isNotEmpty){
                page = page + 1;
              }else{
                Future.delayed(Duration(seconds: 5),(){
                    setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.investigationImage, "${DateTime.now().toString()}");
                  print("end sync : $URL");
                });

              }
            }

          }

          print("end sync : $URL");
        }catch(e){
          print(e);
        }

      }
    }
  }
  Future<void> diseaseImage(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.diseaseImage}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.diseaseImage);
    // String lastSyncDate = "2023-05-18 20:54:38.887878";
    print(lastSyncDate);
    int page = 1;
    int per_page = 1;
    print("download sync start: $URL");
    if(isInternet){
      if(token.isNotEmpty){
        try{
          for(var i=0;i<page;i++){
            var response =servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate,page,per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate,page,per_page);
            print(response);
            var data = response['data'] ?? [];
            if(data.isNotEmpty){
              for(var i=0;i<data.length;i++){
                var deleted_at = data[i]['deleted_at'];
                if(deleted_at == null){
                  var imageString =await HeaderFooterImage(data[i]['url']) ?? '';
                  print(imageString);
                  Uint8List unit8ListImage =await base64.decode(imageString);
                  PatientDiseaseImageModel paDisImage = PatientDiseaseImageModel(
                    id: 0,
                    web_id: data[i]['id'] ?? 0,
                    u_status: DefaultValues.Synced,
                    date: data[i]['created_at'],
                    app_id: data[i]['appointment_id'],
                    disease_name: data[i]['disease_name'] ?? '',
                    title: data[i]['title'],
                    uuid: data[i]['uuid'],
                    details: data[i]['details'],
                    url: unit8ListImage,
                  );
                  await commonController.savePaDisImage(boxPaDisImage, paDisImage);
                }
                if(deleted_at != null){
                  commonController.removePaDisImage(boxPaDisImage, data[i]['uuid']);
                }
              }

            }
            if(data.isNotEmpty){
              page = page + 1;
            }else{
              if(data.length == 0){
                print("download end sync : $URL");
                Future.delayed(Duration(seconds: 5),(){
                  setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.diseaseImage, "${DateTime.now().toString()}");
                });
              }
            }

          }



        }catch(e){
          print(e);
        }

      }
    }
  }

  Future<void> historyCategory(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.historyCategory}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.historyCategory);
    // String lastSyncDate = "2020-06-01 20:54:38.887878";
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.historyCategory);
    // int page = 1;
    int per_page = 50;
    bool statusApi = true;
    print("sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            for(int i = 0; i < page; i++){
              var response = servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String? updated_at = data[i]['updated_at'] ?? null;
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                  String name = data[i]['name'] ?? '';
                  int id = data[i]['id'] ?? 0;
                  if(name.isNotEmpty && deleted_at ==null){
                    await commonController.deleteCommonServerToDbByWebId(boxHistoryCat, HistoryCategoryModel(id: 0, web_id: id, name: name, uuid: '', u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}" ));
                  }
                  if(deleted_at != null){
                    await commonController.deleteCommonServerToDbByWebId(boxHistoryCat, id);
                  }
                }
              }
              if(data.isNotEmpty){
                statusApi = true;
                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.historyCategory, page++);
                page = page++;
                continue;
              }else{

                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.historyCategory, 1);
                print("api call end $URL");
                statusApi = false;
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.historyCategory, "${DateTime.now().toString()}");

                break;
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
  Future<void> historyNew(context)async{
    String URL = '${Syncs.BaseUrl}${Syncs.historyNew}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    String lastSyncDate = await getStoreKeyWithValue(syncTimeSharedPrefsKey.historyNew);
    // String lastSyncDate = "2022-06-01 20:54:38.887878";
    int page = await getIntStoreKeyWithValue("page" + syncTimeSharedPrefsKey.historyNew);
    int per_page = 50;
    bool statusApi = true;
    print("download sync start: $URL");
    try{
      if(isInternet){
        if(token.isNotEmpty){
          if(statusApi){
            for(int i = 0; i < page; i++){
              var response = servError.value ? await ifServErrorApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page) : await ApiCreateServerToDb().ApiService(URL, token, lastSyncDate, page, per_page);
              var data = response['data'] ?? [];
              if(data.isNotEmpty){
                for(int i = 0; i < data.length; i++){
                  String? updated_at = data[i]['updated_at'] ?? null;
                  String? deleted_at = data[i]['deleted_at'] ?? null;
                  String name = data[i]['name'] ?? '';
                  String category = data[i]['category_id'].toString();
                  int id = data[i]['id'] ?? 0;
                  if(name.isNotEmpty && id != 0 && deleted_at ==null){
                    await commonController.saveHistoryServerToDb(boxHistory,boxHistoryCat, HistoryModel(id: 0, web_id: id, name: name, uuid: '', u_status: DefaultValues.Synced, date: "${DateTime.now().toString()}", category: category, type: '' ));
                  }
                  if(deleted_at != null && id != 0){
                    await commonController.deleteCommonServerToDbByWebId(boxHistory, id);
                  }
                }
              }
              if(data.isNotEmpty){
                statusApi = true;
                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.historyNew, page++);
                page = page++;
                continue;
              }else{
                await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.historyNew, 1);
                print("api call end $URL");
                statusApi = false;
                await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.historyNew, "${DateTime.now().toString()}");
                cc.value =  true;
                break;

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

 Future SyncAll(context) async {
  syncStatus.value = true;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  servError.value = await prefs.getBool("HandshakeExceptionError") ?? false;
    await updateProgress(0.0);
    currentSyncingData.value = "Chambers";
    await getChamberList();
    await updateProgress(0.1);

    currentSyncingData.value = "Chief Complain";
    await chiefComplainMethod(context);
    await updateProgress(0.110);

    currentSyncingData.value = "onExamination";
    await onExaminationMethod(context);
    await updateProgress(0.120);

    currentSyncingData.value = "onExamination Category";
    await onExaminationCategoryMethod(context);
    await updateProgress(0.150);

    currentSyncingData.value = "Investigation Advice";
    await investigationAdviceMethod(context);
    await updateProgress(0.190);

    currentSyncingData.value = "Diagnosis";
    await diagnosisMethod(context);
    await updateProgress(0.210);

    currentSyncingData.value = "Investigation Report";
    await investigationReportMethod(context);
    await updateProgress(0.230);

    currentSyncingData.value = "Procedure";
    await procedureMethod(context);
    await updateProgress(0.260);


    currentSyncingData.value = "Advice";
    await adviceMethod(context);
    await updateProgress(0.285);

    currentSyncingData.value = "Handout";
    await handoutMethod(context);
    await updateProgress(0.290);
    //
    currentSyncingData.value = "Instruction";
    await instructionMethod(context);
    await updateProgress(0.300);

    currentSyncingData.value = "Dose";
    await doseMethod(context);
    await updateProgress(0.310);
    //
    currentSyncingData.value = "Duration";
    await durationMethod(context);
    await updateProgress(0.320);

    currentSyncingData.value = "Company";
    await companyMethod(context);
    await updateProgress(0.340);

    currentSyncingData.value = "Generic";
    await genericMethod(context);
    await updateProgress(0.360);

    currentSyncingData.value = "Brand";
    await brandMethod(context);
    await updateProgress(0.380);

    currentSyncingData.value = "Patient";
    await patient(context);
    await updateProgress(0.430);
    //
    currentSyncingData.value = "Appointment";
    await appointment(context);
    await updateProgress(0.480);

    currentSyncingData.value = "Prescription";
    await prescription(context);
    await updateProgress(0.550);

    currentSyncingData.value = "Prescription Drug";
    await prescriptionDrug(context);
    await updateProgress(0.590);

    currentSyncingData.value = "Prescription Drug Dose";
    await prescriptionDrugDose(context);
    await updateProgress(0.650);

    currentSyncingData.value = "Prescription Template";
    await prescriptionTemplate(context);
    await updateProgress(0.700);

    currentSyncingData.value = "Prescription Template Drug";
    await prescriptionTemplateDrug(context);
    await updateProgress(0.750);

     currentSyncingData.value = "Prescription Template Drug Dose";
     await prescriptionTemplateDrugDose(context);
     await updateProgress(0.800);

     // currentSyncingData.value = "General Settings";
     // await generalSettings(context);
     // await updateProgress(0.850);

     currentSyncingData.value = "Prescription Layout Settings";
     await prescriptionLayoutSettingsNew(context);
     await updateProgress(0.900);

     currentSyncingData.value = "Doctor";
     await doctor(context);
     await updateProgress(0.920);

     currentSyncingData.value = "Referral";
     await referral(context);
     await updateProgress(0.940);

     currentSyncingData.value = "Certificate";
     await certificate(context);
     await updateProgress(0.945);

     currentSyncingData.value = "Favorite";
     await favoriteMethod(context);
     await updateProgress(0.950);

    currentSyncingData.value = "Investigation Report Image";
    await investigationImage(context);
    await updateProgress(0.960);

    currentSyncingData.value = "Patient Gyn And Obs History";
    await patientGynHistory(context);
    await updateProgress(0.970);
    //
    currentSyncingData.value = "Patient Chld History";
    await patientChildHistory(context);
    await updateProgress(0.980);

    currentSyncingData.value = "Disease Image";
    await diseaseImage(context);
    await updateProgress(1.0);

    currentSyncingData.value = "History Category";
    await historyCategory(context);
    await updateProgress(1.0);

    currentSyncingData.value = "History";
    await historyNew(context);
    await updateProgress(1.0);
    syncStatus.value = false;

    return true;
  }
  Future<void> updateProgress(double increment)async{
    downloadSyncProgress.value = increment;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    downloadSyncProgress.value = 0.0;
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose

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
    boxFavoriteIndex.close();
    boxPatient.close();
    boxAppointment.close();
    boxPrescription.close();
    boxTemplate.close();
    boxTemplateDrug.close();
    boxTemplateDrugDose.close();
    boxPatientHistory.close();
    boxPrescriptionDrug.close();
    boxPrescriptionDrugDose.close();
    boxGeneralSettings.close();
    boxPrescriptionLayout.close();
    boxChamber.close();
    boxDoctor.close();
    boxReferral.close();
    boxCertificate.close();
    boxInvReImage.close();
    boxPaDisImage.close();
    obs.close();
    super.dispose();
  }
}