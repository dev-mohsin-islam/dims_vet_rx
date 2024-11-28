



import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/database/crud_operations/common_crud.dart';
import 'package:dims_vet_rx/models/referral_short/referral_short_model.dart';

import '../../database/hive_get_boxes.dart';
import '../../utilities/default_value.dart';

class ReferralShortController extends GetxController{
  CommonController commonController = CommonController();
  final Box<ReferralShortModel>boxReferralShort = Boxes.getReferralShort();
  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  RxList dataList =  [].obs;

  saveAndEditReferralShort(int id,method)async{

    if(nameController.text.isNotEmpty && detailsController.text.isNotEmpty){
      ReferralShortModel referralShort = ReferralShortModel(id: id, date: DefaultValues.defaultDate,u_status: DefaultValues.NewAdd, name: nameController.text, details: detailsController.text);
      await commonController.saveTreatmentPlan(boxReferralShort, referralShort,method);

    }
    getAllReferralShort('');
    nameController.clear();
    detailsController.clear();
  }

  deleteReferralShort(int id)async{
    await commonController.deleteCommon(boxReferralShort, id, DefaultValues.Delete);
    getAllReferralShort('');
  }

  getAllReferralShort(searchText)async{
    dataList.clear();
    var response =await commonController.getAllDataCommon(boxReferralShort,searchText);
    if(response.length >0){
      dataList.addAll(response);
    }
  }


  @override
  void onInit() {
    // TODO: implement onInit
    getAllReferralShort('');
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    detailsController.dispose();

    super.dispose();
  }
}