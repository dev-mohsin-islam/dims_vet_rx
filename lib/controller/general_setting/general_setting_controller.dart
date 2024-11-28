import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/prescription_controller.dart';
import 'package:dims_vet_rx/database/crud_operations/general_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../database/hive_get_boxes.dart';
import '../../models/general_setting_pages/setting_pages_model.dart';
import '../../screens/create_prescription_screen/create_prescription_components/drug_brand/add_medicine_modal.dart';
import '../../utilities/app_strings.dart';
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';
import 'config/general_settings_items.dart';

class GeneralSettingController extends GetxController {
  final GeneralSettingsCRUDController generalSettingsCRUDController = GeneralSettingsCRUDController();
  final Box<SettingPagesModel> boxGeneralSetting = Boxes.getSettingPages();

  RxList settingsItemsDataList = [].obs;

  final List<String> deleteRangeItems = [
    'Before 3 months',
    'Before 6 months',
    'Before 12 months',
  ];

  RxString selectedValue = ''.obs;
  // this will be used in setting pages default values insert in database

  getDeleteDate()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int date = prefs.getInt('deleteMonthRange') ?? 6;
    if(date == 3){
      selectedValue.value = 'Before 3 months';
    }else if(date == 6){
      selectedValue.value = 'Before 6 months';
    }else if(date == 12){
      selectedValue.value = 'Before 12 months';
    }
  }

  updateDeleteData(String selected)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int date = 6;
    if(selected == 'Before 3 months'){
      date = 3;
    }else if(selected == 'Before 6 months'){
      date = 6;
    }else if(selected == 'Before 12 months'){
      date = 12;
    }
    prefs.setInt('deleteMonthRange', date);
  }


  final uuid = DefaultValues.defaultUuid;
  final date = DateTime.now().toString();
  final web_id = DefaultValues.defaultweb_id;
  final statusNewAdd = DefaultValues.NewAdd;
  final statusUpdate = DefaultValues.Update;
  final statusDelete = DefaultValues.Delete;



  functionAdd(obj)async{
    settingsItemsDataList.add(obj);
    await addData();
  }

  functionRemove(obj)async{
    var label = obj['label'];
    var section = obj['section'];
    var index = settingsItemsDataList.indexWhere((element) => element['label'] == label && element['section'] == section);
    bool? response = await generalSettingsCRUDController.deleteCommon(boxGeneralSetting, SettingPagesModel(id: 0,uuid: uuid,date:date,u_status: statusNewAdd, section: section, label: label));
    if(response !=null && response == true){
      await getAllData('');
    }
  }


  //insert general settings data to database (box)
  Future<void>addData()async{
    bool isDefault =  false;
    for(var i=0; i<settingsItemsDataList.length; i++){
      String section = settingsItemsDataList[i]['section'];
      String label = settingsItemsDataList[i]['label'];
      await generalSettingsCRUDController.saveSettings(isDefault, boxGeneralSetting, SettingPagesModel(id: 0,uuid: uuid,date:date,u_status: statusNewAdd, section: section, label: label), );
    }
    await getAllData('');
    await prescriptionController.showFavoriteBrandFirst();
  }


  //insert default general settings data to database (box)
  Future<void>functionDefaultSettings()async{
    bool isDefault =  true;
    List generalSettingConstData =await GeneralSettingConstant().generalSettings();
    int boxDataClear =  await boxGeneralSetting.clear();
      for(int i =0; i<  generalSettingConstData.length; i++){
        String section = generalSettingConstData[i]['section'];
        var items = generalSettingConstData[i]['items'];
        for(int j=0; j<items.length; j++){
          var label = items[j]['label'];
          bool defaultValue = items[j]['defaultOn'] ;
          if(defaultValue == true){
            await generalSettingsCRUDController.saveSettings(isDefault, boxGeneralSetting, SettingPagesModel(id: 0,uuid: uuid,date:date,u_status: statusNewAdd, section: section, label: label));
          }
        }
      }
      Helpers.successSnackBar("Success!", "Added successfully");
      await getAllData("");
      await prescriptionController.showFavoriteBrandFirst();
  }


  //get all general settings data from database (box)
  Future<void>getAllData(searchText)async{
    List newList = [];
    List response = await generalSettingsCRUDController.getAllDataCommon(boxGeneralSetting, searchText);
    if(response.isNotEmpty){
      for(var i=0; i<response.length; i++){
        var obj = {
          'section': "${response[i].section}",
          'label': "${response[i].label}",
        };
        newList.add(obj);
      }
      settingsItemsDataList.clear();
      settingsItemsDataList.addAll(newList);
    }
    await prescriptionController.showFavoriteBrandFirst();
  }
  Future getData()async{
    var response = await generalSettingsCRUDController.getAllDataCommon(boxGeneralSetting, '');
    if(response.isNotEmpty){
      List  dates = [];
      dates.clear();
        for(var i=0; i<response.length; i++){
          dates.add(response[i].date.toString());
        }
      List<DateTime> datesMap = dates.map((date) => DateTime.parse(date)).toList();
      DateTime latestDate = datesMap.reduce((a, b) => a.isAfter(b) ? a : b);
      return latestDate;
    }
  }




  RxList<Map<dynamic, dynamic>> generalSettings = [
    {
      "title": "Appointment",
      "slug": "appointment",
      "items": {
        "item": [
          {
            "inputType": "singleInput",
            "title": "Patient Name",
            "slug": "patientName",
            "showIn": {
              "frontPage":true,
              settingAppointment: true,
            },
          },
        ],
      },
    },
    {
      "title": "Clinical Data",
      "slug": "clinicalData",
      "items": {
        "item": [
          {
            "dataType": "cc",
            "slugParent": "clinicalData",
            "title": "Chief Complaint",
            "value": [
              {"id": "1", "name": "pain"}
            ],
            "slug": "cc",
            "showIn": {
              "frontPage": true,
            },
          },

        ],
      },
    },
  ].obs;

  void updateValue(initialSlugDynamic,targetKeyValueDynamic, switchValueDynamic,showInPageName ){

    String parentSlug = initialSlugDynamic; //"appointment";
    String targetKeyValue = targetKeyValueDynamic; //"patientName";
    String showInPage = showInPageName; //show page, like appointment page or front page
    bool switchValue = switchValueDynamic; //true, false

    for (var setting in generalSettings) {
      if (setting['slug'] == parentSlug && setting['items'] != null) {
        for (var item in setting['items']['item']) {
            if (item['slug'] == targetKeyValue && item['showIn'] != null) {
              if(showInPage == showInPage){
                if (item['showIn'].containsKey(showInPage)) {
                  item['showIn'][showInPage] = switchValue;
                }
              }
            }
          }
        }
      }
    generalSettings.refresh();
  }

  initialCall()async{
    await getAllData('');
    await getDeleteDate();
    if(generalSettings.length == 0){
      await functionDefaultSettings();
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    initialCall();
   super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
