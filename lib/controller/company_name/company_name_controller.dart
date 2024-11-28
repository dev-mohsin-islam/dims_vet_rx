







import 'package:dims_vet_rx/models/company_name/company_name_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../database/crud_operations/company_crud.dart';
import '../../database/hive_get_boxes.dart';
import '../../utilities/default_value.dart';

class CompanyNameController extends GetxController{
  final CompanyCrudController companyCrudController = CompanyCrudController();
  final Box<CompanyNameModel> box = Boxes.getCompanyName();
  final TextEditingController nameController= TextEditingController();
  final TextEditingController searchController= TextEditingController();

  final RxList dataList =  [].obs;

  RxBool isLoading = true.obs;
  RxBool isSearch = false.obs;

  final uuid = DefaultValues.defaultUuid;
  final date = DefaultValues.defaultDate;
  final web_id = DefaultValues.defaultweb_id;
  final statusNewAdd = DefaultValues.NewAdd;
  final statusUpdate = DefaultValues.Update;
  final statusDelete = DefaultValues.Delete;


  void addData(id)async{
    if(nameController.text.trim().isNotEmpty){
      await companyCrudController.saveCompany(box, CompanyNameModel(id: id, company_name: nameController.text.trim(), uuid: uuid, date: date, web_id: web_id, u_status: statusNewAdd,));
      nameController.clear();
      await getAllData('');
    }

    // isLoading.value = false;
  }

  Future<void> updateData(id)async{
    if(nameController.text.trim().isNotEmpty){
      await companyCrudController.updateCompany(box, id, nameController.text.trim(), statusUpdate);
      nameController.clear();
      await getAllData('');
    }

    // isLoading.value = false;

  }

  Future<void> deleteData(id)async{

    try {
      if(id != null && id !=-1) {
        await companyCrudController.deleteCommon(box, id, statusDelete);
        await getAllData('');
      }

    } catch (e) {
      // Handle the exception
      if (kDebugMode) {
        print("Error deleting data: $e");
      }
    }
    // isLoading = false;
  }

  Future<void> getAllData(String searchText)async{
      print(searchText);
    try {
      isLoading.value = true;
      var response = await companyCrudController.getAllDataCompany(box,  searchText);
      dataList.clear();
      dataList.addAll(response);
      dataList.sort((a, b) => a.company_name[0].compareTo(b.company_name[0]));
      isLoading.value = false;
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
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
    companyCrudController;
    box;
    nameController.dispose();
    searchController.dispose();
    dataList;
    super.dispose();
  }

}



