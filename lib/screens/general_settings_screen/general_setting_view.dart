import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import '../../controller/general_setting/config/general_settings_items.dart';
import '../../controller/general_setting/general_setting_controller.dart';



class GeneralSettingScreen extends StatelessWidget {
  GeneralSettingScreen({super.key});

  final GeneralSettingConstant generalSettingConstant = Get.put(GeneralSettingConstant());

  final GeneralSettingController generalSettingController = Get.put(GeneralSettingController());

  @override
  Widget build(BuildContext context) {
    generalSettingConstant.orderBy();
    final settingsDataList = generalSettingConstant.generalSettings;
    final settingDataList = generalSettingController.settingsItemsDataList;
    final width = MediaQuery.of(context).size.width;
    return  Scaffold(
        appBar: AppBar(
          backgroundColor:  Colors.black12,
          title: Wrap(
            runSpacing: 5,
            alignment: WrapAlignment.spaceBetween,
            children: [
              const Text("General Settings", style: TextStyle(color: Colors.grey),),
            ],
          ), centerTitle: true, actions: [

        ],),

        body:   SingleChildScrollView(
          child: Center(
            child: Container(
              width: width < 600 ? width * 0.8 : width * 0.5,
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  FilledButton(
                      onPressed: ()async{
                        await generalSettingController.functionDefaultSettings();
                      }, child: Row(
                    children: [
                      Icon(Icons.settings),
                      Text("Default Settings")
                    ],
                  )),
                  SizedBox(height: 5,),

                  Obx(() => ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: settingsDataList.length,
                      itemBuilder: (context, index) {
                        print(index);
                        try{
                          print(settingsDataList.length);
                          return Container(
                            child: Card(
                              child: ExpansionTile(
                                title: Text(settingsDataList[index]['title'], style: const TextStyle(fontSize: 16.0, color: Colors.blue),),
                                backgroundColor: Colors.white,
                                childrenPadding: EdgeInsets.all(8.0),
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: settingsDataList[index]['items'].length,
                                    itemBuilder: (context, itemIndex) {
                                      return    Obx(() {
                                        var switchDynamicValue = settingDataList.any((element) => element['label'] == settingsDataList[index]['items'][itemIndex]['label'] && element['section'] == settingsDataList[index]['section']);
                                        return Card(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Flexible(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [ 
                                                      Flexible(child: Text(settingsDataList[index]['items'][itemIndex]['title'] ?? "")),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Switch(
                                                        value:  switchDynamicValue,
                                                        onChanged: (value) {
            
                                                          if(value ==true){
                                                            Map<String, dynamic> obj = {
                                                              "section": settingsDataList[index]['section'] ?? "",
                                                              "label": settingsDataList[index]['items'][itemIndex]['label'] ?? "",
                                                            };
                                                            String section = obj["section"].toString();
                                                            String label = obj["label"].toString();
                                                            Map<String, String> newObj = {
                                                              "section": section,
                                                              "label": label,
                                                            };
            
                                                            generalSettingController.functionAdd(newObj);
                                                            generalSettingController.settingsItemsDataList.refresh();
                                                            generalSettingConstant.generalSettings;
            
                                                          }else{
            
                                                            Map<String, dynamic> obj = {
                                                              "section": settingsDataList[index]['section'],
                                                              "label": settingsDataList[index]['items'][itemIndex]['label'],
                                                            };
                                                            String section = obj["section"].toString();
                                                            String label = obj["label"].toString();
                                                            Map<String, String> removeObj = {
                                                              "section": section,
                                                              "label": label,
                                                            };
            
                                                            generalSettingController.functionRemove(removeObj);
                                                            generalSettingController.settingsItemsDataList.refresh();
                                                            generalSettingConstant.generalSettings.refresh();
                                                          }
                                                          // generalSettingController.updateValue(setting['slug'], attribute['slug'], value, "frontPage");
            
                                                        }
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
            
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }catch(e){
                          print('An error occurred: $e');
                          return ListTile(
                            title: Text('Error occurred at index $index'),
                          );
                        }
            
                      })),
                ],
              ),
            ),
          ),
        ));


  }
}



