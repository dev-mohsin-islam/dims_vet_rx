


import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/appointment/appointment_controller.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/methods/method_prescription_data_clear.dart';
import 'package:dims_vet_rx/database/crud_operations/appointment_crud.dart';
import 'package:dims_vet_rx/models/appointment/appointment_model.dart';
import 'package:dims_vet_rx/models/on_examination/on_examination_model.dart';
import 'package:dims_vet_rx/models/patient_appointment_model.dart';
import '../../../../controller/drawer_controller/drawer_controller.dart';
import '../../../../utilities/default_value.dart';
import '../../../../utilities/helpers.dart';


todayPatients(context) {
  var appointmentBox = Get.put(AppointmentBoxController());
  final TextEditingController textEditingController = TextEditingController();
  final AppointmentController appointmentController = Get.put(AppointmentController());
  var drawerMenuController = Get.put(DrawerMenuController());
  RxList dropdownItems = [].obs;
  dropdownItems.clear();
  for(var item in appointmentController.patientAppointmentList){
    AppointmentModel appointment = item.appointment;
    var date = appointment.date.toString();
    var dateNow = customDateTimeFormat(DateTime.now());
    if(date == dateNow){
      var res = tetClinicalData(item.appointment.id);
        var data = {
          'appointment': item.appointment,
          'patient': item.patient,
          'additional_data': res
        };
      dropdownItems.add(data);
    }
  }

  return  SingleChildScrollView(
    child: Obx(() => Container(
      child: Column(
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton2<dynamic>(
              isExpanded: true,
              iconStyleData : const IconStyleData(icon : Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.white,)),
              items: dropdownItems.map((item){
              return DropdownMenuItem(
                    // enabled: item.appointment.status == DefaultValues.prescriptionReady || item.appointment.status == DefaultValues.cancelAppointment ? false : true,
                value: item,
                child: Row(
                  children: [
                    // Text(item['additional_data'].serial.toString() + ". ", style: const TextStyle(fontSize: 14,),),
                    Text(item['appointment'].serial.toString() + ". ", style: const TextStyle(fontSize: 14,),),
                    item['appointment'].status == DefaultValues.prescriptionReady ?
                    Row(
                      children: [
                        Icon(Icons.done, color: Colors.green,),
                        SizedBox(width: 5,),
                       Text(item['patient'].name, style: const TextStyle(fontSize: 14, color: Colors.green),),
                      ],
                    ) :  item['appointment'].status == DefaultValues.cancelAppointment ? Text(item['patient'].name, style: const TextStyle(fontSize: 14, color: Colors.red),) : Text(item['patient'].name, style: const TextStyle(fontSize: 14,),
                    ),
                  ]
                ));
                }).toList(),
                onChanged: (patientAppointmentInfo) async{
                PatientAppointment patientAppointmentData = PatientAppointment(appointment: patientAppointmentInfo['appointment'], patient: patientAppointmentInfo['patient']);
                  appointmentController.viewAppointmentDetails(patientAppointmentData);
                  drawerMenuController.selectedMenuIndex.value = 0;
                  var additionalData =await appointmentBox.getAppClinicalInfo(patientAppointmentData.appointment.id);
                  if(additionalData != null){
                    prescriptionController.getAppClinicalData(additionalData);
                  }

              },
              buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16), height: 40, width: 250, decoration: BoxDecoration(

              )),
              dropdownStyleData:  const DropdownStyleData(maxHeight: 400, decoration: BoxDecoration(

              )),
              menuItemStyleData: const MenuItemStyleData(height: 40, ),
              dropdownSearchData: DropdownSearchData(
                searchController: textEditingController,

                searchInnerWidgetHeight: 50,
                searchInnerWidget: Container(
                  height: 50,
                  padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8,),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    controller: textEditingController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8,),
                      hintText: 'Search...',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (dataList, searchValue) {
                  print(dataList);
                  return dataList.value['patient'].name.toString().toLowerCase().contains(searchValue.toLowerCase());
                },
              ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  textEditingController.clear();
                }
              },
            ),
          )
        ],
      ),
    )),
  );
}
tetClinicalData(appId)async{
  var appointmentBox = Get.put(AppointmentBoxController());
  var data = await appointmentBox.getAppClinicalInfo(appId);
  if(data != null){
    var scheduled = data['schedule'] ?? '';
    if(scheduled != null){
      return scheduled;
    }
  }

  return '';
}