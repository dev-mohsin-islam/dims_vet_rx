import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../controller/appointment/appointment_controller.dart';
import '../../../../controller/appointment/methods/clear_appointment_data.dart';
import '../../../../utilities/app_strings.dart';





Future bloodGroupModal(context){
AppointmentController appointmentController = Get.put(AppointmentController());
  return  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Blood Group'),
        content: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: bloodGroupList.map((bloodGroup) {
            return ListTile(
              title: Text(bloodGroup['label']),
              leading: Radio<dynamic>(
                value: bloodGroup['label'],
                groupValue: appointmentController.selectedBloodGroup.value,
                onChanged: (value) {
                  appointmentController.selectedBloodGroupCont.text = value.toString();
                  appointmentController.selectedBloodGroup.value = value;
                  appointmentController.selectedBloodGroup.refresh();
                  Navigator.pop(context);
                },
              ),
            );
          }).toList(),
        )),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),

        ],
      );
    },
  );
}