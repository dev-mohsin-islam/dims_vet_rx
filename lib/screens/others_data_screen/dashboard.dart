import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/prescription_controller.dart';

import '../../controller/appointment/appointment_controller.dart';
import '../../controller/patient/patient_controller.dart';
import '../../utilities/helpers.dart';





class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppointmentController appointmentController = Get.put(AppointmentController());
    PatientController patientController = Get.put(PatientController());
    PrescriptionController prescriptionController = Get.put(PrescriptionController());
    int reportPatientCount = appointmentController.patientAppointmentList.where((element) => element.appointment.report_patient == 1).length;
    int totalReportPatient = appointmentController.patientAppointmentList.where((element) => element.appointment.report_patient ==1).length;
    var today = customDateTimeFormat(DateTime.now());
  
    Iterable todayFeeCollection = appointmentController.patientAppointmentList.where((element) => element.appointment.date == today && element.appointment.fee !=null && element.appointment.fee !=0);
    Iterable totalFeeCollection = appointmentController.patientAppointmentList.where((element) => element.appointment.fee !=null && element.appointment.fee !=0);

    int todayTotalFee = calculateTodayTotalFee(todayFeeCollection);
    int totalFee = calculateTotalFee(totalFeeCollection);
    var todayAppointments = appointmentController.patientAppointmentList.where((element) => element.appointment.date == today);
    var todayPrescriptions = prescriptionController.patientAppPrescriptionJoin.where((element) => element.patientAppointment.appointment.date == today);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Dashboard', style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.people, size: 64.0, color: Colors.blue),
                      DashboardCard(
                        title: 'Total Number of Patients',
                        value: '${patientController.box.length}', // Replace with actual value
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      Icon(Icons.people, size: 64.0, color: Colors.blue),
                      DashboardCard(
                        title: 'Total Number of Appointments',
                        value: '${appointmentController.boxAppointment.length}', // Replace with actual value
                      ),
                    ],
                  ),
                ),

                Card(
                  child: Column(
                    children: [
                      Icon(Icons.today, size: 64.0, color: Colors.blue),
                      DashboardCard(
                        title: 'Today\'s Total Number of Appointments',
                        value: '${todayAppointments.length}', // Replace with actual value
                      ),
                    ],
                  ),
                ),

                Card(
                  child: Column(
                    children: [
                      Icon(Icons.bookmark_added, size: 64.0, color: Colors.blue),
                      DashboardCard(
                        title: 'Total Number of Prescriptions',
                        value: '${prescriptionController.boxPrescription.length}', // Replace with actual value
                      ),
                    ],
                  ),
                ),

                Card(
                  child: Column(
                    children: [
                      Icon(Icons.person_2, size: 64.0, color: Colors.blue),
                      DashboardCard(
                        title: 'Today\'s Total Number of Report Patients',
                        value: '${reportPatientCount}', // Replace with actual value
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      Icon(Icons.person_2, size: 64.0, color: Colors.blue),
                      DashboardCard(
                        title: 'Total Number of Report Patients',
                        value: '${totalReportPatient}', // Replace with actual value
                      ),
                    ],
                  ),
                ),



                Card(
                  child: Column(
                    children: [
                      Icon(Icons.monetization_on, size: 64.0, color: Colors.blue),
                      DashboardCard(
                        title: 'Today Fee Collection',
                        value: '${todayTotalFee}', // Replace with actual value
                      ),
                    ],
                  ),
                ),

                Card(
                  child: Column(
                    children: [
                      Icon(Icons.monetization_on, size: 64.0, color: Colors.blue),
                      DashboardCard(
                        title: 'Total Fee Collection',
                        value: '${totalFee}', // Replace with actual value
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;

  DashboardCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Center(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
