

import 'dart:convert';

import 'dart:ui' as ui;
import 'package:bijoy_helper/bijoy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/general_setting/general_setting_controller.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../controller/general_setting/config/app_default_prescription_print_setup_data.dart';
import '../../../controller/general_setting/prescription_print_page_setup_controller.dart';
import '../../../utilities/history_category.dart';
final PrescriptionPrintPageSetupController printSetup = Get.put(PrescriptionPrintPageSetupController());
final GeneralSettingController generalSettings = Get.put(GeneralSettingController());


class BrandReport extends StatefulWidget {
  final List selectedClinicalDataColumn1;
  final List selectedMedicineDataColumn2;


  BrandReport({super.key, required this.selectedClinicalDataColumn1, required this.selectedMedicineDataColumn2});

  @override
  State<BrandReport> createState() => _PrintPreviewState();
}

class _PrintPreviewState extends State<BrandReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title:   Row(
            children: [
              Text("Brand Report", style: TextStyle(color: Colors.white),),
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
            allowSharing: true,
            canChangeOrientation: false,
            canChangePageFormat: false,
            canDebug: false,
            dynamicLayout: true,
            build: (format) => _printPdf(widget.selectedClinicalDataColumn1,widget.selectedMedicineDataColumn2)
          ),
        ),
      )
    );
  }
}


Future<Uint8List> _printPdf(dataColumn1,dataColumn2,) async {
  printSetup.getAllData('');
  // print(jsonEncode(dataColumn1));
  // print(jsonEncode(dataColumn2));
  // print(jsonEncode(patientAndAppointmentInfo));
  // for(var i = 0; i < dataColumn2.length; i++){
  //   var drug = CompanyBrandReport.branReport[index]['drug'];
  //   var company = CompanyBrandReport.branReport[index]['company'];
  //   var generic = CompanyBrandReport.branReport[index]['generic'];
  //   var doses = CompanyBrandReport.branReport[index]['doses'];
  //   var brandInfo = CompanyBrandReport.branReport[index]['brandInfo'];
  // }





  var clinicalDataPrintingPerPage = parseDouble(printSetup.clinicalDataPrintingPerPageController.text.toString());
  var brandDataPrintingPerPage = parseDouble(printSetup.brandDataPrintingPerPageController.text.toString());
  var clinicalAndBrandDataPerPageGap = parseDouble(printSetup.clinicalAndBrandDataPerPageGapController.text.toString());

  final int totalItemsColumn1 = dataColumn1.length;
  final int totalItemsColumn2 = dataColumn2.length;
  
    int maxTotalItems = totalItemsColumn1 - clinicalAndBrandDataPerPageGap > totalItemsColumn2 ? totalItemsColumn1 : totalItemsColumn2;

  if( maxTotalItems ==0 ||  maxTotalItems == -1){
    maxTotalItems = 1;
  }

  int itemsPerPageColumn1 = clinicalDataPrintingPerPage.toInt();
  int itemsPerPageColumn2 = brandDataPrintingPerPage.toInt();



  double sidebarWidth =  parseDouble(printSetup.pageSideBarWidthController.text.toString()) * 50 ?? 0.0;
  double fontSize = parseDouble(printSetup.pageFontSizeController.text.toString()) ?? 10.0;

  double headerHeight =   parseDouble(printSetup.pageHeaderHeightController.text.toString()) * 50 ?? 0.0;
  double footerHeight =   parseDouble(printSetup.pageFooterHeightController.text.toString()) * 50 ?? 0.0;

   double footerImageHeight = 0.00;
   double headerImageHeight = 0.00;

  // if(FooterImage.toString().isNotEmpty) {
  //       Uint8List imageBytes = base64Decode(FooterImage);
  //       ui.Codec codecF = await ui.instantiateImageCodec(imageBytes);
  //       ui.FrameInfo frameInfoF = await codecF.getNextFrame();
  //       footerImageHeight = frameInfoF.image.height.toDouble();
  //     };

  // if(HeaderImage.toString().isNotEmpty){
  //       Uint8List imageBytesH = base64Decode(HeaderImage);
  //       ui.Codec codecH = await ui.instantiateImageCodec(imageBytesH);
  //       ui.FrameInfo frameInfoH = await codecH.getNextFrame();
  //         headerImageHeight = frameInfoH.image.height.toDouble();
  //     };

    // double headerImageHeight = 200.0;
    // double footerImageHeight = 100.0;

  // double fontSize =  double.tryParse(prescriptionSettingData[0]['font_size'].toString())  ?? 0.0;
  // double sidebarWidth = double.tryParse(prescriptionSettingData[0]['sidebarWidth'].toString()) ?? 0.0;
  // fontSize = fontSize - 2;

  // int AdviceLength = advice.toString().length;


  final pdf = pw.Document(
    pageMode: PdfPageMode.fullscreen,
    version: PdfVersion.pdf_1_5,
    compress: true,
  );



    final fontData = await rootBundle.load('fonts/SutonnyMJRegular.ttf');

    final customFont = pw.Font.ttf(fontData.buffer.asByteData());


   
//
//     if(advices.toString().isEmpty){
//       print("1");
//       itemsPerPageColumn2 = 4;
//     }
//     if(advices.toString().isEmpty && dataColumn2.length < 13){
//       print("1");
//       itemsPerPageColumn2 = 14;
//     }
//     if(advices.toString().isNotEmpty && dataColumn2.length > 13 && dataColumn2.length < 22){
//       itemsPerPageColumn2 = 13;
//     }
//
//     if(isHeaderFooterActive == DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValueImageHeaderFooter){
//       var totalPixel = headerImageHeight + footerImageHeight -50;
//       if(totalPixel  > 100 && totalPixel <= 150){
//         itemsPerPageColumn1 = 22;
//       }
//
//       if(totalPixel  > 150 && totalPixel <= 200){
//         itemsPerPageColumn1 = 24;
//       }
//
//       if(totalPixel  >= 100 && totalPixel < 150 && advices.toString().isEmpty && fontSize <14){
//         itemsPerPageColumn2 = 15;
//       }
//       if(totalPixel  >= 150 && totalPixel <= 200 && advices.toString().isEmpty && fontSize <14){
//         itemsPerPageColumn2 = 13;
//       }
//
//       if(totalPixel  >= 100 && totalPixel < 150 && advices.toString().isNotEmpty && fontSize <=14){
//         itemsPerPageColumn2 = 13;
//       }
//       if(totalPixel  >= 150 && totalPixel <= 200 && advices.toString().isNotEmpty && fontSize <=14 && advices.toString().length <200){
//         itemsPerPageColumn2 = 11;
//         print(advices.toString().length);
//         print(advices.toString().length);
//       }
//       if(totalPixel  >= 150 && totalPixel <= 200 && advices.toString().isNotEmpty && fontSize <=14 && advices.toString().length >250){
//         itemsPerPageColumn2 = 10;
//       }
//
// }else{
//
//       var totalPixel = headerHeight + footerHeight;
//       // if(totalPixel >=50 && totalPixel <= 100 && advices.toString().isEmpty && fontSize <12){
//       //   itemsPerPageColumn2 = 14;
//       // }
//       if(totalPixel  > 100 && totalPixel <= 150){
//         itemsPerPageColumn1 = 22;
//       }
//
//       if(totalPixel  > 150 && totalPixel <= 200){
//         itemsPerPageColumn1 = 24;
//       }
//
//       if(totalPixel  >= 100 && totalPixel < 150 && advices.toString().isEmpty && fontSize <14){
//         itemsPerPageColumn2 = 14;
//       }
//       if(totalPixel  >= 150 && totalPixel <= 200 && advices.toString().isEmpty && fontSize <14){
//         itemsPerPageColumn2 = 14;
//       }
//
//       if(totalPixel  >= 100 && totalPixel < 150 && advices.toString().isNotEmpty && fontSize <=14){
//         itemsPerPageColumn2 = 14;
//       }
//       if(totalPixel  >= 150 && totalPixel <= 200 && advices.toString().isNotEmpty && fontSize <=14 && advices.toString().length <200){
//         itemsPerPageColumn2 = 12;
//         print(advices.toString().length);
//         print(advices.toString().length);
//       }
//       if(totalPixel  >= 150 && totalPixel <= 200 && advices.toString().isNotEmpty && fontSize <=14 && advices.toString().length >250){
//         itemsPerPageColumn2 = 10;
//       }
//
//   }
//

    int totalPages = (maxTotalItems / itemsPerPageColumn2).ceil();

      if(totalItemsColumn1 - clinicalAndBrandDataPerPageGap > totalItemsColumn2){
        totalPages = (maxTotalItems / itemsPerPageColumn1).ceil();
        }

    for (int i = 0; i < totalPages; i++) {
      final startIndex2 = i * itemsPerPageColumn2;
      final startIndex1 = i * itemsPerPageColumn1;
      final List<String> column1Sublist = [];

      final List column2Sublist = [];

      // Calculate endIndex for column2
      final endIndexColumn2 = (i + 1) * itemsPerPageColumn2;
      final endIndexColumn1 = (i + 1) * itemsPerPageColumn1;

      if (startIndex1 < totalItemsColumn1) {
        column1Sublist.addAll(dataColumn1.sublist(startIndex1, endIndexColumn1 < totalItemsColumn1 ? endIndexColumn1 : totalItemsColumn1));
      }

      // Add items from column2
      if (startIndex2 < totalItemsColumn2) {
        column2Sublist.addAll(dataColumn2.sublist(startIndex2, endIndexColumn2 < totalItemsColumn2 ? endIndexColumn2 : totalItemsColumn2));
      }

      double? topMargin = double.tryParse(printSetup.pageMarginTopController.text.toString());
      double? bottomMargin = double.tryParse(printSetup.pageMarginBottomController.text.toString());
      double? leftMargin = double.tryParse(printSetup.pageMarginLeftController.text.toString());
      double? rightMargin = double.tryParse(printSetup.pageMarginRightController.text.toString());


       if(leftMargin != null && leftMargin <=0.0){
         leftMargin = 10.00;
       }
       if(rightMargin != null && rightMargin <=0.0){
         rightMargin = 10.00;
       }

        final pdfPageFormat = PdfPageFormat.a4.copyWith(
          marginTop: topMargin ?? 0.0,
          marginLeft: leftMargin ?? 0.0,
          marginRight:  rightMargin ?? 0.0,
          marginBottom: bottomMargin ?? 0.0,
        );




      pdf.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: pdfPageFormat,
            margin:  pw.EdgeInsets.only(
              left: rightMargin ?? 0.0,
              right: leftMargin ?? 0.0,
              top: topMargin ?? 0.0,
              bottom: bottomMargin ?? 0.0,
            ),
          ),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // header container
                _buildHeader(i == 0, printSetup.printHeaderFooterOrNonValue, printSetup.headerFooterAndBgImage[0]['headerImage'], headerImageHeight, headerHeight),

                // Patient information container only for first page
                // i == 0 ? _buildDataRowPatientInfo(patientAndAppointmentInfo,prescriptionSettingData, generalSetting) : pw.SizedBox(height: 5),

                if(generalSettings.settingsItemsDataList.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "horizontalBorder"))
                pw.Container(
                  width: double.infinity, // Adjust the width as needed
                  height: 1,
                  color: PdfColors.black,
                ),

                // medicine and clinical data container
                pw.Expanded(
                  child: _buildContent(column1Sublist, column2Sublist, totalPages, i + 1 , customFont, sidebarWidth,fontSize, itemsPerPageColumn2, itemsPerPageColumn1, totalItemsColumn1, totalItemsColumn2,),
                ),

                // footer container
                _buildFooter(printSetup.printHeaderFooterOrNonValue,printSetup.headerFooterAndBgImage[0]['footerImage'],footerImageHeight, footerHeight),
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
}

pw.Widget _buildHeader(bool isFirstPage, isHeaderFooterActive, HeaderImage, headerImageHeight, headerHeight,) {
  double marginAroundFullPage = parseDouble(printSetup.marginAroundFullPageController.text.toString());


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

pw.Widget _buildFooter(isHeaderFooterActive,FooterImage, footerImageHeight, footerHeight) {
  double marginAroundFullPage = parseDouble(printSetup.marginAroundFullPageController.text.toString());
print(isHeaderFooterActive);
  return pw.Padding(
    padding:  pw.EdgeInsets.only(top: marginAroundFullPage, bottom: 0.0, left: marginAroundFullPage, right: marginAroundFullPage),
    child: pw.Container(
        child: pw.Column(
            children: [
              if(isHeaderFooterActive == DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValueImageHeaderFooter)
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

 pw.Widget _buildContent(List<String> column1Data, List column2Data, totalPages, i, customFont,sidebarWidth,fontSize, itemsPerPageColumn2, itemsPerPageColumn1, totalPagesColumn1, totalPagesColumn2) {
  List selectedMedicine = column2Data;

  final PrescriptionPrintPageSetupController printSetup = Get.put(PrescriptionPrintPageSetupController());

  double marginAroundFullPage = parseDouble(printSetup.marginAroundFullPageController.text.toString());
  double rxDataStartingTopMargin = parseDouble(printSetup.rxDataStartingTopMarginController.text.toString());
  double clinicalDataStartingTopMargin = parseDouble(printSetup.clinicalDataStartingTopMarginController.text.toString());
  double clinicalDataMargin = parseDouble(printSetup.clinicalDataMarginController.text.toString());
  double brandDataMargin = parseDouble(printSetup.brandDataMarginController.text.toString());
  // double marginAroundFullPage = prescriptionSettingData[0]['marginAroundFullPage'];
  // double rxDataStartingTopMargin = prescriptionSettingData[0]["rxDataStartingTopMargin"];
  // double clinicalDataStartingTopMargin = prescriptionSettingData[0]["clinicalDataStartingTopMargin"];
  // double clinicalDataMargin = prescriptionSettingData[0]['clinicalDataMargin'];
  // double brandDataMargin = prescriptionSettingData[0]['brandDataMargin'];
 var digitalSignature = printSetup.headerFooterAndBgImage[0]['digitalSignature'];
 var prescription_id;
 var rxIcon = printSetup.headerFooterAndBgImage[0]['rxIcon'];
  return pw.Padding(
    padding:  pw.EdgeInsets.symmetric(horizontal: marginAroundFullPage, vertical: 0.0),
    child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Padding(
            padding: pw.EdgeInsets.only(top: clinicalDataStartingTopMargin, bottom: 0.0, left: 5.0, right: 5.0),
            child: pw.SizedBox(
              width: sidebarWidth,
              child: pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: column1Data.asMap().entries.map((entry){
                    final index = entry.key;
                    final item = entry.value;
                    return  pw.Column(
                        children: [
                          item.isNotEmpty ? pw.Column(
                              children: [
                                ( item == "Chief Complaint" || item == "Diagnosis" || item == "On Examination" || item == "Investigation Advice" || item == "Investigation Report" || item == HistoryCategory.personalHistoryTitle || item == HistoryCategory.allergyHistoryTitle || item == HistoryCategory.familyHistoryTitle || item == HistoryCategory.socialHistoryTitle || item == "Disease Activity Score") ?
                                pw.Column(
                                    children: [
                                      pw.SizedBox(height: 5),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(1.0),
                                        child: pw.Text("${item}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize)),
                                      ),

                                    ]
                                ) :
                                pw.Padding(
                                    padding: pw.EdgeInsets.only(left: 5.0),
                                  child: pw.Column(
                                      children: [
                                        if(item.isNotEmpty && item != "")
                                          pw.Padding(
                                            padding: pw.EdgeInsets.symmetric(vertical: clinicalDataMargin),
                                            child: pw.Text("- ${item}  ", style: pw.TextStyle(fontSize: fontSize)),
                                          )
                                      ]
                                  ),
                                ),
                              ]
                          ) : pw.Column(
                              children: [
                              ]
                          ),

                        ]
                    ) ;
                  }).toList(),
                ),
              ),
            ),
          ),

          // if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "verticalBorder"))
            pw.Container(
              width: 1, // Adjust the width as needed
              height: double.infinity,
              color: PdfColors.black,
            ),
          pw.SizedBox(width: 5),
          pw.Expanded(
              child:  pw.Padding(
                padding:  pw.EdgeInsets.only(top: rxDataStartingTopMargin, bottom: 0.0, left: 5.0, right: 5.0),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      // if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "RxIcon"))
                        if(rxIcon.isEmpty)
                        // pw.Text("Rx ${selectedMedicine.length.toString()}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                      // if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "RxIcon"))
                        if(!rxIcon.isEmpty)
                         pw.Container(
                           height: 25,
                           child:  pw.Image(pw.MemoryImage(base64Decode(base64Encode(rxIcon)))),
                         ),
                      pw.SizedBox(height: 5),
                      pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: <pw.Widget>[
                            
                                pw.Column(
                                    children: [
                                      if (selectedMedicine.isNotEmpty)
                                        for (var index = 0; index < selectedMedicine.length; index++)

                                      pw.Padding(
                                        padding:  pw.EdgeInsets.symmetric(vertical: brandDataMargin),
                                        child: pw.Column(
                                          children:  [
                                            if (selectedMedicine[index]['doses'] != null && selectedMedicine[index]['doses'].isNotEmpty)
                                              pw.Container(
                                                padding: const pw.EdgeInsets.all(2),
                                                child: pw.Row(
                                                  mainAxisAlignment:
                                                  pw.MainAxisAlignment.spaceBetween,
                                                  children:  [
                                                    pw.Flexible(
                                                      child: pw.Column(
                                                        crossAxisAlignment:
                                                        pw.CrossAxisAlignment.start,
                                                        children:  [
                                                          // if(selectedMedicine[index]['drug'].prescription_id != null)
                                                          pw.Text("Prescription Id: ${selectedMedicine[index]['drug'].prescription_id} --- Date: ${selectedMedicine[index]['drug'].date}"),
                                                          pw.SizedBox(height: 5),


                                                          // if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "BrandDosesUppercase") == false)
                                                            pw.Wrap(
                                                              children: <pw.Widget>[
                                                                pw.Text("${index + 1}."),
                                                                pw.SizedBox(width: 5),
                                                                pw.Text("${selectedMedicine[index]['brandInfo'].brand_name}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: fontSize, )),
                                                                pw.SizedBox(width: 5,),
                                                                pw.Text("${selectedMedicine[index]['brandInfo'].form ?? ""}", style: pw.TextStyle(fontSize: fontSize),),
                                                                pw.SizedBox(width: 5,),
                                                                pw.Text("${selectedMedicine[index]['brandInfo'].strength ?? ""}", style: pw.TextStyle(fontSize: fontSize)),
                                                              ],
                                                            ),

                                                          if(selectedMedicine[index]['doses'].isNotEmpty)
                                                            for (var i = 0; i < selectedMedicine[index]['doses'].length; i++)
                                                              pw.Column(
                                                                crossAxisAlignment:
                                                                pw.CrossAxisAlignment.start,
                                                                children: <pw.Widget>[
                                                                  pw.Row(
                                                                    children: [
                                                                      pw.SizedBox(width: 15),
                                                                      if(selectedMedicine[index]['doses'][i].doze != null && RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(selectedMedicine[index]['doses'][i].doze) == true)
                                                                        pw.Text(" ${selectedMedicine[index]['doses'][i].doze ?? ""} ", style: pw.TextStyle(fontSize: fontSize)),
                                                                      if(selectedMedicine[index]['doses'][i].doze != null && RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(selectedMedicine[index]['doses'][i].doze) == false)
                                                                        pw.Text(utf8.decode(utf8.encode(unicodeToBijoy("${selectedMedicine[index]['doses'][i].doze ?? ""}"))),style: pw.TextStyle(fontSize: fontSize, font: customFont)),
                                                                      pw.Text("--"),

                                                                      // if(selectedMedicine[index]['doses'][i] != null && RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(selectedMedicine[index]['doses'][i]['instruction']) == true)
                                                                      //   pw.Text(" ${selectedMedicine[index]['doses'][i]['instruction'] ?? ""} ", style: pw.TextStyle(fontSize: fontSize)),
                                                                      // if(selectedMedicine[index]['doses'][i] != null && RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(selectedMedicine[index]['doses'][i]['instruction']) == false)
                                                                      //   pw.Text(utf8.decode(utf8.encode(unicodeToBijoy("${selectedMedicine[index]['doses'][i]['instruction'] ?? ""}"))),style: pw.TextStyle(fontSize: fontSize, font: customFont)),
                                                                      // pw.Text(" -- "),

                                                                      if(selectedMedicine[index]['doses'][i].duration != null && RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(selectedMedicine[index]['doses'][i].duration) == true)
                                                                        pw.Text(" ${selectedMedicine[index]['doses'][i].duration ?? ""} ", style: pw.TextStyle(fontSize: fontSize)),
                                                                      if(selectedMedicine[index]['doses'][i] != null && RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(selectedMedicine[index]['doses'][i].duration) == false)
                                                                        pw.Text(utf8.decode(utf8.encode(unicodeToBijoy("${selectedMedicine[index]['doses'][i].duration ?? ""}"))),style: pw.TextStyle(fontSize: fontSize, font: customFont)),

                                                                      // if(selectedMedicine[index]['doses'][i].toString().isNotEmpty)
                                                                      //   pw.Text(" -- "),
                                                                      //
                                                                      // if(selectedMedicine[index]['dose'][i]['note'] != null && RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(selectedMedicine[index]['dose'][i]['note']) == true)
                                                                      //   pw.Text(" ${selectedMedicine[index]['dose'][i]['note'] ?? ""} ", style: pw.TextStyle(fontSize: fontSize)),
                                                                      // if(selectedMedicine[index]['dose'][i]['note'] != null && RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(selectedMedicine[index]['dose'][i]['note']) == false)
                                                                      //   pw.Text(utf8.decode(utf8.encode(unicodeToBijoy("${selectedMedicine[index]['dose'][i]['note'] ?? ""}"))),style: pw.TextStyle(fontSize: fontSize, font: customFont)),


                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                          ],

                                        ),
                                      ),
                               
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

pw.Widget _buildDataRowPatientInfo(patientAndAppointmentInfo, prescriptionSettingData, generalSetting) {
    double marginBeforePatientName = prescriptionSettingData[0]['marginBeforePatientName'];
    double marginBeforePatientAge = prescriptionSettingData[0]['marginBeforePatientAge'];
    double marginBeforePatientId = prescriptionSettingData[0]['marginBeforePatientId'];
    double marginBeforePatientGender = prescriptionSettingData[0]['marginBeforePatientGender'];
    double marginBeforePatientDate = prescriptionSettingData[0]['marginBeforePatientDate'];
    double marginAroundFullPage = prescriptionSettingData[0]['marginAroundFullPage'];
    double fontSize = prescriptionSettingData[0]['font_size_pa_info'] !=null ? prescriptionSettingData[0]['font_size_pa_info'] : 8;
   //marginBeforePatientId
  return pw.Padding(
    padding:  pw.EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0 + marginAroundFullPage),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
       pw.Padding(
         padding:  pw.EdgeInsets.symmetric(vertical: 0.0, horizontal: marginBeforePatientId),
         child:  pw.Row(
             children: [
               if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "PatientIdLabel"))
                 pw.Text('ID: ',style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold)),
               pw.Text("${patientAndAppointmentInfo[0]['patient_id']}",style: pw.TextStyle(fontSize: fontSize)),
             ]
         ),
       ),


        pw.Padding(
          padding:   pw.EdgeInsets.symmetric(vertical: 0.0, horizontal: marginBeforePatientName),
          child: pw.Row(
              children: [
                if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "NameLabel"))
                  pw.Text('Name: ', style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold)),
                pw.Text("${patientAndAppointmentInfo[0]['name']}", style: pw.TextStyle(fontSize: fontSize)),
              ]
          ),
        ),


        pw.Padding(
          padding:   pw.EdgeInsets.symmetric(vertical: 0.0, horizontal: marginBeforePatientAge),
          child: pw.Row(
              children: [
                if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "AgeLabel"))
                  pw.Text('Age: ', style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold)),
                pw.Text("${patientAndAppointmentInfo[0]['age']}", style: pw.TextStyle(fontSize: fontSize)),
              ]
          ),
        ),


       pw.Padding(
         padding: pw.EdgeInsets.symmetric(vertical: 0.0, horizontal: marginBeforePatientGender),
         child: pw.Row(
             children: [
               if(patientAndAppointmentInfo[0]['sex'] !=0 && patientAndAppointmentInfo[0]['sex'] == 1)
                 pw.Row(
                     children: [
                       if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "GenderLabel"))
                         pw.Text("Gender: ", style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold)),
                       pw.Text("M", style: pw.TextStyle(fontSize: fontSize)),
                     ]
                 ),
               if(patientAndAppointmentInfo[0]['sex'] !=0 && patientAndAppointmentInfo[0]['sex'] == 2)
                 pw.Row(
                     children: [
                       if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "GenderLabel"))
                         pw.Text("Gender: ", style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold)),
                       pw.Text("F", style: pw.TextStyle(fontSize: fontSize)),
                     ]
                 ),
               if(patientAndAppointmentInfo[0]['sex'] !=0 && patientAndAppointmentInfo[0]['sex'] == 3)
                 pw.Row(
                     children: [
                       if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "GenderLabel"))
                         pw.Text("Gender: ", style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold)),
                       pw.Text("Transgender", style: pw.TextStyle(fontSize: fontSize)),
                     ]
                 )
             ]
         ),
       ),

       pw.Padding(
         padding:  pw.EdgeInsets.symmetric(vertical: 0.0, horizontal: marginBeforePatientDate),
         child: pw.Row(
             children: [
               if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "DateLabel"))
                 pw.Text('Date: ', style: pw.TextStyle(fontSize: fontSize)),
               pw.Text("${patientAndAppointmentInfo[0]['date']}", style: pw.TextStyle(fontSize: fontSize)),
             ]
         )
       )
      ],
    ),
  );
}