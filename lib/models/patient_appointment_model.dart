

import 'package:dims_vet_rx/models/appointment/appointment_model.dart';
import 'package:dims_vet_rx/models/patient/patient_model.dart';

class PatientAppointment{
  AppointmentModel appointment;
  PatientModel patient;
  PatientAppointment({required this.appointment , required this.patient});
}