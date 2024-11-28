
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../controller/immunization.dart';

Card immunizationCard(BuildContext context) {
  return Card(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Text("Immunization", style: const TextStyle(  color: Colors.black, fontWeight: FontWeight.bold),),
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
            ImmunizationDialog(context);
          }, icon: Icon(Icons.add_box, size: Platform.isAndroid ? 30 : 25, color: Colors.black,),),
        ),
      ],
    ),
  );
}

ImmunizationDialog(context){
  final immunization = Get.put(Immunization());
  showDialog(context: context, builder: (context){
    return AlertDialog(

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Routine Immunization"),
          ElevatedButton(onPressed: (){
            immunizationOptional(context);
          }, child: Text("Optional")),

          Row(
            children: [
              ElevatedButton(onPressed: (){
                immunization.isDataExist.value = true;
                Navigator.pop(context);
              }, child: Text("Save")),

              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Close")),
            ],
          ),
        ],
      ),

      content: Obx(() => Column(
        children: [
          Card(
            color: Colors.blue,
            elevation: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  sizedBox( context,'Recommended Age'),
                  sizedBox( context,'Vaccine'),
                  sizedBox( context,'Dose'),
                  sizedBox( context,'Date'),
                  sizedBox( context,'Note'),
                  sizedBox( context,'Action'),

                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox(context, "At Birth"),
                                  sizedBox(context, "BCG"),
                                  sizedBox(context, "1st"),
                                  sizedBoxDate(context, immunization.AtBirthBCGGivenDate.value),
                                  noteInput(context, immunization.AtBirthBCGNoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.AtBirthBCGNoteController, immunization.AtBirthBCGGivenDate );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.AtBirthBCGGivenDate.value = "";
                                            immunization.AtBirthBCGNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "At Birth-14 days"),
                                  sizedBox( context, "OPV(Oral Polio Vaccine)"),
                                  sizedBox( context, "0 Dose"),
                                  sizedBoxDate(context, immunization.AtBirth14daysOPV.value),
                                  noteInput(context, immunization.AtBirth14daysOPVNoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.AtBirth14daysOPVNoteController, immunization.AtBirth14daysOPV );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.AtBirth14daysOPV.value = "";
                                            immunization.AtBirth14daysOPVNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, '6 Weeks' ),
                                  Column(
                                    children: [
                                      Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  sizedBox(context, 'BCG (If dose missed at birth)'),
                                                  sizedBox(context, '1st'),
                                                  sizedBoxDate(context, immunization.Weeks6BCG.value),
                                                  noteInput(context, immunization.Weeks6BCGNoteController),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width * 0.100,
                                                    child: Row(
                                                      children: [
                                                        IconButton(onPressed: (){
                                                          showEditDialog(context,immunization.Weeks6BCGNoteController, immunization.Weeks6BCG );

                                                        }, icon: Icon(Icons.edit)),
                                                        IconButton(onPressed: (){
                                                        immunization.Weeks6BCG.value = "";
                                                        immunization.Weeks6BCGNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  sizedBox(context,'Pentavalent Vaccine (DPT, Hepatitis B, Hib)' ),
                                                  sizedBox(context,'1st' ),
                                                  sizedBoxDate(context, immunization.Weeks6PentavalentVaccine.value),
                                                  noteInput(context, immunization.Weeks6PentavalentVaccineNoteController),

                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width * 0.100,
                                                    child: Row(
                                                      children: [
                                                        IconButton(onPressed: (){
                                                          showEditDialog(context,immunization.Weeks6PentavalentVaccineNoteController, immunization.Weeks6PentavalentVaccine );

                                                        }, icon: Icon(Icons.edit)),
                                                        IconButton(onPressed: (){
                                                        immunization.Weeks6PentavalentVaccine.value = "";
                                                        immunization.Weeks6PentavalentVaccineNoteController.clear();
                                                        }, icon: Icon(Icons.delete)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  sizedBox(context, 'OPV'),
                                                  sizedBox(context, '1st'),
                                                  sizedBoxDate(context, immunization.Weeks6OPV.value),
                                                  noteInput(context, immunization.Weeks6OPVNoteController),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width * 0.100,
                                                    child: Row(
                                                      children: [
                                                        IconButton(onPressed: (){
                                                          showEditDialog(context,immunization.Weeks6OPVNoteController, immunization.Weeks6OPV );

                                                        }, icon: Icon(Icons.edit)),
                                                        IconButton(onPressed: (){
                                            immunization.Weeks6OPV.value = "";
                                            immunization.Weeks6OPVNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  sizedBox( context, 'Pneumococcal(conjugate)Pneumonia Vaccine(PCV)'),
                                                  sizedBox( context, '1st'),
                                                  sizedBoxDate(context, immunization.Weeks6Pneumococcal.value),
                                                  noteInput(context, immunization.Weeks6OPneumococcalController),

                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width * 0.100,
                                                    child: Row(
                                                      children: [
                                                        IconButton(onPressed: (){
                                                          showEditDialog(context,immunization.Weeks6OPneumococcalController, immunization.Weeks6Pneumococcal );

                                                        }, icon: Icon(Icons.edit)),
                                                        IconButton(onPressed: (){
                                            immunization.Weeks6Pneumococcal.value = "";
                                            immunization.Weeks6OPneumococcalController.clear();
                                          }, icon: Icon(Icons.delete)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),


                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox(context, '10 Weeks' ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  sizedBox(context, 'OPV(Oral Polio Vaccine)'),
                                                  sizedBox(context, '2nd'),
                                                  sizedBoxDate(context, immunization.Weeks10OPV.value),
                                                  noteInput(context, immunization.Weeks10OPVNoteController),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width * 0.100,
                                                    child: Row(
                                                      children: [
                                                        IconButton(onPressed: (){
                                                          showEditDialog(context,immunization.Weeks10OPVNoteController, immunization.Weeks10OPV );

                                                        }, icon: Icon(Icons.edit)),
                                                        IconButton(onPressed: (){
                                                        immunization.Weeks10OPV.value = "";
                                                        immunization.Weeks10OPVNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  sizedBox(context, 'Pentavalent Vaccine (DPT, Hepatitis B, Hib)'),
                                                  sizedBox(context, '2nd'),
                                                  sizedBoxDate(context, immunization.Weeks10Pneumococcal.value),
                                                  noteInput(context, immunization.Weeks10PneumococcalController),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width * 0.100,
                                                    child: Row(
                                                      children: [
                                                        IconButton(onPressed: (){
                                                          showEditDialog(context,immunization.Weeks10PneumococcalController, immunization.Weeks10Pneumococcal );

                                                        }, icon: Icon(Icons.edit)),
                                                        IconButton(onPressed: (){
                                                        immunization.Weeks10Pneumococcal.value = "";
                                                        immunization.Weeks10PneumococcalController.clear();
                                          }, icon: Icon(Icons.delete)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  sizedBox(context, "Pneumococcal(conjugate)Pneumonia Vaccine(PCV)"),
                                                  sizedBox(context, "2nd"),
                                                  sizedBoxDate(context, immunization.Weeks14PentavalentVaccine.value),
                                                  noteInput(context, immunization.Weeks14PentavalentVaccineNoteController),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width * 0.100,
                                                    child: Row(
                                                      children: [
                                                        IconButton(onPressed: (){
                                                          showEditDialog(context,immunization.Weeks14PentavalentVaccineNoteController, immunization.Weeks14PentavalentVaccine );

                                                        }, icon: Icon(Icons.edit)),
                                                        IconButton(onPressed: (){
                                                            immunization.Weeks14PentavalentVaccine.value = "";
                                                            immunization.Weeks14PentavalentVaccineNoteController.clear();
                                                          }, icon: Icon(Icons.delete)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),


                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox(context,"14 Weeks"),
                                  Column(
                                    children: [
                                      Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  sizedBox(context, "IPV"),
                                                  sizedBox(context, "1 single	"),
                                                  sizedBoxDate(context, immunization.Weeks14IPV.value),
                                                  noteInput(context, immunization.Weeks14IPVNoteController),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width * 0.100,
                                                    child: Row(
                                                      children: [
                                                        IconButton(onPressed: (){
                                                          showEditDialog(context,immunization.Weeks14IPVNoteController, immunization.Weeks14IPV );

                                                        }, icon: Icon(Icons.edit)),
                                                        IconButton(onPressed: (){
                                                          immunization.Weeks14IPV.value = "";
                                                          immunization.Weeks14IPVNoteController.clear();
                                                        }, icon: Icon(Icons.delete)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  sizedBox(context, "OPV(Oral Polio Vaccine)"),
                                                  sizedBox(context, "3rd"),
                                                  sizedBoxDate(context, immunization.Weeks14OPV.value),
                                                  noteInput(context, immunization.Weeks14OPVNoteController),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width * 0.100,
                                                    child: Row(
                                                      children: [
                                                        IconButton(onPressed: (){
                                                          showEditDialog(context,immunization.Weeks14OPVNoteController, immunization.Weeks14OPV );

                                                        }, icon: Icon(Icons.edit)),
                                                        IconButton(onPressed: (){
                                                        immunization.Weeks14OPV.value = "";
                                                        immunization.Weeks14OPVNoteController.clear();
                                                      }, icon: Icon(Icons.delete)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  sizedBox(context, "OPV"),
                                                  sizedBox(context, "3rd"),
                                                  sizedBoxDate(context, immunization.Weeks14OPV3rd.value),
                                                  noteInput(context, immunization.Weeks14OPV3rdNoteController),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width * 0.100,
                                                    child: Row(
                                                      children: [
                                                        IconButton(onPressed: (){
                                                          showEditDialog(context,immunization.Weeks14OPV3rdNoteController, immunization.Weeks14OPV3rd );

                                                        }, icon: Icon(Icons.edit)),
                                                        IconButton(onPressed: (){
                                                        immunization.Weeks14OPV3rd.value = "";
                                                        immunization.Weeks14OPV3rdNoteController.clear();
                                                      }, icon: Icon(Icons.delete)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),


                                    ],
                                  ),
                                   
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox(context, '18th Weeks'),
                                  sizedBox(context, 'Pneumococcal (conjugate) Pneumonia Vaccine (PCV)'),
                                  sizedBox(context, '3rd'),
                                  sizedBoxDate(context, immunization.Weeks18Pneumococcal.value),
                                  noteInput(context, immunization.Weeks18PneumococcalNoteController),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.Weeks18PneumococcalNoteController, immunization.Weeks18Pneumococcal );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.Weeks18Pneumococcal.value = "";
                                            immunization.Weeks18PneumococcalNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox(context, 'After 9 Months'),
                                  sizedBox(context, 'Measles Rubella (MR)'),
                                  sizedBox(context, '1st'),
                                  sizedBoxDate(context, immunization.AfterMonths9MR.value),
                                  noteInput(context, immunization.AfterMonths9MRNoteController),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.AfterMonths9MRNoteController, immunization.AfterMonths9MR );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.AfterMonths9MR.value = "";
                                            immunization.AfterMonths9MRNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox(context, '15 Months'),
                                  sizedBox(context, 'Measles Rubella (MR)'),
                                  sizedBox(context, '2nd'),
                                  sizedBoxDate(context, immunization.Months15MR.value),
                                  noteInput(context, immunization.Months15MRNoteController),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.Months15MRNoteController, immunization.Months15MR );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.Months15MR.value = "";
                                            immunization.Months15MRNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox(context,"15 Years"),
                                  Column(
                                    children: [
                                      Card(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                sizedBox(context, "MR (Measles, Rubella) Child bearing women"),
                                                sizedBox(context, "1st"),
                                                sizedBoxDate(context, immunization.Years15MR.value),
                                                noteInput(context, immunization.Years15MRNoteController),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width * 0.100,
                                                  child: Row(
                                                    children: [
                                                      IconButton(onPressed: (){
                                                        showEditDialog(context,immunization.Years15MRNoteController, immunization.Years15MR );

                                                      }, icon: Icon(Icons.edit)),
                                                      IconButton(onPressed: (){
                                                        immunization.Years15MR.value = "";
                                                        immunization.Years15MRNoteController.clear();
                                                      }, icon: Icon(Icons.delete)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                sizedBox(context, "TT (Tetanus Toxoid) Child bearing women"),
                                                sizedBox(context, "1st	"),
                                                sizedBoxDate(context, immunization.Years15TT.value),
                                                noteInput(context, immunization.Years15TTNoteController),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width * 0.100,
                                                  child: Row(
                                                    children: [
                                                      IconButton(onPressed: (){
                                                        showEditDialog(context,immunization.Years15TTNoteController, immunization.Years15TT );

                                                      }, icon: Icon(Icons.edit)),
                                                      IconButton(onPressed: (){
                                                          immunization.Years15TT.value = "";
                                                          immunization.Years15TTNoteController.clear();
                                                      }, icon: Icon(Icons.delete)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),


                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox(context, 'At Pregnancy'),
                                  sizedBox(context, 'TT (Tetanus Toxoid)'),
                                  sizedBox(context, '1st'),
                                  sizedBoxDate(context, immunization.atPregnancyTT_1st.value),
                                  noteInput(context, immunization.atPregnancyTT_1stNoteController),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.atPregnancyTT_1stNoteController, immunization.atPregnancyTT_1st );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HepatitisA1st.value = "";
                                            immunization.HepatitisA1stNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox(context, '4 wks after TT1'),
                                  sizedBox(context, 'TT (Tetanus Toxoid)'),
                                  sizedBox(context, '2nd'),
                                  sizedBoxDate(context, immunization.weeks4AfterTT2_2nd.value),
                                  noteInput(context, immunization.weeks4AfterTT2_2ndNoteController),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.weeks4AfterTT2_2ndNoteController, immunization.weeks4AfterTT2_2nd );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HepatitisA1st.value = "";
                                            immunization.HepatitisA1stNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox(context, '6 months after TT-2 or during subsequent pregnancy'),
                                  sizedBox(context, 'TT (Tetanus Toxoid)'),
                                  sizedBox(context, '3rd'),
                                  sizedBoxDate(context, immunization.months6AfterTT2_3rd.value),
                                  noteInput(context, immunization.months6AfterTT2_3rdNoteController),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.months6AfterTT2_3rdNoteController, immunization.months6AfterTT2_3rd );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HepatitisA1st.value = "";
                                            immunization.HepatitisA1stNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox(context, '1 year after TT-3 Or during subsequent pregnancy'),
                                  sizedBox(context, 'TT (Tetanus Toxoid)'),
                                  sizedBox(context, '4th'),
                                  sizedBoxDate(context, immunization.year1AfterTT3.value),
                                  noteInput(context, immunization.year1AfterTT3NoteController),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.year1AfterTT3NoteController, immunization.year1AfterTT3 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HepatitisA1st.value = "";
                                            immunization.HepatitisA1stNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox(context, '1 year after TT-4 Or during subsequent pregnancy'),
                                  sizedBox(context, 'TT (Tetanus Toxoid)'),
                                  sizedBox(context, '5th'),
                                  sizedBoxDate(context, immunization.year1AfterTT4.value),
                                  noteInput(context, immunization.year1AfterTT4NoteController),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.year1AfterTT4NoteController, immunization.year1AfterTT4 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HepatitisA1st.value = "";
                                            immunization.HepatitisA1stNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )

        ],
      )),
    );
  });
}
immunizationOptional(context){
  final immunization = Get.put(Immunization());
  showDialog(context: context, builder: (context){
    return AlertDialog(

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Routine Immunization Optional"),

          ElevatedButton(onPressed: (){
             Navigator.pop(context);
          }, child: Text("Main")),

          Row(
            children: [
              ElevatedButton(onPressed: (){
                immunization.isDataExist.value = true;
                Navigator.pop(context);
              }, child: Text("Save")),

              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Close")),
            ],
          ),
        ],
      ),

      content: Obx(() => Column(
        children: [
          Card(
            color: Colors.white,
            elevation: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  sizedBox( context,'Recommended Age'),
                  sizedBox( context,'Vaccine'),
                  sizedBox( context,'Dose'),
                  sizedBox( context,'Date'),
                  sizedBox( context,'Note'),
                  sizedBox( context,'Action'),

                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Card(
                            color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Hepatitis A Vaccine'),
                                  ),
                                ],
                              )
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox(context, ">1 year (any time)"),
                                  sizedBox(context, "Hepatitis A Vaccine"),
                                  sizedBox(context, "1st"),
                                  sizedBoxDate(context, immunization.HepatitisA1st.value),
                                  noteInput(context, immunization.HepatitisA1stNoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.HepatitisA1stNoteController, immunization.HepatitisA1st );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HepatitisA1st.value = "";
                                            immunization.HepatitisA1stNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "6 months after 1st dose"),
                                  sizedBox( context, "Hepatitis A Vaccine"),
                                  sizedBox( context, "Booster"),
                                  sizedBoxDate(context, immunization.HepatitisA2nd.value),
                                  noteInput(context, immunization.HepatitisA2ndNoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.HepatitisA2ndNoteController, immunization.HepatitisA2nd );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HepatitisA2nd.value = "";
                                            immunization.HepatitisA2ndNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Hepatitis B Vaccine (Adult)'),
                                  ),
                                ],
                              )
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "Any day"),
                                  sizedBox( context, "Hepatitis B Vaccine (Adult)"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.HepatitisB1st.value),
                                  noteInput(context, immunization.HepatitisB1stNoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.HepatitisB1stNoteController, immunization.HepatitisB1st );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HepatitisB1st.value = "";
                                            immunization.HepatitisB1stNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "1 month from the 1st dose"),
                                  sizedBox( context, "Hepatitis B Vaccine (Adult)"),
                                  sizedBox( context, "2nd"),
                                  sizedBoxDate(context, immunization.HepatitisB2nd.value),
                                  noteInput(context, immunization.HepatitisB2ndNoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.HepatitisB2ndNoteController, immunization.HepatitisB2nd );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HepatitisB2nd.value = "";
                                            immunization.HepatitisB2ndNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "2 months from the 1st dose"),
                                  sizedBox( context, "Hepatitis B Vaccine (Adult)"),
                                  sizedBox( context, "3rd"),
                                  sizedBoxDate(context, immunization.HepatitisB3rd.value),
                                  noteInput(context, immunization.HepatitisB3rdNoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.HepatitisB3rdNoteController, immunization.HepatitisB3rd );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HepatitisB3rd.value = "";
                                            immunization.HepatitisB3rdNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "12 months from the 1st dose"),
                                  sizedBox( context, "Hepatitis B Vaccine (Adult)"),
                                  sizedBox( context, "4th"),
                                  sizedBoxDate(context, immunization.HepatitisB4.value),
                                  noteInput(context, immunization.HepatitisB4NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.HepatitisB4NoteController, immunization.HepatitisB4 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HepatitisB4.value = "";
                                            immunization.HepatitisB4NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Haemophilus influenzae type b (Hib)'),
                                  ),
                                ],
                              )
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "6 months-12months"),
                                  sizedBox( context, "Haemophilus influenzae type b (Hib)"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.HaemophilusInfluenza1.value),
                                  noteInput(context, immunization.HaemophilusInfluenza1NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.HaemophilusInfluenza1NoteController, immunization.HaemophilusInfluenza1 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HaemophilusInfluenza1.value = "";
                                            immunization.HaemophilusInfluenza1NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "4 weeks after the 1st dose"),
                                  sizedBox( context, "Haemophilus influenzae type b (Hib)"),
                                  sizedBox( context, "2nd"),
                                  sizedBoxDate(context, immunization.HaemophilusInfluenza2.value),
                                  noteInput(context, immunization.HaemophilusInfluenza2NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.HaemophilusInfluenza2NoteController, immunization.HaemophilusInfluenza2 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HaemophilusInfluenza2.value = "";
                                            immunization.HaemophilusInfluenza2NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "4 weeks after the 2nd dose"),
                                  sizedBox( context, "Haemophilus influenzae type b (Hib)"),
                                  sizedBox( context, "3rd"),
                                  sizedBoxDate(context, immunization.HaemophilusInfluenza3.value),
                                  noteInput(context, immunization.HaemophilusInfluenza3NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.HaemophilusInfluenza3NoteController, immunization.HaemophilusInfluenza3 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HaemophilusInfluenza3.value = "";
                                            immunization.HaemophilusInfluenza3NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "6 months after the 3rd dose"),
                                  sizedBox( context, "Haemophilus influenzae type b (Hib)"),
                                  sizedBox( context, "Booster"),
                                  sizedBoxDate(context, immunization.HaemophilusInfluenzaBooster.value),
                                  noteInput(context, immunization.HaemophilusInfluenzaBoosterNoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.HaemophilusInfluenzaBoosterNoteController, immunization.HaemophilusInfluenzaBooster );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HaemophilusInfluenzaBooster.value = "";
                                            immunization.HaemophilusInfluenzaBoosterNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "1 year-5 years"),
                                  sizedBox( context, "Haemophilus influenzae type b (Hib)"),
                                  sizedBox( context, "1 single dose"),
                                  sizedBoxDate(context, immunization.HaemophilusInfluenzaSingle.value),
                                  noteInput(context, immunization.HaemophilusInfluenzaSingleNoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.HaemophilusInfluenzaSingleNoteController, immunization.HaemophilusInfluenzaSingle );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HaemophilusInfluenzaSingle.value = "";
                                            immunization.HaemophilusInfluenzaSingleNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Human Papillomavirus (HPV)'),
                                  ),
                                ],
                              )
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "9-13 years female"),
                                  sizedBox( context, "Human Papillomavirus (HPV)"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.HumanPapillomaVirus1.value),
                                  noteInput(context, immunization.HumanPapillomaVirus1NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.HumanPapillomaVirus1NoteController, immunization.HumanPapillomaVirus1 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HumanPapillomaVirus1.value = "";
                                            immunization.HumanPapillomaVirus1NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "6 months after the 1st dose"),
                                  sizedBox( context, "Human Papillomavirus (HPV)"),
                                  sizedBox( context, "2nd"),
                                  sizedBoxDate(context, immunization.HumanPapillomaVirus2.value),
                                  noteInput(context, immunization.HumanPapillomaVirus2NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.HumanPapillomaVirus2NoteController, immunization.HumanPapillomaVirus2 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HumanPapillomaVirus2.value = "";
                                            immunization.HumanPapillomaVirus2NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, ">15 years female"),
                                  sizedBox( context, "Human Papillomavirus (HPV)"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.HumanPapillomaVirus3.value),
                                  noteInput(context, immunization.HumanPapillomaVirus3NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.HumanPapillomaVirus3NoteController, immunization.HumanPapillomaVirus3 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HumanPapillomaVirus3.value = "";
                                            immunization.HumanPapillomaVirus3NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "1 month after the 1st dose"),
                                  sizedBox( context, "Human Papillomavirus (HPV)"),
                                  sizedBox( context, "2nd"),
                                  sizedBoxDate(context, immunization.HumanPapillomaVirus4.value),
                                  noteInput(context, immunization.HumanPapillomaVirus4NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.HumanPapillomaVirus4NoteController, immunization.HumanPapillomaVirus4 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HumanPapillomaVirus4.value = "";
                                            immunization.HumanPapillomaVirus4NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "6 months after the 1st dose"),
                                  sizedBox( context, "Human Papillomavirus (HPV)"),
                                  sizedBox( context, "3rd"),
                                  sizedBoxDate(context, immunization.HumanPapillomaVirus5.value),
                                  noteInput(context, immunization.HumanPapillomaVirus5NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.HumanPapillomaVirus5NoteController, immunization.HumanPapillomaVirus5 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.HumanPapillomaVirus5.value = "";
                                            immunization.HumanPapillomaVirus5NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Polysaccharide pneumococcal vaccine'),
                                  ),
                                ],
                              )
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, ">2 years-65 years"),
                                  sizedBox( context, "Polysaccharide pneumococcal vaccine"),
                                  sizedBox( context, "1 single dose"),
                                  sizedBoxDate(context, immunization.Polysaccharide1.value),
                                  noteInput(context, immunization.Polysaccharide1NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.Polysaccharide1NoteController, immunization.Polysaccharide1 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.Polysaccharide1.value = "";
                                            immunization.Polysaccharide1NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, ">65 years (after every 5 years)"),
                                  sizedBox( context, "Rabies Vaccine"),
                                  sizedBox( context, "Booster"),
                                  sizedBoxDate(context, immunization.PolysaccharideBooster.value),
                                  noteInput(context, immunization.PolysaccharideBoosterNoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.PolysaccharideBoosterNoteController, immunization.PolysaccharideBooster );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.PolysaccharideBooster.value = "";
                                            immunization.PolysaccharideBoosterNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Rabies Vaccine(pre exposer)'),
                                  ),
                                ],
                              )
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "Any Day"),
                                  sizedBox( context, "Rabies Vaccine"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.RabiesVaccinePre1.value),
                                  noteInput(context, immunization.RabiesVaccinePre1NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.RabiesVaccinePre1NoteController, immunization.RabiesVaccinePre1 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.RabiesVaccinePre1.value = "";
                                            immunization.RabiesVaccinePre1NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "7th day from the 1st dose"),
                                  sizedBox( context, "Rabies Vaccine"),
                                  sizedBox( context, "2nd"),
                                  sizedBoxDate(context, immunization.RabiesVaccinePre2.value),
                                  noteInput(context, immunization.RabiesVaccinePre2NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.RabiesVaccinePre2NoteController, immunization.RabiesVaccinePre2 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.RabiesVaccinePre2.value = "";
                                            immunization.RabiesVaccinePre2NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "21st day from the 1st dose"),
                                  sizedBox( context, "Rabies Vaccine"),
                                  sizedBox( context, "3rd"),
                                  sizedBoxDate(context, immunization.RabiesVaccinePre3.value),
                                  noteInput(context, immunization.RabiesVaccinePre3NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.RabiesVaccinePre3NoteController, immunization.RabiesVaccinePre3 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.RabiesVaccinePre3.value = "";
                                            immunization.RabiesVaccinePre3NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "28th day from the 1st dose"),
                                  sizedBox( context, "Rabies Vaccine"),
                                  sizedBox( context, "4th"),
                                  sizedBoxDate(context, immunization.RabiesVaccinePre4.value),
                                  noteInput(context, immunization.RabiesVaccinePre4NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.RabiesVaccinePre4NoteController, immunization.RabiesVaccinePre4 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.RabiesVaccinePre4.value = "";
                                            immunization.RabiesVaccinePre4NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "1 year after"),
                                  sizedBox( context, "Rabies Vaccine"),
                                  sizedBox( context, "Booster"),
                                  sizedBoxDate(context, immunization.RabiesVaccinePreBooster1.value),
                                  noteInput(context, immunization.RabiesVaccinePreBooster1NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.RabiesVaccinePreBooster1NoteController, immunization.RabiesVaccinePreBooster1 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.RabiesVaccinePreBooster1.value = "";
                                            immunization.RabiesVaccinePreBooster1NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "Then Every 5 years"),
                                  sizedBox( context, "Rabies Vaccine"),
                                  sizedBox( context, "Booster"),
                                  sizedBoxDate(context, immunization.RabiesVaccinePreBooster2.value),
                                  noteInput(context, immunization.RabiesVaccinePreBooster2NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.RabiesVaccinePreBooster2NoteController, immunization.RabiesVaccinePreBooster2 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.RabiesVaccinePreBooster2.value = "";
                                            immunization.RabiesVaccinePreBooster2NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Rabies Vaccine (Post exposer)'),
                                  ),
                                ],
                              )
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "Any day (suspected contact day)"),
                                  sizedBox( context, "Rabies Vaccine"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.RabiesVaccinePost1.value),
                                  noteInput(context, immunization.RabiesVaccinePost1NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.RabiesVaccinePost1NoteController, immunization.RabiesVaccinePost1 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.RabiesVaccinePost1.value = "";
                                            immunization.RabiesVaccinePost1NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "3rd day from the 1st day"),
                                  sizedBox( context, "Rabies Vaccine"),
                                  sizedBox( context, "2nd"),
                                  sizedBoxDate(context, immunization.RabiesVaccinePost2.value),
                                  noteInput(context, immunization.RabiesVaccinePost2NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.RabiesVaccinePost2NoteController, immunization.RabiesVaccinePost2 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.RabiesVaccinePost2.value = "";
                                            immunization.RabiesVaccinePost2NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "7th day from the 1st dose"),
                                  sizedBox( context, "Rabies Vaccine"),
                                  sizedBox( context, "3rd"),
                                  sizedBoxDate(context, immunization.RabiesVaccinePost3.value),
                                  noteInput(context, immunization.RabiesVaccinePost3NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.RabiesVaccinePost3NoteController, immunization.RabiesVaccinePost3 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.RabiesVaccinePost3.value = "";
                                            immunization.RabiesVaccinePost3NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "14th day from the 1st dose"),
                                  sizedBox( context, "Rabies Vaccine"),
                                  sizedBox( context, "4th"),
                                  sizedBoxDate(context, immunization.RabiesVaccinePost4.value),
                                  noteInput(context, immunization.RabiesVaccinePost4NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.RabiesVaccinePost4NoteController, immunization.RabiesVaccinePost4 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.RabiesVaccinePost4.value = "";
                                            immunization.RabiesVaccinePost4NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "28th day from the 1st dose"),
                                  sizedBox( context, "Rabies Vaccine"),
                                  sizedBox( context, "5th"),
                                  sizedBoxDate(context, immunization.RabiesVaccinePost5.value),
                                  noteInput(context, immunization.RabiesVaccinePost5NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.RabiesVaccinePost5NoteController, immunization.RabiesVaccinePost5 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.RabiesVaccinePost5.value = "";
                                            immunization.RabiesVaccinePost5NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "5 years after last dose"),
                                  sizedBox( context, "Rabies Vaccine"),
                                  sizedBox( context, "Booster"),
                                  sizedBoxDate(context, immunization.RabiesVaccinePost5.value),
                                  noteInput(context, immunization.RabiesVaccinePostBooster1NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.RabiesVaccinePostBooster1NoteController, immunization.RabiesVaccinePostBooster1 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.RabiesVaccinePostBooster1.value = "";
                                            immunization.RabiesVaccinePostBooster1NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Typhoid Vaccine'),
                                  ),
                                ],
                              )
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "2 years and above"),
                                  sizedBox( context, "Typhoid Vaccine"),
                                  sizedBox( context, "1 single dose"),
                                  sizedBoxDate(context, immunization.Typhoid1.value),
                                  noteInput(context, immunization.Typhoid1NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.Typhoid1NoteController, immunization.Typhoid1 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.Typhoid1.value = "";
                                            immunization.Typhoid1NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "Every 3 years after"),
                                  sizedBox( context, "Typhoid Vaccine"),
                                  sizedBox( context, "Booster"),
                                  sizedBoxDate(context, immunization.TyphoidBooster.value),
                                  noteInput(context, immunization.TyphoidBoosterNoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.TyphoidBoosterNoteController, immunization.TyphoidBooster );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.TyphoidBooster.value = "";
                                            immunization.TyphoidBoosterNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Oral Cholera vaccine'),
                                  ),
                                ],
                              )
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "2-6 years"),
                                  sizedBox( context, "Oral Cholera vaccine"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.OralCholera1.value),
                                  noteInput(context, immunization.OralCholera1NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.OralCholera1NoteController, immunization.OralCholera1 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.OralCholera1.value = "";
                                            immunization.OralCholera1NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "1 week after 1st dose"),
                                  sizedBox( context, "Oral Cholera vaccine"),
                                  sizedBox( context, "2nd"),
                                  sizedBoxDate(context, immunization.OralCholera2.value),
                                  noteInput(context, immunization.OralCholera2NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.OralCholera2NoteController, immunization.OralCholera2 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.OralCholera2.value = "";
                                            immunization.OralCholera2NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "1 week after 2nd dose"),
                                  sizedBox( context, "Oral Cholera vaccine"),
                                  sizedBox( context, "3rd"),
                                  sizedBoxDate(context, immunization.OralCholera3.value),
                                  noteInput(context, immunization.OralCholera3NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.OralCholera3NoteController, immunization.OralCholera3 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.OralCholera3.value = "";
                                            immunization.OralCholera3NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "Every 6 months"),
                                  sizedBox( context, "Oral Cholera vaccine"),
                                  sizedBox( context, "Booster"),
                                  sizedBoxDate(context, immunization.OralCholeraBooster.value),
                                  noteInput(context, immunization.OralCholeraBoosterNoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.OralCholeraBoosterNoteController, immunization.OralCholeraBooster );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.OralCholeraBooster.value = "";
                                            immunization.OralCholeraBoosterNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, ">6 years & above"),
                                  sizedBox( context, "Oral Cholera vaccine"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.OralCholeraBooster1.value),
                                  noteInput(context, immunization.OralCholeraBooster1NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.OralCholeraBooster1NoteController, immunization.OralCholeraBooster1 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.OralCholeraBooster1.value = "";
                                            immunization.OralCholeraBooster1NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "1 week after 1st dose"),
                                  sizedBox( context, "Oral Cholera vaccine"),
                                  sizedBox( context, "2nd"),
                                  sizedBoxDate(context, immunization.OralCholeraBooster2.value),
                                  noteInput(context, immunization.OralCholeraBooster2NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.OralCholeraBooster2NoteController, immunization.OralCholeraBooster2 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.OralCholeraBooster2.value = "";
                                            immunization.OralCholeraBooster2NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "Every 2 years"),
                                  sizedBox( context, "Oral Cholera vaccine"),
                                  sizedBox( context, "Booster"),
                                  sizedBoxDate(context, immunization.OralCholeraBooster3.value),
                                  noteInput(context, immunization.OralCholeraBooster3NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.OralCholeraBooster3NoteController, immunization.OralCholeraBooster3 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.OralCholeraBooster3.value = "";
                                            immunization.OralCholeraBooster3NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Tetanus Toxoid'),
                                  ),
                                ],
                              )
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "As primary immunization (at appropriate date)"),
                                  sizedBox( context, "Tetanus Toxoid"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.TetanusToxoid1.value),
                                  noteInput(context, immunization.TetanusToxoid1NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.TetanusToxoid1NoteController, immunization.TetanusToxoid1 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.TetanusToxoid1.value = "";
                                            immunization.TetanusToxoid1NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "1-2 months after 1st dose"),
                                  sizedBox( context, "Tetanus Toxoid"),
                                  sizedBox( context, "2nd"),
                                  sizedBoxDate(context, immunization.TetanusToxoid2.value),
                                  noteInput(context, immunization.TetanusToxoid2NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.TetanusToxoid2NoteController, immunization.TetanusToxoid2 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.TetanusToxoid2.value = "";
                                            immunization.TetanusToxoid2NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "6-12 months after the 2nd dose"),
                                  sizedBox( context, "Tetanus Toxoid"),
                                  sizedBox( context, "3rd"),
                                  sizedBoxDate(context, immunization.TetanusToxoid3.value),
                                  noteInput(context, immunization.TetanusToxoid3NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.TetanusToxoid3NoteController, immunization.TetanusToxoid3 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.TetanusToxoid3.value = "";
                                            immunization.TetanusToxoid3NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "Every 10 years"),
                                  sizedBox( context, "Tetanus Toxoid"),
                                  sizedBox( context, "Booster"),
                                  sizedBoxDate(context, immunization.TetanusToxoidBooster.value),
                                  noteInput(context, immunization.TetanusToxoidBoosterNoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.TetanusToxoidBoosterNoteController, immunization.TetanusToxoidBooster );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.TetanusToxoidBooster.value = "";
                                            immunization.TetanusToxoidBoosterNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('MMR (Mumps, Measles, Rubella)'),
                                  ),
                                ],
                              )
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "12-15 months"),
                                  sizedBox( context, "MMR (Mumps, Measles, Rubella)"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.MMR1.value),
                                  noteInput(context, immunization.MMR1NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.MMR1NoteController, immunization.MMR1 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.MMR1.value = "";
                                            immunization.MMR1NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "3-5 years"),
                                  sizedBox( context, "MMR (Mumps, Measles, Rubella)"),
                                  sizedBox( context, "2nd"),
                                  sizedBoxDate(context, immunization.MMR2.value),
                                  noteInput(context, immunization.MMR2NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.MMR2NoteController, immunization.MMR2 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.MMR2.value = "";
                                            immunization.MMR2NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Yellow Fever'),
                                  ),
                                ],
                              )
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "9 months and Above"),
                                  sizedBox( context, "Yellow Fever"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.Yellow.value),
                                  noteInput(context, immunization.YellowNoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.YellowNoteController, immunization.Yellow );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.Yellow.value = "";
                                            immunization.YellowNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Chicken Pox Vaccine'),
                                  ),
                                ],
                              )
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "12-15 months"),
                                  sizedBox( context, "Chicken Pox Vaccine"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.ChickenPox1.value),
                                  noteInput(context, immunization.ChickenPox1NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.ChickenPox1NoteController, immunization.ChickenPox1 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.ChickenPox1.value = "";
                                            immunization.ChickenPox1NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "4-6 years"),
                                  sizedBox( context, "Chicken Pox Vaccine"),
                                  sizedBox( context, "2nd"),
                                  sizedBoxDate(context, immunization.ChickenPox2.value),
                                  noteInput(context, immunization.ChickenPox2NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.ChickenPox2NoteController, immunization.ChickenPox2 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.ChickenPox2.value = "";
                                            immunization.ChickenPox2NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "> 13 years"),
                                  sizedBox( context, "Chicken Pox Vaccine"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.ChickenPox3.value),
                                  noteInput(context, immunization.ChickenPox3NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.ChickenPox3NoteController, immunization.ChickenPox3 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.ChickenPox3.value = "";
                                            immunization.ChickenPox3NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "6-10 weeks after 1st dose"),
                                  sizedBox( context, "Chicken Pox Vaccine"),
                                  sizedBox( context, "2nd"),
                                  sizedBoxDate(context, immunization.ChickenPox4.value),
                                  noteInput(context, immunization.ChickenPox4NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.ChickenPox4NoteController, immunization.ChickenPox4 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.ChickenPox4.value = "";
                                            immunization.ChickenPox4NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Meningococcal polysaccharide vaccine'),
                                  ),
                                ],
                              )
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, ">2 years"),
                                  sizedBox( context, "Meningococcal polysaccharide vaccine"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.Meningococcal1.value),
                                  noteInput(context, immunization.Meningococcal1NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.Meningococcal1NoteController, immunization.Meningococcal1 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.Meningococcal1.value = "";
                                            immunization.Meningococcal1NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "3-5 years"),
                                  sizedBox( context, "Meningococcal polysaccharide vaccine"),
                                  sizedBox( context, "Booster"),
                                  sizedBoxDate(context, immunization.MeningococcalBooster.value),
                                  noteInput(context, immunization.MeningococcalBoosterNoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.MeningococcalBoosterNoteController, immunization.MeningococcalBooster );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.MeningococcalBooster.value = "";
                                            immunization.MeningococcalBoosterNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Meningococcal Quadrivalent conjugate vaccines'),
                                  ),
                                ],
                              )
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "9-23 months"),
                                  sizedBox( context, "Meningococcal Quadrivalent conjugate vaccines"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.MeningococcalQuadrivalent1.value),
                                  noteInput(context, immunization.MeningococcalQuadrivalent1NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.MeningococcalQuadrivalent1NoteController, immunization.MeningococcalQuadrivalent1 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.MeningococcalQuadrivalent1.value = "";
                                            immunization.MeningococcalQuadrivalent1NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "3 months after 1st dose"),
                                  sizedBox( context, "Meningococcal Quadrivalent conjugate vaccines"),
                                  sizedBox( context, "2nd"),
                                  sizedBoxDate(context, immunization.MeningococcalQuadrivalent2.value),
                                  noteInput(context, immunization.MeningococcalQuadrivalent2NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.MeningococcalQuadrivalent2NoteController, immunization.MeningococcalQuadrivalent2 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.MeningococcalQuadrivalent2.value = "";
                                            immunization.MeningococcalQuadrivalent2NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, ">2 years"),
                                  sizedBox( context, "Meningococcal Quadrivalent conjugate vaccines"),
                                  sizedBox( context, "1 single dose	"),
                                  sizedBoxDate(context, immunization.MeningococcalQuadrivalentSingle.value),
                                  noteInput(context, immunization.MeningococcalQuadrivalentSinglNoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.MeningococcalQuadrivalentSinglNoteController, immunization.MeningococcalQuadrivalentSingle );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.MeningococcalQuadrivalentSingle.value = "";
                                            immunization.MeningococcalQuadrivalentSinglNoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Card(
                              color: Colors.grey[200],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Seasonal Influenza (Inactivated Vaccine)'),
                                  ),
                                ],
                              )
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "6 months-8 years"),
                                  sizedBox( context, "Seasonal Influenza (Inactivated Vaccine)"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.SeasonalInfluenza1.value),
                                  noteInput(context, immunization.SeasonalInfluenza1NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.SeasonalInfluenza1NoteController, immunization.SeasonalInfluenza1 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.SeasonalInfluenza1.value = "";
                                            immunization.SeasonalInfluenza1NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "4 weeks after 1st dose"),
                                  sizedBox( context, "Seasonal Influenza (Inactivated Vaccine)"),
                                  sizedBox( context, "2nd"),
                                  sizedBoxDate(context, immunization.SeasonalInfluenza2.value),
                                  noteInput(context, immunization.SeasonalInfluenza2NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.SeasonalInfluenza2NoteController, immunization.SeasonalInfluenza2 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.SeasonalInfluenza2.value = "";
                                            immunization.SeasonalInfluenza2NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "9 years and above"),
                                  sizedBox( context, "Seasonal Influenza (Inactivated Vaccine)"),
                                  sizedBox( context, "1st"),
                                  sizedBoxDate(context, immunization.SeasonalInfluenza3.value),
                                  noteInput(context, immunization.SeasonalInfluenza3NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.SeasonalInfluenza3NoteController, immunization.SeasonalInfluenza3 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.SeasonalInfluenza3.value = "";
                                            immunization.SeasonalInfluenza3NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  sizedBox( context, "Every year"),
                                  sizedBox( context, "Seasonal Influenza (Inactivated Vaccine)"),
                                  sizedBox( context, "Booster"),
                                  sizedBoxDate(context, immunization.SeasonalInfluenza4.value),
                                  noteInput(context, immunization.SeasonalInfluenza4NoteController),

                                  SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.100,
                                      child: Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            showEditDialog(context,immunization.SeasonalInfluenza4NoteController, immunization.SeasonalInfluenza4 );
                                          }, icon: Icon(Icons.edit)),
                                          IconButton(onPressed: (){
                                            immunization.SeasonalInfluenza4.value = "";
                                            immunization.SeasonalInfluenza4NoteController.clear();
                                          }, icon: Icon(Icons.delete)),
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )

        ],
      )),
    );
  });
}

SizedBox sizedBox(BuildContext context, String text) {
  return SizedBox(
          width: MediaQuery.of(context).size.width * 0.140,
          // child: Text(text.isNotEmpty ? text.substring(0,10) : '',)
          child: Text(text)
        );
      }

SizedBox sizedBoxDate(BuildContext context, String text) {
  return SizedBox(
          width: MediaQuery.of(context).size.width * 0.140,
          child:  Text(text.isNotEmpty ? text.substring(0,10) : '',)
          // child: Text(text)
        );
      }
 noteInput(BuildContext context,noteController) {
  return SizedBox(
          width: MediaQuery.of(context).size.width * 0.140,
          child: TextField(
            controller: noteController,
            enabled: false,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          )
        );
      }
showEditDialog(context, noteController, dateValue){
  showDialog(context: context, builder: (context){
    return AlertDialog(
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('Cancel')),
        TextButton(onPressed: (){
          Navigator.pop(context);
          Navigator.pop(context);
        }, child: Text('Save')),
      ],
      content: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            TextField(
              controller: noteController,
               decoration: InputDecoration(
                 border: OutlineInputBorder(),
                 hintText: "Enter Note",
               ),
            ),
            SizedBox(height: 20,),
           Obx(() =>  TextFormField(
             onTap: ()async{
               final DateTime? picked = await showDatePicker(
                 context: context,
                 initialDate: DateTime.now(),
                 firstDate: DateTime(2000),
                 lastDate: DateTime(2101),
               );
               showEditDialog(context, noteController, dateValue);
               if (picked != null) {
                 // Do something with the selected date
                 dateValue.value = picked.toString();
               }


             },
             initialValue:dateValue.value.toString().isNotEmpty ? dateValue.value.toString().substring(0,10) : '',
             decoration: InputDecoration(
               border: OutlineInputBorder(),
               hintText: "Enter data",
             ),
           ),)

          ],
        )
      ),
    );
  });
}


