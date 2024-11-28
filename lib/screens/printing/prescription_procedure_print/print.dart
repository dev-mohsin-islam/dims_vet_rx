

import 'dart:convert';

import 'dart:ui' as ui;
import 'package:bijoy_helper/bijoy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../controller/general_setting/config/app_default_prescription_print_setup_data.dart';
import '../../../controller/general_setting/prescription_print_page_setup_controller.dart';
import '../../../utilities/history_category.dart';
 final PrescriptionPrintPageSetupController printSetup = Get.put(PrescriptionPrintPageSetupController());
class procedurePrintPreview extends StatelessWidget {
  final List selectedClinicalDataColumn1;
  final List selectedMedicineDataColumn2;
  final List printPatientAndAppointmentInfo;


  procedurePrintPreview({super.key, required this.selectedClinicalDataColumn1, required this.selectedMedicineDataColumn2, required this.printPatientAndAppointmentInfo,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prescription Print")),
      body: PdfPreview(
        build: (format) => _printPdf(selectedClinicalDataColumn1,selectedMedicineDataColumn2,printPatientAndAppointmentInfo)
      )
    );
  }
}

Future<Uint8List> _printPdf(dataColumn1,dataColumn2,patientAndAppointmentInfo) async {

  PrescriptionPrintPageSetupController setupController = Get.put(PrescriptionPrintPageSetupController());

// Convert List<dynamic> to List<Map<String, dynamic>>

    double headerHeight =   50 ;
    double footerHeight =   50 ;


    double footerImageHeight = 0.00;


    double headerImageHeight = 0.00;


  final int totalItemsColumn1 = dataColumn1.length;
  final int totalItemsColumn2 = dataColumn2.length;

  final int maxTotalItems = totalItemsColumn1 + 6 > totalItemsColumn2 ? totalItemsColumn1 : totalItemsColumn2;

     double sidebarWidth = 2.0;
     double fontSize = double.parse(setupController.pageFontSizeController.text.toString());


  // int AdviceLength = advice.toString().length;


  final pdf = pw.Document(
    pageMode: PdfPageMode.fullscreen,
    version: PdfVersion.pdf_1_5,
    compress: true,
  );


    final fontData = await rootBundle.load('fonts/SutonnyMJRegular.ttf');
    final customFont = pw.Font.ttf(fontData.buffer.asByteData());


    int itemsPerPageColumn2 = 12;
    int itemsPerPageColumn1 = 18;


    int totalPages = (maxTotalItems / itemsPerPageColumn2).ceil();
    if(dataColumn1.length - 6 < dataColumn1.length){
      totalPages = (maxTotalItems / itemsPerPageColumn1).ceil();
    }


    for (int i = 0; i < totalPages; i++) {

      double topMargin =  double.parse(setupController.pageMarginTopController.text.toString()) * 72;
      double bottomMargin = double.parse(setupController.pageMarginBottomController.text.toString()) * 72;;
      double leftMargin = double.parse(setupController.pageMarginLeftController.text.toString()) * 72;;
      double rightMargin = double.parse(setupController.pageMarginRightController.text.toString()) * 72;;

      final pageHeight = double.parse(setupController.pageHeightController.text.toString()) * 72;
      final pageWidth = double.parse(setupController.pageHeightController.text.toString()) * 72;

      final pdfPageFormat = PdfPageFormat(pageWidth, pageHeight).copyWith(
        marginTop: topMargin ,
        marginLeft: leftMargin,
        marginRight:  rightMargin,
        marginBottom: bottomMargin,
      );


      pdf.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: pdfPageFormat,
          ),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // header container
                _buildHeader(i == 0, headerImageHeight, headerHeight),

                // Patient information container only for first page
                i == 0 ? _buildDataRowPatientInfo(patientAndAppointmentInfo, fontSize) : pw.SizedBox(height: 5),

                pw.Container(
                  width: double.infinity, // Adjust the width as needed
                  height: 1,
                  color: PdfColors.black,
                ),

                // medicine and clinical data container
                pw.Expanded(
                  child: _buildContent(dataColumn1,dataColumn2,  patientAndAppointmentInfo,  totalPages, i + 1 , customFont, sidebarWidth,fontSize, itemsPerPageColumn2, itemsPerPageColumn1, totalItemsColumn1, totalItemsColumn2),
                ),

                // footer container
                _buildFooter(footerImageHeight, footerHeight),
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
}

pw.Widget _buildHeader(bool isFirstPage, headerImageHeight, headerHeight) {
  double marginAroundFullPage = parseDouble(printSetup.marginAroundFullPageController.text.toString());
  return pw.Padding(
      padding: pw.EdgeInsets.only(top: 0.0, bottom: marginAroundFullPage, left: marginAroundFullPage, right: marginAroundFullPage),
      child: pw.Column(
          children: [
            if(printSetup.printHeaderFooterOrNonValue == DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValueImageHeaderFooter && headerImageHeight <600)
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 0.0),
                child: pw.Container(
                  width: double.infinity,
                  child: pw.Image(pw.MemoryImage(base64Decode(base64Encode(printSetup.headerFooterAndBgImage[0]['headerImage'])))),
                ),
              ),
            if(printSetup.printHeaderFooterOrNonValue ==DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValuePrintedHeaderFooter)
              pw.Container(
                width: double.infinity,
                child: pw.SizedBox(
                  height: headerHeight ,
                ),
              ),
            if(printSetup.printHeaderFooterOrNonValue ==DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValueCustomBuilderHeaderFooter)
              pw.Container(
                width: double.infinity,
                child: pw.SizedBox(
                  height: headerHeight ,
                ),
              ),

          ])

  );
}

pw.Widget _buildFooter(footerImageHeight, footerHeight) {
  double marginAroundFullPage = parseDouble(printSetup.marginAroundFullPageController.text.toString());
  return pw.Padding(
      padding:  pw.EdgeInsets.only(top: marginAroundFullPage, bottom: 0.0, left: marginAroundFullPage, right: marginAroundFullPage),
      child: pw.Container(
          child: pw.Column(
              children: [
                if(printSetup.printHeaderFooterOrNonValue == DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValueImageHeaderFooter && footerImageHeight <600)
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 0.0),
                    child: pw.Container(
                      width: double.infinity,
                      child: pw.Image(pw.MemoryImage(base64Decode(base64Encode(printSetup.headerFooterAndBgImage[0]['footerImage'])))),

                    ),
                  ),
                if(printSetup.printHeaderFooterOrNonValue ==DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValuePrintedHeaderFooter)
                  pw.Container(
                    width: double.infinity,

                    child: pw.SizedBox(
                      height: footerHeight ,
                    ),
                  ),
                if(printSetup.printHeaderFooterOrNonValue ==DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValueCustomBuilderHeaderFooter)
                  pw.Container(
                    width: double.infinity,
                    child: pw.SizedBox(
                      // height: 200,
                      height: footerHeight ,
                    ),
                  ),
              ])
      )
  );
}

 pw.Widget _buildContent(column1Data,   column2Data, patientAndAppointmentInfo, totalPages, i, customFont,sidebarWidth,fontSize, itemsPerPageColumn2, itemsPerPageColumn1, totalPagesColumn1, totalPagesColumn2) {



  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
     pw.Padding(
       padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
       child:  pw.SizedBox(
         width: sidebarWidth * 150,
         child: pw.Expanded(
             child:  pw.Column(
                 crossAxisAlignment: pw.CrossAxisAlignment.start,
                 children: [
                   pw.Row(
                       children: [
                         pw.Text("Date: "),
                         pw.Text("${patientAndAppointmentInfo[0]['date']}"),
                       ]
                   ),
                   pw.SizedBox(height: 15),

                   pw.Row(
                       children: [
                         pw.Text("Dx: "),
                         pw.Text("${column1Data[0]['diagnosisController']}"),
                       ]
                   ),
                   pw.SizedBox(height: 15),
                   pw.Row(
                       children: [
                         pw.Text("Procedure Name: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                         pw.Text("${column1Data[0]['procedureNameController']}"),
                       ]
                   ),
                   pw.Row(
                     mainAxisAlignment: pw.MainAxisAlignment.start,
                       crossAxisAlignment: pw.CrossAxisAlignment.start,
                       children: [
                         pw.Text("Anesthesia: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Container(
                          width: 400,
                            child: pw.Text( "${column1Data[0]['anesthesiaController']}"),
                        )
                       ]
                   ),
                   pw.SizedBox(height: 5),
                   pw.Row(
                       children: [
                         pw.Text("Surgeon Name: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                         pw.Text("${column1Data[0]['surgeonNameController']}"),
                       ]
                   ),
                   pw.SizedBox(height: 5),
                   pw.Row(
                       mainAxisAlignment: pw.MainAxisAlignment.start,
                       crossAxisAlignment: pw.CrossAxisAlignment.start,
                       children: [
                         pw.Text("Assistant: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                         pw.Container(
                           width: 400,
                           child: pw.Text("${column1Data[0]['assistantController']}"),
                         )
                       ]
                   ),
                   pw.SizedBox(height: 5),
                   pw.Row(
                       mainAxisAlignment: pw.MainAxisAlignment.start,
                       crossAxisAlignment: pw.CrossAxisAlignment.start,
                       children: [
                         pw.Text("Incision: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                         pw.Container(
                           width: 400,
                           child: pw.Text("${column1Data[0]['incisionController']}"),
                         )
                       ]
                   ),
                   pw.SizedBox(height: 5),

                   pw.Row(
                       mainAxisAlignment: pw.MainAxisAlignment.start,
                       crossAxisAlignment: pw.CrossAxisAlignment.start,
                       children: [
                         pw.Text("Procedure Details: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Container(
                          width: 400,
                          child:  pw.Text("${column1Data[0]['procedureDetailsController']}"),
                        )
                       ]
                   ),
                   pw.SizedBox(height: 5),
                   pw.Row(
                       mainAxisAlignment: pw.MainAxisAlignment.start,
                       crossAxisAlignment: pw.CrossAxisAlignment.start,
                       children: [
                         pw.Text("Prosthesis: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                         pw.Container(
                           width: 400,
                           child:  pw.Text("${column1Data[0]['prosthesisController']}"),
                         )
                       ]
                   ),
                   pw.SizedBox(height: 5),
                   pw.Row(
                       mainAxisAlignment: pw.MainAxisAlignment.start,
                       crossAxisAlignment: pw.CrossAxisAlignment.start,
                       children: [
                         pw.Text("Closer: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                         pw.Container(
                           width: 400,
                           child: pw.Text("${column1Data[0]['closerController']}"),
                         )
                       ]
                   ),
                   pw.SizedBox(height: 5),
                   pw.Row(
                       mainAxisAlignment: pw.MainAxisAlignment.start,
                       crossAxisAlignment: pw.CrossAxisAlignment.start,
                       children: [
                         pw.Text("Findings: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                         pw.Container(
                           width: 400,
                           child: pw.Text("${column1Data[0]['findingsController']}"),
                         )
                       ]
                   ),
                   pw.SizedBox(height: 5),
                   pw.Row(
                       mainAxisAlignment: pw.MainAxisAlignment.start,
                       crossAxisAlignment: pw.CrossAxisAlignment.start,
                       children: [
                         pw.Text("Complications: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                         pw.Container(
                           width: 400,
                           child: pw.Text("${column1Data[0]['complicationsController']}"),
                         )
                       ]
                   ),
                   pw.SizedBox(height: 5),
                   pw.Row(
                       mainAxisAlignment: pw.MainAxisAlignment.start,
                       crossAxisAlignment: pw.CrossAxisAlignment.start,
                       children: [
                         pw.Text("Drains: ",style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Container(
                            width: 400,
                            child:  pw.Text("${column1Data[0]['drainsController']}"),
                          )
                       ]
                   ),
                   pw.SizedBox(height: 5),
                   pw.Row(
                       mainAxisAlignment: pw.MainAxisAlignment.start,
                       crossAxisAlignment: pw.CrossAxisAlignment.start,
                       children: [
                         pw.Text("Post-Operative Instructions: ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Container(
                          width: 400,
                          child:  pw.Text("${column1Data[0]['postOperativeInstructionsController']}"),
                        )
                       ]
                   ),
                 ]
             )
         ),
       ),
     ),

      // pw.Container(
      //   width: 1, // Adjust the width as needed
      //   height: double.infinity,
      //   color: PdfColors.black,
      // ),
      pw.SizedBox(width: 5),
      pw.Expanded(
        child:  pw.Column(
           crossAxisAlignment: pw.CrossAxisAlignment.start,
           children: <pw.Widget>[
               pw.SizedBox(height: 5),
               pw.Column(
                 crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                        // pw.Text("My data"),
                      ])
                  ])
      )]
        );}

pw.Widget _buildDataRowPatientInfo(patientAndAppointmentInfo,fontSize) {
print(patientAndAppointmentInfo);
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        // pw.Text('ID: ${patientAndAppointmentInfo[0]['patient_id']}',style: pw.TextStyle(fontSize: fontSize)),
        pw.Text('Name: ${patientAndAppointmentInfo[0]['name']}', style: pw.TextStyle(fontSize: fontSize)),
        pw.Text('Procedure Note', style: pw.TextStyle(fontSize: fontSize + 2, fontWeight: pw.FontWeight.bold)),
        pw.Text('Age: ${patientAndAppointmentInfo[0]['age']}', style: pw.TextStyle(fontSize: fontSize)),
        // if(patientAndAppointmentInfo[0]['sex'] !=0 && patientAndAppointmentInfo[0]['sex'] == 1)
        //   pw.Text("Gender: M", style: pw.TextStyle(fontSize: fontSize)),
        // if(patientAndAppointmentInfo[0]['sex'] !=0 && patientAndAppointmentInfo[0]['sex'] == 2)
        //   pw.Text("Gender: F", style: pw.TextStyle(fontSize: fontSize)),
        // pw.Text('Date: ${patientAndAppointmentInfo[0]['date']}', style: pw.TextStyle(fontSize: fontSize)),
      ],
    ),
  );
}