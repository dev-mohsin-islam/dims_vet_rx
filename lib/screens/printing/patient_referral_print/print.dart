

import 'dart:convert';

import 'dart:ui' as ui;
import 'package:bijoy_helper/bijoy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/authentication/login_controller.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../controller/general_setting/prescription_print_page_setup_controller.dart';
import '../../../utilities/history_category.dart';
final PrescriptionPrintPageSetupController setupController = Get.put(PrescriptionPrintPageSetupController());
final LoginController loginController = Get.put(LoginController());

class PatientReferralPrint extends StatelessWidget {
final referralInformation; 
PatientReferralPrint({super.key, required this.referralInformation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prescription Print")),
      body: PdfPreview(
        build: (format) => _printPdf(referralInformation),
      )
    );
  }
}

Future<Uint8List> _printPdf(referralInformation) async {

  PrescriptionPrintPageSetupController setupController = Get.put(PrescriptionPrintPageSetupController());


    double headerHeight =   parseDouble(setupController.pageHeaderHeightController.text.toString()) * 72;

    double footerHeight =   parseDouble(setupController.pageFooterHeightController.text.toString()) * 72 ;

    double footerImageHeight = 0.00;
    double headerImageHeight = 0.00;


  final pdf = pw.Document(
    pageMode: PdfPageMode.fullscreen,
    version: PdfVersion.pdf_1_5,
    compress: true,
  );



    final fontData = await rootBundle.load('fonts/SutonnyMJRegular.ttf');
    final customFont = pw.Font.ttf(fontData.buffer.asByteData());


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
                  child: _buildContent(referralInformation),
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
      child: pw.Column(

          children: [
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

 pw.Widget _buildContent(refInfo) {
  var fontSize = parseDouble(setupController.pageFontSizeController.text.toString()); // Adjust the fontSize

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
                         pw.Text("PATIENT REFERRAL FORM", style: pw.TextStyle(fontSize: fontSize + 2, fontWeight: pw.FontWeight.bold)),
                       ]
                   ),
                   pw.Container(
                     width: MediaQuery.of(Get.context!).size.width * 0.8,
                     // child: pw.Image(pw.MemoryImage(imageBytesH)),

                     child: pw.SizedBox(
                       // height: 200,
                       height: 1,
                     ),
                   ),
                   pw.SizedBox(height: 15),
                   pw.Text("Patient Information", style: pw.TextStyle(fontSize: fontSize + 2, fontWeight: pw.FontWeight.bold)),
                   pw.SizedBox(height: 15),
                  pw.Text("Name: ${refInfo['refPaInfo'].name}", style: pw.TextStyle(fontSize: fontSize)),
                   pw.SizedBox(height: 10),
                  pw.Text("Contact: ${refInfo['refPaInfo'].phone}", style: pw.TextStyle(fontSize: fontSize)),
                   pw.SizedBox(height: 15),
                   // pw.Container(
                   //   width: double.infinity,
                   //   // child: pw.Image(pw.MemoryImage(imageBytesH)),
                   //   child: pw.SizedBox(
                   //     // height: 200,
                   //     height: 1,
                   //   ),
                   // ),
                   pw.Text("Clinical Information", style: pw.TextStyle(fontSize: fontSize + 2, fontWeight: pw.FontWeight.bold)),
                   pw.SizedBox(height: 10),
                   pw.Text('${ refInfo['refInfo'].clinical_information}', style: pw.TextStyle(fontSize: fontSize)),

                   pw.SizedBox(height: 10),
                   pw.Text('Special Notes: ${refInfo['refInfo'].special_notes}', style: pw.TextStyle(fontSize: fontSize)),

                   pw.SizedBox(height: 10),
                   pw.Text("Reason For Referral: ", style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold)),
                   pw.Text('${refInfo['refInfo'].reason_for_referral}', style: pw.TextStyle(fontSize: fontSize)),

                   pw.SizedBox(height: 20),
                   pw.Text("Referred To: ", style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold)),
                   pw.SizedBox(height: 10),

                   pw.Column(
                     // mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                       crossAxisAlignment: pw.CrossAxisAlignment.start,
                       children: [

                           pw.Text("Name: ${refInfo['refDocInfo'].name}", style: pw.TextStyle( fontSize: fontSize)),
                         pw.SizedBox(height: 5),
                           pw.Text("Designation: ${refInfo['refDocInfo'].designation}", style: pw.TextStyle( fontSize: fontSize)),
                         pw.SizedBox(height:5),
                           pw.Text("Phone: ${refInfo['refDocInfo'].phone}" , style: pw.TextStyle( fontSize: fontSize)),
                         pw.SizedBox(height: 5),
                         pw.Text("Address: ${refInfo['refDocInfo'].address}" , style: pw.TextStyle(fontSize: fontSize)),


                       ]
                   ),

                   pw.SizedBox(height:50),
                   pw.Text("I would like to refer this patient to you for Evaluation Management and Consultation", style: pw.TextStyle(fontSize: fontSize)),


                   pw.SizedBox(height:50),
                   pw.Column(
                       mainAxisAlignment: pw.MainAxisAlignment.start,
                     crossAxisAlignment: pw.CrossAxisAlignment.start,
                     children: [
                       pw.Text("Thanking you", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize)),
                       pw.SizedBox(height: 45),

                       // pw.SizedBox(width: MediaQuery.of(Get.context!).size.width * 0.08),
                       pw.Text("Signature", style: pw.TextStyle(fontSize: fontSize + 2)),
                       pw.Text("${loginController.userName.value}", style: pw.TextStyle(fontSize: fontSize + 2)),
                       pw.Text("Date: ${refInfo['refInfo'].date.toString().substring(0, 11)}", style: pw.TextStyle(fontSize: fontSize + 2)),
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
        // pw.Text('Name: ${patientAndAppointmentInfo[0]['name']}', style: pw.TextStyle(fontSize: fontSize)),
        // pw.Text('Procedure Note', style: pw.TextStyle(fontSize: fontSize + 2, fontWeight: pw.FontWeight.bold)),
        // pw.Text('Age: ${patientAndAppointmentInfo[0]['age']}', style: pw.TextStyle(fontSize: fontSize)),
        // if(patientAndAppointmentInfo[0]['sex'] !=0 && patientAndAppointmentInfo[0]['sex'] == 1)
        //   pw.Text("Gender: M", style: pw.TextStyle(fontSize: fontSize)),
        // if(patientAndAppointmentInfo[0]['sex'] !=0 && patientAndAppointmentInfo[0]['sex'] == 2)
        //   pw.Text("Gender: F", style: pw.TextStyle(fontSize: fontSize)),
        // pw.Text('Date: ${patientAndAppointmentInfo[0]['date']}', style: pw.TextStyle(fontSize: fontSize)),
      ],
    ),
  );
}