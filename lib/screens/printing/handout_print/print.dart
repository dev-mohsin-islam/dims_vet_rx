

import 'dart:convert';

import 'dart:ui' as ui;
import 'package:bijoy_helper/bijoy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/handout/handout.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../controller/general_setting/config/app_default_prescription_print_setup_data.dart';
import '../../../controller/general_setting/prescription_print_page_setup_controller.dart';
import '../../../utilities/history_category.dart';

class HandOutPrintPreview extends StatefulWidget {


  HandOutPrintPreview({super.key,});

  @override
  State<HandOutPrintPreview> createState() => _PrintPreviewState();
}

class _PrintPreviewState extends State<HandOutPrintPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title:   Row(
            children: [
              Text("Prescription Print", style: TextStyle(color: Colors.white),),
              Spacer(),
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.white), onPressed: () => Navigator.pop(context),
              )
            ],
          )),

      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: PdfPreview(
            allowSharing: false,
            canChangeOrientation: false,
            canChangePageFormat: false,
            canDebug: false,
            build: (format) => _printPdf()
          ),
        ),
      )
    );
  }
}


Future<Uint8List> _printPdf() async {
 PrescriptionPrintPageSetupController printSetup = Get.put(PrescriptionPrintPageSetupController());
  HandoutController handoutController = Get.put(HandoutController());
  List advices = [];
  if(handoutController.selectedHandOut.isNotEmpty){
    advices = handoutController.selectedHandOut;
  }

  final pdf = pw.Document(
    pageMode: PdfPageMode.fullscreen,
    version: PdfVersion.pdf_1_5,
    compress: true,
  );



    final fontData = await rootBundle.load('fonts/SutonnyMJRegular.ttf');
    final customFont = pw.Font.ttf(fontData.buffer.asByteData());


 List<pw.TextSpan> textSpans = [];

// Iterate through the data list and process each 'name'
  for (var item in advices) {
    String name = item.text ?? '';
    List<String> words = name.split(' ');
    textSpans.add(
      pw.TextSpan(
        text: '\n', // Adding a newline character
      ),
    );
    textSpans.add(
      pw.TextSpan(
        text: '\n', // Adding a newline character
      ),
    );
    textSpans.add(
      pw.TextSpan(
        text: utf8.decode(utf8.encode(unicodeToBijoy("${item.label} "))),
        style: pw.TextStyle(font: customFont, fontSize: 20, fontWeight: pw.FontWeight.bold, lineSpacing: 5), // Green for Bangla
      ),
    );
    textSpans.add(
      pw.TextSpan(
        text: '\n', // Adding a newline character
      ),
    );
    textSpans.add(
      pw.TextSpan(
        text: '\n', // Adding a newline character
      ),
    );
    for (var word in words) {
      // Check if the word contains Bangla characters
      if (RegExp(r'[\u0980-\u09FF]').hasMatch(word)) {
        textSpans.add(
          pw.TextSpan(
            text: utf8.decode(utf8.encode(unicodeToBijoy("$word "))),
            style: pw.TextStyle( font: customFont, fontSize: 15, lineSpacing: 5), // Green for Bangla
          ),
        );
      } else {
        textSpans.add(
          pw.TextSpan(
            text: '$word ',
            style: pw.TextStyle(fontSize: 15, lineSpacing: 5), // Blue for English
          ),
        );
      }
    }
    // Add a new line after processing each name
    textSpans.add(
      pw.TextSpan(
        text: '\n', // Adding a newline character
      ),
    );
  }

  int itemPerPage = 400;
  int totalPage = 1;
  if(textSpans.length > itemPerPage){
    totalPage = (textSpans.length / itemPerPage).ceil();
  }


    for (int i = 0; i < totalPage; i++) {

      final startIndex = i * itemPerPage;
      // Ensure that endIndex does not exceed the length of textSpans
      final endIndex = (startIndex + itemPerPage) > textSpans.length
          ? textSpans.length
          : startIndex + itemPerPage;

      final List advicesSublist = textSpans.sublist(startIndex, endIndex);

      double topMargin =  double.parse(printSetup.pageMarginTopController.text.toString()) * 72;
      double bottomMargin = double.parse(printSetup.pageMarginBottomController.text.toString()) * 72;;
      double leftMargin = double.parse(printSetup.pageMarginLeftController.text.toString()) * 72;;
      double rightMargin = double.parse(printSetup.pageMarginRightController.text.toString()) * 72;;



        final pageHeight = double.parse(printSetup.pageHeightController.text.toString()) * 72;
        final pageWidth = double.parse(printSetup.pageHeightController.text.toString()) * 72;

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
                // medicine and clinical data container
                pw.Expanded(
                  child: _buildContent(advicesSublist,customFont),
                ),

              ],
            );
          },
        ),
      );
    }

    return pdf.save();
}

pw.Widget _buildHeader(bool isFirstPage, isHeaderFooterActive, HeaderImage, prescriptionSettingData, headerImageHeight, headerHeight,) {
  double marginAroundFullPage = prescriptionSettingData[0]['marginAroundFullPage'];

  return pw.Padding(
    padding: pw.EdgeInsets.only(top: 0.0, bottom: marginAroundFullPage, left: marginAroundFullPage, right: marginAroundFullPage),
    child: pw.Column(
        children: [
          if(isHeaderFooterActive == DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValueImageHeaderFooter && headerImageHeight <600)
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 0.0),
              child: pw.Container(
                width: double.infinity,
                child: pw.Image(pw.MemoryImage(base64Decode(base64Encode(HeaderImage)))),
              ),
            ),
          if(isHeaderFooterActive ==DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValuePrintedHeaderFooter)
            pw.Container(
              width: double.infinity,
              child: pw.SizedBox(
                height: headerHeight ,
              ),
            ),
          if(isHeaderFooterActive ==DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValueCustomBuilderHeaderFooter)
            pw.Container(
              width: double.infinity,

              child: pw.SizedBox(
                height: headerHeight ,
              ),
            ),

        ])

  );
}

pw.Widget _buildFooter(isHeaderFooterActive,FooterImage,prescriptionSettingData, footerImageHeight, footerHeight) {
  double marginAroundFullPage = prescriptionSettingData[0]['marginAroundFullPage'];
  return pw.Padding(
    padding:  pw.EdgeInsets.only(top: marginAroundFullPage, bottom: 0.0, left: marginAroundFullPage, right: marginAroundFullPage),
    child: pw.Container(
        child: pw.Column(
            children: [
              if(isHeaderFooterActive == DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValueImageHeaderFooter && footerImageHeight <600)
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(horizontal: 0.0),
                  child: pw.Container(
                    width: double.infinity,
                    child: pw.Image(pw.MemoryImage(base64Decode(base64Encode(FooterImage)))),

                  ),
                ),
              if(isHeaderFooterActive ==DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValuePrintedHeaderFooter)
                pw.Container(
                  width: double.infinity,

                  child: pw.SizedBox(
                    height: footerHeight ,
                  ),
                ),
              if(isHeaderFooterActive ==DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValueCustomBuilderHeaderFooter)
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

 pw.Widget _buildContent(advices,customFont) {


  return pw.Padding(
    padding:  pw.EdgeInsets.symmetric(horizontal: 0, vertical: 0.0),
    child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [

          pw.SizedBox(width: 5),
          pw.Expanded(
              child:  pw.Padding(
                padding:  pw.EdgeInsets.only(top: 2, bottom: 0.0, left: 5.0, right: 5.0),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[

                      pw.SizedBox(height: 5),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: <pw.Widget>[
                            
                                pw.Column(
                                    children: [
                                    if(advices.isNotEmpty)
                                      pw.Column(
                                          mainAxisAlignment: pw.MainAxisAlignment.start,
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            if(advices.isNotEmpty)
                                              pw.Column(
                                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                                  children: [
                                                    pw.Text(utf8.decode(utf8.encode(unicodeToBijoy("ঊপদেশঃ "))), style: pw.TextStyle(fontSize: 28, font: customFont,lineSpacing: 4)),
                                                    pw.Divider(thickness: 1, color: PdfColors.black),
                                                    pw.SizedBox(height: 15),
                                                    pw.Column(
                                                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                                                        children: [
                                                          pw.RichText(
                                                            text: pw.TextSpan(
                                                              children: advices,
                                                            ),
                                                          ),

                                                        ]
                                                    )

                                                  ]
                                              ),


                                          ]
                                      )
                                    ]
                                )

                          ])
                    ])
              )
          )
        ]
    )
  );
  }

