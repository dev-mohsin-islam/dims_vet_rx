
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../database/hive_get_boxes.dart';

class Immunization extends GetxController{

    Box boxImmunization = Boxes.getImmunization();
    RxBool isDataExist = false.obs;

    RxString AtBirthBCGGivenDate = "".obs;
    TextEditingController AtBirthBCGNoteController = TextEditingController();

    RxString AtBirth14daysOPV = "".obs;
    TextEditingController AtBirth14daysOPVNoteController = TextEditingController();

    RxString Weeks6BCG = "".obs;
    TextEditingController Weeks6BCGNoteController = TextEditingController();

    RxString Weeks6PentavalentVaccine  = "".obs;
    TextEditingController Weeks6PentavalentVaccineNoteController = TextEditingController();

    RxString Weeks6OPV  = "".obs;
    TextEditingController Weeks6OPVNoteController = TextEditingController();

    RxString Weeks6Pneumococcal  = "".obs;
    TextEditingController Weeks6OPneumococcalController = TextEditingController();

    RxString Weeks10OPV  = "".obs;
    TextEditingController Weeks10OPVNoteController = TextEditingController();

    RxString Weeks10Pneumococcal  = "".obs;
    TextEditingController Weeks10PneumococcalController = TextEditingController();

    RxString Weeks14PentavalentVaccine   = "".obs;
    TextEditingController Weeks14PentavalentVaccineNoteController = TextEditingController();

    RxString Weeks14IPV   = "".obs;
    TextEditingController Weeks14IPVNoteController = TextEditingController();

    RxString Weeks14OPV   = "".obs;
    TextEditingController Weeks14OPVNoteController = TextEditingController();

    RxString Weeks14OPV3rd   = "".obs;
    TextEditingController Weeks14OPV3rdNoteController = TextEditingController();

    RxString Weeks18Pneumococcal    = "".obs;
    TextEditingController Weeks18PneumococcalNoteController = TextEditingController();

    RxString AfterMonths9MR    = "".obs;
    TextEditingController AfterMonths9MRNoteController = TextEditingController();

    RxString Months15MR    = "".obs;
    TextEditingController Months15MRNoteController = TextEditingController();

    RxString Years15MR    = "".obs;
    TextEditingController Years15MRNoteController = TextEditingController();

    RxString Years15TT    = "".obs;
    TextEditingController Years15TTNoteController = TextEditingController();

    RxString atPregnancyTT_1st    = "".obs;
    TextEditingController atPregnancyTT_1stNoteController = TextEditingController();

    RxString weeks4AfterTT2_2nd    = "".obs;
    TextEditingController weeks4AfterTT2_2ndNoteController = TextEditingController();

    RxString months6AfterTT2_3rd    = "".obs;
    TextEditingController months6AfterTT2_3rdNoteController = TextEditingController();

    RxString year1AfterTT3    = "".obs;
    TextEditingController year1AfterTT3NoteController = TextEditingController();

    RxString year1AfterTT4    = "".obs;
    TextEditingController year1AfterTT4NoteController = TextEditingController();



    //Optional

    RxString HepatitisA1st    = "".obs;
    TextEditingController HepatitisA1stNoteController = TextEditingController();

    RxString HepatitisA2nd    = "".obs;
    TextEditingController HepatitisA2ndNoteController = TextEditingController();


    RxString HepatitisB1st    = "".obs;
    TextEditingController HepatitisB1stNoteController = TextEditingController();

    RxString HepatitisB2nd    = "".obs;
    TextEditingController HepatitisB2ndNoteController = TextEditingController();

    RxString HepatitisB3rd    = "".obs;
    TextEditingController HepatitisB3rdNoteController = TextEditingController();

    RxString HepatitisB4    = "".obs;
    TextEditingController HepatitisB4NoteController = TextEditingController();

    RxString HaemophilusInfluenza1    = "".obs;
    TextEditingController HaemophilusInfluenza1NoteController = TextEditingController();

    RxString HaemophilusInfluenza2    = "".obs;
    TextEditingController HaemophilusInfluenza2NoteController = TextEditingController();

    RxString HaemophilusInfluenza3    = "".obs;
    TextEditingController HaemophilusInfluenza3NoteController = TextEditingController();

    RxString HaemophilusInfluenzaBooster    = "".obs;
    TextEditingController HaemophilusInfluenzaBoosterNoteController = TextEditingController();

    RxString HaemophilusInfluenzaSingle    = "".obs;
    TextEditingController HaemophilusInfluenzaSingleNoteController = TextEditingController();

    RxString HumanPapillomaVirus1    = "".obs;
    TextEditingController HumanPapillomaVirus1NoteController = TextEditingController();

    RxString HumanPapillomaVirus2    = "".obs;
    TextEditingController HumanPapillomaVirus2NoteController = TextEditingController();

    RxString HumanPapillomaVirus3    = "".obs;
    TextEditingController HumanPapillomaVirus3NoteController = TextEditingController();

    RxString HumanPapillomaVirus4    = "".obs;
    TextEditingController HumanPapillomaVirus4NoteController = TextEditingController();

    RxString HumanPapillomaVirus5    = "".obs;
    TextEditingController HumanPapillomaVirus5NoteController = TextEditingController();

    RxString Polysaccharide1    = "".obs;
    TextEditingController Polysaccharide1NoteController = TextEditingController();

    RxString PolysaccharideBooster    = "".obs;
    TextEditingController PolysaccharideBoosterNoteController = TextEditingController();

    RxString RabiesVaccinePre1 = ''.obs;
    TextEditingController RabiesVaccinePre1NoteController = TextEditingController();

    RxString RabiesVaccinePre2 = ''.obs;
    TextEditingController RabiesVaccinePre2NoteController = TextEditingController();

    RxString RabiesVaccinePre3 = ''.obs;
    TextEditingController RabiesVaccinePre3NoteController = TextEditingController();

    RxString RabiesVaccinePre4 = ''.obs;
    TextEditingController RabiesVaccinePre4NoteController = TextEditingController();

    RxString RabiesVaccinePreBooster1 = ''.obs;
    TextEditingController RabiesVaccinePreBooster1NoteController = TextEditingController();

    RxString RabiesVaccinePreBooster2 = ''.obs;
    TextEditingController RabiesVaccinePreBooster2NoteController = TextEditingController();



    RxString RabiesVaccinePost1 = ''.obs;
    TextEditingController RabiesVaccinePost1NoteController = TextEditingController();

    RxString RabiesVaccinePost2 = ''.obs;
    TextEditingController RabiesVaccinePost2NoteController = TextEditingController();

    RxString RabiesVaccinePost3 = ''.obs;
    TextEditingController RabiesVaccinePost3NoteController = TextEditingController();

    RxString RabiesVaccinePost4 = ''.obs;
    TextEditingController RabiesVaccinePost4NoteController = TextEditingController();

    RxString RabiesVaccinePost5 = ''.obs;
    TextEditingController RabiesVaccinePost5NoteController = TextEditingController();

    RxString RabiesVaccinePostBooster1 = ''.obs;
    TextEditingController RabiesVaccinePostBooster1NoteController = TextEditingController();


    RxString Typhoid1 = ''.obs;
    TextEditingController Typhoid1NoteController = TextEditingController();

    RxString TyphoidBooster = ''.obs;
    TextEditingController TyphoidBoosterNoteController = TextEditingController();


    RxString OralCholera1 = ''.obs;
    TextEditingController OralCholera1NoteController = TextEditingController();

    RxString OralCholera2 = ''.obs;
    TextEditingController OralCholera2NoteController = TextEditingController();

    RxString OralCholera3 = ''.obs;
    TextEditingController OralCholera3NoteController = TextEditingController();

    RxString OralCholeraBooster = ''.obs;
    TextEditingController OralCholeraBoosterNoteController = TextEditingController();

    RxString OralCholeraBooster1 = ''.obs;
    TextEditingController OralCholeraBooster1NoteController = TextEditingController();

    RxString OralCholeraBooster2 = ''.obs;
    TextEditingController OralCholeraBooster2NoteController = TextEditingController();

    RxString OralCholeraBooster3 = ''.obs;
    TextEditingController OralCholeraBooster3NoteController = TextEditingController();


    RxString TetanusToxoid1 = ''.obs;
    TextEditingController TetanusToxoid1NoteController = TextEditingController();

    RxString TetanusToxoid2 = ''.obs;
    TextEditingController TetanusToxoid2NoteController = TextEditingController();

    RxString TetanusToxoid3 = ''.obs;
    TextEditingController TetanusToxoid3NoteController = TextEditingController();

    RxString TetanusToxoidBooster = ''.obs;
    TextEditingController TetanusToxoidBoosterNoteController = TextEditingController();


    RxString MMR1 = ''.obs;
    TextEditingController MMR1NoteController = TextEditingController();

    RxString MMR2 = ''.obs;
    TextEditingController MMR2NoteController = TextEditingController();


    RxString Yellow = ''.obs;
    TextEditingController YellowNoteController = TextEditingController();


    RxString ChickenPox1  = ''.obs;
    TextEditingController ChickenPox1NoteController = TextEditingController();

    RxString ChickenPox2  = ''.obs;
    TextEditingController ChickenPox2NoteController = TextEditingController();

    RxString ChickenPox3  = ''.obs;
    TextEditingController ChickenPox3NoteController = TextEditingController();

    RxString ChickenPox4  = ''.obs;
    TextEditingController ChickenPox4NoteController = TextEditingController();


    RxString Meningococcal1  = ''.obs;
    TextEditingController Meningococcal1NoteController = TextEditingController();

    RxString MeningococcalBooster  = ''.obs;
    TextEditingController MeningococcalBoosterNoteController = TextEditingController();


    RxString MeningococcalQuadrivalent1= ''.obs;
    TextEditingController MeningococcalQuadrivalent1NoteController = TextEditingController();

    RxString MeningococcalQuadrivalent2= ''.obs;
    TextEditingController MeningococcalQuadrivalent2NoteController = TextEditingController();

    RxString MeningococcalQuadrivalentSingle= ''.obs;
    TextEditingController MeningococcalQuadrivalentSinglNoteController = TextEditingController();


    RxString SeasonalInfluenza1 = ''.obs;
    TextEditingController SeasonalInfluenza1NoteController = TextEditingController();

    RxString SeasonalInfluenza2 = ''.obs;
    TextEditingController SeasonalInfluenza2NoteController = TextEditingController();

    RxString SeasonalInfluenza3 = ''.obs;
    TextEditingController SeasonalInfluenza3NoteController = TextEditingController();

    RxString SeasonalInfluenza4 = ''.obs;
    TextEditingController SeasonalInfluenza4NoteController = TextEditingController();








    Future<void>saveImmunization(patientID)async{
        if(isDataExist.value == true){
            var jsonImmunization = {
                'AtBirthBCGGivenDate' : AtBirthBCGGivenDate.value,
                'AtBirthBCGNoteController' : AtBirthBCGNoteController.text,
                'AtBirth14daysOPV' : AtBirth14daysOPV.value,
                'AtBirth14daysOPVNoteController' : AtBirth14daysOPVNoteController.text,
                'Weeks6BCG' : Weeks6BCG.value,
                'Weeks6BCGNoteController' : Weeks6BCGNoteController.text,
                'Weeks6PentavalentVaccine' : Weeks6PentavalentVaccine.value,
                'Weeks6PentavalentVaccineNoteController' : Weeks6PentavalentVaccineNoteController.text,
                'Weeks6OPV' : Weeks6OPV.value,
                'Weeks6OPVNoteController' : Weeks6OPVNoteController.text,
                'Weeks6Pneumococcal' : Weeks6Pneumococcal.value,
                'Weeks6OPneumococcalController' : Weeks6OPneumococcalController.text,
                'Weeks10OPV' : Weeks10OPV.value,
                'Weeks10OPVNoteController' : Weeks10OPVNoteController.text,
                'Weeks10Pneumococcal' : Weeks10Pneumococcal.value,
                'Weeks10PneumococcalController' : Weeks10PneumococcalController.text,
                'Weeks14PentavalentVaccine' : Weeks14PentavalentVaccine.value,
                'Weeks14PentavalentVaccineNoteController' : Weeks14PentavalentVaccineNoteController.text,
                'Weeks14IPV' : Weeks14IPV.value,
                'Weeks14IPVNoteController' : Weeks14IPVNoteController.text,
                'Weeks14OPV' : Weeks14OPV.value,
                'Weeks10OOPVNoteController' : Weeks14OPVNoteController.text,
                 'Weeks14OPV3rd' : Weeks14OPV3rd.value,
                'Weeks14OPV3rdNoteController' : Weeks14OPV3rdNoteController.text,
                'Weeks18Pneumococcal' : Weeks18Pneumococcal.value,
                'Weeks18PneumococcalNoteController' : Weeks18PneumococcalNoteController.text,
                'AfterMonths9MR' : AfterMonths9MR.value,
                'AfterMonths9MRNoteController' : AfterMonths9MRNoteController.text,
                'Months15MR' : Months15MR.value,
                'Months15MRNoteController' : Months15MRNoteController.text,
                'Years15MR' : Years15MR.value,
                'Years15MRNoteController' : Years15MRNoteController.text,
                'Years15TT' : Years15TT.value,
                'Years15TTNoteController' : Years15TTNoteController.text,
                'atPregnancyTT_1st' : atPregnancyTT_1st.value,
                'atPregnancyTT_1stNoteController' : atPregnancyTT_1stNoteController.text,
                'weeks4AfterTT2_2nd' : weeks4AfterTT2_2nd.value,
                'weeks4AfterTT2_2ndNoteController' : weeks4AfterTT2_2ndNoteController.text,
                'months6AfterTT2_3rd' : months6AfterTT2_3rd.value,
                'months6AfterTT2_3rdNoteController' : months6AfterTT2_3rdNoteController.text,
                'year1AfterTT3' : year1AfterTT3.value,
                'year1AfterTT3NoteController' : year1AfterTT3NoteController.text,
                'year1AfterTT4' : year1AfterTT4.value,
                'year1AfterTT4NoteController' : year1AfterTT4NoteController.text,
                'HepatitisA1st' : HepatitisA1st.value,
                'HepatitisA1stNoteController' : HepatitisA1stNoteController.text,
                'HepatitisA2nd' : HepatitisA2nd.value,
                'HepatitisA2ndNoteController' : HepatitisA2ndNoteController.text,
                'HepatitisB1st' : HepatitisB1st.value,
                'HepatitisB1stNoteController' : HepatitisB1stNoteController.text,
                'HepatitisB2nd' : HepatitisB2nd.value,
                'HepatitisB2ndNoteController' : HepatitisB2ndNoteController.text,
                'HepatitisB3rd' : HepatitisB3rd.value,
                'HepatitisB3rdNoteController' : HepatitisB3rdNoteController.text,
                'HepatitisB4' : HepatitisB4.value,
                'HepatitisB4NoteController' : HepatitisB4NoteController.text,
                'HaemophilusInfluenza1' : HaemophilusInfluenza1.value,
                'HaemophilusInfluenza1NoteController' : HaemophilusInfluenza1NoteController.text,
                'HaemophilusInfluenza2' : HaemophilusInfluenza2.value,
                'HaemophilusInfluenza2NoteController' : HaemophilusInfluenza2NoteController.text,
                'HaemophilusInfluenza3' : HaemophilusInfluenza3.value,
                'HaemophilusInfluenza3NoteController' : HaemophilusInfluenza3NoteController.text,
                'HaemophilusInfluenzaBooster' : HaemophilusInfluenzaBooster.value,
                'HaemophilusInfluenzaBoosterNoteController' : HaemophilusInfluenzaBoosterNoteController.text,
                'HaemophilusInfluenzaSingle' : HaemophilusInfluenzaSingle.value,
                'HaemophilusInfluenzaSingleNoteController' : HaemophilusInfluenzaSingleNoteController.text,
                'HumanPapillomaVirus1' : HumanPapillomaVirus1.value,
                'HumanPapillomaVirus1NoteController' : HumanPapillomaVirus1NoteController.text,
                'HumanPapillomaVirus2' : HumanPapillomaVirus2.value,
                'HumanPapillomaVirus2NoteController' : HumanPapillomaVirus2NoteController.text,
                'HumanPapillomaVirus3' : HumanPapillomaVirus3.value,
                'HumanPapillomaVirus3NoteController' : HumanPapillomaVirus3NoteController.text,
                'HumanPapillomaVirus4' : HumanPapillomaVirus4.value,
                'HumanPapillomaVirus4NoteController' : HumanPapillomaVirus4NoteController.text,
                'HumanPapillomaVirus5' : HumanPapillomaVirus5.value,
                'HumanPapillomaVirus5NoteController' : HumanPapillomaVirus5NoteController.text,
                'Polysaccharide1' : Polysaccharide1.value,
                'Polysaccharide1NoteController' : Polysaccharide1NoteController.text,
                'PolysaccharideBooster' : PolysaccharideBooster.value,
                'PolysaccharideBoosterNoteController' : PolysaccharideBoosterNoteController.text,
                'RabiesVaccinePre1' : RabiesVaccinePre1.value,
                'RabiesVaccinePre1NoteController' : RabiesVaccinePre1NoteController.text,
                'RabiesVaccinePre2' : RabiesVaccinePre2.value,
                'RabiesVaccinePre2NoteController' : RabiesVaccinePre2NoteController.text,
                'RabiesVaccinePre3' : RabiesVaccinePre3.value,
                'RabiesVaccinePre3NoteController' : RabiesVaccinePre3NoteController.text,
                'RabiesVaccinePre4' : RabiesVaccinePre4.value,
                'RabiesVaccinePre4NoteController' : RabiesVaccinePre4NoteController.text,
                'RabiesVaccinePreBooster1' : RabiesVaccinePreBooster1.value,
                'RabiesVaccinePreBooster1NoteController' : RabiesVaccinePreBooster1NoteController.text,
                'RabiesVaccinePreBooster2' : RabiesVaccinePreBooster2.value,
                'RabiesVaccinePreBooster2NoteController' : RabiesVaccinePreBooster2NoteController.text,
                'RabiesVaccinePost1' : RabiesVaccinePost1.value,
                'RabiesVaccinePost1NoteController' : RabiesVaccinePost1NoteController.text,
                'RabiesVaccinePost2' : RabiesVaccinePost2.value,
                'RabiesVaccinePost2NoteController' : RabiesVaccinePost2NoteController.text,
                'RabiesVaccinePost3' : RabiesVaccinePost3.value,
                'RabiesVaccinePost3NoteController' : RabiesVaccinePost3NoteController.text,
                'RabiesVaccinePost4' : RabiesVaccinePost4.value,
                'RabiesVaccinePost4NoteController' : RabiesVaccinePost4NoteController.text,
                'RabiesVaccinePost5' : RabiesVaccinePost5.value,
                'RabiesVaccinePost5NoteController' : RabiesVaccinePost5NoteController.text,
                'RabiesVaccinePostBooster1' : RabiesVaccinePostBooster1.value,
                'RabiesVaccinePostBooster1NoteController' : RabiesVaccinePostBooster1NoteController.text,
                'Typhoid1' : Typhoid1.value,
                'Typhoid1NoteController' : Typhoid1NoteController.text,
                'TyphoidBooster' : TyphoidBooster.value,
                'TyphoidBoosterNoteController' : TyphoidBoosterNoteController.text,
                'OralCholera1' : OralCholera1.value,
                'OralCholera1NoteController' : OralCholera1NoteController.text,
                'OralCholera2' : OralCholera2.value,
                'OralCholera2NoteController' : OralCholera2NoteController.text,
                'OralCholera3' : OralCholera3.value,
                'OralCholera3NoteController' : OralCholera3NoteController.text,
                'OralCholeraBooster' : OralCholeraBooster.value,
                'OralCholeraBoosterNoteController' : OralCholeraBoosterNoteController.text,
                'OralCholeraBooster1' : OralCholeraBooster1.value,
                'OralCholeraBooster1NoteController' : OralCholeraBooster1NoteController.text,
                'OralCholeraBooster2' : OralCholeraBooster2.value,
                'OralCholeraBooster2NoteController' : OralCholeraBooster2NoteController.text,
                'OralCholeraBooster3' : OralCholeraBooster3.value,
                'OralCholeraBooster3NoteController' : OralCholeraBooster3NoteController.text,
                'TetanusToxoid1' : TetanusToxoid1.value,
                'TetanusToxoid1NoteController' : TetanusToxoid1NoteController.text,
                'TetanusToxoid2' : TetanusToxoid2.value,
                'TetanusToxoid2NoteController' : TetanusToxoid2NoteController.text,
                'TetanusToxoid3' : TetanusToxoid3.value,
                'TetanusToxoid3NoteController' : TetanusToxoid3NoteController.text,
                'TetanusToxoidBooster' : TetanusToxoidBooster.value,
                'TetanusToxoidBoosterNoteController' : TetanusToxoidBoosterNoteController.text,
                'MMR1' : MMR1.value,
                'MMR1NoteController' : MMR1NoteController.text,
                'MMR2' : MMR2.value,
                'MMR2NoteController' : MMR2NoteController.text,
                'Yellow' : Yellow.value,
                'YellowNoteController' : YellowNoteController.text,
                'ChickenPox1' : ChickenPox1.value,
                'ChickenPox1NoteController' : ChickenPox1NoteController.text,
                'ChickenPox2' : ChickenPox2.value,
                'ChickenPox2NoteController' : ChickenPox2NoteController.text,
                'ChickenPox3' : ChickenPox3.value,
                'ChickenPox3NoteController' : ChickenPox3NoteController.text,
                'ChickenPox4' : ChickenPox4.value,
                'ChickenPox4NoteController' : ChickenPox4NoteController.text,
                'Meningococcal1' : Meningococcal1.value,
                'Meningococcal1NoteController' : Meningococcal1NoteController.text,
                'MeningococcalBooster' : MeningococcalBooster.value,
                'MeningococcalBoosterNoteController' : MeningococcalBoosterNoteController.text,
                'MeningococcalQuadrivalent1' : MeningococcalQuadrivalent1.value,
                'MeningococcalQuadrivalent1NoteController' : MeningococcalQuadrivalent1NoteController.text,
                'MeningococcalQuadrivalent2' : MeningococcalQuadrivalent2.value,
                'MeningococcalQuadrivalent2NoteController' : MeningococcalQuadrivalent2NoteController.text,
                'MeningococcalQuadrivalentSingle' : MeningococcalQuadrivalentSingle.value,
                'MeningococcalQuadrivalentSinglNoteController' : MeningococcalQuadrivalentSinglNoteController.text,
                'SeasonalInfluenza1' : SeasonalInfluenza1.value,
                'SeasonalInfluenza1NoteController' : SeasonalInfluenza1NoteController.text,
                'SeasonalInfluenza2' : SeasonalInfluenza2.value,
                'SeasonalInfluenza2NoteController' : SeasonalInfluenza2NoteController.text,
                'SeasonalInfluenza3' : SeasonalInfluenza3.value,
                'SeasonalInfluenza3NoteController' : SeasonalInfluenza3NoteController.text,
                'SeasonalInfluenza4' : SeasonalInfluenza4.value,
                'SeasonalInfluenza4NoteController' : SeasonalInfluenza4NoteController.text,
            };

            var jsonImmunizationX = jsonEncode(jsonImmunization);
            final jsonImmunizationXJsonMAp = jsonDecode(jsonImmunizationX) as Map<String, dynamic>;
            var response = await boxImmunization.put('$patientID', jsonImmunizationXJsonMAp);
        }
    }
    Future<void> getImmunization(patientId)async {
        var response = await boxImmunization.get('$patientId');
        if(response != null){
                AtBirthBCGGivenDate.value= response['AtBirthBCGGivenDate'];
                AtBirthBCGNoteController.text= response['AtBirthBCGNoteController'];
                AtBirth14daysOPV.value= response['AtBirth14daysOPV'];
                AtBirth14daysOPVNoteController.text= response['AtBirth14daysOPVNoteController'];
                Weeks6BCG.value= response['Weeks6BCG'];
                Weeks6BCGNoteController.text= response['Weeks6BCGNoteController'];
                Weeks6PentavalentVaccine.value= response['Weeks6PentavalentVaccine'];
                Weeks6PentavalentVaccineNoteController.text= response['Weeks6PentavalentVaccineNoteController'];
                Weeks6OPV.value= response['Weeks6OPV'];
                Weeks6OPVNoteController.text= response['Weeks6OPVNoteController'];
                Weeks6Pneumococcal.value= response['Weeks6Pneumococcal'];
                Weeks6OPneumococcalController.text= response['Weeks6OPneumococcalController'];
                Weeks10OPV.value= response['Weeks10OPV'];
                Weeks10OPVNoteController.text= response['Weeks10OPVNoteController'];
                Weeks10Pneumococcal.value= response['Weeks10Pneumococcal'];
                Weeks10PneumococcalController.text= response['Weeks10PneumococcalController'];
                Weeks14PentavalentVaccine.value= response['Weeks14PentavalentVaccine'];
                Weeks14PentavalentVaccineNoteController.text= response['Weeks14PentavalentVaccineNoteController'];
                Weeks14IPV.value= response['Weeks14IPV'];
                Weeks14IPVNoteController.text= response['Weeks14IPVNoteController'];
                Weeks14OPV.value= response['Weeks14OPV'];
                Weeks14OPVNoteController.text= response['Weeks10OOPVNoteController'];
                Weeks18Pneumococcal.value= response['Weeks18Pneumococcal'];
                Weeks18PneumococcalNoteController.text= response['Weeks18PneumococcalNoteController'];
                AfterMonths9MR.value= response['AfterMonths9MR'];
                AfterMonths9MRNoteController.text= response['AfterMonths9MRNoteController'];
                Months15MR.value= response['Months15MR'];
                Months15MRNoteController.text= response['Months15MRNoteController'];
                Years15MR.value= response['Years15MR'];
                Years15MRNoteController.text= response['Years15MRNoteController'];
                Years15TT.value= response['Years15TT'];
                Years15TTNoteController.text= response['Years15TTNoteController'];
                atPregnancyTT_1st.value= response['atPregnancyTT_1st'];
                atPregnancyTT_1stNoteController.text= response['atPregnancyTT_1stNoteController'];
                weeks4AfterTT2_2nd.value= response['weeks4AfterTT2_2nd'];
                weeks4AfterTT2_2ndNoteController.text= response['weeks4AfterTT2_2ndNoteController'];
                months6AfterTT2_3rd.value= response['months6AfterTT2_3rd'];
                months6AfterTT2_3rdNoteController.text= response['months6AfterTT2_3rdNoteController'];
                year1AfterTT3.value= response['year1AfterTT3'];
                year1AfterTT3NoteController.text= response['year1AfterTT3NoteController'];
                year1AfterTT4.value= response['year1AfterTT4'];
                year1AfterTT4NoteController.text= response['year1AfterTT4NoteController'];
                HepatitisA1st.value= response['HepatitisA1st'];
                HepatitisA1stNoteController.text= response['HepatitisA1stNoteController'];
                HepatitisA2nd.value= response['HepatitisA2nd'];
                HepatitisA2ndNoteController.text= response['HepatitisA2ndNoteController'];
                HepatitisB1st.value= response['HepatitisB1st'];
                HepatitisB1stNoteController.text= response['HepatitisB1stNoteController'];
                HepatitisB2nd.value= response['HepatitisB2nd'];
                HepatitisB2ndNoteController.text= response['HepatitisB2ndNoteController'];
                HepatitisB3rd.value= response['HepatitisB3rd'];
                HepatitisB3rdNoteController.text= response['HepatitisB3rdNoteController'];
                HepatitisB4.value= response['HepatitisB4'];
                HepatitisB4NoteController.text= response['HepatitisB4NoteController'];
                HaemophilusInfluenza1.value= response['HaemophilusInfluenza1'];
                HaemophilusInfluenza1NoteController.text= response['HaemophilusInfluenza1NoteController'];
                HaemophilusInfluenza2.value= response['HaemophilusInfluenza2'];
                HaemophilusInfluenza2NoteController.text= response['HaemophilusInfluenza2NoteController'];
                HaemophilusInfluenza3.value= response['HaemophilusInfluenza3'];
                HaemophilusInfluenza3NoteController.text= response['HaemophilusInfluenza3NoteController'];
                HaemophilusInfluenzaBooster.value= response['HaemophilusInfluenzaBooster'];
                HaemophilusInfluenzaBoosterNoteController.text= response['HaemophilusInfluenzaBoosterNoteController'];
                HaemophilusInfluenzaSingle.value= response['HaemophilusInfluenzaSingle'];
                HaemophilusInfluenzaSingleNoteController.text= response['HaemophilusInfluenzaSingleNoteController'];
                HumanPapillomaVirus1.value= response['HumanPapillomaVirus1'];
                HumanPapillomaVirus1NoteController.text= response['HumanPapillomaVirus1NoteController'];
                HumanPapillomaVirus2.value= response['HumanPapillomaVirus2'];
                HumanPapillomaVirus2NoteController.text= response['HumanPapillomaVirus2NoteController'];
                HumanPapillomaVirus3.value= response['HumanPapillomaVirus3'];
                HumanPapillomaVirus3NoteController.text= response['HumanPapillomaVirus3NoteController'];
                HumanPapillomaVirus4.value= response['HumanPapillomaVirus4'];
                HumanPapillomaVirus4NoteController.text= response['HumanPapillomaVirus4NoteController'];
                HumanPapillomaVirus5.value= response['HumanPapillomaVirus5'];
                HumanPapillomaVirus5NoteController.text= response['HumanPapillomaVirus5NoteController'];
                Polysaccharide1.value= response['Polysaccharide1'];
                Polysaccharide1NoteController.text= response['Polysaccharide1NoteController'];
                PolysaccharideBooster.value= response['PolysaccharideBooster'];
                PolysaccharideBoosterNoteController.text= response['PolysaccharideBoosterNoteController'];
                RabiesVaccinePre1.value= response['RabiesVaccinePre1'];
                RabiesVaccinePre1NoteController.text= response['RabiesVaccinePre1NoteController'];
                RabiesVaccinePre2.value= response['RabiesVaccinePre2'];
                RabiesVaccinePre2NoteController.text= response['RabiesVaccinePre2NoteController'];
                RabiesVaccinePre3.value= response['RabiesVaccinePre3'];
                RabiesVaccinePre3NoteController.text= response['RabiesVaccinePre3NoteController'];
                RabiesVaccinePre4.value= response['RabiesVaccinePre4'];
                RabiesVaccinePre4NoteController.text= response['RabiesVaccinePre4NoteController'];
                RabiesVaccinePreBooster1.value= response['RabiesVaccinePreBooster1'];
                RabiesVaccinePreBooster1NoteController.text= response['RabiesVaccinePreBooster1NoteController'];
                RabiesVaccinePreBooster2.value= response['RabiesVaccinePreBooster2'];
                RabiesVaccinePreBooster2NoteController.text= response['RabiesVaccinePreBooster2NoteController'];
                RabiesVaccinePost1.value= response['RabiesVaccinePost1'];
                RabiesVaccinePost1NoteController.text= response['RabiesVaccinePost1NoteController'];
                RabiesVaccinePost2.value= response['RabiesVaccinePost2'];
                RabiesVaccinePost2NoteController.text= response['RabiesVaccinePost2NoteController'];
                RabiesVaccinePost3.value= response['RabiesVaccinePost3'];
                RabiesVaccinePost3NoteController.text= response['RabiesVaccinePost3NoteController'];
                RabiesVaccinePost4.value= response['RabiesVaccinePost4'];
                RabiesVaccinePost4NoteController.text= response['RabiesVaccinePost4NoteController'];
                RabiesVaccinePost5.value= response['RabiesVaccinePost5'];
                RabiesVaccinePost5NoteController.text= response['RabiesVaccinePost5NoteController'];
                RabiesVaccinePostBooster1.value= response['RabiesVaccinePostBooster1'];
                RabiesVaccinePostBooster1NoteController.text= response['RabiesVaccinePostBooster1NoteController'];
                Typhoid1.value= response['Typhoid1'];
                Typhoid1NoteController.text= response['Typhoid1NoteController'];
                TyphoidBooster.value= response['TyphoidBooster'];
                TyphoidBoosterNoteController.text= response['TyphoidBoosterNoteController'];
                OralCholera1.value= response['OralCholera1'];
                OralCholera1NoteController.text= response['OralCholera1NoteController'];
                OralCholera2.value= response['OralCholera2'];
                OralCholera2NoteController.text= response['OralCholera2NoteController'];
                OralCholera3.value= response['OralCholera3'];
                OralCholera3NoteController.text= response['OralCholera3NoteController'];
                OralCholeraBooster.value= response['OralCholeraBooster'];
                OralCholeraBoosterNoteController.text= response['OralCholeraBoosterNoteController'];
                OralCholeraBooster1.value= response['OralCholeraBooster1'];
                OralCholeraBooster1NoteController.text= response['OralCholeraBooster1NoteController'];
                OralCholeraBooster2.value= response['OralCholeraBooster2'];
                OralCholeraBooster2NoteController.text= response['OralCholeraBooster2NoteController'];
                OralCholeraBooster3.value= response['OralCholeraBooster3'];
                OralCholeraBooster3NoteController.text= response['OralCholeraBooster3NoteController'];
                TetanusToxoid1.value= response['TetanusToxoid1'];
                TetanusToxoid1NoteController.text= response['TetanusToxoid1NoteController'];
                TetanusToxoid2.value= response['TetanusToxoid2'];
                TetanusToxoid2NoteController.text= response['TetanusToxoid2NoteController'];
                TetanusToxoid3.value= response['TetanusToxoid3'];
                TetanusToxoid3NoteController.text= response['TetanusToxoid3NoteController'];
                TetanusToxoidBooster.value= response['TetanusToxoidBooster'];
                TetanusToxoidBoosterNoteController.text= response['TetanusToxoidBoosterNoteController'];
                MMR1.value= response['MMR1'];
                MMR1NoteController.text= response['MMR1NoteController'];
                MMR2.value= response['MMR2'];
                MMR2NoteController.text= response['MMR2NoteController'];
                Yellow.value= response['Yellow'];
                YellowNoteController.text= response['YellowNoteController'];
                ChickenPox1.value= response['ChickenPox1'];
                ChickenPox1NoteController.text= response['ChickenPox1NoteController'];
                ChickenPox2.value= response['ChickenPox2'];
                ChickenPox2NoteController.text= response['ChickenPox2NoteController'];
                ChickenPox3.value= response['ChickenPox3'];
                ChickenPox3NoteController.text= response['ChickenPox3NoteController'];
                ChickenPox4.value= response['ChickenPox4'];
                ChickenPox4NoteController.text= response['ChickenPox4NoteController'];
                Meningococcal1.value= response['Meningococcal1'];
                Meningococcal1NoteController.text= response['Meningococcal1NoteController'];
                MeningococcalBooster.value= response['MeningococcalBooster'];
                MeningococcalBoosterNoteController.text= response['MeningococcalBoosterNoteController'];
                MeningococcalQuadrivalent1.value= response['MeningococcalQuadrivalent1'];
                MeningococcalQuadrivalent1NoteController.text= response['MeningococcalQuadrivalent1NoteController'];
                MeningococcalQuadrivalent2.value= response['MeningococcalQuadrivalent2'];
                MeningococcalQuadrivalent2NoteController.text= response['MeningococcalQuadrivalent2NoteController'];
                MeningococcalQuadrivalentSingle.value= response['MeningococcalQuadrivalentSingle'];
                MeningococcalQuadrivalentSinglNoteController.text= response['MeningococcalQuadrivalentSinglNoteController'];
                SeasonalInfluenza1.value= response['SeasonalInfluenza1'];
                SeasonalInfluenza1NoteController.text= response['SeasonalInfluenza1NoteController'];
                SeasonalInfluenza2.value= response['SeasonalInfluenza2'];
                SeasonalInfluenza2NoteController.text= response['SeasonalInfluenza2NoteController'];
                SeasonalInfluenza3.value= response['SeasonalInfluenza3'];
                SeasonalInfluenza3NoteController.text= response['SeasonalInfluenza3NoteController'];
                SeasonalInfluenza4.value= response['SeasonalInfluenza4'];
                SeasonalInfluenza4NoteController.text= response['SeasonalInfluenza4NoteController'];
                isDataExist.value = true;
        }else{
          isDataExist.value = false;
        }
    }
    dataClear(){
        if(isDataExist.value){
            AtBirthBCGGivenDate.value = '';
            AtBirthBCGNoteController.clear();
            AtBirth14daysOPV.value = '';
            AtBirth14daysOPVNoteController.clear();
            Weeks6BCG.value = '';
            Weeks6BCGNoteController.clear();
            Weeks6PentavalentVaccine.value = '';
            Weeks6PentavalentVaccineNoteController.clear();
            Weeks6OPV.value = '';
            Weeks6OPVNoteController.clear();
            Weeks6Pneumococcal.value = '';
            Weeks6OPneumococcalController.clear();
            Weeks10OPV.value = '';
            Weeks10OPVNoteController.clear();
            Weeks10Pneumococcal.value = '';
            Weeks10PneumococcalController.clear();
            Weeks14PentavalentVaccine.value = '';
            Weeks14PentavalentVaccineNoteController.clear();
            Weeks14IPV.value = '';
            Weeks14IPVNoteController.clear();
            Weeks14OPV.value = '';
            Weeks14OPVNoteController.clear();
            Weeks18Pneumococcal.value = '';
            Weeks18PneumococcalNoteController.clear();
            AfterMonths9MR.value = '';
            AfterMonths9MRNoteController.clear();
            Months15MR.value = '';
            Months15MRNoteController.clear();
            Years15MR.value = '';
            Years15MRNoteController.clear();
            Years15TT.value = '';
            Years15TTNoteController.clear();
            atPregnancyTT_1st.value = '';
            atPregnancyTT_1stNoteController.clear();
            weeks4AfterTT2_2nd.value = '';
            weeks4AfterTT2_2ndNoteController.clear();
            months6AfterTT2_3rd.value = '';
            months6AfterTT2_3rdNoteController.clear();
            year1AfterTT3.value = '';
            year1AfterTT3NoteController.clear();
            year1AfterTT4.value = '';
            year1AfterTT4NoteController.clear();
            HepatitisA1st.value = '';
            HepatitisA1stNoteController.clear();
            HepatitisA2nd.value = '';
            HepatitisA2ndNoteController.clear();
            HepatitisB1st.value = '';
            HepatitisB1stNoteController.clear();
            HepatitisB2nd.value = '';
            HepatitisB2ndNoteController.clear();
            HepatitisB3rd.value = '';
            HepatitisB3rdNoteController.clear();
            HepatitisB4.value = '';
            HepatitisB4NoteController.clear();
            HaemophilusInfluenza1.value = '';
            HaemophilusInfluenza1NoteController.clear();
            HaemophilusInfluenza2.value = '';
            HaemophilusInfluenza2NoteController.clear();
            HaemophilusInfluenza3.value = '';
            HaemophilusInfluenza3NoteController.clear();
            HaemophilusInfluenzaBooster.value = '';
            HaemophilusInfluenzaBoosterNoteController.clear();
            HaemophilusInfluenzaSingle.value = '';
            HaemophilusInfluenzaSingleNoteController.clear();
            HumanPapillomaVirus1.value = '';
            HumanPapillomaVirus1NoteController.clear();
            HumanPapillomaVirus2.value = '';
            HumanPapillomaVirus2NoteController.clear();
            HumanPapillomaVirus3.value = '';
            HumanPapillomaVirus3NoteController.clear();
            HumanPapillomaVirus4.value = '';
            HumanPapillomaVirus4NoteController.clear();
            HumanPapillomaVirus5.value = '';
            HumanPapillomaVirus5NoteController.clear();
            Polysaccharide1.value = '';
            Polysaccharide1NoteController.clear();
            PolysaccharideBooster.value = '';
            PolysaccharideBoosterNoteController.clear();
            RabiesVaccinePre1.value = '';
            RabiesVaccinePre1NoteController.clear();
            RabiesVaccinePre2.value = '';
            RabiesVaccinePre2NoteController.clear();
            RabiesVaccinePre3.value = '';
            RabiesVaccinePre3NoteController.clear();
            RabiesVaccinePre4.value = '';
            RabiesVaccinePre4NoteController.clear();
            RabiesVaccinePreBooster1.value = '';
            RabiesVaccinePreBooster1NoteController.clear();
            RabiesVaccinePreBooster2.value = '';
            RabiesVaccinePreBooster2NoteController.clear();
            RabiesVaccinePost1.value = '';
            RabiesVaccinePost2.value = '';
            RabiesVaccinePost2NoteController.clear();
            RabiesVaccinePost3.value = '';
            RabiesVaccinePost3NoteController.clear();
            RabiesVaccinePost4.value = '';
            RabiesVaccinePost4NoteController.clear();
            RabiesVaccinePost5.value = '';
            RabiesVaccinePost5NoteController.clear();
            RabiesVaccinePostBooster1.value = '';
            RabiesVaccinePostBooster1NoteController.clear();
            Typhoid1.value = '';
            Typhoid1NoteController.clear();
            TyphoidBooster.value = '';
            TyphoidBoosterNoteController.clear();
            OralCholera1.value = '';
            OralCholera1NoteController.clear();
            OralCholera2.value = '';
            OralCholera2NoteController.clear();
            OralCholera3.value = '';
            OralCholera3NoteController.clear();
            OralCholeraBooster.value = '';
            OralCholeraBoosterNoteController.clear();
            OralCholeraBooster1.value = '';
            OralCholeraBooster1NoteController.clear();
            OralCholeraBooster2.value = '';
            OralCholeraBooster2NoteController.clear();
            OralCholeraBooster3.value = '';
            OralCholeraBooster3NoteController.clear();
            TetanusToxoid1.value = '';
            TetanusToxoid1NoteController.clear();
            TetanusToxoid2.value = '';
            TetanusToxoid2NoteController.clear();
            TetanusToxoid3.value = '';
            TetanusToxoid3NoteController.clear();
            TetanusToxoidBooster.value = '';
            TetanusToxoidBoosterNoteController.clear();
            MMR1.value = '';
            MMR1NoteController.clear();
            MMR2.value = '';
            MMR2NoteController.clear();
            Yellow.value = '';
            YellowNoteController.clear();
            ChickenPox1.value = '';
            ChickenPox1NoteController.clear();
            ChickenPox2.value = '';
            ChickenPox2NoteController.clear();
            ChickenPox3.value = '';
            ChickenPox3NoteController.clear();
            ChickenPox4.value = '';
            ChickenPox4NoteController.clear();
            Meningococcal1.value = '';
            Meningococcal1NoteController.clear();
            MeningococcalBooster.value = '';
            MeningococcalBoosterNoteController.clear();
            MeningococcalQuadrivalent1.value = '';
            MeningococcalQuadrivalent1NoteController.clear();
            MeningococcalQuadrivalent2.value = '';
            MeningococcalQuadrivalent2NoteController.clear();
            MeningococcalQuadrivalentSingle.value = '';
            MeningococcalQuadrivalentSinglNoteController.clear();
            SeasonalInfluenza1.value = '';
            SeasonalInfluenza1NoteController.clear();
            SeasonalInfluenza2.value = '';
            SeasonalInfluenza2NoteController.clear();
            SeasonalInfluenza3.value = '';
            SeasonalInfluenza3NoteController.clear();
            SeasonalInfluenza4.value = '';
            SeasonalInfluenza4NoteController.clear();
        };
    }

}