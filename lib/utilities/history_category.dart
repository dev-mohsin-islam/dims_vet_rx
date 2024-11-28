
import 'package:get/get.dart';

class HistoryCategory{



  //this list for insert to database and showing to prescription table and print

static const personalHistoryTitle = "Personal History";
static const allergyHistoryTitle = "Allergy History";
static const familyHistoryTitle = "Family History";
static const socialHistoryTitle = "Social History";
static const foodAllergyHistoryTitle = "Foods Allergy History";
static const drugAllergyHistoryTitle = "Drug Allergy History";
static const environmentalAllergyHistoryTitle = "Environmental Allergy History";

static const personalHistoryCategory = "Personal History";
static const allergyHistoryCategory = "Allergy_History";
static const familyHistoryCategory = "Family History";
static const socialHistoryCategory = "Social History";
static const foodAllergyHistoryCategory = "Foods Allergy History";
static const drugAllergyHistoryCategory = "Drugs Allergy History";
static const environmentalAllergyHistoryCategory = "Environmental Allergy History";

//this list for create new entry
final List historyCategory = [
  {'name': "Select History Category", "value": ""},
  {'name': personalHistoryTitle, "value": personalHistoryCategory},
  {'name': drugAllergyHistoryTitle, "value": drugAllergyHistoryCategory},
  {'name': familyHistoryTitle, "value": familyHistoryCategory},
  {'name': socialHistoryTitle, "value": socialHistoryCategory},
  {'name': foodAllergyHistoryTitle, "value": foodAllergyHistoryCategory},
  {'name': environmentalAllergyHistoryTitle, "value": environmentalAllergyHistoryCategory},
].obs;


}