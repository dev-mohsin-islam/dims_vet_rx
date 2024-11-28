

import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../database/hive_get_boxes.dart';
class VetController extends GetxController{
  final boxVet = Boxes.getVet();
  TextEditingController petNameController = TextEditingController();

  RxList petTypeList = [].obs;

  RxString selectedPetType = "".obs;

  Future<void>createPetType()async{
    if(petNameController.text.isNotEmpty && petTypeList.contains(petNameController.text) == false){
      await boxVet.add(petNameController.text);
      await getPetType();
      petNameController.clear();
    }

  }
  Future getPetType()async{
    petTypeList.clear();
    var response = await boxVet.values.toList();
    if(response.isNotEmpty){
      response.sort((a, b) => a.compareTo(b));
      petTypeList =await response.obs;
    }
  }
  Future deletePetType(String name)async{
    var index = await boxVet.values.toList().indexWhere((data) => data == name);
    if(index >= 0){
      await boxVet.deleteAt(index);
      await getPetType();
    }

  }
  Future initialCall()async{
    await getPetType();
  }

  @override
  void onInit() {
    initialCall();
    // TODO: implement onInit
    super.onInit();
  }
}