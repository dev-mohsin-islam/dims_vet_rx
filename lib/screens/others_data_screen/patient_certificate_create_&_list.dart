

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/patient_certificate/patient_certificate_controller.dart';
import '../../utilities/app_strings.dart';
import '../../utilities/style.dart';



Widget PatientCertificateList(){
  final PatientCertificateController paCertController = Get.put(PatientCertificateController());

  return Column(
    children: [
      // if(paCertController.patientCertificateList)
       
      Container(
        child: Column(
          children: [
            // ListView.builder(
            //     itemCount: paCertController.patientCertificateList.length,
            //     itemBuilder: (context, index){
            //   return Card(
            //     child: Text("data"),
            //   );
            // })
            Obx(() => ListView(
                shrinkWrap: true, //shrinkWrap
                children: [
                  Card(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Action", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          Text("Name", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          Text("Patient Id", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          Text("Date", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),

                  ),
                  for(var i =0; i< paCertController.patientCertificateList.length ; i++)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(onPressed: (){
                              paCertController.singlePaCertPrint(paCertController.patientCertificateList[i]['certificate'].id);
                            }, icon: Icon(Icons.print)),
                            Text(paCertController.patientCertificateList[i]['patient'].name),
                            Text(paCertController.patientCertificateList[i]['patient'].id.toString()),
                            Text(paCertController.patientCertificateList[i]['certificate'].date),

                          ],
                        ),
                      ),

                    ),
                  if(paCertController.patientCertificateList.length == 0)
                    Column(

                    children: [
                      SizedBox(height: 100,),
                      Center(
                  child: FilledButton(onPressed: (){
                    paCertController.getAllPaCertificate();
                  }, child: Text("Load Certificate")) ),
                    ],
                  )
                ]
            ))
          ]
        )
      ),
    ],
  );
}

certificateCreateModal(context, APPOINTMENT_ID){
  final PatientCertificateController patientCertificateController = Get.put(PatientCertificateController());
   showDialog(context: context, builder: (context){
     return AlertDialog(
       title: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Text("Make Certificate", style: TextStyle(color: Colors.black),),
           const SizedBox(width: 10,),
           IconButton(onPressed: (){
             Navigator.pop(context);
           }, icon: Icon(Icons.clear))
         ]
       ),

       content: SingleChildScrollView(
         child: Obx(() => Padding(
           padding: const EdgeInsets.all(8.0),
           child: Column(
             children: [
               Container(
                 height: MediaQuery.of(context).size.height * 0.8,
                 width: MediaQuery.of(context).size.width * 0.9,
                 child: SingleChildScrollView(
                   child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text("To Whom it May Concern", style: TextStyle(color: Colors.blue),),
                         Text("This is certify that"),
                         SizedBox(height: 10,),
                         Wrap(
                             children: [
                               Text("Was examined and treated at the Chamber on"),
                               SizedBox(width: 10,),
                               Wrap(
                                 runSpacing: 5,
                                 spacing: 5,
                                 alignment: WrapAlignment.spaceBetween,
                                 crossAxisAlignment: WrapCrossAlignment.center,
                                 children: [
                                   Container(
                                     width: 160,
                                     height: 40,
                                     child: TextField(
                                       readOnly: true,
                                       controller: patientCertificateController.formController,
                                       keyboardType: TextInputType.number,
                                       decoration: InputDecoration(
                                         border: OutlineInputBorder(),
                                         hintText: "yyyy-mm-dd",
                                         label: Text("Start Date"),
                                       ),
                                       onTap: ()async {
                                         var newDate = await showDatePicker(
                                           context: context,
                                           firstDate: DateTime(1990),
                                           lastDate: DateTime(2101), initialDate: DateTime.now(),
                                         );
                                         if(newDate != null){
                                           patientCertificateController.formController.text = newDate.year.toString() + "-" + newDate.month.toString() + "-" + newDate.day.toString();
                                         }
                                       },
                                     ),
                                   ),
                                   SizedBox(width: 10,),
                                   Text("To"),
                                   SizedBox(width: 10,),
                                   Container(
                                     width: 160,
                                     height: 40,
                                     child: TextField(
                                       readOnly: true,
                                       controller: patientCertificateController.toController,
                                       decoration: InputDecoration(
                                         border: OutlineInputBorder(),
                                         hintText: "yyyy-mm-dd",
                                         label: Text("End Date"),
                                       ),
                                       onTap: ()async {
                                         var newDate = await showDatePicker(
                                           context: context,
                                           firstDate: DateTime(1990),
                                           lastDate: DateTime(2101), initialDate: DateTime.now(),
                                         );
                                         if(newDate != null){
                                           patientCertificateController.toController.text = newDate.year.toString() + "-" + newDate.month.toString() + "-" + newDate.day.toString();
                                         }
                                       },
                                     ),
                                   ),
                                 ],
                               )
                             ]
                         ),
                         SizedBox(height: 10,),

                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text("With the following diagnosis:"),
                             SizedBox(height: 5,),
                             TextField(
                               maxLines: 4,
                               controller: patientCertificateController.diagnosisController,
                               decoration: InputDecoration(
                                   border: OutlineInputBorder()
                               ),
                             ),
                             SizedBox(height: 5,),
                             Text("And would medical attention for Dr. Abullah days barring complication of the above diagnosis"),

                           ],
                         ),
                         SizedBox(height: 10,),

                         Wrap(
                             alignment: WrapAlignment.spaceBetween,
                             crossAxisAlignment: WrapCrossAlignment.center,
                             spacing: 5,
                             runSpacing: 5,
                             children: [
                               Wrap(
                                 alignment: WrapAlignment.spaceBetween,
                                 crossAxisAlignment: WrapCrossAlignment.center,
                                 spacing: 5,
                                 runSpacing: 5,
                                 children: [
                                   Radio(value: 1, groupValue: patientCertificateController.selectedCertificateIndex.value, onChanged: (value){
                                     patientCertificateController.selectedCertificateIndex.value = value!;
                                   }),
                                   Text("I advised to take complete bed rest for")
                                 ],
                               ),
                                 Column(
                                   children: <Widget>[
                                     Card(
                                       child: Padding(
                                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                         child: DropdownButton<String>(

                                           underline: Container(),
                                           hint: Text(patientCertificateController.selectedTime.value == "" ? "Select Duration" : patientCertificateController.selectedTime.value),
                                           value: patientCertificateController.selectedTime.value == "" ? null : patientCertificateController.selectedTime.value.toString(),
                                           onChanged: (String? value) {
                                             patientCertificateController.selectedTime.value = value!;
                                           },
                                           items:patientCertificateController.selectedCertificateIndex.value == 1 ? timePeriodsForCertificate.map((String value) {
                                             return DropdownMenuItem(
                                               value: value,
                                               child: Text(value),
                                             );
                                           }).toList() : [],
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                             ]
                         ),
                         Wrap(
                             alignment: WrapAlignment.spaceBetween,
                             crossAxisAlignment: WrapCrossAlignment.center,
                             spacing: 5,
                             runSpacing: 5,
                             children: [

                               Wrap(
                                 alignment: WrapAlignment.spaceBetween,
                                 crossAxisAlignment: WrapCrossAlignment.center,
                                 spacing: 5,
                                 runSpacing: 5,
                                 children: [
                                   Radio(value: 2, groupValue: patientCertificateController.selectedCertificateIndex.value, onChanged: (value){
                                     patientCertificateController.selectedCertificateIndex.value = value!;
                                   }),
                                   Text("I have carefully examined him and now fit to resume treatment")
                                 ],
                               ),
                               Wrap(
                                   alignment: WrapAlignment.spaceBetween,
                                   crossAxisAlignment: WrapCrossAlignment.center,
                                   spacing: 5,
                                   runSpacing: 5,
                                 children: [
                                   Card(
                                     child: Padding(
                                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                       child: DropdownButton(
                                       underline: Container(),
                                       hint: Text(patientCertificateController.selectedWorkPlace.value == "" ? "Select Work Place" : patientCertificateController.selectedWorkPlace.value),
                                       value: patientCertificateController.selectedWorkPlace.value == "" ? null : patientCertificateController.selectedWorkPlace.value,
                                       onChanged: (value){
                                         patientCertificateController.selectedWorkPlace.value = value.toString();
                                       },
                                           items: patientCertificateController.selectedCertificateIndex.value == 2 ? patientCertificateController.workingPlace.map((String value){
                                             return DropdownMenuItem(
                                               child: Text(value),
                                               value: value,
                                             );
                                           }).toList() : [],
                                       ),
                                     ),
                                   ),
                                   Text("Form"),
                                   Container(
                                     width: 160,
                                     height: 40,
                                     child: TextField(
                                       readOnly: true,
                                       controller: patientCertificateController.isContinueController,
                                       enabled: patientCertificateController.selectedCertificateIndex.value == 2 ? true : false,
                                       decoration: InputDecoration(
                                         border: OutlineInputBorder(),
                                         hintText: "yyyy-mm-dd",
                                         label: Text("Start Date"),
                                       ),
                                       onTap: ()async {
                                         var newDate = await showDatePicker(
                                           context: context,
                                           firstDate: DateTime(1990),
                                           lastDate: DateTime(2101), initialDate: DateTime.now(),
                                         );
                                         if(newDate != null){
                                           patientCertificateController.isContinueController.text = newDate.year.toString() + "-" + newDate.month.toString() + "-" + newDate.day.toString();
                                         }
                                       },

                                     ),
                                   )
                                 ]
                               )

                             ]
                         ),
                         SizedBox(height: 10,),
                         FilledButton(
                             onPressed: (){
                                    patientCertificateController.saveCertificate(APPOINTMENT_ID);
                             },
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.end,
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Icon(Icons.print_outlined),
                                 SizedBox(width: 10,),
                                 Text("Save & Print"),
                               ],
                             ))
                       ]
                   ),
                 ),
               ),
             ],
           ),
         )),
       ),
     );
   });
}
