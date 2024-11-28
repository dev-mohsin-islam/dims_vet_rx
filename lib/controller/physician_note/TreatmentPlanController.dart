

import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/database/crud_operations/common_crud.dart';
import 'package:dims_vet_rx/models/physician_notes/physician_notes_model.dart';

import '../../database/hive_get_boxes.dart';
import '../../models/treatment_plan/treatment_plan_model.dart';
import '../../utilities/default_value.dart';

class PhysicianNoteController extends GetxController{
  CommonController commonController = CommonController();
  final Box<PhysicianNoteModel>boxPhysicianNote = Boxes.getPhysicianNote();
  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  RxList dataList =  [].obs;

  saveAndEditPhysicianNote(int id,method)async{

    if(nameController.text.isNotEmpty && detailsController.text.isNotEmpty){
     PhysicianNoteModel physicianNote = PhysicianNoteModel(id: id, date: DefaultValues.defaultDate,u_status: DefaultValues.NewAdd, name: nameController.text, details: detailsController.text);
       await commonController.saveTreatmentPlan(boxPhysicianNote, physicianNote,method);

    }
    getAllPhysicianNote('');
    nameController.clear();
    detailsController.clear();
  }

  deletePhysicianNote(int id)async{
    await commonController.deleteCommon(boxPhysicianNote, id, DefaultValues.Delete);
    getAllPhysicianNote('');
  }

  getAllPhysicianNote(searchText)async{
    dataList.clear();
    var response =await commonController.getAllDataCommon(boxPhysicianNote,searchText);
    if(response.length >0){
      dataList.addAll(response);
    }
  }


@override
  void onInit() {
    // TODO: implement onInit
  getAllPhysicianNote('');
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