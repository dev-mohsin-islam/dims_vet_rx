

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileUpdateCrud{

  updateProfile(box, object)async{
    if(box.isEmpty){
      await box.add(object);
    }else{
      await box.putAt(0, object);
    }
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text('Profile Updated')),
    );


  }
}