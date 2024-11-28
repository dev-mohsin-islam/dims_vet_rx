

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

import '../../../controller/general_setting/prescription_print_page_setup_controller.dart';
import '../../../models/patient_appointment_model.dart';
import '../../../utilities/history_category.dart';

class patientCertificatePrint extends StatelessWidget {
final patientCertificateData;
final patientInfo;
  patientCertificatePrint({super.key, required this.patientCertificateData, required this.patientInfo,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prescription Print")),
      body: PdfPreview(
        build: (format) => _printPdf(patientCertificateData,patientInfo),
      )
    );
  }
}

Future<Uint8List> _printPdf(patientCertificateData,patientInfo) async {

  PrescriptionPrintPageSetupController setupController = Get.put(PrescriptionPrintPageSetupController());


    double headerHeight =  double.parse(setupController.pageHeaderHeightController.text.toString()) * 72;

    double footerHeight =  double.parse(setupController.pageFooterHeightController.text.toString()) * 72;

    double footerImageHeight = 0.00;
    double headerImageHeight = 0.00;
     double sidebarWidth = double.parse(setupController.pageSideBarWidthController.text.toString()) * 72;
     double fontSize = double.parse(setupController.pageFontSizeController.text);



    final pdf = pw.Document(
      pageMode: PdfPageMode.fullscreen,
      version: PdfVersion.pdf_1_5,
      compress: true,
    );


    final fontData = await rootBundle.load('fonts/SutonnyMJRegular.ttf');
    final customFont = pw.Font.ttf(fontData.buffer.asByteData());


    int itemsPerPageColumn2 = 12;
    int itemsPerPageColumn1 = 18;



    for (int i = 0; i < 1; i++) {
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
                _buildHeader(i == 0, setupController.printHeaderFooterOrNonValue, setupController.headerFooterAndBgImage[0]['headerImage'], headerImageHeight, headerHeight),

                // Patient information container only for first page
                // i == 0 ? _buildDataRowPatientInfo(patientAndAppointmentInfo, fontSize) : pw.SizedBox(height: 5),
                //
                //
                // pw.Container(
                //   width: double.infinity, // Adjust the width as needed
                //   height: 1,
                //   color: PdfColors.black,
                // ),

                // medicine and clinical data container
                pw.Expanded(
                  child: _buildContent(patientCertificateData, patientInfo, sidebarWidth,fontSize),
                ),

                // footer container
                _buildFooter(setupController.printHeaderFooterOrNonValue,setupController.headerFooterAndBgImage[0]['footerImage'], footerImageHeight, footerHeight),
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
}

pw.Widget _buildHeader(bool isFirstPage, isHeaderFooterActive, HeaderImage, headerImageHeight, headerHeight) {


  return pw.Column(
    children: [
      if(isHeaderFooterActive != "headerFooterNotActive")
      pw.Container(
        width: double.infinity,
        child: HeaderImage.length > 0 ? pw.Image(pw.MemoryImage(base64Decode(base64Encode(HeaderImage)))) : pw.Container( height: headerHeight),
        // child: pw.SizedBox(
        //   height: prescriptionSettingData['headerHeight'],
        // ),
      ),
      if(isHeaderFooterActive == "headerFooterNotActive")
      pw.Container(
        width: double.infinity,
        // child: pw.Image(pw.MemoryImage(imageBytesH)),
        child: pw.SizedBox(
          // height: 200,
          height: headerHeight,
        ),
      ),

    ]);
}

pw.Widget _buildFooter(isHeaderFooterActive,FooterImage, footerImageHeight, footerHeight) {
  return pw.Container(
      child: pw.Column(children: [
        if(isHeaderFooterActive != "headerFooterNotActive" && footerImageHeight <600)
       pw.Container(
         width: double.infinity,
         child: FooterImage.length > 0 ? pw.Image(pw.MemoryImage(base64Decode(base64Encode(FooterImage)))) : pw.Container( height: footerHeight),
       ),

        if(isHeaderFooterActive =="headerFooterNotActive")
        pw.Container(
          width: double.infinity,
          child: pw.SizedBox(
            height: footerHeight,
          ),
        ),
      ]),
    );
}

 pw.Widget _buildContent(patientCertificateData,  PatientAppointment patientAppointment, sidebarWidth,fontSize) {


  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
     pw.Padding(
       padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
       child:  pw.SizedBox(
         child: pw.Expanded(
             child:  pw.Column(
                 crossAxisAlignment: pw.CrossAxisAlignment.start,
                 children: [
                   pw.SizedBox(height: 15),
                   pw.Row(
                       children: [
                         pw.Text("Tow Whom it May Concern: ", style: pw.TextStyle(fontSize: fontSize)),

                       ]
                   ),
                   pw.SizedBox(height: 15),

                   pw.Row(
                       children: [
                         pw.Text("This Certificate that "),
                         pw.Text("${patientAppointment.patient.name}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize)),
                       ]
                   ),
                   pw.SizedBox(height: 15),

                  pw.Container(
                    width: 500,
                    child:  pw.Wrap(
                      ///// conditional
                        alignment: pw.WrapAlignment.start,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          pw.Text("Was examined and treated at the Chamber on", style: pw.TextStyle(fontSize: fontSize)),
                          pw.Text(" ${patientCertificateData.form}", style: pw.TextStyle( fontSize: fontSize)),
                          pw.Text(" To ", style: pw.TextStyle(fontSize: fontSize)),
                          pw.Text("${patientCertificateData.to}, ", style: pw.TextStyle(fontSize: fontSize)),
                          pw.Text("with the following diagnosis", style: pw.TextStyle(fontSize: fontSize)),
                          pw.Flexible(child:pw.Text("${patientCertificateData.diagnosis}", style: pw.TextStyle(fontSize: fontSize))),

                        ]
                    ),
                  ),
                   pw.SizedBox(height:15),
                   if(patientCertificateData.type =='1')
                   pw.Row(
                     children: [
                       pw.Text("I advised to take complete bed rest for ", style: pw.TextStyle(fontSize: fontSize)),
                       pw.Text("${patientCertificateData.duration}." , style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                     ]
                   ),

                   if(patientCertificateData.type =='2')
                   pw.Row(
                     children: [
                       pw.Text("I have carefully examined him and now fit to resume ", style: pw.TextStyle(fontSize: fontSize)),
                       if(patientCertificateData.got_to ==1)
                       pw.Text("School", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize)),
                       if(patientCertificateData.got_to ==2)
                       pw.Text("College" , style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize)),
                       if(patientCertificateData.got_to ==3)
                       pw.Text("Duty" , style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize)),

                       pw.Text(" From " , style: pw.TextStyle(fontSize: fontSize)),


                       pw.Text("${patientCertificateData.is_continue}."  , style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize)),

                     ]
                   ),
                   pw.SizedBox(height:155),
                   pw.Column(
                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                     children: [
                       pw.Row(
                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                           children: [
                             pw.Text("Date: ${patientCertificateData.date}", style: pw.TextStyle(fontSize: fontSize + 2)),
                             pw.SizedBox(width: MediaQuery.of(Get.context!).size.width * 0.08),
                             pw.Text("Signature", style: pw.TextStyle(fontSize: fontSize + 2)),

                           ]
                       ),
                     ]
                   )

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
      ]))]
        );}

pw.Widget _buildDataRowPatientInfo(patientAndAppointmentInfo,fontSize) {

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