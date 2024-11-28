

 import 'package:dims_vet_rx/models/patient/patient_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../database/crud_operations/patient_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../utilities/default_value.dart';

class PatientController extends GetxController{
  final PatientCRUDController patientBoxController = Get.put(PatientCRUDController());
  final Box<PatientModel>box = Boxes.getPatient();
  final RxList dataList =  [].obs;
  final TextEditingController nameController= TextEditingController();

  final TextEditingController searchController= TextEditingController();
  RxBool isLoading = true.obs;

  final uuid = DefaultValues.defaultUuid;
  final date = DefaultValues.defaultDate;
  final web_id = DefaultValues.defaultweb_id;
  final statusNewAdd = DefaultValues.NewAdd;
  final statusUpdate = DefaultValues.Update;
  final statusDelete = DefaultValues.Delete;


  RxInt  sexController = 0.obs;
  var dobController = ''.obs;
  var marital_statusController = 0.obs;
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController guardian_nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController blood_groupController = TextEditingController();



  // void addData(id)async{
  //   try {
  //     if(nameController.text.trim().isNotEmpty){
  //       await patientBoxController.savePatient(box,
  //           PatientModel(
  //             id: id,
  //             name: patientNameController.text,
  //             uuid:uuid,
  //             date:date,
  //             u_status: statusNewAdd,
  //             web_id: web_id,
  //             dob:dobController.toString(),
  //             sex: sexController.toInt(),
  //             marital_status: marital_statusController.toInt(),
  //             guardian_name:guardian_nameController.toString(),
  //             phone: phoneController.text,
  //             email: emailController.text,
  //             area: areaController.text,
  //             occupation: occupationController.text,
  //             education: educationController.text,
  //             blood_group: 0,
  //           ));
  //
  //       nameController.clear();
  //       await getAllData('');
  //     }
  //   }catch(e){
  //
  //   }
  //   // isLoading.value = false;
  // }

  Future<void> updateData(id)async{
    // await patientBoxController.updatePatient(box, id, nameController.text.trim(), statusUpdate);
    nameController.clear();
    dataList.refresh();
    // isLoading.value = false;
  }


  // soft delete data
  Future<void> deleteData(id)async{
    try {
      await patientBoxController.deleteCommon(box, id, statusDelete);
      getAllData('');
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting data: $e");
      }
    }
    // isLoading = false;
  }



  Future<void> getAllData(String searchText)async{
    isLoading.value = true;
    var response = await patientBoxController.getAllPatient(box, searchText);
    dataList.clear();
    dataList.addAll(response);
    isLoading.value = false;
  }

  clearText()async{
    dataList.clear();
    nameController.clear();
    searchController.clear();
    await getAllData('');
  }


  @override
  void onInit() {
    // TODO: implement onInit
    getAllData('');
    super.onInit();
  }

  @override
  void dispose() {
    dataList;
    nameController;
    searchController;
    uuid;

    super.dispose();
  }

}



