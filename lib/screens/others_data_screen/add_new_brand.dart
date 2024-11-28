

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get.dart';
import 'package:dims_vet_rx/controller/chief_complain/chief_complain_controller.dart';
import 'package:dims_vet_rx/controller/company_name/company_name_controller.dart';
import 'package:dims_vet_rx/controller/create_prescription/prescription/prescription_controller.dart';
import 'package:dims_vet_rx/controller/drug_brand/drug_brand_controller.dart';
import 'package:dims_vet_rx/controller/drug_generic/drug_generic_controller.dart';
import 'package:dims_vet_rx/controller/favorite_index/favorite_index_controller.dart';
import 'package:dims_vet_rx/controller/sync_controller/sync_server_to_db_controller.dart';
import 'package:dims_vet_rx/models/drug_generic/drug_generic_model.dart';
import 'package:dims_vet_rx/utilities/helpers.dart';

import '../../../utilities/app_strings.dart';
import '../../utilities/default_value.dart';
import '../create_prescription_screen/create_prescription_components/drug_brand/components/related_defualt_data_modal.dart';
import 'add_new_compan_and_list.dart';
import 'add_new_generic_and_list.dart';

Widget brandScreen(context){
  final DrugBrandController controller = Get.put(DrugBrandController());
  final SyncController syncServerToDB = Get.put(SyncController());

  return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
      Obx((){
        if (kDebugMode) {
          print(controller.isLoading);
        }
        return Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 5,
                  children: [
                    SizedBox(
                        child: Text(ScreenTitle.DrugBrand, style: TextStyle(fontSize: 20,color: Colors.black54),)),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: controller.searchController,
                        decoration:   InputDecoration(
                          hintText: 'Search..',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: controller.searchController.text.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.cancel_outlined),
                            onPressed: () {
                              controller.clearText();
                            },
                          ) : null,
                        ),
                        onChanged: (value)async{
                          await controller.getAllData(value);
                        },
                      ),
                    ),

                    Wrap(
                      spacing: 10,
                      runSpacing: 5,
                      children: [
                      FilledButton(onPressed: ()async{
                        syncServerToDB.isBrandSync.value = true;
                        await syncServerToDB.companyMethod(context);
                        await syncServerToDB.genericMethod(context);
                        await syncServerToDB.brandMethod(context);
                        controller.getAllData('');
                        syncServerToDB.isBrandSync.value = false;
                        Helpers.successSnackBar("Success", "Data Synced Successfully");
                      }, child: Wrap(
                        children: [
                          if(syncServerToDB.isBrandSync.value == false)
                            Icon(Icons.sync_outlined),
                          if(syncServerToDB.isBrandSync.value == true)
                            CircularProgressIndicator(color: Colors.white,),
                          SizedBox(width: 10,),
                          Text("Brand Update"),
                        ],
                      )),
                      ElevatedButton(onPressed: (){
                        controller.clearText();
                        // newAddAndUpdateDialog(context, 0, controller);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> dropDownSearch(isShowAppBar: true)));
                      }, child: const Text("Create New")),
                    ],)
                  ],
                ),
              ),
            ),
            controller.isLoading.value ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 158.0),
              child: Center(child: CircularProgressIndicator(),),
            )
                : controller.dataList.length > 0 ? _dataLis(context, controller)
                :  const Padding(
              padding: EdgeInsets.symmetric(vertical: 158.0),
              child: Center(child: Column(
                children: [
                  Icon(Icons.hourglass_empty, size: 80,),
                  Text("Data Not Found"),
                ],
              ),),
            )
          ],
        );
      })
  );
}

Widget _dataLis(context, controller){
  final FavoriteIndexController favoriteIndexController = Get.put(FavoriteIndexController());
  const favoriteSegmentName = FavSegment.brand;
  final PrescriptionController prescriptionController  = Get.put(PrescriptionController());
  final DrugGenericController drugGenericController = Get.put(DrugGenericController());
  return  Expanded(
    child: Obx(() {
      return ListView.builder(
        itemCount: controller.dataList.length,
        itemBuilder: (context, index) {
          var item = controller.dataList[index];
          var favoriteIndex = controller.dataList[index].id;
          var genericId = controller.dataList[index].generic_id;
          var favoriteId = favoriteIndexController.favoriteIndexDataList.firstWhere((element) => element.favorite_id == favoriteIndex && element.u_status !=2 && element.segment ==favoriteSegmentName, orElse: () => null,);
          var generic = drugGenericController.box.values.toList().firstWhere((element) => element.id == genericId, orElse: () => DrugGenericModel(id: 0, generic_name: ""),);

          if(item != null && item.u_status !=3) {
           return  Padding(
             padding: const EdgeInsets.all(5.0),
             child: ListTile(
                title: Wrap(
                  children: [
                    Text(item.brand_name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: Colors.green),),
                    const SizedBox(width: 10,),
                    Text(item.form),
                    const SizedBox(width: 10,),
                    Text(item.strength),
                    const SizedBox(width: 10,),
                  ],
                ),
                subtitle: Text(generic.generic_name.toString().isNotEmpty ? generic.generic_name : 'Not Found',),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     if(item.uuid !=null && item.uuid.toString().isNotEmpty)
                    // IconButton(onPressed: (){
                    //    controller.nameController.text = item.brand_name;
                    //    // newAddAndUpdateModal(context, item.id, controller);
                    //    newAddAndUpdateDialog(context, item.id, controller);
                    //  }, icon: const Icon(Icons.edit)),
                     IconButton(onPressed: (){
                       controller.deleteData(item.id);
                     }, icon: const Icon(Icons.delete)),
                  ]
                ),
               leading: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     IconButton(
                         tooltip: "Set default dose duration instruction",
                         onPressed: (){
                       brandDefaultModel(context, item.id);
                     }, icon: Icon(Icons.info_outline)),
                     if(favoriteSegmentName.toString().isNotEmpty)
                       favoriteId ==null
                           ?
                       IconButton(onPressed: ()async{
                         favoriteIndexController.addData(favoriteIndexController.favoriteIndexDataList.length + 1,FavSegment.brand, favoriteIndex );
                         //
                         // controller.getAllData('');
                         // prescriptionController.getAllBrandData('');
                         controller.dataList.refresh();
                         favoriteIndexController.getAllData('');
                       }, icon: const Icon(Icons.star_border))
                           :
                       IconButton(onPressed: ()async{
                         favoriteIndexController.updateData(favoriteId.id,FavSegment.brand, favoriteIndex );
                         // controller.getAllData('');
                         // prescriptionController.getAllBrandData('');
                         controller.dataList.refresh();
                         favoriteIndexController.getAllData('');
                       }, icon:   Icon(Icons.star, color: Colors.blue,)),
                     const SizedBox(width: 10,),
                   ]
               ),
               tileColor: Colors.grey[200],
              ),
           );

          }
          return Container();
        },
      );
    }),
  );
}

Future  newAddAndUpdateDialog(context, id,  controller) async {


  Get.defaultDialog(
    title: id == 0 ? "Create New" : "Update",
    textConfirm: id == 0 ? "Add" : "Update",
    onConfirm: () async {
      final idNewData = controller.dataList.length + 1;
      id == 0 ? (await controller.addData(idNewData)) : controller.updateData(id);
      Navigator.pop(context);
    },
    textCancel: "Cancel",
    barrierDismissible: false,
    content: SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: controller.nameController,
            decoration: const InputDecoration(
              hintText: "Enter brand name",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),
          SizedBox(height: 20),


        ],
      )),

  );
}


class dropDownSearch extends StatefulWidget {
  final bool isShowAppBar;
  const dropDownSearch({super.key, required this.isShowAppBar} );

  @override
  State<dropDownSearch> createState() => _dropDownSearchState();
}

class _dropDownSearchState extends State<dropDownSearch> {



  final TextEditingController textEditingController = TextEditingController();
  String selectedCompany ="";
  String selectedGeneric ="";

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
  final CompanyNameController companyController = Get.put(CompanyNameController());
  final DrugGenericController genericController = Get.put(DrugGenericController());
  final DrugBrandController drugBrandController = Get.put(DrugBrandController());


  @override
  Widget build(BuildContext context) {
    final companyDataList = companyController.dataList;
    final genericDataList = genericController.dataList;
    return Scaffold(
      appBar: widget.isShowAppBar ? AppBar(title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Add new brand"),
          IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.clear))
        ],
      ), centerTitle: true,) : null,
      body: Card(
        color: Colors.blue,
        child: Center(
          child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                child: SizedBox(
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child:  TextField(
                      controller: drugBrandController.nameController,
                      decoration: const InputDecoration(
                        label: Text("Write brand name"),
                        contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                ),
              ),

                Card(
                child: SizedBox(
                  width: 400,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: drugBrandController.strengthController,
                      decoration: const InputDecoration(
                        label: Text("Write strength"),
                        contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                ),
              ),
                Card(
                child: SizedBox(
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: drugBrandController.dosesFormController,
                      decoration: const InputDecoration(
                        label: Text("Write doses form"),
                        contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  width: 400,
                  child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<dynamic>(
                          isExpanded: true,
                          hint:  Text(selectedGeneric.isEmpty ? "Select generic" : selectedGeneric.toString(), style: const TextStyle(fontSize: 14,),),
                          items: genericDataList.map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item.generic_name, style: const TextStyle(fontSize: 14,),
                            ),
                          )).toList(),
                          onChanged: (value) {
                             var data ={
                               "id": value.id,
                               "generic_name": value.generic_name,
                             };

                             drugBrandController.selectedGeneric.clear();
                             drugBrandController.selectedGeneric.addAll(data);
                            setState(() {
                              selectedGeneric = value.generic_name;
                            });

                          },
                          buttonStyleData: const ButtonStyleData(padding: EdgeInsets.symmetric(horizontal: 16), height: 40, width: 200,),
                          dropdownStyleData:  const DropdownStyleData(maxHeight: 200,),
                          menuItemStyleData: const MenuItemStyleData(height: 40,),
                          dropdownSearchData: DropdownSearchData(
                            searchController: textEditingController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8,),
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                controller: textEditingController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8,),
                                  hintText: 'Search...',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (dataList, searchValue) {
                              return dataList.value.generic_name.toString().toLowerCase().contains(searchValue.toLowerCase());
                            },
                          ),
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              textEditingController.clear();
                            }
                          },
                        ),
                      ),
                      IconButton(onPressed: (){
                        newAddAndUpdateGenericDialog(context, 0, genericController);
                      }, icon: Icon(Icons.add_circle))
                    ],
                  ),
                ),
              ),
              Card(
                child: SizedBox(
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<dynamic>(
                          isExpanded: true,
                          hint:  Text(selectedCompany.isEmpty ? "Select company" : selectedCompany.toString(), style: const TextStyle(fontSize: 14,),
                          ),
                          items: companyDataList.map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item.company_name, style: const TextStyle(fontSize: 14,),
                            ),
                          )).toList(),
                      
                          onChanged: (value) {
                             var data ={
                               "id": value.id,
                               "company_name": value.company_name,
                             };
                             drugBrandController.selectedCompany.clear();
                             drugBrandController.selectedCompany.addAll(data);
                            setState(() {
                              selectedCompany = value.company_name;
                            });
                      
                          },
                          buttonStyleData: const ButtonStyleData(padding: EdgeInsets.symmetric(horizontal: 16), height: 40, width: 200,),
                          dropdownStyleData:  const DropdownStyleData(maxHeight: 200,),
                          menuItemStyleData: const MenuItemStyleData(height: 40,),
                          dropdownSearchData: DropdownSearchData(
                            searchController: textEditingController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8,),
                              child: TextFormField(
                                expands: true,
                                maxLines: null,
                                controller: textEditingController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8,),
                                  hintText: 'Search...',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (dataList, searchValue) {
                              return dataList.value.company_name.toString().toLowerCase().contains(searchValue.toLowerCase());
                            },
                          ),
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              textEditingController.clear();
                            }
                          },
                        ),
                      ),
                      IconButton(onPressed: (){
                        newAddAndUpdateCompanyDialog(context, 0, companyController);
                      }, icon: Icon(Icons.add_circle))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
                SizedBox(
                    width: 400,
                    child: FilledButton(onPressed: (){
                      var id = drugBrandController.dataList.length + 1;
                      drugBrandController.addData(id);
                    }, child: const Text("Save"))),

            ],

          )),
        ),
      ),
    );
  }
}


