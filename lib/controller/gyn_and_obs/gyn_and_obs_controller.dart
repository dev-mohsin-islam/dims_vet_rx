
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:hive/hive.dart';

import '../../database/hive_get_boxes.dart';

class GynAndObsController extends GetxController{
  final Box boxGynAndObs = Boxes.getChildHistory();
  RxBool isDataExist = false.obs;
  RxBool isParaExpanded = false.obs;
  RxBool isGynAndObsExpanded = false.obs;
  RxBool isSexualIsExpanded = false.obs;
  RxBool isMenstrualExpanded = false.obs;
  RxInt screenIndex = 0.obs;
  TextEditingController paraGynController= TextEditingController();
  TextEditingController paraPynController= TextEditingController();
  TextEditingController paraLynController= TextEditingController();
  TextEditingController paraTController= TextEditingController();
  TextEditingController paraAynController= TextEditingController();
  TextEditingController paraParityController= TextEditingController();
  TextEditingController paraAgeLastChildController= TextEditingController();
  TextEditingController sexualFrequencyController = TextEditingController();
  TextEditingController MenstrualCycleController = TextEditingController();
  TextEditingController MenstrualPeriodController = TextEditingController();
  TextEditingController MenstrualPLMPController = TextEditingController();
  TextEditingController MenstrualMenarcheController = TextEditingController();
  TextEditingController MenstrualEDDController = TextEditingController();
  TextEditingController MenstrualLDDController = TextEditingController();
  TextEditingController MenstrualMenopauseController = TextEditingController();

  RxString ageLastChild = "Years".obs;
  RxString typeOfDelivery = "".obs;
  RxString Amenorrhoea = "".obs;
  RxString Engagement = "".obs;
  RxString FetalMovement = "".obs;
  RxString Presentation = "".obs;
  RxString FetalHeart = "".obs;
  RxString Contraceptive = "".obs;
  RxString Dyspareunia = "".obs;
  RxString PostCoitalBleeding = "".obs;

  //Menstrual History
  RxString Dysmenorrhea = "".obs;
  RxString AmountofFlow = "".obs;

  DateTime firstDate = DateTime(2024, 5, 1);
  DateTime lastDate = DateTime(2024, 5, 31);

  // Selected date range (initially null)
  DateTimeRange? selectedDateRange;

  Future<void> selectDateRange() async {
    selectedDateRange = await showDateRangePicker(
      context: Get.context!,
      initialDateRange: selectedDateRange ?? DateTimeRange(
        start: firstDate,
        end: firstDate,
      ),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (selectedDateRange != null) {

    }
  }

  typeOfDeli(value){
    typeOfDelivery.value = value;
  }

  ageOfLastChild(value){
    paraAgeLastChildController.value = value;
  }

  Future<void>savePatientGynHistory(patientID)async{
    print("gyn called");
    if(isDataExist.value==true){
      print("gyn ture save");
      var jsonHistory = {
        "patientId": patientID,
        "paraGynController": paraGynController.text,
        "paraPynController": paraPynController.text,
        "paraLynController": paraLynController.text,
        "paraTController": paraTController.text,
        "paraAynController": paraAynController.text,
        "paraParityController": paraParityController.text,
        "paraAgeLastChildController": paraAgeLastChildController.text,
        "sexualFrequencyController": sexualFrequencyController.text,
        "MenstrualCycleController": MenstrualCycleController.text,
        "MenstrualPeriodController": MenstrualPeriodController.text,
        "MenstrualPLMPController": MenstrualPLMPController.text,
        "MenstrualMenarcheController": MenstrualMenarcheController.text,
        "MenstrualEDDController": MenstrualEDDController.text,
        "MenstrualLDDController": MenstrualLDDController.text,
        "MenstrualMenopauseController": MenstrualMenopauseController.text,
        "ageLastChild": ageLastChild.value,
        "typeOfDelivery": typeOfDelivery.value,
        "Amenorrhoea": Amenorrhoea.value,
        "Engagement": Engagement.value,
        "FetalMovement": FetalMovement.value,
        "Presentation": Presentation.value,
        "FetalHeart": FetalHeart.value,
        "Contraceptive": Contraceptive.value,
        "Dyspareunia": Dyspareunia.value,
        "PostCoitalBleeding": PostCoitalBleeding.value,
        "Dysmenorrhea": Dysmenorrhea.value,
        "AmountofFlow": AmountofFlow.value,

      };
      var gynHistoryJson = jsonEncode(jsonHistory);
      var gynHistoryMap = jsonDecode(gynHistoryJson) as Map<String, dynamic>;
      print("gynHistoryMap");
      print(gynHistoryMap);
      await boxGynAndObs.put('$patientID', gynHistoryMap);
    }

  }
  Future<void>saveFromSeverToLocal(patientID, jsonHistory)async {
    var jsonH = jsonEncode(jsonHistory);
    var gynHistoryMap = jsonDecode(jsonH) as Map<String, dynamic>;
    await boxGynAndObs.put('$patientID', gynHistoryMap);
  }
  Future<List<String?>> getAllGynHistory(patientID)async{
    var response =await boxGynAndObs.get('$patientID');
    if(response != null){
      paraGynController.text = response['paraGynController']?? '';
      paraPynController.text = response['paraPynController']?? '';
      paraLynController.text = response['paraLynController']?? '';
      paraTController.text = response['paraTController']?? '';
      paraAynController.text = response['paraAynController']?? '';
      paraParityController.text = response['paraParityController']?? '';
      paraAgeLastChildController.text = response['paraAgeLastChildController']?? '';
      sexualFrequencyController.text = response['sexualFrequencyController']?? '';
      MenstrualCycleController.text = response['MenstrualCycleController']?? '';
      MenstrualPeriodController.text = response['MenstrualPeriodController']?? '';
      MenstrualPLMPController.text = response['MenstrualPLMPController']?? '';
      MenstrualMenarcheController.text = response['MenstrualMenarcheController']?? '';
      MenstrualEDDController.text = response['MenstrualEDDController']?? '';
      MenstrualLDDController.text = response['MenstrualLDDController']?? '';
      MenstrualMenopauseController.text = response['MenstrualMenopauseController']?? '';
      ageLastChild.value = response['ageLastChild']?? '';
      typeOfDelivery.value = response['typeOfDelivery']?? '';
      Amenorrhoea.value = response['Amenorrhoea']?? '';
      Engagement.value = response['Engagement']?? '';
      FetalMovement.value = response['FetalMovement']?? '';
      Presentation.value = response['Presentation']?? '';
      FetalHeart.value = response['FetalHeart']?? '';
      Contraceptive.value = response['Contraceptive']?? '';
      Dyspareunia.value = response['Dyspareunia']?? '';
      PostCoitalBleeding.value = response['PostCoitalBleeding']?? '';
      Dysmenorrhea.value = response['Dysmenorrhea']?? '';
      AmountofFlow.value = response['AmountofFlow']?? '';

      isDataExist.value = true;


      //this list for printing
      List<String?> gynHistoryList = [];

      if (paraGynController.text != '') {
        gynHistoryList.add('Para Gyn: ' + paraGynController.text);
      }
      if (paraPynController.text != '') {
        gynHistoryList.add('Para Pyn: ' + paraPynController.text);
      }
      if (paraLynController.text != '') {
        gynHistoryList.add('Para Lyn: ' + paraLynController.text);
      }
      if (paraTController.text != '') {
        gynHistoryList.add('Para T: ' + paraTController.text);
      }
      if (paraAynController.text != '') {
        gynHistoryList.add('Para Ayn: ' + paraAynController.text);
      }
      if (paraParityController.text != '') {
        gynHistoryList.add('Para Parity: ' + paraParityController.text);
      }
      if (paraAgeLastChildController.text != '') {
        gynHistoryList.add('Para Age Last Child: ' + paraAgeLastChildController.text);
      }
      if (sexualFrequencyController.text != '') {
        gynHistoryList.add('Sexual Frequency: ' + sexualFrequencyController.text);
      }
      if (MenstrualCycleController.text != '') {
        gynHistoryList.add('Menstrual Cycle: ' + MenstrualCycleController.text);
      }
      if (MenstrualPeriodController.text != '') {
        gynHistoryList.add('Menstrual Period: ' + MenstrualPeriodController.text);
      }
      if (MenstrualPLMPController.text != '') {
        gynHistoryList.add('Menstrual PLMP: ' + MenstrualPLMPController.text);
      }
      if (MenstrualMenarcheController.text != '') {
        gynHistoryList.add('Menstrual Menarche: ' + MenstrualMenarcheController.text);
      }
      if (MenstrualEDDController.text != '') {
        gynHistoryList.add('Menstrual EDD: ' + MenstrualEDDController.text);
      }
      if (MenstrualLDDController.text != '') {
        gynHistoryList.add('Menstrual LDD: ' + MenstrualLDDController.text);
      }
      if (MenstrualMenopauseController.text != '') {
        gynHistoryList.add('Menstrual Menopause: ' + MenstrualMenopauseController.text);
      }
      if (ageLastChild.value != '') {
        gynHistoryList.add('Age Last Child: ' + ageLastChild.value);
      }
      if (typeOfDelivery.value != '') {
        gynHistoryList.add('Type of Delivery: ' + typeOfDelivery.value);
      }
      if (Amenorrhoea.value != '') {
        gynHistoryList.add('Amenorrhoea: ' + Amenorrhoea.value);
      }
      if (Engagement.value != '') {
        gynHistoryList.add('Engagement: ' + Engagement.value);
      }
      if (FetalMovement.value != '') {
        gynHistoryList.add('Fetal Movement: ' + FetalMovement.value);
      }
      if (Presentation.value != '') {
        gynHistoryList.add('Presentation: ' + Presentation.value);
      }
      if (FetalHeart.value != '') {
        gynHistoryList.add('Fetal Heart: ' + FetalHeart.value);
      }
      if (Contraceptive.value != '') {
        gynHistoryList.add('Contraceptive: ' + Contraceptive.value);
      }
      if (Dyspareunia.value != '') {
        gynHistoryList.add('Dyspareunia: ' + Dyspareunia.value);
      }
      if (PostCoitalBleeding.value != '') {
        gynHistoryList.add('Post-Coital Bleeding: ' + PostCoitalBleeding.value);
      }
      if (Dysmenorrhea.value != '') {
        gynHistoryList.add('Dysmenorrhea: ' + Dysmenorrhea.value);
      }
      if (AmountofFlow.value != '') {
        gynHistoryList.add('Amount of Flow: ' + AmountofFlow.value);
      }

      return gynHistoryList;
    }else{
      isDataExist.value = false;
      return [];
    }
  }
  Future getForSaveToServer(patientId)async {
    var response = await boxGynAndObs.get("$patientId");
    if(response != null){
      return response;
    }else{
      return null;
    }
  }

  dataClear(){
    if(isDataExist.value == true){
      paraGynController.clear();
      paraPynController.clear();
      paraLynController.clear();
      paraTController.clear();
      paraAynController.clear();
      paraParityController.clear();
      paraAgeLastChildController.clear();
      sexualFrequencyController.clear();
      MenstrualCycleController.clear();
      MenstrualPeriodController.clear();
      MenstrualPLMPController.clear();
      MenstrualMenarcheController.clear();
      MenstrualEDDController.clear();
      MenstrualLDDController.clear();
      MenstrualMenopauseController.clear();
      isDataExist.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    paraGynController.dispose();
    paraPynController.dispose();
    paraLynController.dispose();
    paraTController.dispose();
    paraAynController.dispose();
    paraParityController.dispose();
    paraAgeLastChildController.dispose();
    sexualFrequencyController.dispose();
    MenstrualCycleController.dispose();
    MenstrualPeriodController.dispose();
    MenstrualPLMPController.dispose();
    MenstrualMenarcheController.dispose();
    MenstrualEDDController.dispose();
    MenstrualMenopauseController.dispose();

    super.dispose();
  }
}