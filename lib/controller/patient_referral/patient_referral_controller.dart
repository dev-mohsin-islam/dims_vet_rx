

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/models/doctors/doctor_model.dart';
import 'package:dims_vet_rx/models/patient/patient_model.dart';
import 'package:dims_vet_rx/models/patient_referral/patient_referral_model.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';

import '../../database/crud_operations/common_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../models/appointment/appointment_model.dart';
import '../../screens/printing/patient_referral_print/print.dart';
import '../../utilities/default_value.dart';

class PaReferralController extends GetxController {
  final Box<PatientReferralModel> boxPaReferral = Boxes.getPaReferral();
  final Box<DoctorModel> boxDoctor = Boxes.getDoctors();
  final Box<AppointmentModel> boxAppointment = Boxes.getAppointment();
  final Box<PatientModel> boxPatient = Boxes.getPatient();
  final CommonController commonController = Get.put(CommonController());
  RxList paReferralList = [].obs;

  TextEditingController chiefComplain = TextEditingController();
  TextEditingController onExamination = TextEditingController();
  TextEditingController diagnosis = TextEditingController();
  TextEditingController specialNote = TextEditingController();

  RxList selectedRefDoctor = [].obs;


  RxList selectedReasonToRef = [].obs;


   paReferralCUD(id, app_id, method) async {
     if(selectedRefDoctor.isNotEmpty && selectedReasonToRef.isNotEmpty && app_id != null){
       List<String> clinicalInfo = [];
       try{
         if(chiefComplain.text.isNotEmpty){
           clinicalInfo.add("Chief Complaint: "+chiefComplain.text);
         }
         if(onExamination.text.isNotEmpty){
           clinicalInfo.add("On Examination: "+onExamination.text);
         }
         if(diagnosis.text.isNotEmpty){
           clinicalInfo.add("Diagnosis: "+diagnosis.text);
         }

         var paReferralModel = PatientReferralModel(
           id: id,
           app_id: app_id.toString(),
           referred_to: selectedRefDoctor[0].id,
           clinical_information: clinicalInfo.map((e) => e).join('\n').toString(),
           special_notes: specialNote.text,
           reason_for_referral: selectedReasonToRef.map((e) => e).join('\n').toString(),
           referred_by: '',
           date: DateTime.now().toString(),
           u_status: DefaultValues.NewAdd,

         );
         if(method=="create"){
          int? resId = await commonController.saveRefPat(boxPaReferral, paReferralModel, 'add');

          if(resId != null){

           await getRefPaForPrint(resId);
          }
         }else if(method=="update"){
           await commonController.saveRefPat(boxPaReferral, paReferralModel, 'update');
         }else if(method=="delete"){
           await commonController.saveRefPat(boxPaReferral, paReferralModel, 'delete');
         }
       }catch(e){
         print(e);
       }
     }else{
       Helpers.successSnackBar("Failed", "Please enter required details");
     }
     // getRefPa('');

  }

  getRefPa(searchText)async{
    var response = await commonController.getRefPatient(boxPaReferral, searchText);

    print(response.length);
    paReferralList.clear();
    var paReferralSingle;
    if(response.isNotEmpty){
      try{
        for(var i = 0; i < response.length; i++){
          var paRefsAppId = response[i].app_id;
          var paRefsDocId = response[i].referred_to;
          if(paRefsAppId != null && paRefsDocId != null){
            var refDocInfo = await boxDoctor.values.toList().firstWhere((element) => element.id == paRefsDocId, orElse: null);
            var paRefsAppInfo = await boxAppointment.values.toList().firstWhere((element) => element.id == parseInt(paRefsAppId), orElse: null);
            var refPaId = paRefsAppInfo.patient_id;
            var refPaInfo = await boxPatient.values.toList().firstWhere((element) => element.id == refPaId);
            if(parseInt(paRefsAppId) ==paRefsAppInfo.id && paRefsDocId == refDocInfo.id && refPaId == refPaInfo.id){
              var refJoinPatient = {
                'refDocInfo': refDocInfo,
                'paRefsAppInfo': paRefsAppInfo,
                'refPaInfo': refPaInfo,
                'refInfo': response[i],
              };
              paReferralList.add(refJoinPatient);
              if(response.length == 1){
                paReferralSingle =refJoinPatient;
              }
            }

          }
        }
        return paReferralSingle;
      }catch(e){
        print(e);
      }
      // paReferralList.addAll(response);
    }

  }
  getRefPaForPrint(id)async{
    var res =await getRefPa(id);
    print(res);
    if(res != null){
      Navigator.push(Get.context!, MaterialPageRoute(builder: (context) => PatientReferralPrint( referralInformation: res,)));
    }

  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getRefPa("");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    chiefComplain.dispose();
    onExamination.dispose();
    diagnosis.dispose();
    specialNote.dispose();

  }

}