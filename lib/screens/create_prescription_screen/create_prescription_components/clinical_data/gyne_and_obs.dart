
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';
import '../../../../controller/gyn_and_obs/gyn_and_obs_controller.dart';
import '../../../../utilities/helpers.dart';

gynAndObsDialog(context, ){
  GynAndObsController gynAndObsController = Get.put(GynAndObsController());
  AppointmentController appointmentController = Get.put(AppointmentController());
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Gyne and Obs"),

                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.clear)),
              ],
            ),

            Obx(() =>  Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                      selected: gynAndObsController.screenIndex.value == 0,
                      label: Text("Para"),
                      onSelected: (value){
                        gynAndObsController.screenIndex.value = 0;
                      }),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                      selected: gynAndObsController.screenIndex.value == 1,
                      label: Text("Obs History"),
                      onSelected: (value){
                        gynAndObsController.screenIndex.value = 1;
                      }),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                      selected: gynAndObsController.screenIndex.value == 2,
                      label: Text("Sexual History"),
                      onSelected: (value){
                        gynAndObsController.screenIndex.value = 2;
                      }),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                      selected: gynAndObsController.screenIndex.value == 3,
                      label: Text("Menstrual History"),
                      onSelected: (value){
                        gynAndObsController.screenIndex.value = 3;
                      }),
                ),
              ],
            ),),
          ],
        ),

        actions: [
          ElevatedButton(onPressed: (){
            gynAndObsController.isDataExist.value = true;
            gynAndObsController.isParaExpanded.value = false;
            gynAndObsController.isParaExpanded.value = false;
            gynAndObsController.isGynAndObsExpanded.value = false;
            gynAndObsController.isSexualIsExpanded.value = false;
            gynAndObsController.isMenstrualExpanded.value = false;

            gynAndObsController.update();
            Helpers.successSnackBar("Success", "Successfully Saved");
            Navigator.pop(context);

          }, child: Text("Save"))
        ],
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Obx(() => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Container(
                    //height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(
                      children: [
                        //selected screen
                        if(gynAndObsController.screenIndex.value == 0)
                          para(context),

                        if(gynAndObsController.screenIndex.value == 1)
                          obsHistory(context),

                        if(gynAndObsController.screenIndex.value == 2)
                          sexualHistory(context),

                        if(gynAndObsController.screenIndex.value == 3)
                          menstrualHistory(context),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
        ),
      );
    },
  );
}

Widget para(context){
  GynAndObsController gynAndObsController = Get.put(GynAndObsController());
  return Container(
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                children: [
                  textField(gynAndObsController.paraGynController, "Write G", "number"),
                  textField(gynAndObsController.paraPynController, "Write P", "number"),
                  textField(gynAndObsController.paraLynController, "Write L", "number"),
                  textField(gynAndObsController.paraTController, "Write T", "number"),
                  textField(gynAndObsController.paraAynController, "Write A", "number"),
                  textField(gynAndObsController.paraParityController, "Write Parity", "number"),
                  Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: TextField(
                     controller: gynAndObsController.paraAgeLastChildController,
                     decoration: InputDecoration(
                       border: OutlineInputBorder(),
                       hintText: "Write last child age",
                       suffixIcon: Obx(() => DropdownButton(
                         hint: Text(gynAndObsController.ageLastChild.value),
                         items: [
                           DropdownMenuItem(child: Text("Year"),value: "Year",),
                           DropdownMenuItem(child: Text("Month"),value: "Month",),
                         ],
                         onChanged: (value){
                           gynAndObsController.ageLastChild.value = value!;
                           gynAndObsController.ageLastChild.refresh();
                         },

                       )),
                     ),
                   ),
                 ),
                ],
              ),
            )
          ],
        )
      ],
    )
  );
}
Widget obsHistory(context){
  GynAndObsController gynAndObsController = Get.put(GynAndObsController());
  return Container(
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                children: [
                 Obx(() =>  Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Column(
                     children: [
                        Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Amenorrhoea"),
                              ),
                              DropdownButton(
                                  underline: Container(),
                                   hint: Text(gynAndObsController.Amenorrhoea.value.isEmpty ? "Select Amenorrhoea" : gynAndObsController.Amenorrhoea.value),
                                   items: [
                                     DropdownMenuItem(child: Text("Absent"),value: "Absent",),
                                     DropdownMenuItem(child: Text("Present"),value: "Present",),
                                   ],
                                   onChanged: (value){
                                     gynAndObsController.Amenorrhoea.value = value!;
                                   },
                                ),
                            ],
                          ),
                        ),
                       Card(
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Engagement"),
                              ),
                              DropdownButton(
                                underline: Container(),
                                   hint: Text(gynAndObsController.Engagement.value.isEmpty ? "Select Engagement" : gynAndObsController.Engagement.value),
                                   items: [
                                     DropdownMenuItem(child: Text("Yes"),value: "Yes",),
                                     DropdownMenuItem(child: Text("No"),value: "No",),
                                   ],
                                   onChanged: (value){
                                     gynAndObsController.Engagement.value = value!;
                                   },
                                ),
                            ],
                          ),
                       ),

                       Card(
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Fetal Movement"),
                              ),
                              DropdownButton(
                                underline: Container(),
                                   hint: Text(gynAndObsController.FetalMovement.value.isEmpty ? "Select Fetal Movement" : gynAndObsController.FetalMovement.value),
                                   items: [
                                     DropdownMenuItem(child: Text("Absent"),value: "Absent",),
                                     DropdownMenuItem(child: Text("Present"),value: "Present",),
                                   ],
                                   onChanged: (value){
                                     gynAndObsController.FetalMovement.value = value!;
                                   },
                                ),
                            ],
                          ),
                       ),

                       Card(
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Presentation"),
                              ),
                              DropdownButton(
                                underline: Container(),
                                   hint: Text(gynAndObsController.FetalMovement.value.isEmpty ? "Select Presentation" : gynAndObsController.FetalMovement.value),
                                   items: [
                                     DropdownMenuItem(child: Text("Floating"),value: "Floating",),
                                     DropdownMenuItem(child: Text("Breech"),value: "Breech",),
                                     DropdownMenuItem(child: Text("Cephalic"),value: "Cephalic",),
                                     DropdownMenuItem(child: Text("Oblique"),value: "Oblique",),
                                     DropdownMenuItem(child: Text("Transverse"),value: "Transverse",),
                                   ],
                                   onChanged: (value){
                                     gynAndObsController.FetalMovement.value = value!;
                                   },
                                ),
                            ],
                          ),
                       ),
                       Card(
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Fetal Heart"),
                              ),
                              DropdownButton(
                                   underline: Container(),
                                   hint: Text(gynAndObsController.FetalHeart.value.isEmpty ? "Select Presentation" : gynAndObsController.FetalHeart.value),
                                   items: [
                                     DropdownMenuItem(child: Text("Present"),value: "Present",),
                                     DropdownMenuItem(child: Text("Absent"),value: "Absent",),
                                   ],
                                   onChanged: (value){
                                     gynAndObsController.FetalHeart.value = value!;
                                   },
                                ),
                            ],
                          ),
                       ),

                     ],
                   ),
                 ),)
                ],
              ),
            )
          ],
        )
      ],
    )
  );
}
Widget sexualHistory(context){
  GynAndObsController gynAndObsController = Get.put(GynAndObsController());
  return Container(
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                children: [
                 Obx(() =>  Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Column(
                     children: [
                        Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Contraceptive"),
                              ),
                              DropdownButton(
                                  underline: Container(),
                                   hint: Text(gynAndObsController.Contraceptive.value.isEmpty ? "Select Contraceptive" : gynAndObsController.Contraceptive.value),
                                   items: [
                                     DropdownMenuItem(child: Text("Condom"),value: "Condom",),
                                     DropdownMenuItem(child: Text("Female Condom"),value: "Female Condom",),
                                     DropdownMenuItem(child: Text("Female Birth Control Pill"),value: "Female Birth Control Pill",),
                                     DropdownMenuItem(child: Text("IUD"),value: "IUD",),
                                     DropdownMenuItem(child: Text("Injection"),value: "Injection",),
                                     DropdownMenuItem(child: Text("Norplant"),value: "Norplant",),
                                   ],
                                   onChanged: (value){
                                     gynAndObsController.Contraceptive.value = value!;
                                   },
                                ),
                            ],
                          ),
                        ),
                       Card(
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Dyspareunia"),
                              ),
                              DropdownButton(
                                underline: Container(),
                                   hint: Text(gynAndObsController.Dyspareunia.value.isEmpty ? "Select Dyspareunia" : gynAndObsController.Dyspareunia.value),
                                   items: [
                                     DropdownMenuItem(child: Text("Yes"),value: "Yes",),
                                     DropdownMenuItem(child: Text("No"),value: "No",),
                                   ],
                                   onChanged: (value){
                                     gynAndObsController.Dyspareunia.value = value!;
                                   },
                                ),
                            ],
                          ),
                       ),

                       textField(gynAndObsController.sexualFrequencyController, "Post Coital Bleeding","/week"),

                       Card(
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Post Coital Bleeding"),
                              ),
                              DropdownButton(
                                underline: Container(),
                                   hint: Text(gynAndObsController.PostCoitalBleeding.value.isEmpty ? "Select Post Coital Bleeding" : gynAndObsController.PostCoitalBleeding.value),
                                   items: [
                                     DropdownMenuItem(child: Text("Absent"),value: "Absent",),
                                     DropdownMenuItem(child: Text("Present"),value: "Present",),
                                   ],
                                   onChanged: (value){
                                     gynAndObsController.PostCoitalBleeding.value = value!;
                                   },
                                ),
                            ],
                          ),
                       ),


                     ],
                   ),
                 ),)
                ],
              ),
            )
          ],
        )
      ],
    )
  );
}
Widget menstrualHistory(context){
  GynAndObsController gynAndObsController = Get.put(GynAndObsController());
  return Container(
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                children: [
                 Obx(() =>  Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Column(
                     children: [
                       textField(gynAndObsController.MenstrualCycleController, "Cycle","days"),
                        Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Amount of Flow"),
                              ),
                              DropdownButton(
                                  underline: Container(),
                                   hint: Text(gynAndObsController.AmountofFlow.value.isEmpty ? "Select Amount of Flow" : gynAndObsController.AmountofFlow.value),
                                   items: [
                                     DropdownMenuItem(child: Text("Scanty"),value: "Scanty",),
                                     DropdownMenuItem(child: Text("Normal"),value: "Normal",),
                                     DropdownMenuItem(child: Text("Heavy"),value: "Heavy",),
                                     DropdownMenuItem(child: Text("To Heavy"),value: "To Heavy",),
                                   ],
                                   onChanged: (value){
                                     gynAndObsController.AmountofFlow.value = value!;
                                   },
                                ),
                            ],
                          ),
                        ),
                       Card(
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Dysmenorrhea"),
                              ),
                              DropdownButton(
                                underline: Container(),
                                   hint: Text(gynAndObsController.Dysmenorrhea.value.isEmpty ? "Select Dysmenorrhea" : gynAndObsController.Dysmenorrhea.value),
                                   items: [
                                     DropdownMenuItem(child: Text("Mild"),value: "Mild",),
                                     DropdownMenuItem(child: Text("Moderate"),value: "Moderate",),
                                     DropdownMenuItem(child: Text("Several"),value: "Several",),
                                   ],
                                   onChanged: (value){
                                     gynAndObsController.Dysmenorrhea.value = value!;
                                   },
                                ),
                            ],
                          ),
                       ),



                       textField( gynAndObsController.MenstrualPeriodController, "Period","days"),
                       textField( gynAndObsController.MenstrualMenarcheController, "Menarche","years"),
                       Padding(padding: EdgeInsets.all(8.0),
                         child: TextField(
                           onTap: ()async{
                             final newDate = await showDatePicker(
                               context: context,
                               firstDate: DateTime(1990),
                               lastDate: DateTime(2101), initialDate: DateTime.now(),
                             );
                             if (newDate != null) {

                               DateTime lmpDate = DateFormat('yyyy-MM-dd').parse(newDate.toString());
                               gynAndObsController.MenstrualEDDController.text = lmpDate.add(Duration(days: 280)).toString().substring(0,10);
                               gynAndObsController.MenstrualLDDController.text = lmpDate.add(Duration(days: 42 * 7)).toString().substring(0,10);
                               gynAndObsController.MenstrualPLMPController.text = lmpDate.toString().substring(0,10);
                               // appointmentController.date.value = customDateTimeFormat(newDate).toString();
                               // if (kDebugMode) {
                               //   print(newDate);
                               // }
                             }
                           },
                           controller: gynAndObsController.MenstrualPLMPController,
                           decoration: InputDecoration(
                             border: OutlineInputBorder(),
                             labelText: "LMP",
                           ),


                         ),
                       ),
                        Padding(padding: EdgeInsets.all(8.0),
                        child: TextField(
                          onTap: ()async{
                            final newDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1990),
                              lastDate: DateTime(2101), initialDate: DateTime.now(),
                            );
                            if (newDate != null) {
                              gynAndObsController.MenstrualEDDController.text = customDateTimeFormat(newDate).toString();
                              // appointmentController.date.value = customDateTimeFormat(newDate).toString();
                              // if (kDebugMode) {
                              //   print(newDate);
                              // }
                            }
                          },
                          controller: gynAndObsController.MenstrualEDDController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "EDD",
                          ),


                        ),
                        ),
                        Padding(padding: EdgeInsets.all(8.0),
                        child: TextField(
                          onTap: ()async{
                            final newDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1990),
                              lastDate: DateTime(2101), initialDate: DateTime.now(),
                            );
                            if (newDate != null) {
                              gynAndObsController.MenstrualLDDController.text = customDateTimeFormat(newDate).toString();
                              // appointmentController.date.value = customDateTimeFormat(newDate).toString();
                              // if (kDebugMode) {
                              //   print(newDate);
                              // }
                            }
                          },
                          controller: gynAndObsController.MenstrualLDDController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "LDD",
                          ),


                        ),
                        )

                     ],
                   ),
                 ),)
                ],
              ),
            )
          ],
        )
      ],
    )
  );
}

Padding textField(textController, hintText,suffixText){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
        controller: textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: hintText,
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(suffixText),
          ),
        ),
      ),
  );
}

selectedGynHistory(context, [isFollowUp = false]){
  GynAndObsController gynAndObsController = Get.put(GynAndObsController());
  return Container(
    child: Obx(() => Column(
      children: [
        Column(
          children: [
            if(isFollowUp == false)
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text("Gyn and Obs History", style: const TextStyle(  color: Colors.black, fontWeight: FontWeight.bold),),
                  ),),
                  // ElevatedButton(onPressed: (){
                  //   treatmentPlanDialog(context);
                  // }, child: Text("View Plans")),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // color: Colors.black
                    ),
                    child: IconButton(onPressed: () async {
                      // historyDialog(context);
                      gynAndObsDialog(context);
                    }, icon: Icon(Icons.add_box, size: Platform.isAndroid ? 30 : 25, color: Colors.black,),),
                  ),
                ],
              ),
            ),
            if(gynAndObsController.isDataExist.value)
            Column(
              children: [
                if(gynAndObsController.isDataExist.value)
                Card(
                  elevation: 0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Para", style: const TextStyle(  color: Colors.black, fontWeight: FontWeight.w500),),
                          ),
                          IconButton(onPressed: (){
                            gynAndObsController.isParaExpanded.value = !gynAndObsController.isParaExpanded.value;
                          }, icon: Icon(gynAndObsController.isParaExpanded.value ? Icons.arrow_drop_up : Icons.arrow_drop_down)),
                        ],
                      ),

                      if(gynAndObsController.isParaExpanded.value)
                      Column(
                        children: [
                          if(gynAndObsController.paraGynController.text.isNotEmpty)
                            singlePara(gynAndObsController.paraGynController.text, "Para Gyn"),

                          if(gynAndObsController.paraPynController.text.isNotEmpty)
                            singlePara(gynAndObsController.paraPynController.text, "Para P"),

                          if(gynAndObsController.paraLynController.text.isNotEmpty)
                            singlePara(gynAndObsController.paraLynController.text, "Para L"),

                          if(gynAndObsController.paraTController.text.isNotEmpty)
                            singlePara(gynAndObsController.paraTController.text, "Para T"),

                          if(gynAndObsController.paraAynController.text.isNotEmpty)
                            singlePara(gynAndObsController.paraAynController.text, "Para Any"),

                          if(gynAndObsController.paraParityController.text.isNotEmpty)
                            singlePara(gynAndObsController.paraParityController.text, "Para Priority"),

                          if(gynAndObsController.paraAgeLastChildController.text.isNotEmpty)
                            singlePara(gynAndObsController.paraAgeLastChildController.text + "/${gynAndObsController.ageLastChild.value}", "Last child"),
                        ],
                      ),
                    ],
                  )
                ),

                if(gynAndObsController.isDataExist.value)
                Card(
                  elevation: 0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Gyn and Obs History", style: const TextStyle(  color: Colors.black, fontWeight: FontWeight.w500),),
                          ),
                          IconButton(onPressed: (){
                            gynAndObsController.isGynAndObsExpanded.value = !gynAndObsController.isGynAndObsExpanded.value;
                          }, icon: Icon(gynAndObsController.isGynAndObsExpanded.value ? Icons.arrow_drop_up : Icons.arrow_drop_down)),
                        ],
                      ),

                      if(gynAndObsController.isGynAndObsExpanded.value)
                      Column(
                        children: [
                          if(gynAndObsController.Amenorrhoea.value.isNotEmpty)
                            singlePara(gynAndObsController.Amenorrhoea.value, "Amenorrhoea"),

                          if(gynAndObsController.Engagement.value.isNotEmpty)
                            singlePara(gynAndObsController.Engagement.value, "Engagement"),

                          if(gynAndObsController.FetalMovement.value.isNotEmpty)
                            singlePara(gynAndObsController.FetalMovement.value, "Fetal Movement"),

                          if(gynAndObsController.FetalMovement.value.isNotEmpty)
                            singlePara(gynAndObsController.FetalMovement.value, "Presentation"),

                          if(gynAndObsController.FetalHeart.value.isNotEmpty)
                            singlePara(gynAndObsController.FetalHeart.value, "Presentation"),

                        ],
                      ),
                    ],
                  ),
                ),
                if(gynAndObsController.isDataExist.value)
                Card(
                  elevation: 0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Sexual History", style: TextStyle(fontWeight: FontWeight.w500),),
                          ),
                          IconButton(onPressed: (){
                            gynAndObsController.isSexualIsExpanded.value = !gynAndObsController.isSexualIsExpanded.value;
                          }, icon: Icon(gynAndObsController.isSexualIsExpanded.value ? Icons.arrow_drop_up : Icons.arrow_drop_down)),
                        ],
                      ),

                      if(gynAndObsController.isSexualIsExpanded.value)
                      Column(
                        children: [
                          if(gynAndObsController.Contraceptive.value.isNotEmpty)
                            singlePara(gynAndObsController.Contraceptive.value, "Contraceptive"),

                          if(gynAndObsController.Dyspareunia.value.isNotEmpty)
                            singlePara(gynAndObsController.Dyspareunia.value, "Dyspareunia"),

                          if(gynAndObsController.sexualFrequencyController.text.isNotEmpty)
                            singlePara(gynAndObsController.sexualFrequencyController.text + '/week', "Post Coital Bleeding"),

                          if(gynAndObsController.PostCoitalBleeding.value.isNotEmpty)
                            singlePara(gynAndObsController.PostCoitalBleeding.value, "Post Coital Bleeding"),

                        ],
                      ),
                    ],
                  ),
                ),
                if(gynAndObsController.isDataExist.value)
                Card(
                  elevation: 0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Menstrual History", style: TextStyle(fontWeight: FontWeight.w500),),
                          ),
                          IconButton(onPressed: (){
                            gynAndObsController.isMenstrualExpanded.value = !gynAndObsController.isMenstrualExpanded.value;
                          }, icon: Icon(gynAndObsController.isMenstrualExpanded.value ? Icons.arrow_drop_up : Icons.arrow_drop_down)),
                        ],
                      ),
                      if(gynAndObsController.isMenstrualExpanded.value)
                      Column(
                        children: [
                          if(gynAndObsController.MenstrualCycleController.text.isNotEmpty)
                            singlePara(gynAndObsController.MenstrualCycleController.text + '/days', "Cycle"),

                          if(gynAndObsController.AmountofFlow.value.isNotEmpty)
                            singlePara(gynAndObsController.AmountofFlow.value, "Amount of Flow"),

                          if(gynAndObsController.Dysmenorrhea.value.isNotEmpty)
                            singlePara(gynAndObsController.Dysmenorrhea.value + '/week', "Dysmenorrhea"),

                          if(gynAndObsController.PostCoitalBleeding.value.isNotEmpty)
                            singlePara(gynAndObsController.PostCoitalBleeding.value, "Post Coital Bleeding"),

                          if(gynAndObsController.MenstrualPeriodController.text.isNotEmpty)
                            singlePara(gynAndObsController.MenstrualPeriodController.text + '/days', "Post Coital Bleeding"),

                          if(gynAndObsController.MenstrualMenarcheController.text.isNotEmpty)
                            singlePara(gynAndObsController.MenstrualMenarcheController.text + '/years', "Post Coital Bleeding"),

                          if(gynAndObsController.MenstrualEDDController.text.isNotEmpty)
                            singlePara(gynAndObsController.MenstrualEDDController.text, "EDD"),

                          if(gynAndObsController.MenstrualLDDController.text.isNotEmpty)
                            singlePara(gynAndObsController.MenstrualLDDController.text, "LDD"),

                          if(gynAndObsController.MenstrualPLMPController.text.isNotEmpty)
                            singlePara(gynAndObsController.MenstrualPLMPController.text, "LMP"),

                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )

          ],
        ),
      ],
    )),
  );
}
Widget singlePara(controllerText, hintText) {
  return Padding(
    padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text("$hintText : ", style: TextStyle(fontWeight: FontWeight.w400),),
            ),
            Expanded(
                // child: Text("${controllerText}")
              child: TextFormField(
                readOnly: true,
                initialValue: hintText.toString().isEmpty ? "" : controllerText,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),

          ],
        ),
        Divider(),
      ],
    ),
  );
}