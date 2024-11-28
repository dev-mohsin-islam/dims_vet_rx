





import 'dart:convert';

import 'package:dims_vet_rx/models/drug_brand/drug_brand_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../database/crud_operations/brand_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../utilities/default_value.dart';
import '../../utilities/helpers.dart';
import '../company_name/company_name_controller.dart';
import '../drug_generic/drug_generic_controller.dart';

class DrugBrandController extends GetxController{
  final CompanyNameController companyNameController = Get.put(CompanyNameController());
  final DrugGenericController genericController = Get.put(DrugGenericController());
  final BrandCrudController brandCrudController = BrandCrudController();
  final Box boxDefaultDoseDuration = Boxes.getDefaultDoseDurationInstruction();
  final Box<DrugBrandModel>box = Boxes.getDrugBrand();
  final RxList dataList =  [].obs;
  final TextEditingController searchController= TextEditingController();


  final TextEditingController nameController= TextEditingController();
  final TextEditingController strengthController= TextEditingController();
  final TextEditingController dosesFormController= TextEditingController();
  RxMap selectedGeneric= {}.obs;
  RxMap selectedCompany= {}.obs;


  RxBool isLoading = true.obs;

  final uuid = DefaultValues.defaultUuid;
  final date = DefaultValues.defaultDate;
  final web_id = DefaultValues.defaultweb_id;
  final statusNewAdd = DefaultValues.NewAdd;
  final statusUpdate = DefaultValues.Update;
  final statusDelete = DefaultValues.Delete;


  void addData(id)async{

   try{
    if(nameController.text.trim().isNotEmpty){
      var response = await brandCrudController.saveBrand(box, DrugBrandModel(id: 0, brand_name: nameController.text.trim(), uuid: uuid, date: date, web_id: web_id, u_status: statusNewAdd, generic_id: selectedGeneric['id'], company_id: selectedCompany['id'], form: dosesFormController.text.trim(), strength: strengthController.text.trim()));
      if(response){
        Helpers.successSnackBar("Success!", "Added successfully");
        Navigator.pop(Get.context!);
      }
      await getAllData('');
    }
   }catch(e){
     print(e);
   }
    // isLoading.value = false;
  }

  Future<void> updateData(id)async{
    try {
      if(nameController.text.trim().isNotEmpty){
        await brandCrudController.updateBrand(box, id, nameController.text.trim(), statusUpdate);
        nameController.clear();
        await getAllData('');
      }
    }catch(e){
      print(e);
    }
    // isLoading.value = false;

  }

  Future<void> deleteData(id)async{

    try {
      await brandCrudController.deleteCommon(box, id, statusDelete);
      getAllData('');
    } catch (e) {
      // Handle the exception
      if (kDebugMode) {
        print("Error deleting data: $e");
      }
    }
    // isLoading = false;
  }

  Future<void> getAllData(String searchText)async {
    var response = await brandCrudController.getAllDataBrand(box, searchText);
    if(response !=null){
      isLoading.value = false;
      dataList.clear();
      dataList.addAll(response);
    }

  }

  Future<void> insertDefaultDrugDoseDuration(brandId,Dose,Duration,Instruction,Notes)async{

    try{
      var mapData = {
        "brand_id": brandId,
        "dose": Dose,
        "duration": Duration,
        "instruction": Instruction,
        "notes": Notes
      };
      var json = jsonEncode(mapData);
      final jsonMap = jsonDecode(json) as Map<String, dynamic>;
      var response = await boxDefaultDoseDuration.put('$brandId', jsonMap);
    }catch(e){
      print(e);
    }
  }
  getDefaultDrugDoseDuration(brandId)async{
   try{
     var response = await boxDefaultDoseDuration.get('$brandId');
     return response;
   }catch(e){
     print(e);
   }
  }

  clearText()async{
    dataList.clear();
    nameController.clear();
    searchController.clear();
    await getAllData('');
  }







  @override
  void onInit() {
    // TODO: implement onInit

    getAllData('');
    super.onInit();
  }

  @override
  void dispose() {
    getAllData('');
    dataList;
    nameController.dispose();
    searchController.dispose();
    uuid;
    date;
    web_id;
    statusNewAdd;
    statusUpdate;
    statusDelete;
    super.dispose();
  }

}



