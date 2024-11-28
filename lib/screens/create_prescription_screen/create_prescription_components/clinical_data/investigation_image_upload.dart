
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../controller/appointment/appointment_controller.dart';
import '../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../controller/drawer_controller/drawer_controller.dart';
import '../../../../controller/investigation_report_image/investigation_report_image_cotroller.dart';
import '../../../../utilities/style.dart';

Container investigationImageUpload(PrescriptionController prescriptionController, BuildContext context) {
  final DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
  return Container(
    padding: const EdgeInsets.all(5),
    child: FilledButton(onPressed: (){
      showDialog(context: context, builder: (context){
        return   AlertDialog(
          title: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text("Upload Investigation Report"),
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.close))
            ],
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              children: [
                investigationReportUpload(context)
              ],
            ),
          ),
        );
      });
    },  child: Row(
      children: [
        Icon(Icons.photo),
        SizedBox(width: 5,),
        Flexible(child: const Text("I/R Image")),
      ],
    )),

  );
}


Widget investigationReportUpload(context){
  final PrescriptionController controller = Get.put(PrescriptionController());
  final InvestigationReportImageController investigationReportImageController = Get.put(InvestigationReportImageController());
  final AppointmentController appointmentController = Get.put(AppointmentController());
  return  Container(
    height: Responsive().endDrawerHeight(context),
    child: SingleChildScrollView(
      child: Column(
        children: [

          SizedBox(height: 10,),
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context)
                    {
                      return AlertDialog(
                        title: Text('User Data Disclosure'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(
                                  'This app collects and uploads your patient investigation report image to our servers for store to local database and server, and for creating and maintaining accurate patient profiles.'),
                              SizedBox(height: 10,),
                              Text("We do not provide any kind of personal data to anyone. We are only collecting images of Investigation Report. Do you allow this?", style: TextStyle(color: Colors.red),),

                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Decline'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Prevent further action
                            },
                          ),
                          TextButton(
                            child: Text('Accept'),
                            onPressed: () async {
                              Navigator.pop(context);
                              await investigationReportImageController
                                  .uploadInvestigationReportImage();
                              // Proceed with data collection or upload
                            },
                          ),
                        ],
                      );
                    });
              }, child: const Text("Upload Investigation Report Image")),
          const SizedBox(height: 10,),
          Column(
            children: [
              Obx(() {
                return Wrap(
                  children: [
                    for(int i =0; i<investigationReportImageController.selectedInvestigationReportImage.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.grey.shade200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 300,
                                  child: TextFormField(
                                    initialValue: investigationReportImageController.selectedInvestigationReportImage[i]['title'] ?? "",
                                    decoration: InputDecoration(
                                        labelText: "Write Title",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        )
                                    ),
                                    onChanged: (value){
                                      investigationReportImageController.onChangeInvestigationReportImageTitleUpdate(value, i);
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 300,
                                  child: TextFormField(
                                    initialValue: investigationReportImageController.selectedInvestigationReportImage[i]['inv_name'] ?? "",
                                    decoration: InputDecoration(
                                        labelText: "Write Inv Name",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        )
                                    ),

                                    onChanged: (value){
                                      investigationReportImageController.onChangeInvestigationReportImageNameUpdate(value, i);
                                    },
                                  ),

                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 300,
                                  child: TextFormField(
                                    initialValue: investigationReportImageController.selectedInvestigationReportImage[i]['details'] ?? "",
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                        labelText: "Details",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        )
                                    ),
                                    onChanged: (value){
                                      investigationReportImageController.onChangeInvestigationReportImageDetailsUpdate(value, i);
                                    },
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    child: Container(
                                      width: 100,
                                      child: Image.memory(investigationReportImageController.selectedInvestigationReportImage[i]['image']),
                                    ),
                                    onTap: (){
                                      ImagePopup(investigationReportImageController.selectedInvestigationReportImage[i]['image'], context);
                                    },
                                  ),
                                ],
                              ),
                              Container(
                                child: IconButton(
                                    onPressed: (){
                                      investigationReportImageController.selectedInvestigationReportImage.remove(investigationReportImageController.selectedInvestigationReportImage[i]);
                                    }, icon: const Icon(Icons.delete)),
                              ),


                            ],
                          ),
                        ),
                      ),

                  ],
                );
              }),


              Divider(thickness: 1, color: Colors.grey.shade300,),

              Column(
                  children: [
                    Obx(() => Column(
                      children: [
                        Text("Old Images", style: const TextStyle(fontSize: 25, color: Colors.black),),

                        if(investigationReportImageController.investigationReportImageList.isNotEmpty)
                          Wrap(
                              children: [
                                for(int i =0; i<investigationReportImageController.investigationReportImageList.length; i++)
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:Column(
                                        children: [
                                          Text("Title: ${investigationReportImageController.investigationReportImageList[i].title}"),
                                          SizedBox(height: 10,),
                                          Text("Inv Name: ${investigationReportImageController.investigationReportImageList[i].inv_name}"),
                                          SizedBox(height: 10,),
                                          Text("Details: ${investigationReportImageController.investigationReportImageList[i].details}"),
                                          InkWell(
                                            child: Container(
                                              width: 100,
                                              child: Image.memory(investigationReportImageController.investigationReportImageList[i].url),
                                            ),
                                            onTap: (){
                                              ImagePopup(investigationReportImageController.investigationReportImageList[i].url, context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              ]
                          ),
                      ],
                    )),
                  ]
              ),
              if(investigationReportImageController.investigationReportImageList.isEmpty)
                Text("Old Images not found", style: const TextStyle(fontSize: 25, color: Colors.black),),
            ],
          )

        ],
      ),
    ),
  );
}

Future ImagePopup(image, context){
  return showDialog(

      context: context,
      builder: (builder){
        return AlertDialog(
            actions: [
              FilledButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Close"))
            ],
            content: Container(
              height: MediaQuery.of(context).size.height/1,
              child: Image.memory(image),
            )
        );
      }
  );
}