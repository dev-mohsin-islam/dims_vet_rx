

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hive/hive.dart';

import '../../database/hive_get_boxes.dart';

class ChildHistoryController extends GetxController{
  final Box boxChildHistory = Boxes.getChildHistory();
  RxBool isDataExist = false.obs;
  RxInt screenIndex = 0.obs;

  // var jsonHistory = {
  //   'patient_id': patientID,
  //   "mothersAgeDuringBirth": mothersAgeDuringBirth.text,
  //   "motherBloodGroup": motherBloodGroup.value,
  //   "rhesusIncompatibility": rhesusIncompatibility.value,
  //   "DurationOfLabour": DurationOfLabour.value,
  //   "BirthTrauma": BirthTrauma.value,
  //   "Miscarriages": Miscarriages.value,
  //   "Presentation": Presentation.value,
  //   "DelayedCrying": DelayedCrying.value,
  //   "FebrileIllness": FebrileIllness.value,
  //   "Jaundice": Jaundice.value,
  //   "Hypoglycemia": Hypoglycemia.value,
  //   "ConsanguinityOfMarriage": ConsanguinityOfMarriage.value,
  //   "HaemolyticDisease": HaemolyticDisease.value,
  //   "Gestation": Gestation.text,
  //   "TypeOfDelivery": TypeOfDelivery.value,
  //   "ComplicationsDuringPregnancy": ComplicationsDuringPregnancy.value,
  //   "Resuscitation": Resuscitation.value,
  //   "FetalDistress": FetalDistress.value,
  //   "BirthWeight": BirthWeight.text,
  //   "Convulsion": Convulsion.value,
  //   "BleedingDisorders": BleedingDisorders.value,
  //   "Septicemia": Septicemia.value,
  //   "RespiratoryDistress": RespiratoryDistress.value,
  //
  //   "currentHealth": currentHealth.value,
  //   "specificMedicalConcerns": specificMedicalConcerns.value,
  //   "childAllergic": childAllergic.value,
  //   "immunizationsUpToDate": immunizationsUpToDate.value,
  //   "languageScreening": languageScreening.value,
  //   "medicationsList": medicationsList.text,
  //   "HearingScreening": HearingScreening.value,
  //   "VisionScreening": VisionScreening.value,
  //   "RecurrentEarInfections": RecurrentEarInfections.value,
  //   "tubesEars": tubesEars.value,
  //   //
  //   "RolledOver": RolledOver.text,
  //   "RolledOverType": RolledOverType.value,
  //   "Walked": Walked.text,
  //   "WalkedType": WalkedType.value,
  //   "Weaned": Weaned.text,
  //   "WeanedType": WeanedType.value,
  //   "ToiletTrained": ToiletTrained.text,
  //   "ToiletTrainedType": ToiletTrainedType.value,
  //   "Completed": Completed.text,
  //   "CompletedType": CompletedType.value,
  //   "SatUp": SatUp.text,
  //   "SatUpType": SatUpType.value,
  //   "SpokeFirstWord": SpokeFirstWord.text,
  //   "SpokeFirstWordType": SpokeFirstWordType.value,
  //   "FedSelf": FedSelf.text,
  //   "FedSelfType": FedSelfType.value,
  //   "WasYourInfant": WasYourInfant.value,
  //   "Crawled": Crawled.text,
  //   "CrawledType": CrawledType.value,
  //   "Talked": Talked.text,
  //   "TalkedType": TalkedType.value,
  //   "DrankFrom": DrankFrom.text,
  //   "DrankFromType": DrankFromType.value,
  //   "medicalSpecialistsTherapists": medicalSpecialistsTherapists.value,
  //   "followingDifficultiesWithSleep": followingDifficultiesWithSleep.value,
  //   "difficultiesWithEating": difficultiesWithEating.value,
  //   "difficultiesWithElimination": difficultiesWithElimination.value,
  //   "problemsWithVision": problemsWithVision.value,
  //   "problemsWithCoordination": problemsWithCoordination.value,
  //   "dressedByThemselves": dressedByThemselves.value,
  //   "languageProblems": languageProblems.value,
  //   "difficultySpeechFluency": difficultySpeechFluency.value,
  //   "timeMakingFriends": timeMakingFriends.value,
  //   "caregiversObserveDifficulty": caregiversObserveDifficulty.value,
  //   "useBottle": useBottle.value,
  //   "repetitiveMovements": repetitiveMovements.value,
  //   "avoidPhysicalActivities": avoidPhysicalActivities.value,
  //   "problemsWithExpressiveLanguage": problemsWithExpressiveLanguage.value,
  //   "concernsListening": concernsListening.value,
  //   "currentlyEnrolledInSchool": currentlyEnrolledInSchool.value,
  //   "concernsRelated": concernsRelated.value,
  //   "useToCompleteTasks": useToCompleteTasks.value,
  //   "developmentInAnyOfTheseAreas": developmentInAnyOfTheseAreas.value,
  //   "concernsSpeechOrLanguage": concernsSpeechOrLanguage.value,
  //   "problemsSayingSoundsCorrectly": problemsSayingSoundsCorrectly.value,
  //   "difficultyUnderstandingVerbal": difficultyUnderstandingVerbal.value,
  //   "usuallyPlay": usuallyPlay.value,
  //   "regardingSchoolPerformance": regardingSchoolPerformance.value,
  //   "Colostrum": Colostrum.value,
  //   "BottleFeeding": BottleFeeding.value,
  //   "MixedFeeding": MixedFeeding.value,
  //   "EBF": EBF.value,
  //   "ComplementaryFeed": ComplementaryFeed.value,
  //   "frequentTemperOutbursts": frequentTemperOutbursts.value,
  //   "Energy": Energy.value,
  //   "Mood": Mood.value,
  //   "Persistence": Persistence.value,
  //   "Perceptiveness": Perceptiveness.value,
  //   "FirstReaction": FirstReaction.value,
  //   "Sensitivity": Sensitivity.value,
  //   "Adaptability": Adaptability.value,
  //   "Intensity": Intensity.value,
  //   "Attention": Attention.value,
  //   "AdditionalComment": AdditionalComment.text,
  // };
  static const yesNoString = ["Yes", "No", "I don't know"];
  static const List absPresString = ["Present", "Absent"];
  static const List durationOfLabour = ["Prolonged", "Short", "Normal", "Long", "Induced"];
  static const List typeOfDelivery = ["Normal", "Assisted", "C/S"];
  static const List birthOrder = ["1st", "2nd", "3rd", "4th", "Other"];

  static const tRa = "radio";
  static const tInput = "textInput";
  RxList selectedChildHistory = [].obs;
  RxList childHistoryData = [
    {
      "key": "BirthHistory",
      "title": "Birth History",
      "data": [
        {
          "type": tRa,
          "title": "Rhesus incomplatibility",
          "description": "Rhesus incomplatibility",
          "value": "",
          "field": absPresString,
        },{
          "type": tRa,
          "title": "Birth Order",
          "description": "Birth Order",
          "value": "",
          "field": birthOrder,
        },
        {
          "type": tRa,
          "title": "Duration of Labour",
          "description": "Duration of Labour",
          "value": "",
          "field": durationOfLabour,
        },
        {
          "type": tRa,
          "title": "Birth Trauma",
          "description": "Birth Trauma",
          "value": "",
          "field": absPresString,
        },
        {
          "type": tRa,
          "title": "Miscarriages",
          "description": "Miscarriages",
          "value": "",
          "field": absPresString,
        },
        {
          "type": tRa,
          "title": "Presentation",
          "description": "Presentation",
          "value": "",
          "field": absPresString,
        },
        {
          "type": tRa,
          "title": "Delayed Crying",
          "description": "Delayed Crying",
          "value": "",
          "field": yesNoString,
        },
        {
          "type": tRa,
          "title": "Febrile Illness",
          "description": "Febrile Illness",
          "value": "",
          "field": absPresString,
        },
        {
          "type": tRa,
          "title": "Febrile Illness",
          "description": "Febrile Illness",
          "value": "",
          "field": absPresString,
        },
        {
          "type": tRa,
          "title": "Jaundice",
          "description": "Jaundice",
          "value": "",
          "field": absPresString,
        },
        {
          "type": tRa,
          "title": "Hypoglycemia",
          "description": "Hypoglycemia",
          "value": "",
          "field": absPresString,
        }, {
          "type": tRa,
          "title": "Consanguinity of marriage",
          "description": "Consanguinity of marriage",
          "value": "",
          "field": yesNoString,
        },{
          "type": tRa,
          "title": "Haematologic disease",
          "description": "Haematologic disease",
          "value": "",
          "field": yesNoString,
        },{
          "type": tRa,
          "title": "Type of delivery",
          "description": "Type of delivery",
          "value": "",
          "field": typeOfDelivery,
        },{
          "type": tRa,
          "title": "Complications during pregnancy",
          "description": "Complications during pregnancy",
          "value": "",
          "field": yesNoString,
        },
        {
          "type": tRa,
          "title": "Resuscitation",
          "description": "Resuscitation",
          "value": "",
          "field": yesNoString,
        },{
          "type": tRa,
          "title": "Fetal Distress",
          "description": "Fetal Distress",
          "value": "",
          "field": absPresString,
        },{
          "type": tRa,
          "title": "Convulsion/Seizure",
          "description": "Convulsion",
          "value": "",
          "field": absPresString,
        },{
          "type": tRa,
          "title": "Bleeding Disorders",
          "description": "Bleeding Disorders",
          "value": "",
          "field": absPresString,
        },{
          "type": tRa,
          "title": "Septicemia",
          "description": "Septicemia",
          "value": "",
          "field": absPresString,
        },{
          "type": tRa,
          "title": "Respiratory Distress",
          "description": "Respiratory Distress",
          "value": "",
          "field": absPresString,
        },
        {
          "type": tInput,
          "title": "Mother age during birth",
          "description": "",
          "selectedDurationType": "Year",
          "value": "",
          "field": ["Year"],
        },
        {
          "type": tInput,
          "title": "Birth Weight",
          "selectedDurationType": "Kg",
          "value": "",
          "field": ["Kg"],
        },
        {
          "type": tInput,
          "title": "Gestational Age",
          "description": "",
          "selectedDurationType": "",
          "value": "",
          "field": ["Day", "Week"],
        },

      ],
    },

  ].obs;


  RxBool isBirthHistoryOpen = false.obs;
  RxBool isHealthHistoryOpen = false.obs;
  RxBool isDevelopmentalMilestonesOpen = false.obs;
  RxBool isFeedingHistoryOpen = false.obs;
  RxBool isTempermentalAndPersonal = false.obs;

  TextEditingController mothersAgeDuringBirth = TextEditingController();

  ///birth history
  RxString motherBloodGroup = "".obs;
  RxString rhesusIncompatibility = "".obs;
  RxString DurationOfLabour = "".obs;
  RxString BirthTrauma = "".obs;
  RxString Miscarriages = "".obs;
  RxString Presentation = "".obs;
  RxString DelayedCrying = "".obs;
  RxString FebrileIllness = "".obs;
  RxString Jaundice = "".obs;
  RxString Hypoglycemia = "".obs;
  RxString ConsanguinityOfMarriage = "".obs;
  RxString HaemolyticDisease = "".obs;
  TextEditingController Gestation = TextEditingController();
  RxString TypeOfDelivery = "".obs;
  RxString ComplicationsDuringPregnancy = "".obs;
  RxString Resuscitation = "".obs;
  RxString FetalDistress = "".obs;
  TextEditingController BirthWeight = TextEditingController();
  RxString Convulsion = "".obs;
  RxString BleedingDisorders = "".obs;
  RxString Septicemia = "".obs;
  RxString RespiratoryDistress = "".obs;

  ///Health history
  RxString currentHealth  = "".obs;
  RxString specificMedicalConcerns  = "".obs;
  RxString childAllergic  = "".obs;
  RxString immunizationsUpToDate = "".obs;
  RxString languageScreening = "".obs;
  TextEditingController medicationsList = TextEditingController();
  RxString HearingScreening = "".obs;
  RxString VisionScreening = "".obs;
  RxString RecurrentEarInfections = "".obs;
  RxString tubesEars = "".obs;

  ///star developmental milestones
 TextEditingController RolledOver = TextEditingController();
 RxString RolledOverType = "Months".obs;

 TextEditingController Walked = TextEditingController();
 RxString WalkedType = "Months".obs;

 TextEditingController Weaned  = TextEditingController();
 RxString WeanedType = "Months".obs;

 TextEditingController ToiletTrained  = TextEditingController();
 RxString ToiletTrainedType = "Months".obs;

 TextEditingController Completed  = TextEditingController();
 RxString CompletedType = "Months".obs;

 TextEditingController SatUp= TextEditingController();
 RxString SatUpType = "Months".obs;

 TextEditingController SpokeFirstWord= TextEditingController();
 RxString SpokeFirstWordType = "Months".obs;

 TextEditingController FedSelf = TextEditingController();
 RxString FedSelfType = "Months".obs;

 RxString WasYourInfant = "".obs;

 TextEditingController Crawled = TextEditingController();
 RxString CrawledType = "Months".obs;

 TextEditingController Talked  = TextEditingController();
 RxString TalkedType = "Months".obs;

 TextEditingController DrankFrom  = TextEditingController();
 RxString DrankFromType = "Months".obs;

 RxString medicalSpecialistsTherapists = "".obs;
 RxString followingDifficultiesWithSleep = "".obs;
 RxString difficultiesWithEating = "".obs;
 RxString difficultiesWithElimination = "".obs;
 RxString problemsWithVision = "".obs;
 RxString problemsWithCoordination = "".obs;
 RxString dressedByThemselves = "".obs;
 RxString languageProblems = "".obs;
 RxString difficultySpeechFluency = "".obs;
 RxString timeMakingFriends = "".obs;
 RxString caregiversObserveDifficulty = "".obs;
 RxString useBottle = "".obs;
 RxString repetitiveMovements = "".obs;
 RxString avoidPhysicalActivities = "".obs;
 RxString problemsWithExpressiveLanguage = "".obs;
 RxString concernsListening = "".obs;
 RxString currentlyEnrolledInSchool  = "".obs;
 RxString concernsRelated = "".obs;
 RxString useToCompleteTasks = "".obs;
 RxString developmentInAnyOfTheseAreas = "".obs;
 RxString concernsSpeechOrLanguage = "".obs;
 RxString problemsSayingSoundsCorrectly = "".obs;
 RxString difficultyUnderstandingVerbal = "".obs;
 RxString usuallyPlay = "".obs;
 RxString regardingSchoolPerformance = "".obs;

 ///Feeding history
 RxString Colostrum = "".obs;
 RxString BottleFeeding = "".obs;
 RxString MixedFeeding = "".obs;
 RxString EBF = "".obs;
 RxString ComplementaryFeed = "".obs;

 ///Temperament & Personality
RxString frequentTemperOutbursts = "".obs;
RxString Energy = "".obs;
RxString Mood = "".obs;
RxString Persistence = "".obs;
RxString Perceptiveness = "".obs;
RxString FirstReaction = "".obs;
RxString Sensitivity = "".obs;
RxString Adaptability = "".obs;
RxString Intensity = "".obs;
RxString Attention = "".obs;
TextEditingController AdditionalComment  = TextEditingController();

Future<void>saveChildHistory(patientID)async{
  if(isDataExist.value == true){
    var jsonHistory = {
      'patient_id': patientID,
      "mothersAgeDuringBirth": mothersAgeDuringBirth.text,
      "motherBloodGroup": motherBloodGroup.value,
      "rhesusIncompatibility": rhesusIncompatibility.value,
      "DurationOfLabour": DurationOfLabour.value,
      "BirthTrauma": BirthTrauma.value,
      "Miscarriages": Miscarriages.value,
      "Presentation": Presentation.value,
      "DelayedCrying": DelayedCrying.value,
      "FebrileIllness": FebrileIllness.value,
      "Jaundice": Jaundice.value,
      "Hypoglycemia": Hypoglycemia.value,
      "ConsanguinityOfMarriage": ConsanguinityOfMarriage.value,
      "HaemolyticDisease": HaemolyticDisease.value,
      "Gestation": Gestation.text,
      "TypeOfDelivery": TypeOfDelivery.value,
      "ComplicationsDuringPregnancy": ComplicationsDuringPregnancy.value,
      "Resuscitation": Resuscitation.value,
      "FetalDistress": FetalDistress.value,
      "BirthWeight": BirthWeight.text,
      "Convulsion": Convulsion.value,
      "BleedingDisorders": BleedingDisorders.value,
      "Septicemia": Septicemia.value,
      "RespiratoryDistress": RespiratoryDistress.value,

      "currentHealth": currentHealth.value,
      "specificMedicalConcerns": specificMedicalConcerns.value,
      "childAllergic": childAllergic.value,
      "immunizationsUpToDate": immunizationsUpToDate.value,
      "languageScreening": languageScreening.value,
      "medicationsList": medicationsList.text,
      "HearingScreening": HearingScreening.value,
      "VisionScreening": VisionScreening.value,
      "RecurrentEarInfections": RecurrentEarInfections.value,
      "tubesEars": tubesEars.value,
      //
      "RolledOver": RolledOver.text,
      "RolledOverType": RolledOverType.value,
      "Walked": Walked.text,
      "WalkedType": WalkedType.value,
      "Weaned": Weaned.text,
      "WeanedType": WeanedType.value,
      "ToiletTrained": ToiletTrained.text,
      "ToiletTrainedType": ToiletTrainedType.value,
      "Completed": Completed.text,
      "CompletedType": CompletedType.value,
      "SatUp": SatUp.text,
      "SatUpType": SatUpType.value,
      "SpokeFirstWord": SpokeFirstWord.text,
      "SpokeFirstWordType": SpokeFirstWordType.value,
      "FedSelf": FedSelf.text,
      "FedSelfType": FedSelfType.value,
      "WasYourInfant": WasYourInfant.value,
      "Crawled": Crawled.text,
      "CrawledType": CrawledType.value,
      "Talked": Talked.text,
      "TalkedType": TalkedType.value,
      "DrankFrom": DrankFrom.text,
      "DrankFromType": DrankFromType.value,
      "medicalSpecialistsTherapists": medicalSpecialistsTherapists.value,
      "followingDifficultiesWithSleep": followingDifficultiesWithSleep.value,
      "difficultiesWithEating": difficultiesWithEating.value,
      "difficultiesWithElimination": difficultiesWithElimination.value,
      "problemsWithVision": problemsWithVision.value,
      "problemsWithCoordination": problemsWithCoordination.value,
      "dressedByThemselves": dressedByThemselves.value,
      "languageProblems": languageProblems.value,
      "difficultySpeechFluency": difficultySpeechFluency.value,
      "timeMakingFriends": timeMakingFriends.value,
      "caregiversObserveDifficulty": caregiversObserveDifficulty.value,
      "useBottle": useBottle.value,
      "repetitiveMovements": repetitiveMovements.value,
      "avoidPhysicalActivities": avoidPhysicalActivities.value,
      "problemsWithExpressiveLanguage": problemsWithExpressiveLanguage.value,
      "concernsListening": concernsListening.value,
      "currentlyEnrolledInSchool": currentlyEnrolledInSchool.value,
      "concernsRelated": concernsRelated.value,
      "useToCompleteTasks": useToCompleteTasks.value,
      "developmentInAnyOfTheseAreas": developmentInAnyOfTheseAreas.value,
      "concernsSpeechOrLanguage": concernsSpeechOrLanguage.value,
      "problemsSayingSoundsCorrectly": problemsSayingSoundsCorrectly.value,
      "difficultyUnderstandingVerbal": difficultyUnderstandingVerbal.value,
      "usuallyPlay": usuallyPlay.value,
      "regardingSchoolPerformance": regardingSchoolPerformance.value,
      "Colostrum": Colostrum.value,
      "BottleFeeding": BottleFeeding.value,
      "MixedFeeding": MixedFeeding.value,
      "EBF": EBF.value,
      "ComplementaryFeed": ComplementaryFeed.value,
      "frequentTemperOutbursts": frequentTemperOutbursts.value,
      "Energy": Energy.value,
      "Mood": Mood.value,
      "Persistence": Persistence.value,
      "Perceptiveness": Perceptiveness.value,
      "FirstReaction": FirstReaction.value,
      "Sensitivity": Sensitivity.value,
      "Adaptability": Adaptability.value,
      "Intensity": Intensity.value,
      "Attention": Attention.value,
      "AdditionalComment": AdditionalComment.text,
    };

    var jsonHistoryJson = jsonEncode(jsonHistory);
    final jsonHistoryJsonMAp = jsonDecode(jsonHistoryJson) as Map<String, dynamic>;
    print(jsonHistoryJsonMAp);
    var response = await boxChildHistory.put('$patientID', jsonHistoryJsonMAp);
  }
 }

 Future<void> saveChildHistoryFromServeToLocal(patientID, childHistory)async{
   var jsonHistoryJson = jsonEncode(childHistory);
   final jsonHistoryJsonMAp = jsonDecode(jsonHistoryJson) as Map<String, dynamic>;
   var response =await boxChildHistory.put('$patientID', jsonHistoryJsonMAp);
   print("success");
 }
 Future<void> getChildHistory(patientId)async{
   var response =await boxChildHistory.get('$patientId');

   if(response != null){
         mothersAgeDuringBirth.text = response["mothersAgeDuringBirth"] ?? "";
         motherBloodGroup.value = response["motherBloodGroup"] ?? "";
         rhesusIncompatibility.value = response["rhesusIncompatibility"] ?? '';
         DurationOfLabour.value = response["DurationOfLabour"] ?? '';
         BirthTrauma.value = response["BirthTrauma"] ?? '';
         Miscarriages.value = response["Miscarriages"] ?? '';
         Presentation.value = response["Presentation"] ?? '';
         DelayedCrying.value = response["DelayedCrying"] ?? '';
         FebrileIllness.value = response["FebrileIllness"] ?? '';
         Jaundice.value = response["Jaundice"] ?? '';
         Hypoglycemia.value = response["Hypoglycemia"] ?? '';
         ConsanguinityOfMarriage.value = response["ConsanguinityOfMarriage"] ?? '';
         HaemolyticDisease.value = response["HaemolyticDisease"] ?? '';
         Gestation.text = response["Gestation"] ?? '';
         TypeOfDelivery.value = response["TypeOfDelivery"] ?? '';
         ComplicationsDuringPregnancy.value = response["ComplicationsDuringPregnancy"] ?? '';
         Resuscitation.value = response["Resuscitation"] ?? '';
         FetalDistress.value = response["FetalDistress"] ?? '';
         BirthWeight.text = response["BirthWeight"] ?? '';
         Convulsion.value = response["Convulsion"] ?? '';
         BleedingDisorders.value = response["BleedingDisorders"] ?? '';
         Septicemia.value = response["Septicemia"] ?? '';
         RespiratoryDistress.value = response["RespiratoryDistress"] ?? '';


         currentHealth.value = response["currentHealth"] ?? '';
         specificMedicalConcerns.value = response["specificMedicalConcerns"] ?? '';
         childAllergic.value = response["childAllergic"] ?? '';
         immunizationsUpToDate.value = response["immunizationsUpToDate"] ?? '';
         languageScreening.value = response["languageScreening"] ?? '';
         medicationsList.text = response["medicationsList"] ?? '';
         HearingScreening.value = response["HearingScreening"] ?? '';
         VisionScreening.value = response["VisionScreening"] ?? '';
         RecurrentEarInfections.value = response["RecurrentEarInfections"] ?? '';
         tubesEars.value = response["tubesEars"] ?? '';

          RolledOver.text = response["RolledOver"] ?? '';
         RolledOverType.value = response["RolledOverType"] ?? '';
         Walked.text = response["Walked"] ?? '';
         WalkedType.value = response["WalkedType"] ?? '';
         Weaned.text = response["Weaned"] ?? '';
         WeanedType.value = response["WeanedType"] ?? '';
         ToiletTrained.text = response["ToiletTrained"] ?? '';
         ToiletTrainedType.value = response["ToiletTrainedType"] ?? '';
         Completed.text = response["Completed"] ?? '';
         CompletedType.value = response["CompletedType"] ?? '';
         SatUp.text = response["SatUp"] ?? '';
         SatUpType.value = response["SatUpType"] ?? '';
         SpokeFirstWord.text = response["SpokeFirstWord"] ?? '';
         SpokeFirstWordType.value = response["SpokeFirstWordType"] ?? '';
         FedSelf.text = response["FedSelf"] ?? '';
         FedSelfType.value = response["FedSelfType"] ?? '';
         WasYourInfant.value = response["WasYourInfant"] ?? '';
         Crawled.text = response["Crawled"] ?? '';
         CrawledType.value = response["CrawledType"] ?? '';
         Talked.text = response["Talked"] ?? '';
         TalkedType.value = response["TalkedType"] ?? '';
         DrankFrom.text = response["DrankFrom"] ?? '';
         DrankFromType.value = response["DrankFromType"] ?? '';
         medicalSpecialistsTherapists.value = response["medicalSpecialistsTherapists"] ?? '';
         followingDifficultiesWithSleep.value = response["followingDifficultiesWithSleep"] ?? '';
         difficultiesWithEating.value = response["difficultiesWithEating"] ?? '';
         difficultiesWithElimination.value = response["difficultiesWithElimination"] ?? '';
         problemsWithVision.value = response["problemsWithVision"] ?? '';
         problemsWithCoordination.value = response["problemsWithCoordination"] ?? '';
         dressedByThemselves.value = response["dressedByThemselves"] ?? '';
         languageProblems.value = response["languageProblems"] ?? '';
         difficultySpeechFluency.value = response["difficultySpeechFluency"] ?? '';
         timeMakingFriends.value = response["timeMakingFriends"] ?? '';
         caregiversObserveDifficulty.value = response["caregiversObserveDifficulty"] ?? '';
         useBottle.value = response["useBottle"] ?? '';
         repetitiveMovements.value = response["repetitiveMovements"] ?? '';
         avoidPhysicalActivities.value = response["avoidPhysicalActivities"] ?? '';
         problemsWithExpressiveLanguage.value = response["problemsWithExpressiveLanguage"] ?? '';
         concernsListening.value = response["concernsListening"] ?? '';
         currentlyEnrolledInSchool.value = response["currentlyEnrolledInSchool"] ?? '';
         concernsRelated.value = response["concernsRelated"] ?? '';
         useToCompleteTasks.value = response["useToCompleteTasks"] ?? '';
         developmentInAnyOfTheseAreas.value = response["developmentInAnyOfTheseAreas"] ?? '';
         concernsSpeechOrLanguage.value = response["concernsSpeechOrLanguage"] ?? '';
         problemsSayingSoundsCorrectly.value = response["problemsSayingSoundsCorrectly"] ?? '';
         difficultyUnderstandingVerbal.value = response["difficultyUnderstandingVerbal"] ?? '';
         usuallyPlay.value = response["usuallyPlay"] ?? '';
         regardingSchoolPerformance.value = response["regardingSchoolPerformance"] ?? '';
         Colostrum.value = response["Colostrum"] ?? '';
         BottleFeeding.value = response["BottleFeeding"] ?? '';
         MixedFeeding.value = response["MixedFeeding"] ?? '';
         EBF.value = response["EBF"] ?? '';
         ComplementaryFeed.value = response["ComplementaryFeed"] ?? '';
         frequentTemperOutbursts.value = response["frequentTemperOutbursts"] ?? '';
         Energy.value = response["Energy"] ?? '';
         Mood.value = response["Mood"] ?? '';
         Persistence.value = response["Persistence"] ?? '';
         Perceptiveness.value = response["Perceptiveness"] ?? '';
         FirstReaction.value = response["FirstReaction"] ?? '';
         Sensitivity.value = response["Sensitivity"] ?? '';
         Adaptability.value = response["Adaptability"] ?? '';
         Intensity.value = response["Intensity"] ?? '';
         Attention.value = response["Attention"] ?? '';
         AdditionalComment.text = response["AdditionalComment"] ?? '';
         isDataExist.value = true;
   }else{
     isDataExist.value = false;
     print('no data');
   }

 }
 getForSaveToServer(patientId)async{
   var response =await boxChildHistory.get('$patientId');
   if(response != null){
     return response;
   }else{
     return null;
   }
 }

 dataClear(){
  if(isDataExist.value == true){
    mothersAgeDuringBirth.text= '';
    motherBloodGroup.value= '';
    rhesusIncompatibility.value= '';
    DurationOfLabour.value= '';
    BirthTrauma.value= '';
    Miscarriages.value= '';
    Presentation.value= '';
    DelayedCrying.value= '';
    FebrileIllness.value= '';
    Jaundice.value= '';
    Hypoglycemia.value= '';
    ConsanguinityOfMarriage.value= '';
    HaemolyticDisease.value= '';
    Gestation.text= '';
    TypeOfDelivery.value= '';
    ComplicationsDuringPregnancy.value= '';
    Resuscitation.value= '';
    FetalDistress.value= '';
    BirthWeight.text= '';
    Convulsion.value= '';
    BleedingDisorders.value= '';
    Septicemia.value= '';
    RespiratoryDistress.value= '';
    currentHealth.value = '';
   specificMedicalConcerns.value= '';
    childAllergic.value= '';
    immunizationsUpToDate.value= '';
    languageScreening.value= '';
    medicationsList.text= '';
    HearingScreening.value= '';
    VisionScreening.value= '';
    RecurrentEarInfections.value= '';
    tubesEars.value= '';

    RolledOver.clear();
   RolledOverType.value= '';
    Walked.text= '';
    WalkedType.value= '';
    Weaned.text= '';
    WeanedType.value= '';
    ToiletTrained.text= '';
    ToiletTrainedType.value= '';
    Completed.text= '';
    CompletedType.value= '';
    SatUp.text= '';
    SatUpType.value= '';
    SpokeFirstWord.text= '';
    SpokeFirstWordType.value= '';
    FedSelf.text= '';
    FedSelfType.value= '';
    WasYourInfant.value= '';
    Crawled.text= '';
    CrawledType.value= '';
    Talked.text= '';
    TalkedType.value= '';
    DrankFrom.text= '';
    DrankFromType.value= '';
    medicalSpecialistsTherapists.value= '';
    followingDifficultiesWithSleep.value= '';
    difficultiesWithEating.value= '';
    difficultiesWithElimination.value= '';
    problemsWithVision.value= '';
    problemsWithCoordination.value= '';
    dressedByThemselves.value= '';
    languageProblems.value= '';
    difficultySpeechFluency.value= '';
    timeMakingFriends.value= '';
    caregiversObserveDifficulty.value= '';
    useBottle.value= '';
    repetitiveMovements.value= '';
    avoidPhysicalActivities.value= '';
    problemsWithExpressiveLanguage.value= '';
    concernsListening.value= '';
    currentlyEnrolledInSchool.value= '';
    concernsRelated.value= '';
    useToCompleteTasks.value= '';
    developmentInAnyOfTheseAreas.value= '';
    concernsSpeechOrLanguage.value= '';
    problemsSayingSoundsCorrectly.value= '';
    difficultyUnderstandingVerbal.value= '';
    usuallyPlay.value= '';
    regardingSchoolPerformance.value= '';
    Colostrum.value= '';
    BottleFeeding.value= '';
    MixedFeeding.value= '';
    EBF.value= '';
    ComplementaryFeed.value= '';
    frequentTemperOutbursts.value= '';
    Energy.value= '';
    Mood.value= '';
    Persistence.value= '';
    Perceptiveness.value= '';
    FirstReaction.value= '';
    Sensitivity.value= '';
    Adaptability.value= '';
    Intensity.value= '';
    Attention.value= '';
    AdditionalComment.text= '';
    isDataExist.value = false;
  }
 }
 @override
  void dispose() {
    // TODO: implement dispose
   mothersAgeDuringBirth;
   motherBloodGroup;
   rhesusIncompatibility;
   DurationOfLabour;
   BirthTrauma;
   Miscarriages;
   Presentation;
   DelayedCrying;
   FebrileIllness;
   Jaundice;
   Hypoglycemia;
   ConsanguinityOfMarriage;
   HaemolyticDisease;
   Gestation;
   TypeOfDelivery;
   ComplicationsDuringPregnancy;
   Resuscitation;
   FetalDistress;
   BirthWeight;
   Convulsion;
   BleedingDisorders;
   Septicemia;
   RespiratoryDistress;
   currentHealth;
   specificMedicalConcerns;
   childAllergic;
   immunizationsUpToDate;
   languageScreening;
   medicationsList;
   HearingScreening;
   VisionScreening;
   RecurrentEarInfections;
   tubesEars;


   RolledOver;
   RolledOverType;
   Walked;
   WalkedType;
   Weaned;
   WeanedType;
   ToiletTrained;
   ToiletTrainedType;
   Completed;
   CompletedType;
   SatUp;
   SatUpType;
   SpokeFirstWord;
   SpokeFirstWordType;
   FedSelf;
   FedSelfType;
   WasYourInfant;
   Crawled;
   CrawledType;
   Talked;
   TalkedType;
   DrankFrom;
   DrankFromType;
   medicalSpecialistsTherapists;
   followingDifficultiesWithSleep;
   difficultiesWithEating;
   difficultiesWithElimination;
   problemsWithVision;
   problemsWithCoordination;
   dressedByThemselves;
   languageProblems;
   difficultySpeechFluency;
   timeMakingFriends;
   caregiversObserveDifficulty;
   useBottle;
   repetitiveMovements;
   avoidPhysicalActivities;
   problemsWithExpressiveLanguage;
   concernsListening;
   currentlyEnrolledInSchool;
   concernsRelated;
   useToCompleteTasks;
   developmentInAnyOfTheseAreas;
   concernsSpeechOrLanguage;
   problemsSayingSoundsCorrectly;
   difficultyUnderstandingVerbal;
   usuallyPlay;
   regardingSchoolPerformance;
   Colostrum;
   BottleFeeding;
   MixedFeeding;
   EBF;
   ComplementaryFeed;
   frequentTemperOutbursts;
   Energy;
   Mood;
   Persistence;
   Perceptiveness;
   FirstReaction;
   Sensitivity;
   Adaptability;
   Intensity;
   Attention;
   AdditionalComment;

    super.dispose();
  }
}