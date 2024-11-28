

import 'dart:io';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:dims_vet_rx/controller/general_setting/general_setting_controller.dart';
import 'package:dims_vet_rx/utilities/default_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/others_data_screen/app_sync_modal.dart';
import '../../screens/others_data_screen/privacy_policy.dart';
import '../../services/api/api_login.dart';
import '../../services/end_points_list.dart';
import '../../utilities/helpers.dart';
import '../sync_controller/json_to_db.dart';
import '../sync_controller/sync_server_to_db_controller.dart';

class LoginController extends GetxController{
  GeneralSettingController generalSettingController = Get.put(GeneralSettingController());
  RxBool isLoginError = false.obs;
  TextEditingController serverError = TextEditingController();

  final InsertDataJsonToDb insertDataJsonToDb = Get.put(InsertDataJsonToDb());
  final SyncController syncController = Get.put(SyncController());

  RxBool isDataSync = true.obs;

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxString userName = ''.obs;
  RxString email = ''.obs;
  RxString phone = ''.obs;
  RxInt identifier = 0.obs;
  RxInt id = 0.obs;
  RxString uuid = ''.obs;
  RxString lastSyncDate = ''.obs;
  RxString updatedLastSyncDate = ''.obs;
  RxBool agreeWithPrivacyPolicy = false.obs;

  RxString selectedProfileType = ''.obs;
  RxList loginWith = [
    {'name': 'Doctor', 'value': 'Doctor'},
    {'name': 'Assistant', 'value': 'Assistant'},
    {'name': 'Assistant Doctor', 'value': 'AssistantDoctor'},
  ].obs;

  dynamic convertTime(String selected)async{
    int date = 0;
    if(selected == 'download last 3 months'){
      date = 3;
    }else if(selected == 'download last 6 months'){
      date = 6;
    }else if(selected == 'download last 12 months'){
      date = 12;
    }

    String defaultDate = DefaultValues.defaultSyncStarting;
    DateTime dateTime = DateTime.parse(defaultDate);
    DateTime updateDate = DateTime(dateTime.year, dateTime.month - date, dateTime.day);
    String formatDate = DateFormat('yyyy-MM-dd').format(updateDate);
    String updateDateTime = '$formatDate 12:50:56';

    updatedLastSyncDate.value = updateDateTime;

    print('lastSync___updateDate: $updateDateTime');

    return updateDateTime;
  }

  Future<void> loginController(context, defaultSyncDownload)async{

    String URL = '${Syncs.BaseUrlLogin}${Syncs.Login}';
    if(updatedLastSyncDate.value == ''){
      updatedLastSyncDate.value = DefaultValues.defaultSyncStarting;
    }
    if(selectedProfileType.value == ''){
      return Helpers.errorSnackBarDuration("Failed", "Please Select as Login With", 2000);
    }
    try{
        bool internet = await InternetConnectionStatus();

        if(internet){
          if(phoneController.text.trim().isNotEmpty && passwordController.text.isNotEmpty){

            var response = await login(URL, phoneController.text.trim(), passwordController.text);

            if(response !=null){
              if(response['success'] == true){
                // isLoginError.value = false;
                var setData = await storeLoginTokenWithStatus(response['data'],context,passwordController.text.toString());
                if(isDataSync.value && setData == true){
                  await insertDataJsonToDb.callAllJsonData(updatedLastSyncDate.value);
                  bool status = await runSyncFunction();
                  if(status){
                    exit(0);
                  }
                }else{
                  await generalSettingController.functionDefaultSettings();
                  await syncController.getChamberList();
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString('lastSyncTime', DateTime.now().toString());
                  exit(0);
                }
              }
            } else{
              // isLoginError.value = true;
              // serverError.text = response['message'];
            }

          }else{
            Helpers.errorSnackBar('Error', 'Please enter phone and password');
          }
        }else{
         print("Error : No Internet Connection");
        }

    } catch(e){
      print(e);
    }
  }

  Future storeLoginTokenWithStatus(data,context,password) async {
    // final ChamberController chamberController = Get.put(ChamberController());
    //  chamberController.chamberName.text = data['name'];
    //  chamberController.saveChamber();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", data['token']);
    await prefs.setString("phone", data['phone']);
    await prefs.setString("password", password);
    await prefs.setString("name", data['name']);
    await prefs.setString("email", data['email']);
    await prefs.setInt("identifier", data['identifier']);
    await prefs.setInt("id", data['id']);
    await prefs.setString("uuid", data['uuid']);
    await prefs.setBool('isLoggedIn', true);
    bool status = await checkLoginStatus();
    if(status){
      Helpers.successSnackBar("Success", "Login Success");
      return true;
    }

  }
  Future getUserInformation()async{
    // selectedProfileType.value =  await getStoreKeyWithValue("profileType");
    try{
      selectedProfileType.value =  "Doctor";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userName.value =  prefs.getString('name') ?? '' ;
      email.value = prefs.getString('email') ?? '';
      phone.value = prefs.getString('phone') ?? '';
      identifier.value = prefs.getInt('identifier') ?? 0;
      id.value = prefs.getInt('id')!;
      uuid.value = prefs.getString('uuid')!;
      String? lastRunDate = prefs.getString('lastSyncTime');
      if (lastRunDate != null) {
        lastSyncDate.value = lastRunDate;
      } else {
        // Handle the case where 'lastRunDate' is null, perhaps by assigning a default value.
      }
    }catch(e){}
  }

  Future storeUserInformation(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);

  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserInformation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneController.dispose();
    passwordController.dispose();
    insertDataJsonToDb.dispose();
    phoneController.dispose();
    passwordController.dispose();
    userName;
    email;
    identifier;
    id;
    uuid;
    lastSyncDate;
  }
}


