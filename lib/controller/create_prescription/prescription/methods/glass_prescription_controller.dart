

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../database/hive_get_boxes.dart';
import '../../../../utilities/helpers.dart';

class GlassPrescriptionController extends GetxController{
  final boxGlassPrescription = Boxes.getGlassPrescription();


  RxBool isDataExist = false.obs;
  TextEditingController drSphereController = TextEditingController();
  TextEditingController drCylinderController = TextEditingController();
  TextEditingController drAxisController = TextEditingController();
  TextEditingController drVAController = TextEditingController();
  TextEditingController dlSphereController = TextEditingController();
  TextEditingController dlCylinderController = TextEditingController();
  TextEditingController dlAxisController = TextEditingController();
  TextEditingController dlVAController = TextEditingController();
  TextEditingController nrSphereController = TextEditingController();
  TextEditingController nlSphereController = TextEditingController();
  TextEditingController ipdController = TextEditingController();

  RxList remarks = ['Unifocal', 'Bifocal', 'Progressive', 'White', 'Photosun', 'Anti-Reflective','Blue-Cut', 'MC'].obs;
  RxList forData = ['Constant', 'Near Use',].obs;
  RxList selectedRemarks = [].obs;
  RxList selectedFor = [].obs;

  Future<void> saveGlassPrescription(patientId, appointmentId)async{
     var glassPresData = {
       'patientId':  patientId,
       "Distance Right Sphere": drSphereController.text,
       "Distance Right Cylinder": drCylinderController.text,
       "Distance Right Axis": drAxisController.text,
       "Distance Right V/A": drVAController.text,
       "Distance Left Sphere": dlSphereController.text,
       "Distance Left Cylinder": dlCylinderController.text,
       "Distance Left Axis": dlAxisController.text,
       "Distance Left VA": dlVAController.text,
       "Near Add Right Sphere": nrSphereController.text,
       "Near Add Left Sphere": nlSphereController.text,
       "IDP": ipdController.text,
       "Remarks": selectedRemarks,
       "For": selectedFor
     };

     var jsonGlassData = jsonEncode(glassPresData);
     final jsonGlassDataJsonMap = jsonDecode(jsonGlassData) as Map<String, dynamic>;
     await boxGlassPrescription.put('${appointmentId.toString()}', jsonGlassDataJsonMap);
     getGlassPress();
  }
  Future<void>getGlassPress()async{
    var response = await boxGlassPrescription.values;
  }
  Future getGlassPressSingle(appointmentId)async{
    print("glass appointmentId");
    print(appointmentId);
    var response = await boxGlassPrescription.get('${appointmentId}');print(response);
    return response;
  }

  clearData(){
    drSphereController.clear();
    drCylinderController.clear();
    drAxisController.clear();
    drVAController.clear();
    dlSphereController.clear();
    dlCylinderController.clear();
    dlAxisController.clear();
    dlVAController.clear();
    nrSphereController.clear();
    nlSphereController.clear();
    ipdController.clear();

    selectedRemarks.clear();
    selectedFor.clear();
    isDataExist.value = false;
  }

  Future initialCall()async{
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initialCall();
  }

}
