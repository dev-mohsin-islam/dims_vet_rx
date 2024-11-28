

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:dims_vet_rx/models/company_name/company_name_model.dart';
import 'package:dims_vet_rx/models/create_prescription/prescription_drug/prescription_drug_model.dart';
import 'package:dims_vet_rx/models/drug_brand/drug_brand_model.dart';
import 'package:dims_vet_rx/models/drug_generic/drug_generic_model.dart';

import '../../database/hive_get_boxes.dart';
import '../../models/create_prescription/prescription/prescription_model.dart';
import '../../models/create_prescription/prescription_drug_dose/prescription_drug_dose_model.dart';

class BrandReportController extends GetxController {
  final Box<PrescriptionDrugModel> boxPresDrug = Boxes.getPrescriptionDrug();
  final Box<PrescriptionDrugDoseModel> boxPresDrugDose = Boxes.getPrescriptionDrugDose();
  final Box<CompanyNameModel> boxCompany = Boxes.getCompanyName();
  final Box<DrugGenericModel> boxGeneric = Boxes.getDrugGeneric();
  final Box<DrugBrandModel> boxDrugBrand = Boxes.getDrugBrand();
  final Box<PrescriptionModel> boxPrescription = Boxes.getPrescription();
  TextEditingController searchText = TextEditingController();
  RxList branReport = [].obs;
  RxList branReportForDoc = [].obs;
  RxList companyList = [].obs;
  RxList brandReportAllCompany = [].obs;

  RxString selectedItem = 'Today'.obs;
  final RxList<String> items = ['Today', 'Option 1', 'Option 2', 'Option 3'].obs;

  getCompany(searchText)async{
   try{
     if(searchText.isEmpty){
       var resAll =await boxCompany.values.toList().obs;
       companyList.clear();
       if(resAll.isNotEmpty){
         companyList.addAll(resAll);
       }
     }
     if(searchText.isNotEmpty){
       var resSingle =await boxCompany.values.where((element) => element.company_name.toLowerCase().contains(searchText.toLowerCase())).toList().obs;
       companyList.clear();
       if(resSingle.isNotEmpty){
         companyList.addAll(resSingle);
         return resSingle;
       }
     }
   }catch(e){
     print("Error in getCompany: $e");
   }
  }

  getBrandReport(company_id)async{
     var brandList =[];
     brandList.clear();
    try{
      if(company_id != null){
        branReport.clear();
        var resCompany =await boxCompany.values.firstWhere((element) => element.id == company_id);
        var resDrugs =await boxPresDrug.values.where((element) => element.company_id == company_id).toList();
        if(resDrugs.isNotEmpty){
          for(var resDrugs in resDrugs){
            List multiDoses = [];
            var resGeneric =await boxGeneric.values.firstWhere((element) => element.id == resDrugs.generic_id);
            var resPrescription =await boxPrescription.values.firstWhere((element) => element.id == resDrugs.prescription_id);
            var resDrugBrand = await boxDrugBrand.values.firstWhere((element) => element.id == resDrugs.brand_id);
            brandList.add(resDrugBrand);
            var resDrugDoses =await boxPresDrugDose.values.where((element) => element.drug_id == resDrugs.id).toList();
            if(resDrugDoses.isNotEmpty){
              multiDoses.clear();
              for(var resDrugDose in resDrugDoses){
                multiDoses.add(resDrugDose);
              }

            }
            branReport.add({
              "drug":resDrugs,
              "brandInfo":resDrugBrand,
              "company":resCompany,
              "generic":resGeneric,
              "doses":multiDoses,
              "prescriptionInfo":resPrescription,
            });
          }

        }

      }
    }catch(e){
      print("Error in getBrandReport: $e");
    }

    if(brandList.isNotEmpty){
      getBrandReportForDoctor(brandList);
    }
  }

  Future<void>getBrandReportAll()async{



    var companyList = await boxCompany.values.toList().obs;
    brandReportAllCompany = [].obs;
     brandReportAllCompany.clear();
    try{
      if(companyList.isNotEmpty){

       for(var company in companyList){
         Map<String, List> groupingBrand = {};

         var brandList =[];
         brandList.clear();
         var resCompany =await boxCompany.values.firstWhere((element) => element.id == company.id);
         var resDrugs =await boxPresDrug.values.where((element) => element.company_id == company.id).toList();
         if(resDrugs.isNotEmpty){
           for(var resDrug in resDrugs){
             List multiDoses = [];
             var resGeneric =await boxGeneric.values.firstWhere((element) => element.id == resDrug.generic_id);
             var resPrescription =await boxPrescription.values.firstWhere((element) => element.id == resDrug.prescription_id);
             var resDrugBrand = await boxDrugBrand.values.firstWhere((element) => element.id == resDrug.brand_id);
             brandList.add(resDrugBrand);
             var resDrugDoses =await boxPresDrugDose.values.where((element) => element.drug_id == resDrug.id).toList();
             if(resDrugDoses.isNotEmpty){
               multiDoses.clear();
               for(var resDrugDose in resDrugDoses){
                 multiDoses.add(resDrugDose);
               }
             }
             brandReportAllCompany.add({
               "drug":resDrugs,
               "brandInfo":resDrugBrand,
               "company":resCompany,
               "generic":resGeneric,
               "doses":multiDoses,
               "prescriptionInfo":resPrescription,
             });
           }

         }

         for (var brand in brandList) {
           if (!groupingBrand.containsKey(brand.brand_id)) {
             groupingBrand[brand.brand_id] = [];
           }
           groupingBrand[brand.brand_id]!.add(brand);
         }
       }


      }
    }catch(e){
      print("Error in getBrandReport: $e");
    }

  }



  getBrandReportForDoctor(brandList)async{
    try{
      var similarBrandList = {};

      for(var brands in brandList){
        final brandId = brands.id;
        if(!similarBrandList.containsKey(brandId)){
          similarBrandList[brandId] = [];
        }
        similarBrandList[brandId].add(brands);
      }

      similarBrandList.forEach((key, value) {
         var brandId = key;
         var numberOfSimilarBrand = value.length;
         var brandName = value[0].brand_name;


      });

      branReportForDoc.clear();
      branReportForDoc.addAll(similarBrandList.values.toList());


    }catch(e){
      print("Error in getBrandReport: $e");
    }

  }

  Future<void>initialCall()async{

  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    boxPresDrug;
    boxPresDrugDose;
    boxCompany;
    boxGeneric;
    boxDrugBrand;
    boxPrescription;
    searchText;
    branReport;
    branReportForDoc;
    companyList;
    super.dispose();
  }

}