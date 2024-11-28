

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../services/api/assistant.dart';
import '../../services/end_points_list.dart';
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';

class AssistantController extends GetxController{
  final RxList assistantList = [].obs;

  TextEditingController assistantName = TextEditingController();
  TextEditingController assistantEmail = TextEditingController();
  TextEditingController assistantPassword = TextEditingController();
  TextEditingController assistantPhone = TextEditingController();
  TextEditingController assistantId = TextEditingController();

  Future<void>createNewAssistant(context)async{

    if(assistantName.text.isNotEmpty && assistantEmail.text.isNotEmpty && assistantPassword.text.isNotEmpty && assistantPhone.text.isNotEmpty){
      String URL = '${ApiCUD.BaseUrl}${ApiCUD.Assistant}';
      String token = await Helpers().checkToken();
      bool isInternet = await InternetConnectionStatus();

      if(isInternet){
        var response =await createAssistantApiService(URL, 'post', token, assistantPhone.text.toString(), assistantName.text.toString(), assistantEmail.text.toString(), assistantPassword.text.toString());

        if(response !=null)
          if(jsonDecode(response)['success'] == true){
            Helpers.successSnackBar("Success", "${jsonDecode(response)['message'] }");
            assistantPassword.clear();
            assistantEmail.clear();
            assistantName.clear();
            assistantPhone.clear();
            await getAssistantList();
            Navigator.pop(context);
          }

      }
    }else{
      Helpers.errorSnackBar("Failed", "Filed must be not empty");
    }
  }
  updateAssistant(context)async{
    if(assistantName.text.isNotEmpty && assistantEmail.text.isNotEmpty  && assistantPhone.text.isNotEmpty){
      String URL = '${ApiCUD.BaseUrl}${ApiCUD.Assistant}';
      String token = await Helpers().checkToken();
      bool isInternet = await InternetConnectionStatus();
      if(isInternet){
        var response =await updateAssistantApiService(URL + "/${assistantId.text}", 'post', token, assistantPhone.text, assistantName.text.toString(), assistantEmail.text.toString(), assistantPassword.text.toString());
         Helpers.successSnackBar("Success", "Assistant Update Successfully");
         assistantPassword.clear();
         assistantEmail.clear();
         assistantName.clear();
         assistantPhone.clear();
         await getAssistantList();
         Navigator.pop(context);
      }
    }else{
      Helpers.errorSnackBar("Failed", "Filed must be not empty");
    }
  }

  Future<void> deleteAssistant(id)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.Assistant}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    if(isInternet){
      var response =await deleteAssistantApiService(URL + "/${id}", 'delete', token);
      var success = jsonDecode(response);
      if(success['success'] == true){

          await getAssistantList();
          Helpers.successSnackBar("Success", "Assistant Deleted Successfully");
      }

    }
  }

   Future<void>getAssistantList()async{

    String URL = '${ApiCUD.BaseUrl}${ApiCUD.Assistant}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    if(isInternet){
      var response =await assistantListApiService(URL  , 'get', token, );
      if(response !=null){
        if(response['success'] == true){
          assistantList.clear();
          assistantList.addAll(response['data']);

        }
      }else{
        print("Server issue");
      }

    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAssistantList();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    assistantList;
    assistantName.dispose();
    assistantEmail.dispose();
    assistantPassword.dispose();
    assistantPhone.dispose();
    assistantId.dispose();
    super.dispose();
  }

}