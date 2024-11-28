
import 'dart:io';
import 'dart:typed_data';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/chambers/chamber_controller.dart';
import 'package:dims_vet_rx/controller/general_setting/general_setting_controller.dart';
import 'package:dims_vet_rx/controller/general_setting/prescription_print_page_setup_controller.dart';
import 'package:dims_vet_rx/screens/general_settings_screen/general_setting_components/prescription_print_layout_html_builder.dart';
import 'package:dims_vet_rx/utilities/app_strings.dart';

import '../../controller/general_setting/config/app_default_prescription_print_setup_data.dart';
import '../../utilities/style.dart';


Widget prescriptionPrintPageSetup(context){
 final PrescriptionPrintPageSetupController controller = Get.put(PrescriptionPrintPageSetupController());
 final ChamberController chamberController = Get.put(ChamberController());
 final GeneralSettingController generalSettingController = Get.put(GeneralSettingController());
 List<dynamic> chamberList = chamberController.chamberList;
 return  SingleChildScrollView(

   child: Obx(() => Column(
     children: [
        // if(controller.isLoading.value == true)
        //  Center(child: loadingDialog(context),),
       SizedBox(height: 20,),
       Container(
         width: 250,
         child: FilledButton(
             onPressed: ()async{
               await controller.defaultPrescriptionPrintSetup();
             }, child: Row(
           children: [
             Icon(Icons.settings),
             Text(AppButtonString.DefaultSettingSetup)
           ],
         )),
       ),
       Wrap(
         crossAxisAlignment: WrapCrossAlignment.center,
         children: [
           Text("Active Chamber: ", style: TextStyle(fontWeight: FontWeight.bold),),
            for(var chamber in chamberList)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio(
                        value: chamber.id,
                        groupValue: controller.activeChamberId.value,
                        onChanged:(value){
                          controller.getAllData(value);
                          // controller.activeChamberId.value = value;
                    }),
                    Text(chamber.chamber_name.toString())
                  ],
                ),
              ),
            )
         ]
       ),
       Container(
         padding: const EdgeInsets.all(10),
         color: Colors.white54,
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [

                     const SizedBox(height: 20,),
                     const Text("Page Setup (inc)", style: TextStyle(fontWeight: FontWeight.bold),),
                     Wrap(
                       children: [
                         InputFieldForPrintPageSetup(AppInputLabel.pageWidth, controller.pageWidthController, controller.pageWidthController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.pageHeight, controller.pageHeightController, controller.pageHeightController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.sideBarWidth, controller.pageSideBarWidthController, controller.pageSideBarWidthController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.headerHeight, controller.pageHeaderHeightController, controller.pageHeaderHeightController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.footerHeight, controller.pageFooterHeightController, controller.pageFooterHeightController, TextInputType.numberWithOptions(decimal: true)),

                         InputFieldForPrintPageSetup(AppInputLabel.fontSize, controller.pageFontSizeController, controller.pageFontSizeController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.fontSizePaInfo, controller.fontSizePaInfoController, controller.fontSizePaInfoController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.fontColor, controller.pageFontColorController, controller.pageFontColorController, TextInputType.numberWithOptions(decimal: true)),
                       ],
                     ),

                     const SizedBox(height: 20,),
                     const Text("Page Margin (inc)", style: TextStyle(fontWeight: FontWeight.bold),),
                     Wrap(
                       children: [
                         InputFieldForPrintPageSetup(AppInputLabel.marginTop, controller.pageMarginTopController, controller.pageMarginTopController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.marginBottom, controller.pageMarginBottomController, controller.pageMarginBottomController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.marginLeft, controller.pageMarginLeftController, controller.pageMarginLeftController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.marginRight, controller.pageMarginRightController, controller.pageMarginRightController, TextInputType.numberWithOptions(decimal: true)),
                       ],
                     ),
                     const SizedBox(height: 20,),

                     const Text("Printing Adjustment in Patient Info (inc)", style: TextStyle(fontWeight: FontWeight.bold),),
                     Wrap(
                       children: [
                         InputFieldForPrintPageSetup(AppInputLabel.marginBeforePatientId, controller.marginBeforePatientIdController, controller.marginBeforePatientIdController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.marginBeforePatientName, controller.marginBeforePatientNameController, controller.marginBeforePatientNameController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.marginBeforePatientAge, controller.marginBeforePatientAgeController, controller.marginBeforePatientAgeController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.marginBeforePatientGender, controller.marginBeforePatientGenderController, controller.marginBeforePatientGenderController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.marginBeforePatientDate, controller.marginBeforePatientDateController, controller.marginBeforePatientDateController, TextInputType.numberWithOptions(decimal: true)),
                       ],
                     ),

                     const SizedBox(height: 20,),
                     const Text("For main prescription (inc)", style: TextStyle(fontWeight: FontWeight.bold),),
                     Wrap(
                       children: [
                         InputFieldForPrintPageSetup(AppInputLabel.clinicalDataMargin, controller.clinicalDataMarginController, controller.clinicalDataMarginController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.adviceGapBetween, controller.gapBetweenAdviceController, controller.gapBetweenAdviceController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.brandDataMargin, controller.brandDataMarginController, controller.brandDataMarginController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.rxDataStartingTopMargin, controller.rxDataStartingTopMarginController, controller.rxDataStartingTopMarginController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.clinicalDataStartingTopMargin, controller.clinicalDataStartingTopMarginController, controller.clinicalDataStartingTopMarginController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.marginAroundFullPage, controller.marginAroundFullPageController, controller.marginAroundFullPageController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.clinicalDataLeftMargin, controller.marginLeftClinicalData, controller.marginLeftClinicalData, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.clinicalDataRightMargin, controller.marginRightClinicalData, controller.marginRightClinicalData, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.brandDataLeftMargin, controller.marginLeftBrandData, controller.marginLeftBrandData, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.brandDataRightMargin, controller.marginRightBrandData, controller.marginRightBrandData, TextInputType.numberWithOptions(decimal: true)),

                          ],
                     ),

                     const SizedBox(height: 20,),
                     const Text("Show Data Per page (number of item)", style: TextStyle(fontWeight: FontWeight.bold),),
                     Wrap(
                       children: [
                         InputFieldForPrintPageSetup(AppInputLabel.clinicalDataPrintingPerPage, controller.clinicalDataPrintingPerPageController, controller.clinicalDataPrintingPerPageController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.brandDataPrintingPerPage, controller.brandDataPrintingPerPageController, controller.brandDataPrintingPerPageController, TextInputType.numberWithOptions(decimal: true)),
                         InputFieldForPrintPageSetup(AppInputLabel.clinicalAndBrandDataPerPageGap, controller.clinicalAndBrandDataPerPageGapController, controller.clinicalAndBrandDataPerPageGapController, TextInputType.numberWithOptions(decimal: true)),
                          ],
                     ),
                     const SizedBox(height: 20,),

                   ],
                 )),
             Expanded(
                 child: Image.asset("assets/images/img.png"),),
           ],
         ),
       ),
       const SizedBox(height: 60,),

       Column(
         children: [
           if(Platform.isAndroid)
           Container(
             width: MediaQuery.of(context).size.width * 0.5,
             child: DropdownButtonFormField2<String>(
               isExpanded: true,
               decoration: InputDecoration(
                 contentPadding: const EdgeInsets.symmetric(vertical: 16),
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                 ),
               ),
               hint: Text(
                 "Delete Range ${generalSettingController.selectedValue.value} data",
                 style: TextStyle(fontSize: 14),
               ),
               items: generalSettingController.deleteRangeItems.map((item) => DropdownMenuItem<String>(
                 value: item,
                 child: Text(
                   item,
                   style: const TextStyle(
                     fontSize: 14,
                   ),
                 ),
               )).toList(),

               onChanged: (value) {
                 generalSettingController.selectedValue.value = value.toString();
                 if (value != null) {
                   generalSettingController.updateDeleteData(value);
                 }
               },
               onSaved: (value) {
                 generalSettingController.selectedValue.value = value.toString();
                 if (value != null) {
                   generalSettingController.updateDeleteData(value);
                 }
               },
               buttonStyleData: const ButtonStyleData(
                 padding: EdgeInsets.only(right: 8),
               ),
               iconStyleData: const IconStyleData(
                 icon: Icon(
                   Icons.arrow_drop_down,
                   color: Colors.black45,
                 ),
                 iconSize: 24,
               ),
               dropdownStyleData: DropdownStyleData(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(15),
                 ),
               ),
               menuItemStyleData: const MenuItemStyleData(
                 padding: EdgeInsets.symmetric(horizontal: 16),
               ),
             ),
           ),

           Wrap(
             children: [
               Card(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Radio(
                           value: DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValueImageHeaderFooter,
                           groupValue: controller.printHeaderFooterOrNonValue.value,
                           onChanged: (value){
                             controller.printHeaderFooterOrNonValue.value = value!;
                           }),
                       const Text("Show Image Header/Footer"),
                     ],
                   ),
                 ),
               ),
               Card(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Radio(
                           value: DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValueCustomBuilderHeaderFooter,
                           groupValue: controller.printHeaderFooterOrNonValue.value,
                           onChanged: (value){
                             controller.printHeaderFooterOrNonValue.value = value!;
                           }),
                       const Text("Show Custom Builder Header/Footer"),
                     ],
                   ),
                 ),
               ),
               Card(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Radio(
                           value: DefaultPrescriptionPrintSetupData.printHeaderFooterOrNonValuePrintedHeaderFooter,
                           groupValue: controller.printHeaderFooterOrNonValue.value,
                           onChanged: (value){
                             print(value);
                             controller.printHeaderFooterOrNonValue.value = value!;
                           }),
                       const Text("Hide both"),
                     ],
                   ),
                 ),
               ),

             ],
           ),
           Obx(() =>  Column(
             children: [
              SizedBox(
                width: 650,
                child: Column(
                  children: [
                    Card(
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: const Text("Header Image"),
                        children: [
                          ElevatedButton(
                              onPressed: ()async{
                                await controller.getImage("headerImage");
                              }, child: const Text("Upload Image")),
                          const SizedBox(height: 10,),
                          if (controller.headerFooterAndBgImage[0]['headerImage']!.isNotEmpty)
                            InkWell(
                              onTap: () {
                                if (controller.headerFooterAndBgImage[0]['headerImage']!.isNotEmpty) {
                                  // Show full-screen dialog with the image
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        // backgroundColor: Colors.transparent,
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                                            child: Image.memory(
                                              controller.headerFooterAndBgImage[0]['headerImage']!,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                              child: SizedBox(
                                // height: 100,
                                // width: 100,
                                child: Center(
                                  child: controller.headerFooterAndBgImage[0]['headerImage']!.isEmpty
                                      ? const Text('')
                                      : Stack(
                                    alignment : AlignmentDirectional.topStart,
                                    children: [
                                      Image.memory(
                                          controller.headerFooterAndBgImage[0]['headerImage'],
                                          fit: BoxFit.cover
                                      ),
                                      IconButton(onPressed: (){
                                        controller.headerFooterAndBgImage[0]['headerImage'] = Uint8List(0);
                                        controller.headerFooterAndBgImage.refresh();
                                      }, icon: const Icon(Icons.cancel,color: Colors.white,))
                                    ],
                                  ),),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Card(
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: const Text("Footer Image"),
                        children: [
                          ElevatedButton(
                              onPressed: ()async{
                                await controller.getImage("footerImage");
                              }, child: const Text("Upload Image")),
                          const SizedBox(height: 10,),
                          if (controller.headerFooterAndBgImage[0]['footerImage']!.isNotEmpty)
                            InkWell(
                              onTap: () {
                                if (controller.headerFooterAndBgImage[0]['footerImage']!.isNotEmpty) {
                                  // Show full-screen dialog with the image
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        // backgroundColor: Colors.transparent,
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                                            child: Image.memory(
                                              controller.headerFooterAndBgImage[0]['footerImage']!,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                              child: SizedBox(
                                // height: 100,
                                // width: 100,
                                child: Center(
                                  child: controller.headerFooterAndBgImage[0]['footerImage']!.isEmpty
                                      ? const Text('')
                                      : Stack(
                                    alignment : AlignmentDirectional.topStart,
                                    children: [
                                      Image.memory(
                                          controller.headerFooterAndBgImage[0]['footerImage'],
                                          fit: BoxFit.cover
                                      ),
                                      IconButton(onPressed: (){
                                        controller.headerFooterAndBgImage[0]['footerImage'] = Uint8List(0);
                                        controller.headerFooterAndBgImage.refresh();
                                      }, icon: const Icon(Icons.cancel,color: Colors.white,))
                                    ],
                                  ),),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Card(
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: const Text("Digital Signature Image"),
                        children: [
                          ElevatedButton(
                              onPressed: ()async{
                                await controller.getImage("digitalSignature");
                              }, child: const Text("Upload Image")),
                          const SizedBox(height: 10,),
                          if (controller.headerFooterAndBgImage[0]['digitalSignature']!.isNotEmpty)
                            InkWell(
                              onTap: () {
                                if (controller.headerFooterAndBgImage[0]['digitalSignature']!.isNotEmpty) {
                                  // Show full-screen dialog with the image
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        // backgroundColor: Colors.transparent,
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                                            child: Image.memory(
                                              controller.headerFooterAndBgImage[0]['digitalSignature']!,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                              child: SizedBox(
                                // height: 100,
                                // width: 100,
                                child: Center(
                                  child: controller.headerFooterAndBgImage[0]['digitalSignature']!.isEmpty
                                      ? const Text('')
                                      : Stack(
                                    alignment : AlignmentDirectional.topStart,
                                    children: [
                                      Image.memory(
                                          controller.headerFooterAndBgImage[0]['digitalSignature'],
                                          fit: BoxFit.cover
                                      ),
                                      IconButton(onPressed: (){
                                        controller.headerFooterAndBgImage[0]['digitalSignature'] = Uint8List(0);
                                        controller.headerFooterAndBgImage.refresh();
                                      }, icon: const Icon(Icons.cancel,color: Colors.white,))
                                    ],
                                  ),),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Card(
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: const Text("Rx Icon Image"),
                        children: [
                          ElevatedButton(
                              onPressed: ()async{
                                await controller.getImage("rxIcon");
                              }, child: const Text("Upload Image")),
                          const SizedBox(height: 10,),
                          if (controller.headerFooterAndBgImage[0]['rxIcon']!.isNotEmpty)
                            InkWell(
                              onTap: () {
                                if (controller.headerFooterAndBgImage[0]['rxIcon']!.isNotEmpty) {
                                  // Show full-screen dialog with the image
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        // backgroundColor: Colors.transparent,
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                                            child: Image.memory(
                                              controller.headerFooterAndBgImage[0]['rxIcon']!,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                              child: SizedBox(
                                // height: 100,
                                // width: 100,
                                child: Center(
                                  child: controller.headerFooterAndBgImage[0]['rxIcon']!.isEmpty
                                      ? const Text('')
                                      : Stack(
                                    alignment : AlignmentDirectional.topStart,
                                    children: [
                                      Image.memory(
                                          controller.headerFooterAndBgImage[0]['rxIcon'],
                                          fit: BoxFit.cover
                                      ),
                                      IconButton(onPressed: (){
                                        controller.headerFooterAndBgImage[0]['rxIcon'] = Uint8List(0);
                                        controller.headerFooterAndBgImage.refresh();
                                      }, icon: const Icon(Icons.cancel,color: Colors.white,))
                                    ],
                                  ),),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              )


               // Card(
               //   child: ExpansionTile(
               //     initiallyExpanded: true,
               //     title: const Text("Footer Custom Builder"),
               //     children: [
               //       Image.asset("assets/images/rx_header.png"),
               //     ],
               //   ),
               // ),


             ],
           ))
         ],
       ),


       Padding(
         padding: const EdgeInsets.all(18.0),
         child: FilledButton(onPressed: ()async{
          await controller.saveData();
          chamberController.initCall();
         }, child: const Padding(
           padding: EdgeInsets.all(10.0),
           child: Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(Icons.save),
               Text(AppButtonString.saveString),
             ],
           ),
         )),
       )
     ],
   )),
 );
}


loadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}