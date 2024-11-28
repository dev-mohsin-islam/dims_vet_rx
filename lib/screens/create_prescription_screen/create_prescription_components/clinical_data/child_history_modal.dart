

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';
import 'package:dims_vet_rx/controller/child_history/child_history_controller.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';

childHistoryNewDialog(context){
  ChildHistoryController childHistoryCont = Get.put(ChildHistoryController());
  AppointmentController appointmentController = Get.put(AppointmentController());
  showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Child History"),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.clear))
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: childHistoryCont.selectedChildHistory.length,
                  itemBuilder: (context, index){
                    var item = childHistoryCont.selectedChildHistory[index];
                    var filedList = item['data'];
                    return Card(
                      child: ExpansionTile(
                        title: Text(item['title']),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for(var i = 0; i < filedList.length; i++)
                                Card(child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Text(filedList[i]['title'], style: TextStyle(fontWeight: FontWeight.bold),),
                                      Column(
                                        children: [
                                          if(filedList[i]['type'] == "radio")
                                            Card(
                                              child: Wrap(
                                                children: [
                                                  for(var j = 0; j < filedList[i]['field'].length; j++)
                                                    Wrap(
                                                      children: [
                                                        SizedBox(
                                                          width: 150,
                                                          child: RadioMenuButton(
                                                            value: filedList[i]['field'][j],
                                                            groupValue: filedList[i]['value'],
                                                            onChanged: (value){
                                                              filedList[i]['value'] = value;
                                                              print(value);
                                                              childHistoryCont.selectedChildHistory.refresh();
                                                            }, child: Text(filedList[i]['field'][j]),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                ],
                                              ),
                                            ),
                                          if(filedList[i]['type'] == "textInput")
                                            Card(
                                              child: SizedBox(
                                                child: Wrap(
                                                  crossAxisAlignment: WrapCrossAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 200,
                                                      child: TextField(
                                                        decoration: InputDecoration(
                                                          border: OutlineInputBorder(),
                                                          labelText: "Write here",
                                                        ),

                                                        onChanged: (value){
                                                          filedList[i]['value'] = value;
                                                          print(value);
                                                          childHistoryCont.selectedChildHistory.refresh();
                                                        },
                                                      ),
                                                    ),
                                                    if(filedList[i]['field'] !=null)
                                                      if(filedList[i]['field'].length > 0)
                                                        for(var j = 0; j < filedList[i]['field'].length; j++)
                                                          Container(
                                                            width: 100,
                                                            child: RadioMenuButton(
                                                              value: filedList[i]['field'][j].toString(),
                                                              groupValue: filedList[i]['selectedDurationType'],
                                                              onChanged: (value){
                                                                filedList[i]['selectedDurationType'] = value;
                                                                childHistoryCont.selectedChildHistory.refresh();
                                                              }, child: Text(filedList[i]['field'][j].toString()),
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            )
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                            ],
                          )
                        ],
                      ),
                    );
                  })
            ],
          )),
        ),
      ),
    );
  });
}
childHistoryDialog(context){
  ChildHistoryController childHistoryCont = Get.put(ChildHistoryController());
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
                Text("Child History"),

                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.clear))
              ],
            ),

            Obx(() => Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FilterChip(
                      selected: childHistoryCont.screenIndex.value == 0,
                      label: Text("Birth History"),
                      onSelected: (value){
                        childHistoryCont.screenIndex.value = 0;
                      }),
                ),

                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FilterChip(
                      selected: childHistoryCont.screenIndex.value == 1,
                      label: Text("Health History"),
                      onSelected: (value){
                        childHistoryCont.screenIndex.value = 1;
                      }),
                ),

                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FilterChip(
                      selected: childHistoryCont.screenIndex.value == 2,
                      label: Text("Developmental Milestones"),
                      onSelected: (value){
                        childHistoryCont.screenIndex.value = 2;
                      }),
                ),

                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FilterChip(
                      selected: childHistoryCont.screenIndex.value == 3,
                      label: Text("Feeding History"),
                      onSelected: (value){
                        childHistoryCont.screenIndex.value = 3;
                      }),
                ),

                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FilterChip(
                      selected: childHistoryCont.screenIndex.value == 4,
                      label: Text("Temperamental & Personality"),
                      onSelected: (value){
                        childHistoryCont.screenIndex.value = 4;
                      }),
                ),
              ],
            ),),

          ],
        ),
        actions: [
          ElevatedButton(onPressed: (){
              childHistoryCont.isDataExist.value = true;
              Helpers.successSnackBar("Success", "Successfully Saved");
              childHistoryCont.isTempermentalAndPersonal.value = false;
              childHistoryCont.isFeedingHistoryOpen.value = false;
              childHistoryCont.isDevelopmentalMilestonesOpen.value = false;
              childHistoryCont.isBirthHistoryOpen.value = false;
              childHistoryCont.isHealthHistoryOpen.value = false;
              Navigator.pop(context);

          }, child: Text("Save"))
        ],
        content: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Obx(() => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            
                Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //selected screen
                        if(childHistoryCont.screenIndex.value == 0)
                          birthHistory(context),
            
                        if(childHistoryCont.screenIndex.value == 1)
                          healthHistory(context),
            
                        if(childHistoryCont.screenIndex.value == 2)
                          developmentMilestones(context),
            
                        if(childHistoryCont.screenIndex.value == 3)
                          feedingHistory(context),
            
                        if(childHistoryCont.screenIndex.value == 4)
                          temperamentPersonality(context),
            
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

Widget birthHistory(context){
 ChildHistoryController childHistoryCont = Get.put(ChildHistoryController());
  return ListTile(
    title: Wrap(
      children: [
        SizedBox(
            width: 300,
            child: absentPresentDropDow(context, 'Rhesus incompatibility' , childHistoryCont.rhesusIncompatibility)),
        SizedBox(
            width: 300,
            child: textField(context, childHistoryCont.mothersAgeDuringBirth,"Mother’s age during birth:", "Write mothers age during birth", "Years",)),
        durationLabourDropDow(context, 'Duration of labour',  childHistoryCont.DurationOfLabour), //not ready
        absentPresentDropDow(context, 'Birth Trauma', childHistoryCont.BirthTrauma),
        absentPresentDropDow(context, 'Miscarriages', childHistoryCont.Miscarriages),
        absentPresentDropDow(context, 'Presentation', childHistoryCont.Presentation),//not trady
        yesNotDropDow(context, 'Delayed crying', childHistoryCont.DelayedCrying),
        absentPresentDropDow(context, 'Febrile illness', childHistoryCont.FebrileIllness),
        absentPresentDropDow(context, 'Jaundice', childHistoryCont.Jaundice),
        absentPresentDropDow(context, 'Hypoglycemia', childHistoryCont.Hypoglycemia),
        yesNotDropDow(context, 'Consanguinity of marriage', childHistoryCont.ConsanguinityOfMarriage),
        yesNotDropDow(context, 'Haemolytic disease', childHistoryCont.HaemolyticDisease),
        textField(context, childHistoryCont.Gestation,"Gestation", "Write Duration", "Weeks",),
        yesNotDropDow(context, 'Type of delivery', childHistoryCont.TypeOfDelivery), //not ready
        yesNotDropDow(context, 'Complications during pregnancy', childHistoryCont.ComplicationsDuringPregnancy),
        yesNotDropDow(context, 'Resuscitation', childHistoryCont.Resuscitation), //not ready
        absentPresentDropDow(context, 'Fetal distress', childHistoryCont.FetalDistress),
        textField(context, childHistoryCont.BirthWeight,"Birth weight", "Write Birth weight", "Kg",),
        absentPresentDropDow(context, 'Convulsion/Seizure', childHistoryCont.Convulsion),
        absentPresentDropDow(context, 'Bleeding disorders', childHistoryCont.BleedingDisorders),
        absentPresentDropDow(context, 'Septicemia', childHistoryCont.Septicemia),
        absentPresentDropDow(context, 'Respiratory distress', childHistoryCont.RespiratoryDistress),

      ],
    ),
  );
}
Widget healthHistory(context){
 ChildHistoryController childHistoryCont = Get.put(ChildHistoryController());
  return Container(
    child: Column(
      children: [
        Wrap(
          children: [
            currentHealth(context, 'What is the current health status of your child?' , childHistoryCont.currentHealth),
            yesNotDropDow(context, 'Do you have any specific medical concerns about your child?', childHistoryCont.specificMedicalConcerns),
            yesNotDropDow(context, 'Is your child allergic to any medications?', childHistoryCont.childAllergic),
            yesNotWithDonKnowDropDow(context, 'Are your child’s immunizations up to date?', childHistoryCont.immunizationsUpToDate),
            yesNotWithDonKnowDropDow(context, 'Has your child had a Speech/language screening?', childHistoryCont.languageScreening),
            textField(context, childHistoryCont.medicationsList,"Medications List", "Write medications", "",),
            yesNotWithDonKnowDropDow(context, 'Has your child had a Hearing screening', childHistoryCont.HearingScreening),
            yesNotWithDonKnowDropDow(context, 'Has your child had a Vision screening', childHistoryCont.VisionScreening),
            yesNotWithDonKnowDropDow(context, 'Did/does your child have Recurrent ear infections?', childHistoryCont.RecurrentEarInfections),
            yesNotWithDonKnowDropDow(context, 'Did/does your child have tubes in his/her ears?', childHistoryCont.tubesEars),

          ],
        )
      ],
    ),
  );
}
Widget developmentMilestones(context){
 ChildHistoryController childHistoryCont = Get.put(ChildHistoryController());
  return Container(
    child: Column(
      children: [
        Wrap(
          children: [

            yesNotDropDow(context, 'Is your child currently seeing any medical specialists or therapists (such as a neurologist, occupational therapist, ophthalmologists, physical therapist, speech and language pathologist etc)?', childHistoryCont.medicalSpecialistsTherapists),
            yesNotDropDow(context, 'Does your child experience any of the following difficulties with sleep?', childHistoryCont.followingDifficultiesWithSleep),
            yesNotDropDow(context, 'Does your child have any of the following difficulties with eating?', childHistoryCont.difficultiesWithEating),
            yesNotDropDow(context, 'Does your child have any of the following difficulties with elimination?', childHistoryCont.difficultiesWithElimination),
            yesNotDropDow(context, 'Does your child have problems with vision?', childHistoryCont.problemsWithVision),
            yesNotDropDow(context, 'Does your child have problems with coordination?', childHistoryCont.problemsWithCoordination),
            yesNotDropDow(context, 'Does your child get dressed by themselves?', childHistoryCont.dressedByThemselves),
            yesNotDropDow(context, 'Does your child have a history of speech or language problems?', childHistoryCont.languageProblems),
            yesNotDropDow(context, 'Does your child have any difficulty with speech fluency?', childHistoryCont.difficultySpeechFluency),
            yesNotDropDow(context, 'Does your child have a hard time making friends?', childHistoryCont.timeMakingFriends),
            caregiversObserveDifficulty(context, 'Did preschool teachers, daycare providers or other caregivers observe difficulty with any of the following?', childHistoryCont.caregiversObserveDifficulty),
            useBottle(context, 'Does your child use a bottle?', childHistoryCont.useBottle),
            yesNotDropDow(context, 'Does your child display any unusual repetitive movements or noises (tics)?', childHistoryCont.repetitiveMovements),
            yesNotDropDow(context, 'Does your child avoid any physical activities?', childHistoryCont.avoidPhysicalActivities),
            yesNotDropDow(context, 'Does your child have any problems with expressive language?', childHistoryCont.problemsWithExpressiveLanguage),
            yesNotDropDow(context, 'Do you have any specific concerns about your child’s hearing/listening?', childHistoryCont.concernsListening),
            yesNotDropDow(context, 'Is your child currently enrolled in school?', childHistoryCont.currentlyEnrolledInSchool),
            concernsRelated(context, 'Do you have concerns related to', childHistoryCont.concernsRelated),
            useToCompleteTasks(context, 'What hand does your child use to complete tasks?', childHistoryCont.useToCompleteTasks),
            useToCompleteTasks(context, 'Do you have concerns about your child’s development in any of these areas?', childHistoryCont.developmentInAnyOfTheseAreas),
            yesNotDropDow(context, 'Do you have any current concerns regarding your child’s speech or language?', childHistoryCont.concernsSpeechOrLanguage),
            yesNotDropDow(context, 'Does your child have any problems saying sounds correctly?', childHistoryCont.problemsSayingSoundsCorrectly),
            difficultyUnderstandingVerbal(context, 'Does your child have any difficulty using or understanding non-verbal cues?', childHistoryCont.difficultyUnderstandingVerbal),
            usuallyPlay(context, 'Does your child usually play', childHistoryCont.usuallyPlay),
            yesNotDropDow(context, 'Do you have concerns regarding school performance?', childHistoryCont.regardingSchoolPerformance),



          ],
        )
      ],
    ),
  );
}
Widget feedingHistory(context){
 ChildHistoryController childHistoryCont = Get.put(ChildHistoryController());
  return Container(
    child: Column(
      children: [
        Wrap(
          children: [

            Colostrum(context, 'Colostrum', childHistoryCont.Colostrum),
            yesNotDropDow(context, 'Bottle feeding', childHistoryCont.BottleFeeding),
            yesNotDropDow(context, 'Mixed feeding', childHistoryCont.MixedFeeding),
            yesNotDropDow(context, 'EBF', childHistoryCont.EBF),
            yesNotDropDow(context, 'Complementary feed', childHistoryCont.ComplementaryFeed),

          ],
        )
      ],
    ),
  );
}
Widget temperamentPersonality(context){
 ChildHistoryController childHistoryCont = Get.put(ChildHistoryController());
  return Container(
    child: Column(
      children: [
        Wrap(
          children: [

            yesNotDropDow(context, 'Does your child have frequent temper outbursts (e.g., yelling, hitting or stomping feet)?', childHistoryCont.frequentTemperOutbursts),
            Energy(context, 'Energy', childHistoryCont.Energy),
            Mood(context, 'Mood (general emotional tone)', childHistoryCont.Mood),
            Persistence(context, 'Persistence (ease of stopping when involved in an activity)', childHistoryCont.Persistence),
            Perceptiveness(context, 'Perceptiveness (notices people, noises, objects)', childHistoryCont.Perceptiveness),
            FirstReaction(context, 'First Reaction (to new people, activities, ideas)', childHistoryCont.FirstReaction),
            Sensitivity(context, 'Sensitivity (to noises, emotions, tastes, textures, stress)', childHistoryCont.Sensitivity),
            Adaptability(context, 'Adaptability (copes with transitions, changes in routine)', childHistoryCont.Adaptability),
            Intensity(context, 'Intensity (strength of emotional reactions)', childHistoryCont.Intensity),
            Attention(context, 'Attention Span/Distractibility', childHistoryCont.Attention),
            textField(context, childHistoryCont.AdditionalComment,'Additional Comment', 'Write additional Comment',  ''),

          ],
        )
      ],
    ),
  );
}


Card absentPresentDropDow(context, labelText, valueController) {
  return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Choose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: "",),
                    DropdownMenuItem(child: Text("Absent"),value: "Absent",),
                    DropdownMenuItem(child: Text("Present"),value: "Present",),
                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card durationLabourDropDow(context, labelText, valueController) {
  return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Choose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: "",),
                    DropdownMenuItem(child: Text("Prolonged"),value: "Prolonged",),
                    DropdownMenuItem(child: Text("Short"),value: "Short",),
                    DropdownMenuItem(child: Text("Normal"),value: "Normal",),
                    DropdownMenuItem(child: Text("Induced"),value: "Induced",),
                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}

Card textField(context,textController,Details, hintText,suffixText){
  return Card(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.250,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(Details),
            TextField(
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
          ],
        ),
      ),
    ),
  );
}
Card yesNotDropDow(context, labelText, valueController) {
  return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: "",),
                    DropdownMenuItem(child: Text("Yes"),value: "Yes",),
                    DropdownMenuItem(child: Text("No"),value: "No",),
                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card yesNotWithDonKnowDropDow(context, labelText, valueController) {
  return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: "",),
                    DropdownMenuItem(child: Text("Yes"),value: "Yes",),
                    DropdownMenuItem(child: Text("No"),value: "No",),
                    DropdownMenuItem(child: Text("I don't know"),value: "I don't know",),
                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card caregiversObserveDifficulty(context, labelText, valueController) {
  return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Structured activity"),value: "Structured activity"),
                    DropdownMenuItem(child: Text("Group activity"),value: "Group activity"),
                    DropdownMenuItem(child: Text("Behavior"),value: "Behavior"),
                    DropdownMenuItem(child: Text("Peer Relationships"),value: "Peer Relationships"),
                    DropdownMenuItem(child: Text("Transitions"),value: "Transitions"),
                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card useBottle(context, labelText, valueController) {
  return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: ""),
                    DropdownMenuItem(child: Text("Pacifier"),value: "Pacifier"),
                    DropdownMenuItem(child: Text("Suck thumb"),value: "Suck thumb"),
                    DropdownMenuItem(child: Text("Use a bottle"),value: "Use a bottle"),
                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card concernsRelated(context, labelText, valueController) {
  return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: ""),
                    DropdownMenuItem(child: Text("Off task behavior"),value: "Off task behavior"),
                    DropdownMenuItem(child: Text("Attention"),value: "Attention"),
                    DropdownMenuItem(child: Text("Concentration"),value: "Concentration"),
                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card useToCompleteTasks(context, labelText, valueController) {
  return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: ""),
                    DropdownMenuItem(child: Text("Left"),value: "Left"),
                    DropdownMenuItem(child: Text("Right"),value: "Right"),
                    DropdownMenuItem(child: Text("Both"),value: "Both"),
                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card developmentInAnyOfTheseAreas(context, labelText, valueController) {
  return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: ""),
                    DropdownMenuItem(child: Text("Left"),value: "Left"),
                    DropdownMenuItem(child: Text("Right"),value: "Right"),
                    DropdownMenuItem(child: Text("Both"),value: "Both"),
                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card difficultyUnderstandingVerbal(context, labelText, valueController) {
  return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: ""),
                    DropdownMenuItem(child: Text("Body language"),value: "Body language"),
                    DropdownMenuItem(child: Text("Facial Expressions"),value: "Facial Expressions"),
                    DropdownMenuItem(child: Text("Tone of Voice"),value: "Tone of Voice"),
                    DropdownMenuItem(child: Text("Rate of Speech"),value: "Rate of Speech"),
                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card usuallyPlay(context, labelText, valueController) {
  return Card(
      child: Container(
        //width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: ""),
                    DropdownMenuItem(child: Text("Alone "),value: "Alone "),
                    DropdownMenuItem(child: Text("W/Siblings"),value: "W/Siblings"),
                    DropdownMenuItem(child: Text("W/Peers"),value: "W/Peers"),
                    DropdownMenuItem(child: Text("W/Younger Children"),value: "W/Younger Children"),
                    DropdownMenuItem(child: Text("W/Adults"),value: "W/Adults"),
                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card Colostrum(context, labelText, valueController) {
  return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: ""),
                    DropdownMenuItem(child: Text("Taken "),value: "Taken "),
                    DropdownMenuItem(child: Text("No Taken"),value: "No Taken"),

                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card Energy(context, labelText, valueController) {
  return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: ""),
                    DropdownMenuItem(child: Text("Sedentary "),value: "Sedentary "),
                    DropdownMenuItem(child: Text("Active"),value: "Active"),
                    DropdownMenuItem(child: Text("Very Active"),value: "Very Active"),

                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}

Card Mood(context, labelText, valueController) {
  return Card(
      child: Container(
        //width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: ""),
                    DropdownMenuItem(child: Text("Difficulty Sittings at table "),value: "Difficulty Sittings at table "),
                    DropdownMenuItem(child: Text("Over eats"),value: "Over eats"),
                    DropdownMenuItem(child: Text("Avoids food due to texture"),value: "Avoids food due to texture"),
                    DropdownMenuItem(child: Text("Poor food choices"),value: "Poor food choices"),
                    DropdownMenuItem(child: Text("Pick Eater"),value: "Pick Eater"),
                    DropdownMenuItem(child: Text("Odd eating behavior/habit"),value: "Odd eating behavior/habit"),
                    DropdownMenuItem(child: Text("Restricted diets"),value: "Restricted diets"),
                    DropdownMenuItem(child: Text("Other"),value: "Other"),

                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card Persistence(context, labelText, valueController) {
  return Card(
      child: Container(
        //width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: ""),
                    DropdownMenuItem(child: Text("Hard"),value: "Hard"),
                    DropdownMenuItem(child: Text("Easily Redirect"),value: "Easily Redirect"),
                    DropdownMenuItem(child: Text("Hard to focus on an activity"),value: "Hard to focus on an activity"),


                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card Perceptiveness(context, labelText, valueController) {
  return Card(
      child: Container(
        //width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: ""),
                    DropdownMenuItem(child: Text("Hardly ever notices"),value: "Hardly ever notices"),
                    DropdownMenuItem(child: Text("Turns to looks/notices"),value: "Turns to looks/notices"),
                    DropdownMenuItem(child: Text("Overly perceptive"),value: "Overly perceptive"),


                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card FirstReaction(context, labelText, valueController) {
  return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: ""),
                    DropdownMenuItem(child: Text("Avoidant"),value: "Avoidant"),
                    DropdownMenuItem(child: Text("Shy"),value: "Shy"),
                    DropdownMenuItem(child: Text("Outgoing"),value: "Outgoing"),




                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card Sensitivity(context, labelText, valueController) {
  return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: ""),
                    DropdownMenuItem(child: Text("Not Sensitive"),value: "Not Sensitive"),
                    DropdownMenuItem(child: Text("Mild"),value: "Mild"),
                    DropdownMenuItem(child: Text("Very Sensitive"),value: "Very Sensitive"),





                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card Adaptability(context, labelText, valueController) {
  return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: ""),
                    DropdownMenuItem(child: Text("Slow"),value: "Slow"),
                    DropdownMenuItem(child: Text("Flexible"),value: "Flexible"),
                    DropdownMenuItem(child: Text("Quickly"),value: "Quickly"),





                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card Intensity(context, labelText, valueController) {
  return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: ""),
                    DropdownMenuItem(child: Text("Withdraw"),value: "Withdraw"),
                    DropdownMenuItem(child: Text("Toilet refusal"),value: "Toilet refusal"),
                    DropdownMenuItem(child: Text("Strong Reactions"),value: "Strong Reactions"),

                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}
Card Attention(context, labelText, valueController) {
  return Card(
      child: Container(
        //width: MediaQuery.of(context).size.width * 0.280,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Chose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Chose any one"),value: ""),
                    DropdownMenuItem(child: Text("Easily distracted"),value: "Easily distracted"),
                    DropdownMenuItem(child: Text("Sometimes distracted"),value: "Sometimes distracted"),
                    DropdownMenuItem(child: Text("Stays focused"),value: "Stays focused"),
                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
        ),
      ),
    );
}


Card currentHealth(context, labelText, valueController) {
  return Card(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.250,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(labelText),
              Card(
                child: DropdownButton(
                  underline: Container(),
                  hint: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(valueController.value.isEmpty ? "Choose any one" : valueController.value),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("Excellent"),value: "Excellent",),
                    DropdownMenuItem(child: Text("Good"),value: "Good",),
                    DropdownMenuItem(child: Text("Fair"),value: "Fair",),
                    DropdownMenuItem(child: Text("Poor"),value: "Poor",),
                    DropdownMenuItem(child: Text("I don't Know"),value: "I don't Know",),
                  ],
                  onChanged: (value){
                    valueController.value = value;
                  },
                ),
              )
            ],
          ),)
      ),
    ),
  );
}



selectedChildHistory(context, [isFollowUp = false]) {
  ChildHistoryController childHistoryController = Get.put(ChildHistoryController());
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
                    child: Text("Child History", style: const TextStyle(  color: Colors.black, fontWeight: FontWeight.bold),),
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

                        childHistoryController.selectedChildHistory.addAll(childHistoryController.childHistoryData);

                      childHistoryNewDialog(context);
                    }, icon: Icon(Icons.add_box, size: Platform.isAndroid ? 30 : 25, color: Colors.black,),),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // color: Colors.black
                    ),
                    child: IconButton(onPressed: () async {
                      // historyDialog(context);
                      childHistoryDialog(context);
                    }, icon: Icon(Icons.add_box, size: Platform.isAndroid ? 30 : 25, color: Colors.black,),),
                  ),
                ],
              ),
            ),
            if(childHistoryController.isDataExist.value)
              Column(
                children: [
                  Card(
                    elevation: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:   Text("Birth History", style: TextStyle(fontWeight: FontWeight.w500),
                        ),),
                      IconButton(onPressed: (){
                         childHistoryController.isBirthHistoryOpen.value = !childHistoryController.isBirthHistoryOpen.value;
                      }, icon: Icon(childHistoryController.isBirthHistoryOpen.value ? Icons.arrow_drop_up : Icons.arrow_drop_down)),
                    ],
                ),
                ),
                if(childHistoryController.isBirthHistoryOpen.value)
                  Column(
                    children: [

                      if(childHistoryController.rhesusIncompatibility.value.isNotEmpty)
                        singlePara(childHistoryController.rhesusIncompatibility.value, "Rhesus incompatibility"),

                      if(childHistoryController.mothersAgeDuringBirth.text.isNotEmpty)
                        singlePara(childHistoryController.mothersAgeDuringBirth.text + 'Years', "Mother’s age during birth"),

                      if(childHistoryController.DurationOfLabour.value.isNotEmpty)
                        singlePara(childHistoryController.DurationOfLabour.value, "Duration of labour"),

                      if(childHistoryController.BirthTrauma.value.isNotEmpty)
                        singlePara(childHistoryController.BirthTrauma.value, "Birth Trauma"),

                      if(childHistoryController.Miscarriages.value.isNotEmpty)
                        singlePara(childHistoryController.Miscarriages.value, "Miscarriages"),

                      if(childHistoryController.Presentation.value.isNotEmpty)
                        singlePara(childHistoryController.Presentation.value, "Presentation"),

                      if(childHistoryController.DelayedCrying.value.isNotEmpty)
                        singlePara(childHistoryController.DelayedCrying.value, "Delayed crying"),

                      if(childHistoryController.FebrileIllness.value.isNotEmpty)
                        singlePara(childHistoryController.FebrileIllness.value, "Febrile illness"),

                      if(childHistoryController.Jaundice.value.isNotEmpty)
                        singlePara(childHistoryController.Jaundice.value, "Jaundice"),

                      if(childHistoryController.Hypoglycemia.value.isNotEmpty)
                        singlePara(childHistoryController.Hypoglycemia.value, "Hypoglycemia"),

                      if(childHistoryController.ConsanguinityOfMarriage.value.isNotEmpty)
                        singlePara(childHistoryController.ConsanguinityOfMarriage.value , "Consanguinity of marriage"),

                      if(childHistoryController.HaemolyticDisease.value.isNotEmpty)
                        singlePara(childHistoryController.HaemolyticDisease.value, "Haemolytic disease"),

                      if(childHistoryController.Gestation.text.isNotEmpty)
                        singlePara(childHistoryController.Gestation.text + 'Weeks', "Gestation"),


                      if(childHistoryController.TypeOfDelivery.value.isNotEmpty)
                        singlePara(childHistoryController.TypeOfDelivery.value, "Type of delivery"),

                      if(childHistoryController.ComplicationsDuringPregnancy.value.isNotEmpty)
                        singlePara(childHistoryController.ComplicationsDuringPregnancy.value , "Complications during pregnancy"),

                      if(childHistoryController.Resuscitation.value.isNotEmpty)
                        singlePara(childHistoryController.Resuscitation.value, "Resuscitation"),

                      if(childHistoryController.FetalDistress.value.isNotEmpty)
                        singlePara(childHistoryController.FetalDistress.value, "Fetal distress"),

                      if(childHistoryController.BirthWeight.text.isNotEmpty)
                        singlePara(childHistoryController.BirthWeight.text + 'Kg', "Birth weight"),

                      if(childHistoryController.Convulsion.value.isNotEmpty)
                        singlePara(childHistoryController.Convulsion.value, "Convulsion/Seizure"),

                      if(childHistoryController.BleedingDisorders.value.isNotEmpty)
                        singlePara(childHistoryController.BleedingDisorders.value, "Bleeding disorders"),

                      if(childHistoryController.RespiratoryDistress.value.isNotEmpty)
                        singlePara(childHistoryController.RespiratoryDistress.value, "Respiratory distress"),
                    ],
                  ),

                  Card(
                    elevation: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:   Text("Health History", style: TextStyle(fontWeight: FontWeight.w500),
                          ),),
                        IconButton(onPressed: (){
                          childHistoryController.isHealthHistoryOpen.value = !childHistoryController.isHealthHistoryOpen.value;
                        }, icon: Icon(childHistoryController.isHealthHistoryOpen.value ? Icons.arrow_drop_up : Icons.arrow_drop_down)),
                      ],
                    ),
                  ),
                  if(childHistoryController.isHealthHistoryOpen.value)
                  Column(
                    children: [
                      if(childHistoryController.currentHealth.value.isNotEmpty)
                        singlePara(childHistoryController.currentHealth.value, "What is the current health status of your child?"),

                      if(childHistoryController.specificMedicalConcerns.value.isNotEmpty)
                        singlePara(childHistoryController.specificMedicalConcerns.value, "Do you have any specific medical concerns about your child?"),

                      if(childHistoryController.childAllergic.value.isNotEmpty)
                        singlePara(childHistoryController.childAllergic.value, "Is your child allergic to any medications?"),

                      if(childHistoryController.immunizationsUpToDate.value.isNotEmpty)
                        singlePara(childHistoryController.immunizationsUpToDate.value, "Are your child’s immunizations up to date?"),

                      if(childHistoryController.languageScreening.value.isNotEmpty)
                        singlePara(childHistoryController.languageScreening.value, "Has your child had a Speech/language screening?"),

                      if(childHistoryController.medicationsList.text.isNotEmpty)
                        singlePara(childHistoryController.medicationsList.text, "Medications List", ),

                      if(childHistoryController.HearingScreening.value.isNotEmpty)
                        singlePara(childHistoryController.HearingScreening.value, "Has your child had a Hearing screening illness"),

                      if(childHistoryController.VisionScreening.value.isNotEmpty)
                        singlePara(childHistoryController.VisionScreening.value, "Has your child had a Vision screening"),

                      if(childHistoryController.RecurrentEarInfections.value.isNotEmpty)
                        singlePara(childHistoryController.RecurrentEarInfections.value, "Did/does your child have Recurrent ear infections?"),

                      if(childHistoryController.tubesEars.value.isNotEmpty)
                        singlePara(childHistoryController.tubesEars.value , "Did/does your child have tubes in his/her ears?"),

                    ],
                  ),

                  Card(
                    elevation: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:   Text("Developmental Milestones", style: TextStyle(fontWeight: FontWeight.w500),
                          ),),
                        IconButton(onPressed: (){
                          childHistoryController.isDevelopmentalMilestonesOpen.value = !childHistoryController.isDevelopmentalMilestonesOpen.value;
                        }, icon: Icon(childHistoryController.isDevelopmentalMilestonesOpen.value ? Icons.arrow_drop_up : Icons.arrow_drop_down)),
                      ],
                    ),
                  ),
                  if(childHistoryController.isDevelopmentalMilestonesOpen.value)
                  Column(
                    children: [
                      if(childHistoryController.medicalSpecialistsTherapists.value.isNotEmpty)
                        singlePara(childHistoryController.medicalSpecialistsTherapists.value, 'Is your child currently seeing any medical specialists or therapists (such as a neurologist, occupational therapist, ophthalmologists, physical therapist, speech and language pathologist etc)?'),
                      if(childHistoryController.followingDifficultiesWithSleep.value.isNotEmpty)
                        singlePara(childHistoryController.followingDifficultiesWithSleep.value, 'Does your child experience any of the following difficulties with sleep?'),
                      if(childHistoryController.difficultiesWithEating.value.isNotEmpty)
                        singlePara(childHistoryController.difficultiesWithEating.value, 'Does your child have any of the following difficulties with eating?'),
                      if(childHistoryController.difficultiesWithElimination.value.isNotEmpty)
                        singlePara(childHistoryController.difficultiesWithElimination.value, 'Does your child have any of the following difficulties with elimination?'),
                      if(childHistoryController.problemsWithVision.value.isNotEmpty)
                        singlePara(childHistoryController.problemsWithVision.value, 'Does your child have problems with vision?'),
                      if(childHistoryController.problemsWithCoordination.value.isNotEmpty)
                        singlePara(childHistoryController.problemsWithCoordination.value, 'Does your child have problems with coordination?'),
                      if(childHistoryController.dressedByThemselves.value.isNotEmpty)
                        singlePara(childHistoryController.dressedByThemselves.value, 'Does your child get dressed by themselves?'),
                      if(childHistoryController.languageProblems.value.isNotEmpty)
                        singlePara(childHistoryController.languageProblems.value, 'Does your child have a history of speech or language problems?'),
                      if(childHistoryController.difficultySpeechFluency.value.isNotEmpty)
                        singlePara(childHistoryController.difficultySpeechFluency.value, 'Does your child have any difficulty with speech fluency?'),
                      if(childHistoryController.timeMakingFriends.value.isNotEmpty)
                        singlePara(childHistoryController.timeMakingFriends.value, 'Does your child have a hard time making friends?'),
                      if(childHistoryController.caregiversObserveDifficulty.value.isNotEmpty)
                        singlePara(childHistoryController.caregiversObserveDifficulty.value, 'Did preschool teachers, daycare providers or other caregivers observe difficulty with any of the following?'),
                      if(childHistoryController.useBottle.value.isNotEmpty)
                        singlePara(childHistoryController.useBottle.value, 'Does your child use a bottle?'),
                      if(childHistoryController.repetitiveMovements.value.isNotEmpty)
                        singlePara(childHistoryController.repetitiveMovements.value, 'Does your child display any unusual repetitive movements or noises (tics)?'),
                      if(childHistoryController.avoidPhysicalActivities.value.isNotEmpty)
                        singlePara(childHistoryController.avoidPhysicalActivities.value, 'Does your child avoid any physical activities?'),
                      if(childHistoryController.problemsWithExpressiveLanguage.value.isNotEmpty)
                        singlePara(childHistoryController.problemsWithExpressiveLanguage.value, 'Does your child have any problems with expressive language?'),
                      if(childHistoryController.concernsListening.value.isNotEmpty)
                        singlePara(childHistoryController.concernsListening.value, 'Do you have any specific concerns about your child’s hearing/listening?'),
                      if(childHistoryController.currentlyEnrolledInSchool.value.isNotEmpty)
                        singlePara(childHistoryController.currentlyEnrolledInSchool.value, 'Is your child currently enrolled in school?'),
                      if(childHistoryController.concernsRelated.value.isNotEmpty)
                        singlePara(childHistoryController.concernsRelated.value, 'Do you have concerns related to'),
                      if(childHistoryController.useToCompleteTasks.value.isNotEmpty)
                        singlePara(childHistoryController.useToCompleteTasks.value, 'What hand does your child use to complete tasks?'),
                      if(childHistoryController.developmentInAnyOfTheseAreas.value.isNotEmpty)
                        singlePara(childHistoryController.developmentInAnyOfTheseAreas.value, 'Do you have concerns about your child’s development in any of these areas?'),
                      if(childHistoryController.concernsSpeechOrLanguage.value.isNotEmpty)
                        singlePara(childHistoryController.concernsSpeechOrLanguage.value, 'Do you have any current concerns regarding your child’s speech or language?'),
                      if(childHistoryController.problemsSayingSoundsCorrectly.value.isNotEmpty)
                        singlePara(childHistoryController.problemsSayingSoundsCorrectly.value, 'Does your child have any problems saying sounds correctly?'),
                      if(childHistoryController.difficultyUnderstandingVerbal.value.isNotEmpty)
                        singlePara(childHistoryController.difficultyUnderstandingVerbal.value, 'Does your child have any difficulty using or understanding non-verbal cues?'),
                      if(childHistoryController.usuallyPlay.value.isNotEmpty)
                        singlePara(childHistoryController.usuallyPlay.value, 'Does your child usually play'),
                      if(childHistoryController.regardingSchoolPerformance.value.isNotEmpty)
                        singlePara(childHistoryController.regardingSchoolPerformance.value, 'Do you have concerns regarding school performance?'),

                    ],
                  ),

                  Card(
                    elevation: 0,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Feeding History", style: TextStyle(fontWeight: FontWeight.w500),),
                            ),
                            IconButton(onPressed: (){
                              childHistoryController.isFeedingHistoryOpen.value = !childHistoryController.isFeedingHistoryOpen.value;
                            }, icon: Icon(childHistoryController.isFeedingHistoryOpen.value ? Icons.arrow_drop_up : Icons.arrow_drop_down)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if(childHistoryController.isFeedingHistoryOpen.value)
                  Column(
                    children: [
                      if(childHistoryController.Colostrum.value.isNotEmpty)
                        singlePara(childHistoryController.Colostrum.value, 'Colostrum'),

                      if(childHistoryController.BottleFeeding.value.isNotEmpty)
                        singlePara(childHistoryController.BottleFeeding.value, 'Bottle feeding'),
                      if(childHistoryController.MixedFeeding.value.isNotEmpty)
                        singlePara(childHistoryController.MixedFeeding.value, 'Mixed feeding'),
                      if(childHistoryController.EBF.value.isNotEmpty)
                        singlePara(childHistoryController.EBF.value, 'EBF'),
                      if(childHistoryController.ComplementaryFeed.value.isNotEmpty)
                        singlePara(childHistoryController.ComplementaryFeed.value, 'Complementary feed'),

                    ],
                  ),

                  Card(
                    elevation: 0,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Tempermental And Personal", style: TextStyle(fontWeight: FontWeight.w500),),
                            ),
                            IconButton(onPressed: (){
                              childHistoryController.isTempermentalAndPersonal.value = !childHistoryController.isTempermentalAndPersonal.value;
                            }, icon: Icon(childHistoryController.isTempermentalAndPersonal.value ? Icons.arrow_drop_up : Icons.arrow_drop_down)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if(childHistoryController.isTempermentalAndPersonal.value)
                  Column(
                    children: [
                      if(childHistoryController.frequentTemperOutbursts.value.isNotEmpty)
                        singlePara(childHistoryController.frequentTemperOutbursts.value, 'Does your child have frequent temper outbursts (e.g., yelling, hitting or stomping feet)?'),

                      if(childHistoryController.Energy.value.isNotEmpty)
                        singlePara(childHistoryController.Energy.value, 'Energy'),

                      if(childHistoryController.Mood.value.isNotEmpty)
                        singlePara(childHistoryController.Mood.value, 'Mood (general emotional tone)'),

                      if(childHistoryController.Persistence.value.isNotEmpty)
                        singlePara(childHistoryController.Persistence.value, 'Persistence (ease of stopping when involved in an activity)'),

                      if(childHistoryController.Perceptiveness.value.isNotEmpty)
                        singlePara(childHistoryController.Perceptiveness.value, 'Perceptiveness (notices people, noises, objects)'),

                      if(childHistoryController.FirstReaction.value.isNotEmpty)
                        singlePara(childHistoryController.FirstReaction.value, 'First Reaction (to new people, activities, ideas)'),

                      if(childHistoryController.Sensitivity.value.isNotEmpty)
                        singlePara(childHistoryController.Sensitivity.value, 'Sensitivity (to noises, emotions, tastes, textures, stress)'),

                      if(childHistoryController.Adaptability.value.isNotEmpty)
                        singlePara(childHistoryController.Adaptability.value, 'Adaptability (copes with transitions, changes in routine)'),

                      if(childHistoryController.Intensity.value.isNotEmpty)
                        singlePara(childHistoryController.Intensity.value, 'Intensity (strength of emotional reactions)'),

                      if(childHistoryController.Attention.value.isNotEmpty)
                        singlePara(childHistoryController.Attention.value, 'Attention Span/Distractibility'),

                      if(childHistoryController.AdditionalComment.text.isNotEmpty)
                        singlePara(childHistoryController.AdditionalComment.text, 'Additional Comment',),

                    ],
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text("$hintText : ", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),),
            ),
            Expanded(
              // child: Text("${controllerText}")
              child: TextFormField(
                maxLines: 1,
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