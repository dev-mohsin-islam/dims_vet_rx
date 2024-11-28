


import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:dims_vet_rx/controller/authentication/profile.dart';
import 'package:dims_vet_rx/controller/drawer_controller/drawer_controller.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';
import 'package:dims_vet_rx/utilities/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/authentication/login_controller.dart';
import '../../controller/authentication/logout_controller.dart';
import '../../controller/sync_controller/sync_db_to_server_controller.dart';
import '../../controller/sync_controller/sync_server_to_db_controller.dart';
import '../../main.dart';
import '../../utilities/app_strings.dart';
import '../../utilities/navigator_drawer_items.dart';
import '../others_data_screen/app_sync_modal.dart';
import '../others_data_screen/dashboard.dart';
import '../others_data_screen/login_screen.dart';
import '../others_data_screen/profile.dart';

final DbToServerSyncController syncCRUDController = Get.put(DbToServerSyncController());

Widget drawerItems(context){
  final NavigatorDrawerItem navigatorDrawerItem = NavigatorDrawerItem();
  final LoginController loginController = Get.put(LoginController());
  final DbToServerSyncController dbToServerSyncController = Get.put(DbToServerSyncController());
  final SyncController syncController = Get.put(SyncController());
  final Profile profile = Get.put(Profile());
  return  SingleChildScrollView(
    child: Column(
      children: [
        Obx(() => Container(
          height: 220,
          width: MediaQuery.of(context).size.width * 1,
          color: Colors.indigo,
          child: Column(
            children: [
              SizedBox(height: 15,),
              Center(
                child: profile.profileImage[0]['profileImage']!.isEmpty
                    ? const Text('')
                    : Stack(
                  alignment : AlignmentDirectional.topStart,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      child: Image.memory(
                          profile.profileImage[0]['profileImage'],
                          fit: BoxFit.cover
                      ),
                    ),
                    // IconButton(onPressed: (){
                    //   profile.profileImage[0]['profileImage'] = Uint8List(0);
                    //   profile.profileImage.refresh();
                    // }, icon: const Icon(Icons.cancel,color: Colors.white,))
                  ],
                ),),

              Text("${loginController.userName.value}", style: TextStyle(color: Colors.white, fontSize: 18),),
              Text("${loginController.email.value}", style: TextStyle(color: Colors.white, fontSize: 14),),
              Text("${Platform.isAndroid ? "Version No: 1.1.5" : "Version No: 1.3.2.0"}", style: TextStyle(color: Colors.white, fontSize: 14),),
              Text("Last Sync: ${loginController.lastSyncDate.value.isNotEmpty ? loginController.lastSyncDate.value : DateTime.now().toString().substring(0,16)}", style: TextStyle(color: Colors.white, fontSize: 14),),

              SizedBox(height: 5,),
              FilledButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen()));
              }, child: Wrap(
                children: [
                  Icon(Icons.person, color: Colors.white),
                  Text("Profile", style: TextStyle(color: Colors.white),),
                ],
              )),
              SizedBox(height: 5,),
            ],
          ),
        ),),

        //............................................................
        MenuList(context),
        SizedBox(height: 30,),
        //.................................................................

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FilledButton(onPressed: ()async{
              Navigator.push(context, MaterialPageRoute(builder: (context) => SyncScreen()));
              // Navigator.push(context, MaterialPageRoute(builder: (context) => syncScreenJsonToDb()));
              //  Navigator.push(context, MaterialPageRoute(builder: (context) => logoutSyncScreen()));
              await runSyncFunction();
              Navigator.pop(context);
            }, child: Row(children: [
              Icon(Icons.sync),
              Text("Data Sync"),
            ],)),

          ],
        )

      ],
    ),
  );
}









Widget MenuList(context){
  final DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
       Obx(() =>  Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.start,
         children: NavigatorDrawerItem.menuSingleItem.map((item){
           return InkWell(
             onTap: (){
               drawerMenuController.selectedMenuIndex.value = item['id'];
               Navigator.pop(context);
             },
             child: Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Row(
                         children: [
                           if(item['id'] == 0)
                             const Icon(Icons.home),
                           if(item['id'] == 1)
                             const Icon(Icons.list),
                           if(item['id'] == 2)
                             const Icon(Icons.book),
                           if(item['id'] == 3)
                             const Icon(Icons.dashboard),
                           const SizedBox(width: 10,),
                           Text(item['label'], style: AppWidget.expandedMenuTitleStyle(),),
                         ],
                       ),
                       const Icon(Icons.arrow_forward, size: 20,),
                     ],
                   ),
                 )
               ],
             ),

           );
         }).toList(),
       ),),
        ExpansionTile(
          leading: const Icon(Icons.settings),
        title: Text("Settings", style: AppWidget.expandedMenuTitleStyle()),
        children: <Widget>[
        Obx(() {
          return  Column(
          children: NavigatorDrawerItem.menuSettings.map((item){
              return ListTile(
                title: Text(item['label'], style: AppWidget.expandedMenuSubTitleStyle(),),
                onTap: () {
                  drawerMenuController.selectedMenuIndex.value = item['id'];
                  Navigator.pop(context);
                },
              );
             }).toList(),
          );
        })
        ],),
        ExpansionTile(
          leading: const Icon(Icons.branding_watermark),
          title: Text("Brands", style: AppWidget.expandedMenuTitleStyle()),
          children: <Widget>[
            Obx(() {
              return  Column(
                children: NavigatorDrawerItem.menuBrand.map((item){
                  return ListTile(
                    title: Text(item['label'], style: AppWidget.expandedMenuSubTitleStyle(),),
                    onTap: () {
                      drawerMenuController.selectedMenuIndex.value = item['id'];
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              );
            })
          ],),
        ExpansionTile(
          leading: const Icon(Icons.medical_information),
          title: Text("Clinical Options", style: AppWidget.expandedMenuTitleStyle()),
          children: <Widget>[
            Obx(() {
              return  Column(
                children: NavigatorDrawerItem.menuClinicalOptions.map((item){
                  return ListTile(
                    title: Text(item['label'], style: AppWidget.expandedMenuSubTitleStyle(),),
                    onTap: () {
                      drawerMenuController.selectedMenuIndex.value = item['id'];
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              );
            })
          ],),
        ExpansionTile(
        leading: const Icon(Icons.sync),
        title: Text("Sync Type", style: AppWidget.expandedMenuTitleStyle()),
        children: <Widget>[
          Obx(() {
            return  Column(
              children: NavigatorDrawerItem.syncType.map((item){
                return ListTile(
                  title: Text(item['label'], style: AppWidget.expandedMenuSubTitleStyle(),),
                  onTap: () async{
                    Directory? appDocDir;
                    if(item['id'] == 33){
                      if(Platform.isAndroid){
                        Directory? appDocDir;

                        if (Platform.isAndroid) {
                          appDocDir = await getApplicationDocumentsDirectory();
                        }

                        if (appDocDir != null) {
                          String androidPath = appDocDir.path + "/NavanaRxDigitalDB"; // Append your custom directory
                          Directory customDir = Directory(androidPath);

                          if (!await customDir.exists()) {
                            await customDir.create(recursive: true);
                          }

                          print("Directory created or exists at: $androidPath");
                          // final directoryPath = appDocDir.path;
                          // final uri = Uri.parse('file://$directoryPath');
                          //
                          // // Open the directory using the default file manager
                          // if (await canLaunchUrl(uri)) {
                          //   await launchUrl(uri);
                          // } else {
                          //   // Handle the case where the directory cannot be opened
                          //   print('Could not launch $directoryPath');
                          // }
                        }
                      }
                      if(!Platform.isAndroid){
                        openDirectory("C:\\NavanaRxDigitalDB");
                      }
                    }else if(item['id'] == 34){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SyncScreen()));
                      await runSyncFunction();
                      Navigator.pop(context);
                    }else{
                      drawerMenuController.selectedMenuIndex.value = item['id'];
                    }

                  },
                );
              }).toList(),
            );
          })
        ],),
        ExpansionTile(
          leading: const Icon(Icons.recycling),
          title: Text("Others", style: AppWidget.expandedMenuTitleStyle()),
          children: <Widget>[
            Obx(() {
              return  Column(
                children: NavigatorDrawerItem.menuOthers.map((item){
                  return ListTile(
                    title: Text(item['label'], style: AppWidget.expandedMenuSubTitleStyle(),),
                    onTap: () {
                      drawerMenuController.selectedMenuIndex.value = item['id'];
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              );
            })
          ],),


    ],
  );
}

class SyncScreen extends StatelessWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DbToServerSyncController dbToServerSyncController = Get.put(DbToServerSyncController());
    final SyncController serverToDbSyncController = Get.put(SyncController());
    return Scaffold(
      body:   Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Obx(() => Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Center(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 100.0,
                              height: 100.0,
                              child: CircularProgressIndicator(
                                value: serverToDbSyncController.downloadSyncProgress.value,
                                color: Colors.green,
                                strokeWidth: 20.0,
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                            Text(
                              '${(serverToDbSyncController.downloadSyncProgress.value * 100).round()}%',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Download: ", style: TextStyle(color: Colors.green),),
                            Flexible(child: Text(" ${serverToDbSyncController.currentSyncingData.value}", style: TextStyle(color: Colors.black),)),
                          ],
                        ),

                      ],
                    ),

                  ),
                ),
                SizedBox(width: 20,),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Center(
                    child: Column(
                      children: [
                        // LinearProgressIndicator(
                        //   backgroundColor: Colors.grey[200],
                        //   valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                        //   value: insertDataJsonToDb.overallProgress.value,
                        //   minHeight: 20.0,
                        //   borderRadius: BorderRadius.circular(5.0),
                        // ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 100.0,
                              height: 100.0,
                              child: CircularProgressIndicator(
                                value: dbToServerSyncController.updateSyncProgress.value,
                                color: Colors.green,
                                strokeWidth: 20.0,
                                backgroundColor: Colors.grey[200],
                              ),
                            ),
                            Text(
                              '${(dbToServerSyncController.updateSyncProgress.value * 100).round()}%',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Upload: ", style: TextStyle(color: Colors.green),),
                            Flexible(child: Text("${dbToServerSyncController.currentSyncingData.value}", style: TextStyle(color: Colors.black),),)
                          ],
                        ),
                      ],
                    ),

                  ),
                ),

              ],
            )),

          ],
        ),
      ),
    );
  }
}


