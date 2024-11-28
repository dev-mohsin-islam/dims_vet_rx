import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';
import 'package:dims_vet_rx/controller/appointment/methods/clear_appointment_data.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/prescription_controller.dart';
import 'package:dims_vet_rx/controller/drug_brand/drug_brand_controller.dart';
import 'package:dims_vet_rx/controller/drug_generic/drug_generic_controller.dart';
import 'package:dims_vet_rx/database/crud_operations/appointment_crud.dart';
import 'package:dims_vet_rx/models/chief_complain/chief_complain_model.dart';
import 'package:dims_vet_rx/models/create_prescription/prescription/prescription_model.dart';
import 'package:dims_vet_rx/models/create_prescription/prescription_drug_dose/prescription_drug_dose_model.dart';
import 'package:dims_vet_rx/models/diagnosis/diagnosis_modal.dart';
import 'package:dims_vet_rx/models/drug_brand/drug_brand_model.dart';
import 'package:dims_vet_rx/models/investigation/investigation_modal.dart';
import 'package:dims_vet_rx/models/investigation_report/investigation_report_model.dart';
import 'package:dims_vet_rx/models/on_examination/on_examination_model.dart';
import 'package:dims_vet_rx/models/prescription_template/prescription_template/prescription_template_model.dart';
import 'package:dims_vet_rx/models/prescription_template/prescription_template_drug/prescription_template_drug_model.dart';
import 'package:dims_vet_rx/models/prescription_template/prescription_template_drug_dose/prescription_template_drug_dose_model.dart';
import 'package:dims_vet_rx/models/procedure/procedure_model.dart';
import '../../models/appointment/appointment_model.dart';
import '../../models/create_prescription/prescription_drug/prescription_drug_model.dart';
import '../../models/patient/patient_model.dart';
import '../../utilities/default_value.dart';
import '../../utilities/app_strings.dart';
import '../../utilities/helpers.dart';
import '../hive_get_boxes.dart';

class SyncCRUDController {
  final Logger _logger = Logger();

  Box<ChiefComplainModel>boxChiefComplain = Boxes.getChiefComplain();
  Box<InvestigationModal>boxIa = Boxes.getInvestigation();
  Box<DiagnosisModal>boxDia = Boxes.getDiagnosis();
  Box<ProcedureModel>boxProcedure = Boxes.getProcedure();
  Box<InvestigationReportModel>boxIr = Boxes.getInvestigationReportBox();
  Box<OnExaminationModel>boxOE = Boxes.getOnExamination();
  Box<DrugBrandModel>boxBrand = Boxes.getDrugBrand();

  final AppointmentController appointmentController = Get.put(AppointmentController());
  ///insert data form server through api
  Future<bool?> saveGeneralSettingsServerToDb(box, object) async {

    try {
      final index = await box.values.toList().indexWhere((data) => data.section == object.section && data.label == object.label);
      if(index != -1){
        _logger.i('Already Exist in Database,  $box');
        return true;
      }else{
        int indexNew = await box.add(object);
         var existingData = await box.getAt(indexNew);
        existingData.id = await indexNew;
        await box.putAt(indexNew, existingData);
        _logger.i('Success $box');
        return true;
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> savePrescriptionLayoutServerToDb(box, object) async {

    try {
      var index = await box.add(object);

    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> saveHeader(box, headerImage) async {
    try {
      var existingData = await box.getAt(0);
      existingData.header_image = await headerImage;
      await box.putAt(0, existingData);
      _logger.i('Success $box');
      return true;
    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> saveFooter(box, footerImage) async {
    try {
      var existingData = await box.getAt(0);
      existingData.footer_image =await footerImage;
      await box.putAt(0, existingData);
      _logger.i('Success $box');
      return true;
    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> saveCommonServerToDb(box, object) async {
    int web_id =await object.web_id;
    try {
      final index = await box.values.toList().indexWhere((data) => data.web_id == web_id);
      if(index != -1){
          object.id =await index + 1;
         await box.putAt(index, object);
        _logger.i('Already Exist in Database, Updated $box');
        return true;
      }else{
        int indexNew = await box.add(object);
         var existingData = await box.getAt(indexNew);
        existingData.id =await indexNew + 1;
        await box.putAt(indexNew, existingData);
        _logger.i('Success $box');
        return true;
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> saveHistoryServerToDb(box,boxCategory, object) async {

    int web_id =await object.web_id;
    try {
      print(object.category);
      final objectApp = boxCategory.values.toList().indexWhere((data) => data.web_id.toString() == object.category);
      if(objectApp == -1){
        return false;
      }else{
        object.category =await boxCategory.getAt(objectApp).id.toString();
        final index = await box.values.toList().indexWhere((data) => data.web_id == web_id);
        if(index != -1){
          object.id =await index + 1;
          await box.putAt(index, object);
          _logger.i('Already Exist in Database, Updated $box');
          return true;
        }else{
          int indexNew = await box.add(object);
          var existingData = await box.getAt(indexNew);
          existingData.id =await indexNew + 1;
          await box.putAt(indexNew, existingData);
          _logger.i('Success $box');
          return true;
        }
      }


    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> saveChamber(box, object) async {
    int web_id =await object.web_id;
    try {
      final index = await box.values.toList().indexWhere((data) => data.web_id == web_id);
      if(index != -1){
        var   existingData = await box.getAt(index);
        object.id =await existingData.id;
         await box.putAt(index, object);
        _logger.i('Already Exist in Database $box');
        return true;
      }else{
        int indexNew = await box.add(object);
         var existingData = await box.getAt(indexNew);
        existingData.id =await indexNew + 1;
        await box.putAt(indexNew, existingData);
        _logger.i('Success $box');
        return true;
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> saveDoctor(box, object) async {

    try {
      final index = await box.values.toList().indexWhere((data) => data.uuid == object.uuid);
      if(index != -1){
          var existingData = await box.getAt(index);
          object.id =await existingData.id;
         await box.putAt(index, object);
        _logger.i('Already Exist in Database, update $box');
        return true;
      }else{
        int indexNew = await box.add(object);
         var existingData = await box.getAt(indexNew);
        existingData.id =await indexNew + 1;
        await box.putAt(indexNew, existingData);
        _logger.i('Added Success  $box');
        return true;
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> saveReferral(box, object) async {

    try {
      final index = await box.values.toList().indexWhere((data) => data.uuid == object.uuid);
      if(index != -1){
          var existingData = await box.getAt(index);
          object.id =await existingData.id;
         await box.putAt(index, object);
        _logger.i('Already Exist in Database, update $box');
        return true;
      }else{
        int indexNew = await box.add(object);
         var existingData = await box.getAt(indexNew);
        existingData.id =await indexNew + 1;
        await box.putAt(indexNew, existingData);
        _logger.i('Added Success  $box');
        return true;
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> saveInvReportImage(box, object) async {
    final Box<AppointmentModel> boxApp = Boxes.getAppointment();

    try {
      final index = await box.values.toList().indexWhere((data) => data.web_id == object.web_id);
      if(index != -1){
          final objectApp = boxApp.values.firstWhere((data) => data.web_id == object.app_id);
          var existingData = await box.getAt(index);
          object.app_id = await objectApp.id;
          object.id =await existingData.id;
         await box.putAt(index, object);
        _logger.i('Already Exist in Database, update $box');
        return true;
      }else{
        final objectApp = boxApp.values.firstWhere((data) => data.web_id == object.app_id);
        object.app_id = await objectApp.id;
        int indexNew = await box.add(object);
         var existingData = await box.getAt(indexNew);
        existingData.id =await indexNew + 1;
        await box.putAt(indexNew, existingData);
        _logger.i('Added Success  $box');
        return true;
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }

  Future<bool?> savePaDisImage(box, object) async {
    final Box<AppointmentModel> boxApp = Boxes.getAppointment();

    try {
      final index = await box.values.toList().indexWhere((data) => data.web_id == object.web_id);
      if(index != -1){
          final objectApp = boxApp.values.firstWhere((data) => data.web_id == object.app_id);
          var existingData = await box.getAt(index);
          object.app_id = await objectApp.id;
          object.id =await existingData.id;
         await box.putAt(index, object);
        _logger.i('Already Exist in Database, update $box');
        return true;
      }else{
        final objectApp = boxApp.values.firstWhere((data) => data.web_id == object.app_id);
        object.app_id = await objectApp.id;
        int indexNew = await box.add(object);
         var existingData = await box.getAt(indexNew);
        existingData.id =await indexNew + 1;
        await box.putAt(indexNew, existingData);
        _logger.i('Added Success  $box');
        return true;
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> saveCertificate(box, object) async {
    try {
      final index = await box.values.toList().indexWhere((data) => data.web_id == object.web_id);
      if(index != -1){
          var existingData = await box.getAt(index);
          object.id =await existingData.id;
         await box.putAt(index, object);
        _logger.i('Already Exist in Database, update $box');
        return true;
      }else{
        int indexNew = await box.add(object);
         var existingData = await box.getAt(indexNew);
        existingData.id =await indexNew + 1;
        await box.putAt(indexNew, existingData);
        _logger.i('Added Success  $box');
        return true;
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> updateChamber(box, id, web_id) async {
    try {
      final index = await box.values.toList().indexWhere((data) => data.id == id);
      if(index != -1){
         var existingData = await box.getAt(index);
        existingData.web_id =await web_id;
        existingData.u_status =await DefaultValues.Synced;
         await box.putAt(index, existingData);
        _logger.i('Already Exist in Database, Updated $box');
        return true;
      }else{
        // int indexNew = await box.add(object);
        //  var existingData = await box.getAt(indexNew);
        // existingData.id = indexNew;
        // await box.putAt(indexNew, existingData);
        _logger.i('chamber not found $box');
        return true;
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> updateIRImage(box, object) async {
    try {
      final index = await box.values.toList().indexWhere((data) => data.id == object.id);
      if(index != -1){
         var existingData = await box.getAt(index);
         await box.putAt(index, existingData);
        _logger.i('Already Exist in Database, Updated $box');
        return true;
      }else{
        // int indexNew = await box.add(object);
        //  var existingData = await box.getAt(indexNew);
        // existingData.id = indexNew;
        // await box.putAt(indexNew, existingData);
        _logger.i('chamber not found $box');
        return true;
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> saveFavoriteServerToDb(box, object) async {

    int web_id = object.web_id;
    int favorite_id = object.favorite_id;
    String segment = object.segment;
    try {
      final index = await box.values.toList().indexWhere((data) => data.web_id == web_id && data.segment == segment); 
      if(index != -1){ 
         //  object.id = index;
         // await box.putAt(index, object);
        _logger.i('Already Exist in Database, $box');
        return true;
      }else{
        if(segment ==FavSegment.chiefComplain){
          final index = await boxChiefComplain.values.toList().indexWhere((data) => data.web_id == favorite_id);
          if(index != -1){
            var existingData = await boxChiefComplain.getAt(index);
            int? ccId = existingData?.id;
            if(ccId != null){
              object.favorite_id =await ccId;
              int indexNew = await box.add(object);
              var existingData = await box.getAt(indexNew);
              existingData.id =await indexNew;
              await box.putAt(indexNew, existingData);
              _logger.i('Success $box');
            }

          }
        }
        if(segment ==FavSegment.oE){
          final index = await boxOE.values.toList().indexWhere((data) => data.web_id == favorite_id);
          if(index != -1){
            var existingData = await boxOE.getAt(index);
            int? dataId = existingData?.id;
            if(dataId != null){
              object.favorite_id =await dataId;
              int indexNew = await box.add(object);
              var existingData = await box.getAt(indexNew);
              existingData.id = await indexNew;
              await box.putAt(indexNew, existingData);
              _logger.i('Success $box');
            }

          }
        }
        if(segment ==FavSegment.brand){
          final index = await boxBrand.values.toList().indexWhere((data) => data.web_id == favorite_id);
          if(index != -1){
            var existingData = await boxBrand.getAt(index);
            int? dataId = existingData?.id;
            if(dataId != null){
              object.favorite_id = await dataId;
              int indexNew = await box.add(object);
              var existingData = await box.getAt(indexNew);
              existingData.id =await indexNew;
              await box.putAt(indexNew, existingData);
              _logger.i('Success $box');
            }
          }
        }
        if(segment ==FavSegment.ia){
          final index = await boxIa.values.toList().indexWhere((data) => data.web_id == favorite_id);
          if(index != -1){
            var existingData = await boxIa.getAt(index);
            int? dataId = existingData?.id;
            if(dataId != null){
              object.favorite_id = await dataId;
              int indexNew = await box.add(object);
              var existingData = await box.getAt(indexNew);
              existingData.id = await indexNew;
              await box.putAt(indexNew, existingData);
              _logger.i('Success $box');
            }
          }
        }
        if(segment ==FavSegment.ir){
          final index = await boxIr.values.toList().indexWhere((data) => data.web_id == favorite_id);
          if(index != -1){
            var existingData = await boxIr.getAt(index);
            int? dataId = existingData?.id;
            if(dataId != null){
              object.favorite_id =await dataId;
              int indexNew = await box.add(object);
              var existingData = await box.getAt(indexNew);
              existingData.id =await indexNew;
              await box.putAt(indexNew, existingData);
              _logger.i('Success $box');
            }
          }
        }
        if(segment ==FavSegment.dia){
          final index = await boxDia.values.toList().indexWhere((data) => data.web_id == favorite_id);
          if(index != -1){
            var existingData = await boxDia.getAt(index);
            int? dataId = existingData?.id;
            if(dataId != null){
              object.favorite_id = dataId;
              int indexNew = await box.add(object);
              var existingData = await box.getAt(indexNew);
              existingData.id =await indexNew;
              await box.putAt(indexNew, existingData);
              _logger.i('Success $box');
            }
          }
        }
        if(segment ==FavSegment.procedure){
          final index = await boxProcedure.values.toList().indexWhere((data) => data.web_id == favorite_id);
          if(index != -1){
            var existingData = await boxProcedure.getAt(index);
            int? dataId = existingData?.id;
            if(dataId != null){
              object.favorite_id =await dataId;
              int indexNew = await box.add(object);
              var existingData = await box.getAt(indexNew);
              existingData.id = await indexNew;
              await box.putAt(indexNew, existingData);
              _logger.i('Success $box');
            }
          }
        }

        return true;
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> saveCompanyServerToDb(box, object) async {
    int web_id = object.web_id;
    try {
      final index = await box.values.toList().indexWhere((data) => data.web_id == web_id);
      if(index != -1){
         await box.putAt(index, object);
        _logger.i('Already Exist in Database, Updated $box');
        return true;
      }else{
        int index = await box.add(object);
        _logger.i('Success $box');
        return true;
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> saveGenericServerToDb(box, object) async {
    int web_id = object.web_id;
    try {
      final index = await box.values.toList().indexWhere((data) => data.web_id == web_id);
      if(index != -1){
         await box.putAt(index, object);
        _logger.i('Already Exist in Database, Updated $box');
        return true;
      }else{
        int indexNew = await box.add(object);
        _logger.i('Success $box');
        return true;
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> saveBrandServerToDb(box, object) async {
    int web_id = object.web_id;
    try {
      final index = await box.values.toList().indexWhere((data) => data.web_id == web_id);
      if(index != -1){
         await box.putAt(index, object);
        _logger.i('Already Exist in Database, Updated $box');
        return true;
      }else{
        int index = await box.add(object);
        _logger.i('Success $box');
        return true;
      }
    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }
  Future<bool?> saveBrandJsnToDb(box, object) async {
    try {
      final index = await box.values.toList().indexWhere((data) => data.web_id == object.web_id);
      if(index != -1){
         // await box.putAt(index, object);
        _logger.i('Already Exist in Database, Updated $box');
        return true;
      }else{
        int index = await box.add(object);
        _logger.i('Success $box');
        return true;
      }
    } catch (e) {
      _logger.e("Error in saveCommon: $e $box");
    }
    return null;
  }

  Future<bool?> savePatientServerToDb(boxPatient, object) async {
    int web_id = object.web_id;
    try {
        final index = await boxPatient.values.toList().indexWhere((data) => data.web_id == web_id);
        if(index != -1){
          await boxPatient.putAt(index, object);
          _logger.i('Exist in Database, Updated $boxPatient');
          return true;
        }else{
          final index = await boxPatient.add(object);
          if(index != -1){
              _logger.i('Success $boxPatient');
              return true;
          }
      }
    } catch (e) {
      _logger.e("Error in saveCommon: $e $boxPatient");
    }
    return null;
  }
  Future<bool?> saveAppointmentServerToDb(Box<AppointmentModel> boxAppointment, Box<PatientModel> boxPatient,additionalData, object) async {
    var patient_id = object.patient_id;
    var uuid = object.uuid;
    try {
      if (await boxPatient.length >0) {
        for(var i=0; i< await boxPatient.length; i++){
          var patients = await boxPatient.getAt(i);
          if(patients?.web_id == patient_id){
            int? pa_id = patients?.id;
            if(await boxAppointment.length >0){
              final index =await boxAppointment.values.toList().indexWhere((data) => data.uuid == uuid,);
              if (index != -1) {
                var existingData = await boxAppointment.getAt(index);
                object.id = existingData?.id;
                object.patient_id = pa_id;
                await boxAppointment.putAt(index, object);
                if(additionalData != null){
                  await saveAppClinicalData(object.id,additionalData);
                }
                _logger.i('Already Exist in Database, Updated $boxAppointment');
                appointmentController.InitialData();
              } else {
                List appointmentList = await boxAppointment.values.toList();
                dynamic maxValue = appointmentList.map((e) => e.id).reduce((a,b) => a >b ? a : b);
                object.id = maxValue + 1;
                object.patient_id = pa_id;
                await boxAppointment.add(object);
                if(additionalData != null){
                  await saveAppClinicalData(object.id,additionalData);
                }
                _logger.i('Appointment not exist newly added $boxAppointment.');
                appointmentController.InitialData();
              }
            }else{
              int id = PreFixIds.defaultPrefixAppId;
              object.id = id;
              object.patient_id = pa_id;
              await boxAppointment.add(object);
              if(additionalData != null){
                await saveAppClinicalData(object.id,additionalData);
              }
              _logger.i('Appointment not exist newly added $boxAppointment.');
              appointmentController.InitialData();
            }
          }
        }
      }else{
        _logger.w('Patient Database is empty');
      }


    } catch (e) {
      _logger.e("Error in saveAppointmentServerToDb: $e");
    }
    return null;
  }
Future<void>saveAppClinicalData(appId,Data)async{
  var boxAppClinicalData = Boxes.getAppClinicalData();
  // Map<String, dynamic> dataOrderingMap = Map.fromIterable(dataOrdering, key: (e) => e['title'], value: (e) => e['value']);
  String jsonOrdering = jsonEncode(Data);
  var jsonClinical = Data;
  final jsonClinicalDataJsonMAp = jsonDecode(jsonClinical) as Map<String, dynamic>;
  await boxAppClinicalData.put(appId, jsonClinicalDataJsonMAp); 
}

  Future<bool?> savePrescriptionServerToDb(boxPrescription,boxAppointment, object) async {
    final AppointmentBoxController appointmentBoxController  = Get.put(AppointmentBoxController());
    var uuid = object.uuid;
    try {
      if(await boxAppointment.length >0){
        for(int i = 0; i <await boxAppointment.length; i++){
          var appointment = await boxAppointment.getAt(i)!;
          if(appointment.uuid == uuid){
            int appointment_id = appointment.id;
           if(await boxPrescription.length >0){
             final index = await boxPrescription.values.toList().indexWhere((data) => data.appointment_id == appointment_id);
             if(index != -1){
               var existingData = await boxPrescription.getAt(index);
               object.id = existingData.id;
               object.appointment_id = appointment_id;
               await boxPrescription.putAt(index, object);
               await appointmentBoxController.appointmentPrescriptionIsReady(boxAppointment, appointment_id);
               _logger.i('Already Exist in Database, Updated $boxPrescription');
               return true;
             }else{
              List prescriptionList = await boxPrescription.values.toList();
               dynamic maxValue =await prescriptionList.map((e) => e.id).reduce((a,b) => a >b ? a : b);
              object.id =await maxValue + 1;
              object.appointment_id =await appointment_id;
               await boxPrescription.add(object);
              await appointmentBoxController.appointmentPrescriptionIsReady(boxAppointment, appointment_id);
               _logger.i('Success $boxPrescription');
               return true;
             }
           }else{
             object.id =await PreFixIds.defaultPrefixPrescriptionId;
             object.appointment_id =await appointment_id;
             await boxPrescription.add(object);
             await appointmentBoxController.appointmentPrescriptionIsReady(boxAppointment, appointment_id);
             _logger.i('Success $boxPrescription');
           }
          }
        }
      }else{
        _logger.i('No Appointment Found in Database');
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $boxPrescription");
    }
    return null;
  }
  Future<bool?> savePrescriptionDrugServerToDb(Box<PrescriptionDrugModel> boxPrescriptionDrug,Box<PrescriptionModel> boxPrescription, object) async {
    final PrescriptionController prescriptionController = Get.put(PrescriptionController());
    final DrugGenericController drugGenericController = Get.put(DrugGenericController());
    final DrugBrandController drugBrandController = Get.put(DrugBrandController());
    try {
      if(await boxPrescription.length >0){
        for(int i = 0; i <await boxPrescription.length; i++){
          var prescription = await boxPrescription.getAt(i)!;
          if(prescription.web_id == object.prescription_id){
            int? checkWebBrandId;
            int? checkGenericWebId;

            for(int j = 0; j <await drugBrandController.box.length; j++){
              var brands = await drugBrandController.box.getAt(j)!;
              if(brands.web_id == object.brand_id){
                checkWebBrandId =await brands.id;
                print("brandWeb: $checkWebBrandId");
              }
            }
            for(int j = 0; j <await drugGenericController.box.length; j++){
              var generics = await drugGenericController.box.getAt(j)!;
              if(await generics.web_id == object.generic_id){
                checkGenericWebId =await generics.id;
                print("genericWeb: $checkGenericWebId");
              }
            }


            if(checkWebBrandId != null && checkWebBrandId !=0 && checkGenericWebId != null && checkGenericWebId !=0){
              final index = await boxPrescriptionDrug.values.toList().indexWhere((data) => data.uuid == object.uuid && data.brand_id == object.brand_id);
              if(index != -1){
                try{
                  var existingData = await boxPrescriptionDrug.getAt(index);
                  object.id = await existingData?.id;
                  object.brand_id = await checkWebBrandId;
                  object.generic_id =await checkGenericWebId;
                  object.prescription_id =await prescription.id;
                  await boxPrescriptionDrug.putAt(index, object);
                  _logger.i('Already Exist in Database, Updated $boxPrescriptionDrug');
                  return true;
                }catch(e){
                  _logger.e("Error in saveCommon: $e $boxPrescriptionDrug");
                }
              }else{
                try{
                  object?.brand_id = checkWebBrandId;
                  object?.generic_id = checkGenericWebId;
                  object?.prescription_id = prescription.id;
                  int indexNew = await boxPrescriptionDrug.add(object);
                  if(indexNew != -1){
                    print(indexNew);
                    var existingData = await boxPrescriptionDrug.getAt(indexNew);
                    existingData?.id =await indexNew;
                    await boxPrescriptionDrug.putAt(indexNew, existingData!);
                    _logger.i('Success $boxPrescriptionDrug');
                    return true;
                  }
                }catch(e){
                  _logger.e("Error in saveCommon: $e $boxPrescriptionDrug");
                }
              }
            }else{
              _logger.i('Invalid drug id or generic id ${object.brand_id} -> ${object.generic_id}');
            }
          }
        }
      }else{
        _logger.w('No Prescription Found in Database');
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $boxPrescriptionDrug");
    }
    return null;
  }
  Future<bool?> savePrescriptionDrugDoseServerToDb(Box<PrescriptionDrugDoseModel> boxPrescriptionDrugDose,Box<PrescriptionDrugModel> boxPrescriptionDrug, object) async {
    var drug_id = object.drug_id;
    var serial = object.dose_serial;

    try {
      if(await boxPrescriptionDrug.length >0){
        for(int i = 0; i <await boxPrescriptionDrug.length; i++){
          var prescriptionDrug = await boxPrescriptionDrug.getAt(i)!;
          if(prescriptionDrug.web_id == drug_id){
            final index = await boxPrescriptionDrugDose.values.toList().indexWhere((data) => data.drug_id == prescriptionDrug.id && data.prescription_id == prescriptionDrug.prescription_id && data.dose_serial == serial);
            if(index != -1){
              var existingData = await boxPrescriptionDrugDose.getAt(index);
              object.id = await existingData?.id;
              object.drug_id = await prescriptionDrug.id;
              object.prescription_id = await prescriptionDrug.prescription_id;
              await boxPrescriptionDrugDose.putAt(index, object);
              _logger.i('Already Exist in Database, Updated $boxPrescriptionDrugDose');
              return true;
            }else{
              object.drug_id =await prescriptionDrug.id;
              object.prescription_id = await prescriptionDrug.prescription_id;
              int indexNew = await boxPrescriptionDrugDose.add(object);
              if(indexNew != -1){
                var existingData = await boxPrescriptionDrugDose.getAt(indexNew);
                existingData?.id = await indexNew;
                await boxPrescriptionDrugDose.putAt(indexNew, existingData!);
                _logger.i('Success $boxPrescriptionDrugDose');
              }
              return true;
            }
          }
        }
      }else{
        _logger.w('No Drug Found in Database');
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $boxPrescriptionDrugDose");
    }
    return null;
  }
  Future<bool?> saveTemplateServerToDb(boxTemplate, object) async {
    var web_id = object.web_id;
    var templateName = object.template_name;
    try {
        if(templateName.isNotEmpty){
          final index = await boxTemplate.values.toList().indexWhere((data) => data.web_id == web_id);
          if(index != -1){
            var existingData = await boxTemplate.getAt(index);
            object.id = existingData.id;
            await boxTemplate.putAt(index, object);
            _logger.i('Already Exist in Database, Updated $boxTemplate');
            return true;
          }else{
            int indexNew = await boxTemplate.add(object);
            if(indexNew !=-1){
              var existingData = await boxTemplate.getAt(indexNew);
              existingData.id =await indexNew;
              await boxTemplate.putAt(indexNew, existingData);
              _logger.i('Success $boxTemplate');
              return true;
            }else{
              _logger.e('Failed $boxTemplate data inserted but not get');
            }
          }
        }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $boxTemplate");
    }
    return null;
  }
  Future<bool?> saveTemplateDrugServerToDb(Box<PrescriptionTemplateDrugModel> boxTemplateDrug,  boxTemplate,object) async {
    final DrugGenericController drugGenericController = Get.put(DrugGenericController());
    final DrugBrandController drugBrandController = Get.put(DrugBrandController());
    try {
      var brand_id = object.brand_id;
      var generic_id = object.generic_id;
      if(await boxTemplate.length >0){
        for(int i = 0; i <await boxTemplate.length; i++){
          var template = await boxTemplate.getAt(i)!;
          if(template.web_id == object.template_id){
           try{
             int? checkWebBrandId;
             int? checkGenericWebId;
             for(int j = 0; j <await drugBrandController.box.length; j++){
               var brands = await drugBrandController.box.getAt(j)!;
               if(brands.web_id == object.brand_id){
                 checkWebBrandId =await brands.id;
               }
             }
             for(int j = 0; j <await drugGenericController.box.length; j++){
               var generics = await drugGenericController.box.getAt(j)!;
               if(await generics.web_id == object.generic_id){
                 checkGenericWebId =await generics.id;
               }
             }
             if(checkWebBrandId != null  && checkGenericWebId != null){
               final index = await boxTemplateDrug.values.toList().indexWhere((data) => data.uuid == object.uuid);
               if(index != -1){
                 var existingData = await boxTemplateDrug.getAt(index);
                 object.id = await existingData?.id;
                 object.brand_id =await checkWebBrandId;
                 object.generic_id =await checkGenericWebId;
                 object.template_id =await template.id;
                 await boxTemplateDrug.putAt(index, object);
                 _logger.i('Already Exist in Database, Updated $boxTemplateDrug');
                 return true;
               }else{
                 try{
                   object?.brand_id =await checkWebBrandId;
                   object?.generic_id = await checkGenericWebId;
                   object?.template_id = await template.id;
                   int indexNew = await boxTemplateDrug.add(object);
                   if(indexNew !=-1){
                     var existingData = await boxTemplateDrug.getAt(indexNew);
                     existingData?.id =await indexNew;
                     await boxTemplateDrug.putAt(indexNew, existingData!);
                     _logger.i('Success $boxTemplateDrug');
                     return true;
                   }
                 }catch(e){
                   _logger.i('Error $e');
                 }
               }
             }else{
               _logger.i('Error invalid brand or generic $brand_id -> $generic_id ');
             }
           }catch(e){
             _logger.e(e);
           }

          }
        }
      }else{
        _logger.w('No Template Found in Database');
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $boxTemplate");
    }
    return null;
  }
  Future<bool?> saveTemplateDrugDoseServerToDb(Box<PrescriptionTemplateDrugDoseModel> boxTemplateDrugDose,Box<PrescriptionTemplateDrugModel> boxTemplateDrug, object) async {
    var drug_id = object.drug_id;
    var serial = object.dose_serial;
    try {
      if(await boxTemplateDrug.length >0){
        for(int i = 0; i <await boxTemplateDrug.length; i++){
          var templateDrug = await boxTemplateDrug.getAt(i)!;
          print(templateDrug.web_id);
          if(templateDrug.web_id == drug_id){
            final index = await boxTemplateDrugDose.values.toList().indexWhere((data) => data.drug_id == templateDrug.id && data.template_id == templateDrug.template_id && data.dose_serial == serial);
            if(index != -1){
              var existingData = await boxTemplateDrugDose.getAt(index);
              object.id = await existingData?.id;
              object.drug_id = await templateDrug.id;
              object.template_id = await templateDrug.template_id;
              await boxTemplateDrugDose.putAt(index, object);
              _logger.i('Already Exist in Database, Updated $boxTemplateDrugDose');
              return true;
            }else{
              object?.drug_id = await templateDrug.id;
              object.template_id = await templateDrug.template_id;
              int indexNew = await boxTemplateDrugDose.add(object);
              if(indexNew !=-1){
                var existingData = await boxTemplateDrugDose.getAt(indexNew);
                existingData?.id = await indexNew;
                await boxTemplateDrugDose.putAt(indexNew, existingData!);
                _logger.i('Success $boxTemplateDrugDose');
                return true;
              }else{
                _logger.i('Error $boxTemplateDrugDose data inserted but not got' );
              }
            }
          }
        }
      }else{
        _logger.i('Error $boxTemplateDrug is empty' );
      }

    } catch (e) {
      _logger.e("Error in saveCommon: $e $boxTemplateDrugDose");
    }
    return null;
  }


  // Future<bool?> saveAppointmentServerToDb( Box<AppointmentModel> boxAppointment, Box<PatientModel> boxPatient, object) async {
  //   var uuid = object.uuid;
  //   try {
  //     if(boxPatient.isNotEmpty){
  //       var item = await boxPatient.values.toList().firstWhere((data) => data.uuid == uuid && data.web_id == object.patient_id, orElse: () => null);
  //       if(item != null){
  //         int pa_id = item.id;
  //         if(boxAppointment.isNotEmpty){
  //           final index = await boxAppointment.values.toList().indexWhere((data) => data.uuid == uuid,);
  //           int id = index + PreFixIds.defaultPrefixAppId;
  //           if (index != -1) {
  //             object.id = id;
  //             object.patient_id = pa_id;
  //             await boxAppointment.putAt(index, object);
  //             await boxAppointment.getAt(index);
  //             _logger.i('Already Exist in Database, Updated $boxAppointment');
  //           }
  //         } else {
  //           // Handle the case where item is null (if needed)
  //         }
  //       }
  //     }
  //
  //
  //   } catch (e) {
  //     _logger.e("Error in $e: $e $boxAppointment");
  //   }
  //   return null;
  //
  // }



  Future<bool?> saveCommonGenericServerToDb(boxGeneric, object) async {
    int web_id = object.web_id;
    try {
      List bradList = await boxGeneric.values.toList();
      dynamic maxValue = bradList.map((e) => e.id).reduce((a, b) => a > b ? a : b);
      final index = await boxGeneric.values.toList().indexWhere((data) => data.web_id == web_id);
      if(index != -1){
        _logger.i('Already Exist in Database $boxGeneric');
        return true;
      }else{
        object.id = maxValue + 1;
        await boxGeneric.add(object);
        _logger.i('Success $boxGeneric');
        return true;
      }
    } catch (e) {
      _logger.e("Error in saveCommon: $e $boxGeneric");
    }
    return null;
  }
  Future<bool?> saveCompanyCompanyServerToDb(boxCompany, object) async {
    try {
      List bradList = await boxCompany.values.toList();
      dynamic maxValue = bradList.map((e) => e.id).reduce((a, b) => a > b ? a : b);
      int web_id = object.web_id;
      String name = object.company_name;
      if (name.isNotEmpty && web_id != -1) {
        var index = await boxCompany.values.toList().indexWhere((data) => data.web_id == web_id);
        if(index != -1) {
          _logger.i('Already exists $boxCompany');
          return true;
        } else {
          object.id = maxValue + 1;
          var index = await boxCompany.add(object);
            _logger.i('Success $boxCompany');
          return true;
        }
      }
    } catch (e) {
      _logger.e("Error in saveCommon: $e $boxCompany");
    }
    return null;
  }
  Future<bool?> saveCommonBrandServerToDb(boxBrand, object) async {
    try {
      List bradList = await boxBrand.values.toList();
      dynamic maxValue = bradList.map((e) => e.id).reduce((a, b) => a > b ? a : b);
      int web_id = object.web_id;
      String name = object.brand_name;
      if (name.isNotEmpty && web_id != -1) {
        var index = await boxBrand.values.toList().indexWhere((data) => data.web_id == web_id);
        if(index != -1) {
            var existingData = await boxBrand.getAt(index)!;
          _logger.i('Already exists $boxBrand');
          return true;
        } else {
          object.id = maxValue + 1;
          var index = await boxBrand.add(object);
            _logger.i('Success $boxBrand');
        }
      }
    } catch (e) {
      _logger.e("Error in saveCommon: $e $boxBrand");
    }
    return null;
  }

  ///update data form server through api
  Future<bool?> updateCommonServerToDb(box, object) async {
    int id = object.id;
    try {
      final index = await box.values.toList().indexWhere((data) => data.id == id);
      if (index != -1) {
        await box.putAt(index, object);
        _logger.i('Success updated $box');
        return true;
      } else {
        await box.add(object);
        _logger.w("Invalid index $box create for new data");
        return false;
      }
    } catch (e) {
      _logger.e("Error in updateCommon: $e $box");
    }
    return null;
  }
  Future<bool?> updateCertificate(box, object) async {
    try {
      final index = await box.values.toList().indexWhere((data) => data.id == object.id);
      if (index != -1) {
        await box.putAt(index, object);
        _logger.i('Success updated $box');
        return true;
      } else {
        // await box.add(object);
        _logger.w("Invalid index $box create for new data");
        return false;
      }
    } catch (e) {
      _logger.e("Error in updateCommon: $e $box");
    }
    return null;
  }

  Future<bool?> updateFavoriteServerToDb(box, id) async {
    try {
      final index = await box.values.toList().indexWhere((data) => data.id == id);
      if (index != -1) {
        var existingData =await box.getAt(index);
        existingData.u_status = DefaultValues.Synced;
        await box.putAt(index, existingData);
        _logger.i('Success updated $box');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _logger.e("Error in updateCommon: $e $box");
    }
    return null;
  }
  Future<bool?> deleteFavoriteServerToDb(box, id) async {
    try {
      final index = await box.values.toList().indexWhere((data) => data.id == id);
      if (index != -1) {
         await box.deletAt(index);
        _logger.i('Success updated $box');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _logger.e("Error in updateCommon: $e $box");
    }
    return null;
  }
  Future<bool?> updateHistoryServerToDb(box, historyId, patient_id) async {
    try {
      final index = await box.values.toList().indexWhere((data) => data.id == historyId && data.patient_id == patient_id);
      if (index != -1) {
        var existingData= await box.getAt(index);
        existingData.u_status =await DefaultValues.Synced;
        print(existingData.u_status);
        await box.putAt(index, existingData);
        _logger.i('Success updated $box');
        return true;
      } else {
        _logger.w("Invalid index $box ");
        return false;
      }
    } catch (e) {
      _logger.e("Error in updateCommon: $e $box");
    }
    return null;
  }
  Future<bool?> updateDrugBrandServerToDb(boxDrugBrand,brandId,web_id, uuid ) async {
    try {
      final index = await boxDrugBrand.values.toList().indexWhere((data) => data.id == brandId);
      if (index != -1) {
        var existingData = await boxDrugBrand.getAt(index);
        existingData.uuid = uuid;
        existingData.web_id = web_id;
        existingData.u_status = DefaultValues.Synced;
        await boxDrugBrand.putAt(index, existingData);
        _logger.i('Success updated $boxDrugBrand');
        return true;
      } else {
        _logger.w("Invalid index $brandId create for new data");
        return false;
      }
    } catch (e) {
      _logger.e("Error in updateCommon: $e $boxDrugBrand");
    }
    return null;
  }


  Future<bool?> updateAppointmentServerToDb(box,Box<PrescriptionModel>boxPrescription, object) async {
    int appointmentId = object.id;
    String uuid = object.uuid;
    try {
      for(var i =0; i<boxPrescription.values.toList().length;i++){
        var prescription = await boxPrescription.getAt(i);
        if(prescription?.appointment_id == appointmentId){
          var prescriptionId = prescription?.id;
          final index = await boxPrescription.values.toList().indexWhere((data) => data.id == prescriptionId);
          if(index !=-1){
            prescription?.uuid = uuid;
            await boxPrescription.put(index, prescription!);
            _logger.i('Success updated $boxPrescription');
          }
        }
      }

      final index = await box.values.toList().indexWhere((data) => data.id == appointmentId);
      if (index != -1) {
        await box.putAt(index, object);
        _logger.i('Success updated $box');
        return true;
      } else {
        await box.add(object);
        _logger.w("Invalid index $box create for new data");
        return false;
      }

    } catch (e) {
      _logger.e("Error in updateCommon: $e $box");
    }
    return null;
  }
  Future<bool?> updateAppointmentServerToDb2(boxAppointment,boxPrescription, appId, appWebId, appUUID,) async {
    try {

      final index = await boxAppointment.values.toList().indexWhere((data) => data.id == appId);
      final prescriptionIndex = await boxPrescription.values.toList().indexWhere((data) => data.appointment_id == appId);

       if(index != -1 && prescriptionIndex != -1){
         var existingData = await boxAppointment.getAt(index);
         existingData.uuid =await  appUUID;
         existingData.web_id =await  appWebId;
         existingData.u_status = await DefaultValues.Synced;

         await boxAppointment.putAt(index, existingData);

         var prescriptionExistingData = await boxPrescription.getAt(prescriptionIndex);
         prescriptionExistingData?.uuid =await appUUID;
         await boxPrescription.putAt(prescriptionIndex, prescriptionExistingData!);


         _logger.i('Success updated $boxPrescription and $boxAppointment');

         return true;
       }else{
         _logger.w("Invalid index $appId create for new data");
         return false;
       }

    } catch (e) {
      _logger.e("Error in updateCommon: $e $boxAppointment");
    }
    return null;
  }
  Future<bool?> updatePatientServerToDb2( boxPatient, paId, appWebId, uuid,) async {

    try {
      final index = await boxPatient.values.toList().indexWhere((data) => data.id == paId);
       if(index != -1){
         var existingData = await boxPatient.getAt(index);
         existingData.uuid = uuid;
         existingData.u_status = DefaultValues.Synced;
         existingData.web_id = appWebId;
         await boxPatient.putAt(index, existingData);
         _logger.i('Success updated $boxPatient');
         return true;
       }else{
         _logger.w("Invalid index $paId create for new data");
         return false;
       }

    } catch (e) {
      _logger.e("Error in updateCommon: $e $boxPatient");
    }
    return null;
  }
  Future<bool?> updatePrescriptionServerToDb(Box<PrescriptionModel>boxPrescription, prescriptionId, uuid) async {
    try {
      for(var i =0; i <await boxPrescription.length;i++){
        var prescriptions = await boxPrescription.getAt(i);
        if(prescriptions?.id == prescriptionId){
          final index = await boxPrescription.values.toList().indexWhere((data) => data.id == prescriptions?.id);
          if(index !=-1){
            var existingData = await boxPrescription.getAt(index);
            existingData?.u_status =await DefaultValues.Synced;
            existingData?.uuid = await uuid;
            await boxPrescription.put(index, existingData!);
            _logger.i('Success updated status $boxPrescription');
          }else{
            _logger.w("Invalid index $boxPrescription update for existing data");
          }
        }
      }

    } catch (e) {
      _logger.e("Error in updateCommon: $e ");
    }
    return null;
  }
  Future<bool?> updatePrescriptionTemplateServerToDb(Box<PrescriptionTemplateModel>boxPrescriptionTemplate, prescriptionTemplateId,web_id, uuid) async {
    try {
      for(var i =0; i<await boxPrescriptionTemplate.length;i++){
        var prescriptionTemplate = await boxPrescriptionTemplate.getAt(i);
        if(prescriptionTemplate?.id == prescriptionTemplateId){
          final index = await boxPrescriptionTemplate.values.toList().indexWhere((data) => data.id == prescriptionTemplate?.id);
          if(index !=-1){
            var existingData = await boxPrescriptionTemplate.getAt(index);
            existingData?.u_status =await DefaultValues.Synced;
            existingData?.uuid =await uuid;
            existingData?.web_id =await web_id;
            await boxPrescriptionTemplate.put(index, existingData!);
            _logger.i('Success updated status $boxPrescriptionTemplate');
          }
        }
      }

    } catch (e) {
      _logger.e("Error in updateCommon: $e ");
    }
    return null;
  }
  Future<bool?> updateCommonCompanyServerToDb(box, object) async {
    int uuid = object.uuid;
    try {
      final index = await box.values.toList().indexWhere((data) => data.uuid == uuid);
      if (index != -1) {
        await box.putAt(index, object);
        _logger.i('Success updated $box');
        return true;
      } else {
        await box.add(object);
        _logger.w("Invalid index $box create for new data");
        return false;
      }
    } catch (e) {
      _logger.e("Error in updateCommon: $e $box");
    }
    return null;
  }
  Future<bool?> updateCommonGenericServerToDb(box, object) async {
    int generic_id = object.generic_id;
    try {
      final index = await box.values.toList().indexWhere((data) => data.generic_id == generic_id);
      if (index != -1) {
        await box.putAt(index, object);
        _logger.i('Success updated $box');
        return true;
      } else {
        await box.add(object);
        _logger.w("Invalid index $box create for new data");
        return false;
      }
    } catch (e) {
      _logger.e("Error in updateCommon: $e $box");
    }
    return null;
  }
  Future<bool?> updateCommonBrandServerToDb(box, object) async {
    int brand_id = object.brand_id;
    try {
      final index = await box.values.toList().indexWhere((data) => data.brand_id == brand_id);
      if (index != -1) {
        await box.putAt(index, object);
        _logger.i('Success updated $box');
        return true;
      } else {
        await box.add(object);
        _logger.w("Invalid index $box create for new data");
        return false;
      }
    } catch (e) {
      _logger.e("Error in updateCommon: $e $box");
    }
    return null;
  }

  Future<bool?> deleteCommonDbServer(box, id) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.id == id);
      if (index != -1) {
        var existingData = await box.getAt(index);
        existingData.u_status = await DefaultValues.permanentDelete;
        await box.putAt(index, existingData);
        print(existingData.u_status);
        _logger.i('Deleted Success $box');
        return true;
      } else {
        _logger.w("Invalid index $box");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deletePermanentCommon: $e $box");
    }
    return null;
  }
  Future<bool?> deleteCommonServerToDb(box, uuid) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.uuid == uuid);
      if (index != -1) {
        var existingData = await box.getAt(index);
        existingData.u_status = DefaultValues.permanentDelete;
        await box.putAt(index, existingData);
        _logger.i('Deleted Success $box');
        return true;
      } else {
        _logger.w("Delete failed -Invalid index $box");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deletePermanentCommon: $e $box");
    }
    return null;
  }
  Future<bool?> deleteCommonServerToDbByWebId(box, webId) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.web_id == webId);
      if (index != -1) {
        var existingData = await box.getAt(index);
        existingData.u_status = DefaultValues.permanentDelete;
        await box.putAt(index, existingData);
        _logger.i('Deleted Success $box');
        return true;
      } else {
        _logger.w("Delete failed -Invalid index $box");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deletePermanentCommon: $e $box");
    }
    return null;
  }
  Future<bool?> removeChamber(box, id) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.id == id);
      if (index != -1) {
        var existingData = await box.getAt(index);
        existingData.u_status = DefaultValues.permanentDelete;
        await box.putAt(index, existingData);
        _logger.i('Deleted Success $box');
        return true;
      } else {
        _logger.w("Delete failed -Invalid index $box");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deletePermanentCommon: $e $box");
    }
    return null;
  }
  Future<bool?> removeChamberServerSync(box, web_id) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.web_id == web_id);
      if (index != -1) {
        var existingData = await box.getAt(index);
        existingData.u_status = DefaultValues.permanentDelete;
        await box.putAt(index, existingData);
        _logger.i('Deleted Success $box');
        return true;
      } else {
        _logger.w("Delete failed -Invalid index $box");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deletePermanentCommon: $e $box");
    }
    return null;
  }
  Future<bool?> removeDoctorServerSync(box, uuid) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.uuid == uuid);
      if (index != -1) {
        var existingData = await box.getAt(index);
        existingData.u_status = DefaultValues.permanentDelete;
        await box.putAt(index, existingData);
        _logger.i('Deleted Success $box');
        return true;
      } else {
        _logger.w("Delete failed -Invalid index $box");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deletePermanentCommon: $e $box");
    }
    return null;
  }
  Future<bool?> removeCertificateServerSync(box, uuid) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.uuid == uuid);
      if (index != -1) {
        var existingData = await box.getAt(index);
        existingData.u_status = DefaultValues.permanentDelete;
        await box.putAt(index, existingData);
        _logger.i('Deleted Success $box');
        return true;
      } else {
        _logger.w("Delete failed -Invalid index $box");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deletePermanentCommon: $e $box");
    }
    return null;
  }
  Future<bool?> removeInvRImage(box, uuid) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.uuid == uuid);
      if (index != -1) {
        var existingData = await box.getAt(index);
        existingData.u_status = DefaultValues.permanentDelete;
        await box.putAt(index, existingData);
        _logger.i('Deleted Success $box');
        return true;
      } else {
        _logger.w("Delete failed -Invalid index $box");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deletePermanentCommon: $e $box");
    }
    return null;
  }
  Future<bool?> removePaDisImage(box, uuid) async {
    print("object");
    try {
      var index = await box.values.toList().indexWhere((data) => data.uuid == uuid);
      if (index != -1) {
        var existingData = await box.getAt(index);
        existingData.u_status = DefaultValues.permanentDelete;
        await box.putAt(index, existingData);
        _logger.i('Deleted Success $box');
        return true;
      } else {
        _logger.w("Delete failed -Invalid index $box");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deletePermanentCommon: $e $box");
    }
    return null;
  }
  Future<bool?> removeReferralServerSync(box, uuid) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.uuid == uuid);
      if (index != -1) {
        var existingData = await box.getAt(index);
        existingData.u_status = DefaultValues.permanentDelete;
        await box.putAt(index, existingData);
        _logger.i('Deleted Success $box');
        return true;
      } else {
        _logger.w("Delete failed -Invalid index $box");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deletePermanentCommon: $e $box");
    }
    return null;
  }

  Future<bool?> deleteFavoriteToDb(box, id) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.web_id == id);
      if (index != -1) {
        var existingData = await box.getAt(index);
        existingData.u_status = DefaultValues.permanentDelete;
        await box.putAt(index, existingData);
        _logger.i('Deleted Success $box');
        return true;
      } else {
        _logger.w("Invalid index for delete $box");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deletePermanentCommon: $e $box");
    }
    return null;
  }
  Future<bool?> deleteCommonGenericServerToDb(box, uuid) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.uuid == uuid);
      if (index != -1) {
        await box.deleteAt(index)!;
        _logger.i('Success $box');
        return true;
      } else {
        _logger.w("Invalid index $box");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deletePermanentCommon: $e $box");
    }
    return null;
  }
  Future<bool?> deleteCommonBrandServerToDb(box, uuid) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.uuid == uuid);
      if (index != -1) {
        var existingData = await box.getAt(index);
        existingData.u_status = DefaultValues.permanentDelete;
        await box.putAt(index, existingData);
        _logger.i('Success $box');
        return true;
      } else {
        _logger.w("Invalid index $box");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deletePermanentCommon: $e $box");
    }
    return null;
  }

  Future<bool?> deleteCommonCompanyServerToDb(box, uuid) async {
    try {
      var index = await box.values.toList().indexWhere((data) => data.uuid == uuid);
      if (index != -1) {
        await box.deleteAt(index)!;
        _logger.i('Success $box');
        return true;
      } else {
        _logger.w("Invalid index $box");
        return false;
      }
    } catch (e) {
      _logger.e("Error in deletePermanentCommon: $e $box");
    }
    return null;
  }

}
