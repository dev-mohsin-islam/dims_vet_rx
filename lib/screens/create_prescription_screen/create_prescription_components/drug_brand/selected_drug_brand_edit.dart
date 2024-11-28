import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/general_setting/general_setting_controller.dart';

import '../../../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../../../controller/dose/dose_controller.dart';
import '../../../../controller/instruction/instruction_controller.dart';
import '../../../../controller/prescription_duration/prescription_duration_controller.dart';
import 'components/expansion_tile.dart';

selectedMedicineChangeCompanyModal(context, fieldName, screenWidth, screenHeight, genericId,companyId, doses, changeCompany) {

  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  GeneralSettingController generalSettingController = Get.put(GeneralSettingController());


  //dose list
  final DoseController doseController = Get.put(DoseController());
  final doseList = doseController.dataList;


  final DurationController durationController = Get.put(DurationController());
  final durationList = durationController.dataList;

  //instruction
  final InstructionController instructionController = Get.put(
      InstructionController());
  final instructionList = instructionController.dataList;
  // for(var index = 0; index < prescriptionController.modifyDrugData.length; index ++) {
  //   if(prescriptionController.modifyDrugData[index]['generic_id'] == genericId) {
  //     prescriptionController.modifyDrugData[index]['dose'] = doses;
  //   }
  // }

  RxString searchCompany = ''.obs;
  searchCompany.value = '';


  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(fieldName),
            SizedBox(
              width: screenWidth * 0.3,
              child: TextField(
                onChanged: (value){
                    searchCompany.value = value;
                },
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search by company name..",
                    border: OutlineInputBorder()
                )
              ),
            ),
            IconButton(onPressed: () {
              searchCompany.value = '';
              //prescriptionController.getAllBrandData('');
              Navigator.pop(context);
            }, icon: Icon(Icons.clear))
          ],
        ),
        content:
        SizedBox(
          width: screenWidth * 0.7,
          height: screenHeight * 0.7,
          child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Obx(() {
                    return Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for(var drugData in prescriptionController.modifyDrugData)
                                if(drugData['generic_id'] == genericId)
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if(searchCompany.value != '')
                                          if(drugData['company_name'].toString().toLowerCase().contains(searchCompany.value.toLowerCase()))
                                        Card(
                                            child: expansionTile(prescriptionController, drugData,generalSettingController, doseList , durationList, instructionList, changeCompany )
                                        ),
                                        if(searchCompany.value == '')
                                          Card(
                                              child: expansionTile(prescriptionController, drugData,generalSettingController, doseList , durationList, instructionList, changeCompany )
                                          ),
                                      ],
                                    ),
                                  ),

                            ]

                        ),
                      ],
                    );

                  }),
                ],
              )
          ),
        ),
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  searchCompany.value = '';
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          )
        ],

      );
    },
  );
}
selectedMedicineChangeBrandModal(context, fieldName, screenWidth, screenHeight, genericId, doses,changeBrand) {

  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  GeneralSettingController generalSettingController = Get.put(GeneralSettingController());


  //dose list
  final DoseController doseController = Get.put(DoseController());
  final doseList = doseController.dataList;


  final DurationController durationController = Get.put(DurationController());
  final durationList = durationController.dataList;

  //instruction
  final InstructionController instructionController = Get.put(
      InstructionController());
  final instructionList = instructionController.dataList;
  // for(var index = 0; index < prescriptionController.modifyDrugData.length; index ++) {
  //   if(prescriptionController.modifyDrugData[index]['generic_id'] == genericId) {
  //     prescriptionController.modifyDrugData[index]['dose'] = doses;
  //   }
  // }

  RxString searchBrand = ''.obs;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(fieldName),
            SizedBox(
              width: screenWidth * 0.3,
              child: TextField(
                onChanged: (value){
                    searchBrand.value = value;
                  // prescriptionController.drugBrandSearch(value);
                },
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search by brand name..",
                    border: OutlineInputBorder()
                )
              ),
            ),
            IconButton(onPressed: (){
              searchBrand.value = '';
              Navigator.pop(context);
            }, icon:  Icon(Icons.clear),)
          ],
        ),
        content:
        SizedBox(
          width: screenWidth * 0.7,
          height: screenHeight * 0.7,
          child: SingleChildScrollView(
              child: Column(
                children: [
                  const Divider(),
                  Obx(() {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for(var drugData in prescriptionController.modifyDrugData)
                            if(drugData['generic_id'] == genericId)
                              Column(
                                  children:  [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if(searchBrand.value != '')
                                          if(drugData['brand_name'].toString().toLowerCase().contains(searchBrand.value.toLowerCase()))
                                        Card(
                                            child: expansionTile(prescriptionController, drugData,generalSettingController, doseList , durationList, instructionList,changeBrand,)
                                        ),
                                        if(searchBrand.value == '')
                                        Card(
                                            child: expansionTile(prescriptionController, drugData,generalSettingController, doseList , durationList, instructionList,changeBrand,)
                                        ),
                                      ],
                                    )
                                  ])
                        ]

                    );

                  }),
                ],
              )
          ),
        ),
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          )
        ],

      );
    },
  );
}

selectedMedicineEditModal(context, fieldName, screenWidth, screenHeight, editBrandId,editBrand,[isFromHome = false]) {

  final PrescriptionController prescriptionController = Get.put(PrescriptionController());
  GeneralSettingController generalSettingController = Get.put(GeneralSettingController());

  final selectedMedicineList = prescriptionController.selectedMedicine;

  //dose list
  final DoseController doseController = Get.put(DoseController());
  final doseList = doseController.dataList;


  final DurationController durationController = Get.put(DurationController());
  final durationList = durationController.dataList;

  //instruction
  final InstructionController instructionController = Get.put(
      InstructionController());
  final instructionList = instructionController.dataList;

if(isFromHome == false)
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(fieldName),
            IconButton(onPressed: ()async{
              prescriptionController.isExpanded.value =await false;
              Navigator.pop(context);
            }, icon: Icon(Icons.clear))
          ],
        ),
        content:
        EditMedicineMainContainer(isFromHome,screenWidth, screenHeight, selectedMedicineList, editBrandId, prescriptionController, generalSettingController, doseList, durationList, instructionList, editBrand),
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: ()async {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          )
        ],

      );
    },
  );
if(isFromHome == true)
  return EditMedicineMainContainer(isFromHome,screenWidth, screenHeight, selectedMedicineList, editBrandId, prescriptionController, generalSettingController, doseList, durationList, instructionList, editBrand);
}

SizedBox EditMedicineMainContainer(isFromHome,screenWidth, screenHeight, RxList<dynamic> selectedMedicineList, editBrandId, PrescriptionController prescriptionController, GeneralSettingController generalSettingController, RxList<dynamic> doseList, RxList<dynamic> durationList, RxList<dynamic> instructionList, editBrand) {

  return SizedBox(
        width: screenWidth * 0.7,
        height: screenHeight * 0.7,
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Obx(() {
                  return Column(

                      children:

                      [
                        for(var drugData in prescriptionController.selectedMedicine)
                          if(drugData['brand_id'] ==  editBrandId)
                            Column(
                                children:  [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Card(
                                          child: expansionTile(prescriptionController, drugData,generalSettingController, doseList , durationList, instructionList, editBrand)
                                      ),
                                    ],
                                  )
                                ])
                      ]

                  );

                }),
              ],
            )
        ),
      );
}
