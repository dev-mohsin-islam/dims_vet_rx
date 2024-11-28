

import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/database/crud_operations/common_crud.dart';
import 'package:dims_vet_rx/utilities/default_value.dart';

import '../../database/hive_get_boxes.dart';
import '../../models/doctors/doctor_model.dart';

class DoctorCreateController extends GetxController {
  final Box<DoctorModel> boxDoctor = Boxes.getDoctors();
  final CommonController commonController = CommonController();
  RxList doctorList = [].obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  saveDoctor(id, method)async{
    final doctor = DoctorModel(
        id: id,
        name: nameController.text,
        degree: degreeController.text,
        designation: designationController.text,
        phone: phoneController.text,
        address: addressController.text,
        uuid: '',
        date: DateTime.now().toString(),
        u_status: DefaultValues.NewAdd,
    );
    if(method == 'create'){
      var response = await commonController.saveRefDoc(boxDoctor, doctor, 'add');
    }else if(method == 'update'){
      var response = await commonController.saveRefDoc(boxDoctor, doctor, 'update');
    }else if(method == 'delete'){
      var response = await commonController.saveRefDoc(boxDoctor, doctor, 'delete');
    }

    nameController.clear();
    degreeController.clear();
    designationController.clear();
    phoneController.clear();
    addressController.clear();

    getData('');
  }
  // updateDoctor(id)async{
  //   final doctor = DoctorModel(
  //       id: id,
  //       name: nameController.text,
  //       degree: degreeController.text,
  //       designation: designationController.text,
  //       phone: phoneController.text,
  //       address: addressController.text,
  //       uuid: '',
  //       date: DateTime.now().toString(),
  //       u_status: DefaultValues.Update,
  //   );
  //   var response = await commonController.saveRefDoc(boxDoctor, doctor, 'update');
  //   getData('');
  // }

  Future<void>getData(searchText)async{
    var response = await commonController.getAllDataCommon(boxDoctor, searchText);
    doctorList.clear();
    if(response.isNotEmpty){
      doctorList.addAll(response);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData('');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    degreeController.dispose();
    designationController.dispose();
    phoneController.dispose();
    addressController.dispose();


  }

}
