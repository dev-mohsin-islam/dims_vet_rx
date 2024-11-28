

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/database/crud_operations/common_crud.dart';
import 'package:dims_vet_rx/models/chambers/chamber_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/hive_get_boxes.dart';
import '../../utilities/app_strings.dart';
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';

class ChamberController extends GetxController{
  CommonController commonController = Get.put(CommonController());
  Box<ChamberModel>boxChamber = Boxes.getChamber();
  RxList chamberList = [].obs;
  TextEditingController chamberName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController nplCode = TextEditingController();

  RxString activeChamberName = "".obs;


  saveChamber()async{
    if(chamberName.text.isNotEmpty){
      ChamberModel chamberModel = ChamberModel(
        id: boxChamber.length + 1,
        chamber_name: chamberName.text,
        uuid: 'uuid',
        date: DateTime.now().toString(),
        u_status: DefaultValues.NewAdd,
        web_id: 0,
        chamber_address: chamberName.text,
        npl_code: nplCode.text,
      );
      await commonController.saveChamber(boxChamber, chamberModel);
      chamberName.clear();
      nplCode.clear();
      address.clear();
      getChamber('');
    }

  }

  updateChamber(id)async{
    ChamberModel chamberModel = ChamberModel(
      id: boxChamber.length + 1,
      chamber_name: chamberName.text,
      uuid: 'uuid',
      date: DateTime.now().toString(),
      u_status: DefaultValues.Update,
      web_id: null,
      chamber_address: chamberName.text,
      npl_code: nplCode.text,
    );
    await commonController.updateChamber(boxChamber, id, chamberName.text, DefaultValues.Update);
    chamberName.clear();
    nplCode.clear();
    address.clear();

    getChamber('');
  }

  removeChamber(chamberId){
    commonController.deleteCommon(boxChamber, chamberId, DefaultValues.Delete);
    getChamber('');
  }

  getChamber(searchText)async {
    var response = await commonController.getChamber(boxChamber, searchText);
    chamberList.clear();
   if(response.isNotEmpty){
     chamberList.addAll(response);
   }
  }

  initCall()async{
   await getChamber('');
    int activeChamberId = await getIntStoreKeyWithValue(syncTimeSharedPrefsKey.activeChamberId);
    chamberList.forEach((element) {
      if(element.id == activeChamberId){
        activeChamberName.value = element.chamber_name;
      }
    });
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initCall();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    chamberName.dispose();
    nplCode.dispose();
    address.dispose();
    super.dispose();
  }
}

