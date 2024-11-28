import 'package:get/get.dart';

import 'helpers.dart';

class AppointmentDefaultValue{
  static const defaultReportPatient = null;
  static const int defaultFee = 0;
  static const defaultImprovement = null;
  static const defaultMedicine = '';
  static const defaultComplain = '';
  static const defaultRr = null;
  static const defaultHip = null;
  static const defaultWaist = null;
  static const defaultOFC = null;
  static const defaultHeight = null;
  static const defaultWeight = null;
  static const defaultTemparature = null;
  static const defaultDys_blood_pressure = null;
  static const defaultSys_blood_pressure = null;
  static const defaultPulse = null;
  static const defaultNext_visit = null;

}

class PatientDefaultValues{
  static const defaultName = "";
  static const defaultSex = null;
  static const defaultMaritalStatus = 1;
  static const defaultDob = null;
  static const defaultGuardianName = null;
  static const defaultPhone = null;
  static const defaultEmail = null;
  static const defaultArea = null;
  static const defaultOccupation = null;
  static const defaultEducation = null;
  static const defaultBloodGroup = null;
}

class PrescriptionDefaultValues{
  static const noteDefault = '';
  static const physicalFindingsDefault = '';
  static const chiefComplainDefault = '';
  static const onExaminationDefault = '';
  static const diagnosisDefault = '';
  static const investigationDefault = '';
  static const investigationReportDefault = '';
}

class PreFixIds{
  static const int defaultPrefixAppId = 100001;
  static const int defaultPrefixPatientId = 333000;
  static const int defaultPrefixPrescriptionId = 200001;
}

class DefaultValues extends GetxController{
  static  String defaultUuid = '';
  static  int identifier = 0;
  static  int id = 0;
  static String defaultDate = customDateTimeFormat(DateTime.now()).toString();
  static const int defaultweb_id = 0;
  static const int NewAdd = 1;
  static const int Update = 2;
  static const int Delete = 3;
  static const int Synced = 4;
  static const int permanentDelete = 5;
  static const int onExamCatId = 0;
  static const String defaultSyncStarting = '2024-03-09 12:50:56';
  static const int defaultPageNum = 1;
  static const prescriptionReady = 1;
  static const prescriptionNotReady = 3;
  static const cancelAppointment = 2;
  static const favoriteDelete = 0;
  static const defaultChamberId = 1;

  RxString defaultSyncDownload = '2024-03-09 12:50:56'.obs;

  void setDefaultSyncDownload(String value){
    defaultSyncDownload.value = value;

    print('lastSyncUpdatedDate: ${defaultSyncDownload.value}');
  }

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
  }
}

Future getUserInfo() async{
  DefaultValues.defaultUuid = await getStoreKeyWithValue('uuid') ?? '';
  DefaultValues.id = await getIntStoreKeyWithValue('id') ?? 0;
  DefaultValues.identifier = await getIntStoreKeyWithValue('identifier') ?? 0;
  print(DefaultValues.identifier);
}
