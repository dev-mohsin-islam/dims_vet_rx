import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/authentication/login_controller.dart';
import 'package:dims_vet_rx/controller/dose/dose_controller.dart';
import 'package:dims_vet_rx/controller/general_setting/general_setting_controller.dart';
import 'package:dims_vet_rx/controller/instruction/instruction_controller.dart';
import 'package:dims_vet_rx/controller/prescription_duration/prescription_duration_controller.dart';
import 'package:dims_vet_rx/models/create_prescription/prescription_duration/prescription_duration_model.dart';
import 'package:dims_vet_rx/models/instruction/instruction_model.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/drug_brand/components/drug_instruction.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/drug_brand/selected_drug_brand_edit.dart';

import '../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../controller/drug_brand/drug_brand_controller.dart';
import '../../../../models/dose/dose_model.dart';
import '../../../../utilities/app_strings.dart';
import 'components/drug_dose.dart';
import 'components/drug_duration.dart';
import 'components/related_defualt_data_modal.dart';

class selectedMedicineFinal2 extends StatefulWidget {
  const selectedMedicineFinal2({super.key});

  @override
  State<selectedMedicineFinal2> createState() => _selectedMedicineFinal2State();
}

class _selectedMedicineFinal2State extends State<selectedMedicineFinal2> {
  final loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    final DrugBrandController drugBrandController =
        Get.put(DrugBrandController());
    final PrescriptionController prescriptionController =
        Get.put(PrescriptionController());
    final selectedDrugList = prescriptionController.selectedMedicine;
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;



    return Column(
      children: [
        Obx(() => Column(
              children: [
                if(loginController.selectedProfileType.value == "Doctor")
                ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedDrugList.length,
                  itemBuilder: (context, index) => DrugList(selectedDrugList, index, context, screenWidth, screenHeight, prescriptionController),
                  // reverse: true,
                  // shrinkWrap: true,
                  // children: [
                  //   for (var index = 0; index < selectedDrugList.length; index++)
                  //     DrugList(selectedDrugList, index, context, screenWidth, screenHeight, prescriptionController),
                  // ]
                ),



                // //   Text(selectedDrugList[i]['index'].toString()),
                // for (var index = 0; index < selectedDrugList.length; index++)
                //   DrugList(selectedDrugList, index, context, screenWidth, screenHeight, prescriptionController)
              ],
            )),
      ],
    );
  }

  Column DrugList(RxList<dynamic> selectedDrugList, int index, BuildContext context, double screenWidth, double screenHeight, PrescriptionController prescriptionController) {

    GeneralSettingController generalSettingController = Get.put(GeneralSettingController());
    var edit = generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "EnableDrugEditHome");
    var showGeneric = generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "GenericShowInHome");
    var showCompany = generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "CompanyNameShowSelectedDrug");
    var showDoseShort = generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "DoseShortForm");
    var showAlterCompanyButton = generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "AlterCompanyButton");
    var showAlterBrandButton = generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "AlterBrandButton");
    var ShowDeleteButton = generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "DeleteButton");
    var ShowDrugDefaultDoseButton = generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "DrugDefaultDoseButton");
    var ShowNoteButton = generalSettingController.settingsItemsDataList.any((element) => element['section'] == Settings.settingHome && element['label'] == "NoteButton");
        return Column(
                    children: [
                      // if (selectedDrugList[index]['dose'].isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[200],
                              border: Border.all(
                                  color: selectedDrugList[index]['dose'].isEmpty ? Colors.red : Colors.grey),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ExpansionTile(
                                        initiallyExpanded: true,
                                        title: Wrap(
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          children: [
                                            // Tooltip(
                                            //   message: "(${selectedDrugList[index]['generic_name']})",
                                            //   child: Text("${selectedDrugList[index]['brand_name']}",
                                            //     style: const TextStyle(
                                            //         fontWeight: FontWeight.w500),
                                            //   ),
                                            // ),

                                            Wrap(
                                              crossAxisAlignment: WrapCrossAlignment.center,
                                              alignment: WrapAlignment.spaceBetween,
                                              spacing: 10,
                                              children: [
                                                Card(
                                                  child: Wrap(
                                                    children: [
                                                      if(ShowDrugDefaultDoseButton)
                                                        IconButton(
                                                            tooltip: "Set default dose duration instruction",
                                                            onPressed: () {
                                                              // prescriptionController.isExpanded.value = true;
                                                              // prescriptionController.selectedBrandId.value = selectedDrugList[index]['brand_id'];
                                                              // selectedMedicineEditModal(context, "Edit", screenWidth, screenHeight, selectedDrugList[index]['brand_id'], "editBrandId");
                                                              brandDefaultModel(context, selectedDrugList[index]['brand_id']);
                                                            }, icon: const Icon(Icons.info_outline, size: 15,)),
                                                      if(ShowDeleteButton)
                                                        IconButton(
                                                            tooltip: "Delete from list",
                                                            onPressed: () {
                                                              selectedDrugList.removeAt(index);
                                                            }, icon: const Icon(Icons.delete_forever_outlined, size: 15,)),

                                                      if(showAlterCompanyButton)
                                                        IconButton(
                                                            tooltip: "Alternate Company",
                                                            onPressed: () {
                                                              selectedMedicineChangeCompanyModal(
                                                                  context,
                                                                  "Same brand other company",
                                                                  screenWidth,
                                                                  screenHeight,
                                                                  selectedDrugList[index]
                                                                  ['generic_id'],
                                                                  selectedDrugList[index]
                                                                  ['company_id'],
                                                                  selectedDrugList[index]
                                                                  ['dose'],
                                                                  "changeCompany");
                                                            },
                                                            icon: const Icon(Icons
                                                                .edit_location_alt_outlined, size: 15,)),
                                                      if(showAlterBrandButton)
                                                        IconButton(
                                                            tooltip: "Alternate Brand Same Generic",
                                                            onPressed: () {
                                                              selectedMedicineChangeBrandModal(context, "Alternate Available Brand", screenWidth, screenHeight, selectedDrugList[index]['generic_id'], selectedDrugList[index]['dose'], "changeBrand");
                                                            }, icon: const Icon(Icons.edit_note, size: 15,)),

                                                      IconButton(
                                                          tooltip:  "Add Dose, Edit Dose, Duration and Instruction",
                                                          onPressed: () {
                                                            prescriptionController.isExpanded.value = true;
                                                            prescriptionController.selectedBrandId.value = selectedDrugList[index]['brand_id'];

                                                            selectedMedicineEditModal(context, "Edit", screenWidth, screenHeight, selectedDrugList[index]['brand_id'], "editBrandId");
                                                          }, icon: const Icon(Icons.edit, size: 15,)),
                                                    ],
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: "(${selectedDrugList[index]['generic_name']})",
                                                  child: Text("${selectedDrugList[index]['brand_name']}",
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                                Wrap(
                                                  children: [
                                                    Text("${showDoseShort ? selectedDrugList[index]['sortForm'] : selectedDrugList[index]['form']}", style: TextStyle(fontSize: 14, color: Colors.blueGrey),),
                                                    Text("${selectedDrugList[index]['strength']}", style: TextStyle(fontSize: 10,color: Colors.grey),),
                                                  ],
                                                ),
                                                Wrap(
                                                  spacing: 10,
                                                  children: [
                                                    if(showGeneric)
                                                      Text("${selectedDrugList[index]['generic_name']}", style: const TextStyle(fontSize: 12,color: Colors.teal)) ,

                                                    if(showCompany)
                                                      Text("${selectedDrugList[index]['company_name']}", style: const TextStyle(fontSize: 12,)) ,
                                                  ],
                                                ),
                                              ],
                                            ),

                                            if(!Platform.isAndroid)
                                            Wrap(
                                              children: [
                                                for (var i = 0; i < selectedDrugList[index]['dose'].length; i++)
                                                  DosesList( selectedDrugList, index, i, prescriptionController, edit),
                                              ],
                                            ),

                                            // const SizedBox(
                                            //   width: 10,
                                            // ),
                                          ],
                                        ),
                                        children: [

                                          // Row(
                                          //   children: [
                                          //
                                          //     Wrap(
                                          //       children: [
                                          //         if(ShowDrugDefaultDoseButton)
                                          //         IconButton(
                                          //           tooltip: "Set default dose duration instruction",
                                          //             onPressed: () {
                                          //               // prescriptionController.isExpanded.value = true;
                                          //               // prescriptionController.selectedBrandId.value = selectedDrugList[index]['brand_id'];
                                          //               // selectedMedicineEditModal(context, "Edit", screenWidth, screenHeight, selectedDrugList[index]['brand_id'], "editBrandId");
                                          //               brandDefaultModel(context, selectedDrugList[index]['brand_id']);
                                          //             }, icon: const Icon(Icons.info_outline, size: 15,)),
                                          //         if(ShowDeleteButton)
                                          //         IconButton(
                                          //            tooltip: "Delete from list",
                                          //             onPressed: () {
                                          //               selectedDrugList.removeAt(index);
                                          //             }, icon: const Icon(Icons.delete_forever_outlined, size: 15,)),
                                          //
                                          //         if(showAlterCompanyButton)
                                          //         IconButton(
                                          //           tooltip: "Alternate Company",
                                          //             onPressed: () {
                                          //               selectedMedicineChangeCompanyModal(
                                          //                   context,
                                          //                   "Same brand other company",
                                          //                   screenWidth,
                                          //                   screenHeight,
                                          //                   selectedDrugList[index]
                                          //                   ['generic_id'],
                                          //                   selectedDrugList[index]
                                          //                   ['company_id'],
                                          //                   selectedDrugList[index]
                                          //                   ['dose'],
                                          //                   "changeCompany");
                                          //             },
                                          //             icon: const Icon(Icons
                                          //                 .edit_location_alt_outlined, size: 15,)),
                                          //         if(showAlterBrandButton)
                                          //         IconButton(
                                          //             tooltip: "Alternate Brand Same Generic",
                                          //             onPressed: () {
                                          //                 selectedMedicineChangeBrandModal(context, "Alternate Available Brand", screenWidth, screenHeight, selectedDrugList[index]['generic_id'], selectedDrugList[index]['dose'], "changeBrand");
                                          //             }, icon: const Icon(Icons.edit_note, size: 15,)),
                                          //
                                          //         IconButton(
                                          //           tooltip:  "Add Dose, Edit Dose, Duration and Instruction",
                                          //             onPressed: () {
                                          //               prescriptionController.isExpanded.value = true;
                                          //               prescriptionController.selectedBrandId.value = selectedDrugList[index]['brand_id'];
                                          //
                                          //               selectedMedicineEditModal(context, "Edit", screenWidth, screenHeight, selectedDrugList[index]['brand_id'], "editBrandId");
                                          //             }, icon: const Icon(Icons.edit, size: 15,)),
                                          //
                                          //       ],
                                          //     ),
                                          //     // Wrap(
                                          //     //   runSpacing: 5,
                                          //     //   spacing: 5,
                                          //     //   children: [
                                          //     //     if(showGeneric)
                                          //     //     Text("${selectedDrugList[index]['generic_name']}", style: const TextStyle(fontSize: 12,color: Colors.teal)) ,
                                          //     //
                                          //     //     if(showCompany)
                                          //     //     Text("${selectedDrugList[index]['company_name']}", style: const TextStyle(fontSize: 12,)) ,
                                          //     //   ],
                                          //     // )
                                          //   ],
                                          // ),
                                          if(Platform.isAndroid)
                                          for (var i = 0; i < selectedDrugList[index]['dose'].length; i++)
                                            DosesList( selectedDrugList, index, i, prescriptionController, edit),
                                        ],
                                      ),

                                      // if(showGeneric)

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                    ],
                  );
  }

  Column DosesList(RxList<dynamic> selectedDrugList, int index, int i, PrescriptionController prescriptionController, edit) {
    final screenWidth = Get.context!.width;
    final doseController = Get.put(DoseController());
    RxList doseList = [].obs;
    final durationController = Get.put(DurationController());
    final instructionController = Get.put(InstructionController());
    TextEditingController dose = TextEditingController();
    TextEditingController duration = TextEditingController();
    TextEditingController instruction = TextEditingController();
    TextEditingController note = TextEditingController();
     for(var j = 0; j < selectedDrugList[index]['dose'].length; j++){
       if(selectedDrugList[index]['dose'][j]['dose'] == selectedDrugList[index]['dose'][i]['dose']){
         dose.text = selectedDrugList[index]['dose'][j]['dose'];
         duration.text = selectedDrugList[index]['dose'][j]['duration'];
         instruction.text = selectedDrugList[index]['dose'][j]['instruction'];
         if(selectedDrugList[index]['dose'][j]['comment'] != null && selectedDrugList[index]['dose'][j]['comment'] != ''){
           note.text = selectedDrugList[index]['dose'][j]['comment'];
         }
       }
     }
    if(selectedDrugList[index]['dose'][i]['dose'] != null && selectedDrugList[index]['dose'][i]['dose'] != ''){
      var exist =  doseController.dataList.any((element) => element.name == selectedDrugList[index]['dose'][i]['dose']);
      if(!exist) {
        doseController.dataList.add(DoseModel(id: doseController.dataList.length +1, name:  selectedDrugList[index]['dose'][i]['dose']));
      }
    }if(selectedDrugList[index]['dose'][i]['duration'] != null && selectedDrugList[index]['dose'][i]['duration'] != ''){
      var exist =  durationController.dataList.any((element) => element.name == selectedDrugList[index]['dose'][i]['duration']);
      if(!exist) {
        durationController.dataList.add(PrescriptionDurationModel(id: durationController.dataList.length +1, name:  selectedDrugList[index]['dose'][i]['duration'], u_status: 1, uuid: '', number: 2, type: ''));
      }
    }
    if(selectedDrugList[index]['dose'][i]['instruction'] != null && selectedDrugList[index]['dose'][i]['instruction'] != ''){
      var exist =  instructionController.dataList.any((element) => element.name == selectedDrugList[index]['dose'][i]['instruction']);
      if(!exist) {
        instructionController.dataList.add(InstructionModel(id: durationController.dataList.length +1, name:  selectedDrugList[index]['dose'][i]['instruction']));
      }
    }

      return Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Column(
                  children: [
                    if(edit)
                    Row(
                      children: [
                        // Dose field
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(

                              border: Border.all(
                                  color: edit ? Colors.grey:  Colors.transparent),
                              borderRadius:
                                  BorderRadius
                                      .circular(5),
                            ),
                            child: TextFormField(
                              controller: dose,
                              maxLines: null,
                              // initialValue: selectedDrugList[index]['dose'][i]['dose'],
                              style: const TextStyle(

                                  fontWeight:
                                      FontWeight
                                          .w500),
                              decoration:
                                  const InputDecoration(

                                hintText:
                                    "Write dose: 1 + 1 + 1",
                                contentPadding:
                                    EdgeInsets
                                        .symmetric(
                                            horizontal:
                                                2),
                                border:
                                    InputBorder.none,
                              ),
                              onChanged: (value) {
                                selectedDrugList[
                                            index]
                                        ['dose'][i]
                                    ['dose'] = value;
                                prescriptionController
                                    .update(); // Notify GetX to update the UI
                              },
                            ),
                          ),
                        ),
                        if(edit)
                        const Text("-"),

                        // Duration field

                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                              color: edit ? Colors.grey:  Colors.transparent),
                              borderRadius:
                                  BorderRadius
                                      .circular(5),
                            ),
                            child: TextFormField(
                              controller: duration,
                              maxLines: null,
                              style: const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .w500),
                              decoration:
                                  const InputDecoration(

                                hintText:
                                    "Write duration: 7days",
                                contentPadding:
                                    EdgeInsets
                                        .symmetric(
                                            horizontal:
                                                2),
                                border:
                                    InputBorder.none,
                              ),
                              onChanged: (value) {
                                selectedDrugList[
                                                index]
                                            [
                                            'dose'][i]
                                        ['duration'] =
                                    value;
                                prescriptionController
                                    .update(); // Notify GetX to update the UI
                              },
                            ),
                          ),
                        ),

                        // const SizedBox(width: 8),
                        if(edit)
                        const Text("-"),

                        // Instruction field
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: edit ? Colors.grey :  Colors.transparent),
                              borderRadius:
                                  BorderRadius
                                      .circular(5),
                            ),
                            child: TextFormField(
                              controller: instruction,
                              maxLines: null,

                              style: const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .w500),
                              decoration:
                                  const InputDecoration(
                                hintText:
                                    "Write instruction: After meal",
                                contentPadding:
                                    EdgeInsets
                                        .symmetric(
                                            horizontal:
                                                2),
                                border:
                                    InputBorder.none,
                              ),
                              onChanged: (value) {
                                selectedDrugList[
                                                index]
                                            ['dose'][i]
                                        [
                                        'instruction'] =
                                    value;
                                prescriptionController
                                    .update(); // Notify GetX to update the UI
                              },
                            ),
                          ),
                        ),
                        if(edit)
                        const Text("-"),
                        // Optional comment field
                        // if (selectedDrugList[index]['dose'][i]['comment'].toString().isNotEmpty)
                        Note(note, selectedDrugList, index, i, prescriptionController),
                      ],
                    ),
                    if(!edit)
                    Column(
                      children: [
                        if(Platform.isWindows )
                        Wrap(
                         alignment:WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // Dose field
                            Container(width: MediaQuery.of(context).size.width * 0.170, child: drugDose(selectedDrugList[index], i, doseController.dataList, prescriptionController),),
                            Container(width: MediaQuery.of(context).size.width * 0.170, child: drugDuration(selectedDrugList[index], i, durationController.dataList, prescriptionController),),
                            Container(width: MediaQuery.of(context).size.width * 0.170, child: drugInstruction(selectedDrugList[index], i, instructionController.dataList, prescriptionController),),
                            IconButton(
                                tooltip: "Add note",
                                onPressed: (){
                                      showDialog(context: context, builder: (context){
                                        return AlertDialog(
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Add note"),
                                              const Spacer(),
                                              IconButton(onPressed: (){
                                                Navigator.pop(context);
                                              }, icon: Icon(Icons.close)),
                                            ],
                                          ),
                                          content: Note(note, selectedDrugList, index, i, prescriptionController),
                                        );
                                    });
                            }, icon: Icon(Icons.note_alt,size: 15, color: selectedDrugList[index]['dose'][i]['comment'].length > 0 ? Colors.blue : Colors.grey,)),
                            IconButton(
                              tooltip: "Remove Dose",
                                onPressed: (){
                                  selectedDrugList[index]['dose'].removeAt(i);
                                  selectedDrugList.refresh();
                            }, icon: Icon(Icons.highlight_remove_rounded, size: 15,)),


                            // const SizedBox(width: 8),
                            if(edit)
                            const Text("-"),

                            // Instruction field

                            if(edit)
                            const Text("-"),
                            // Optional comment field
                            // if (selectedDrugList[index]['dose'][i]['comment'].toString().isNotEmpty)
                            // Note(note, selectedDrugList, index, i, prescriptionController),
                          ],
                        ),

                        if(!Platform.isWindows)
                        Column(
                          children: [
                            // Dose field
                            Container(width: MediaQuery.of(context).size.width * 0.9, child: drugDose(selectedDrugList[index], i, doseController.dataList, prescriptionController),),
                            Container(width: MediaQuery.of(context).size.width * 0.9, child: drugDuration(selectedDrugList[index], i, durationController.dataList, prescriptionController),),
                            Container(width: MediaQuery.of(context).size.width * 0.9, child: drugInstruction(selectedDrugList[index], i, instructionController.dataList, prescriptionController),),
                            Container(width: 40,
                                child: Tooltip(
                                  message: "Add note",
                                  child: IconButton(onPressed: (){
                                    showDialog(context: context, builder: (context){
                                      return AlertDialog(
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Add note"),
                                            const Spacer(),
                                            IconButton(onPressed: (){
                                              Navigator.pop(context);
                                            }, icon: Icon(Icons.close)),
                                          ],
                                        ),
                                        content: Note(note, selectedDrugList, index, i, prescriptionController),
                                      );
                                    });
                                  }, icon: Icon(Icons.note_alt, color: selectedDrugList[index]['dose'][i]['comment'].length > 0 ? Colors.blue : Colors.grey,)),
                                )),


                            // const SizedBox(width: 8),
                            if(edit)
                            const Text("-"),

                            // Instruction field

                            if(edit)
                            const Text("-"),
                            // Optional comment field
                            // if (selectedDrugList[index]['dose'][i]['comment'].toString().isNotEmpty)
                            // Note(note, selectedDrugList, index, i, prescriptionController),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
  }

    Note(TextEditingController note, RxList<dynamic> selectedDrugList, int index, int i, PrescriptionController prescriptionController) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.grey),
        borderRadius:
            BorderRadius
                .circular(5),
      ),
      child: TextFormField(
        controller: note,
        maxLines: null,

        style: const TextStyle(
            fontWeight:
                FontWeight
                    .w500),
        decoration:
            const InputDecoration(
          hintText:
              "Write Note",
          contentPadding:
              EdgeInsets
                  .symmetric(
                      horizontal:
                          2),
          border:
              InputBorder.none,
        ),
        onChanged: (value) {
          selectedDrugList[
                          index]
                      [
                      'dose'][i]
                  ['comment'] =
              value;
          prescriptionController
              .update(); // Notify GetX to update the UI
        },
      ),
    );
  }
}


