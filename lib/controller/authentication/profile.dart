
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/database/crud_operations/profile_info_update.dart';

import '../../database/hive_get_boxes.dart';
import '../../models/user_info/user_info_model.dart';
import '../../services/api/db_to_server/data_upload_sync.dart';
import '../../services/end_points_list.dart';
import '../../utilities/helpers.dart';

class Profile extends GetxController{
  final Box<UserInfoModel> boxUserInfo = Boxes.getUserInfo();
  final ProfileUpdateCrud profileUpdateCrud = ProfileUpdateCrud();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updatePass = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController chamberController = TextEditingController();
  TextEditingController specialityController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController degreeController = TextEditingController();

  TextEditingController chamberNameController = TextEditingController();
  TextEditingController chamberNPLController = TextEditingController();
  RxList chamberList = [].obs;

  TextEditingController updatePasswordController = TextEditingController();
  TextEditingController reTypePasswordController = TextEditingController();

  RxList<Map<String, dynamic>> profileImage= [
    {"profileImage":  Uint8List(0),},
  ].obs;

  Future<void> getImage(type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      // The user selected a file
      var imagePath = File(result.files.single.path!);

      Uint8List imageData = await imagePath.readAsBytes();
      profileImage[0]['profileImage']= imageData;
      profileImage.refresh();
    }
    updateProfile();
  }

 updateProfile()async{
    if(profileImage[0]['profileImage'].length >0 ){
      UserInfoModel userInfoModel = UserInfoModel(
        id: 1,
        name: nameController.text,
        phone: phoneController.text,
        profile_image: profileImage[0]['profileImage'],
        speciality: specialityController.text,
      );
      profileUpdateCrud.updateProfile(boxUserInfo, userInfoModel);
    }
 }

 getProfileInfo()async{
    if(boxUserInfo.isNotEmpty){
      var info = await boxUserInfo.getAt(0)!;
      profileImage[0]['profileImage']= info?.profile_image!;
    }

 }


  void submitForm() {
    // Handle form submission here, you can access the form fields' values using the controllers
    // For example:
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String chamber = chamberController.text;
    String speciality = specialityController.text;
    String designation = designationController.text;
    String degree = degreeController.text;

    // Now you can use these variables to do whatever you want, such as sending them to a backend server.
    // For now, let's just print them.
    print('Name: $name');
    print('Email: $email');
    print('Phone: $phone');
    print('Chamber: $chamber');
    print('Speciality: $speciality');
    print('Designation: $designation');
    print('Degree: $degree');
  }

  Future ProfileInformation()async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.User}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    if(isInternet){
      if(token.isNotEmpty){
        var response = await ApiCreateDbToServer().ProfileApiService(URL, "get", token);
        if(checkLoginStatus() == true){
          nameController.text = response['name'];
          emailController.text = response['email'];
          phoneController.text = response['phone'];
        }

      }
    }
  }

  chamberCreate()async{
    if(chamberNameController.text.isNotEmpty){
      String URL = '${ApiCUD.BaseUrl}${ApiCUD.chambers}';
      String token = await Helpers().checkToken();
      bool isInternet = await InternetConnectionStatus();
      if(isInternet){
        if(token.isNotEmpty){
          var response = await ApiCreateDbToServer().chamberApiService(URL, "post", token, chamberNameController.text);
          if(response['success'] == true){
            await getChamberList();
            chamberNameController.clear();
            Navigator.pop(Get.context!);
          }

        }
      }else{
        Helpers.errorSnackBar("Failed", "Internet Connection Failed");
      }
    }else{
      Helpers.errorSnackBar("Failed", "Please Enter Chamber Name");
    }
  }
  chamberUpdate(id)async{
    if(chamberNameController.text.isNotEmpty){
      String URL = '${ApiCUD.BaseUrl}${ApiCUD.chambers}/$id?name=${chamberNameController.text}';
      String token = await Helpers().checkToken();
      bool isInternet = await InternetConnectionStatus();
      if(isInternet){
        if(token.isNotEmpty){
          var response = await ApiCreateDbToServer().chamberApiService(URL, "put", token, chamberNameController.text);
          if(response['success'] == true){
            await getChamberList();
            chamberNameController.clear();
            Helpers.successSnackBar("Success", "Chamber Update Successfully");
            Navigator.pop(Get.context!);
          }

        }
      }else{
        Helpers.errorSnackBar("Failed", "Internet Connection Failed");
      }
    }else{
      Helpers.errorSnackBar("Failed", "Please Enter Chamber Name");
    }
  }
  getChamberList()async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.chambers}';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    if(isInternet){
      if(token.isNotEmpty && checkLoginStatus() == true){
        var response = await ApiCreateDbToServer().chamberApiService(URL, "get", token, '');
        if(response['success'] == true){
          chamberList.value = response['data'];
        }

      }
    }
  }
  chamberRemove(int id)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.chambers}/$id';
    String token = await Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();
    if(isInternet){
      if(token.isNotEmpty){
        var response = await ApiCreateDbToServer().chamberApiService(URL, "delete", token, '');

          await getChamberList();

      }
    }
  }
  updatePassword()async{
    if(updatePasswordController.text.isNotEmpty && reTypePasswordController.text.isNotEmpty){
      if(updatePasswordController.text == reTypePasswordController.text){
        String URL = '${ApiCUD.BaseUrl}${ApiCUD.updatePassword}';
        String token = await Helpers().checkToken();
        bool isInternet = await InternetConnectionStatus();
        if(isInternet){
          if(token.isNotEmpty && checkLoginStatus() == true){
            var response = await ApiCreateDbToServer().updatePasswordApiService(URL, "post", token, updatePasswordController.text.toString());
            if(response['success'] == true){
              Helpers.successSnackBar("Success", "Password Updated");
              Navigator.pop(Get.context!);
            }
          }
      }else{
        Helpers.errorSnackBar("Failed", "Internet Connection Failed");
      }
        }else{
        Helpers.errorSnackBar("Failed", "Password Not Matched");
      }
    }else{
      Helpers.errorSnackBar("Failed", "Field Must be not empty");
    }

  }

  Future initialCall()async{
    await getProfileInfo();
    await ProfileInformation();
    await getChamberList();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initialCall();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    chamberNameController.dispose();
    updatePasswordController.dispose();
    reTypePasswordController.dispose();
    profileUpdateCrud;
    formKey;
    updatePass;
    nameController;
    emailController;
    phoneController;
    chamberController;
    specialityController;
    designationController;
    degreeController;
    chamberNameController;
    chamberNPLController;
    chamberList;
    updatePasswordController;
    reTypePasswordController;
  }
}