

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

class MoneyReceiptPrint extends StatelessWidget {
final MoneyReceiptPrintInfo;
MoneyReceiptPrint({super.key, required this.MoneyReceiptPrintInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Money Receipt Print")),
      body: PdfPreview(
        build: (format) => _printPdf(MoneyReceiptPrintInfo),
      )
    );
  }
}

Future<Uint8List> _printPdf(MoneyReceiptPrintInfo) async {

  PrescriptionPrintPageSetupController setupController = Get.put(PrescriptionPrintPageSetupController());


// Convert List<dynamic> to List<Map<String, dynamic>>

    double headerHeight =   double.parse(setupController.pageHeaderHeightController.text.toString()) * 72  ;

    double footerHeight =    double.parse(setupController.pageFooterHeightController.text.toString()) * 72  ;
    // double footerHeight =  2.0;


    double footerImageHeight = 0.00;


    double headerImageHeight = 0.00;



  // int AdviceLength = advice.toString().length;


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
                  child: _buildContent(MoneyReceiptPrintInfo),
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

 pw.Widget _buildContent(MoneyReceiptPrintInfo) {
  var fontSize = parseDouble(setupController.pageFontSizeController.text.toString()); // Adjust the fontSize

  return pw.Column(
    children: [
     pw.Padding(
       padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
       child:  pw.SizedBox(
         child: pw.Column(
             children:  [
               pw.SizedBox(height: 15),
              pw.Text("Money Receipt",style: pw.TextStyle(fontSize: fontSize + 5)),
               pw.SizedBox(height: 15),

               pw.Row(
                 mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                 children: [
                   pw.Text("Name: ${MoneyReceiptPrintInfo[0]['paInfo'].name} ",style: pw.TextStyle(fontSize: fontSize)),
                   pw.Text("Invoice ID: ${MoneyReceiptPrintInfo[0]['moneyRecInfo'][0].invoice_id.toString()}",style: pw.TextStyle(fontSize: fontSize)),
                   pw.Text("Date: ${MoneyReceiptPrintInfo[0]['moneyRecInfo'][0].date.toString().substring(0,11)}",style: pw.TextStyle(fontSize: fontSize)),

                 ]
               ),
               pw.SizedBox(height: 15),
               pw.Container(
                 width: 400,
                 child: pw.Column(
                   children: [
                     pw.Container(
                       color: PdfColors.grey300,
                       child: pw.Padding(
                         padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                         child: pw.Row(
                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                           children: [
                             pw.Text("Sl"),
                             pw.Text("Details"),
                             pw.Text("Amount"),
                           ],
                         )
                       ),
                     ),
                     pw.SizedBox(height: 15),
                     pw.Container(

                         child: pw.Padding(
                           padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                           child: pw.Row(
                             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                             children: [
                               pw.Text("1."),
                               pw.Text("${MoneyReceiptPrintInfo[0]['moneyRecInfo'][0].description.toString()}",style: pw.TextStyle(fontSize: fontSize)),
                               pw.Text("${MoneyReceiptPrintInfo[0]['moneyRecInfo'][0].fee.toString()}",style: pw.TextStyle(fontSize: fontSize)),

                             ],
                           ),
                         )
                       ),
                     pw.SizedBox(height: 15),
                     pw.Container(
                       height: 1,
                       width: double.infinity,
                         color: PdfColors.grey300,

                     ),
                     pw.Container(
                       decoration: pw.BoxDecoration(

                       ),
                         child: pw.Padding(
                           padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                           child: pw.Row(
                             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                             children: [
                               pw.Text(""),
                               pw.Text("Total",style: pw.TextStyle(fontSize: fontSize)),
                               pw.Text("${MoneyReceiptPrintInfo[0]['moneyRecInfo'][0].fee.toString()}",style: pw.TextStyle(fontSize: fontSize)),

                             ],
                           ),
                         )
                       ),
                   ]
                 )
               ),


             ]
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

