

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/authentication/login_controller.dart';
import 'package:dims_vet_rx/controller/doctor_create/doctor_create_controller.dart';
import 'package:dims_vet_rx/controller/patient_referral/patient_referral_controller.dart';
import 'package:dims_vet_rx/screens/printing/money_receipet_print/mone_receipt_print.dart';

import '../../controller/authentication/profile.dart';
import '../../utilities/app_strings.dart';

class DoctorReferralScreen extends StatelessWidget {
  const DoctorReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DoctorCreateController doctorCont = Get.put(DoctorCreateController());
    final loginController = Get.put(LoginController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          runSpacing: 5,
          children: [
            Text('Doctor Referral', style: TextStyle(color: Colors.white),),
            FilledButton(onPressed: (  ){
              doctorCreateModal(context, "create", doctorCont.boxDoctor.length + 1);

            }, child: Text("Create Doctor"))
          ],
        ),

      ),
      body: SingleChildScrollView(
        child: Obx(() => Column(
            children: [
              ListView.builder(
                  itemCount: doctorCont.doctorList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    var doctor = doctorCont.doctorList[index];
                    if(doctor !=null)
                    return Card(
                        child: ListTile(
                          title: Text(doctorCont.doctorList[index].name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doctorCont.doctorList[index].degree ?? ""),
                              Text(doctorCont.doctorList[index].designation ?? ""),
                              Text(doctorCont.doctorList[index].phone ?? ""),
                              Text(doctorCont.doctorList[index].address ?? ""),
                            ],
                          ),
                          trailing: Wrap(
                            children: [

                              IconButton(onPressed: (){
                                doctorCreateModal(context, "update", doctorCont.doctorList[index].id) ;
                                doctorCont.nameController.text =  doctorCont.doctorList[index].name ?? "";
                                doctorCont.degreeController.text =  doctorCont.doctorList[index].degree ?? "";
                                doctorCont.designationController.text =  doctorCont.doctorList[index].designation ?? "";
                                doctorCont.phoneController.text =  doctorCont.doctorList[index].phone;
                                doctorCont.addressController.text =  doctorCont.doctorList[index].address;
                              }, icon: Icon(Icons.edit)),
                              IconButton(onPressed: (){
                                doctorCont.saveDoctor( doctorCont.doctorList[index].id, "delete");
                              }, icon: Icon(Icons.delete)),
                            ],
                          ),

                        )
                    );
                    return Container();
                  })
            ]
        ))
      ),
    );
  }
}


doctorCreateModal(context, method, id){
  final DoctorCreateController doctorCreateController = Get.put(DoctorCreateController());
  showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(' Doctor Referral'),
          IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.clear))
        ]
      ),
      content: Container(
        child: Column(
          children: [
            inputField(context, doctorCreateController.nameController, "Doctor Name", ),
            inputField(context, doctorCreateController.degreeController, "Doctor Degree", ),
            inputField(context, doctorCreateController.designationController, "Doctor Designation", ),
            inputField(context, doctorCreateController.phoneController, "Doctor Phone", ),
            inputField(context, doctorCreateController.addressController, "Doctor Address", ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){

                doctorCreateController.saveDoctor(id, method);


              Navigator.pop(context);
            }, child: Text("Submit"))
          ]
        )
      )
    );
  });
}

SizedBox inputField(BuildContext context, TextEditingController textEditingController, label) {
  return SizedBox(
      height: 70,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder()
          )
        ),
      )
    );
}

referralCreateDialog(context, APP_ID){

  PaReferralController paRefCont = Get.put(PaReferralController());
  showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Referral"),

          IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.clear))
        ],
      ),
      actions: [
        FilledButton(onPressed: (){
          paRefCont.paReferralCUD(paRefCont.boxPaReferral.length + 1, APP_ID, 'create');
        }, child: Text("Save & Print"))

      ],
      content: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
          child: Obx(() => Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          children: [
                            Text("Referred To: "),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: TextField(
                                onTap: (){
                                  refDoctors(context);
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    // hintText: "Search Referred doctor"
                                    hintText: "${paRefCont.selectedRefDoctor.length > 0 ?
                                            paRefCont.selectedRefDoctor[0].name ?? "" + ' | ' + paRefCont.selectedRefDoctor[0].degree ?? "" + ' | ' + paRefCont.selectedRefDoctor[0].designation ?? "" + ' | ' + paRefCont.selectedRefDoctor[0].phone ?? ""
                                           : "Search Referred doctor"}"

                                ),
                                readOnly: true,
                              ),
                            ),
                          ]
                      ),
                      Row(
                          children: [
                            Text("Referred By: "),
                            Text(" ${loginController.userName.value}  "),

                          ]
                      ),
                    ]
                ),
                SizedBox(height: 20,),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Clinical Information", style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextField(
                              controller: paRefCont.chiefComplain,
                              maxLines: 1,
                              decoration: InputDecoration(
                                labelText: "Chief Complaint",
                                border: OutlineInputBorder(),
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextField(
                              controller: paRefCont.diagnosis,
                              maxLines: 1,
                              decoration: InputDecoration(
                                labelText: "Diagnosis",
                                border: OutlineInputBorder(),
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextField(
                              controller: paRefCont.onExamination,
                              maxLines: 1,
                              decoration: InputDecoration(
                                labelText: "On Examination",
                                border: OutlineInputBorder(),
                              )
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextField(
                              controller: paRefCont.specialNote,
                              maxLines: 2,
                              decoration: InputDecoration(
                                labelText: "Special Note",
                                border: OutlineInputBorder(),

                              )
                          ),
                        ),
                      ),
                      Text("Referral Reason", style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                      Row(
                        children: [
                         for(int i = 0; i < reasonToRef.length; i++)
                           Row(
                             children: [
                               Checkbox(
                                   value: paRefCont.selectedReasonToRef.contains(reasonToRef[i]),
                                    onChanged: (bool? value) {
                                      if (value == true) {
                                        paRefCont.selectedReasonToRef.add(reasonToRef[i]);
                                      }else{
                                        paRefCont.selectedReasonToRef.remove(reasonToRef[i]);
                                      }
                                    }
                               ),

                               Text(reasonToRef[i], style: TextStyle(color: Colors.blue),),
                             ],
                           ),
                        ]
                      )
                    ]
                )
              ]
          )),
        ),
      ),
    );
  });
}

refDoctors(context){
  DoctorCreateController doctorCont = Get.put(DoctorCreateController());
  PaReferralController paRefCont = Get.put(PaReferralController());
  doctorCont.getData('');
  showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Referral"),
          IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.clear))
        ]
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: [
            if(doctorCont.doctorList.isNotEmpty)
            for(int i = 0; i <doctorCont.doctorList.length; i++)
              ListView(
                shrinkWrap: true,
                children: [
                  Card(
                    child: ListTile(
                      onTap: (){ 
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${doctorCont.doctorList[i].name ?? ''}"),
                          FilledButton(onPressed: (){
                            paRefCont.selectedRefDoctor.clear();
                            paRefCont.selectedRefDoctor.add(doctorCont.doctorList[i]);
                            Navigator.pop(context);
                          }, child: Text("Select"))
                        ],
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctorCont.doctorList[i].degree ?? ''),
                          Text(doctorCont.doctorList[i].designation ?? ''),
                          Text(doctorCont.doctorList[i].phone ?? ''),
                          Text(doctorCont.doctorList[i].address ?? ''),
                        ],
                      ),
                    ),
                  )
                ]
              )
          ]
        ),
      ),
    );
  });
}