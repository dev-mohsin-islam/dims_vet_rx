


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/sync_controller/sync_server_to_db_controller.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../controller/sync_controller/json_to_db.dart';
import '../../controller/sync_controller/sync_db_to_server_controller.dart';






class syncScreenJsonToDb extends StatelessWidget {
  const syncScreenJsonToDb({
    super.key,});


  @override
  Widget build(BuildContext context) {
    final InsertDataJsonToDb insertDataJsonToDb = Get.put(InsertDataJsonToDb());
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 150.0,
                                  height: 150.0,
                                  child: CircularProgressIndicator(
                                    value: insertDataJsonToDb.overallProgress.value,
                                    color: Colors.green,
                                    strokeWidth: 20.0,
                                    backgroundColor: Colors.grey[200],
                                  ),
                                ),
                                Text(
                                  '${(insertDataJsonToDb.overallProgress.value * 100).round()}%',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Text("${insertDataJsonToDb.currentSyncingData.value}", style: TextStyle(color: Colors.green),),
                            SizedBox(height: 10,),
                            Text(" "),
                            Text("Data is Syncing...Please Wait !!! ", style: TextStyle(color: Colors.green),),
                            Text("After Sync is Completed...Apps will be Closed...Please Open the App Again.....")

                          ],
                        ),

                      ),
                    ),
                  ],
                ),
              ),
              // Text('${(insertDataJsonToDb.overallProgress * 100).round()}%'),
            ],
          )),
        ],
      ),
    );
  }
}




class logoutSyncScreen extends StatelessWidget {
  const logoutSyncScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    final DbToServerSyncController dbToServerSyncController = Get.put(DbToServerSyncController());
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Column(
                                children: [

                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 200.0,
                                        height: 200.0,
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
                                      Text("${dbToServerSyncController.currentSyncingData.value}", style: TextStyle(color: Colors.black),),
                                    ],
                                  ),
                                ],
                              ),

                            ),

                          ],
                        ),
                      ),

                    ],
                  )),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}