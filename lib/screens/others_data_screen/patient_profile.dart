import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dims_vet_rx/models/appointment/appointment_model.dart';
import 'package:dims_vet_rx/models/patient/patient_model.dart';

import '../../models/patient_appointment_model.dart';
import '../../utilities/helpers.dart';

patientProfileDialog(context,PatientAppointment patientAppointment){
  PatientModel patientModel = patientAppointment.patient;
  AppointmentModel appointmentModel = patientAppointment.appointment;
  final fields = {
    'Patient ID': patientModel.id,
    'Name': patientModel.id,
    'Age': patientModel.id,
    'Gender': genderConvertToString(patientModel.id),
    'Date': patientModel.date,
    'Phone': patientModel.phone,
    'Email': patientModel.email,
    'Address': patientModel.area,
    'Education': patientModel.education,
    'Guardian Name': patientModel.guardian_name,
    'Blood Group': bloodGroupNumToString(patientModel.id),
    'Drug History': appointmentModel.medicine,
    'Height (cm)': appointmentModel.height,
    'Weight (kg)': appointmentModel.weight,
    'Hip': appointmentModel.hip,
    'Waist (cm)': appointmentModel.waist,
    'OFC (cm)': appointmentModel.OFC,
    'RR (cm)': appointmentModel.rr,
  };
  showDialog(context: context, builder: (context){

    return AlertDialog(
      title: Row(
        children: [
          Text("Patient Profile"),
          Spacer(),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.close))
        ],
      ),
      content: Column(
        children: [
          Icon(Icons.account_circle, size: 100, color: Colors.grey),
          Container(
            width: Platform.isWindows ? 500 : MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context) .size.height * 0.6,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for(var entry in fields.entries)
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Table(
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                               border: Border.all(color: Colors.grey),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${entry.key}: ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        entry.value?.toString() ?? 'N/A',
                                        style: const TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  });
}
