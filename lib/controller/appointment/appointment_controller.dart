

import 'package:intl/intl.dart';

import 'package:get/get_rx/get_rx.dart';
 import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/controller/general_setting/prescription_print_page_setup_controller.dart';
import 'package:dims_vet_rx/controller/investigation_report_image/investigation_report_image_cotroller.dart';
import 'package:dims_vet_rx/controller/patient_certificate/patient_certificate_controller.dart';
import 'package:dims_vet_rx/models/appointment/appointment_model.dart';
import 'package:dims_vet_rx/models/patient_appointment_model.dart';
import 'package:dims_vet_rx/screens/printing/company_brand_report_download/print.dart';
import 'package:dims_vet_rx/utilities/default_value.dart';

import '../../database/crud_operations/appointment_crud.dart';
import '../../database/crud_operations/common_crud.dart';
import '../../database/crud_operations/patient_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../models/on_examination/on_examination_model.dart';
import '../../models/patient/patient_model.dart';
import '../../screens/create_prescription_screen/create_prescription_components/patient_appointment/todays_appointment.dart';
import '../../utilities/app_strings.dart';
import '../../utilities/helpers.dart';
import '../create_prescription/prescription/prescription_controller.dart';
import '../general_setting/general_setting_controller.dart';
import '../vet_controller/vet_controller.dart';
import 'methods/clear_appointment_data.dart';

class AppointmentController extends GetxController{
  final CommonController commonController = CommonController();
  final PatientCRUDController patientBoxController = PatientCRUDController();
  final AppointmentBoxController appointmentBoxController = AppointmentBoxController();
  final PrescriptionController prescriptionController = PrescriptionController();
  final InvestigationReportImageController investigationReportImageController = InvestigationReportImageController();
  final PrescriptionPrintPageSetupController presPrintSetUp = Get.put(PrescriptionPrintPageSetupController());
  final GeneralSettingController generalSettingController = Get.put(GeneralSettingController());
  final vetController = Get.put(VetController());

  RxBool isLoading = true.obs;
  RxBool isSyncing = false.obs;

  final Box<AppointmentModel>boxAppointment = Boxes.getAppointment();
  final Box<PatientModel>boxPatient = Boxes.getPatient();

  final appConst = AppointmentDefaultValue();
  RxList dropdownItemsX =  [].obs;

  final RxList allAppointmentList =  [].obs;
  final RxList patientInfo =  [].obs;
  final RxList patientAndAppointmentInfoJoin =  [].obs;
  final RxList searchDataList =  [].obs;
  final RxList patientAppointmentList = [].obs;
  final RxList todayPatientAppointmentList = [].obs;
  final TextEditingController nameController= TextEditingController();
  final TextEditingController searchController= TextEditingController();


  final uuid = DefaultValues.defaultUuid;
   TextEditingController dateController = TextEditingController();
  final statusDelete = DefaultValues.Delete;

  int appointmentBy = 1;
  int appointmentTo = 1;

  RxInt PATIENT_ID = 0.obs;
  RxInt APPOINTMENT_ID = 0.obs;


  //patient info----------------------------------------------------------------------
  var dobController = ''.obs;
   TextEditingController selectedBloodGroupCont = TextEditingController();
  RxString selectedBloodGroup = ''.obs;

  final TextEditingController ageYearController = TextEditingController();
  final TextEditingController ageMonthController = TextEditingController();
  final TextEditingController ageDayController = TextEditingController();
  final TextEditingController ageHourController = TextEditingController();
  final TextEditingController ageMinutesController = TextEditingController();

  Future<void> deleteOldAppointment_Patient() async {
    await appointmentBoxController.deleteOldestAppointment(boxAppointment);
    await patientBoxController.deleteOldestPatient(boxPatient);
  }




  RxInt  sexController = 0.obs;
  RxString?  isPregnant = ''.obs;

  var marital_statusController = 0.obs;
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController guardian_nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController blood_groupController = TextEditingController();
  final TextEditingController dobTextController = TextEditingController();
  //patient info----------------------------------------------------------------------

//for oe in create rx page

  RxString  weight = ''.obs;
  RxString  bp1 = ''.obs;
  RxString  bp2 = ''.obs;
  RxString  pulse = ''.obs;
  RxString  rr = ''.obs;
  RxString  temparature = ''.obs;
  RxString  height = ''.obs;
  RxString  hip = ''.obs;
  RxString  waist = ''.obs;
  RxString  OFC = ''.obs;
  RxString  medicineHistory = ''.obs;
  RxString  complain = ''.obs;


  //appointment info----------------------------------------------------------------------
  final TextEditingController pulseTextEditingController = TextEditingController();
  final TextEditingController sys_blood_pressureTextEditingController = TextEditingController();
  final TextEditingController dys_blood_pressureTextEditingController = TextEditingController();
  final TextEditingController temparatureTextEditingController = TextEditingController();
  final TextEditingController temparatureCelsiusTextEditingController = TextEditingController();
  final TextEditingController weightTextEditingController = TextEditingController();
  final TextEditingController heightFeetTextEditingController = TextEditingController();
  final TextEditingController heightInchesTextEditingController = TextEditingController();
  final TextEditingController heightCmTextEditingController = TextEditingController();
  final TextEditingController heightMeterTextEditingController = TextEditingController();
  final TextEditingController OFCTextEditingController = TextEditingController();
  final TextEditingController OFCInchesTextEditingController = TextEditingController();
  final TextEditingController waistTextEditingController = TextEditingController();
  final TextEditingController waistCmTextEditingController = TextEditingController();
  final TextEditingController hipTextEditingController = TextEditingController();
  final TextEditingController hipCmTextEditingController = TextEditingController();
  final TextEditingController rrTextEditingController = TextEditingController();
  final TextEditingController complainTextEditingController = TextEditingController();
  final TextEditingController medicineTextEditingController = TextEditingController();
  final TextEditingController improvementTextEditingController = TextEditingController();
  final TextEditingController feeTextEditingController = TextEditingController();
  final TextEditingController report_patientTextEditingController = TextEditingController();
  final TextEditingController hospitalId = TextEditingController();
  final TextEditingController patientHospitalRegId = TextEditingController();
  final TextEditingController wardNo = TextEditingController();
  final TextEditingController bedNo = TextEditingController();
  final TextEditingController cabinNo = TextEditingController();
  final TextEditingController roomNo = TextEditingController();
  RxBool isReportPatient = false.obs;
  final TextEditingController serialTextEditingController = TextEditingController();
  var patientHeight = "".obs;
  //appointment info----------------------------------------------------------------------
  //date picker

  RxString selectedNextVisitDate = "".obs;
  void selectedNextVisitMethod(value){
    var nextDate = value.toString();
    selectedNextVisitDate.value = customDateTimeFormat(DateTime.parse(nextDate));
    selectedNextVisitDate.refresh();
  }



  // save patient and appointment data to database  (box)
  Future<PatientAppointment?> savePatientAndAppointment({isSaveOnlyAppointment = false})async{

    if(selectedBloodGroup.value != "None"){
      print(selectedBloodGroup.value);
      print("object");
        blood_groupController.text = bloodGroupStringToNum(selectedBloodGroup.value).toString();
        print(blood_groupController.text);
    }

    if(temparatureCelsiusTextEditingController.text.toString().isNotEmpty){
      temparatureTextEditingController.text = celsiusToFahrenheit(parseDouble(temparatureCelsiusTextEditingController.text.toString())).toString();
    }

    if(hipTextEditingController.text.toString().isNotEmpty){
      hipCmTextEditingController.text = inchToCm(parseDouble(hipTextEditingController.text.toString())).toString();
    }
    if(waistTextEditingController.text.toString().isNotEmpty){
      waistCmTextEditingController.text = inchToCm(parseDouble(waistTextEditingController.text.toString())).toString();
    }
    if(heightCmTextEditingController.text.toString().isNotEmpty){
      var data = convertCMToHeight(heightCmTextEditingController.text.toString());
      if(data != null){
        heightFeetTextEditingController.text = data[0].toString() ;
        heightInchesTextEditingController.text = data[1].toString();
      }
      heightMeterTextEditingController.text = centimeterToMeter(parseDouble(heightCmTextEditingController.text.toString())).toString();
    }

    if(heightMeterTextEditingController.text.toString().isNotEmpty){
      heightCmTextEditingController.text = meterToCentimeter(parseDouble(heightMeterTextEditingController.text.toString())).toString();
      var data = convertCMToHeight(heightCmTextEditingController.text.toString());
      if(data != null){
        heightFeetTextEditingController.text = data[0].toString() ;
        heightInchesTextEditingController.text = data[1].toString();
      }
    }

    if(heightFeetTextEditingController.text.toString().isNotEmpty || heightInchesTextEditingController.text.toString().isNotEmpty){
      heightCmTextEditingController.text = convertHeightToCM(heightFeetTextEditingController.text.toString(), heightInchesTextEditingController.text.toString());
      heightMeterTextEditingController.text = centimeterToMeter(parseDouble(heightCmTextEditingController.text.toString())).toString();
    }



    double? weight = weightTextEditingController.text.isNotEmpty ? parseDouble(roundString(weightTextEditingController.text.toString())) : null;
    double? height = heightCmTextEditingController.text.isNotEmpty ? parseDouble(roundString(heightCmTextEditingController.text.toString())) : null;
    double? hip = hipCmTextEditingController.text.isNotEmpty ? parseDouble(roundString(hipCmTextEditingController.text.toString())) : null;
    double? waist = waistCmTextEditingController.text.isNotEmpty ? parseDouble(roundString(waistCmTextEditingController.text.toString())) : null;
    double? OFC = OFCTextEditingController.text.toString().isNotEmpty ? parseDouble(roundString(OFCTextEditingController.text.toString())) : null;

    int? pulse = parseInt(pulseTextEditingController.text.toString());
    int? sysBloodPressure = parseInt(sys_blood_pressureTextEditingController.text.toString());
    int? dysBloodPressure = parseInt(dys_blood_pressureTextEditingController.text.toString());
    int? rr = parseInt(rrTextEditingController.text.toString()); ;
    int? fee = parseInt(feeTextEditingController.text.toString());
    String? blood_group = blood_groupController.text;
    var ageY;
    var ageM;
    var ageD;
    var ageH;
    var ageMn;
    var DOB = '';
    try{
      if(ageYearController.text.isNotEmpty){
        ageY = parseInt(ageYearController.text);
      }
      if(ageMonthController.text.isNotEmpty){
        ageM = parseInt(ageMonthController.text);
      }
      if(ageDayController.text.isNotEmpty){
        ageD = parseInt(ageDayController.text);
      }
      if(ageHourController.text.isNotEmpty){
        ageH = parseInt(ageHourController.text);
      }
      if(ageMinutesController.text.isNotEmpty){
        ageMn = parseInt(ageMinutesController.text);
      }

      if(ageY != null || ageM != null || ageD != null || ageH != null || ageMn != null){
        DOB = calculateDOB(ageY ?? 0, ageM ?? 0, ageD ?? 0, ageH ?? 0, ageMn ?? 0).toString();
      };
    }catch(e){
      print(e);
    }


    if(patientNameController.text.isEmpty){
      Helpers.errorSnackBar("Failed!", "Name Field Must be not empty");

    }else if(dateController.text.toString().isEmpty){
      Helpers.errorSnackBar("Failed!", "Date must be not empty");
    }else{
        print("patient init id ${PATIENT_ID.value}");
        print("appointment init id ${APPOINTMENT_ID.value}");

        print("----------------");

      //save patient data to patient table
        PatientModel patientModel = PatientModel(
          id: PATIENT_ID.value,
          name: patientNameController.text,
          uuid: uuid,
          date: dateController.text.toString(),
          u_status: DefaultValues.NewAdd,
          web_id: DefaultValues.defaultweb_id,
          dob: DOB.toString(),
          sex: sexController.toInt(),
          marital_status: marital_statusController.value.toInt(),
          guardian_name: guardian_nameController.text.toString(),
          phone: phoneController.text,
          email: emailController.text,
          area: areaController.text,
          occupation: occupationController.text,
          education: educationController.text,
          blood_group: parseInt(blood_groupController.text.toString()),
          ageHours: 0,
          ageMin: 0,
          ageDays: 0,
          chamber_id: presPrintSetUp.activeChamberId.value.toString(),
          p_type: vetController.selectedPetType.value,
        );
      int? patient_id = await patientBoxController.savePatient(boxPatient,patientModel);
      if(patient_id != -1 && patient_id !=null){
        PATIENT_ID.value = patient_id;
        if(PATIENT_ID.value !=0 && PATIENT_ID.value !=-1){
          AppointmentModel appointmentModel =AppointmentModel(
            id: APPOINTMENT_ID.value,
            uuid:uuid,
            u_status:DefaultValues.NewAdd,
            web_id:DefaultValues.defaultweb_id,
            patient_id:PATIENT_ID.value,
            date: dateController.text.toString(),
            next_visit:  selectedNextVisitDate.value,
            appointed_by:appointmentBy,
            appointed_to:appointmentTo,
            pulse:  pulse,
            sys_blood_pressure:  sysBloodPressure,
            dys_blood_pressure: dysBloodPressure,
            temparature: temparatureTextEditingController.text.toString(),
            weight:  weight,
            height: height,
            OFC:  OFC,
            waist:  waist,
            hip:  hip,
            rr: rr,
            complain:  complainTextEditingController.text.toString() ,
            medicine:  medicineTextEditingController.text.toString() ,
            improvement: parseInt(improvementTextEditingController.text.toString()),
            fee:fee,
            status: DefaultValues.prescriptionReady,
            report_patient:  isReportPatient.value ? 1 : 0,
            serial:  parseInt(serialTextEditingController.text.toString().isNotEmpty ? serialTextEditingController.text.toString() : '1'),
            chamber_id: presPrintSetUp.activeChamberId.value.toString(),
            hospital_id: hospitalId.text,
            patient_hospital_reg_id: patientHospitalRegId.text,
            is_pregnant: isPregnant?.value,
          );
          int? appointment_id = await appointmentBoxController.saveAppointment(boxAppointment,appointmentModel);
          if(appointment_id !=-1 && appointment_id !=null){
            APPOINTMENT_ID.value = appointment_id;
            if(!isSaveOnlyAppointment){
              if(APPOINTMENT_ID.value !=0 && APPOINTMENT_ID.value !=-1){
                print("patient returned id ${PATIENT_ID.value}");
                print("appointment returned id ${APPOINTMENT_ID.value}");
                print("--------------------------");
                await  prescriptionController.getPatientAndAppointmentID(PATIENT_ID.value, APPOINTMENT_ID.value);
              }
            }
            return PatientAppointment(appointment: appointmentModel, patient: patientModel);
          }
        }
      }

    }
    return null;
  }



  //this method use for get Data from today appointment list and edit prescription list
  Future<void>  viewAppointmentDetails(patientAppointment)async{
    print("view app info: " + DateTime.now().toString());
    newAppointmentForTodayFromPatientList(patientAppointment.patient);
    AppointmentModel newAppointment = patientAppointment.appointment;
    var appointment_id= newAppointment.id;
    var uuid= newAppointment.uuid;
    var u_status= newAppointment.u_status;
    var web_id= newAppointment.web_id;
    var patient_id= newAppointment.patient_id;
    var appDate = newAppointment.date;
    var next_visit= newAppointment.next_visit;
    var appointed_by= newAppointment.appointed_by;
    var appointed_to= newAppointment.appointed_to;

    if(newAppointment.pulse !=null && newAppointment.pulse !='' && newAppointment.pulse !=0){
      pulseTextEditingController.text = newAppointment.pulse.toString();
      pulse.value ="Pulse: " + newAppointment.pulse.toString();
    }
    if(newAppointment.sys_blood_pressure !=null && newAppointment.dys_blood_pressure !=null && newAppointment.sys_blood_pressure !=0 && newAppointment.dys_blood_pressure !=0){
      sys_blood_pressureTextEditingController.text =newAppointment.sys_blood_pressure.toString();
      dys_blood_pressureTextEditingController.text =newAppointment.dys_blood_pressure.toString();
      bp1.value = "BP: " + newAppointment.sys_blood_pressure.toString() ;
      bp2.value = "/" + newAppointment.dys_blood_pressure.toString();
    }

    if(newAppointment.OFC !=null && newAppointment.OFC !='' && newAppointment.OFC !=0){
      OFCTextEditingController.text = roundString(newAppointment.OFC.toString());
      OFCInchesTextEditingController.text = cmToInch(parseDouble(newAppointment.OFC.toString())).toString();
      if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "OFCcM")){
        OFC.value = "OFC: " + roundString(newAppointment.OFC.toString()) + "cm ";
      }else{
        OFC.value = "OFC: ""${roundString(OFCInchesTextEditingController.text)} inches";
      }

    }
    if(newAppointment.rr !=null && newAppointment.rr !='' && newAppointment.rr !=0){
      rrTextEditingController.text = roundString(newAppointment.rr.toString());
      rr.value = "RR: " + roundString(newAppointment.rr.toString()) + " brpm";
    }

     if(newAppointment.complain !=null && newAppointment.complain !=''){
       complain.value = newAppointment.complain!;
       complainTextEditingController.text = newAppointment.complain.toString();
     };
     if(newAppointment.patient_hospital_reg_id !=null && newAppointment.patient_hospital_reg_id !=''){
       complainTextEditingController.text = newAppointment.patient_hospital_reg_id.toString();
     };
    if(newAppointment.medicine !=null && newAppointment.medicine !=''){
      medicineTextEditingController.text = newAppointment.medicine!;
      medicineHistory.value = "Medicine History: " + newAppointment.medicine.toString();
    }

    var status= newAppointment.status;
    isReportPatient.value = newAppointment.report_patient == 1 ? true : false;

    //appointment info
     if(next_visit !=null && next_visit !='' && next_visit != '0000-00-00 00:00:00' && next_visit != '0000-00-00'){
      if(isValidDateFormat(next_visit)){
        DateTime nextVis  = DateTime.parse(next_visit);
        selectedNextVisitMethod(nextVis);
      };
     }


     if(newAppointment.weight !=null && newAppointment.weight !='' && newAppointment.weight !=0){
      weightTextEditingController.text = roundString(newAppointment.weight.toString());
      weight.value = "Weight:" + roundString(newAppointment.weight.toString()) + " kg";
     }

    improvementTextEditingController.text = newAppointment.improvement !=null ? newAppointment.improvement.toString(): '';
    feeTextEditingController.text = newAppointment.fee !=null ? newAppointment.fee.toString(): '';
    report_patientTextEditingController.text = newAppointment.report_patient !=null ? newAppointment.report_patient.toString(): '';
    serialTextEditingController.text = newAppointment.serial !=null ? newAppointment.serial.toString(): '';


    hospitalId.text =newAppointment.hospital_id !=null ? newAppointment.hospital_id.toString() : '';


    if(newAppointment.height !=null && newAppointment.height !='' && newAppointment.height !=0){

      heightCmTextEditingController.text = newAppointment.height.toString();
      var data = convertCMToHeight(newAppointment.height.toString());
      if(data != null){
        heightFeetTextEditingController.text = data[0].toString() ;
        heightInchesTextEditingController.text = data[1].toString();
      }
      heightMeterTextEditingController.text = centimeterToMeter(parseDouble(heightCmTextEditingController.text.toString())).toString();
      if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "HeightCm")){
        height.value = "Height: ${roundString(newAppointment.height.toString()) + " cm"} ";

      }else if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "HeightMeter")){
        height.value = "Height: ${roundString(heightMeterTextEditingController.text.toString())} m";
      }else{
        height.value = "Height: ${roundString(heightFeetTextEditingController.text.toString()) + "'" + roundString(heightInchesTextEditingController.text.toString()) + "''"}";
      }

      }

     if(newAppointment.temparature.toString().isNotEmpty && newAppointment.temparature !=0){
       try{
         temparatureTextEditingController.text = roundString(newAppointment.temparature.toString());
         temparatureCelsiusTextEditingController.text = roundString(fahrenheitToCelsius(parseDouble(newAppointment.temparature.toString())).toString());
         if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "TemparatureCelsius")){
           temparature.value = "Temperature: ${roundString(temparatureCelsiusTextEditingController.text.toString())} °C ";
         }else{
           temparature.value = "Temperature: ${roundString(temparatureTextEditingController.text.toString())} °F";
         }
       }catch(e){

       }
     }
     if(newAppointment.waist !=null && newAppointment.waist !='' && newAppointment.waist !=0){
       waistTextEditingController.text = roundString(cmToInch(parseDouble(newAppointment.waist.toString())).toString());
       waistCmTextEditingController.text = roundString(newAppointment.waist.toString());
       if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "WaistCm")){
         waist.value = "Waist: ${roundString(newAppointment.waist.toString())} cm";
       }else{
         waist.value = "Waist: ${roundString(waistTextEditingController.text.toString())} inch";
       }

     }
     if(newAppointment.hip !=null && newAppointment.hip !='' && newAppointment.hip !=0){
       hipTextEditingController.text = cmToInch(parseDouble(newAppointment.hip.toString())).toString();
       hipCmTextEditingController.text = newAppointment.hip.toString();
       if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "HipCm")){
         hip.value = "Hip: ${newAppointment.hip.toString()} cm";
       }else{
         hip.value = "Hip: ${roundString(hipTextEditingController.text.toString())} inch";
       }
     }
     if(newAppointment.is_pregnant !=null && newAppointment.is_pregnant !=''){
       isPregnant?.value = newAppointment.is_pregnant.toString();
     }

    APPOINTMENT_ID.value = appointment_id;

    PATIENT_ID.value = patient_id;
    appointmentBy  =appointed_by;
    appointmentTo  =appointed_to;
    uuid = uuid;

    if(appDate !='' && appDate != '0000-00-00 00:00:00' && appDate != '0000-00-00'){
      if(isValidDateFormat(appDate)){
        dateController.text  = appDate;
      }

    }
    web_id = web_id;
  }

  Future<void> newAppointmentForTodayFromPatientList(PatientModel patientInfo)async{

    var name = patientInfo.name;
    var dob = patientInfo.dob;
    var phone = patientInfo.phone;
    var patient_Id = patientInfo.id;
    var guardian_name = patientInfo.guardian_name;
    var email = patientInfo.email;
    var area = patientInfo.area;
    var occupation = patientInfo.occupation;
    var education = patientInfo.education;

    patientNameController.text = name ?? '';
    guardian_nameController.text =guardian_name ?? '';
    phoneController.text =phone ?? '';
    emailController.text =email ?? '';
    areaController.text = area ?? '';
    occupationController.text =occupation ?? '';
    educationController.text =education ?? '';
    PATIENT_ID.value = patient_Id;

    if(dob !=null && dob !=''){
        try{
          var age = calculateAge(DateTime.parse(dob));
          ageYearController.text = age.years.toString();
          ageMonthController.text = age.months.toString();
          ageDayController.text = age.days.toString();
          ageHourController.text = age.hours.toString();
          ageMinutesController.text = age.minutes.toString();
        }catch(e){
          if(e is FormatException){
             var dobs = dob.split("-");
            var ageError =calculateAge(DateTime.parse(dobs[2] + "-" + dobs[1] + "-" + dobs[0] + " 00:00:00"));
            print(ageError);
            ageYearController.text = ageError.years.toString();
            ageMonthController.text = ageError.months.toString();
            ageDayController.text = ageError.days.toString();
            ageHourController.text = ageError.hours.toString();
            ageMinutesController.text = ageError.minutes.toString();
          }
        }
    }
      if(patientInfo.sex !=null && patientInfo.sex !=''){
          sexController.value =  patientInfo.sex!;
      }
      if(patientInfo.marital_status !=null && patientInfo.marital_status !=''){
        marital_statusController.value =  patientInfo.marital_status!;
      }
      if(PATIENT_ID.value !=-1 && PATIENT_ID.value !=0){
        await  prescriptionController.getPatientAndAppointmentID(PATIENT_ID.value, APPOINTMENT_ID.value);
      }

      if(patientInfo.blood_group !=null && patientInfo.blood_group !=''){
         selectedBloodGroup.value = bloodGroupNumToString(patientInfo.blood_group.toString());
         selectedBloodGroupCont.text = bloodGroupNumToString(patientInfo.blood_group.toString());

      }
      if(patientInfo.p_type !=null && patientInfo.p_type !=''){
        vetController.selectedPetType.value = patientInfo.p_type!;
      }

  }



  Future<void> updateData(id)async{
    await commonController.updateCommon(boxAppointment, id, nameController.text.trim(), DefaultValues.Update);
    nameController.clear();
    allAppointmentList.refresh();
    // isLoading.value = false;

  }



  Future<void> deleteData(id)async{
    try {
      await commonController.deleteCommon(boxAppointment, id, statusDelete);
      getAllData('');
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting data: $e");
      }
    }
    // isLoading = false;
  }

  // get all patient and appointment data from database
  Future<void> getAllData(String searchText)async{
    patientAppointmentList.clear();
    var responseAppointment = await appointmentBoxController.getAllDataAppointment(boxAppointment, '');
    var responsePatient = await patientBoxController.getAllPatient(boxPatient, searchText);
    if(responsePatient.isNotEmpty && responseAppointment.isNotEmpty){
      for(var appointment in responseAppointment){
        if(responsePatient.any((element) => element.id == appointment.patient_id)){
          PatientAppointment patientAppointment = PatientAppointment(
              appointment: appointment,
              patient: responsePatient.firstWhere((element) => element.id == appointment.patient_id)
          );
          patientAppointmentList.add(patientAppointment);
        }
      }
    }
    var toDayDate = customDateTimeFormat(DateTime.parse(DateTime.now().toString().substring(0,10)));
    var serial = responseAppointment.where((element) => element.date == toDayDate).length;
    if(serial == 0){
      serialTextEditingController.text = '1';
    }else{
      serialTextEditingController.text = (serial+1).toString();
    }
    patientAppointmentList.sort((a, b) => b.appointment.id.compareTo(a.appointment.id));
    patientAndAppointmentInfoJoin.refresh();
    isLoading.value = false;
    if(patientAppointmentList.isNotEmpty){
     await modifyTodayAppointmentList(patientAppointmentList);
    }
  }
  Future<void> modifyTodayAppointmentList(List appointments) async {
    // Create a copy of the list for iteration

    // for (var appointment in appointmentsCopy) {
    //   // Modify the original list safely here
    //   if (/* some condition */) {
    //     appointments.remove(appointment); // Safe to remove from original list
    //   }
    // }
    dropdownItemsX.clear();
     for(var i = 0; i < appointments.length; i++){
       var item = appointments[i];
       AppointmentModel appointment = item.appointment;
       var date = appointment.date.toString();
       var dateNow = customDateTimeFormat(DateTime.now());
       if(date == dateNow){
         var res = await tetClinicalData(item.appointment.id);
         var data = {
           'appointment': item.appointment,
           'patient': item.patient,
           'additional_data': res.toString()
         };
         dropdownItemsX.add(data);
       }
     }
     }


  //  Future<void> getAllPatientData(String searchText)async{
  //   isLoading.value = true;
  //   var response = await patientBoxController.getAllPatient(boxPatient, searchText);
  //   patientInfo.addAll(response);
  //   patientAndAppointmentInfoJoin.refresh();
  //   isLoading.value = false;
  // }


  Future<void> InitialData()async{
    await getAllData('');
  }



  clearText()async{
    allAppointmentList.clear();
    nameController.clear();
    searchController.clear();
    await getAllData('');
  }



  //this method called 2 method (1 save appointment data and 2 save prescription data)
  prescriptionSave(prescriptionData,context)async{
    //this method for save appointment and patient data save to database
    await savePatientAndAppointment();
    //this method for save prescription data save to database with printing
    // await prescriptionController.savePrescription(prescriptionData, context);

  }
 oECollection()async{
   await prescriptionController.getOEFindingFromApp("weight", weightTextEditingController.text,);
 }
 cancelAppointment(APP_ID)async{
   await appointmentBoxController.appointmentCancel(boxAppointment, APP_ID);
   InitialData();
 }
  @override
  void onInit() {
    // TODO: implement onInit
    InitialData();
    dateController.text = customDateTimeFormat(DateTime.parse(DateTime.now().toString().substring(0,10)));

    //oe findings
    sys_blood_pressureTextEditingController.addListener(() {
      if(sys_blood_pressureTextEditingController.text.length >0){
       bp1.value = "BP : " + sys_blood_pressureTextEditingController.text + "/";
      };
       if(sys_blood_pressureTextEditingController.text.isEmpty){
         bp1.value ="";
       }
    });
    dys_blood_pressureTextEditingController.addListener(() {
      if(dys_blood_pressureTextEditingController.text.length >0){
        bp2.value = dys_blood_pressureTextEditingController.text;
      };

    });
    temparatureTextEditingController.addListener(() {
      if(temparatureTextEditingController.text.length >0){
       temparature.value ="Temperature : " +  temparatureTextEditingController.text + " °F";
      };
       if(temparatureTextEditingController.text.isEmpty){
         temparature.value ="";
       }
    });
    temparatureCelsiusTextEditingController.addListener(() {
      if(temparatureCelsiusTextEditingController.text.length >0){
      temparature.value ="Temperature : " + temparatureCelsiusTextEditingController.text + " °C";
      };
      if(temparatureCelsiusTextEditingController.text.isEmpty){
        temparature.value ="";
      }
    });

    weightTextEditingController.addListener(() {
      if(weightTextEditingController.text.toString().length >0){
        weight.value = "Weight : " + weightTextEditingController.text + " kg";
      };
      if(weightTextEditingController.text.toString().isEmpty){
        print(weightTextEditingController.text.toString().length);
        weight.value = "";
      }
    });


    heightFeetTextEditingController.addListener(() {
      if(heightFeetTextEditingController.text.length >0){
       height.value = "Height : " + "${roundString(heightFeetTextEditingController.text)}" + " ft";
      };
       if(heightFeetTextEditingController.text.isEmpty){
         height.value ="";
       }
    });


    heightInchesTextEditingController.addListener(() {
      if(heightInchesTextEditingController.text.length >0){
        height.value = height.value + "/" + heightInchesTextEditingController.text + " inches";
      }
    });


      heightCmTextEditingController.addListener(() {
        if(heightCmTextEditingController.text.length >0){
          height.value ="Height : " + heightCmTextEditingController.text + " cm";
        };
        if(heightCmTextEditingController.text.isEmpty){
          height.value ="";
        }
      });


      heightMeterTextEditingController.addListener(() {
        if(heightMeterTextEditingController.text.length >0){
          height.value = "Height : " + roundString(heightMeterTextEditingController.text) + " m";
        };
        if(heightMeterTextEditingController.text.isEmpty){
          height.value ="";
        }
      });


    OFCTextEditingController.addListener(() {
      if(OFCTextEditingController.text.length >0){
       OFC.value = "OFC : " + OFCTextEditingController.text + " cm";
      };
       if(OFCTextEditingController.text.isEmpty){
         OFC.value ="";
       }
    });
    OFCInchesTextEditingController.addListener(() {
      if(OFCInchesTextEditingController.text.length >0){
       OFC.value =  "OFC : " + OFCInchesTextEditingController.text + " inches";
      };
       if(OFCInchesTextEditingController.text.isEmpty){
         OFC.value ="";
       }
    });
    waistTextEditingController.addListener(() {
      if(waistTextEditingController.text.length >0){
       waist.value = "Waist : " + waistTextEditingController.text + " inches";
      };
       if(waistTextEditingController.text.isEmpty){
         waist.value ="";
       }
    });
    waistCmTextEditingController.addListener(() {
      if(waistCmTextEditingController.text.length >0){
       waist.value = "Waist : " + waistCmTextEditingController.text + " cm";
      };
       if(waistCmTextEditingController.text.isEmpty){
         waist.value ="";
       }
    });

    hipTextEditingController.addListener(() {
      if(hipTextEditingController.text.length >0){
       hip.value = "Hip : " + hipTextEditingController.text + " inches";
      };
       if(hipTextEditingController.text.isEmpty){
         hip.value ="";
       }
    });
    hipCmTextEditingController.addListener(() {
      if(hipCmTextEditingController.text.length >0){
       hip.value = "Hip : " + hipCmTextEditingController.text + " cm";
      };
       if(hipCmTextEditingController.text.isEmpty){
         hip.value ="";
       }
    });
    rrTextEditingController.addListener(() {
      if(rrTextEditingController.text.length >0){
       rr.value = "RR : " + rrTextEditingController.text + " brpm";
      };
       if(rrTextEditingController.text.isEmpty){
         rr.value ="";
       }
    });
    medicineTextEditingController.addListener(() {
      if(medicineTextEditingController.text.length >0){
      medicineHistory.value = "Drug History : " + medicineTextEditingController.text;
      };
      if(medicineTextEditingController.text.isEmpty){
        medicineHistory.value ="";
      }
    });

    pulseTextEditingController.addListener(() {
      if(pulseTextEditingController.text.length >0){
        pulse.value = "Pulse : " + pulseTextEditingController.text;
      };
      if(pulseTextEditingController.text.isEmpty){
        pulse.value ="";
      }
    });
    complainTextEditingController.addListener(() {

      if(complainTextEditingController.text.length >0){
        complain.value =complainTextEditingController.text;
      };
      if(complainTextEditingController.text.isEmpty){
        complain.value ="";
      }
    });



    super.onInit();
  }



  @override
  void dispose() {
    allAppointmentList;
    weightTextEditingController.removeListener(oECollection);
    ageYearController.dispose();
    ageMonthController.dispose();
    ageDayController.dispose();
    ageHourController.dispose();
    ageMinutesController.dispose();
    patientNameController.dispose();
    guardian_nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    areaController.dispose();
    occupationController.dispose();
    educationController.dispose();
    blood_groupController.dispose();
    dobTextController.dispose();
    pulseTextEditingController.dispose();
    sys_blood_pressureTextEditingController.dispose();
    dys_blood_pressureTextEditingController.dispose();
    temparatureTextEditingController.dispose();
    temparatureCelsiusTextEditingController.dispose();
    weightTextEditingController.dispose();
    heightFeetTextEditingController.dispose();
    heightInchesTextEditingController.dispose();
    heightCmTextEditingController.dispose();
    heightMeterTextEditingController.dispose();
    OFCTextEditingController.dispose();
    OFCInchesTextEditingController.dispose();
    waistTextEditingController.dispose();
    waistCmTextEditingController.dispose();
    hipTextEditingController.dispose();
    hipCmTextEditingController.dispose();
    rrTextEditingController.dispose();
    complainTextEditingController.dispose();
    medicineTextEditingController.dispose();
    improvementTextEditingController.dispose();
    feeTextEditingController.dispose();
    report_patientTextEditingController.dispose();
    hospitalId;
    serialTextEditingController.dispose();
    commonController;
    patientBoxController;
    appointmentBoxController;
    prescriptionController.dispose();
    investigationReportImageController.dispose();
    presPrintSetUp.dispose();
    allAppointmentList;
    patientInfo;
    patientAndAppointmentInfoJoin;
    searchDataList;

    super.dispose();
  }

}



