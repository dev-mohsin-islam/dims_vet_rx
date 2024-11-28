

import 'dart:convert';

import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';

import '../../database/hive_get_boxes.dart';
import '../../models/patient_appointment_model.dart';
import '../../services/api/send_sms.dart';
import '../../services/api/upload_prescription_pdf.dart';
import '../../services/end_points_list.dart';
import '../../utilities/helpers.dart';
import '../authentication/profile.dart';
import 'package:url_launcher/url_launcher.dart';

class SMSController extends GetxController{
  AppointmentController appointmentController = Get.put(AppointmentController());
  final boxSms = Boxes.getSmsSuccess();
  Profile profile = Get.put(Profile());

  String APIKEY= "RADwtnxA0UAQVV78NO5u5ZEHP0zxtn6EzgwraDPd";
  String APIKEYNavana= "qbwevk0a-7n3gvtfd-sago34yy-rlzdhosq-xoe7lw6g";
  String BASEURL = "https://api.sms.net.bd/sendsms";
  String BASEURLNavana = "http://202.51.179.74/navana_erx.php";
  String Message = "OTP Text from API 2";

  RxList sendingPatients = [].obs;
  int count = 0;

  Future sendSms(patientPhoneNumber, message)async{
    bool isInternet = await InternetConnectionStatus();
    if(isInternet){
      var response = await sendSmsApiService2(BASEURLNavana, APIKEYNavana, patientPhoneNumber, message);
      if(response != null){
        return response;
      }
      // var response = await sendSmsApiService(BASEURLNavana, APIKEYNavana,patientPhoneNumber, message);
    }else{
      print("No Internet");
    }
  }
 // for auto sms next visit date
  filterSendingList()async{
    var appointments = appointmentController.boxAppointment.values.toList();
    var patients = appointmentController.boxPatient.values.toList();
    if(appointments.isNotEmpty){
      for(int i=0; i<appointments.length; i++){
        var patient_id = appointments[i].patient_id;
        // DateTime nextVisitDate = DateTime.parse('2024-05-23');
        String? nextVisitDateX = appointments[i].next_visit;
        try{
          if(nextVisitDateX !=null && nextVisitDateX.isNotEmpty && nextVisitDateX != '0000-00-00'){
            DateTime parsedDate = customParseDate(nextVisitDateX);
            String formattedDate = customDateTimeFormatReverse(parsedDate);
            DateTime nextVisitDate =await DateTime.parse(formattedDate);
            int? patientIndex = appointmentController.boxPatient.values.toList().indexWhere((element) => element.id== patient_id);
            if(patientIndex!=-1){
              var patientPhoneNumber = patients[patientIndex].phone;
              if(patientPhoneNumber != null && patientPhoneNumber.isNotEmpty){
                String sendingPhoneNumber = formatPhoneNumber(patientPhoneNumber);
                DateTime reminderDate = nextVisitDate.subtract(Duration(days: 2));
                DateTime today = DateTime.now();
                if (today.year == reminderDate.year &&
                    today.month == reminderDate.month &&
                    today.day == reminderDate.day) {
                  String message = ''
                      'Reminder:'
                      'Dear ${patients[patientIndex].name}, '
                      'Your next visit is on Date: ${nextVisitDate.toString().substring(0, 10)} '
                      'Time: 10:00 AM to 11:00 AM '
                      '${profile.nameController.text}'
                      '${profile.designationController.text}'
                      '${profile.phoneController.text}'
                  ;
                  // var response = await sendSms(sendingPhoneNumber, message);
                }

              }

            }
          }
        }catch(e){
          print(e);
        }

      }
    }
  }
  sentPrescriptionToSMS(PatientAppointment patientAppointment, prescriptionLink)async{

        try{
              var patientPhoneNumber = patientAppointment.patient.phone;
              var patientName = patientAppointment.patient.name;
              if(patientPhoneNumber != null && patientPhoneNumber.isNotEmpty){
                String sendingPhoneNumber = formatPhoneNumber(patientPhoneNumber);
                String message =
                    'Dear ${patientName},\n'
                    'Your Digital Prescription is available here: ${prescriptionLink}\n'
                    '${DateTime.now().toString().substring(0,10)}\n'
                    '${profile.nameController.text}\n'
                    '${profile.designationController.text}\n\n'
                    '${profile.phoneController.text}';
                 var response = await sendSms(sendingPhoneNumber, message);
                 if(response != null){
                   smsSuccessInsert("prescription_link",patientAppointment,message,true);
                   Helpers.successSnackBar("Success", "Successfully Sent");
                 }
              }

        }catch(e){
          print(e);
        }
    }

  prescriptionFileUpload(PatientAppointment appointmentAndPatientInfo, pdfFile, medium)async{
    String URL = '${ApiCUD.BaseUrl}${ApiCUD.pdfPrescription}';
    String token =  await  Helpers().checkToken();
    bool isInternet = await InternetConnectionStatus();

      if(isInternet){

        var res =await uploadPdfApiService(URL, token, pdfFile, appointmentAndPatientInfo.patient.id);

        if(res['success'] == true){

          var prescriptionLink = res['data']['prescription_url'];
          if(medium == 'sms'){
            if(appointmentAndPatientInfo.patient.phone == null || appointmentAndPatientInfo.patient.phone!.isEmpty){
              Helpers.errorSnackBar("Error", "Patient Phone Number Not Found");
            }else{
              await sentPrescriptionToSMS(appointmentAndPatientInfo, prescriptionLink);
            }

          }
          if(medium == 'email'){
            if(appointmentAndPatientInfo.patient.email == null || appointmentAndPatientInfo.patient.email!.isEmpty){
              Helpers.errorSnackBar("Error", "Patient Email Not Found");
            }else{
              openGmail(appointmentAndPatientInfo, prescriptionLink);
            }
          }

        }else{
        }

      }else{
      }


  }

  void openGmail(PatientAppointment appointmentAndPatientInfo, prescriptionLink) async {
    final Uri gmailUri = Uri(
      scheme: 'https',
      host: 'mail.google.com',
      path: '/mail/u/0/',
      queryParameters: {
        'view': 'cm',
        'fs': '1',
        'to': '${appointmentAndPatientInfo.patient.email}',
        'su': 'Digital Prescription Link',
        // 'body': _encodeEmailBody(appointmentAndPatientInfo[0], prescriptionLink),
        'body': ' Dear ${appointmentAndPatientInfo.patient.name},\n'
                  'Your Digital Prescription is available here:\n  ${prescriptionLink}\n'
                  'Date: ${DateTime.now().toString().substring(0,10)}\n'
                  'Doctor Name: ${profile.nameController.text}\n'
                  'Designation: ${profile.designationController.text}\n\n'
                  'Phone: ${profile.phoneController.text}'
       },
    );

    if (await canLaunch(gmailUri.toString())) {
      await launch(gmailUri.toString());
    } else {
      throw 'Could not launch $gmailUri';
    }
  }
  Future<void>smsSuccessInsert(type,PatientAppointment patientAppointment,smsContent,smsStatus)async{
    var dataObject = {
      'patient_id': "${patientAppointment.patient.id}",
      'appointment_id': "${patientAppointment.appointment.id}",
      'medium': "sms",
      'status': "$smsStatus",
      "type": "$type",
      'message': "$smsContent"
    };
    var jsonData = jsonEncode(dataObject);
    final jsonDataMap = jsonDecode(jsonData) as Map<String, dynamic>;
    var response = await boxSms.add(jsonDataMap);
  }
  // String _encodeEmailBody(appointmentAndPatientInfo,  prescriptionLink) {
  //   final String emailBody = '''
  //   Dear ${appointmentAndPatientInfo['name']},
  //     Your Digital Prescription is available here: <a href="$prescriptionLink">Download</a>
  //     Date: ${DateTime.now().toString().substring(0, 10)}
  //     Doctor Name: ${appointmentAndPatientInfo['doctorName']}
  //     Designation: ${appointmentAndPatientInfo['designation']}
  //     Phone: ${appointmentAndPatientInfo['phone']}
  //     ''';
  //   return Uri.encodeComponent(emailBody);
  // }
}

