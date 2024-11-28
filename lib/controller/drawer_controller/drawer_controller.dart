

import 'package:get/get.dart';

class DrawerMenuController extends GetxController{
  RxInt selectedMenuIndex = 0.obs;
  RxInt commonClinicalPopupCurrentScreen = 0.obs;
  RxInt endDrawerCurrentScreen = 0.obs;


}


class EndDrawerScreenValues{
  static const int chiefComplain =0;
  static const int onExamination =1;
  static const int diagnosis =2;
  static const int investigationAdvice =3;
  static const int investigationReport =4;
  static const int personalHistory =5;
  static const int allergyHistory =5;
  static const int socialHistory =5;
  static const int familyHistory =5;
  static const int procedure =6;
  static const int investigationReportImage =7;
  static const int appointment =8;
  static const int patientDiseaseImageUpload =9;
  static const int patientHistory =10;
  static const int addMedicine =11;
  static const int history =11;
}