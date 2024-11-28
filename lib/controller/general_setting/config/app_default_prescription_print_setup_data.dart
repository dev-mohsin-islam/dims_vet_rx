
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class DefaultPrescriptionPrintSetupData{

  static const pageWidthController =  "8.5";
  static const pageHeightController =  "11.0";
  static const pageSideBarWidthController =  "1.7";
  static const pageHeaderHeightController =  "1.0";
  static const pageFooterHeightController =  "1.0";
  static const pageFontSizeController =  "10.0";
  static const fontSizePaInfoController =  "10.0";
  static const pageFontColorController =  "2.0";
  static const pageMarginTopController =  "0.5";
  static const pageMarginBottomController =  "0.5";
  static const pageMarginLeftController =  "0.5";
  static const pageMarginRightController =  "0.5";

  static const clinicalDataMargin = "0.02";
  static const brandDataMargin = "0.02";

  static const rxDataStartingTopMargin = "0.0";
  static const clinicalDataStartingTopMargin = "0.0";

  static const marginBeforePatientId = "0.0";
  static const marginBeforePatientName = "0.2";
  static const marginBeforePatientAge = "0.2";
  static const marginBeforePatientGender = "0.2";
  static const marginBeforePatientDate = "0.2";
  static const gapAdvice = "0.1";

  static const clinicalDataPrintingPerPage = "35";
  static const brandDataPrintingPerPage = "12";
  static const clinicalAndBrandDataPerPageGap = "6";
  static const marginAroundFullPage = "0.0";
  static const clinicalDataLeftMargin = "0.5";
  static const clinicalDataRightMargin = "0.5";
  static const brandDataLeftMargin = "0.5";
  static const brandDataRightMargin = "0.5";

  static const chamberIdController = 1;

  String header_full_content = "";
  String footer_full_content = "";

  static  RxBool horizontalBorder = true.obs;
  static  RxBool rxIcon = true.obs;
  static  RxBool verticalBorder = true.obs;

  static const printHeaderFooterOrNonValuePrintedHeaderFooter = "printedHeaderFooter";
  static const printHeaderFooterOrNonValueCustomBuilderHeaderFooter = "customBuilderHeaderFooter";
  static const printHeaderFooterOrNonValueImageHeaderFooter = "imageHeaderFooter";
}