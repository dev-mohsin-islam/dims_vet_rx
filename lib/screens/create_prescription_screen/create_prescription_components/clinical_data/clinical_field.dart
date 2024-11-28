


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../controller/chief_complain/chief_complain_controller.dart';
import '../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../controller/diagnosis/diagnosis_controller.dart';
import '../../../../controller/investigation/investigation_controller.dart';
import '../../../../controller/investigation_report/Investigation_report_controller.dart';
import '../../../../controller/on_examination/on_examination_controller.dart';
import '../../../../controller/procedure/procedure_controller.dart';
import '../../../../utilities/app_strings.dart';
import 'procedure.dart';

///this widget called from prescription create page and open right endDrawer in prescription create page---------------------start
// Widget procedurePrescriptionWidget(context){
//   final ProcedureController procedureController = Get.put(ProcedureController());
//   final PrescriptionController prescriptionController = Get.put(PrescriptionController());
//   final selectedDataList = procedureController.selectedProcedure;
//   const Procedure = ScreenTitle.Procedure;
//   return clinicalFieldProcedureDataList(context,Procedure,procedureController,selectedDataList,"Procedure",);
// }

Widget investigationAdvicePrescriptionWidget(context){
  final InvestigationController controller = Get.put(InvestigationController());
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final selectedDataList = prescriptionController.selectedInvestigationAdvice;
  const Investigation = ScreenTitle.Investigation;
  // return clinicalDataList(context,Investigation,controller,selectedDataList,prescriptionController,"investigationAdvice",FavSegment.ia);
  return Text("data");
}
Widget investigationReportPrescriptionWidget(context){
  final InvestigationReportController controller = Get.put(InvestigationReportController());
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final selectedDataList = prescriptionController.selectedInvestigationReport;
  const InvestigationReport = ScreenTitle.InvestigationReport;
  // return clinicalDataList(context,InvestigationReport,controller,selectedDataList,prescriptionController,"investigationReport",FavSegment.ir, true);
  return Text("data");
}


Widget diagnosisPrescriptionWidget(context){
  final DiagnosisController controller = Get.put(DiagnosisController());
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final selectedDataList = prescriptionController.selectedDiagnosis;
  const Diagnosis = ScreenTitle.Diagnosis;
  // return clinicalDataList(context,Diagnosis,controller,selectedDataList,prescriptionController,"diagnosis", FavSegment.dia);
  return Text("data");
}


Widget onExaminationPrescriptionWidget(context){
  final OnExaminationController controller = Get.put(OnExaminationController());
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final selectedDataList = prescriptionController.selectedOnExamination;
  const  OnExamination= ScreenTitle.OnExamination;
  // return clinicalDataList(context,OnExamination,controller,selectedDataList,prescriptionController,"onExamination",FavSegment.oE);
  return Text("data");
}


Widget chiefComplainPrescriptionWidget(context){
  final ChiefComplainController controller = Get.put(ChiefComplainController());
  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  final selectedDataList = prescriptionController.selectedChiefComplain;
  const  chiefComplain= ScreenTitle.ChiefComplain;
  // return clinicalDataList(context,chiefComplain, controller,selectedDataList,prescriptionController, "chiefComplain",FavSegment.chiefComplain);
  return Text("data");
}

///this widget called from prescription create page and open right endDrawer in prescription create page---------------------end