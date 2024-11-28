//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../../../controller/general_setting/general_setting_controller.dart';
//
//
// Widget prescriptionCreatePage(){
//   final toggleController = Get.put(GeneralSettingController());
//
//
//   return SizedBox(
//     width: 480,
//     child: Padding(
//       padding: const EdgeInsets.all(15),
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//             border: Border.all(color: Colors.black26, width: 1),
//             borderRadius: BorderRadius.circular(10)
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Obx(() {
//               return Column(
//                 children: [
//                   const Text("Front Page Clinical Field", style: TextStyle(
//                       fontSize: 20, fontWeight: FontWeight.bold)),
//                   const Divider(),
//
//                   SizedBox(
//                     width: 310,
//                     child: Card(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('Chief Complaint: '),
//                           ),
//                           Switch(
//                             value: toggleController
//                                 .chiefComplain.value,
//                             onChanged: (value) {
//                               toggleController
//                                   .chiefComplainToggleSwitch();
//                             },
//
//                             // Color when the switch is on
//                             inactiveThumbColor: Colors
//                                 .grey, // Color when the switch is off
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(
//                     width: 310,
//                     child: Card(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('On Examination:'),
//                           ),
//                           Switch(
//                             value: toggleController.onExamination.value,
//                             onChanged: (value) {
//                               toggleController.onExaminationToggleSwitch();
//                             },
//
//
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 310,
//                     child: Card(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('Disease Activity Score:'),
//                           ),
//                           Switch(
//                             value: toggleController.diseaseScore.value,
//                             onChanged: (value) {
//                               toggleController.diseaseScoreToggleSwitch();
//                             },
//
//
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(
//                     width: 310,
//                     child: Card(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('Diagnosis:'),
//                           ),
//                           Switch(
//                             value: toggleController.diagnosis.value,
//                             onChanged: (value) {
//                               toggleController.diagnosisToggleSwitch();
//                             },
//
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//
//
//                   SizedBox(
//                     width: 310,
//                     child: Card(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('Investigation Advice:'),
//                           ),
//                           Switch(
//                             value: toggleController.investigationAdvice.value,
//                             onChanged: (value) {
//                               toggleController.investigationAdviceToggleSwitch();
//                             },
//
//
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//
//
//                   SizedBox(
//                     width: 310,
//                     child: Card(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('Investigation Report:'),
//                           ),
//                           Switch(
//                             value: toggleController.investigationReport.value,
//                             onChanged: (value) {
//                               toggleController.investigationReportAdviceToggleSwitch();
//                             },
//
//
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(
//                     width: 310,
//                     child: Card(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('Procedure:'),
//                           ),
//                           Switch(
//                             value: toggleController.procedure.value,
//                             onChanged: (value) {
//                               toggleController.newProcedureMethodToggle();
//                             },
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//
//
//
//
//                   SizedBox(
//                     width: 310,
//                     child: Card(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('Child History:'),
//                           ),
//                           Switch(
//                             value: toggleController.childHistory.value,
//                             onChanged: (value) {
//                               toggleController.childHistoryToggleSwitch();
//                             },
//
//
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(
//                     width: 310,
//                     child: Card(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('Certificate:'),
//                           ),
//                           Switch(
//                             value: toggleController.certificate.value,
//                             onChanged: (value) {
//                               toggleController.certificateToggleSwitch();
//                             },
//
//
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(
//                     width: 310,
//                     child: Card(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                         children: [
//                             const Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text('Money Receipt:'),
//                             ),
//                           Switch(
//                             value: toggleController.moneyReceipt.value,
//                             onChanged: (value) {
//                               toggleController.moneyReceiptToggleSwitch();
//                             },
//
//
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(
//                     width: 310,
//                     child: Card(
//
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Text('History:'),
//                           ),
//                           Switch(
//                             value: toggleController.history.value,
//                             onChanged: (value) {
//                               toggleController.historyAdviceToggleSwitch();
//                             },
//
//
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//
//
//                   SizedBox(
//                     width: 310,
//                     child: Card(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                         children: [
//                             const Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text('Fee:'),
//                             ),
//                           Switch(
//                             value: toggleController.fee.value,
//                             onChanged: (value) {
//                               toggleController.feeToggleSwitch();
//                             },
//
//
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//
//
//                   SizedBox(
//                     width: 310,
//                     child: Card(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                         children: [
//                             const Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text('Hand Out:'),
//                             ),
//                           Switch(
//                             value: toggleController.handOut.value,
//                             onChanged: (value) {
//                               toggleController.handOutToggleSwitch();
//                             },
//
//
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//
//
//                   SizedBox(
//                     width: 310,
//                     child: Card(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                         children: [
//                             const Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text('Immunization:'),
//                             ),
//                           Switch(
//                             value: toggleController.immunization.value,
//                             onChanged: (value) {
//                               toggleController.immunizationToggleSwitch();
//                             },
//
//
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20,),
//                 ],
//               );
//             }),
//           ],
//         ),
//       ),
//     ),
//   );
// }