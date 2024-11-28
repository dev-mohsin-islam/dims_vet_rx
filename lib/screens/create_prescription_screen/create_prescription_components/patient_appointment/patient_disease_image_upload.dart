

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';
import 'package:dims_vet_rx/controller/history/history_controller.dart';
import 'package:dims_vet_rx/controller/patient_disease_image/patient_disease_image_controller.dart';
import 'package:dims_vet_rx/utilities/app_strings.dart';

import '../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../controller/drawer_controller/drawer_controller.dart';
import '../../../../utilities/app_icons.dart';
import '../../../../utilities/style.dart';
Container diseaseImageUploadCard(PrescriptionController prescriptionController, BuildContext context) {
  final DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
  return Container(
    padding: const EdgeInsets.all(5),
    child: FilledButton(onPressed: (){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text("Disease Image"),
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.close))
            ],
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  patientDiseaseImageUpload(context),
                ],
              ),
            ),
          ),
        );
      });
    },  child: Row(
      children: [
        Icon(Icons.photo),
        SizedBox(width: 5,),
        Flexible(child: const Text("Patient Disease Image")),
      ],
    )),
  );
}

Widget patientDiseaseImageUpload(context){
  final PatientDiseaseImageController patientDiseaseImageController = Get.put(PatientDiseaseImageController());
  final AppointmentController appointmentController = Get.put(AppointmentController());
  return  Container(
    height: MediaQuery.of(context).size.height * 0.85,
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
                              Text('This app collects and uploads your patient disease image to our servers for store to local database and server, and for creating and maintaining accurate patient profiles and for better health service.'),
                              SizedBox(height: 10,),
                              Text("We do not provide any kind of personal data to anyone. We are only collecting images of disease. Do you allow this?", style: TextStyle(color: Colors.red),),



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
                              await patientDiseaseImageController.uploadPatientDiseaseImage();
                              // Proceed with data collection or upload
                            },
                          ),
                        ],
                      );
                    });
              }, child: const Text("Upload Disease Image")),
          const SizedBox(height: 10,),

          const SizedBox(height: 10,),
          Column(
            children: [
              Obx(() {
                return Wrap(
                  children: [
                    for(int i =0; i<patientDiseaseImageController.selectedPatientDiseaseImage.length; i++)
                      inputField(patientDiseaseImageController, i, context),
                  ],
                );
              }),
            Divider(thickness: 1, color: Colors.grey.shade300,),

              Obx(() => Column(
                children: [
                  Text("Old Images", style: const TextStyle(fontSize: 25, color: Colors.black),),
                  Wrap(
                      children: [
                    for(int i =0; i<patientDiseaseImageController.patientDiseaseList.length; i++)
                       Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:Column(
                            children: [
                              Text("Title: ${patientDiseaseImageController.patientDiseaseList[i].title}"),
                              SizedBox(height: 10,),
                              Text("Disease Name: ${patientDiseaseImageController.patientDiseaseList[i].disease_name}"),
                              SizedBox(height: 10,),
                              Text("Details: ${patientDiseaseImageController.patientDiseaseList[i].details}"),
                              InkWell(
                                child: Container(
                                  width: 100,
                                  child: Image.memory(patientDiseaseImageController.patientDiseaseList[i].url),
                                ),
                                onTap: (){
                                  ImagePopup(patientDiseaseImageController.patientDiseaseList[i].url, context);
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                  ]
                  ),
                ],
              ))
            ],
          )

        ],
      ),
    ),
  );
}

Padding inputField(PatientDiseaseImageController patientDiseaseImageController, int i, context) {
        return Padding(
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
                        initialValue: patientDiseaseImageController.selectedPatientDiseaseImage[i]['title'] ?? "",
                        decoration: InputDecoration(
                            labelText: "Write Title",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                        ),
                        onChanged: (value){
                          patientDiseaseImageController.onChangePatientDiseaseImageTitleUpdate(value, i);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 300,
                      child: TextFormField(
                        initialValue: patientDiseaseImageController.selectedPatientDiseaseImage[i]['title'] ?? "",
                        decoration: InputDecoration(
                            labelText: "Write Disease Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                        ),
                        onChanged: (value){
                          patientDiseaseImageController.onChangePatientDiseaseImageDiseaseNameUpdate(value, i);
                        },
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 300,
                      child: TextFormField(
                        initialValue: patientDiseaseImageController.selectedPatientDiseaseImage[i]['title'] ?? "",
                        maxLines: 3,
                        decoration: InputDecoration(
                            labelText: "Details",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                        ),
                        onChanged: (value){
                          patientDiseaseImageController.onChangePatientDiseaseImageDiseaseDetailsUpdate(value, i);
                        },
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          width: 100,
                          child: Image.memory(patientDiseaseImageController.selectedPatientDiseaseImage[i]['image']),
                        ),
                        onTap: (){
                          ImagePopup(patientDiseaseImageController.selectedPatientDiseaseImage[i]['image'], context);
                        },
                      ),
                    ],
                  ),

                  Container(
                    child: IconButton(
                        onPressed: (){
                          patientDiseaseImageController.selectedPatientDiseaseImage.remove(patientDiseaseImageController.selectedPatientDiseaseImage[i]);
                        }, icon: const Icon(Icons.delete)),
                  ),

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
            FilledButton(
                onPressed: (){
              Navigator.pop(context);
            },
              child: Text("Close"),
            )
          ],
            content: Container(
              height: MediaQuery.of(context).size.height/1,
              child: Image.memory(image),
            )
        );
      }
  );
}



// selectedHistory(context) {
//   final historyController = Get.put(HistoryController());
//   // var dataList = historyController.groupDataByCategory(historyController.selectedHistory);
//   //  print(dataList.length.toString());
//   return Container(
//
//     child: Obx(() => Column(
//         children: [
//           ListView.builder(
//             physics: NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: historyController.selectedHistoryGroupByCat.length,
//             itemBuilder: (context, index) {
//               String category = historyController.selectedHistoryGroupByCat.keys.elementAt(index);
//               List  items = historyController.selectedHistoryGroupByCat[category]!;
//               var categoryData = historyController.category.firstWhere((element) => element['value'] == category, orElse: () => null);
//
//               return ExpansionTile(
//
//                 initiallyExpanded: true,
//                 title: Text(categoryData['name'], style: TextStyle(fontWeight: FontWeight.w500),),
//                 children: items.map((item) {
//                   return ListTile(
//                     title: Row(
//                       children: [
//                         InkWell(onTap: (){
//                           historyController.selectedHistory.remove(item);
//                           historyController.selectedHistory.refresh();
//                           historyController.groupDataByCategory();
//                         }, child: AppIcons.clinicalDataRemove),
//                         SizedBox(width: 5,),
//                         Text(item.name),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               );
//             },
//           )
//         ]
//     )),
//   );
//
// }