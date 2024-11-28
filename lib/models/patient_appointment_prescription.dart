

import 'package:dims_vet_rx/models/patient_appointment_model.dart';

import 'create_prescription/prescription/prescription_model.dart';

class PatientAppointmentPrescriptionModel {
  PatientAppointment patientAppointment;
  PrescriptionModel prescription;

  PatientAppointmentPrescriptionModel({required this.patientAppointment, required this.prescription});
}