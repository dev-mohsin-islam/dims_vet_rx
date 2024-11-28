import 'dart:io';
import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/chief_complain/chief_complain_controller.dart';
import 'package:dims_vet_rx/models/chief_complain/chief_complain_model.dart';
import 'package:dims_vet_rx/models/diagnosis/diagnosis_modal.dart';
import 'package:dims_vet_rx/models/history/history_model.dart';
import 'package:dims_vet_rx/models/investigation/investigation_modal.dart';
import 'package:dims_vet_rx/models/investigation_report/investigation_report_model.dart';
import 'package:dims_vet_rx/models/on_examination/on_examination_model.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/clinical_data/patient_histry.dart';
import 'package:dims_vet_rx/utilities/app_strings.dart';

import '../../../../controller/create_prescription/prescription/methods/custom_findings_controller.dart';
import '../../../../controller/create_prescription/prescription/prescription_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_findings_modal.dart';
import 'history_hx.dart';
import 'left_clinical_widget.dart'; // Assuming you are using GetX for state management

class ClinicalCommonDropDown extends StatelessWidget {
  final individualController;
  final model;
  final selectedDataList;
  final title;
  final favSegment;
  final mainKey;
  ClinicalCommonDropDown(this.title, this.selectedDataList, this.individualController,this.favSegment,this.model,{this.mainKey} );
  RxBool isSearchEmpty = false.obs;
  @override
  Widget build(BuildContext context) {
    final List items = individualController.dataList.map((element) => element.name.toString()).toList();
    final customFindingsController = Get.put(CustomFindingsController());
    final prescriptionController = Get.put(PrescriptionController());
    TextEditingController _searchController = TextEditingController();
    RxBool isVisible = false.obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownSearch<dynamic>(
                  clearButtonProps: ClearButtonProps(
                    isVisible: isVisible.value
                  ),
                  popupProps: PopupProps.menu(
                    favoriteItemProps: FavoriteItemProps(
                    ),
                    listViewProps: ListViewProps(
                      addAutomaticKeepAlives: false,
                    ),
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                        hintText: "Search",
                        suffix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          if(isSearchEmpty.value || !isSearchEmpty.value)
                            IconButton(
                              tooltip: "Add New",
                              onPressed: () {
                                if(_searchController.text.isNotEmpty) {
                                  insertNew(model,individualController,_searchController, selectedDataList);
                                  _searchController.clear();
                                  Navigator.pop(context);
                                }
                              },
                              icon: Icon(Icons.play_arrow_rounded),
                            ),

                            IconButton(
                              onPressed: () {
                                _searchController.clear();
                              },
                              icon: Icon(Icons.clear),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  items: items,
                  selectedItem:  null,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      filled: true,
                      prefixIcon: mainKey !=null || favSegment == FavSegment.history ? IconButton(onPressed: (){
                        if(mainKey !=null){
                          customFindingsController.getKeyValuePayerField('');
                          customFindingModal(context, mainKey, title);
                        }
                        if(favSegment == FavSegment.history){
                          historyDialog(context);
                        }
                      }, icon: Icon(Icons.add_box_outlined)) : null,
                      icon: IconButton(onPressed: (){
                        clinicalDataListScreen(context, title, individualController,selectedDataList, prescriptionController, favSegment);
                      }, icon: Icon(Icons.add_box)),
                      label: Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
                      border:  InputBorder.none,
                    )
                    // dropdownSearchDecoration: InputDecoration(
                    //   icon: IconButton(onPressed: (){}, icon: Icon(Icons.add_box)),
                    //   label: Text("Chief Complain", style: TextStyle(fontWeight: FontWeight.bold),),
                    //   border:  InputBorder.none,
                    // ),
                  ),
                  onChanged: (value) {
                    isVisible.value = true;
                    if (value != null) {
                      selectFromList(model,individualController,value, selectedDataList);
                      _searchController.clear();
                    }
                  },
                  asyncItems: (filter) async {
                    var filteredITem = await _searchItems(filter, items);
                    if (filteredITem.isEmpty) {
                      isSearchEmpty.value = true;
                    } else {
                      isSearchEmpty.value = false;
                    }
                    return filteredITem;
                  },
                ),
                // You can display the selected items below the dropdown as needed.
              ],
            )),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(() {
                  return Column(
                    children: [
                      if(selectedDataList.length >0)
                      if(model != HistoryModel)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: selectedDataList.map<Widget>((item) {
                          return
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    // border: Border.all(width: 1, color: Colors.grey)
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          selectedDataList.remove(item);
                                        },
                                        child: Icon(
                                          Icons.cancel,
                                          size: Platform.isAndroid ? 15 : 12,
                                        ),),
                                      const SizedBox(width: 5,),
                                      Flexible(child: Text(item.name, style: const TextStyle(fontSize: 16),)),
                                      const SizedBox(width: 5,),
                                      InkWell(
                                          onTap: (){
                                            clinicalFieldEditModal(context, item, selectedDataList, prescriptionController);
                                          },
                                          child: Icon(
                                            Icons.edit, size: Platform.isAndroid ? 15 : 12,)),
                                      const SizedBox(width: 5,),

                                    ],
                                  ),
                                ),

                              ],
                            );
                        }).toList(),

                      ),
                      if(model == HistoryModel)
                        historySelectedDataContainer(individualController)
                    ],
                  );
                }),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Optimized Search Function
  Future<List> _searchItems(String filter, List allItems) async {
    if (filter.isEmpty) return allItems.take(30).toList(); // Limit initial results
    final filteredItems = allItems.where((item) => item.toLowerCase().startsWith(filter.toLowerCase())).toList();
    if(filteredItems.isEmpty){
      isSearchEmpty.value = true;
    }
    return filteredItems; // Limit results to the first 20 matches
  }
}

insertNew(model,individualController,_searchController, selectedDataList){
  if(model == ChiefComplainModel) {
    selectedDataList.add(ChiefComplainModel(
      id: selectedDataList.length + 1,
      name: _searchController.text,
    ));
  }else if(model == InvestigationModal){
    selectedDataList.add(InvestigationModal(
      id: selectedDataList.length + 1,
      name: _searchController.text,
    ));
  }else if(model == InvestigationReportModel){
    selectedDataList.add(InvestigationReportModel(
      id: selectedDataList.length + 1,
      name: _searchController.text,
    ));
  }else if(model == OnExaminationModel){
    selectedDataList.add(OnExaminationModel(
      id: selectedDataList.length + 1,
      name: _searchController.text,
    ));
  }else if(model == HistoryModel){
    selectedDataList.add(HistoryModel(
      id: selectedDataList.length + 1,
      category: "General",
      name: _searchController.text, uuid: '', type: '',
    ));
    individualController.groupDataByCategory();
  }else if(model == DiagnosisModal){
    selectedDataList.add(DiagnosisModal(
      id: selectedDataList.length + 1,
      name: _searchController.text,
    ));
  }
}
selectFromList(model,individualController,value, selectedDataList){
  if (model == ChiefComplainModel) {
    selectedDataList.add(ChiefComplainModel(
      id: selectedDataList.length + 1,
      name: value,
    ));

  }else if(model == DiagnosisModal){
    selectedDataList.add(DiagnosisModal(
      id: selectedDataList.length + 1,
      name: value,
    ));
  }else if(model == InvestigationModal){
    selectedDataList.add(InvestigationModal(
      id: selectedDataList.length + 1,
      name: value,
    ));
  }else if(model == OnExaminationModel){
    selectedDataList.add(OnExaminationModel(
      id: selectedDataList.length + 1,
      name: value,
    ));
  }else if(model == InvestigationReportModel){
    selectedDataList.add(InvestigationReportModel(
      id: selectedDataList.length + 1,
      name: value,
    ));
  }else if(model == HistoryModel){
    individualController.searchHistoryForAddToRx(value);
  }
}