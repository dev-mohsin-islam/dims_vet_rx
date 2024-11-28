import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/prescription_controller.dart';
import 'package:dims_vet_rx/screens/create_prescription_screen/create_prescription_components/drug_brand/selected_drug_brand_edit.dart';

import 'add_medicine_modal.dart';

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({super.key});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  Color? selectedColorSeed;
  List searchHistory = [];
  PrescriptionController prescriptionController =
      Get.put(PrescriptionController());

  Iterable<Widget> getHistoryList(SearchController controller) {
    searchHistory.sort((a, b) => a['brand_name'].compareTo(b['brand_name']));
    return searchHistory.map(
      (drug) => ListTile(
        subtitle:  Text(drug['generic_name']),
        title: Row(
          children: [
            Text(
              drug['brand_name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 3,
            ),
            Text(drug['form']),
            const SizedBox(
              width: 5,
            ),
            Text(drug['strength']),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.call_missed),
          onPressed: () {
            controller.text = drug['brand_name'];
            controller.selection =
                TextSelection.collapsed(offset: controller.text.length);
          },
        ),
        onTap: () {
          if(drug['dose'][0]['dose'] == null || drug['dose'][0]['dose'] == ''){
            drug['index'] = prescriptionController.selectedMedicine.length;
            prescriptionController.selectedMedicine.add(drug);
              // prescriptionController.showFavoriteList.value = false;
              // showAddMedicineModal(context, "Add Medicine");
              // prescriptionController.brandSearchController.text = drug['brand_name'];
              // prescriptionController.isExpanded.value = true;
              // prescriptionController.selectedBrandId.value = drug['brand_id'];
              // prescriptionController.getAllBrandData(prescriptionController.brandSearchController.text);
              controller.text = '';
            Navigator.pop(context);

          }else{
            drug['index'] = prescriptionController.selectedMedicine.length;
            prescriptionController.selectedMedicine.add(drug);
            controller.text = '';
            Navigator.pop(context);
          }

        },
      ),
    );
  }

  Iterable<Widget> getSuggestions(SearchController controller) {
    final String input = controller.value.text
        .toLowerCase(); // Convert input to lowercase for case-insensitive comparison
    var drugList = prescriptionController.modifyDrugData;

    return drugList
        .where((drug) => drug['brand_name']
                .toLowerCase()
                .startsWith(input) // Use startsWith for filtering
            )
        .map(
          (drug) =>  Column(
            children: [
              ListTile(
                subtitle:  Text(drug['generic_name']),
                title: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          drug['brand_name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                            width: 3),
                        Text(drug['form']),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                            fit: FlexFit.tight,
                            child: Text(drug['strength'])),


                      ],
                    ),
                  ],
                ),
                trailing: Tooltip(
                  message: "Search same brand name",
                  child: IconButton(
                    icon: const Icon(Icons.call_missed),
                    onPressed: () {
                      controller.text = drug['brand_name'];
                      controller.selection =
                          TextSelection.collapsed(offset: controller.text.length);
                    },
                  ),
                ),
                onTap: () {

                  var exist = searchHistory.any((element) => element['brand_id'] == drug['brand_id']);
                  if (!exist) {
                    searchHistory.add(drug);
                  }

                  if(drug['dose'][0]['dose'] == null || drug['dose'][0]['dose'] == ''){
                    // Navigator.pop(context);
                    // prescriptionController.showFavoriteList.value = false;
                    // showAddMedicineModal(context, "Add Medicine");
                    // prescriptionController.brandSearchController.text = drug['brand_name'];
                    // prescriptionController.isExpanded.value = true;
                    // prescriptionController.selectedBrandId.value = drug['brand_id'];
                    // prescriptionController.getAllBrandData(prescriptionController.brandSearchController.text);
                    drug['index'] = prescriptionController.selectedMedicine.length;
                    prescriptionController.selectedMedicine.add(drug);
                    controller.text = '';
                    Navigator.pop(context);


                  }else{
                    drug['index'] = prescriptionController.selectedMedicine.length;
                    prescriptionController.selectedMedicine.add(drug);
                    Navigator.pop(context);
                    controller.text = '';
                  }

                  // controller.closeView(filteredColor.label);
                  // handleSelection(filteredColor);
                },
              ),
            ],
          ),
        );
  }

  void handleSelection(selectedColor) {
    setState(() {
      selectedColorSeed = selectedColor.color;
      if (searchHistory.length >= 5) {
        searchHistory.removeLast();
      }
      searchHistory.insert(0, selectedColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData =
        ThemeData(useMaterial3: true, colorSchemeSeed: selectedColorSeed);
    final ColorScheme colors = themeData.colorScheme;

    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              SearchAnchor.bar(
                barHintText: 'Search by brand name',
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) {
                  if (controller.text.isEmpty) {
                    if (searchHistory.isNotEmpty) {
                      return getHistoryList(controller);
                    }
                    return <Widget>[
                      Center(
                        child: Text(
                          'No search history today.',
                          style: TextStyle(color: colors.outline),
                        ),
                      )
                    ];
                  }
                  return getSuggestions(controller);
                },
              ),
              // cardSize,
              // Card(color: colors.primary, child: cardSize),
              // Card(color: colors.onPrimary, child: cardSize),
              // Card(color: colors.primaryContainer, child: cardSize),
              // Card(color: colors.onPrimaryContainer, child: cardSize),
              // Card(color: colors.secondary, child: cardSize),
              // Card(color: colors.onSecondary, child: cardSize),
            ],
          ),
        ),
      ],
    );
  }
}

SizedBox cardSize = const SizedBox(
  width: 80,
  height: 30,
);
