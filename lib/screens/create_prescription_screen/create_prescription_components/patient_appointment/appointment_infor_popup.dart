import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:dims_vet_rx/controller/vet_controller/vet_controller.dart';

import '../../../../controller/appointment/appointment_controller.dart';
import '../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../controller/general_setting/general_setting_controller.dart';
import '../../../../utilities/app_icons.dart';
import '../../../../utilities/app_strings.dart';
import '../../../../utilities/style.dart';
import '../../../../utilities/helpers.dart';
import '../../../others_data_screen/pet_type.dart';
import 'blood_group_collect_modal.dart';



Widget appointmentInfoModal(BuildContext context){
  final GeneralSettingController generalSettingController = Get.put(GeneralSettingController());
  final AppointmentController appointmentController = Get.put(AppointmentController());
  final AppointmentController patientController = Get.put(AppointmentController());
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final vatController = Get.put(VetController());
  final StyleConstant styleConstant = Get.put(StyleConstant());
  return Container(
    child: SingleChildScrollView(
      child: Column(
        children: [
        SizedBox(height: 10,),
           Wrap(
            runSpacing: 10,
            spacing: 10,
            children: [
              InputFieldForAppointmentNumber("Serial", "Serial No-1", appointmentController.serialTextEditingController, appointmentController.serialTextEditingController, TextInputType.numberWithOptions(decimal: true)),
              SizedBox(
                width:  styleConstant.formWidthM,
                height: styleConstant.formHeight,
                child:  TextFormField(
                  controller: appointmentController.dateController,
                  onTap: ()async{
                    final newDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101), initialDate: DateTime.now(),
                    );
                    if (newDate != null) {
                      appointmentController.dateController.text = customDateTimeFormat(newDate).toString();
                      if (kDebugMode) {
                        print(newDate);
                      }
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Appointment Date",
                  ),
                  readOnly: true,
                ),
              ),

              Container(width: MediaQuery.of(context).size.width * 0.115,),
            ],
           ),


          Obx(() => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Wrap(
              runSpacing: 20.0,
              spacing: 30.0,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Personal Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Name") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Name"))
                  InputFieldForAppointmentText("Patient Name *","Mamun Khan", patientController.patientNameController, patientController.patientNameController, TextInputType.text),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Age") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Age"))
                  SizedBox(
                    width:  styleConstant.formWidthM,
                    height: styleConstant.formHeight,
                    child:   InputFieldForAppointmentNumber("Age (Year)", "30 years", patientController.ageYearController, patientController.ageYearController, TextInputType.numberWithOptions(decimal: true)),
                  ),


                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "AgeInfant") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "AgeInfant"))
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        )
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        SizedBox(
                          width:  styleConstant.formWidthS,
                          height: styleConstant.formHeight,
                          child:   InputFieldForAppointmentNumber("Age y", "30 years", patientController.ageYearController, patientController.ageYearController, TextInputType.numberWithOptions(decimal: true)),
                        ),

                        SizedBox(
                          width:  styleConstant.formWidthS,
                          height: styleConstant.formHeight,
                          child: InputFieldForAppointmentNumber("Age m", "4 months", patientController.ageMonthController, patientController.ageMonthController, TextInputType.numberWithOptions(decimal: true)),
                        ),


                        SizedBox(
                          width:  styleConstant.formWidthS,
                          height: styleConstant.formHeight,
                          child: InputFieldForAppointmentNumber("Age d", "10 days", patientController.ageDayController, patientController.ageDayController, TextInputType.numberWithOptions(decimal: true)),
                        ) ,


                        SizedBox(
                          width:  styleConstant.formWidthS,
                          height: styleConstant.formHeight,
                          child: InputFieldForAppointmentNumber("Age h","10 hours", patientController.ageHourController, patientController.ageHourController, TextInputType.numberWithOptions(decimal: true)),
                        )  ,

                        SizedBox(
                          width:  styleConstant.formWidthS,
                          height: styleConstant.formHeight,
                          child: InputFieldForAppointmentNumber("Age Min","10 Minutes", patientController.ageMinutesController, patientController.ageMinutesController, TextInputType.numberWithOptions(decimal: true)),
                        )
                      ],
                    ),
                  ),


                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Gender") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Gender"))
                  Container(
                    width:  styleConstant.formWidthL,
                    height: styleConstant.formHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Radio(
                            value: 1,
                            groupValue: patientController.sexController.value,
                            onChanged: (value){
                              patientController.sexController.value = value!;
                            }),
                        const Text("Male"),

                        Radio(
                            value: 2,
                            groupValue: patientController.sexController.value,
                            onChanged: (value){
                              patientController.sexController.value = value!;
                            }),
                        const Text("Female"),
                        // Radio(value: "Other", groupValue: createPrescriptionController.selectedGender.value, onChanged: (value){
                        //   createPrescriptionController.selectedGender.value = value!;
                        // }),

                        Radio(
                            value: 3,
                            groupValue: patientController.sexController.value,
                            onChanged: (value){
                              patientController.sexController.value = value!;
                            }),
                        const Text("Others"),

                        IconButton(onPressed: (){
                          patientController.sexController.value = 0;
                        }, icon: AppIcons.inputFieldDataClear),
                      ],
                    ),
                  ),
                if(patientController.sexController.value == 2)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      height: styleConstant.formHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey,
                        ),

                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Radio(
                              value: "Pregnant",
                              groupValue: patientController.isPregnant?.value,
                              onChanged: (value){
                                patientController.isPregnant?.value = value!;
                              }),
                          const Text("Pregnant"),
                          Radio(
                              value: "Non Pregnant",
                              groupValue: patientController.isPregnant?.value,
                              onChanged: (value){
                                patientController.isPregnant?.value = value!;
                              }),
                          const Text("Non Pregnant"),
                          IconButton(onPressed: (){
                            patientController.isPregnant?.value = "";
                          }, icon: AppIcons.inputFieldDataClear),

                          // Radio(value: "Other", groupValue: createPrescriptionController.selectedGender.value, onChanged: (value){
                          //   createPrescriptionController.selectedGender.value = value!;
                          // }),
                          // const Text("Other"),
                        ],
                      ),
                    ),
                  ),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "DOB") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "DOB"))
                  SizedBox(
                    width:  styleConstant.formWidthM,
                    height: styleConstant.formHeight,
                    child:  TextFormField(
                      controller: patientController.dobTextController,
                      onTap: ()async{
                        var newDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2101),  initialDate: DateTime.now(),
                        );
                          if (newDate != null) {
                            print(newDate);
                            // Show time picker after selecting the date
                            TimeOfDay? selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(), // Default time to show
                            );
                            if(selectedTime != null){
                                newDate = DateTime(newDate.year, newDate.month, newDate.day, selectedTime.hour, selectedTime.minute);
                            }
                              appointmentController.ageYearController.text = calculateAge(newDate).years.toString();
                              appointmentController.ageMonthController.text = calculateAge(newDate).months.toString();
                              appointmentController.ageDayController.text = calculateAge(newDate).days.toString();
                              appointmentController.ageHourController.text = calculateAge(newDate).hours.toString();
                              appointmentController.ageMinutesController.text = calculateAge(newDate).minutes.toString();
                              patientController.dobTextController.text = newDate.toString().substring(0,10);
                          }

                      },
                      decoration: InputDecoration(
                          label: Text("DOB"),
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(onPressed: (){
                            patientController.dobTextController.clear();
                          }, icon: AppIcons.inputFieldDataClear)
                      ),
                      readOnly: true,
                    ),
                  ),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "MaritalStatus") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "MaritalStatus"))
                  Container(
                    height: styleConstant.formHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                            value: 1,
                            groupValue: patientController.marital_statusController.value,
                            onChanged: (value){
                              patientController.marital_statusController.value = value!;
                            }),
                        const Text("Unmarried"),

                        Radio(
                            value: 2,
                            groupValue: patientController.marital_statusController.value,
                            onChanged: (value){
                              patientController.marital_statusController.value = value!;
                            }),
                        const Text("Married"),

                        IconButton(onPressed: (){
                          patientController.marital_statusController.value = 0;
                        }, icon: AppIcons.inputFieldDataClear),
                      ],
                    ),
                  ),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Education") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Education"))
                  InputFieldForAppointmentText("Education","BSc", appointmentController.educationController, appointmentController.educationController, TextInputType.text),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Occupation") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Occupation"))
                  InputFieldForAppointmentText("Occupation","Engineer", appointmentController.occupationController, appointmentController.occupationController, TextInputType.text),


                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Address") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Address"))
                  InputFieldForAppointment("Address","Mirpur-1", appointmentController.areaController, appointmentController.areaController, TextInputType.text),



                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "GuardiaName") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "GuardiaName"))
                  InputFieldForAppointmentText("Guardian Name","Mr. XYZ", appointmentController.guardian_nameController, appointmentController.guardian_nameController, TextInputType.text),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Phone") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Phone"))
                  InputFieldForAppointmentNumber("Phone","019********", patientController.phoneController, patientController.phoneController, TextInputType.numberWithOptions(decimal: true)),


                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Email") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Email"))
                  InputFieldForAppointment("Email","mamun@gmail.com", appointmentController.emailController, appointmentController.emailController, TextInputType.emailAddress),


                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "HospitalId" ) && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "HospitalId"))
                  InputFieldForAppointment("Hospital/Clinic PID","edg: 34433", appointmentController.hospitalId, appointmentController.hospitalId, TextInputType.text),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "PatientRegNo" ) && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "PatientRegNo"))
                  InputFieldForAppointment("Patient Reg No ","edg: 12144", appointmentController.patientHospitalRegId, appointmentController.patientHospitalRegId, TextInputType.text),

                Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text("Clinical Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),

                 ],
               ),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "BP") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "BP"))
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: styleConstant.formWidthS,
                          child: InputFieldForAppointmentNumber("BP (Systolic)", "BP 180", patientController.sys_blood_pressureTextEditingController, patientController.sys_blood_pressureTextEditingController,TextInputType.numberWithOptions(decimal: true))),
                      Text(" | "),
                      SizedBox(
                          width: styleConstant.formWidthS,
                          child: InputFieldForAppointmentNumber("BP (Diastolic)","BP 80", patientController.dys_blood_pressureTextEditingController, patientController.dys_blood_pressureTextEditingController,TextInputType.numberWithOptions(decimal: true))),
                    ],
                  ),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Pulse") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Pulse"))
                  InputFieldForAppointmentNumber("Pulse (bpm)", "100", patientController.pulseTextEditingController, patientController.pulseTextEditingController, TextInputType.numberWithOptions(decimal: true)),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Temperature") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Temperature"))
                  InputFieldForAppointmentNumber("Temperature (Fahrenheit)","100", appointmentController.temparatureTextEditingController, appointmentController.temparatureTextEditingController, TextInputType.numberWithOptions(decimal: true)),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "TemperatureCelsius") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "TemperatureCelsius"))
                  InputFieldForAppointmentNumber("Temperature (Celsius)", "37.5", appointmentController.temparatureCelsiusTextEditingController, appointmentController.temparatureCelsiusTextEditingController, TextInputType.numberWithOptions(decimal: true)),


                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "RR") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "RR"))
                  InputFieldForAppointmentNumber("RR (brpm)", "15 per/minute", appointmentController.rrTextEditingController, appointmentController.rrTextEditingController, TextInputType.numberWithOptions(decimal: true)),



                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "BloodGroup") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "BloodGroup"))
                // InputFieldForAppointment("Blood Group", appointmentController.blood_groupController, appointmentController.blood_groupController, TextInputType.text),
                  SizedBox(
                    width:  styleConstant.formWidthM,
                    height: styleConstant.formHeight,
                    child:  TextField(
                      readOnly: true,
                      controller: appointmentController.selectedBloodGroupCont,
                      onTap: ()async{
                        bloodGroupModal(context);
                      },
                      decoration: InputDecoration(
                          labelText: "Blood Group",
                          // label: appointmentController.selectedBloodGroup.value.toString().isNotEmpty ? Text(appointmentController.selectedBloodGroup.value.toString()) : Text("Blood Group"),

                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(onPressed: (){
                            appointmentController.selectedBloodGroup.value = "";
                          }, icon: AppIcons.inputFieldDataClear)
                        // hintText:  appointmentController.selectedBloodGroup.value.toString().isNotEmpty ? appointmentController.selectedBloodGroup.value.toString() : "",
                      ),
                      // readOnly: true,

                    ),
                  ),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Weight") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Weight"))
                  InputFieldForAppointmentNumber("Weight","50 Kg", patientController.weightTextEditingController, patientController.weightTextEditingController, TextInputType.numberWithOptions(decimal: true)),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "HeightCm") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "HeightCm"))
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width:  styleConstant.formWidthM,
                        height: styleConstant.formHeight,
                        child: InputFieldForAppointmentNumber("Height (cm)", "180cm", appointmentController.heightCmTextEditingController, appointmentController.heightCmTextEditingController, TextInputType.numberWithOptions(decimal: true)),),
                    ],
                  ),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Height") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Height"))
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width:  styleConstant.formWidthS,
                        child: InputFieldForAppointmentNumber("Height (Ft)", "5ft", appointmentController.heightFeetTextEditingController, appointmentController.heightFeetTextEditingController, TextInputType.numberWithOptions(decimal: true)),),
                      Text(" | "),
                      SizedBox(
                        width:  styleConstant.formWidthS,
                        child: InputFieldForAppointmentNumber("Height (Inc)","6in", appointmentController.heightInchesTextEditingController, appointmentController.heightInchesTextEditingController, TextInputType.numberWithOptions(decimal: true)),),
                    ],
                  ),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "HeightMeter") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "HeightMeter"))
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width:  styleConstant.formWidthM,
                        height: styleConstant.formHeight,
                        child: InputFieldForAppointmentNumber("Height (Meter)", "2 m", appointmentController.heightMeterTextEditingController, appointmentController.heightMeterTextEditingController, TextInputType.numberWithOptions(decimal: true)),),
                    ],
                  ),




                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "OFCcM") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "OFCcM"))
                  InputFieldForAppointmentNumber("OFC (cm)","30cm", appointmentController.OFCTextEditingController, appointmentController.OFCTextEditingController, TextInputType.numberWithOptions(decimal: true)),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "OFC") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "OFC"))
                  InputFieldForAppointmentNumber("OFC (Inch)","30inch ", appointmentController.OFCInchesTextEditingController, appointmentController.OFCInchesTextEditingController, TextInputType.numberWithOptions(decimal: true)),


                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Hip") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Hip"))
                  InputFieldForAppointmentNumber("Hip (Inch)","", appointmentController.hipTextEditingController, appointmentController.hipTextEditingController, TextInputType.numberWithOptions(decimal: true)),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "HipCm") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "HipCm"))
                  InputFieldForAppointmentNumber("Hip (cm)","", appointmentController.hipCmTextEditingController, appointmentController.hipCmTextEditingController, TextInputType.numberWithOptions(decimal: true)),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Waist") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Waist"))
                  InputFieldForAppointmentNumber("Waist (Inch)","32", appointmentController.waistTextEditingController, appointmentController.waistTextEditingController, TextInputType.numberWithOptions(decimal: true)),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "WaistCm") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "WaistCm"))
                  InputFieldForAppointmentNumber("Waist (cm)","64", appointmentController.waistCmTextEditingController, appointmentController.waistTextEditingController, TextInputType.numberWithOptions(decimal: true)),

                ElevatedButton(onPressed: (){
                  petType(context);
                }, child: vatController.selectedPetType.value.isNotEmpty ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${vatController.selectedPetType.value}"),
                    IconButton(onPressed: (){
                      vatController.selectedPetType.value = "";

                    }, icon: Icon(Icons.clear))
                  ],
                ) : Text("Select Pet Type")),
                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "ReportPatient") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "ReportPatient"))
                  Container(
                    width:  styleConstant.formWidthM,
                    height: styleConstant.formHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey,
                      ),),
                    child:  CheckboxListTile(
                      title: Text('Report Patient'),
                      value: appointmentController.isReportPatient.value,
                      onChanged: (bool? value) {
                        appointmentController.isReportPatient.value = value!;
                      },
                    ),
                  ),
                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Complain") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Complain"))
                  Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Patient Complaint", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Complain") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Complain"))
                  InputFieldForAppointmentDrugHistory("Patient Complaint", "Fever for 5 days", appointmentController.complainTextEditingController, appointmentController.complainTextEditingController, TextInputType.text),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "MedicineTaken") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "MedicineTaken"))
                  Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Drug History", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "MedicineTaken") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "MedicineTaken"))
                  InputFieldForAppointmentDrugHistory("Medicine taken", "Napa 500mg", appointmentController.medicineTextEditingController, appointmentController.medicineTextEditingController, TextInputType.text),

                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Fee") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Fee"))
                  Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Fee", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
                if(!generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Fee") && generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.appointment && element['label'] == "Fee"))
                  InputFieldForAppointmentNumber("Fee","500 BDT", appointmentController.feeTextEditingController, appointmentController.feeTextEditingController, TextInputType.numberWithOptions(decimal: true)),


              ],
            ),
          ),),
          SizedBox(height: 10,),
        ],
      )
    ),
  );
}