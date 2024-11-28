


import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/prescription_controller.dart';
import 'package:dims_vet_rx/controller/sync_controller/sync_server_to_db_controller.dart';
import 'package:path_provider/path_provider.dart';


import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/authentication/login_controller.dart';
import '../controller/sms/sms_controller.dart';
import '../controller/sync_controller/sync_db_to_server_controller.dart';
import '../screens/drawer_items_screen/drawer_items.dart';
import 'default_value.dart';
import 'app_strings.dart';
import 'box_data_clear_refresh.dart';

SMSController smsController = Get.put(SMSController());
class Helpers{

  String removeLastWord(String input) {
    int lastSpaceIndex = input.lastIndexOf(' ');

    if (lastSpaceIndex != -1) {
      return input.substring(0, lastSpaceIndex);
    } else {
      return input;
    }
  }

  findSpecificItem(data,key, find){
     for(var item in data){
       if(item.key == find){
         return item;
       }else{
         return null;
       }
     }
  }

  static successSnackBar(title, message) {
    return  Get.snackbar(
      "$title",
      "$message",
      maxWidth: 300.00,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(vertical: 100),
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration:   Duration(milliseconds: 500),
    );
  }
  static successSnackBarDuration(title, message, duration) {
    return  Get.snackbar(
      "$title",
      "$message",
      maxWidth: 300.00,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(vertical: 100),
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration:   Duration(milliseconds: duration),
    );
  }
  static errorSnackBar(title, message){
    return  Get.snackbar(
      "$title",
      "$message",
      maxWidth: 300.00,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(vertical: 100),
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(milliseconds: 500),
    );
  }
  static errorSnackBarDuration(title, message, duration){
    return  Get.snackbar(
      "$title",
      "$message",
      maxWidth: 300.00,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(vertical: 100),
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration:   Duration(milliseconds: duration),
    );
  }
  Future<String> checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('token') ?? '';
    return token;
  }

}

Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  if (isLoggedIn) {
    return true;
  } else {
    return false;
  }

}

/// This function will run daily
Future checkAndRunDailyFunction() async {
  bool isInternet = await InternetConnectionStatus();
  if(isInternet){
    final BoxDataClearAndRefresh boxDataClearAndRefresh = Get.put(BoxDataClearAndRefresh());
    final AppointmentController appointmentController = Get.put(AppointmentController());
    final PrescriptionController prescriptionController = Get.put(PrescriptionController());
    DateTime now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentDate = '${now.year}-${now.month}-${now.day}';
    String? lastRunDate = prefs.getString('lastRunDate') ?? currentDate;
    print("Last Run Date: $lastRunDate");
    if (lastRunDate != currentDate) {
      bool syncComplete = await runSyncFunction();
      // await smsController.filterSendingList();
      if(syncComplete){
        await prefs.setString('lastRunDate', currentDate);
        print("Last Run Date: $lastRunDate");
        // delete 6 month old appointment, patient and prescription
        await appointmentController.deleteOldAppointment_Patient();
        await prescriptionController.deleteOldPrescription();
      }
    }
  }else{
    Helpers.errorSnackBar("Failed", "Internet Connection Failed");
  }

}

///call sync function
 runSyncFunction() async{
  LoginController loginController = Get.put(LoginController());
  final SyncController syncDownloadController = Get.put(SyncController());
  final DbToServerSyncController syncUploadController = Get.put(DbToServerSyncController());
  bool download = await syncDownloadController.SyncAll(Get.context);
  bool upload = await syncUploadController.SyncAll(Get.context);
  if(download && upload){
    Helpers.successSnackBar("Success", "Sync Successfully completed");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSyncTime', DateTime.now().toString());
    loginController.getUserInformation();
    syncDownloadController.downloadSyncProgress.value = 0.0;
    syncUploadController.updateSyncProgress.value = 0.0;
    return true;
  }else{
    Helpers.errorSnackBar("Error", "Sync Failed");
  }


}

Future getStoreKeyWithValue(storeKey) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String value = prefs.getString(storeKey) ?? DefaultValues.defaultSyncStarting;
  return value;
}
Future getIntStoreKeyWithValue(storeKey) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int value = prefs.getInt(storeKey) ?? 0;
  return value;
}

Future<void> setStoreKeyWithDefaultValue(String storeKey, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(storeKey, value);
}
Future<void> setIntStoreKeyWithDefaultValue(String storeKey, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(storeKey, value);
}

Future<void>setSharedPreferences(String defaultSyncDownload) async {

  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.advice, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.brand, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.cc, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.company, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.diagnosis, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.dose, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.duration, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.generic, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.handout, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.history, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.instruction, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.investigationAdvice, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.investigationReport, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.onExamination, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.onExaminationCategory, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.procedure, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.patient, defaultSyncDownload);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.appointment, defaultSyncDownload);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.prescription, defaultSyncDownload);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.prescriptionDrug, defaultSyncDownload);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.prescriptionDrugDose, defaultSyncDownload);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.template, defaultSyncDownload);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.templateDrug, defaultSyncDownload);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.templateDrugDose, defaultSyncDownload);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.favorite, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.patientsSocialHistory, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.patientsAllergyHistory, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.patientsFamilyHistory, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.generalSettings, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.prescriptionLayoutSettings, DefaultValues.defaultSyncStarting);
  await setIntStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.activeChamberId, DefaultValues.defaultChamberId);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.diseaseImage, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.investigationImage, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.certificate, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.gynehistory, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.historyCategory, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.historyNew, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.physicianNotes, DefaultValues.defaultSyncStarting);
  await setStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.treatmentPlan, DefaultValues.defaultSyncStarting);


  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.advice, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.brand, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.cc, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.company, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.diagnosis, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.dose, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.duration, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.generic, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.handout, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.history, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.instruction, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.investigationAdvice, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.investigationReport, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.onExamination, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.onExaminationCategory, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.procedure, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.patient, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.appointment, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.prescription, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.prescriptionDrug, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.prescriptionDrugDose, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.template, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.templateDrug, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.templateDrugDose, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.favorite, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.patientsSocialHistory, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.patientsAllergyHistory, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.patientsFamilyHistory, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.generalSettings, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.gynehistory, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.historyCategory, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.historyNew, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.physicianNotes, DefaultValues.defaultPageNum);
  await setIntStoreKeyWithDefaultValue("page" + syncTimeSharedPrefsKey.treatmentPlan, DefaultValues.defaultPageNum);
}

DateTime customDateFormat(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
  print("formattedDate: $formattedDate || Date: ${DateFormat('dd-MM-yyyy').parse(formattedDate)}");
  return DateFormat('dd-MM-yyyy').parse(formattedDate);
}

DateTime customParseDate(String dateString) {
  // Parse the date string assuming the format is dd-MM-yyyy
  return DateFormat('dd-MM-yyyy').parse(dateString);
}

Future<bool> isSixMonthsOld(DateTime givenDate) async {
  DateTime recentDate = DateTime.now();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int delete = prefs.getInt('deleteMonthRange') ?? 6;
  DateTime sixMonthsAgo = DateTime(recentDate.year, recentDate.month - delete, recentDate.day);

  // Check if the given date is before the six-months-ago date
  return givenDate.isBefore(sixMonthsAgo);
}


String customDateTimeFormat(DateTime dateTime) {
  return DateFormat('dd-MM-yyyy').format(dateTime);
}
String customDateTimeFormatReverse(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime);
}
String appDateTimeFormat(DateTime dateTime) {
  return DateFormat('yyyy-M-d').format(dateTime);
}

String customDateTimeFormatWithHours(DateTime dateTime) {
  return DateFormat('hh-dd-MM-yyyy').format(dateTime);
}

String customDateTimeFormatWithHoursMin(DateTime dateTime) {
  return DateFormat('hh:mm dd-MM-yyyy').format(dateTime);
}
String customDateTimeFormatReverseWithHoursMin(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd hh:mm').format(dateTime);
}
DateTime parseDate(String date) {
  try {
    // Try parsing as ISO-8601 format (1969-11-25 12:54:00.000)
    return DateTime.parse(date);
  } catch (e) {
    // If parsing fails, try as custom format (21-08-1959)
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.parse(date);
  }
}
 Age calculateAge(DateTime dob) {

  DateTime now = DateTime.now();
  int years = now.year - dob.year;
  int months = now.month - dob.month;
  int days = now.day - dob.day;
  int hours = now.hour - dob.hour;
  int minutes = now.minute - dob.minute;

  // Adjust negative values
  if (minutes < 0) {
    minutes += 60;
    hours--;
  }
  if (hours < 0) {
    hours += 24;
    days--;
  }
  if (days < 0) {
    final previousMonth = now.subtract(Duration(days: now.day));
    days += previousMonth.day;
    months--;
  }
  if (months < 0) {
    months += 12;
    years--;
  }

  return Age(years: years, months: months, days: days, hours: hours, minutes: minutes);
}

DateTime calculateDOB(int years, int months, int days, int hours, int minutes) {
  DateTime now = DateTime.now();

  // Subtract years, months, and days from current date
  DateTime dob = DateTime(
    now.year - years,
    now.month - months,
    now.day - days,
    now.hour - hours,
    now.minute - minutes,
  );

  // Adjust for negative months or days
  if (dob.month <= 0) {
    dob = DateTime(dob.year - 1, dob.month + 12, dob.day, dob.hour, dob.minute);
  }

  if (dob.day <= 0) {
    dob = dob.subtract(Duration(days: now.day));
  }

  return dob;
}


bool isValidDateFormat(String dateString) {
  try {
    DateTime.parse(dateString);
    return true;
  } catch (e) {
    return false;
  }
}

parseDouble(String value) {
  try {
    if (value.isEmpty) {
      // Return null to represent an empty field
      return null;
    }
    return double.parse(value);
  } catch (e) {
    // Handle the error, for example, by returning null
    print("Error parsing double: $e");
    return null;
  }
}

parseInt(String value) {
  try {
    if (value.isEmpty) {
      // Return null to represent an empty field
      return null;
    }
    return int.parse(value);
  } catch (e) {
    // Handle the error, for example, by returning null
    print("Error parsing int: $e");
    return null;
  }
}




Future<void> initHive() async {
  WidgetsFlutterBinding.ensureInitialized();

    // await Firebase.initializeApp();
  print("Firebase initialized successfully!");
// Determine platform and get appropriate directory
  Directory? appDocDir;

  if (!kIsWeb) {
    // For non-web platforms (Android, iOS, Desktop)
    if (Platform.isAndroid || Platform.isIOS) {
      appDocDir = await getApplicationDocumentsDirectory();
    } else if (Platform.isWindows) {
      // For Windows desktop
      String customDirectoryName = "NavanaRxDigitalDB";
      String customPathC = "C:\\$customDirectoryName";
      appDocDir = Directory(customPathC);
      if (!await appDocDir.exists()) {
        await appDocDir.create(recursive: true);
      }
    }
  } else {
    // For web
    appDocDir = Directory.current;
  }

  // Initialize Hive with the appropriate directory path
  Hive.init(appDocDir!.path);
  await getUserInfo();
}

// Define a function to open the directory
void openDirectory(String path) {
  Process.run('explorer', [path]);
}

clinicalDataJoiningToString(listMapData){
  var string = "";
  for(int i=0; i<listMapData.length; i++){
    var chiefComplain = listMapData[i].name.toString();
    var stringWithN = "\n".toString();
     string = string + chiefComplain + stringWithN;
  }
  return string;
}

shortAdviceDataJoiningToString(listMapData){
  var string = "";
  for(int i=0; i<listMapData.length; i++){
    var chiefComplain = listMapData[i].text.toString();
    var stringWithN = "\n".toString();
     string = string + chiefComplain + stringWithN;
  }
  return string;
}

clinicalDataConvertStringToList(stringData){
  final List joinedDataList = [];
  joinedDataList.clear();
  List<String> dataList = stringData.split('\n').toList();
  // print(dataList.length);
  for(var i=0; i<dataList.length; i++){
    var item = dataList[i].toString();
    var mapData =   (id: i, name: item.toString().trim());
    joinedDataList.add(mapData);
  }
  return joinedDataList;
}
clinicalDataHistoryConvertStringToList(stringData){
  final List joinedDataList = [];
  joinedDataList.clear();
  List<String> dataList = stringData.split('\n').toList();
  // print(dataList.length);
  for(var i=0; i<dataList.length; i++){
    var item = dataList[i].toString();
    var mapData =   (id: i, name: item);
    joinedDataList.add(mapData);
  }
  return joinedDataList;
}



String checkInputType(String value) {
  RegExp digitRegex = RegExp(r'^[0-9]+$');
  RegExp letterRegex = RegExp(r'^[a-zA-Z]+$');

  if (digitRegex.hasMatch(value)) {
    return 'Number';
  } else if (letterRegex.hasMatch(value)) {
    return 'Letter';
  } else {
    return 'Mixed/Other';
  }
}
clinicalDataIterationForPrinting(List data, fieldName){
  List<String> dataList = [];
  if( data.isNotEmpty && data.length> 0){
   dataList.insert(0, "${fieldName.toString()}");
    for(int i=0; i<data.length; i++){
      dataList.add(data[i].name.toString());
    }

    return  dataList;
  }else{
    return [""];
  }
}

InternetConnectionStatus() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  }else{
    return true;
  }
}

convertHeightToCM(feet, inches,) {
  if (checkInputType(feet) == "Number" ||
      checkInputType(inches) == "Number") {
    double heightFeet = 0.0;
    double heightInches = 0.0;
    if (feet.isNotEmpty) {
      heightFeet = double.parse(feet.toString());
    }
    if (inches.isNotEmpty) {
      heightInches = double.parse(inches.toString());
    }

    double heightInCentimeters = (heightFeet * 30.48) + (heightInches * 2.54);
    var heightCmTextEditingController = heightInCentimeters.toString();
    return heightCmTextEditingController;
  }
}

convertCMToHeight(cm) {

    double? heightInCentimeters = 0.0;
    if (cm.isNotEmpty) {
      heightInCentimeters = double.parse(cm.toString());

    double totalInches = heightInCentimeters / 2.54;
    int feet = (totalInches / 12).floor();
    int inches = (totalInches % 12).round();
    var heightFeetTextEditingController = feet.toString();
    var heightInchesTextEditingController = inches.toString();
    return [heightFeetTextEditingController, heightInchesTextEditingController];
    }
}



HeaderFooterImage(imageURL)async{
  // Download the image
  final imageUrl = imageURL;
  if(imageUrl !=null){
    final imageBytes = await downloadImage(imageUrl);
    if(imageBytes !=false){
      final base64String = imageToBase64(imageBytes);
      return base64String;
    }else{
      return false;
    }

  }
}

Future downloadImage(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    return false;
  }
}

// Function to convert image bytes to base64 string
String imageToBase64(Uint8List imageBytes) {
  return base64Encode(imageBytes);
}


// Function to convert Fahrenheit to Celsius
double fahrenheitToCelsius(double fahrenheit) {
  return (fahrenheit - 32) * 5 / 9;
}

// Function to convert Celsius to Fahrenheit
double celsiusToFahrenheit(double celsius) {
  return (celsius * 9 / 5) + 32;
}

//inch to CM
double inchToCm(double inches) {
  return inches * 2.54;
}

//cm to inch
double cmToInch(double centimeters) {
  return centimeters / 2.54;
}

int calculateTotalFee(feeAppointments) {
 
  return feeAppointments.fold(0, (previousValue, appointment) => previousValue + (appointment.appointment.fee as int));
}

int calculateTodayTotalFee(feeAppointments) {
  return feeAppointments.fold(0, (previousValue, appointment) => previousValue + (appointment.appointment.fee as int));
}



    timeDifferenceNew(serverTime, localDbTime) {
      try{
        bool result = isLocalTimeValid(DateTime.parse(serverTime.toString()), DateTime.parse(localDbTime.toString()));
        if(result){
          return true;
        }else{
          return false;
        }
      }catch(e){
        print(e);
      }
    }
  bool isLocalTimeValid(DateTime serverTime, DateTime localDbTime) {
    return localDbTime.isBefore(serverTime);
  }



   timeDifference(serverTime, localDbTime) {
  try{
    String dateTimeString = "${DateTime.parse(serverTime).toString()}";

    // Splitting the string into date and time components
    List<String> dateTimeComponents = dateTimeString.split(" ");
    List<String> dateComponents = dateTimeComponents[0].split("-");
    List<String> timeComponents = dateTimeComponents[1].split(":");

    // Parsing components into integers
    int year = int.parse(dateComponents[0]);
    int month = int.parse(dateComponents[1]);
    int day = int.parse(dateComponents[2]);
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);
    int second = 0; // Set seconds to zero
    int millisecond = 0; // Set milliseconds to zero

// Creating DateTime object from the previous time
    DateTime previousDateTime = DateTime.utc(year, month, day, hour, minute, second, millisecond);

    DateTime currentDateTime = localDbTime;

    // Comparing the two DateTime objects
    if (previousDateTime.isBefore(currentDateTime)) {
      String difference = currentDateTime.difference(previousDateTime).toString();
      return true;
    } else if (previousDateTime.isAfter(currentDateTime)) {
      String difference = previousDateTime.difference(currentDateTime).toString();
      return true;
    } else {
      return true;
    }
  }catch(e){
    print(e);
  }
}


class Age {
  final int years;
  final int months;
  final int days;
  final int hours;
  final int minutes;

  Age({required this.years, required this.months, required this.days, required this.hours, required this.minutes});
}


class DurationDifference {
  int years;
  int months;
  int days;
  int hours;
  int minutes;

  DurationDifference({
    required this.years,
    required this.months,
    required this.days,
    required this.hours,
    required this.minutes,
  });
}

DurationDifference calculateDuration(DateTime startDate, DateTime endDate) {
  int years = endDate.year - startDate.year;
  int months = endDate.month - startDate.month;
  int days = endDate.day - startDate.day;
  int hours = endDate.hour - startDate.hour;
  int minutes = endDate.minute - startDate.minute;

  // Adjust negative values
  if (minutes < 0) {
    minutes += 60;
    hours--;
  }
  if (hours < 0) {
    hours += 24;
    days--;
  }
  if (days < 0) {
    final previousMonth = endDate.subtract(Duration(days: endDate.day));
    days += previousMonth.day;
    months--;
  }
  if (months < 0) {
    months += 12;
    years--;
  }

  return DurationDifference(
    years: years,
    months: months,
    days: days,
    hours: hours,
    minutes: minutes,
  );
}


String roundString(String value) {
  // String valueText = value;
  // double valueCm = double.tryParse(valueText) ?? 0.0; // Parsing text to double, defaulting to 0.0 if parsing fails
  // String formattedValue = valueCm.toStringAsFixed(1);
  // return formattedValue;
  String valueText = value;
  double valueCm = double.tryParse(valueText) ?? 0.0; // Parse text to double
  String formattedValue = valueCm.toStringAsFixed(1);
  return formattedValue.split('.')[0]; // Only keep the part before the dot
}




List<List<T>> splitList<T>(List<T> originalList, listLength) {
  int length = originalList.length;
  int partLength = (length / listLength).ceil();

  List<List<T>> dividedLists = [];

  for (int i = 0; i < length; i += partLength) {
    dividedLists.add(originalList.sublist(i, i + partLength > length ? length : i + partLength));
  }

  return dividedLists;
}

String cmToFeetAndInches(double cm) {
  double feet = cm / 30.48;
  // Calculate remaining inches
  double totalInches = cm / 2.54;
  double inches = totalInches % 12;

  // Convert the result to a formatted string
  String formattedResult = '${feet.toInt()} feet ${inches.toInt()} inches';

  return formattedResult;
}

double cmToInches(double cm) {
  // 1 inch = 2.54 centimeters
  return cm / 2.54;
}
// Convert meters to centimeters
double meterToCentimeter(double meter) {
  return meter * 100;
}

// Convert centimeters to meters
double centimeterToMeter(double centimeter) {
  return centimeter / 100;
}


bloodGroupNumToString(value) {
  if(value != 0 && value !=null){
    for(var bloodGroup in bloodGroupList){
      if(bloodGroup['value'] == parseInt(value.toString())){
        return bloodGroup['label'];
      }
    }
  }

}

bloodGroupStringToNum(value) {
  for(var bloodGroup in bloodGroupList){
    if(bloodGroup['label'] == value){
      return bloodGroup['value'];
    }
  }
}


genderConvertToString(value) {
  if(value != 0 && value !=null){
    if(value == 1){
      return "Male";
    }else if(value == 2){
      return "Female";
    }else if(value == 3){
      return "Other";
    }
  }
}

void timeCalculation() {

    // Define two DateTime objects representing two different times
    DateTime startTime = DateTime(2025, 5, 19, 0, 0); // Example start time
    DateTime endTime = DateTime(2024, 5, 19, 20, 45);   // Example end time

    // Calculate the difference between the two times
    Duration difference = endTime.difference(startTime);

    // Calculate the difference in days, hours, and minutes
    int days = difference.inDays;
    int hours = difference.inHours.remainder(24);
    int minutes = difference.inMinutes.remainder(60);

    // Approximate the difference in years
    int years = (days / 365).floor();

    // Print the difference
    print("Time difference: $years years, ${days % 365 } days, $hours hours, and $minutes minutes");

}

String formatPhoneNumber(String phoneNumber) {
  if (phoneNumber.length == 11) {
    return '88' + phoneNumber;
  }else if(phoneNumber.length == 10){
    return '880' + phoneNumber;
  } else if (phoneNumber.length > 11 && phoneNumber.startsWith('880')) {
    return phoneNumber;
  } else {
    return '';
  }
}
double convertToDoubleWithDPI(String value) {
 try{
   return double.parse(value);
 }catch(e){
   return 0.0;
 }
}

void checkFile() async {
  final file = File('assets/images/rx_icon.png');
  print("await file.exists()");
  print(await file.exists());
}
