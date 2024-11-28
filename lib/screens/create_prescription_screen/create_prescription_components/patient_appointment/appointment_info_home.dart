import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:dims_vet_rx/controller/vet_controller/vet_controller.dart';
import 'package:dims_vet_rx/screens/others_data_screen/pet_type.dart';

import '../../../../controller/appointment/appointment_controller.dart';
import '../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../controller/drawer_controller/drawer_controller.dart';
import '../../../../controller/general_setting/general_setting_controller.dart';
import '../../../../utilities/app_icons.dart';
import '../../../../utilities/app_strings.dart';
import '../../../../utilities/style.dart';
import '../../../../utilities/helpers.dart';
import '../../popup_screen.dart';
import '../clinical_data/left_clinical_widget.dart';
import 'appointment_infor_popup.dart';
import 'blood_group_collect_modal.dart';


void showTopSheet(BuildContext context) {
  OverlayEntry? overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.grey,
        child: Card(
          child: SingleChildScrollView(
            child: Column(
              children: [
                appointmentInfoFrontPageWidget(context, false),
                const SizedBox(height: 10,),
                FilledButton(
                  onPressed: () {
                    overlayEntry!.remove();
                    // Navigator.pop(context);
                  },
                  child: const Text('Save and Close'),
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  Overlay.of(context).insert(overlayEntry);
}

Widget appointmentInfoFrontPageWidget(context, buttonVisible){
  final GeneralSettingController generalSettingController = Get.put(GeneralSettingController());
  final AppointmentController appointmentController = Get.put(AppointmentController());
  final AppointmentController patientController = Get.put(AppointmentController());
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final screenHeight = MediaQuery.of(context).size.height;
  final StyleConstant styleConstant = Get.put(StyleConstant());
  final DrawerMenuController drawerMenuController = Get.put(DrawerMenuController());
  final vatController = Get.put(VetController());
  final TextEditingController blood_groupController = TextEditingController();
  final TextEditingController heightTextEditingController = TextEditingController();
  final TextEditingController improvementTextEditingController = TextEditingController();
  final TextEditingController report_patientTextEditingController = TextEditingController();

  return  Obx(() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            child: Wrap(
              runSpacing: 8.0,
              spacing: 8.0,
              children: [


                // Container(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text("Basic Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ),),
                //       Container(
                //         color: Colors.blueGrey,
                //         width: MediaQuery.of(context).size.width * 0.6,
                //         height: 1,
                //       )
                //     ],
                //   ),
                // ),
                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Name"))
                  InputFieldForAppointmentText("Patient Name *", "Mamun Khan", patientController.patientNameController, patientController.patientNameController, TextInputType.text),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Phone"))
                  InputFieldForAppointmentNumber("Phone","019111111111", patientController.phoneController, patientController.phoneController, TextInputType.numberWithOptions(decimal: true)),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Age"))
                  SizedBox(
                    width:  styleConstant.formWidthM,
                    height: styleConstant.formHeight,
                    child:   InputFieldForAppointmentNumber("Age y", "30 years", patientController.ageYearController, patientController.ageYearController, TextInputType.numberWithOptions(decimal: true)),
                  ),
                  if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "AgeInfant"))
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
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
                        )  ,

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

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Gender"))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      width:  styleConstant.formWidthL,
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
                              value: 1,
                              groupValue: patientController.sexController.value,
                              onChanged: (value){
                                patientController.sexController.value = value!;
                                patientController.isPregnant?.value = '';
                              }),
                          const Text("Male"),
                          Radio(
                              value: 2,
                              groupValue: patientController.sexController.value,
                              onChanged: (value){
                                patientController.sexController.value = value!;
                              }),
                          const Text("Female"),

                          Radio(
                              value: 3,
                              groupValue: patientController.sexController.value,
                              onChanged: (value){
                                patientController.sexController.value = value!;
                                patientController.isPregnant?.value = '';
                              }),
                          const Text("Others"),
                          IconButton(onPressed: (){
                            patientController.isPregnant?.value = '';
                            patientController.sexController.value = 0;
                          }, icon: AppIcons.inputFieldDataClear),

                          // Radio(value: "Other", groupValue: createPrescriptionController.selectedGender.value, onChanged: (value){
                          //   createPrescriptionController.selectedGender.value = value!;
                          // }),
                          // const Text("Other"),
                        ],
                      ),
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

                // Container(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text("Clinical Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ),),
                //       Container(
                //         color: Colors.blueGrey,
                //         width: MediaQuery.of(context).size.width * 0.6,
                //         height: 1,
                //       )
                //     ],
                //   ),
                // ),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Weight"))
                  InputFieldForAppointmentNumber("Weight","50 Kg", patientController.weightTextEditingController, patientController.weightTextEditingController, TextInputType.numberWithOptions(decimal: true)),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "BP"))
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: styleConstant.formWidthS,
                          child: InputFieldForAppointmentNumber("BP 180", "BP 180", patientController.sys_blood_pressureTextEditingController, patientController.sys_blood_pressureTextEditingController,TextInputType.numberWithOptions(decimal: true))),
                      Text(" | "),
                      SizedBox(
                          width: styleConstant.formWidthS,
                          child: InputFieldForAppointmentNumber("BP 80","BP 80", patientController.dys_blood_pressureTextEditingController, patientController.dys_blood_pressureTextEditingController,TextInputType.numberWithOptions(decimal: true))),
                    ],
                  ),
                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Pulse"))
                  InputFieldForAppointmentNumber("Pulse", "100", patientController.pulseTextEditingController, patientController.pulseTextEditingController, TextInputType.numberWithOptions(decimal: true)),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Temperature"))
                  InputFieldForAppointmentNumber("Temperature (Fahrenheit)","100", appointmentController.temparatureTextEditingController, appointmentController.temparatureTextEditingController, TextInputType.numberWithOptions(decimal: true)),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "TemperatureCelsius"))
                  InputFieldForAppointmentNumber("Temperature (Celsius)", "37.5", appointmentController.temparatureCelsiusTextEditingController, appointmentController.temparatureCelsiusTextEditingController, TextInputType.numberWithOptions(decimal: true)),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Height"))
                  InputFieldForAppointmentNumber("Height Feet", "5ft", appointmentController.heightFeetTextEditingController, appointmentController.heightFeetTextEditingController, TextInputType.numberWithOptions(decimal: true)),


                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Height"))
                  InputFieldForAppointmentNumber("Height Inches","6in", appointmentController.heightInchesTextEditingController, appointmentController.heightInchesTextEditingController, TextInputType.numberWithOptions(decimal: true)),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Height"))
                  InputFieldForAppointmentNumber("Height CM", "180cm", appointmentController.heightCmTextEditingController, appointmentController.heightCmTextEditingController, TextInputType.numberWithOptions(decimal: true)),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "HeightMeter"))
                  InputFieldForAppointmentNumber("Height Meeter", "2 m", appointmentController.heightMeterTextEditingController, appointmentController.heightMeterTextEditingController, TextInputType.numberWithOptions(decimal: true)),


                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "MaritalStatus"))
                Container(
                  width:  styleConstant.formWidthM,
                  height: styleConstant.formHeight,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Complain"))
                  InputFieldForAppointment("Complain","Fever for 5days", appointmentController.complainTextEditingController, appointmentController.complainTextEditingController, TextInputType.text),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Address"))
                  InputFieldForAppointment("Address","Mirpur-1",appointmentController.areaController, appointmentController.areaController, TextInputType.text),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Education"))
                  InputFieldForAppointmentText("Education", "BSc", appointmentController.educationController, appointmentController.educationController, TextInputType.text),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Occupation"))
                  InputFieldForAppointmentText("Occupation", "Engineer", appointmentController.occupationController, appointmentController.occupationController, TextInputType.text),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "GuardiaName"))
                  InputFieldForAppointmentText("Guardian Name","Father's/Mother's", appointmentController.guardian_nameController, appointmentController.guardian_nameController, TextInputType.text),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Email"))
                  InputFieldForAppointment("Email","email@gmail.com",appointmentController.emailController, appointmentController.emailController, TextInputType.text),


                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Fee"))
                  InputFieldForAppointmentNumber("Fee","500 BDT", appointmentController.feeTextEditingController, appointmentController.feeTextEditingController, TextInputType.numberWithOptions(decimal: true)),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "HospitalId"))
                  InputFieldForAppointment("Hospital/Clinic PID","edg: 34433", appointmentController.hospitalId, appointmentController.hospitalId, TextInputType.text),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "PatientRegNo"))
                  InputFieldForAppointment("Patient Reg No ","edg: 12144", appointmentController.patientHospitalRegId, appointmentController.patientHospitalRegId, TextInputType.text),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "DOB"))
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


                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "BloodGroup"))
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

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "MedicineTaken"))
                  InputFieldForAppointment("Drug History","Napa 500mg", appointmentController.medicineTextEditingController, appointmentController.medicineTextEditingController, TextInputType.text),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "OFCcM"))
                  InputFieldForAppointmentNumber("OFC","30cm", appointmentController.OFCTextEditingController, appointmentController.OFCTextEditingController, TextInputType.numberWithOptions(decimal: true)),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "OFC"))
                  InputFieldForAppointmentNumber("OFC","30inch ", appointmentController.OFCInchesTextEditingController, appointmentController.OFCInchesTextEditingController, TextInputType.numberWithOptions(decimal: true)),


                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "RR"))
                  InputFieldForAppointmentNumber("RR", "15 per/minute", appointmentController.rrTextEditingController, appointmentController.rrTextEditingController, TextInputType.numberWithOptions(decimal: true)),


                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Hip"))
                  InputFieldForAppointmentNumber("Hip (Inch)","", appointmentController.hipTextEditingController, appointmentController.hipTextEditingController, TextInputType.numberWithOptions(decimal: true)),


                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "HipCm"))
                  InputFieldForAppointmentNumber("Hip (CM)","", appointmentController.hipCmTextEditingController, appointmentController.hipCmTextEditingController, TextInputType.numberWithOptions(decimal: true)),


                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Waist"))
                  InputFieldForAppointmentNumber("Waist (Inch)","", appointmentController.waistTextEditingController, appointmentController.waistTextEditingController, TextInputType.numberWithOptions(decimal: true)),


                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "WaistCm"))
                  InputFieldForAppointmentNumber("Waist (CM)","", appointmentController.waistCmTextEditingController, appointmentController.waistCmTextEditingController, TextInputType.numberWithOptions(decimal: true)),




                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "ReportPatient"))
                  Container(
                    width:  styleConstant.formWidthM,
                    height: styleConstant.formHeight,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child:  CheckboxListTile(
                      title: Text('Report Patient'),
                      value: appointmentController.isReportPatient.value,
                      onChanged: (bool? value) {
                        appointmentController.isReportPatient.value = value!;
                      },
                    ),
                  ),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Date"))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
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

                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Appointment Date",
                      ),
                      readOnly: true,

                    ),
                  ),
                ),

                if(generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "Serial"))
                  InputFieldForAppointmentNumber("Serial","Serial No-1", appointmentController.serialTextEditingController, appointmentController.serialTextEditingController, TextInputType.number),

                // SizedBox(
                //   width:  styleConstant.formWidthM,
                //   height: styleConstant.formHeight,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //     child: FilledButton(
                //       onPressed: () {
                //         // addPatientAllInfo(context, "Patient Information for Appointment", screenWidth, screenHeight);
                //         // showBottom(context);
                //         showTopSheet(context);
                //
                //       },
                //       child: const Text(
                //         "+ Add More Info",
                //       ),
                //     ),
                //   ),
                // ),

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
                SizedBox(
                  child: FilledButton(
                    onPressed: () {
                      //           // addPatientAllInfo(context, "Patient Information for Appointment", screenWidth, screenHeight);
                      //           // showBottom(context);
                      //           // showTopSheet(context);
                      // drawerMenuController.endDrawerCurrentScreen.value = EndDrawerScreenValues.appointment;
                      // bool isImageUpload = true;
                      appointmentAllInfoModal(context, "Patient Appointment Information ");
                    }, child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:   [
                      Icon(Icons.add_circle, size: 30, color: Colors.white),
                      SizedBox(width: 10,),
                      Text("Patient Information")],),
                  ),
                ),

              ],
            ),
          )


        ],
      ),
    );

  });
}

appointmentAllInfoModal(context, String title) {
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 5,
        children: [
          Text(title),

          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.close))
        ],
      ),
      content:
      Container(
          height: MediaQuery.of(context).size.height * .9,
          width: MediaQuery.of(context).size.width * .9,
          child: appointmentInfoModal(context)),
    );
  });
}