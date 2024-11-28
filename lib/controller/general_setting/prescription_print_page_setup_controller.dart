
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';

import '../../database/crud_operations/prescription_print_layout_page_setup_settings_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../models/general_setting_pages/prescription_print_layout_settings/prescription_print_layout_setting_model.dart';
import '../../utilities/app_strings.dart';
import '../../utilities/default_value.dart';
import 'config/app_default_prescription_print_setup_data.dart';

class PrescriptionPrintPageSetupController extends GetxController{

  final Box<PrescriptionPrintLayoutSettingModel> boxPrescriptionPrintPageSetup = Boxes.getPrescriptionPrintLayoutSettings();
  final PrescriptionPrintLayoutSetupCRUDController prescriptionLayout = PrescriptionPrintLayoutSetupCRUDController();
  final RxList prescriptionPageSetupData = [].obs;
  final defaultPrescriptionPrintSetupData = DefaultPrescriptionPrintSetupData();

  RxBool isLoading = false.obs;

  final uuid = DefaultValues.defaultUuid;
  final date = DefaultValues.defaultDate;
  final web_id = DefaultValues.defaultweb_id;
  final statusNewAdd = DefaultValues.NewAdd;
  final statusUpdate = DefaultValues.Update;
  final statusDelete = DefaultValues.Delete;
  RxInt activeChamberId = 0.obs;


  TextEditingController pageWidthController = TextEditingController();
  TextEditingController pageHeightController = TextEditingController();
  TextEditingController pageSideBarWidthController = TextEditingController();
  TextEditingController pageHeaderHeightController = TextEditingController();
  TextEditingController pageFooterHeightController = TextEditingController();
  TextEditingController pageFontSizeController = TextEditingController();
  TextEditingController fontSizePaInfoController = TextEditingController();
  TextEditingController pageFontColorController = TextEditingController();
  TextEditingController pageMarginTopController = TextEditingController();
  TextEditingController pageMarginBottomController = TextEditingController();
  TextEditingController pageMarginLeftController = TextEditingController();
  TextEditingController pageMarginRightController = TextEditingController();

  TextEditingController clinicalDataMarginController =TextEditingController();
  TextEditingController brandDataMarginController =TextEditingController();
  TextEditingController rxDataStartingTopMarginController =TextEditingController();
  TextEditingController clinicalDataStartingTopMarginController =TextEditingController();

  TextEditingController marginBeforePatientNameController = TextEditingController();
  TextEditingController marginBeforePatientAgeController = TextEditingController();
  TextEditingController marginBeforePatientIdController = TextEditingController();
  TextEditingController marginBeforePatientGenderController = TextEditingController();
  TextEditingController marginBeforePatientDateController = TextEditingController();

  TextEditingController clinicalDataPrintingPerPageController = TextEditingController();
  TextEditingController brandDataPrintingPerPageController = TextEditingController();
  TextEditingController clinicalAndBrandDataPerPageGapController = TextEditingController();
  TextEditingController marginAroundFullPageController = TextEditingController();
  TextEditingController chamberIdController = TextEditingController();
  TextEditingController gapBetweenAdviceController = TextEditingController();
  TextEditingController marginTopSignature = TextEditingController();

  TextEditingController marginLeftClinicalData = TextEditingController();
  TextEditingController marginRightClinicalData = TextEditingController();
  TextEditingController marginLeftBrandData = TextEditingController();
  TextEditingController marginRightBrandData = TextEditingController();

  RxList prescriptionPrintSetupData = [
    {
      "title": "Print Page Setup",
      "isEditable": true,
      "key": "PrintPageSetup",
      "example": "",
      "data": [
        {
          "key": "PageWidth",
          "label": "Page Width",
          "value": '8.5',
          "isEditable": true,
          "defaultValue": '8.5',
        },
        {
          "key": "PageHeight",
          "label": "Page Height",
          "value": '11.0',
          "isEditable": true,
          "defaultValue": '11.0',
        },
        {
          "key": "PageSideBarWidth",
          "label": "Page Side Bar Width",
          "value": '2.0',
          "isEditable": true,
          "defaultValue": '2.0',
        },
        {
          "key": "PageHeaderHeight",
          "label": "Page Header Height",
          "value": '1.0',
          "isEditable": true,
          "defaultValue": '1.0',
        },
        {
          "key": "PageFooterHeight",
          "label": "Page Footer Height",
          "value": '1.0',
          "isEditable": true,
          "defaultValue": '1.0',
        },
      ]

    },
    {
      "title": "Page Margin Setup",
      "isEditable": true,
      "key": "PageMarginSetup",
      "example": "",
      "data": [
        {
          "key": "PageMarginLeft",
          "label": "Page Margin Left",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "PageMarginRight",
          "label": "Page Margin Right",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "PageMarginTop",
          "label": "Page Margin Top",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "PageMarginBottom",
          "label": "Page Margin Bottom",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
      ]
    },
    {
      "title": "Font Size Setup",
      "isEditable": true,
      "key": "PageFontSizeSetup",
      "example": "",
      "data": [
        {
          "key": "FontSizePaInfo",
          "label": "Font Size Patient Info",
          "value": '10.0',
          "isEditable": true,
          "defaultValue": '10.0',
        },
        {
          "key": "FontSizeClinicalDataTitle",
          "label": "Font Size Clinical Data Title",
          "value": '10.0',
          "isEditable": true,
          "defaultValue": '10.0',
        },
        {
          "key": "FontSizeClinicalDataDetails",
          "label": "Font Size Clinical Data Details",
          "value": '10.0',
          "isEditable": true,
          "defaultValue": '10.0',
        },
        {
          "key": "FontSizeBrandDataName",
          "label": "Font Size Brand Name",
          "value": '10.0',
          "isEditable": true,
          "defaultValue": '10.0',
        },
        {
          "key": "FontSizeBrandDataDose",
          "label": "Font Size Brand Dose",
          "value": '10.0',
          "isEditable": true,
          "defaultValue": '10.0',
        },
        {
          "key": "FontSizeAdviceData",
          "label": "Font Size Advice",
          "value": '10.0',
          "isEditable": true,
          "defaultValue": '10.0',
        },
        {
          "key": "FontSizeHandoutData",
          "label": "Font Size Handout",
          "value": '10.0',
          "isEditable": true,
          "defaultValue": '10.0',
        },
      ]
    },
    {
      "title": "Main Prescription",
      "isEditable": true,
      "key": "MainPrescription",
      "example": "",
      "data": [
        {
          "key": "MarginLeftClinicalData",
          "label": "Margin Left Clinical Data",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginRightClinicalData",
          "label": "Margin Right Clinical Data",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginTopClinicalData",
          "label": "Margin Top Clinical Data",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginBottomClinicalData",
          "label": "Margin Bottom Clinical Data",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginBetweenSectionToSectionClinicalData",
          "label": "Margin Between Section (edg: cc to dx)",
          "value": '0.1',
          "isEditable": true,
          "defaultValue": '0.1',
        },
        {
          "key": "MarginBetweenDetailsClinicalData",
          "label": "Margin Between Clinical Data Details",
          "value": '0.1',
          "isEditable": true,
          "defaultValue": '0.1',
        },
        {
          "key": "MarginLeftMedicineSection",
          "label": "Margin Left Medicine Section",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginRightMedicineSection",
          "label": "Margin Right MedicineSection",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginTopMedicineSection",
          "label": "Margin Top Medicine Section",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginBottomMedicineSection",
          "label": "Margin Bottom Medicine Section",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginBetweenBrand",
          "label": "Margin Between Brand",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },{
          "key": "MarginTopDoseSection",
          "label": "Margin Top Dose Section",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },{
          "key": "MarginBottomDoseSection",
          "label": "Margin Bottom Dose Section",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },{
          "key": "MarginBetweenDoseDurationInstruction",
          "label": "Margin Between Dose-Duration-Instruction",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginTopPatientInfo",
          "label": "Margin Top Patient Info Section",
          "value": '0.1',
          "isEditable": true,
          "defaultValue": '0.1',
        },
        {
          "key": "MarginBottomPatientInfo",
          "label": "Margin Bottom Patient Info Section",
          "value": '0.1',
          "isEditable": true,
          "defaultValue": '0.1',
        },
        {
          "key": "MarginLeftPatientInfo",
          "label": "Margin Left Patient Info Section",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginRightPatientInfo",
          "label": "Margin Right Patient Info Section",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginTopRxIcon",
          "label": "Margin Top Rx Icon",
          "value": '0.1',
          "isEditable": true,
          "defaultValue": '0.1',
        },{
          "key": "PaddingPatientInfoData",
          "label": "Padding Patient Info Data",
          "value": '0.1',
          "isEditable": true,
          "defaultValue": '0.1',
        },
        {
          "key": "MarginBottomRxIcon",
          "label": "Margin Bottom Rx Icon",
          "value": '0.1',
          "isEditable": true,
          "defaultValue": '0.1',
        },
        {
          "key": "MarginLeftRxIcon",
          "label": "Margin Left Rx Icon",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginRightRxIcon",
          "label": "Margin Right Rx Icon",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginTopHeader",
          "label": "Margin Top Header",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginBottomHeader",
          "label": "Margin Bottom Header",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginLeftHeader",
          "label": "Margin Left Header",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginRightHeader",
          "label": "Margin Right Header",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginTopFooter",
          "label": "Margin Top Footer",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },{
          "key": "MarginBottomFooter",
          "label": "Margin Bottom Footer",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginLeftFooter",
          "label": "Margin Left Footer",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginRightFooter",
          "label": "Margin Right Footer",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginTopAdvice",
          "label": "Margin Top Advice",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginBottomAdvice",
          "label": "Margin Bottom Advice",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginBetweenAdvice",
          "label": "Margin Between Advice",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginTopNextVisit",
          "label": "Margin Top Next Visit",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginBottomNextVisit",
          "label": "Margin Bottom Next Visit",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },


      ]
    },
    {
      "title": "Patient Information Adjustment",
      "isEditable": true,
      "key": "PatientInformationAdjustment",
      "example": "",
      "data": [
        {
          "key": "MarginBeforePatientId",
          "label": "Margin Before Patient Id",
          "value": '0.0',
          "isEditable": true,
          "defaultValue": '0.0',
        },
        {
          "key": "MarginBeforePatientName",
          "label": "Margin Before Patient Name",
          "value": '0.7',
          "isEditable": true,
          "defaultValue": '0.7',
        },
      {
        "key": "MarginBeforePatientAge",
        "label": "Margin Before Patient Age",
        "value": '0.7',
        "isEditable": true,
        "defaultValue": '0.7',
      },
        {
          "key": "MarginBeforePatientGender",
          "label": "Margin Before Patient Gender",
          "value": '0.7',
          "isEditable": true,
          "defaultValue": '0.7',
        },
        {
          "key": "MarginBeforeDate",
          "label": "Margin Before Date",
          "value": '0.7',
          "isEditable": true,
          "defaultValue": '0.7',
        },
      ]
    },
    {
      "title":"Custom Color Adjustment",
      "isEditable": true,
      "key": "CustomColorAdjustment",
      "example": "",
      "data": [
        {
          "key":"BrandNameColor",
          "label": "Brand Name Color",
          "value": '#000000',
          "isEditable": true,
          "defaultValue": '#000000',
        },
        {
          "key":"BrandDoseColor",
          "label": "Brand Dose Color",
          "value": '#000000',
          "isEditable": true,
          "defaultValue": '#000000',
        },{
          "key":"BrandDurationColor",
          "label": "Brand Duration Color",
          "value": '#000000',
          "isEditable": true,
          "defaultValue": '#000000',
        },
        {
          "key":"BrandInstructionColor",
          "label": "Brand Instruction Color",
          "value": '#000000',
          "isEditable": true,
          "defaultValue": '#000000',
        },{
          "key":"BrandNotesColor",
          "label": "Brand Notes Color",
          "value": '#000000',
          "isEditable": true,
          "defaultValue": '#000000',
        },{
          "key":"BrandDosesFormColor",
          "label": "Brand Doses Form Color",
          "value": '#000000',
          "isEditable": true,
          "defaultValue": '#000000',
        },{
          "key":"BrandStrengthColor",
          "label": "Brand Strength Color",
          "value": '#000000',
          "isEditable": true,
          "defaultValue": '#000000',
        },
        {
          "key":"RxIconColor",
          "label": "Rx Icon Color",
          "value": '#000000',
          "isEditable": true,
          "defaultValue": '#000000',
        },
        {
          "key":"ClinicalDataTitleColor",
          "label": "Clinical Data Title Color",
          "value": '#FFFFFF',
          "isEditable": true,
          "defaultValue": '#FFFFFF',
        },
        {
          "key":"ClinicalDataDetailsColor",
          "label": "Clinical Data Details Color",
          "value": '#FFFFFF',
          "isEditable": true,
          "defaultValue": '#FFFFFF',
        },
        {
          "key":"PatientInformationTitleColor",
          "label": "Patient Information Title Color",
          "value": '#000000',
          "isEditable": true,
          "defaultValue": '#000000',
        }, {
          "key":"PatientInformationValueColor",
          "label": "Patient Information Value Color",
          "value": '#000000',
          "isEditable": true,
          "defaultValue": '#000000',
        },{
          "key":"AdviceColor",
          "label": "Advice Color",
          "value": '#000000',
          "isEditable": true,
          "defaultValue": '#000000',
        },{
          "key":"NextVisitTitleColor",
          "label": "Next Visit Title Color",
          "value": '#000000',
          "isEditable": true,
          "defaultValue": '#000000',
        },{
          "key":"NextVisitValueColor",
          "label": "Next Visit Value Color",
          "value": '#000000',
          "isEditable": true,
          "defaultValue": '#000000',
        },
        {
          "key":"HandoutTitleColor",
          "label": "Handout Title Color",
          "value": '#000000',
          "isEditable": true,
          "defaultValue": '#000000',
        },
        {
          "key":"HandoutDescriptionColor",
          "label": "Handout Description Color",
          "value": '#000000',
          "isEditable": true,
          "defaultValue": '#000000',
        },

      ]
    },
    {
      "title":"Image Upload Section",
      "isEditable": true,
      "key": "ImageUploadSection",
      "example": "",
      "data": [
        {
          "key":"HeaderImage",
          "label": "Header Image",
          "value": '',
          "isEditable": true,
          "defaultValue": '',
        },
        {
          "key":"FooterImage",
          "label": "Footer Image",
          "value": '',
          "isEditable": true,
          "defaultValue": '',
        },
        {
          "key":"BackgroundImage",
          "label": "Background Image",
          "value": '',
          "isEditable": true,
          "defaultValue": '',
        },
        {
          "key":"DigitalSignature",
          "label": "Digital Signature",
          "value": '',
          "isEditable": true,
          "defaultValue": '',
        },
        {
          "key":"RxIcon",
          "label": "Rx Icon",
          "value": '',
          "isEditable": true,
          "defaultValue": '',
        },
      ]
    },
  ].obs;
  RxList selectedCustomHeader = [].obs;
  RxList customHeaderContent = [{
    "title":"Custom Header Section",
    "isEditable": true,
    "key": "CustomHeaderSection",
    "chamberId": 0,
    "selectedType": "",
    "type": [
      {
        "key": "Text",
      },
      {
        "key": "Image",
      },
    ],
    "headerSelectedPosition": "",
    "headerPosition": [
      {
        "key": "Left",
      },
      {
        "key": "Center",
      },
      {
        "key": "Right",
      },

    ],
    "example": "",
    "data": [
      {
        "key":"doctorName",
        "label": "Write your name here",
        "title": "Name",
        "value": '',
        "fontSize": "20",
        "orderIndex": "1",
        "isBold": true,
        "isItalic": true,
        "isUnderline": false,
        "fontColor": '#000000',
        "isEditable": true,
        "defaultValue": '',
      },
      {
        "key":"doctorQualifications",
        "label": "Write your Qualification (MBBS, MD, etc.)",
        "title": "",
        "value": '',
        "fontSize": "20",
        "orderIndex": "2",
        "isBold": true,
        "isItalic": true,
        "isUnderline": false,
        "fontColor": '#000000',
        "isEditable": true,
        "defaultValue": '',
      },{
        "key":"doctorDesignation",
        "label": "Write your designation (Professor)",
        "title": "",
        "value": '',
        "fontSize": "20",
        "orderIndex": "3",
        "isBold": true,
        "isItalic": true,
        "isUnderline": false,
        "fontColor": '#000000',
        "isEditable": true,
        "defaultValue": '',
      },
      {
        "key":"doctorSpeciality",
        "label": "Write your Speciality (Medicine)",
        "title": "",
        "value": '',
        "fontSize": "20",
        "orderIndex": "4",
        "isBold": true,
        "isItalic": true,
        "isUnderline": false,
        "fontColor": '#000000',
        "isEditable": true,
        "defaultValue": '',
      },{
        "key":"doctorInstituteName",
        "label": "Write your Institute (BSMMU)",
        "title": "",
        "value": '',
        "fontSize": "20",
        "orderIndex": "5",
        "isBold": true,
        "isItalic": true,
        "isUnderline": false,
        "fontColor": '#000000',
        "isEditable": true,
        "defaultValue": '',
      },{
        "key":"doctorTrainingOrCourse",
        "label": "Write your Training or Course",
        "title": "",
        "value": '',
        "fontSize": "20",
        "orderIndex": "6",
        "isBold": true,
        "isItalic": true,
        "isUnderline": false,
        "fontColor": '#000000',
        "isEditable": true,
        "defaultValue": '',
      },{
        "key":"doctorMemberShipOrFellowship",
        "label": "Write your MemberShip or Fellowship",
        "title": "",
        "value": '',
        "fontSize": "20",
        "orderIndex": "7",
        "isBold": true,
        "isItalic": true,
        "isUnderline": false,
        "fontColor": '#000000',
        "isEditable": true,
        "defaultValue": '',
      },
      {
        "key":"doctorChamberAddress",
        "label": "Write your chamber address",
        "title": "Address: ",
        "value": '',
        "fontSize": "20",
        "orderIndex": "8",
        "isBold": true,
        "isItalic": true,
        "isUnderline": false,
        "fontColor": '#000000',
        "isEditable": true,
        "defaultValue": '',
      },{
        "key":"doctorChamberName",
        "label": "Write your chamber name",
        "title": "Chamber: ",
        "value": '',
        "fontSize": "20",
        "orderIndex": "9",
        "isBold": true,
        "isItalic": true,
        "isUnderline": false,
        "fontColor": '#000000',
        "isEditable": true,
        "defaultValue": '',
      },
      {
        "key":"doctorEmail",
        "label": "Write your email here",
        "title": "Email",
        "value": '',
        "fontSize": "20",
        "orderIndex": "10",
        "isBold": true,
        "isItalic": true,
        "isUnderline": false,
        "fontColor": '#000000',
        "isEditable": true,
        "defaultValue": '',
      },
      {
        "key":"doctorAppointmentNumber",
        "label": "Write your appointment number",
        "title": "Appointment: ",
        "value": '',
        "fontSize": "20",
        "orderIndex": "11",
        "isBold": true,
        "isItalic": true,
        "isUnderline": false,
        "fontColor": '#000000',
        "isEditable": true,
        "defaultValue": '',
      },
      {
        "key":"doctorEmail",
        "label": "Write your email",
        "title": "Email: ",
        "value": '',
        "fontSize": "20",
        "orderIndex": "12",
        "isBold": true,
        "isItalic": true,
        "isUnderline": false,
        "fontColor": '#000000',
        "isEditable": true,
        "defaultValue": '',
      },{
        "key":"doctorOthers",
        "label": "Write others Note",
        "title": "",
        "value": '',
        "fontSize": "20",
        "orderIndex": "13",
        "isBold": true,
        "isItalic": true,
        "isUnderline": false,
        "fontColor": '#000000',
        "isEditable": true,
        "defaultValue": '',
      },
    ]
  }
  ].obs;

  String header_full_content = "";
  String footer_full_content = "";

  RxBool horizontalBorder = false.obs;
  RxBool rxIcon = false.obs;
  RxBool verticalBorder = false.obs;

  // which content will be showing in prescription page (like image, html content, or non both of them
  final printHeaderFooterOrNonValue = "printedHeaderFooter".obs;


  // Uint8List? headerImage;
  RxList<Map<String, dynamic>> headerFooterAndBgImage= [
    {"headerImage":  Uint8List(0),"footerImage":  Uint8List(0), "backgroundImage":  Uint8List(0), "digitalSignature":  Uint8List(0), "rxIcon":  Uint8List(0)},
  ].obs;



  Future<void> getImage(type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
        // The user selected a file
     var imagePath = File(result.files.single.path!);

     Uint8List imageData = await imagePath.readAsBytes();
     if(type =="headerImage"){
       headerFooterAndBgImage[0]['headerImage']= imageData;
     }
     if(type =="footerImage"){
       headerFooterAndBgImage[0]['footerImage']= imageData;
     }
     if(type =="backgroundImage"){
       headerFooterAndBgImage[0]['backgroundImage']= imageData;
     }
      if(type =="digitalSignature"){
       headerFooterAndBgImage[0]['digitalSignature']= imageData;
     }
      if(type =="rxIcon"){
       headerFooterAndBgImage[0]['rxIcon']= imageData;
     }

     headerFooterAndBgImage.refresh();
    }
  }
  RxInt selectedThemeIndex = 0.obs;

  //prescription print setup data save to database(box)
  Future<void>saveData([isDefault = false])async{
    var dateTime = DateTime.now();
    print(dateTime);
       if(chamberIdController.text.isNotEmpty){
         try {
           if(
               pageWidthController.text.isNotEmpty &&
               pageHeightController.text.isNotEmpty &&
               pageSideBarWidthController.text.isNotEmpty &&
               pageHeaderHeightController.text.isNotEmpty &&
               pageFooterHeightController.text.isNotEmpty &&
               pageFontSizeController.text.isNotEmpty &&
               // pageFontColorController.text.isNotEmpty &&
               pageMarginTopController.text.isNotEmpty &&
               pageMarginBottomController.text.isNotEmpty &&
               pageMarginLeftController.text.isNotEmpty &&
               pageMarginRightController.text.isNotEmpty &&
               printHeaderFooterOrNonValue.value.isNotEmpty && clinicalAndBrandDataPerPageGapController.text.isNotEmpty
           ){

             if(printHeaderFooterOrNonValue.value == "imageHeaderFooter"){
               if(headerFooterAndBgImage[0]['headerImage'].toString().length >2 && headerFooterAndBgImage[0]['footerImage'].toString().length >2){
                 await prescriptionLayout.savePrescriptionPrintLayout(boxPrescriptionPrintPageSetup, PrescriptionPrintLayoutSettingModel(
                   id: 0,
                   uuid: uuid,
                   u_status: statusNewAdd,
                   page_width: parseDouble(pageWidthController.text),
                   page_height: parseDouble(pageHeightController.text),
                   font_color: '',
                   font_size: parseDouble(pageFontSizeController.text),
                   top_mergin: parseDouble(pageMarginTopController.text),
                   right_mergin: parseDouble(pageMarginRightController.text),
                   bottom_mergin: parseDouble(pageMarginBottomController.text),
                   left_mergin: parseDouble(pageMarginLeftController.text),
                   sidebar_width: parseDouble(pageSideBarWidthController.text),
                   header_height: parseDouble(pageHeaderHeightController.text),
                   footer_height: parseDouble(pageFooterHeightController.text),
                   header_full_conten: '',
                   footer_content: '',
                   ph_background_color: "",
                   header_two_column_left: "",
                   header_two_column_right: "",
                   header_three_column_left: "",
                   header_three_column_center: "",
                   header_three_column_right: "",
                   header_image: headerFooterAndBgImage[0]['headerImage'],
                   footer_image: headerFooterAndBgImage[0]['footerImage'],
                   background_image: headerFooterAndBgImage[0]['backgroundImage'],
                   print_header_footer_or_none: printHeaderFooterOrNonValue.toString(),

                   clinicalDataMargin: parseDouble(clinicalDataMarginController.text),
                   brandDataMargin: parseDouble(brandDataMarginController.text),
                   rxDataStartingTopMargin: parseDouble(rxDataStartingTopMarginController.text),
                   clinicalDataStartingTopMargin: parseDouble(clinicalDataStartingTopMarginController.text),
                   marginBeforePatientName: parseDouble(marginBeforePatientNameController.text),
                   marginBeforePatientAge: parseDouble(marginBeforePatientAgeController.text),
                   marginBeforePatientId: parseDouble(marginBeforePatientIdController.text),
                   marginBeforePatientGender: parseDouble(marginBeforePatientGenderController.text),
                   marginBeforePatientDate: parseDouble(marginBeforePatientDateController.text),
                   clinicalDataPrintingPerPage: parseDouble(clinicalDataPrintingPerPageController.text),
                   brandDataPrintingPerPage: parseDouble(brandDataPrintingPerPageController.text),
                   clinicalAndBrandDataPerPageGap: parseDouble(clinicalAndBrandDataPerPageGapController.text),
                   marginAroundFullPage: parseDouble(marginAroundFullPageController.text),
                   marginLeftBrandData: marginLeftBrandData.text.isEmpty ? 0.0 : parseDouble(marginLeftBrandData.text),
                   marginRightBrandData: marginRightBrandData.text.isEmpty ? 0.0 : parseDouble(marginRightBrandData.text),
                   marginLeftClinicalData: marginLeftClinicalData.text.isEmpty ? 0.0 : parseDouble(marginLeftClinicalData.text),
                   marginRightClinicalData: marginRightClinicalData.text.isEmpty ? 0.0 : parseDouble(marginRightClinicalData.text),
                   date: dateTime,
                   font_size_pa_info: parseDouble(fontSizePaInfoController.text.toString()),
                   digital_signature: headerFooterAndBgImage[0]['digitalSignature'],
                   rx_icon: headerFooterAndBgImage[0]['rxIcon'],
                   chamber_id: parseInt(chamberIdController.text.toString()),
                   advice_gap: parseInt(gapBetweenAdviceController.text.toString()),
                 ));
               }else{
                 Helpers.errorSnackBar("Failed", "Header footer image must be not empty ");
               }
             }else if(printHeaderFooterOrNonValue.value == "customBuilderHeaderFooter"){
               if(header_full_content == ""){
                 Helpers.errorSnackBar("Failed", "Field must be not empty ");
               }else{
                 await prescriptionLayout.savePrescriptionPrintLayout(boxPrescriptionPrintPageSetup, PrescriptionPrintLayoutSettingModel(
                   id: 0,
                   uuid: uuid,
                   u_status: statusNewAdd,
                   page_width: parseDouble(pageWidthController.text),
                   page_height: parseDouble(pageHeightController.text),
                   font_color: '',
                   font_size: parseDouble(pageFontSizeController.text),
                   top_mergin: parseDouble(pageMarginTopController.text),
                   right_mergin: parseDouble(pageMarginRightController.text),
                   bottom_mergin: parseDouble(pageMarginBottomController.text),
                   left_mergin: parseDouble(pageMarginLeftController.text),
                   sidebar_width: parseDouble(pageSideBarWidthController.text),
                   header_height: parseDouble(pageHeaderHeightController.text),
                   footer_height: parseDouble(pageFooterHeightController.text),
                   header_full_conten: '',
                   footer_content: '',
                   ph_background_color: "",
                   header_two_column_left: "",
                   header_two_column_right: "",
                   header_three_column_left: "",
                   header_three_column_center: "",
                   header_three_column_right: "",
                   header_image: headerFooterAndBgImage[0]['headerImage'],
                   footer_image: headerFooterAndBgImage[0]['footerImage'],
                   background_image: headerFooterAndBgImage[0]['backgroundImage'],
                   print_header_footer_or_none: printHeaderFooterOrNonValue.toString(),
                   clinicalDataMargin: parseDouble(clinicalDataMarginController.text),
                   brandDataMargin: parseDouble(brandDataMarginController.text),
                   rxDataStartingTopMargin: parseDouble(rxDataStartingTopMarginController.text),
                   clinicalDataStartingTopMargin: parseDouble(clinicalDataStartingTopMarginController.text),
                   marginBeforePatientName: parseDouble(marginBeforePatientNameController.text),
                   marginBeforePatientAge: parseDouble(marginBeforePatientAgeController.text),
                   marginBeforePatientId: parseDouble(marginBeforePatientIdController.text),
                   marginBeforePatientGender: parseDouble(marginBeforePatientGenderController.text),
                   marginBeforePatientDate: parseDouble(marginBeforePatientDateController.text),
                   clinicalDataPrintingPerPage: parseDouble(clinicalDataPrintingPerPageController.text),
                   brandDataPrintingPerPage: parseDouble(brandDataPrintingPerPageController.text),
                   clinicalAndBrandDataPerPageGap: parseDouble(clinicalAndBrandDataPerPageGapController.text),
                   marginAroundFullPage: parseDouble(marginAroundFullPageController.text),
                   marginLeftBrandData: marginLeftBrandData.text.isEmpty ? 0.0 : parseDouble(marginLeftBrandData.text),
                   marginRightBrandData: marginRightBrandData.text.isEmpty ? 0.0 : parseDouble(marginRightBrandData.text),
                   marginLeftClinicalData: marginLeftClinicalData.text.isEmpty ? 0.0 : parseDouble(marginLeftClinicalData.text),
                   marginRightClinicalData: marginRightClinicalData.text.isEmpty ? 0.0 : parseDouble(marginRightClinicalData.text),
                   date: dateTime,
                   font_size_pa_info: parseDouble(fontSizePaInfoController.text.toString()),
                   digital_signature: headerFooterAndBgImage[0]['digitalSignature'],
                   rx_icon: headerFooterAndBgImage[0]['rxIcon'],
                   chamber_id: parseInt(chamberIdController.text.toString()),
                   advice_gap: parseInt(gapBetweenAdviceController.text.toString()),
                 ));
               }

             }else{
               await prescriptionLayout.savePrescriptionPrintLayout(boxPrescriptionPrintPageSetup, PrescriptionPrintLayoutSettingModel(
                 id: 0,
                 uuid: uuid,
                 u_status: statusNewAdd,
                 page_width: parseDouble(pageWidthController.text),
                 page_height: parseDouble(pageHeightController.text),
                 font_color: '',
                 font_size: parseDouble(pageFontSizeController.text),
                 top_mergin: parseDouble(pageMarginTopController.text),
                 right_mergin: parseDouble(pageMarginRightController.text),
                 bottom_mergin: parseDouble(pageMarginBottomController.text),
                 left_mergin: parseDouble(pageMarginLeftController.text),
                 sidebar_width: parseDouble(pageSideBarWidthController.text),
                 header_height: parseDouble(pageHeaderHeightController.text),
                 footer_height: parseDouble(pageFooterHeightController.text),
                 header_full_conten: '',
                 footer_content: '',
                 ph_background_color: "",
                 header_two_column_left: "",
                 header_two_column_right: "",
                 header_three_column_left: "",
                 header_three_column_center: "",
                 header_three_column_right: "",
                 header_image: headerFooterAndBgImage[0]['headerImage'],
                 footer_image: headerFooterAndBgImage[0]['footerImage'],
                 background_image: headerFooterAndBgImage[0]['backgroundImage'],
                 print_header_footer_or_none: printHeaderFooterOrNonValue.toString(),

                 clinicalDataMargin: parseDouble(clinicalDataMarginController.text),
                 brandDataMargin: parseDouble(brandDataMarginController.text),
                 rxDataStartingTopMargin: parseDouble(rxDataStartingTopMarginController.text),
                 clinicalDataStartingTopMargin: parseDouble(clinicalDataStartingTopMarginController.text),
                 marginBeforePatientName: parseDouble(marginBeforePatientNameController.text),
                 marginBeforePatientAge: parseDouble(marginBeforePatientAgeController.text),
                 marginBeforePatientId: parseDouble(marginBeforePatientIdController.text),
                 marginBeforePatientGender: parseDouble(marginBeforePatientGenderController.text),
                 marginBeforePatientDate: parseDouble(marginBeforePatientDateController.text),
                 clinicalDataPrintingPerPage: parseDouble(clinicalDataPrintingPerPageController.text),
                 brandDataPrintingPerPage: parseDouble(brandDataPrintingPerPageController.text),
                 clinicalAndBrandDataPerPageGap: parseDouble(clinicalAndBrandDataPerPageGapController.text),
                 marginAroundFullPage: parseDouble(marginAroundFullPageController.text),
                 marginLeftBrandData: marginLeftBrandData.text.isEmpty ? 0.0 : parseDouble(marginLeftBrandData.text),
                 marginRightBrandData: marginRightBrandData.text.isEmpty ? 0.0 : parseDouble(marginRightBrandData.text),
                 marginLeftClinicalData: marginLeftClinicalData.text.isEmpty ? 0.0 : parseDouble(marginLeftClinicalData.text),
                 marginRightClinicalData: marginRightClinicalData.text.isEmpty ? 0.0 : parseDouble(marginRightClinicalData.text),
                 date: dateTime,
                 font_size_pa_info: parseDouble(fontSizePaInfoController.text.toString()),
                 digital_signature: headerFooterAndBgImage[0]['digitalSignature'],
                 rx_icon: headerFooterAndBgImage[0]['rxIcon'],
                 chamber_id: parseInt(chamberIdController.text.toString()),
                 advice_gap: parseInt(gapBetweenAdviceController.text.toString()),
               ));
             }
           }

         }catch(e){
           print(e);
         }
       }else{
         ScaffoldMessenger.of(Get.context!).showSnackBar(
           const SnackBar(content: Text('Please select chamber first')),
         );
       }
  }

  Future getDataByChamberId(chamberId)async{
    var response = await prescriptionLayout.getChamber(boxPrescriptionPrintPageSetup, chamberId);
    if(response.isNotEmpty){
      print(response[0].date);
      return response[0].date;
    }

  }
  //get all prescription print setup data from database(box)
 Future<void> getAllData(chamberId)async{
    int? actChamberId;
    isLoading.value = true;

   try {
     List response = await prescriptionLayout.getChamber(boxPrescriptionPrintPageSetup, chamberId);
     headerFooterAndBgImage.clear();
     headerFooterAndBgImage.addAll(headerFooterAndBgImageC);
     headerFooterAndBgImage.refresh();
     if(response.length != 0 && response.length ==1){
       headerFooterAndBgImage.refresh();
       for(var i=0; i<response.length; i++){
         var responseSetting = response[i];
         actChamberId= responseSetting.chamber_id;
         var page_width= responseSetting.page_width;
         var page_height= responseSetting.page_height;
         var font_size= responseSetting.font_size == null ? 10.0 : responseSetting.font_size;
         var font_size_pa_info= responseSetting.font_size_pa_info == null ? 10.0 : responseSetting.font_size_pa_info;
         var font_color= responseSetting.font_color;
         var top_mergin= responseSetting.top_mergin == null ? 0.0 : responseSetting.top_mergin;
         var right_mergin= responseSetting.right_mergin  == null ? 0.0 : responseSetting.right_mergin;
         var bottom_mergin= responseSetting.bottom_mergin == null ? 0.0 : responseSetting.bottom_mergin;
         var left_mergin= responseSetting.left_mergin == null ? 0.0 : responseSetting.left_mergin;
         var sidebar_width= responseSetting.sidebar_width == null ? 0.0 : responseSetting.sidebar_width;
         var header_height= responseSetting.header_height == null ? 0.0 : responseSetting.header_height;
         var header_full_conten= responseSetting.header_full_conten == null ? '' : responseSetting.header_full_conten;
         var header_two_column_left= responseSetting.header_two_column_left;
         var header_two_column_right= responseSetting.header_two_column_right;
         var header_three_column_left= responseSetting.header_three_column_left;
         var header_three_column_center= responseSetting.header_three_column_center;
         var header_three_column_right= responseSetting.header_three_column_right;
         var footer_height= responseSetting.footer_height == null ? 0.0 : responseSetting.footer_height;
         var footer_content= responseSetting.footer_content ;
         var ph_font_color= responseSetting.ph_font_color;
         var ph_background_color= responseSetting.ph_background_color;
         var header_image= responseSetting.header_image;
         var footer_image= responseSetting.footer_image;
         var digital_signature= responseSetting.digital_signature;
         var rx_icon= responseSetting.rx_icon;
         var background_image= responseSetting.background_image;
         var print_header_footer_or_none= responseSetting.print_header_footer_or_none;
         var clinicalDataMargin = responseSetting.clinicalDataMargin == null ? 0.0 : responseSetting.clinicalDataMargin;

         var brandDataMargin = responseSetting.brandDataMargin == null ? 0.0 : responseSetting.brandDataMargin;
         var rxDataStartingTopMargin = responseSetting.rxDataStartingTopMargin == null ? 0.0 : responseSetting.rxDataStartingTopMargin;
         var clinicalDataStartingTopMargin = responseSetting.clinicalDataStartingTopMargin == null ? 0.0 : responseSetting.clinicalDataStartingTopMargin;
         var marginBeforePatientName = responseSetting.marginBeforePatientName == null  ? 0.0 : responseSetting.marginBeforePatientName;
         var marginBeforePatientAge = responseSetting.marginBeforePatientAge == null ? 0.0 : responseSetting.marginBeforePatientAge;
         var marginBeforePatientId = responseSetting.marginBeforePatientId == null  ? 0.0 : responseSetting.marginBeforePatientId;
         var marginBeforePatientGender = responseSetting.marginBeforePatientGender == null ? 0.0 : responseSetting.marginBeforePatientGender;
         var marginBeforePatientDate = responseSetting.marginBeforePatientDate == null ? 0.0 : responseSetting.marginBeforePatientDate;
         var clinicalDataPrintingPerPage = responseSetting.clinicalDataPrintingPerPage == null ? 30.0  : responseSetting.clinicalDataPrintingPerPage;
         var brandDataPrintingPerPage = responseSetting.brandDataPrintingPerPage == null ? 12.0 : responseSetting.brandDataPrintingPerPage;
         var clinicalAndBrandDataPerPageGap = responseSetting.clinicalAndBrandDataPerPageGap == null ? 6.0 : responseSetting.clinicalAndBrandDataPerPageGap;
         var marginAroundFullPage = responseSetting.marginAroundFullPage == null ? 0.0 :  responseSetting.marginAroundFullPage;
         var adviceGap = responseSetting.advice_gap == null ? 0.0 :  responseSetting.advice_gap;


         pageWidthController.text = page_width.toString();
         gapBetweenAdviceController.text = adviceGap.toString();
         pageHeightController.text = page_height.toString();
         pageSideBarWidthController.text = sidebar_width.toString();
         pageHeaderHeightController.text = header_height.toString();
         pageFooterHeightController.text = footer_height.toString();
         pageFontSizeController.text = font_size.toString();

         pageFontColorController.text = font_color.toString();
         pageMarginTopController.text = top_mergin.toString();
         pageMarginBottomController.text = bottom_mergin.toString();
         pageMarginLeftController.text = left_mergin.toString();
         pageMarginRightController.text = right_mergin.toString();

         clinicalDataMarginController.text = clinicalDataMargin.toString();
         brandDataMarginController.text = brandDataMargin.toString();
         rxDataStartingTopMarginController.text = rxDataStartingTopMargin.toString();
         clinicalDataStartingTopMarginController.text = clinicalDataStartingTopMargin.toString();
         marginBeforePatientNameController.text = marginBeforePatientName.toString();
         marginBeforePatientAgeController.text = marginBeforePatientAge.toString();
         marginBeforePatientIdController.text = marginBeforePatientId.toString();
         marginBeforePatientGenderController.text = marginBeforePatientGender.toString();
         marginBeforePatientDateController.text = marginBeforePatientDate.toString();
         clinicalDataPrintingPerPageController.text = clinicalDataPrintingPerPage.toString();
         brandDataPrintingPerPageController.text = brandDataPrintingPerPage.toString();
         clinicalAndBrandDataPerPageGapController.text = clinicalAndBrandDataPerPageGap.toString();
         marginAroundFullPageController.text = marginAroundFullPage.toString();
         fontSizePaInfoController.text = responseSetting.font_size_pa_info.toString();
         chamberIdController.text =  responseSetting.chamber_id.toString();
         marginLeftBrandData.text =responseSetting.marginLeftBrandData != null ? responseSetting.marginLeftBrandData.toString()  : '0.0';
         marginRightBrandData.text= responseSetting.marginRightBrandData != null ? responseSetting.marginRightBrandData.toString()  : '0.0';
         marginLeftClinicalData.text= responseSetting.marginLeftClinicalData != null ? responseSetting.marginLeftClinicalData.toString()  : '0.0';
         marginRightClinicalData.text= responseSetting.marginRightClinicalData != null ? responseSetting.marginRightClinicalData.toString() : '0.0';


         if(header_image != null && header_image.isNotEmpty){
           headerFooterAndBgImage[0]['headerImage'] = header_image;
         }
        if(footer_image != null && footer_image.isNotEmpty){

          headerFooterAndBgImage[0]['footerImage'] = footer_image;
        }
        if(background_image != null && background_image.isNotEmpty){
          headerFooterAndBgImage[0]['backgroundImage'] = background_image;
        }
        if(digital_signature != null && digital_signature.isNotEmpty){
          headerFooterAndBgImage[0]['digitalSignature'] = digital_signature;
        }

        if(rx_icon != null && rx_icon.isNotEmpty){
          headerFooterAndBgImage[0]['rxIcon'] = rx_icon;
        }

        if(header_full_content.toString().isNotEmpty){
          header_full_content = header_full_content;
        }
        if(footer_content.toString().isNotEmpty){
          footer_full_content = footer_content;
        }
         printHeaderFooterOrNonValue.value = print_header_footer_or_none;

         List PrescriptionPrintSetupData = [
           {
             "page_width": page_width,
             "page_height": page_height,
             "font_size": font_size,
             "font_size_pa_info": font_size_pa_info,
             "font_color": font_color,
             "top_mergin": top_mergin,
             "right_mergin": right_mergin,
             "bottom_mergin": bottom_mergin,
             "left_mergin": left_mergin,
             "sidebar_width": sidebar_width,
             "header_height": header_height,
             "header_full_conten": header_full_conten,
             "header_two_column_left": header_two_column_left,
             "header_two_column_right": header_two_column_right,
             "header_three_column_left": header_three_column_left,
             "header_three_column_center": header_three_column_center,
             "header_three_column_right": header_three_column_right,
             "footer_height": footer_height,
             "footer_content": footer_content,
             "ph_font_color": ph_font_color,
             "ph_background_color": ph_background_color,
             "header_image": header_image,
             "footer_image": footer_image,
             "background_image": background_image,
             "print_header_footer_or_none": print_header_footer_or_none,
             "clinicalDataMargin": clinicalDataMargin,
             "brandDataMargin": brandDataMargin,
             "rxDataStartingTopMargin": rxDataStartingTopMargin,
             "clinicalDataStartingTopMargin": clinicalDataStartingTopMargin,
             "marginBeforePatientName": marginBeforePatientName,
             "marginBeforePatientAge": marginBeforePatientAge,
             "marginBeforePatientId": marginBeforePatientId,
             "marginBeforePatientGender": marginBeforePatientGender,
             "marginBeforePatientDate": marginBeforePatientDate,
             "clinicalDataPrintingPerPage": clinicalDataPrintingPerPage,
             "brandDataPrintingPerPage": brandDataPrintingPerPage,
             "clinicalAndBrandDataPerPageGap": clinicalAndBrandDataPerPageGap,
             "marginAroundFullPage": marginAroundFullPage,
             "gapAdvice": adviceGap,
           }
         ];
         prescriptionPageSetupData.clear();
         prescriptionPageSetupData.addAll(PrescriptionPrintSetupData);

       }

      isLoading.value = false;
     }
     if(response.length == 0){
       isLoading.value = false;
       await defaultPrescriptionPrintSetup(chamberId: chamberId);
     }
     if(actChamberId !=null){
       await setIntStoreKeyWithDefaultValue(syncTimeSharedPrefsKey.activeChamberId, actChamberId);
       activeChamberId.value = actChamberId;
     }

   }catch(e){
     print(e);
   }
 }

 Future<void>defaultPrescriptionPrintSetup({chamberId})async{
    try{
        pageWidthController.text = DefaultPrescriptionPrintSetupData.pageWidthController;
        pageHeightController.text = DefaultPrescriptionPrintSetupData.pageHeightController;
        pageSideBarWidthController.text = DefaultPrescriptionPrintSetupData.pageSideBarWidthController;
        pageHeaderHeightController.text = DefaultPrescriptionPrintSetupData.pageHeaderHeightController;
        pageFooterHeightController.text = DefaultPrescriptionPrintSetupData.pageFooterHeightController;
        pageFontSizeController.text = DefaultPrescriptionPrintSetupData.pageFontSizeController;
        pageFontColorController.text = DefaultPrescriptionPrintSetupData.pageFontColorController;
        pageMarginTopController.text = DefaultPrescriptionPrintSetupData.pageMarginTopController;
        pageMarginBottomController.text = DefaultPrescriptionPrintSetupData.pageMarginBottomController;
        pageMarginLeftController.text = DefaultPrescriptionPrintSetupData.pageMarginLeftController;
        pageMarginRightController.text = DefaultPrescriptionPrintSetupData.pageMarginRightController;

        horizontalBorder = DefaultPrescriptionPrintSetupData.horizontalBorder;
        rxIcon = DefaultPrescriptionPrintSetupData.rxIcon;
        verticalBorder = DefaultPrescriptionPrintSetupData.rxIcon;

        clinicalDataMarginController.text = DefaultPrescriptionPrintSetupData.clinicalDataMargin;
        brandDataMarginController.text = DefaultPrescriptionPrintSetupData.brandDataMargin;
        rxDataStartingTopMarginController.text = DefaultPrescriptionPrintSetupData.rxDataStartingTopMargin;
        clinicalDataStartingTopMarginController.text = DefaultPrescriptionPrintSetupData.clinicalDataStartingTopMargin;
        marginBeforePatientNameController.text = DefaultPrescriptionPrintSetupData.marginBeforePatientName;
        marginBeforePatientAgeController.text = DefaultPrescriptionPrintSetupData.marginBeforePatientAge;
        marginBeforePatientIdController.text = DefaultPrescriptionPrintSetupData.marginBeforePatientId;
        marginBeforePatientGenderController.text = DefaultPrescriptionPrintSetupData.marginBeforePatientGender;
        marginBeforePatientDateController.text = DefaultPrescriptionPrintSetupData.marginBeforePatientDate;
        clinicalDataPrintingPerPageController.text = DefaultPrescriptionPrintSetupData.clinicalDataPrintingPerPage;
        brandDataPrintingPerPageController.text = DefaultPrescriptionPrintSetupData.brandDataPrintingPerPage;
        clinicalAndBrandDataPerPageGapController.text = DefaultPrescriptionPrintSetupData.clinicalAndBrandDataPerPageGap;
        marginAroundFullPageController.text = DefaultPrescriptionPrintSetupData.marginAroundFullPage;
        fontSizePaInfoController.text = DefaultPrescriptionPrintSetupData.fontSizePaInfoController;
        gapBetweenAdviceController.text = DefaultPrescriptionPrintSetupData.gapAdvice;
        chamberIdController.text = chamberId.toString();
        marginRightBrandData.text = DefaultPrescriptionPrintSetupData.brandDataRightMargin;
        marginRightClinicalData.text = DefaultPrescriptionPrintSetupData.clinicalDataRightMargin;
        marginLeftBrandData.text = DefaultPrescriptionPrintSetupData.brandDataLeftMargin;
        marginLeftClinicalData.text = DefaultPrescriptionPrintSetupData.clinicalDataLeftMargin;
        await saveData(true);
        await getAllData(chamberId);

    }catch(e){
      print(e);
    }

 }

 getActiveChamberId()async{
   activeChamberId.value = await getIntStoreKeyWithValue(syncTimeSharedPrefsKey.activeChamberId);
   getAllData(activeChamberId.value);

 }

  @override
  void onInit() {
    // TODO: implement onInit
    getActiveChamberId();
    super.onInit();

  }

}

