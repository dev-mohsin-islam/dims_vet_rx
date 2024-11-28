

import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:dims_vet_rx/controller/authentication/login_controller.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/prescription_controller.dart';
import 'package:dims_vet_rx/services/api/api_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/others_data_screen/doctors_referral.dart';
import '../../services/api/api_logout.dart';
import '../../services/end_points_list.dart';
import '../../utilities/box_data_clear_refresh.dart';
import '../../utilities/helpers.dart';
import '../create_prescription/prescription/methods/method_prescription_data_clear.dart';

class LogOutController extends GetxController{

  final BoxDataClearAndRefresh boxDataClearAndRefresh = Get.put(BoxDataClearAndRefresh());
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final LoginController loginController = Get.put(LoginController());

  Future<bool?> logoutController(context)async{

    String URLLogin = '${Syncs.BaseUrlLogin}${Syncs.Login}';
    String URL = '${Syncs.BaseUrlLogin}${Syncs.Logout}';
    try{
      String token = await Helpers().checkToken();
      bool internet = await InternetConnectionStatus();
      if(internet){
        if(token.isNotEmpty){
          var response = await logOut(URL, token);
          if(response== true){
           bool res =  await boxDataClearAndRefresh.boxDataClearFunction();
           print("Exit process");
            if(res){
              print("Exit process");
              exit(0);
            }
            return true;
          }else{
            var phone =await getStoreKeyWithValue('phone');
            var password =await getStoreKeyWithValue('password');
            if(phone != null && password != null){
              var response = await login(URLLogin, phone.trim(), password.toString());
              if(response['success'] == true){
                await logoutController(context);
              }
            }
            return false;
          }
        }
      }else{
       print("Error : No Internet Connection");

      }

    } catch(e){
      print(e);
    }
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    boxDataClearAndRefresh;
    prescriptionController;
  }

}


