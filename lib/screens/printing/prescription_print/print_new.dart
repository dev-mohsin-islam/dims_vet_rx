

import 'dart:convert';
import 'dart:io';

import 'dart:ui' as ui;
import 'package:bijoy_helper/bijoy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/authentication/login_controller.dart';
import 'package:dims_vet_rx/models/patient_appointment_model.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../controller/general_setting/config/app_default_prescription_print_setup_data.dart';
import '../../../controller/general_setting/data_ordering_controller.dart';
import '../../../controller/general_setting/prescription_print_page_setup_controller.dart';
import '../../../models/appointment/appointment_model.dart';
import '../../../models/patient/patient_model.dart';
import '../../../utilities/app_strings.dart';
import '../../../utilities/history_category.dart';

class NewPrintPreview extends StatefulWidget {
  final List selectedClinicalDataColumn1;
  final List selectedMedicineDataColumn2;
  final PatientAppointment printPatientAndAppointmentInfo;
  final List advices;

  var prescriptionSettingData;
  var generalSetting;
  var patientHistory;

  NewPrintPreview({super.key, required this.selectedClinicalDataColumn1, required this.selectedMedicineDataColumn2, required this.printPatientAndAppointmentInfo,
     required this.advices, this.prescriptionSettingData, this.generalSetting, this.patientHistory});

  @override
  State<NewPrintPreview> createState() => _PrintPreviewState();
}

class _PrintPreviewState extends State<NewPrintPreview> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title:   Row(
            children: [
              Text("Prescription Print ${(DateTime.now().toString())}", style: TextStyle(color: Colors.white),),
              Spacer(),
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.white), onPressed: () => Navigator.pop(context),
              )
            ],
          )),
      body: Center(
        child: Container(
          width: Platform.isAndroid ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.6,
          child: PdfPreview(
            allowSharing: false,
            canChangeOrientation: false,
            canChangePageFormat: false,
            canDebug: false,
            build: (format) => _printPdf(widget.selectedClinicalDataColumn1,widget.selectedMedicineDataColumn2,widget.printPatientAndAppointmentInfo,widget.advices,widget.prescriptionSettingData, widget.generalSetting, widget.patientHistory)
          ),
        ),
      )
    );
  }
}

Future<Uint8List> generateQrCode(String data) async {
  final qrValidationResult = QrValidator.validate(
    data: data,
    version: QrVersions.auto,
    errorCorrectionLevel: QrErrorCorrectLevel.L,
  );
  if (qrValidationResult.status == QrValidationStatus.valid) {
    final qrCode = qrValidationResult.qrCode;
    final painter = QrPainter.withQr(
      qr: qrCode!,
      color: const Color(0xFF000000),
      emptyColor: const Color(0xFFFFFFFF),
      gapless: true,
    );
    final picData = await painter.toImageData(2048, format: ui.ImageByteFormat.png);
    return picData!.buffer.asUint8List();
  } else {
    throw Exception('QR code generation failed');
  }
}

Future<Uint8List> _printPdf(dataColumn1,dataColumn2,patientAndAppointmentInfo,advices, prescriptionSettingData, generalSetting, patientHistory) async {
  final PrescriptionPrintPageSetupController printSetup = Get.put(PrescriptionPrintPageSetupController());
   PatientModel patientInfo = patientAndAppointmentInfo.patient;
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


  List<dynamic> pageSetupData = printSetup.prescriptionPrintSetupData.where((item) => item['key'] == "PrintPageSetup").map((item) => item['data']).toList()[0];
  double sidebarWidth =  parseDouble(pageSetupData.where((element) => element['key'] == 'PageSideBarWidth').map((e) => e['value']).toList()[0].toString()) * 72 ?? 0.0;

  double fontSize = parseDouble(printSetup.pageFontSizeController.text.toString()) ?? 10.0;

  double headerHeight =   parseDouble(pageSetupData.where((element) => element['key'] == 'PageHeaderHeight').map((e) => e['value']).toList()[0].toString()) * 72 ?? 0.0;
  double footerHeight =   parseDouble(pageSetupData.where((element) => element['key'] == 'PageFooterHeight').map((e) => e['value']).toList()[0].toString()) * 72 ?? 0.0;

   double footerImageHeight = 0.00;
   double headerImageHeight = 0.00;


  final pdf = pw.Document(
    pageMode: PdfPageMode.fullscreen,
    version: PdfVersion.pdf_1_5,
    compress: true,
  );



    final fontData = await rootBundle.load('fonts/SutonnyMJRegular.ttf');
    final customFont = pw.Font.ttf(fontData.buffer.asByteData());

    // Generate QR code

    var qrCodeData ;
  if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "QRCode")){
    qrCodeData = await generateQrCode('${patientInfo.id}');;
   }

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
      List<dynamic> pageMarginSetupData = printSetup.prescriptionPrintSetupData.where((item) => item['key'] == "PageMarginSetup").map((item) => item['data']).toList()[0];
      List<dynamic> pageSetupData = printSetup.prescriptionPrintSetupData.where((item) => item['key'] == "PrintPageSetup").map((item) => item['data']).toList()[0];

      double? topMargin = double.tryParse(pageMarginSetupData.where((element) => element['key'] == 'PageMarginTop').map((e) => e['value']).toList()[0].toString()) ?? 0.0;
      double? bottomMargin = double.tryParse(pageMarginSetupData.where((element) => element['key'] == 'PageMarginRight').map((e) => e['value']).toList()[0].toString()) ?? 0.0;
      double? leftMargin = double.tryParse(pageMarginSetupData.where((element) => element['key'] == 'PageMarginLeft').map((e) => e['value']).toList()[0].toString()) ?? 0.0;
      double? rightMargin = double.tryParse(pageMarginSetupData.where((element) => element['key'] == 'PageMarginRight').map((e) => e['value']).toList()[0].toString()) ?? 0.0;

      double? _pageHeight = double.tryParse(pageSetupData.where((element) => element['key'] == 'PageHeight').map((e) => e['value']).toList()[0].toString()) ?? 11.0;
      double? _pageWidth = double.tryParse(pageSetupData.where((element) => element['key'] == 'PageWidth').map((e) => e['value']).toList()[0].toString()) ?? 8.5;

      final pageWidth = _pageWidth * 72; // Convert inches to points
      final pageHeight = _pageHeight * 72; // Convert inches to points


      final marginTop = topMargin * 72; // Convert inches to points
      final marginLeft = leftMargin * 72; // Convert inches to points
      final marginRight = rightMargin * 72; // Convert inches to points
      final marginBottom = bottomMargin * 72; // Convert inches to points

        final pdfPageFormat = PdfPageFormat(pageWidth, pageHeight).copyWith(
          // marginTop: marginTop,
          // marginLeft: marginLeft,
          // marginRight:  marginRight,
          // marginBottom: marginBottom,
        );


      pdf.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: pdfPageFormat,
          ),
          build: (pw.Context context) {
            return pw.Container(
              margin:  pw.EdgeInsets.only(left: marginLeft, right: marginRight, top: marginTop, bottom: marginBottom),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,

                children: [
                  // header container
                  _buildHeader(i == 0,  prescriptionSettingData, headerImageHeight, headerHeight,),

                  if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "HorizontalBorderTop"))
                    pw.Container(
                      width: double.infinity, // Adjust the width as needed
                      height: 1,
                      color: PdfColor.fromHex("#000000"),
                    ),
                  // Patient information container only for first page
                  if(!generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "offPatientAllInfo"))
                    i == 0 ? _buildDataRowPatientInfo(patientAndAppointmentInfo,prescriptionSettingData, generalSetting) : pw.SizedBox(height: 5),

                  if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "horizontalBorder"))
                    pw.Container(
                      width: double.infinity, // Adjust the width as needed
                      height: 1,
                      color: PdfColors.black,
                    ),

                  // medicine and clinical data container
                  pw.Expanded(
                    child: _buildContent(column1Sublist, column2Sublist, prescriptionSettingData, patientAndAppointmentInfo, advices, totalPages, i + 1 , customFont, sidebarWidth,fontSize, itemsPerPageColumn2, itemsPerPageColumn1, totalItemsColumn1, totalItemsColumn2,generalSetting,qrCodeData,patientHistory),
                  ),

                  // footer container
                  _buildFooter(prescriptionSettingData, footerImageHeight, footerHeight),
                ],
              )
            );
          },
        ),
      );
    }
  // Save the PDF to a temporary file
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/example.pdf");
  await file.writeAsBytes(await pdf.save());
  // return file;
  return pdf.save();
}

pw.Widget _buildHeader(bool isFirstPage, prescriptionSettingData, headerImageHeight, headerHeight,) {
  final PrescriptionPrintPageSetupController printSetup = Get.put(PrescriptionPrintPageSetupController());
  double marginAroundFullPage = parseDouble(printSetup.marginAroundFullPageController.text.toString()) * 72;
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

pw.Widget _buildFooter(prescriptionSettingData, footerImageHeight, footerHeight) {
  final PrescriptionPrintPageSetupController printSetup = Get.put(PrescriptionPrintPageSetupController());
  double marginAroundFullPage = parseDouble(printSetup.marginAroundFullPageController.text.toString()) * 72;

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

pw.Widget _buildContent(List<String> column1Data, List column2Data, prescriptionSettingData, patientAndAppointmentInfo,List advices, totalPages, i, customFont,sidebarWidth,fontSize, itemsPerPageColumn2, itemsPerPageColumn1, totalPagesColumn1, totalPagesColumn2, generalSetting,qrCodeData,patientHistory) {
  List selectedMedicine = column2Data;
  AppointmentModel appointmentInfo = patientAndAppointmentInfo.appointment;
  final PrescriptionPrintPageSetupController printSetup = Get.put(PrescriptionPrintPageSetupController());
  List<dynamic> mainPageSetup = printSetup.prescriptionPrintSetupData.where((item) => item['key'] == "MainPrescription").map((item) => item['data']).toList()[0];

  double clinicalDataMarginTop = convertToDoubleWithDPI(mainPageSetup.where((element) => element['key'] == 'MarginTopClinicalData').map((e) => e['value']).toList()[0].toString());
  double clinicalDataMarginLeft = convertToDoubleWithDPI(mainPageSetup.where((element) => element['key'] == 'MarginLeftClinicalData').map((e) => e['value']).toList()[0].toString());
  double clinicalDataMarginRight = convertToDoubleWithDPI(mainPageSetup.where((element) => element['key'] == 'MarginRightClinicalData').map((e) => e['value']).toList()[0].toString());
  double clinicalDataMarginBottom = convertToDoubleWithDPI(mainPageSetup.where((element) => element['key'] == 'MarginBottomClinicalData').map((e) => e['value']).toList()[0].toString());
  double clinicalDetailDataMargin = convertToDoubleWithDPI(mainPageSetup.where((element) => element['key'] == 'MarginBetweenDetailsClinicalData').map((e) => e['value']).toList()[0].toString());
  double clinicalSectionDataMargin = convertToDoubleWithDPI(mainPageSetup.where((element) => element['key'] == 'MarginBetweenSectionToSectionClinicalData').map((e) => e['value']).toList()[0].toString());

  double brandMarginLeft = convertToDoubleWithDPI(mainPageSetup.where((element) => element['key'] == 'MarginLeftMedicineSection').map((e) => e['value']).toList()[0].toString());
  double brandMarginRight = convertToDoubleWithDPI(mainPageSetup.where((element) => element['key'] == 'MarginRightMedicineSection').map((e) => e['value']).toList()[0].toString());
  double brandMarginTop = convertToDoubleWithDPI(mainPageSetup.where((element) => element['key'] == 'MarginTopMedicineSection').map((e) => e['value']).toList()[0].toString());
  double brandMarginBottom = convertToDoubleWithDPI(mainPageSetup.where((element) => element['key'] == 'MarginBottomMedicineSection').map((e) => e['value']).toList()[0].toString());

  double adviceGap = parseDouble(printSetup.gapBetweenAdviceController.text.toString()) * 72;


  String nextVisitDate = appointmentInfo.next_visit ?? "";
  double rxDataStartingTopMargin = parseDouble(printSetup.rxDataStartingTopMarginController.text.toString()) * 72;

  // double marginAroundFullPage = prescriptionSettingData[0]['marginAroundFullPage'];
  // double rxDataStartingTopMargin = prescriptionSettingData[0]["rxDataStartingTopMargin"];
  // double clinicalDataStartingTopMargin = prescriptionSettingData[0]["clinicalDataStartingTopMargin"];
  // double clinicalDataMargin = prescriptionSettingData[0]['clinicalDataMargin'];
  // double brandDataMargin = prescriptionSettingData[0]['brandDataMargin'];
 var digitalSignature = printSetup.headerFooterAndBgImage[0]['digitalSignature'];
final LoginController loginController = Get.put(LoginController());
 var rxIcon = printSetup.headerFooterAndBgImage[0]['rxIcon'];
  List<pw.TextSpan> textSpans = [];


// Iterate through the data list and process each 'name'

   for (var item in advices) {
     if(item.name != '') {
       String name = item.name ?? '';
       List<String> words = name.split(' ');
       textSpans.add(
         pw.TextSpan(
           text: ' * ',
           style: pw.TextStyle(fontSize: fontSize + 5,
               fontWeight: pw.FontWeight.bold,
               color: PdfColors.blue),
         ),
       );
       for (var word in words) {
         // Check if the word contains Bangla characters
         if (RegExp(r'[\u0980-\u09FF]').hasMatch(word)) {
           textSpans.add(
             pw.TextSpan(
               text: utf8.decode(utf8.encode(unicodeToBijoy("$word "))),
               style: pw.TextStyle(
                   font: customFont, fontSize: fontSize), // Green for Bangla
             ),
           );
         } else {
           textSpans.add(
             pw.TextSpan(
               text: '$word ',
               style: pw.TextStyle(fontSize: fontSize), // Blue for English
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
   }

   return pw.Padding(
    padding:  pw.EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
    child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Padding(
            padding: pw.EdgeInsets.only(top: clinicalDataMarginTop, bottom: clinicalDataMarginBottom, left: clinicalDataMarginLeft, right: clinicalDataMarginRight),
            child: pw.SizedBox(
              width: sidebarWidth,
              child: pw.Expanded(
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: column1Data.asMap().entries.map((entry){
                        final index = entry.key;
                        final item = entry.value;
                        return  pw.Column(
                            children: [
                              item.isNotEmpty ? pw.Column(
                                  children: [
                                    (item == 'Glass Recommendation' || item == "Chief Complaint" || item == "Diagnosis" || item == "On Examination" || item == "Investigation Advice" || item == "Investigation Report" || item == "Physician Notes" ||  item == "Referred By" || item == "Treatment Plan" || item == HistoryCategory.personalHistoryTitle || item == HistoryCategory.allergyHistoryTitle || item == HistoryCategory.familyHistoryTitle || item == HistoryCategory.socialHistoryTitle || item == "Disease Activity Score" || item == "Gyn and Obs History") ?
                                    pw.Column(
                                        children: [
                                          pw.SizedBox(height: 5),
                                          pw.Padding(
                                            padding:  pw.EdgeInsets.only(top: clinicalSectionDataMargin, bottom: 0.0, left: 0.0 , right: 0.0 ),
                                            child: pw.Text("${item}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize)),
                                          ),

                                        ]
                                    ) : clinicalDataList(item,clinicalDetailDataMargin, customFont, fontSize, ),

                                  ]
                              ) : pw.Column(
                                  children: [
                                  ]
                              ),

                            ]
                        ) ;
                      }).toList(),
                    ),
                    pw.SizedBox(height: 5),
                    if(patientHistory !=null)
                    for(int i = 0; i<patientHistory.length; i++)
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5.0),
                        child:  pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(patientHistory[i]['category'], style: pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 2),
                              for(int j = 0; j<patientHistory[i]['items'].length; j++)
                                pw.Text('- '+patientHistory[i]['items'][j].name, style: pw.TextStyle(fontSize: fontSize))
                            ]
                        ),
                      ),
                  ]
                ),
              ),
            ),
          ),

          if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "verticalBorder"))
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
                      if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "RxIcon"))
                        if(rxIcon.isEmpty)
                        pw.Text("Rx", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
                      if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "RxIcon"))
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
                                          medicineList(selectedMedicine[index],index,generalSetting,customFont,fontSize),

                                      shortAdvice(textSpans,generalSetting,nextVisitDate,customFont,fontSize,digitalSignature,loginController,qrCodeData)
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
  PatientModel patientInfoData = patientAndAppointmentInfo.patient;
  final PrescriptionPrintPageSetupController printSetup = Get.put(PrescriptionPrintPageSetupController());
  final orderingController = Get.put(DataOrderingController());
  List<dynamic> patientSetupData = printSetup.prescriptionPrintSetupData.where((item) => item['key'] == "PatientInformationAdjustment").map((item) => item['data']).toList()[0];
  List<dynamic> patientFontSetupData = printSetup.prescriptionPrintSetupData.where((item) => item['key'] == "PageFontSizeSetup").map((item) => item['data']).toList()[0];

  var MarginBeforePatientId = patientSetupData.where((element) => element['key'] == 'MarginBeforePatientId').map((e) => e['value']).toList()[0].toString();
  var MarginBeforePatientName = patientSetupData.where((element) => element['key'] == 'MarginBeforePatientName').map((e) => e['value']).toList()[0];
  var MarginBeforePatientAge = patientSetupData.where((element) => element['key'] == 'MarginBeforePatientAge').map((e) => e['value']).toList()[0];
  var MarginBeforePatientGender = patientSetupData.where((element) => element['key'] == 'MarginBeforePatientGender').map((e) => e['value']).toList()[0];
  var MarginBeforeDate = patientSetupData.where((element) => element['key'] == 'MarginBeforeDate').map((e) => e['value']).toList()[0];
  var fontSizePaInfo = patientFontSetupData.where((element) => element['key'] == 'FontSizePaInfo').map((e) => e['value']).toList()[0];

    double marginBeforePatientName = double.parse(MarginBeforePatientName) * 72;
    double marginBeforePatientAge = double.parse(MarginBeforePatientAge) * 72;
    double marginBeforePatientId = double.parse(MarginBeforePatientId) * 72;
    double marginBeforePatientGender = double.parse(MarginBeforePatientGender) * 72;
    double marginBeforePatientDate = double.parse(MarginBeforeDate) * 72;
    double fontSize = double.parse(fontSizePaInfo);

   var ageString = "";

  if(patientInfoData.dob != null && patientInfoData.dob != "" ){
    var age = calculateAge(DateTime.parse(patientInfoData.dob.toString()));
    if(generalSetting.any((element) => element['section'] == Settings.print && element['label'] == "AgeYearMonthDayMin")){
      ageString = "${age.years !=0 ? age.years.toString() + "Y" : "" }-${age.months !=0 ? age.months.toString() + "M" : ""}-${age.days !=0 ?  age.days.toString() + "D" : "" }-${age.hours !=0 ? age.hours.toString() + "H" : "" }-${age.minutes !=0 ? age.minutes.toString() + "Min" : "" }";
    }else if(generalSetting.any((element) => element['section'] == Settings.print && element['label'] == "AgeYearMonthDay")){
      ageString = "${age.years !=0 ? age.years.toString() + "Y" : "" }-${age.months !=0 ? age.months.toString() + "M" : ""}-${age.days !=0 ?  age.days.toString() + "D" : ""}";
    }else if(generalSetting.any((element) => element['section'] == Settings.print && element['label'] == "AgeYearMon")){
      ageString = "${ age.years.toString() }Y-${ age.months.toString() }M";
    }else{
      ageString = "${age.years.toString() }Y";
    }

  }

  List<Map<String, dynamic>> patientInfo = [
  {
    "index": 1,
    "isShowWidget": generalSetting.any((element) => element['section'] == Settings.print && element['label'] == "PatientId"),
    "isShowLabel": generalSetting.any((element) => element['section'] == Settings.print && element['label'] == "PatientIdLabel"),
    "title": "Patient Id",
    'marginBefore': marginBeforePatientId,
    "fontSize": fontSize,
    "data": "${patientAndAppointmentInfo.appointment.patient_id}"
  },
  {
    "index": 2,
    "isShowWidget": generalSetting.any((element) => element['section'] == Settings.print && element['label'] == "Name"),
    "isShowLabel": generalSetting.any((element) => element['section'] == Settings.print && element['label'] == "NameLabel"),
    "title": "Name",
    'marginBefore': marginBeforePatientName,
    "fontSize": fontSize,
    "data": "${patientInfoData.name}"
  },
    {
    "index": 3,
    "isShowWidget": generalSetting.any((element) => element['section'] == Settings.print && element['label'] == "Age"),
    "isShowLabel": generalSetting.any((element) => element['section'] == Settings.print && element['label'] == "AgeLabel"),
    "title": "Age",
    'marginBefore': marginBeforePatientAge,
    "fontSize": fontSize,
    "data": "$ageString"
  },{
    "index": 4,
    "isShowWidget": generalSetting.any((element) => element['section'] == Settings.print && element['label'] == "Gender"),
    "isShowLabel": generalSetting.any((element) => element['section'] == Settings.print && element['label'] == "GenderLabel"),
    "title": "Gender",
    'marginBefore': marginBeforePatientGender,
    "fontSize": fontSize,
      "data": patientInfoData.sex == 1 ? "M" :  patientInfoData.sex == 2 ? "F" : patientInfoData.sex == 3 ? "Other" : ""
    },{
    "index": 5,
    "isShowWidget": generalSetting.any((element) => element['section'] == Settings.print && element['label'] == "Date"),
    "isShowLabel": generalSetting.any((element) => element['section'] == Settings.print && element['label'] == "DateLabel"),
    "title": "Date",
    'marginBefore': marginBeforePatientDate,
    "fontSize": fontSize,
    "data": patientAndAppointmentInfo.appointment.date
  },

  ];
  for(var item in patientInfo){
    for(var item2 in orderingController.patientInfoOrderingForPrint){
      if(item['title'] == item2['title']){
        item['index'] = parseInt(item2['value']);
      }
    }
  }
  patientInfo.sort((a, b) => a['index'].compareTo(b['index']));
   //marginBeforePatientId
  return pw.Container(
    padding:  pw.EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
    child: pw.Row(
      children: [
        for (var item in patientInfo)
          if(item['isShowWidget'])
             CustomPatientInfo(item)
      ],
    ),
  );
}

pw.Widget CustomPatientInfo(item){
   if(item['marginBefore'] == 0.0 && item['index'] != 1) {
      item['marginBefore'] = 30.0;
   }
  return pw.Column(
      children: [
        pw.Container(
          margin:  pw.EdgeInsets.only(left: item['marginBefore']),
          child: pw.Row(
              children: [
                if(item['isShowLabel'])
                  pw.Text('${item['title']}: ', style: pw.TextStyle(fontSize: item['fontSize'], fontWeight: pw.FontWeight.bold)),
                pw.Text("${item['data']}", style: pw.TextStyle(fontSize: item['fontSize'])),
              ]
          )
        )
      ]
    );
}
pw.Widget medicineList(medicine,index,generalSetting,customFont,fontSize){
  var isUppercase = generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "BrandDosesUppercase");
  final PrescriptionPrintPageSetupController printSetup = Get.put(PrescriptionPrintPageSetupController());
  List<dynamic> mainPageSetup = printSetup.prescriptionPrintSetupData.where((item) => item['key'] == "MainPrescription").map((item) => item['data']).toList()[0];
  double brandToDoseTopMargin = convertToDoubleWithDPI(mainPageSetup.where((element) => element['key'] == 'MarginTopDoseSection').map((e) => e['value']).toList()[0].toString());
  double brandToDoseBottomMargin = convertToDoubleWithDPI(mainPageSetup.where((element) => element['key'] == 'MarginBottomDoseSection').map((e) => e['value']).toList()[0].toString());
  double brandDoseDurationInstructionMargin = convertToDoubleWithDPI(mainPageSetup.where((element) => element['key'] == 'MarginBetweenDoseDurationInstruction').map((e) => e['value']).toList()[0].toString());
  double brandToBrandMargin = convertToDoubleWithDPI(mainPageSetup.where((element) => element['key'] == 'MarginBetweenBrand').map((e) => e['value']).toList()[0].toString());

  return pw.Padding(
    padding:  pw.EdgeInsets.symmetric(vertical: brandToBrandMargin),
    child: pw.Column(
      children: <pw.Widget>[
        // if (medicine['dose'].isNotEmpty)
          pw.Container(
            padding: const pw.EdgeInsets.all(2),
            child: pw.Row(
              mainAxisAlignment:
              pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Flexible(
                  child: pw.Column(
                    crossAxisAlignment:
                    pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                        pw.Wrap(
                          children: <pw.Widget>[
                            pw.Text("${index + 1}."),
                            pw.SizedBox(width: 5),
                            pw.Text("${isUppercase ? medicine['brand_name'].toUpperCase() : medicine['brand_name']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: fontSize, )),
                            pw.SizedBox(width: 5,),
                            pw.Text("${isUppercase ? medicine['form'].toUpperCase() : medicine['form']}", style: pw.TextStyle(fontSize: fontSize),),
                            pw.SizedBox(width: 5,),
                            pw.Text("${isUppercase ? medicine['strength'].toString().toUpperCase() : medicine['strength'].toString() ?? ""}", style: pw.TextStyle(fontSize: fontSize)),
                          ],
                        ),

                        pw.SizedBox(height: brandToDoseTopMargin),
                        for (var i = 0; i < medicine['dose'].length; i++)
                          medicineDoses(medicine['dose'][i],customFont,fontSize,brandDoseDurationInstructionMargin),

                      pw.SizedBox(height: brandToDoseBottomMargin),
                    ],
                  ),
                ),
              ],
            ),
          ),


      ],

    ),
  );
}
pw.Widget shortAdvice(textSpans,generalSetting,nextVisitDate,customFont,fontSize,digitalSignature,loginController,qrCodeData){
  return  pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if(textSpans.isNotEmpty)
          pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(height: 10),
                if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "AdviceTitleBangla"))
                  pw.Text(utf8.decode(utf8.encode(unicodeToBijoy("ঊপদেশঃ "))), style: pw.TextStyle(fontSize: fontSize + 4, font: customFont,lineSpacing: 4)),

                if(!generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "AdviceTitleBangla"))
                  pw.Text("Advice:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize)),
                pw.SizedBox(height: 5),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.RichText(
                        text: pw.TextSpan(
                          children: textSpans,
                        ),
                      ),
                    ]
                )
              ]
          ),
        pw.SizedBox(height: 10),

        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              if(nextVisitDate.toString().isNotEmpty && nextVisitDate.toString() != "null" && nextVisitDate.toString() != "0000-00-00")
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(utf8.decode(utf8.encode(unicodeToBijoy("পরবর্তি সাক্ষাতঃ "))), style: pw.TextStyle(fontSize: fontSize + 4, font: customFont,lineSpacing: 4, fontWeight: pw.FontWeight.bold)),
                      pw.Text("${nextVisitDate}", style: pw.TextStyle(fontSize: fontSize,)),
                    ]
                ),
              pw.SizedBox(width: 20),
              if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "DigitalSignature" ))
                pw.Column(
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            if(digitalSignature.length >0)
                              pw.Column(
                                  children: [
                                    pw.Container(
                                      height: 30,
                                      child: pw.Image(pw.MemoryImage(base64Decode(base64Encode(digitalSignature)))),
                                    ),
                                    pw.Container(
                                      height: 1,
                                      width: 70,
                                      color: PdfColors.grey,
                                    ),
                                    pw.Text("${loginController.userName}", style: pw.TextStyle( fontSize: 10)),
                                  ]
                              )
                          ]
                      ),

                    ]
                ),

              if( generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "AnalogSignature"))
                pw.Column(
                    children: [
                      if(generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "AnalogSignature"))
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Column(
                                  children: [
                                    pw.Container(
                                      // child: pw.Text("Signature", style: pw.TextStyle( fontSize: 10)),
                                    ),
                                    pw.SizedBox(height: 20),
                                    pw.Container(
                                      height: 1,
                                      width: 70,
                                      color: PdfColors.grey,
                                    ),
                                    pw.Text("${loginController.userName}", style: pw.TextStyle( fontSize: 10)),
                                  ]
                              )
                            ]
                        ),

                    ]
                ),
              pw.SizedBox(width: 10),
              if( generalSetting.any((element) => element['section'] == "PrescriptionPrintPage" && element['label'] == "QRCode"))
                pw.Column(
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Column(
                                children: [
                                  pw.Container(
                                    alignment: pw.Alignment.center,
                                    child: pw.Image(
                                      pw.MemoryImage(qrCodeData),
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),

                                  pw.Text("Your Prescription", style: pw.TextStyle( fontSize: 10)),
                                ]
                            )
                          ]
                      ),

                    ]
                ),
            ]
        ),


      ]
  );
}
pw.Widget medicineDoses(doses,customFont,fontSize,brandDoseDurationInstructionMargin){

  List<pw.TextSpan> textSpans = [];
  List<String> wordsDose = doses['dose'].split(' ');
  List<String> wordsDuration = doses['duration'].split(' ');
  List<String> wordsInstruction = doses['instruction'].split(' ');
  List<String> wordsNote = doses['comment'].split(' ');;

  for(var word in wordsDose){
    if (RegExp(r'[\u0980-\u09FF]').hasMatch(word)) {
      textSpans.add(
        pw.TextSpan(
          text: utf8.decode(utf8.encode(unicodeToBijoy(" ${word} "))),
          style: pw.TextStyle( font: customFont, fontSize: fontSize), // Green for Bangla
        ),
      );
    } else {
      textSpans.add(
        pw.TextSpan(
          text: ' ${word} ',
          style: pw.TextStyle(fontSize: fontSize), // Blue for English
        ),
      );
    }
  }

  if(wordsInstruction.isNotEmpty){
    textSpans.add(
      pw.TextSpan(
        text: ' -- ',
        style: pw.TextStyle(fontSize: fontSize), // Blue for English
      ),
    );
  }
  for(var word in wordsInstruction){
    if (RegExp(r'[\u0980-\u09FF]').hasMatch(word)) {
      textSpans.add(
        pw.TextSpan(
          text: utf8.decode(utf8.encode(unicodeToBijoy(" ${word} "))),
          style: pw.TextStyle( font: customFont, fontSize: fontSize), // Green for Bangla
        ),
      );
    } else {
      textSpans.add(
        pw.TextSpan(
          text: ' ${word} ',
          style: pw.TextStyle(fontSize: fontSize), // Blue for English
        ),
      );
    }
  }

  if(wordsDuration.isNotEmpty){
    textSpans.add(
      pw.TextSpan(
        text: ' -- ',
        style: pw.TextStyle(fontSize: fontSize), // Blue for English
      ),
    );
  }
  for(var word in wordsDuration){
    if (RegExp(r'[\u0980-\u09FF]').hasMatch(word)) {
      textSpans.add(
        pw.TextSpan(
          text: utf8.decode(utf8.encode(unicodeToBijoy(" ${word} "))),
          style: pw.TextStyle( font: customFont, fontSize: fontSize), // Green for Bangla
        ),
      );
    } else {
      textSpans.add(
        pw.TextSpan(
          text: ' ${word} ',
          style: pw.TextStyle(fontSize: fontSize), // Blue for English
        ),
      );
    }
  }

  if(wordsNote.isNotEmpty){

  }
  if(wordsNote.length > 1){
    textSpans.add(
      pw.TextSpan(
        text: ' -- ',
        style: pw.TextStyle(fontSize: fontSize), // Blue for English
      ),
    );
    for(var word in wordsNote){
      if (RegExp(r'[\u0980-\u09FF]').hasMatch(word)) {
        textSpans.add(
          pw.TextSpan(
            text: utf8.decode(utf8.encode(unicodeToBijoy(" ${word} "))),
            style: pw.TextStyle( font: customFont, fontSize: fontSize), // Green for Bangla
          ),
        );
      } else {
        textSpans.add(
          pw.TextSpan(
            text: ' ${word} ',
            style: pw.TextStyle(fontSize: fontSize), // Blue for English
          ),
        );
      }
    }
  }

  return pw.Column(
    crossAxisAlignment:
    pw.CrossAxisAlignment.start,
    children: <pw.Widget>[
      pw.Row(
        children: [
          pw.SizedBox(width: 15),
            pw.RichText(
            text: pw.TextSpan(
              children: textSpans,
            ),
          ),
        ],
      ),
    ],
  );
}
pw.Widget clinicalDataList(item,clinicalDataMargin,customFront, fontSize){
  List<pw.TextSpan> textSpans = [];
  List<String> words = item.split('\n');
  for(var word in words){
    List<String> singleData = word.split(' ');
    textSpans.add(
      pw.TextSpan(
        text: '-',
        style: pw.TextStyle(fontSize: fontSize), // Blue for English
      ),
    );
    for(var single in singleData){

      if (RegExp(r'[\u0980-\u09FF]').hasMatch(single)) {
        textSpans.add(
          pw.TextSpan(
            text: utf8.decode(utf8.encode(unicodeToBijoy(" ${single} "))),
            style: pw.TextStyle( font: customFront, fontSize: fontSize), // Green for Bangla
          ),
        );
      } else {
        textSpans.add(
          pw.TextSpan(
            text: ' ${single} ',
            style: pw.TextStyle(fontSize: fontSize), // Blue for English
          ),
        );
      }
    }
  }
  return pw.Padding(
    padding: pw.EdgeInsets.only(left: 5.0),
    child: pw.Column(
        children: [
          if(item.isNotEmpty && item != "")
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(vertical: clinicalDataMargin),
              child: pw.RichText(
                text: pw.TextSpan(
                  children: textSpans,
                ),
              ),
            )
        ]
    ),
  );
}