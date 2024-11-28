
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:dims_vet_rx/controller/advice_category/advice_category_controller.dart';
import 'package:dims_vet_rx/controller/company_name/company_name_controller.dart';
import 'package:dims_vet_rx/controller/dose/dose_controller.dart';
import 'package:dims_vet_rx/controller/favorite_index/favorite_index_controller.dart';
import 'package:dims_vet_rx/controller/handout_category/handout_category_controller.dart';
import 'package:dims_vet_rx/controller/improvement_type/improvement_type_controller.dart';
import 'package:dims_vet_rx/controller/instruction/instruction_controller.dart';
import 'package:dims_vet_rx/controller/speciality/speciality_controller.dart';
import 'package:dims_vet_rx/controller/strength/strength_controller.dart';
import 'package:dims_vet_rx/utilities/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/create_prescription/prescription/prescription_controller.dart';
import '../../controller/prescription_duration/prescription_duration_controller.dart';
import '../create_prescription_screen/create_prescription_components/clinical_data/procedure.dart';
import '../others_data_screen/add_new_compan_and_list.dart';
import 'common_screen_widget.dart';
import '../../controller/chief_complain/chief_complain_controller.dart';
import '../../controller/diagnosis/diagnosis_controller.dart';
import '../../controller/investigation/investigation_controller.dart';
import '../../controller/investigation_report/Investigation_report_controller.dart';
import '../../controller/on_examination/on_examination_controller.dart';
import '../../controller/on_examination_category/on_examination_category.dart';
import '../../controller/procedure/procedure_controller.dart';

final FavoriteIndexController favoriteIndexController = Get.put(FavoriteIndexController());




Widget specialityScreen(context)  {
  final SpecialityController controller = Get.put(SpecialityController());
  return screenSingleData(ScreenTitle.Speciality ,  controller, favoriteIndexController, "");
}


Widget improvementTypeScreen(context)  {
  final ImprovementTypeController controller = Get.put(ImprovementTypeController());
  return screenSingleData(ScreenTitle.ImprovementType ,  controller, favoriteIndexController, "");
}


Widget handoutCategory(context)  {
  final HandoutCategoryController controller = Get.put(HandoutCategoryController());
  return screenSingleData(ScreenTitle.HandoutCategory,  controller, favoriteIndexController, "");
}


Widget adviceCategoryScreen(context)  {
  final AdviceCategoryController controller =  Get.put(AdviceCategoryController());
  return screenSingleData(ScreenTitle.AdviceCategory,  controller, favoriteIndexController, "");
}










Widget strengthScreen(context){
  final StrengthController controller = Get.put(StrengthController());
  // return screenSingleData(ScreenTitle.Strength , controller, favoriteIndexController, "");

  return singleDataScreen(context,ScreenTitle.Strength , controller, "");

}

Obx singleDataScreen(context, String screenTitle, controller, String favoriteSegmentName) {
  return Obx(() => Column(
    children: [
      Container(
        width: MediaQuery.sizeOf(context).width * 1,
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 5,
            spacing: 5,
            children: [
              Text(screenTitle.toString(), style: TextStyle(color: Colors.teal, fontSize: 20, fontWeight: FontWeight.bold),),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: 200,
                  child: TextField(
                    onChanged: (value) {
                      controller.getAllData(value);
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Search by name"),

                  ),
                ),
              ),
              if(screenTitle == "Doses")
                FilledButton(onPressed: (){
                  dosesFormShort(context);
                }, child: Text("Doses Short List")),

              ElevatedButton(onPressed: () => newAddAndUpdateDialog(context, 0, controller), child: Text("Create New")),

            ],
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: controller.dataList.length,
          itemBuilder: (context, index){
            var item = controller.dataList[index];
            var name = item.name;
            var favoriteIndex = item.id;
            var favoriteId = favoriteIndexController.favoriteIndexDataList.firstWhere(
                  (element) => element.favorite_id == favoriteIndex && element.u_status != 2 && element.segment == favoriteSegmentName, orElse: () => null,);
            return SingleChildScrollView(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Wrap(
                        children: [
                          if (favoriteSegmentName.isNotEmpty)
                            favoriteId == null
                                ? IconButton(
                              onPressed: () async {
                                await favoriteIndexController.addData(
                                  favoriteIndexController.favoriteIndexDataList.length + 1,
                                  favoriteSegmentName,
                                  favoriteIndex,
                                );
                                await controller.getAllData('');
                                controller.dataList.refresh();
                              },
                              icon: const Icon(Icons.star_border),
                            )
                                : IconButton(
                              onPressed: () async {
                                favoriteIndexController.updateData(
                                  favoriteIndexController.favoriteIndexDataList.length + 1,
                                  favoriteSegmentName,
                                  favoriteIndex,
                                );
                                await controller.getAllData('');
                              },
                              icon: const Icon(Icons.star),
                            ),
                          const SizedBox(width: 10),
                          // item name
                          Container(
                              child: Text(name)),
                        ],
                      ),
                      // if (item.uuid.isNotEmpty)
                      Wrap(
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.nameController.text = item.name;
                              newAddAndUpdateDialog(context, item.id, controller);
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              controller.deleteData(item.id);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          // reverse: true,
          // shrinkWrap: true,
          // children: [
          //   for (var index = 0; index < controller.diagnosisList.length; index++)
          //     DiagnosisList(controller, index, context),
          // ]
        ),
      ),
    ],
  ));
}

dosesFormShort(context){
  final doseController = Get.put(DoseController());
  if(doseController.selectedDoseFormList.isEmpty){
    doseController.selectedDoseFormList.addAll(doseController.doseFormSortList);
  }
  final dosesForm = TextEditingController();
  final dosesShortForm = TextEditingController();
  var editIndex = null;
  showDialog(context: context, builder: (context){
    return AlertDialog(
      actions: [
        // FilledButton(onPressed: ()async{
        //   await doseController.insertDosesFormShort(doseController.selectedDoseFormList);
        // }, child: Text("Save"))
      ],
      title: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          Text("Doses Short List"),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.close)),
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: SingleChildScrollView(
          child: Obx(() => Column(
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 10,
                children: [
                  Container(
                    width: 200,
                    child: TextField(
                      controller: dosesForm,
                      decoration: InputDecoration(
                          labelText: "Dose Form",
                          border: OutlineInputBorder()
                      ),
                    ),
                  ),
                  Text("-"),
                  Container(
                    width: 200,
                    child: TextField(
                      controller: dosesShortForm,
                      decoration: InputDecoration(
                          labelText: "Dose Short Form",
                          border: OutlineInputBorder()
                      ),
                    ),
                  ),
                  FilledButton(onPressed: (){
                    if(editIndex ==null){
                      doseController.selectedDoseFormList.add({
                        'id': doseController.selectedDoseFormList.length + 1,
                        "dose_name": dosesForm.text,
                        "short_name": dosesShortForm.text
                      });
                    }
                    if(editIndex != null){
                      doseController.selectedDoseFormList.removeAt(editIndex);
                      doseController.selectedDoseFormList.add({
                        'id': doseController.selectedDoseFormList.length + 1,
                        "dose_name": dosesForm.text,
                        "short_name": dosesShortForm.text
                      });
                    }
                    dosesForm.clear();
                    dosesShortForm.clear();
                    doseController.insertDosesFormShort(doseController.selectedDoseFormList);
                    doseController.selectedDoseFormList.refresh();
                    editIndex = null;
                  }, child: Text(editIndex == null ? "Add" : "Update"))
                ],
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: doseController.selectedDoseFormList.length,
                  itemBuilder: (context, index ){
                    var item = doseController.selectedDoseFormList[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text("Dose Form : ${item['dose_name']}"),
                                Text(" => ", style: TextStyle(color: Colors.red),),
                                SizedBox(width: 10),
                                Text("Short Form : ${item['short_name']}"),
                              ],
                            ),
                            Wrap(
                              children: [
                                IconButton(onPressed: (){
                                  dosesForm.text = item['dose_name'];
                                  dosesShortForm.text = item['short_name'];
                                  editIndex = index;

                                }, icon: Icon(Icons.edit)),
                                IconButton(onPressed: ()async{
                                  await doseController.selectedDoseFormList.remove(item);
                                  doseController.insertDosesFormShort(doseController.selectedDoseFormList);
                                  doseController.selectedDoseFormList.refresh();
                                }, icon: Icon(Icons.delete)),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  })
            ],
          )),
        ),
      ),

    );
  });
}