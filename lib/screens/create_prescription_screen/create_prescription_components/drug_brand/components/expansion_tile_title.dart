


import 'package:flutter/material.dart';

import '../../../../../controller/general_setting/general_setting_controller.dart';
import '../../../../../utilities/app_strings.dart';

Padding expansionTileTitle(drugData, GeneralSettingController generalSettingController) {

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2.0),
    child: Wrap(
      children: [
        Text(drugData['brand_name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
        const SizedBox(width: 5,),
        Text(drugData['form'], style: const TextStyle(fontSize: 12),),
        const SizedBox(width: 5,),
        Text(drugData['strength'], style: const TextStyle(fontSize: 12),),
        const SizedBox(width: 20,),
        Text(drugData['generic_name'], style: const TextStyle(fontSize: 12, color: Colors.blueGrey),),

        const SizedBox(width: 20,),
        // if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "ShowCompanyName"))
        if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "ShowCompanyName"))
        Text(drugData['company_name'], style: const TextStyle(fontSize: 12, color: Colors.black26),),
        const SizedBox(width: 50,),
        // Text(drugData['company_name'])
      ],
    ),
  );
}