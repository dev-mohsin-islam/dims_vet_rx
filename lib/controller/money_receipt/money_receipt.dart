

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/database/crud_operations/common_crud.dart';
import 'package:dims_vet_rx/models/appointment/appointment_model.dart';

import '../../database/hive_get_boxes.dart';
import '../../models/money_receipt/money_receipt_model.dart';
import '../../models/patient/patient_model.dart';
import '../../screens/printing/money_receipet_print/mone_receipt_print.dart';

class MoneyReceiptCont extends GetxController{
  final Box<MoneyReceiptModel> boxMoneyReceipt = Boxes.getMoneyReceipt();
  final Box<PatientModel> boxPatient = Boxes.getPatient();
  final Box<AppointmentModel> boxAppointment = Boxes.getAppointment();
  final CommonController commonController = Get.put(CommonController());
  final feeController = TextEditingController();
  final descriptionController = TextEditingController();
  RxList moneyReceipts = [].obs;

  saveMoneyReceipt(id, app_id, method)async{
    try{
       if(feeController.text.isNotEmpty){
         var moneyReceiptModel = MoneyReceiptModel(
           id: id,
           app_id: app_id,
           fee: feeController.text,
           description: descriptionController.text,
           invoice_id: app_id,
           date: DateTime.now().toString(),
         );
         if(method == "create"){
           int? resId = await commonController.saveMoneyReceipt(boxMoneyReceipt, moneyReceiptModel, 'add');
           if(resId != null){
            print(resId);
            await getMoneyResPrint(resId);

           }
         }
         if(method == "update"){
           await commonController.saveMoneyReceipt(boxMoneyReceipt, moneyReceiptModel, 'update');
         }
         if(method == "delete"){
           await commonController.saveMoneyReceipt(boxMoneyReceipt, moneyReceiptModel, 'delete');
         }
       }
    }catch(e){
      print("Error in saveMoneyReceipt: $e");
    }
  }

  getMoneyReceipt(searchText)async{
    try{
      List SingleMoneyReceipt = [];
      moneyReceipts.clear();
      SingleMoneyReceipt.clear();
       List? resMoneyRec = await commonController.getMoneyReceipt(boxMoneyReceipt, searchText);
       if( resMoneyRec != null){
         for(var i =0; i < resMoneyRec.length; i++ ){

           int paId = resMoneyRec[i].app_id;
             var appInfo = await boxAppointment.values.firstWhere((element) => element.id == paId );
             var paInfo = await boxPatient.values.firstWhere((element) => element.id == appInfo.patient_id);
              var element = {
                "moneyRecInfo": resMoneyRec,
                "paInfo": paInfo
              };
             moneyReceipts.add(element);
             if(resMoneyRec.length == 1){
               SingleMoneyReceipt.add(element);
             }
         }
       }
       return SingleMoneyReceipt;
    }catch(e){
      print("Error in getMoneyReceipt: $e");
    }
  }

  getMoneyResPrint(id)async{
    var resMoneyRec =await getMoneyReceipt(id);

    print(resMoneyRec.length);
    if(resMoneyRec != null){
      Navigator.push(Get.context!, MaterialPageRoute(builder: (context) => MoneyReceiptPrint(MoneyReceiptPrintInfo: resMoneyRec,)));

    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getMoneyReceipt('');
  }

  //create a dispose method to close the hive box
  @override
  void dispose() {
    boxMoneyReceipt.close();
    super.dispose();
  }

}